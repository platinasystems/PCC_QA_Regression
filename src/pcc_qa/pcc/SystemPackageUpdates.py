import re
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

class SystemPackageUpdates(PccBase):
    """
    SystemPackageUpdate
    """
    def __init__(self):
        self.host_ips= None
        self.host_ip= None
        self.linux_user= "pcc"
        self.linux_password= "cals0ft"
        super().__init__()

    ###########################################################################
    @keyword(name="CLI.Check repo list")
    ###########################################################################
    def check_repo_list(self, *args, **kwargs):
        """
        Check repo list
        [Args]
            (str) host_ip: Host IP of the node
        [Returns]
            (str) Response: Output of check repo list command
        """
        self._load_kwargs(kwargs)
        banner("CLI.Check repo list")
        try:
            OS_type = Cli().get_OS_version(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)
            print("OS_type output: {}".format(OS_type))
            if re.search("Debian",str(OS_type)) or re.search("Ubuntu",str(OS_type)):
                print("Inside debian")
                cmd = "sudo grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/*"

            if re.search("Red Hat Enterprise",str(OS_type)) or re.search("CentOS",str(OS_type)):
                print("Inside red hat")
                cmd = "sudo yum repolist"

            print("cmd to be executed is : {}".format(cmd))
            cmd_op=cli_run(self.host_ip,self.linux_user,self.linux_password,cmd)
            serialised_output = self._serialize_response(time.time(), cmd_op)

            output = str(serialised_output['Result']['stdout']).replace('\n', '').strip()
            return output

        except Exception as e:
            print("Exception encountered: {}".format(e))
            return "Exception encountered: "+ str(e)

    ###########################################################################
    @keyword(name="CLI.Check GPG Keys")
    ###########################################################################
    def check_GPG_keys(self, *args, **kwargs):
        """
        Check GPG Keys
        [Args]
            (str) host_ip: Host IP of the node
        [Returns]
            (dict) Response: Output of check GPG keys command
        """
        self._load_kwargs(kwargs)
        banner("CLI.Check GPG Keys")
        try:
            OS_type = Cli().get_OS_version(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)

            if re.search("Debian",str(OS_type)) or re.search("Ubuntu",str(OS_type)):
                cmd = "sudo apt-key list"

            if re.search("Red Hat Enterprise",str(OS_type)) or re.search("CentOS",str(OS_type)):
                cmd = '''sudo rpm -qa gpg-pubkey --qf "%{version}-%{release} %{summary}\n"'''

            cmd_op=cli_run(self.host_ip,self.linux_user,self.linux_password,cmd)
            serialised_output = self._serialize_response(time.time(), cmd_op)

            output = str(serialised_output['Result']['stdout']).replace('\n', '').strip()

            return output

        except Exception as e:
            print("Exception encountered: {}".format(e))
            return "Exception encountered: "+ str(e)

    ###########################################################################
    @keyword(name="CLI.Validate Kubernetes Resource")
    ###########################################################################
    def validate_kubernetes_resource(self, *args, **kwargs):
        """
        Validate Kubernetes Resource
        [Args]
            (str) host_ip: Host IP of the node
        [Returns]
            (dict) Response: "OK" if validation successful
        """
        self._load_kwargs(kwargs)
        banner("CLI.Validate Kubernetes Resource")
        try:
            validation_checks = []

            check_repo_list_output = self.check_repo_list(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)
            check_GPG_keys_output = self.check_GPG_keys(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)

            OS_type = Cli().get_OS_version(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)

            if re.search("Debian",str(OS_type)) or re.search("Ubuntu",str(OS_type)):
                print(" ===============  Searching in repo list: deb https://download.docker.com/linux/debian stretch stable =========== ")
                if (re.search(r"deb https://download.docker.com/linux/debian stretch stable", str(check_repo_list_output))) or (re.search(r"deb https://download.docker.com/linux/ubuntu bionic stable", str(check_repo_list_output))):
                    validation_checks.append("OK")

                print("================  Searching in gpg keys: Docker Release (CE deb) ============= ")
                if re.search(r"Docker Release \(CE deb\)",str(check_GPG_keys_output)):
                    validation_checks.append("OK")
                if all(x==validation_checks[0] for x in validation_checks) and (len(validation_checks)==2):
                    return "OK"
                else:
                    return "Kubernetes Resource validation unsuccessful: {}".format(validation_checks)

            if re.search("Red Hat Enterprise",str(OS_type)) or re.search("CentOS",str(OS_type)):
                print("===========  Searching in repo list: docker-ce/x86_64, Docker-CE Repository ================")
                if re.search(r"docker-ce/x86_64", str(check_repo_list_output)) and re.search("Docker-CE Repository", str(check_repo_list_output)):
                    validation_checks.append("OK")

                print("============  Searching in gpg keys: gpg(Docker Release (CE rpm) ==================")
                if re.search(r"Docker Release \(CE rpm\)", str(check_GPG_keys_output)):
                    validation_checks.append("OK")

                if all(x==validation_checks[0] for x in validation_checks) and (len(validation_checks)==2):
                    return "OK"
                else:
                    return "Kubernetes Resource validation unsuccessful: {}".format(validation_checks)

        except Exception as e:
            print("Exception encountered: {}".format(e))
            return "Exception encountered: "+ str(e)

    ###########################################################################
    @keyword(name="CLI.Validate CEPH Resource")
    ###########################################################################
    def validate_ceph_resource(self, *args, **kwargs):
        """
        Validate CEPH Resource
        [Args]
            (str) host_ip: Host IP of the node
        [Returns]
            (dict) Response: "OK" if validation successful
        """
        self._load_kwargs(kwargs)
        banner("CLI.Validate CEPH Resource")
        try:
            validation_checks = []

            check_repo_list_output = self.check_repo_list(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)
            check_GPG_keys_output = self.check_GPG_keys(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)

            OS_type = Cli().get_OS_version(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)

            if re.search("Debian",str(OS_type)) or re.search("Ubuntu",str(OS_type)):
                print(" ===============  Searching in repo list: deb http://download.ceph.com/debian-nautilus xenial main =========== ")

                if (re.search(r"deb http://download.ceph.com/debian-nautilus xenial main", str(check_repo_list_output))) or (re.search(r"deb http://download.ceph.com/debian-nautilus bionic main", str(check_repo_list_output))):
                    validation_checks.append("OK")

                print("================  Searching in gpg keys: Ceph.com (release key) <security@ceph.com> ============= ")
                if re.search(r"Ceph.com \(release key\) <security@ceph.com>",str(check_GPG_keys_output)):
                    validation_checks.append("OK")

                if all(x==validation_checks[0] for x in validation_checks) and (len(validation_checks)==2):
                    return "OK"
                else:
                    return "Kubernetes Resource validation unsuccessful: {}".format(validation_checks)

            if re.search("Red Hat Enterprise",str(OS_type)) or re.search("CentOS",str(OS_type)):
                print("===========  Searching in repo list: ceph_stable/x86_64 ================")
                #if re.search(r"RedHat Ceph stable community repository", str(check_repo_list_output)) and re.search("RedHat Ceph stable noarch community repository", str(check_repo_list_output)):
                 
                if re.search(r"ceph_stable/x86_64", str(check_repo_list_output)) and re.search("ceph_stable_noarch", str(check_repo_list_output)):
                    validation_checks.append("OK")

                print("============  Searching in gpg keys: gpg(Ceph.com (release key) ==================")
                if re.search(r"gpg\(Ceph.com \(release key\)", str(check_GPG_keys_output)):
                    validation_checks.append("OK")

                if all(x==validation_checks[0] for x in validation_checks) and (len(validation_checks)==2):
                    return "OK"
                else:
                    return "CEPH Resource validation unsuccessful: {}".format(validation_checks)

        except Exception as e:
            print("Exception encountered: {}".format(e))
            return "Exception encountered: "+ str(e)

    ###########################################################################
    @keyword(name="CLI.Validate Network Resource")
    ###########################################################################
    def validate_network_resource(self, *args, **kwargs):
        """
        Validate Network Resource
        [Args]
            (str) host_ip: Host IP of the node
        [Returns]
            (dict) Response: "OK" if validation successful
        """
        self._load_kwargs(kwargs)
        banner("CLI.Validate Network Resource")
        try:
            validation_checks = []

            check_repo_list_output = self.check_repo_list(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)
            check_GPG_keys_output = self.check_GPG_keys(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)

            OS_type = Cli().get_OS_version(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)

            if re.search("Debian",str(OS_type)) or re.search("Ubuntu",str(OS_type)):
                print(" ===============  Searching in repo list: deb https://deb.frrouting.org/frr stretch frr-stable =========== ")
                if (re.search(r"deb https://deb.frrouting.org/frr stretch frr-stable", str(check_repo_list_output))) or (re.search(r"deb https://deb.frrouting.org/frr bionic frr-stable", str(check_repo_list_output))):
                    validation_checks.append("OK")

                print("================  Searching in gpg keys: FRRouting Debian Repository ============= ")
                if re.search(r"FRRouting Debian Repository",str(check_GPG_keys_output)):
                    validation_checks.append("OK")

                if all(x==validation_checks[0] for x in validation_checks) and (len(validation_checks)==2):
                    return "OK"
                else:
                    return "Network Resource validation unsuccessful: {}".format(validation_checks)

            if re.search("Red Hat Enterprise",str(OS_type)) or re.search("CentOS",str(OS_type)):
                print("===========  Searching in repo list: FRRouting Packages for Enterprise Linux 7 - x86_64 ================")
                if re.search(r"FRRouting Packages for Enterprise Linux 7", str(check_repo_list_output)) and re.search("FRRouting Dependencies for Enterprise Linux 7", str(check_repo_list_output)):
                    validation_checks.append("OK")

                if all(x==validation_checks[0] for x in validation_checks) and (len(validation_checks)==1):
                    return "OK"
                else:
                    return "Network Resource validation unsuccessful: {}".format(validation_checks)

        except Exception as e:
            print("Exception encountered: {}".format(e))
            return "Exception encountered: "+ str(e)

    ###########################################################################
    @keyword(name="CLI.Validate Platina Systems Package repository")
    ###########################################################################
    def validate_platina_systems_package_repository(self, *args, **kwargs):
        """
        Validate Platina Systems Package repository
        [Args]
            (str) host_ip: Host IP of the node
        [Returns]
            (dict) Response: "OK" if validation successful
        """
        self._load_kwargs(kwargs)
        banner("CLI.Validate Platina Systems Package repository")
        try:
            validation_checks = []

            check_repo_list_output = self.check_repo_list(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)
            check_GPG_keys_output = self.check_GPG_keys(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)

            OS_type = Cli().get_OS_version(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)

            if re.search("Debian",str(OS_type)) or re.search("Ubuntu",str(OS_type)):
                print(" ===============  Searching in repo list: deb https://platina.io/goes/debian stretch main =========== ")
                if re.search(r"deb https://platina.io/goes/debian stretch main", str(check_repo_list_output)):
                    validation_checks.append("OK")

                print("================  Searching in gpg keys: Kevin Paul Herbert <kph@platinasystems.com> ============= ")
                if re.search(r"Kevin Paul Herbert <kph@platinasystems.com>",str(check_GPG_keys_output)):
                    validation_checks.append("OK")

                if all(x==validation_checks[0] for x in validation_checks) and (len(validation_checks)==2):
                    return "OK"
                else:
                    return "Platina Systems Package repository validation unsuccessful: {}".format(validation_checks)

            if re.search("Red Hat Enterprise",str(OS_type)) or re.search("CentOS",str(OS_type)):
                return "Validations for Platina Systems Package respository is not available for CentOS or RedHat Enterprise"

        except Exception as e:
            print("Exception encountered: {}".format(e))
            return "Exception encountered: "+ str(e)

    ###########################################################################
    @keyword(name="CLI.OS Package repository")
    ###########################################################################
    def validate_os_package_repository(self, *args, **kwargs):
        """
        OS Package repository validation
        [Args]
            (str) host_ip: Host IP of the node
        [Returns]
            (dict) Response: "OK" if validation successful
        """
        self._load_kwargs(kwargs)
        banner("CLI.Validate OS Package repository")
        try:
            validation_checks = []

            check_repo_list_output = self.check_repo_list(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)
            check_GPG_keys_output = self.check_GPG_keys(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)

            OS_type = Cli().get_OS_version(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)

            if re.search("Debian",str(OS_type)):
                print(" ===============  Searching in repo list:deb http://deb.debian.org/debian stretch main =========== ")
                if re.search(r"deb http://deb.debian.org/debian stretch main", str(check_repo_list_output)):
                    validation_checks.append("OK")
                if re.search(r"deb-src http://deb.debian.org/debian-security/ stretch/updates", str(check_repo_list_output)):
                    validation_checks.append("OK")
                if re.search(r"deb http://deb.debian.org/debian stretch-updates main", str(check_repo_list_output)):
                    validation_checks.append("OK")
                if all(x==validation_checks[0] for x in validation_checks) and (len(validation_checks)==3):
                    return "OK"
                else:
                    return "OS Package repository validation unsuccessful in Debian: {}".format(validation_checks)

            if re.search("Ubuntu",str(OS_type)):
                print(" ===============  Searching in repo list:deb http://us.archive.ubuntu.com/ubuntu bionic main restricted universe multiverse =========== ")
                if re.search(r"deb http://us.archive.ubuntu.com/ubuntu bionic main restricted universe multiverse", str(check_repo_list_output)):
                    validation_checks.append("OK")
                if re.search(r"deb http://us.archive.ubuntu.com/ubuntu bionic-updates main restricted universe multiverse", str(check_repo_list_output)):
                    validation_checks.append("OK")
                if re.search(r"deb http://us.archive.ubuntu.com/ubuntu bionic-backports main restricted universe multiverse", str(check_repo_list_output)):
                    validation_checks.append("OK")
                if re.search(r"deb http://us.archive.ubuntu.com/ubuntu bionic-security main restricted universe multiverse", str(check_repo_list_output)):
                    validation_checks.append("OK")

                if all(x==validation_checks[0] for x in validation_checks) and (len(validation_checks)==4):
                    return "OK"
                else:
                    return "OS Package repository validation unsuccessful in Ubuntu: {}".format(validation_checks)

            if re.search("Red Hat Enterprise",str(OS_type)) or re.search("CentOS",str(OS_type)):
                print("===========  Searching in repo list: base/7/x86_64 ================")
                if re.search(r"base/7/x86_64", str(check_repo_list_output)) and re.search(r"extras/7/x86_64", str(check_repo_list_output)) and re.search(r"updates/7/x86_64", str(check_repo_list_output)) and re.search(r"epel/x86_64", str(check_repo_list_output)):
                    validation_checks.append("OK")

                print("============  Searching in gpg keys: gpg\(Fedora EPEL (7) <epel@fedoraproject.org>\) ==================")
                if re.search(r"gpg\(Fedora EPEL (7) <epel@fedoraproject.org>\)", str(check_GPG_keys_output)) and re.search(r"Official Signing Key\) <security@centos.org>\)", str(check_GPG_keys_output)):
                    validation_checks.append("OK")

                if all(x==validation_checks[0] for x in validation_checks) and (len(validation_checks)==1):
                    return "OK"
                else:
                    return "OS Package repository validation unsuccessful in Redhat or CentOS: {}".format(validation_checks)

        except Exception as e:
            print("Exception encountered: {}".format(e))
            return "Exception encountered: "+ str(e)
            
    ###########################################################################
    @keyword(name="CLI.Automatic Upgrades Validation")
    ###########################################################################
    def validate_automatic_upgrades(self, *args, **kwargs):
        """
        Automatic Upgrades Validation
        [Args]
            (str) host_ip: Host IP of the node
        [Returns]
            (dict) Response: "OK" if validation successful
        """
        self._load_kwargs(kwargs)
        banner("CLI.Automatic Upgrades Validation")
        try:
            OS_type = Cli().get_OS_version(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)

            if re.search("Debian",str(OS_type)) or re.search("Ubuntu",str(OS_type)):
                
                package_installation_check = Cli().check_package_installed(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password,package_name="unattended-upgrades")
                
                print("package_installation_check: {}".format(package_installation_check))
                
                cmd1= "sudo cat /etc/apt/apt.conf.d/20auto-upgrades"
                cmd_op1=cli_run(self.host_ip,self.linux_user,self.linux_password,cmd1)
                serialised_output1 = self._serialize_response(time.time(), cmd_op1)
                print("serialised_output1 is : {}".format(serialised_output1))
                cmd2= 'sudo cat /var/log/unattended-upgrades/unattended-upgrades.log'
                cmd_op2=cli_run(self.host_ip,self.linux_user,self.linux_password,cmd2)
                serialised_output2 = self._serialize_response(time.time(), cmd_op2)
                print("serialised_output2 is : {}".format(serialised_output2))
                if (re.search(r'APT::Periodic::Update-Package-Lists "0"', str(serialised_output1))) and (package_installation_check=="unattended-upgrades Package installed") and ((re.search(r'installed', str(serialised_output2))) or (re.search(r'No packages found that can be upgraded', str(serialised_output2)))):
                    return "Automatic upgrades set to No from backend"
                
                elif (re.search(r'APT::Periodic::Update-Package-Lists "1"', str(serialised_output1))) and (re.search(r'APT::Periodic::Unattended-Upgrade "1"', str(serialised_output1))) and (package_installation_check=="unattended-upgrades Package installed") and ((re.search(r'installed', str(serialised_output2)))or (re.search(r'No packages found that can be upgraded', str(serialised_output2)))):
                    return "Automatic upgrades set to Yes from backend"
                else:
                    return "Automatic upgrades validation unsuccessful in Debian"

            if re.search("Red Hat Enterprise",str(OS_type)) or re.search("CentOS",str(OS_type)):
                
                package_installation_check = Cli().check_package_installed(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password,package_name="unattended-upgrades")
                
                cmd1= "sudo service yum-cron status"
                cmd_op1=cli_run(self.host_ip,self.linux_user,self.linux_password,cmd1)
                serialised_output1 = self._serialize_response(time.time(), cmd_op1)
                print("serialised_output1 is : {}".format(serialised_output1))
                current_date = datetime.date.today().strftime("%b %d")
                print("current date is : {}".format(current_date))
                cmd2= 'sudo cat /var/log/yum.log| grep "{}"'.format(current_date)
                cmd_op2=cli_run(self.host_ip,self.linux_user,self.linux_password,cmd2)
                serialised_output2 = self._serialize_response(time.time(), cmd_op2)
                print("serialised_output2 is : {}".format(serialised_output2))
                cmd3= 'sudo cat /var/log/cron | grep "{}"|grep -i yum-daily'.format(current_date)
                cmd_op3=cli_run(self.host_ip,self.linux_user,self.linux_password,cmd3)
                serialised_output3 = self._serialize_response(time.time(), cmd_op3)
                
                if (re.search(r'yum-cron.service; enabled', str(serialised_output1))) and (package_installation_check=="unattended-upgrades Package installed") and (re.search(r'updated', str(serialised_output2))) and (re.search(r'starting 0yum-daily.cron', str(serialised_output3))):
                    return "Automatic upgrades set to Yes from backend"
                
                elif (re.search(r'yum-cron.service; disabled', str(serialised_output1))) and (package_installation_check=="unattended-upgrades Package installed") and (re.search(r'installed', str(serialised_output2))) and (re.search(r'starting 0yum-daily.cron', str(serialised_output3))):
                    return "Automatic upgrades set to No from backend"
                
                elif (re.search(r'yum-cron.service could not be found', str(serialised_output1))) and (package_installation_check=="unattended-upgrades Package installed") and (re.search(r'installed', str(serialised_output2))) and (re.search(r'starting 0yum-daily.cron', str(serialised_output3))):
                    return "Automatic upgrades service are not available on backend"
                    
                else:
                    return "Automatic upgrades validation unsuccessful in RedHat or CentOS"

        except Exception as e:
            print("Exception encountered: {}".format(e))
            return "Exception encountered: "+ str(e)
            
    ###########################################################################
    @keyword(name="CLI.Validate Node Self Healing")
    ###########################################################################
    def validate_node_self_healing(self, *args, **kwargs):
        """
        Validate Node Self Healing
        [Args]
            (str) host_ip: Host IP of the node
        [Returns]
            (dict) Response: Output of Validate Node Self Healing
        """
        self._load_kwargs(kwargs)
        banner("CLI.Validate Node Self Healing")
        try:
            OS_type = Cli().get_OS_version(host_ip= self.host_ip, linux_user= self.linux_user, linux_password = self.linux_password)
            cmd = "sudo sysctl -a"
            cmd_op=cli_run(self.host_ip,self.linux_user,self.linux_password,cmd)
            serialised_output = self._serialize_response(time.time(), cmd_op)

            output = str(serialised_output['Result']['stdout']).replace('\n', '').strip()
            list_for_Ubuntu = ['kernel.hung_task_panic = 1','kernel.panic = 1','kernel.panic_on_io_nmi = 1','kernel.panic_on_oops = 1','kernel.panic_on_rcu_stall = 1','kernel.panic_on_unrecovered_nmi = 1','kernel.panic_on_warn = 1','kernel.softlockup_panic = 1','kernel.unknown_nmi_panic = 1','vm.panic_on_oom = 1']
            
            list_for_Debian = ['kernel.panic = 1','kernel.panic_on_io_nmi = 1','kernel.panic_on_oops = 1','kernel.panic_on_rcu_stall = 1','kernel.panic_on_unrecovered_nmi = 1','kernel.panic_on_warn = 1','kernel.unknown_nmi_panic = 1','vm.panic_on_oom = 1']
            
            list_for_Centos_Redhat = ['kernel.hardlockup_panic = 1','kernel.hung_task_panic = 1','kernel.panic = 1','kernel.panic_on_io_nmi = 1','kernel.panic_on_oops = 1','kernel.panic_on_unrecovered_nmi = 1','kernel.panic_on_warn = 1','kernel.softlockup_panic = 1','kernel.unknown_nmi_panic = 1','vm.panic_on_oom = 1']
            
            if re.search("Debian",str(OS_type)):
                for i in list_for_Debian:
                    if re.search(i,output):
                        continue
                    else:
                        return "Package {} not found in the command output".format(i)
                return "OK"
            
            if re.search("Ubuntu",str(OS_type)):
                for i in list_for_Ubuntu:
                    if re.search(i,output):
                        continue
                    else:
                        return "Package {} not found in the command output".format(i)
                return "OK"
            
            if re.search("Red Hat Enterprise",str(OS_type)) or re.search("CentOS",str(OS_type)):
                for i in list_for_Centos_Redhat:
                    if re.search(i,output):
                        continue
                    else:
                        return "Package {} not found in the command output".format(i)
                return "OK"

        except Exception as e:
            print("Exception encountered: {}".format(e))
            return "Exception encountered: "+ str(e)
            


    ###########################################################################
    @keyword(name="CLI.Validate Ethtool")
    ###########################################################################
    def validate_ethtool(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("CLI.Validate Ethtool")
        try:
            for host_ip in ast.literal_eval(self.host_ips):
                trace("Host IP:{}".format(host_ip))
                cmd = 'sudo ethtool --version'
                cmd_op = cli_run(host_ip,self.linux_user,self.linux_password,cmd)
                trace("Command output:{}".format(cmd_op))
                if re.search("ethtool version",str(cmd_op)):
                    return "OK"
                else:
                    return "Error: Ethtool Not Found"

        except Exception as e:
            print("Exception encountered: {}".format(e))
            return "Exception encountered: "+ str(e)    
