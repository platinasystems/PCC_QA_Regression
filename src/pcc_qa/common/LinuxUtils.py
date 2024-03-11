import os
import re
import ast
import sys
import json
import time
from datetime import datetime
from robot.api import logger
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Utils import banner, trace, debug, pretty_print
from pcc_qa.common.Cli import cli_run
from pcc_qa.common.Result import get_response_data

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy
from pcc_qa.pcc.Nodes import Nodes
from pcc_qa.pcc.Cli import Cli

class LinuxUtils(PccBase):
    
    
    def __init__(self):

        self.hostip = None
        self.node_names = []
        self.username = "pcc"
        self.password = "plat1na"
        self.process_name = None
        self.service_name = None
        self.port_number = None
        self.FQDN_name = None
        self.time_to_wait = None
        super().__init__()

    ##################################################################################################
    @keyword(name="Is process up")
    ##################################################################################################
    
    # returns OK if Process is up
    # <usage> is_process_up(process_name=<process_name>)
    
    def is_process_up(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        try:
            cmd = "ps -aux|grep {}|grep -v grep|wc -l".format(self.process_name)
            process_up_status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username, linux_password=self.password)
            
            serialised_process_up_status = self._serialize_response(time.time(), process_up_status)
            print("serialised_process_up_status is:{}".format(serialised_process_up_status))
            
            cmd_output = str(serialised_process_up_status['Result']['stdout']).replace('\n', '').strip()
            
            if int(cmd_output) > 0:
                return "OK"
            else:
                return "Error"
        except Exception as e:
            logger.console("Error in process_up: " + e)

    ##################################################################################################
    @keyword(name="Is Daemon up")
    ##################################################################################################
    
    # returns OK if daemon is up
    # <usage> is_daemon_up(service_name=<service_name>)
    
    def is_daemon_up(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        try:
            cmd = "sudo service {} status|grep -e 'Active:' -e 'running'|wc -l".format(self.service_name)
            daemon_up_status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username, linux_password=self.password)
            
            serialised_daemon_up_status = self._serialize_response(time.time(), daemon_up_status)
            print("serialised_daemon_up_status is:{}".format(serialised_daemon_up_status))
            
            cmd_output = str(serialised_daemon_up_status['Result']['stdout']).replace('\n', '').strip()
            
            print("daemon_up_status output : {}".format(cmd_output))
            if int(cmd_output) > 0:
                return "OK"
            else:
                return "Error"
        except Exception as e:
            logger.console("Error in daemon_up: " + e)

    ###################################################################################################
    @keyword(name="Is FQDN reachable")
    ###################################################################################################

    # returns OK if FQDN is reachable
    # <usage> is_FQDN_reachable(FQDN_name=<FQDN_name>)
    
    def is_FQDN_reachable(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        try:
            cmd = "ping {} -c 4".format(self.FQDN_name)
            FQDN_status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username, linux_password=self.password)
            
            serialised_FQDN_status = self._serialize_response(time.time(), FQDN_status)
            print("serialised_FQDN_status is:{}".format(serialised_FQDN_status))
            
            cmd_output = str(serialised_FQDN_status['Result']['stdout']).replace('\n', '').strip()
            
            if ", 0% packet loss" in cmd_output:
                return "OK"
            else:
                return "Error"
        except Exception as e:
            logger.console("Error in FQDN_reachability: " + e)

    ###################################################################################################
    @keyword(name="Is Port Used")
    ###################################################################################################
    
    # returns OK if Port is Used
    # <usage> is_port_used(port_number=<port_number>)
    
    def is_port_used(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        try:
            cmd = "sudo netstat -antlp|grep -w {}|wc -l".format(self.port_number)
            port_used_status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username, linux_password=self.password)

            serialised_port_used_status = self._serialize_response(time.time(), port_used_status)
            print("serialised_port_used_status is:{}".format(serialised_port_used_status))
            
            cmd_output = str(serialised_port_used_status['Result']['stdout']).replace('\n', '').strip()
            
            if int(cmd_output) > 0:
                return "OK"
            else:
                return "Error"
        except Exception as e:
            logger.console("Error in Port_used: " + e)
            
    ###################################################################################################
    @keyword(name="Restart node")
    ###################################################################################################
    
    # returns OK if Node is Restarted successfully
    # <usage> restart_node(hostip=<hostip>)
    
    def restart_node(self,*args, **kwargs):
        self._load_kwargs(kwargs)
        try:
            cmd = "sudo reboot"
            restart_cmd = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username, linux_password=self.password)
            banner("Sleeping")
            time.sleep(int(self.time_to_wait))
            banner("Done sleeping")
            cmd = "ping {} -c 4".format(self.hostip)
            
            restart_up_status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username, linux_password=self.password)
            
            serialised_restart_up_status = self._serialize_response(time.time(), restart_up_status)
            print("serialised_restart_up_status is:{}".format(serialised_restart_up_status))
            
            cmd_output = str(serialised_restart_up_status['Result']['stdout']).replace('\n', '').strip()
            
            if ", 0% packet loss" in cmd_output:
                return "OK"
            else:
                return "Error"
        except Exception as e:
            logger.console("Error in Restart node: " + e)
            
    ###################################################################################################
    @keyword(name="Force Restart node")
    ###################################################################################################
    
    # returns OK if Node is Restarted successfully
    # <usage> restart_node(hostip=<hostip>)
    
    def force_restart_node(self,*args, **kwargs):
        self._load_kwargs(kwargs)
        try:
            cmd = "sudo reboot -f"
            restart_cmd = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username, linux_password=self.password)
            banner("Sleeping")
            time.sleep(int(self.time_to_wait))
            banner("Done sleeping")
            cmd = "ping {} -c 4".format(self.hostip)
            
            restart_up_status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username, linux_password=self.password)
            
            serialised_restart_up_status = self._serialize_response(time.time(), restart_up_status)
            print("serialised_restart_up_status is:{}".format(serialised_restart_up_status))
            
            cmd_output = str(serialised_restart_up_status['Result']['stdout']).replace('\n', '').strip()
            
            if ", 0% packet loss" in cmd_output:
                return "OK"
            else:
                return "Error"
        except Exception as e:
            logger.console("Error in Force Restart node: " + e)
            
    ###################################################################################################
    @keyword(name="Install net-tools command")
    ###################################################################################################
    
    def install_nettools(self,*args, **kwargs):
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        print("Kwargs are: {}".format(kwargs))
        try:
            host_ips = []
            status = []
            get_nodes_response = Nodes().get_nodes(**kwargs)
            host_ips = [str(node['Host']) for node in get_response_data(get_nodes_response)]
            print("host_ips_list : {}".format(host_ips))
            for ip in host_ips:    
                cmd = "sudo cat /etc/os-release|grep PRETTY_NAME"
                cmd_output = cli_run(cmd=cmd, host_ip=ip, linux_user=self.username, linux_password=self.password)
                
                serialised_status = self._serialize_response(time.time(), cmd_output)                    
                serialised_cmd_output = str(serialised_status['Result']['stdout']).replace('\n', '').strip()                              
                                              
                
                if "Ubuntu" in serialised_cmd_output:
                    cmd = "sudo apt-get install net-tools"
                    cmd_output = cli_run(cmd=cmd, host_ip=ip, linux_user=self.username, linux_password=self.password)
                    
                    serialised_status = self._serialize_response(time.time(), cmd_output)                    
                    serialised_cmd_output = str(serialised_status['Result']['stdout']).replace('\n', '').strip()
                    
                    if "0 newly installed" or "1 newly installed" in serialised_cmd_output:
                        status.append("OK")
                    else:
                        logger.console("Error in installing net-tools on Ubuntu: {}".format(serialised_cmd_output))
                        status.append("Error in installing net-tools on Ubuntu")
                
                elif "CentOS" in serialised_cmd_output:
                    cmd = "sudo yum -y install net-tools"
                    cmd_output = cli_run(cmd=cmd, host_ip=ip, linux_user=self.username,
                                         linux_password=self.password)
                                         
                    serialised_status = self._serialize_response(time.time(), cmd_output)                    
                    serialised_cmd_output = str(serialised_status['Result']['stdout']).replace('\n', '').strip()
                    
                    if "Complete!" or "Nothing to do" in serialised_cmd_output:
                        status.append("OK")
                    else:
                        logger.console("Error in installing net-tools on CentOS: {}".format(serialised_cmd_output))
                        status.append("Error in installing net-tools on CentOS")
                
                elif "Debian" in serialised_cmd_output:
                    cmd = "sudo apt-get install net-tools"
                    cmd_output = cli_run(cmd=cmd, host_ip=ip, linux_user=self.username,
                                         linux_password=self.password)
                                         
                    serialised_status = self._serialize_response(time.time(), cmd_output)                    
                    serialised_cmd_output = str(serialised_status['Result']['stdout']).replace('\n', '').strip()
                    
                    if "0 upgraded" or "0 newly installed" or "1 newly installed" in serialised_cmd_output:
                        status.append("OK")
                    else:
                        logger.console("Error in installing net-tools on Debian: {}".format(serialised_cmd_output))
                        status.append("Error in installing net-tools on Debian")
                
                else:
                    return "Error: OS version not supported in code"
            print("Status: {}".format(status))    
            result = len(status) > 0 and all(elem == "OK" for elem in status)
            if result:
                return "OK"
            else:
                return "Error: Installation of net-tools failed" 
        
        except Exception as e:
            return "Error in installing net-tools: {}".format(e)

    ###################################################################################################
    @keyword(name="Ping Check")
    ###################################################################################################
    def ping_check(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        failed_check=[]
        if self.node_names:
            for node in eval(str(self.node_names)):
                host_ip=easy.get_hostip_by_name(conn,node)
                if type(host_ip)==str:
                    ping_cmd = "sudo ping {} -c 4".format(host_ip)
                    ping_execute = cli_run(cmd=ping_cmd, host_ip=host_ip, linux_user=self.username, linux_password=self.password)
                    ping_serialize = self._serialize_response(time.time(), ping_execute)
                    output = str(ping_serialize['Result']['stdout']).replace('\n', '').strip()
                    print("-------Ping Output for {}--------".format(node))
                    print(output)
                    if ", 0% packet loss" in output:
                        continue
                    else:
                        failed_check.append(node)
            if failed_check:
                print("Could not verify ping test for {}".format(failed_check))
                return "Could not verify ping test for {}".format(failed_check)
            else:
                return "OK"
        else:
            print("node_names argument is missing")
            return "node_name argument is missing"


    ###################################################################################################
    @keyword(name="Install s3cmd command")
    ###################################################################################################

    def install_s3cmd(self,*args, **kwargs):
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        print("Kwargs are: {}".format(kwargs))
        try:
            host_ips = []
            status = []
            get_nodes_response = Nodes().get_nodes(**kwargs)
            host_ips = [str(node['Host']) for node in get_response_data(get_nodes_response)]
            print("host_ips_list : {}".format(host_ips))
            for ip in host_ips:
                OS_type = Cli().get_OS_version(host_ip= ip, linux_user= self.username, linux_password = self.password)
                if re.search("Debian",str(OS_type)) or re.search("Ubuntu",str(OS_type)):
                    cmd = "sudo apt-get --assume-yes install s3cmd"
                if re.search("Red Hat Enterprise",str(OS_type)) or re.search("CentOS",str(OS_type)):
                    cmd = "sudo yum -y install s3cmd"
                
                s3cmd_install = cli_run(cmd=cmd, host_ip=ip, linux_user=self.username, linux_password=self.password)
                print("Cmd: {} executed successfully. Output is : {}".format(cmd, str(s3cmd_install)))
                trace("Cmd: {} executed successfully. Output is : {}".format(cmd, str(s3cmd_install)))
            return "OK"
        except Exception as e:
            print("s3cmd installation unsuccessful: {}".format(e))
            return("s3cmd installation unsuccessful: {}".format(e))
