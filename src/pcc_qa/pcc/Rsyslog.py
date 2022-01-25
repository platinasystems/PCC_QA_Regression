import re
import os
import time
import ast
import datetime
from robot.api.deco import keyword
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run
from pcc_qa.pcc.Cli import Cli

PCC_TIMEOUT = 60*5  # 5 min

class Rsyslog(PccBase):
    """
    Rsyslog
    """
    def __init__(self):
        self.host_ip= None
        self.linux_user= "pcc"
        self.linux_password= "cals0ft"
        self.node_names=None
        self.host_ips= None
        self.rsys_tls = "no"
        self.rsys_server = None
        super().__init__()

    ###########################################################################
    @keyword(name="CLI.Validate Rsyslog from backend")
    ###########################################################################
    def validate_rsyslog_backend(self, *args, **kwargs):
        """
        Validate rsyslog from backend
        [Args]
            (str) host_ip: Host IP of the server
            (str) client names
        [Returns]
            (str) Response: Output of check repo list command
        """
        self._load_kwargs(kwargs)
        banner("CLI.Validate Rsyslog from backend")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        try:
            validation_status = []
            for node_name in ast.literal_eval(self.node_names):
                print("Node name: {}".format(node_name))
                date_cmd_op = self._serialize_response(time.time(), cli_run(self.host_ip,self.linux_user,self.linux_password,cmd="date"))
                output = str(date_cmd_op['Result']['stdout']).replace('\n', '').strip()
                current_date_day = output[4:5]
                current_date_month = output[7:9]
                current_date = current_date_month + " " + current_date_day
                #current_time = output[11:16]
                print("Current_date: {}".format(current_date))
                #print("Current_time: {}".format(current_time))

                cmd = '''sudo cat /var/log/messages|grep "{}"|grep "{}"|grep "{}"|wc -l'''.format(current_date,node_name)  
                print("============== cmd is : {} ==========".format(cmd))
                cmd_op=cli_run(self.host_ip,self.linux_user,self.linux_password,cmd)
                serialised_output = self._serialize_response(time.time(), cmd_op)
                output = str(serialised_output['Result']['stdout']).replace('\n', '').strip()
                print("command output is :{}".format(output))
                if int(output)>0:
                    print("I am here inside if")
                    validation_status.append("OK")
                else:
                    validation_status.append("{}: Failed".format(node_name))
            result = len(validation_status) > 0 and all(elem == "OK" for elem in validation_status)
            if result:
                return "OK"
            else:
                return "Error: while validation of Rsyslog. Validation_status is: {}".format(validation_status)
        except Exception as e:
            return "Exception encountered while Validating Rsyslog client {}".format(e)

    ###############################################################################################################
    @keyword(name="CLI.Restart Rsyslog service")
    ###############################################################################################################
    
    def restart_rsyslog_service(self, *args, **kwargs):
        banner("CLI.Restart Rsyslog service")
        self._load_kwargs(kwargs)
        print("Kwargs are: {}".format(kwargs))
        try:
            restart_status = []
            cmd1 = "sudo systemctl restart rsyslog"
            cmd2 = "sudo systemctl status rsyslog"
            for hostip in ast.literal_eval(self.host_ips):
                cmd1_op=cli_run(hostip,self.linux_user,self.linux_password,cmd1)
                print("cmd1: {}\n ====== Output is {} ========".format(cmd1, cmd1_op))
                
                time.sleep(10)

                cmd2_op= cli_run(hostip,self.linux_user,self.linux_password,cmd2)
                print("cmd2: {}\n ====== Output is {} ========".format(cmd2, cmd2_op))
                trace("cmd2: {}\n ====== Output is {} ========".format(cmd2, cmd2_op))
                if re.search("active \(running\)", str(cmd2_op)):
                    print("============================== Inside re search =====================")
                    restart_status.append("OK")
                else:
                    restart_status.append("Restart validation failed on {}".format(hostip))
            result = len(restart_status) > 0 and all(elem == "OK" for elem in restart_status)
            if result:
                return "OK"
            else:
                return "Error: while Rsyslog service restart. Restart status is: {}".format(restart_status)
        except Exception as e:
            return "Exception encountered while restarting Rsyslog client services {}".format(e)

    ###############################################################################################################
    @keyword(name="CLI.Cleanup logs created by Rsyslog")
    ###############################################################################################################

    def cleanup_logs_by_rsyslog(self, *args, **kwargs):
        banner("CLI.Cleanup logs created by Rsyslog")
        self._load_kwargs(kwargs)
        print("Kwargs are: {}".format(kwargs))
        try:
            cleanup_status = []
            cmd = "sudo dd if=/dev/null of=/var/log/messages"
            
            for hostip in ast.literal_eval(self.host_ips):
                cmd_op=cli_run(hostip,self.linux_user,self.linux_password,cmd)
                print("cmd: {}\n ====== Output is {} ========".format(cmd, cmd_op))
                if re.search("0\+0 records out",str(cmd_op)):
                    cleanup_status.append("OK")
                else:
                    cleanup_status.append("Rsyslog Cleanup failed on {}".format(hostip))
            
            trace("Cleanup status is: {}".format(cleanup_status))
            result = len(cleanup_status) > 0 and all(elem == "OK" for elem in cleanup_status)
            trace("Result is : {}".format(result))

            if result:
                return "OK"
            else:
                return "Error: while Rsyslog cleanup. Cleanup status is: {}".format(cleanup_status)
        except Exception as e:
            return "Exception encountered while Rsyslog cleanup: {}".format(e)

    ###########################################################################
    @keyword(name="CLI.Rsyslog Server Configuration")
    ###########################################################################
    def rsyslog_server_configuration(self,*args,**kwargs):
        banner("CLI.Rsyslog Server Configuration")
        self._load_kwargs(kwargs)
        trace("Kwargs are: " + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        if self.rsys_server:
            server_ip=easy.get_hostip_by_name(conn,self.rsys_server)
            print("Server Host Ip: "+str(server_ip))
            trace("Server Host Ip: "+str(server_ip))
        if self.rsys_tls.lower()=="yes":
            path=os.getcwd()+"/tests/test-data/rsyslog/tls"
            print("----------------Copying Rsyslog Config File For TLS----------------")
            trace("----------------Copying Rsyslog Config File For TLS----------------")
            changing_perm="sudo chmod 777 /etc"
            cmd_out = cli_run(server_ip, self.linux_user, self.linux_password, changing_perm)
            cmd_config="sshpass -p 'cals0ft' scp -o StrictHostKeyChecking=no {}/rsyslog.conf pcc@{}:/etc/".format(path,server_ip)
            print("Command for transferriddng rsyslog config file for TLS: "+str(cmd_config))
            trace("Command for transferring rsyslog config file for TLS: "+str(cmd_config))
            cmd_out = os.system(cmd_config)
            print("-----------Verifying if folder exist for server files-----------------")
            trace("-----------Verifying if folder exist for server files-----------------")
            cmd_dir="sudo test -d /etc/pki/tls/private && echo 'True' || echo 'False'"
            cmd_out=cli_run(server_ip,self.linux_user,self.linux_password,cmd_dir)
            print("----------------------------------------------------------------------")
            if re.search("False", str(cmd_out)):
                folder_cmd = "sudo mkdir -p /etc/pki/tls/private"
                cmd_out = cli_run(server_ip, self.linux_user, self.linux_password, folder_cmd)
                changing_perm="sudo chmod 777 /etc/pki/tls/private"
                cmd_out = cli_run(server_ip, self.linux_user, self.linux_password, changing_perm)
                print("-----------Copying server files-----------------")
                trace("-----------Copying server files-----------------")
                cmd_transfer = "sudo sshpass -p 'cals0ft' scp -o StrictHostKeyChecking=no {}/*.pem pcc@{}:/etc/pki/tls/private/.".format(path,server_ip)
                print("Command for transferring server files : "+str(cmd_transfer))
                trace("Command for transferring server files : "+str(cmd_transfer))
                cmd_out = cli_run(server_ip, self.linux_user, self.linux_password, cmd_transfer)
                print("------------------------------------------------")
            else:
                changing_perm="sudo chmod 777 /etc/pki/tls/private"
                cmd_out = cli_run(server_ip, self.linux_user, self.linux_password, changing_perm)
                print("-----------Copying server files-----------------")
                trace("-----------Copying server files-----------------")
                cmd_transfer = "sshpass -p 'cals0ft' scp -o StrictHostKeyChecking=no {}/*.pem pcc@{}:/etc/pki/tls/private/.".format(path,server_ip)
                print("Command for transferring server files : "+str(cmd_transfer))
                trace("Command for transferring server files : "+str(cmd_transfer))
                cmd_out = os.system(cmd_transfer)
        else:
            path=os.getcwd()+"/tests/test-data/rsyslog/non_tls"
            changing_perm="sudo chmod 777 /etc"
            cmd_out = cli_run(server_ip, self.linux_user, self.linux_password, changing_perm)
            print("-----------Copying Rsyslog Config File For Non TLS-----------------")
            trace("-----------Copying Rsyslog Config File For Non TLS-----------------")
            cmd_config="sshpass -p 'cals0ft' scp -o StrictHostKeyChecking=no {}/rsyslog.conf pcc@{}:/etc/.".format(path,server_ip)
            print("Command for transferring rsyslog config file for non TLS: " + str(cmd_config))
            trace("Command for transferring rsyslog config file for non TLS: " + str(cmd_config))
            cmd_out = os.system(cmd_config)
            print("------------------------------------------------")
        return "OK"


