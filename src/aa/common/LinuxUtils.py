import os
import sys
import json
import time
from datetime import datetime
from robot.api import logger
from robot.api.deco import keyword
from aa.common.AaBase import AaBase
from aa.common.Utils import banner, trace, debug, pretty_print
from aa.common.Cli import cli_run

from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy


class LinuxUtils(AaBase):
    
    
    def __init__(self):

        self.hostip = "172.17.10.100"
        self.username = "pcc"
        self.password = "cals0ft"
        self.cmd_output = None
        self.process_name = None
        self.service_name = None
        self.port_number = None
        self.FQDN_name = None
        self.cmd = None
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
            self.cmd = "ps -aux|grep {}|grep -v grep|wc -l".format(self.process_name)
            process_up_status = cli_run(cmd=self.cmd, host_ip=self.hostip, linux_user=self.username,
                                           linux_password=self.password)
            
            serialised_process_up_status = self._serialize_response(time.time(), process_up_status)
            print("serialised_process_up_status is:{}".format(serialised_process_up_status))
            
            self.cmd_output = str(serialised_process_up_status['Result']['stdout']).replace('\n', '').strip()
            
            if int(self.cmd_output) > 0:
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
            self.cmd = "sudo service {} status|grep -e 'Active:' -e 'running'|wc -l".format(self.service_name)
            daemon_up_status = cli_run(cmd=self.cmd, host_ip=self.hostip, linux_user=self.username,
                                          linux_password=self.password)
            
            serialised_daemon_up_status = self._serialize_response(time.time(), daemon_up_status)
            print("serialised_daemon_up_status is:{}".format(serialised_daemon_up_status))
            
            self.cmd_output = str(serialised_daemon_up_status['Result']['stdout']).replace('\n', '').strip()
            
            print("daemon_up_status output : {}".format(self.cmd_output))
            if int(self.cmd_output) > 0:
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
            self.cmd = "ping {} -c 4".format(self.FQDN_name)
            FQDN_status = cli_run(cmd=self.cmd, host_ip=self.hostip, linux_user=self.username,
                                     linux_password=self.password)
            
            serialised_FQDN_status = self._serialize_response(time.time(), FQDN_status)
            print("serialised_FQDN_status is:{}".format(serialised_FQDN_status))
            
            self.cmd_output = str(serialised_FQDN_status['Result']['stdout']).replace('\n', '').strip()
            
            if ", 0% packet loss" in self.cmd_output:
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
            self.cmd = "sudo netstat -antlp|grep -w {}|wc -l".format(self.port_number)
            port_used_status = cli_run(cmd=self.cmd, host_ip=self.hostip, linux_user=self.username,
                                          linux_password=self.password)
            
            serialised_port_used_status = self._serialize_response(time.time(), port_used_status)
            print("serialised_port_used_status is:{}".format(serialised_port_used_status))
            
            self.cmd_output = str(serialised_port_used_status['Result']['stdout']).replace('\n', '').strip()
            
            if int(self.cmd_output) > 0:
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
            self.cmd = "sudo reboot"
            restart_cmd = cli_run(cmd=self.cmd, host_ip=self.hostip, linux_user=self.username,
                                          linux_password=self.password)
            banner("Sleeping")
            time.sleep(int(self.time_to_wait))
            banner("Done sleeping")
            self.cmd = "ping {} -c 4".format(self.hostip)
            
            restart_up_status = cli_run(cmd=self.cmd, host_ip=self.hostip, linux_user=self.username,
                                     linux_password=self.password)
            
            serialised_restart_up_status = self._serialize_response(time.time(), restart_up_status)
            print("serialised_restart_up_status is:{}".format(serialised_restart_up_status))
            
            self.cmd_output = str(serialised_restart_up_status['Result']['stdout']).replace('\n', '').strip()
            
            if ", 0% packet loss" in self.cmd_output:
                return "OK"
            else:
                return "Error"
        except Exception as e:
            logger.console("Error in Restart node: " + e)
