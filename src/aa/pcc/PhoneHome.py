import time
import json
import ast
import math
import re

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy

from aa.common.Utils import banner, trace, pretty_print, cmp_json, midtext
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase
from aa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60 * 10


class PhoneHome(AaBase):
    def __init__(self):
        self.container = None
        self.host_ip = None
        self.config_file = None
        self.user = "pcc"
        self.password = "cals0ft"
        self.setup_username = None
        self.tar_file_type = None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.PhoneHome Update Config File")
    ###########################################################################
    def update_config_file(self, *arg, **kwargs):
        banner("PCC.PhoneHome Update Config File")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))
        trace("Kwargs:" + str(kwargs))
        cmd = "sudo /home/pcc/platina-cli-ws/platina-cli support config --configPath /home/pcc/{}".format(self.config_file)
        trace("Command:{}".format(str(cmd)))
        cmd_execution = cli_run(self.host_ip, self.user, self.password, cmd)
        trace("cmd_execution: {}".format(cmd_execution))
        if re.search("FAIL", str(cmd_execution)):
            return "Error"
        else:
            return "OK"

    ###########################################################################
    @keyword(name="PCC.PhoneHome Verify Application.yml File")
    ###########################################################################
    def verify_application_file(self, *arg, **kwargs):
        banner("PCC.PhoneHome Verify Application.yml File")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))
        trace("Kwargs:" + str(kwargs))
        if self.config_file == "config_without_ssl.json":
            docker_cmd = "sudo docker cp phone-home:/home/conf/application.yml /home/pcc/."
            application_cmd = "cat /home/pcc/application.yml"
            docker_cmd_run = cli_run(self.host_ip, self.user, self.password, docker_cmd)
            application_cmd_output = cli_run(self.host_ip, self.user, self.password, application_cmd)
            
            trace("docker_cmd_run:{}".format(docker_cmd_run))
            trace("application_cmd_output:{}".format(application_cmd_output))
            validation_status = []
            validation_list = ['collectionenabled: true', 'submitenabled: true', 'dailysubmission: true',
                               'platinadestination: true', 'https: false','jobCleanupAge: 0',
                               'httpsSkipVerify: true', 'destinationHost: "{}"'.format(self.host_ip), 'destinationPort: 9001',
                               'destinationBucket: phone-home']
            for i in validation_list:
                trace("================ Value of i is :{} =============".format(i))
                validation_status.append(re.search(i, str(application_cmd_output)))

            if len(validation_status) > 0 and all(elem == True for elem in validation_status):
                return "OK"
            else:
                return "Error:validation failed-{}".format(validation_status)

        elif self.config_file == "config_with_ssl.json":
            docker_cmd = "sudo docker cp phone-home:/home/conf/application.yml /home/pcc/."
            application_cmd = "cat /home/pcc/application.yml"
            docker_cmd_run = cli_run(self.host_ip, self.user, self.password, docker_cmd)
            application_cmd_output = cli_run(self.host_ip, self.user, self.password, application_cmd)
            trace("docker_cmd_run:{}".format(docker_cmd_run))
            trace("application_cmd_output:{}".format(application_cmd_output))
            validation_status = []
            validation_list = ['collectionenabled: true', 'submitenabled: true', 'dailysubmission: true',
                               'platinadestination: false', 'https: true', 'jobCleanupAge: 0',
                               'httpsSkipVerify: true', 'destinationHost: "{}"'.format(self.host_ip), 'destinationPort: 9001',
                               'destinationBucket: phone-home']
            for i in validation_list:
                validation_status.append(re.search(i, str(application_cmd_output)))

            if len(validation_status) > 0 and all(elem == True for elem in validation_status):
                return "OK"
            else:
                return "Error:validation failed-{}".format(validation_status)
        else:
            return "Invalid config file"

    ###########################################################################
    @keyword(name="PCC.PhoneHome Verify Data Push")
    ###########################################################################
    def verify_data_push(self, *arg, **kwargs):
        banner("PCC.PhoneHome Verify Data Push")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))
        trace("Kwargs:" + str(kwargs))
        cmd = "sudo /home/pcc/platina-cli-ws/platina-cli support data-push"
        trace("Command:{}".format(str(cmd)))
        cmd_execution = cli_run(self.host_ip, self.user, self.password, cmd)
        trace("Command executed successfully")
        if re.search("FAIL", str(cmd_execution)):
            return "Error"
        else:
            return "OK"

    ###########################################################################
    @keyword(name="PCC.Wait Until Phone Home Job Is Finished")
    ###########################################################################
    def wait_until_phone_home_job_is_finished(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        trace("Kwargs:" + str(kwargs))
        banner("PCC.Wait Until Phone Home Job Is Finished")
        PCCSERVER_TIMEOUT = 60 * 60  # 60 minutes timeout
        timeout = time.time() + PCCSERVER_TIMEOUT
        cmd = "sudo /home/pcc/platina-cli-ws/platina-cli support jobs"
        finished = False
        while not finished:
            cmd_output = cli_run(self.host_ip, self.user, self.password, cmd)
            trace("cmd_output: {}".format(cmd_output))
            serialised_output = str(cmd_output['Result']['stdout']).replace('\n', '').strip()
            if time.time() > timeout:
                return "Timeout: Still in collecting state"
            if re.search("collecting", serialised_output) or re.search("processing", serialised_output):
                time.sleep(30)
                trace("Still collecting/processing phone home data... Please wait")
                continue
            if re.search("end", serialised_output) and ("collecting" not in serialised_output) and (
                    "processing" not in serialised_output):
                trace("Finished Phone home job")
                return "OK"
            if re.search("error", serialised_output):
                trace("Error: Phone Home Job Failed")
                return "Error: Phone Home Job Failed"

            else:
                return "Error: Phone Home Job Failed"

    ###########################################################################
    @keyword(name="PCC.PhoneHome Verify Success Logs In Container")
    ###########################################################################
    def verify_success_log_in_container(self, *arg, **kwargs):
        banner("PCC.PhoneHome Verify Success Logs In Container")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))
        trace("Kwargs:" + str(kwargs))
        date_cmd = cli_run(self.host_ip, self.user, self.password, "date +%Y-%m-%d")
        trace("date_cmd output is: {}".format(date_cmd))
        date_cmd_op = self._serialize_response(time.time(), date_cmd)
        trace("Serialised date_cmd_op: {}".format(date_cmd_op))
        docker_cp_cmd = "sudo docker cp phone-home:home/logs/default.log /home/pcc/"
        docker_cp_cmd_output = cli_run(self.host_ip, self.user, self.password, docker_cp_cmd)
        default_log_success_check = 'sudo cat /home/pcc/default.log |grep "Successfully uploaded"| grep "{}"|wc -l'.format(date_cmd_op)
        trace("default_log_success_check: {}".format(default_log_success_check))
        default_log_success_output = cli_run(self.host_ip, self.user, self.password, default_log_success_check)
        default_log_serialize_output = self._serialize_response(time.time(), default_log_success_output)
        trace("default_log_serialize_output:{}".format(default_log_serialize_output))
        if int(default_log_serialize_output) == 1:
            return "OK"
        else:
            return "Error: Phone home default success log verification failed"

    ###########################################################################
    @keyword(name="PCC.PhoneHome Fetch Tar File Details")
    ###########################################################################
    def fetch_tar_file_detail(self, *arg, **kwargs):
        banner("PCC.PhoneHome Fetch Tar File Details")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))
        trace("Kwargs:" + str(kwargs))
        date_cmd = cli_run(self.host_ip, self.user, self.password, "date +%Y-%m-%d")
        date_cmd_op = self._serialize_response(time.time(), date_cmd)
        manual_tar_file_command = 'sudo cat /home/pcc/default.log |grep "Successfully uploaded"|grep "manual"|grep "{}"'.format(date_cmd_op)
        manual_tar_file_command_output = cli_run(self.host_ip, self.user, self.password, manual_tar_file_command)
        manual_tar_file_serialize_output = self._serialize_response(time.time(), manual_tar_file_command_output)
        manual_tar_file = midtext('"', "(", manual_tar_file_serialize_output)
        #####  Road_Runner/30862a4df11a/2021-02-23-10.09.36.726335-utc-manual.tar.xz". Size: 228.41 MiB

        split_manual_tar_file = manual_tar_file.split(" ")
        manual_tar = {}
        manual_tar['name'] = split_manual_tar_file[0].replace('".', '')
        manual_tar['tar_file_without_user'] = split_manual_tar_file[0].replace('".', '').replace(self.setup_username,"")
        manual_tar['size'] = float(split_manual_tar_file[2])

        daily_tar_file_command = 'sudo cat /home/pcc/default.log |grep "Successfully uploaded"|grep "daily"|grep "{}"'.format(date_cmd_op)
        daily_tar_file_command_output = cli_run(self.host_ip, self.user, self.password, daily_tar_file_command)
        daily_tar_file_serialize_output = self._serialize_response(time.time(), daily_tar_file_command_output)
        daily_tar_file = midtext('"', "(", daily_tar_file_serialize_output)

        ######## Road_Runner/30862a4df11a/2021-02-23-16.30.00.427008-utc-daily.tar.xz". Size: 96.11 MiB

        split_daily_tar_file = daily_tar_file.split(" ")
        daily_tar = {}
        daily_tar['name'] = split_daily_tar_file[0].replace('".', '')
        daily_tar['tar_file_without_user'] = split_daily_tar_file[0].replace('".', '').replace(self.setup_username,"")
        daily_tar['size'] = float(split_daily_tar_file[2])
        return manual_tar,daily_tar

    ###########################################################################
    @keyword(name="PCC.PhoneHome Verify Tar File Size")
    ###########################################################################
    def verify_tar_file_size(self, *arg, **kwargs):
        banner("PCC.PhoneHome Verify Tar File Size")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))
        try:
            if self.tar_file_type == "daily":
                tar_file_size = self.fetch_tar_file_detail(**kwargs)[1]['size']
                trace("tar_file_size :{}".format(tar_file_size))
                if tar_file_size>100:
                    return "Daily tar file size is greater than 100 MB"
                else:
                    return "OK"

            if self.tar_file_type == "manual":
                tar_file_size = self.fetch_tar_file_detail(**kwargs)[0]['size']
                trace("tar_file_size:{}".format(tar_file_size))
                if tar_file_size>500:
                    return "Manual tar file size is greater than 100 MB"
                else:
                    return "OK"

            else:
                return "Error: Please provide tar_file_type. For e.g.- daily or manual"
        except Exception as e:
            return "Exception encountered in verify_tar_file_size : {}".format(e)

    ###########################################################################
    @keyword(name="PCC.PhoneHome Untar File")
    ###########################################################################
    def untar_file(self, *arg, **kwargs):
        banner("PCC.PhoneHome Untar File")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))
        try:

            tar_file_name = self.fetch_tar_file_detail(**kwargs)[0]['name']
            cmd1 = "sudo mkdir /home/pcc/platina-cli-ws/phone-home/without_ssl"
            cmd2 = "sudo tar -C /home/pcc/platina-cli-ws/phone-home/without_ssl -xvf /home/pcc/storage-s3/minio/volume/data/phone-home/{}".format(tar_file_name)
            create_folder = cli_run(self.host_ip, self.user, self.password, cmd1)
            untar_file = cli_run(self.host_ip, self.user, self.password, cmd2)
            return "OK"
        except Exception as e:
            return "Exception occured in untar file:{}".format(e)

    ###########################################################################
    @keyword(name="PCC.PhoneHome Import PrivateKey On Platina-cli-ws For SSL")
    ###########################################################################
    def import_privatekey_for_ssl(self, *arg, **kwargs):
        banner("PCC.PhoneHome Import PrivateKey On Platina-cli-ws For SSL")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))
        try:

            cmd1 = "sudo cp /home/pcc/privatekey.asc /home/pcc/platina-cli-ws/"
            cmd2 = "sudo cat /home/pcc/passphrase.json | grep 'gpg' | awk '{print $2}'"
            copy_privatekey_on_platina_cli = cli_run(self.host_ip, self.user, self.password, cmd1)
            passphrase_gpg_key = cli_run(self.host_ip, self.user, self.password, cmd2)
            trace("passphrase_gpg_key: {}".format(passphrase_gpg_key))
            passphrase_gpg_key_output = self._serialize_response(time.time(), passphrase_gpg_key)

            cmd3 = "sudo gpg --pinentry-mode=loopback --passphrase {} --import /home/pcc/platina-cli-ws/privatekey.asc".format(passphrase_gpg_key_output)
            gpg_import_private_key = cli_run(self.host_ip, self.user, self.password, cmd3)

            cmd4 = "sudo gpg --list-secret-keys | grep Key"
            verify_setup_username = cli_run(self.host_ip, self.user, self.password, cmd4)

            if self.setup_username in verify_setup_username:
                return "OK"
            else:
                return "Error : {} not found in GPG secret key list".format(self.setup_username)

        except Exception as e:
            return "Exception occured in import privatekey for SSL:{}".format(e)


    ###########################################################################
    @keyword(name="PCC.PhoneHome Decrypt Files")
    ###########################################################################
    def decrypt_files(self, *arg, **kwargs):
        banner("PCC.PhoneHome Decrypt Files")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))

        try:
            tar_file_name = self.fetch_tar_file_detail(**kwargs)[0]['name']
            cmd1 = "sudo mkdir /home/pcc/platina-cli-ws/phone-home/with_ssl"
            cmd2 = "sudo gpg --output /home/pcc/platina-cli-ws/phone-home/with_ssl/manual_untar_file.tar.xz --decrypt /home/pcc/storage-s3/minio/volume/data/phone-home/{}".format(tar_file_name)
            create_with_ssl_folder = cli_run(self.host_ip, self.user, self.password, cmd1)
            decrypt_manual_tar_file = cli_run(self.host_ip, self.user, self.password, cmd2)
            return "OK"
        except Exception as e:
            return "Exception occured in decrypt file"

    ###########################################################################
    @keyword(name="PCC.PhoneHome Validation of Logs")
    ###########################################################################
    def phone_home_log_validation(self, *arg, **kwargs):
        banner("PCC.PhoneHome Validation of Logs")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))

        try:
            cmd1 = 'sudo find /home/pcc/platina-cli-ws/phone-home/with_ssl/ -type f -name "*.log"'
            list_all_log_files = cli_run(self.host_ip, self.user, self.password, cmd1)
            list_all_log_files = str(self._serialize_response(time.time(), list_all_log_files)).replace('/home/pcc/platina-cli-ws/phone-home/with_ssl/','')

            validation_checks = ['mailer/logs/detailed.log','mailer/logs/default.log','security/home/logs/detailed.log','security/home/logs/error.log','security/home/logs/default.log','platina-executor/logs/detailed.log','platina-executor/logs/error.log','platina-executor/logs/ansible.log','platina-executor/logs/default.log','monitor/home/logs/detailed.log','monitor/home/logs/error.log','monitor/home/logs/default.log','user-management/home/logs/detailed.log','user-management/home/logs/error.log','user-management/home/logs/default.log','pccserver/logs/detailed.log','pccserver/logs/error.log','pccserver/logs/default.log','gateway/home/logs/detailed.log','gateway/home/logs/error.log','gateway/home/logs/default.log','key-manager/home/logs/detailed.log','key-manager/home/logs/error.log','key-manager/home/logs/default.log','maas/logs/detailed.log','maas/logs/error.log','maas/logs/default.log','platina-monitor/logs/detailed.log','platina-monitor/logs/error.log','platina-monitor/logs/default.log','registry/home/logs/detailed.log','registry/home/logs/error.log','registry/home/logs/default.log']
            status=[]
            for validation in validation_checks:
                if re.search(str(validation), list_all_log_files):
                    status.append("OK")
                else:
                    status.append("{} not found".format(validation))
                    return "Phone home log validation failed: {} not found".format(validation)
            result = len(status) > 0 and all(elem == "OK" for elem in status)
            if result:
                return "OK"
            else:
                return "Result is :{}".format(result)

        except Exception as e:
            return "Exception occured in phone home logs validation: {}".format(e)


    ###########################################################################
    @keyword(name="PCC.PhoneHome Encypted Values Validation")
    ###########################################################################
    def phone_home_encypted_value_validation(self, *arg, **kwargs):
        banner("PCC.PhoneHome Encypted Values Validation")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))

        try:
            encrypted_values = ["plat1na","cals0ft","miniominio","aucta2018","BEGIN CERTIFICATE","BEGIN PRIVATE KEY","Bearer"]
            status = []
            for val in encrypted_values:
                cmd1 = 'sudo grep -rnw "/home/pcc/platina-cli-ws/phone-home/" -e "{}"| wc -l'.format(val)
                check_encypted_values = cli_run(self.host_ip, self.user, self.password, cmd1)
                check_encypted_values_serialize = int(self._serialize_response(time.time(), check_encypted_values))
                if check_encypted_values_serialize == 0:
                    status.append("OK")
                else:
                    status.append("Not Encypted:{}".format(val))

            result = len(status) > 0 and all(elem == "OK" for elem in status)
            if result:
                return "OK"
            else:
                return "Result is :{}".format(result)

        except Exception as e:
            return "Exception occured in phone home encypted value validation: {}".format(e)


