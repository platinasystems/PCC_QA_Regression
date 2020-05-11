import time
import os
import re
import sys
import json
import ast

from robot.api.deco import keyword
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from platina_sdk import pcc_easy_api as easy
from aa.common.LinuxUtils import LinuxUtils
from aa.common.AaBase import AaBase
from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data

from aa.pcc.Nodes import Nodes

class Tunneling(AaBase):

    def __init__(self):

        self.hostip = "172.17.2.242"
        self.cidr_val = "10.99.0.0/16"
        self.interface_ip = None
        self.path = "/home/pcc/platina-home/platina-system/config-repo/docker/pccserver.yml"
        self.username = "pcc"
        self.password = "cals0ft"
        self.node_hostip = None
        self.host_name = None
        self.managed = None
        self.Name = None
        self.host_ips = []
        self.Names = []
        self.tun_switch= None
        self.tun_value = None
        self.restart = None
        self.standby = None
        self.list_of_nodes = []
        self.setup_password = None
        self.peer_ip_address = None
        self.cmd_output = None
        self.invader_host = None
        self.tun_cmd_output = None
        self.modified_ip = None
        self.tun_interface_state = "UP"
        self.list_tun_interface_state = None

        if '/' in self.cidr_val:
            self.modified_cidr_val = self.cidr_val.replace("/","\/")
        
        super().__init__()

    ##################################################################################################
    @keyword(name="Tunnel Turn On")
    ##################################################################################################
    def turn_on_tunnel(self, *args, **kwargs):
        
        """
        Turn On Tunnel by updating the cidr value in pccserver.yml file in respective Virtual Machine
    
        [Args]
            (str) cidr_val: cidr value to be given as input. For e.g. cidr_val=10.99.0.0/16
            (str) hostip: Host IP of the Virtual Machine
    
        [Returns]
            (bool) True/False: Create Container Registry response (includes any errors)
        """
        
        
        self._load_kwargs(kwargs)
        try:
            cmd = "python /home/pcc/tmp/read_pccserver_yml.py"
            data = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,
                                                 linux_password=self.password)
            print("Data: {}".format(data))
            serialised_data = self._serialize_response(time.time(), data)
            print("serialised_data is:{}".format(serialised_data))
            
            pccserver_yml_data = serialised_data['Result']['stdout']
            
            re_match = re.findall("cidr: (.*)\n", pccserver_yml_data)
            
            print("re_match:{}".format(re_match))
            if re_match:
                
                if re_match[0] == self.cidr_val:
                    logger.console("Cidr value is same as the input provided")
                    return True
                else:
                    logger.console("Wrong Cidr value exists: {}".format(re_match[0]))
                    
                    cmd = "sed -i s/'cidr:{}'/'cidr: {}'/ {}".format(re_match[0],self.modified_cidr_val,self.path)
                    edit_cidr = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,
                                             linux_password=self.password)
                    
                    cmd = "python /home/pcc/tmp/read_pccserver_yml.py"
                    data = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,
                                                     linux_password=self.password)
                    
                    serialised_data = self._serialize_response(time.time(), data)
                    print("serialised_data is:{}".format(serialised_data))
            
                    pccserver_yml_data = serialised_data['Result']['stdout']
                    re_match = re.findall("cidr: (.*)\n", pccserver_yml_data)
                                                    
                    if re_match:
                    
                        if re_match[0] == self.cidr_val:
                            logger.console("Cidr value updated to desired value")
                            return True
                        else:
                            return False
            
            else:
                cmd = "sed -i s/'cidr:'/'cidr: {}'/ {}".format(self.modified_cidr_val,self.path)
                edit_cidr = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,
                                         linux_password=self.password)
                
                cmd = "python /home/pcc/tmp/read_pccserver_yml.py"
                data = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,
                                                 linux_password=self.password)
                
                serialised_data = self._serialize_response(time.time(), data)
                print("serialised_data is:{}".format(serialised_data))
            
                pccserver_yml_data = serialised_data['Result']['stdout']
                
                re_match = re.findall("cidr: (.*)\n", pccserver_yml_data)
                                                
                if re_match:
                
                    if re_match[0] == self.cidr_val:
                        logger.console("Cidr value updated to desired value")
                        return True
                    else:
                        return False
                
        except Exception as e:
            logger.console("Error in tunnel turn on: {}".format(e))
    
    ##################################################################################################
    @keyword(name="Tunnel Turn Off")
    ##################################################################################################
    def turn_off_tunnel(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        try:
            cmd = "python /home/pcc/tmp/read_pccserver_yml.py"
            data = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,
                                linux_password=self.password)
            
            serialised_data = self._serialize_response(time.time(), data)
            print("serialised_data is:{}".format(serialised_data))
        
            pccserver_yml_data = serialised_data['Result']['stdout']
            
            re_match = re.findall("cidr: (.*)\n", pccserver_yml_data)
            
            print("re_match:{}".format(re_match))
            if re_match == []:
                logger.console("Cidr value doesn't have any value")
                return True
            elif re_match:
                if re_match[0] == self.cidr_val:

                    cmd = "sed -i s/'cidr: {}'/'cidr:'/ {}".format(self.modified_cidr_val, self.path)
                    edit_cidr = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,
                                             linux_password=self.password)
                    cmd = "python /home/pcc/tmp/read_pccserver_yml.py"
                    data = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,
                                        linux_password=self.password)
                    
                    serialised_data = self._serialize_response(time.time(), data)
                    print("serialised_data is:{}".format(serialised_data))
        
                    pccserver_yml_data = serialised_data['Result']['stdout']
                    
                    re_match = re.findall("cidr: (.*)\n", pccserver_yml_data)

                    if re_match == []:
                        logger.console("Cidr value updated to blank value")
                        return True
                    else:
                        return False

                        

                elif re_match[0] != self.cidr_val:

                    cmd = "sed -i s/'cidr: {}'/'cidr:'/ {}".format(re_match[0], self.path)
                    edit_cidr = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,
                                             linux_password=self.password)

                    cmd = "python /home/pcc/tmp/read_pccserver_yml.py"
                    data = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,
                                        linux_password=self.password)
                    
                    serialised_data = self._serialize_response(time.time(), data)
                    print("serialised_data is:{}".format(serialised_data))
        
                    pccserver_yml_data = serialised_data['Result']['stdout']
                    
                    re_match = re.findall("cidr: (.*)\n", pccserver_yml_data)

                    if re_match == []:
                        logger.console("Cidr value updated to blank value")
                        return True
                    else:
                        return False
                else:
                    return False

            else:
                return False

        except Exception as e:
            logger.console("Error in tunnel turn off: {}".format(e))
    
    
    
    
    ###############################################################################################################
    @keyword(name="Updated pccserver.yml with cidr value")
    ###############################################################################################################
    
    # returns True if cidr value is updated in pccserver.yml file
    # <usage> is_cidr_value_updated(host_ip = <self.hostip>, self.path, self.ip)
    
    def is_cidr_value_updated(self, *args, **kwargs):
        banner("Updated pccserver.yml with cidr value")
        self._load_kwargs(kwargs)
        try:
            cmd = "cat {}".format(self.path)
            data = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,
                                             linux_password=self.password)
            print("Data is : {}".format(data))
            serialised_data = self._serialize_response(time.time(), data)
            print("serialised_data is:{}".format(serialised_data))

            pccserver_yml_data = serialised_data['Result']['stdout']
            
            re_match = re.findall("cidr: (.*)\n", pccserver_yml_data)
                                            
            if re_match:
            
                if re_match[0] == self.cidr_val:
                    logger.console("Cidr value updated to desired value")
                    return True
                else:
                    return False
            else:
                return False
        except Exception as e:
            logger.console("Error in is_cidr_value_updated: {}".format(e))
            
    ###############################################################################################################
    @keyword(name="Restart Container and Check up Status")
    ###############################################################################################################
    
    # returns True if containers are restarted and containers are up and working
    # <usage> is_cidr_value_updated(host_ip = <self.hostip>)
    
    def restart_containers_and_check_up_status(self, *args, **kwargs):
        banner("Restart Container and Check up Status")
        self._load_kwargs(kwargs)
        try:
            cmd= "sudo ./platina-cli-ws/platina-cli restart -p {}".format(self.setup_password)
            
            restart_container_status = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_restart_container_status = self._serialize_response(time.time(), restart_container_status)
            print("serialised_restart_container_status is:{}".format(serialised_restart_container_status))
            
            self.cmd_output = str(serialised_restart_container_status['Result']['stdout']).replace('\n', '').strip()
            
            if "OK" in str(self.cmd_output):
                return True
            else:
                return False
        except Exception as e:
            logger.console("Error in restart_containers_and_check_up_status: {}".format(e))
            
    ###############################################################################################################
    @keyword(name="Tun command execution")
    ###############################################################################################################
    
    def tun_command_execution(self, *args, **kwargs):
        banner("Tun command execution")
        self._load_kwargs(kwargs)
        try:
            if self.restart == None:
                cmd= "ip addr | grep tun"
                
                tun_cmd_status = easy.cli_run(cmd=cmd, host_ip=self.node_hostip, linux_user=self.username,linux_password=self.password)
                
                serialised_tun_cmd_status = self._serialize_response(time.time(), tun_cmd_status)
                print("serialised_tun_cmd_status is:{}".format(serialised_tun_cmd_status))
                
                self.cmd_output = str(serialised_tun_cmd_status['Result']['stdout']).replace('\n', '').strip()
                
                if self.cmd_output:
                    self.tun_value = re.findall(": (.*): <POINTOPOINT", self.cmd_output)[0]
                    self.peer_ip_address = re.findall("peer (.*)\/", self.cmd_output)[0]
                    self.inet_ip_address = re.findall("inet (.*) peer", self.cmd_output)[0]
                    return self.tun_value, self.peer_ip_address , self.inet_ip_address
                else:
                    return False
            
            elif self.restart == "Restarted":
                cmd= "ip addr | grep tun"
                tun_cmd_status = easy.cli_run(cmd=cmd, host_ip=self.node_hostip, linux_user=self.username,linux_password=self.password)
                
                serialised_tun_cmd_status = self._serialize_response(time.time(), tun_cmd_status)
                print("serialised_tun_cmd_status is:{}".format(serialised_tun_cmd_status))
                
                self.cmd_output = str(serialised_tun_cmd_status['Result']['stdout']).replace('\n', '').strip()
                
                if not self.cmd_output:
                    return True
                else:
                    return False
            else:
                return False
                
                
        
        except Exception as e:
            logger.console("Error in tun_command_execution status: {}".format(e))
    
    ###############################################################################################################
    @keyword(name="Peer IP Address Reachability")
    ###############################################################################################################
    
    def peer_IP_reachability(self, *args, **kwargs):
        banner("Peer IP Address Reachability")
        self._load_kwargs(kwargs)
        try:
            if self.tun_interface_state == "UP": 
                cmd = "ping {} -c 4".format(self.interface_ip)
                peer_ip_reachability_status = easy.cli_run(cmd=cmd, host_ip=self.node_hostip, linux_user=self.username,linux_password=self.password)
                
                serialised_peer_ip_reachability_status = self._serialize_response(time.time(), peer_ip_reachability_status)
                print("serialised_peer_ip_reachability_status is:{}".format(serialised_peer_ip_reachability_status))
                
                self.cmd_output = str(serialised_peer_ip_reachability_status['Result']['stdout']).replace('\n', '').strip()
                
                if ", 0% packet loss" in self.cmd_output:
                    return True
                else:
                    return False
            elif self.tun_interface_state == "DOWN":
                cmd = "ping {} -c 4".format(self.interface_ip)
                peer_ip_reachability_status = easy.cli_run(cmd=cmd, host_ip=self.node_hostip, linux_user=self.username,linux_password=self.password)
                
                serialised_peer_ip_reachability_status = self._serialize_response(time.time(), peer_ip_reachability_status)
                print("serialised_peer_ip_reachability_status is:{}".format(serialised_peer_ip_reachability_status))
                
                self.cmd_output = str(serialised_peer_ip_reachability_status['Result']['stdout']).replace('\n', '').strip()
                
                if ", 100% packet loss" in self.cmd_output:
                    return True
                else:
                    return False
            
            else:
                return False
        
        except Exception as e:
            logger.console("Error in peer_IP_reachability status: {}".format(e))
            
    ###############################################################################################################
    @keyword(name="Verify Profile_node.json")
    ###############################################################################################################
    
    def verify_profile_node_json(self, *args, **kwargs):
        banner("Verify Profile_node.json")
        '''args: hostip, node_hostip
        '''
        verification_status = []

        self._load_kwargs(kwargs)
        try:
            cmd= "sudo cat /opt/platina/pcc/etc/profile_node.json"
            profile_node_json_status = easy.cli_run(cmd=cmd, host_ip=self.node_hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_profile_node_json_status = self._serialize_response(time.time(), profile_node_json_status)
            print("serialised_profile_node_json_status is:{}".format(serialised_profile_node_json_status))
            
            self.cmd_output = str(serialised_profile_node_json_status['Result']['stdout']).replace('\n', '').strip()
            
            
            profile_node_json_output = json.loads(self.cmd_output)
            
            brokerUri_verification = [True if str(i)+":9092" in profile_node_json_output["brokerUri"] else False for i in self.list_of_nodes]
            brokerUri_verification_result = len(brokerUri_verification) > 0 and all(elem == brokerUri_verification[0] for elem in brokerUri_verification)
            
            if brokerUri_verification_result == True:
                verification_status.append("True")
            else:
                verification_status.append("False")
            
            schemaRegistryUri_verification = [True if "http://"+str(i)+":8081" in profile_node_json_output["schemaRegistryUri"] else False for i in self.list_of_nodes]
            schemaRegistryUri_verification_result = len(schemaRegistryUri_verification) > 0 and all(elem == schemaRegistryUri_verification[0] for elem in schemaRegistryUri_verification)
            
            if schemaRegistryUri_verification_result == True:
                verification_status.append("True")
            else:
                verification_status.append("False")
            
            if profile_node_json_output["nodeAddress"] == self.node_hostip:
                verification_status.append("True")
            else:
                verification_status.append("False")
            
            if profile_node_json_output["pccgwAddress"] == self.hostip:
                verification_status.append("True")
            else:
                verification_status.append("False")
            
            result = len(verification_status) > 0 and all(elem == verification_status[0] for elem in verification_status)
            
            if result == True:
                return True
            else:
                return False
        
        except Exception as e:
            logger.console("Error in verify_profile_node_json status: {}".format(e))
            
    ###############################################################################################################
    @keyword(name="Tun value validation")
    ###############################################################################################################
    
    def validate_tun_value(self, *args, **kwargs):
        banner("Tun value validation")
        '''args: hostip
        '''
        self._load_kwargs(kwargs)
        try:
            cmd= "docker exec pccserver ip addr|grep tun"
            find_tun_value = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_find_tun_value = self._serialize_response(time.time(), find_tun_value)
            print("serialised_find_tun_value is:{}".format(serialised_find_tun_value))
            
            self.cmd_output = str(serialised_find_tun_value['Result']['stdout']).replace('\n', '').strip()
            
            tun_value_to_be_validated = re.findall(": (.*): <POINTOPOINT", self.cmd_output)
            
            if self.tun_value in tun_value_to_be_validated:
                return True
            else:
                return False
                
        except Exception as e:
            logger.console("Error in validate_tun_value status: {}".format(e))
            
    ###############################################################################################################
    @keyword(name="Kafka memory validation")
    ###############################################################################################################
    
    def kafka_memory_validation(self, *args, **kwargs):
        banner("Kafka memory validation")
        '''args: hostip
        '''
        self._load_kwargs(kwargs)
        logger.console("self.tun_interface_state: {}".format(self.tun_interface_state))
        try:
            if self.tun_interface_state == "UP":          
                cmd= "docker exec kafka kafka-avro-console-consumer --topic memory --bootstrap-server localhost:9092|head -20|grep {}|wc -l".format(self.host_name)
                kafka_memory_validation = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
                
                serialised_kafka_memory_validation = self._serialize_response(time.time(), kafka_memory_validation)
                print("serialised_kafka_memory_validation is:{}".format(serialised_kafka_memory_validation))
                
                self.cmd_output = str(serialised_kafka_memory_validation['Result']['stdout']).replace('\n', '').strip()
                
                if int(self.cmd_output) > 0:
                    return True
                else:
                    return False
            
            elif self.tun_interface_state == "DOWN":
                cmd= "docker exec kafka kafka-avro-console-consumer --topic memory --bootstrap-server localhost:9092|head -20|grep {}|wc -l".format(self.host_name)
                kafka_memory_validation = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
                
                serialised_kafka_memory_validation = self._serialize_response(time.time(), kafka_memory_validation)
                print("serialised_kafka_memory_validation is:{}".format(serialised_kafka_memory_validation))
                
                self.cmd_output = str(serialised_kafka_memory_validation['Result']['stdout']).replace('\n', '').strip()
                
                if int(self.cmd_output) == 0:
                    return True
                else:
                    return False
                    
            else:
                return False
            
                    
                
        except Exception as e:
            logger.console("Error in kafka_memory_validation status: {}".format(e))
            
    ###############################################################################################################
    @keyword(name="Kafka CPU validation")
    ###############################################################################################################
    
    def kafka_CPU_validation(self, *args, **kwargs):
        banner("Kafka CPU validation")
        '''args: hostip
        '''
        self._load_kwargs(kwargs)
        logger.console("self.tun_interface_state: {}".format(self.tun_interface_state))
        try:
            if self.tun_interface_state == "UP":
                cmd = "docker exec kafka kafka-avro-console-consumer --topic cpu --bootstrap-server localhost:9092|head -20|grep {}|wc -l".format(self.host_name)
                kafka_CPU_validation = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
                
                serialised_kafka_CPU_validation = self._serialize_response(time.time(), kafka_CPU_validation)
                print("serialised_kafka_CPU_validation is:{}".format(serialised_kafka_CPU_validation))
                
                self.cmd_output = str(serialised_kafka_CPU_validation['Result']['stdout']).replace('\n', '').strip()
                
                if int(self.cmd_output) > 0:
                    return True
                else:
                    return False
                    
            elif self.tun_interface_state == "DOWN":
                cmd = "docker exec kafka kafka-avro-console-consumer --topic cpu --bootstrap-server localhost:9092|head -20|grep {}|wc -l".format(self.host_name)
                kafka_CPU_validation = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
                
                serialised_kafka_CPU_validation = self._serialize_response(time.time(), kafka_CPU_validation)
                print("serialised_kafka_CPU_validation is:{}".format(serialised_kafka_CPU_validation))
                
                self.cmd_output = str(serialised_kafka_CPU_validation['Result']['stdout']).replace('\n', '').strip()
                
                if int(self.cmd_output) == 0:
                    return True
                else:
                    return False   
            else:
                return False
            
        except Exception as e:
            logger.console("Error in kafka_CPU_validation status: {}".format(e))
            
    ###############################################################################################################
    @keyword(name="Tunnel interface switch from PCC")
    ###############################################################################################################
    
    def tunnel_interface_switch(self, *args, **kwargs):
        banner("Tunnel interface switch from PCC")
        self._load_kwargs(kwargs)
        logger.console("Kwargs are : {}".format(kwargs))
        
        try:
            cmd= "docker exec pccserver ifconfig {} {}".format(self.tun_value, self.tun_switch)
            tunnel_down_cmd = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            cmd= "docker exec pccserver ip addr|grep tun"
            tunnel_down_status = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_tunnel_down_status = self._serialize_response(time.time(), tunnel_down_status)
            print("serialised_tunnel_down_status is:{}".format(serialised_tunnel_down_status))
            
            self.cmd_output = str(serialised_tunnel_down_status['Result']['stdout']).replace('\n', '').strip()
            
            self.list_tun_interface_state = re.findall("NOARP,(.*),LOWER", self.cmd_output)
            if self.list_tun_interface_state:
                self.tun_interface_state = self.list_tun_interface_state[0]
            else:
                self.tun_interface_state = "DOWN"
            if self.tun_switch == "down":
                if self.tun_interface_state == "DOWN":
                    return True
                else:
                    return False
                    
            elif self.tun_switch == "up":
                if str(self.tun_interface_state) == "UP":
                    return True
                else:
                    return False
            
            else:
                print("Didn't get the tunnel switch value - Please provide up or down as args")
                logger.console("Didn't get the tunnel switch value - Please provide up or down as args")
                return False
                
        except Exception as e:
            logger.console("Error in tunnel_interface_switch status: {}".format(e))
            
            
    ###############################################################################################################
    @keyword(name="Tunnel interface switch from invader")
    ###############################################################################################################
    
    def tunnel_interface_switch_invader(self, *args, **kwargs):
        banner("Tunnel interface switch from invader")
        self._load_kwargs(kwargs)
        logger.console("Kwargs are : {}".format(kwargs))
        
        try:
            cmd= "sudo ifconfig {} {}".format(self.tun_value, self.tun_switch)
            tunnel_down_cmd = easy.cli_run(cmd=cmd, host_ip=self.node_hostip, linux_user=self.username,linux_password=self.password)
            
            cmd= "sudo ip addr|grep tun"
            tunnel_down_status = easy.cli_run(cmd=cmd, host_ip=self.node_hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_tunnel_down_status = self._serialize_response(time.time(), tunnel_down_status)
            print("serialised_tunnel_down_status is:{}".format(serialised_tunnel_down_status))
            
            self.cmd_output = str(serialised_tunnel_down_status['Result']['stdout']).replace('\n', '').strip()
            
            self.list_tun_interface_state = re.findall("NOARP,(.*),LOWER", self.cmd_output)
            if self.list_tun_interface_state:
                self.tun_interface_state = self.list_tun_interface_state[0]
            else:
                self.tun_interface_state = "DOWN"
            
            if self.tun_switch == "down":
                if self.tun_interface_state == "DOWN":
                    return True
                else:
                    return False
                    
            elif self.tun_switch == "up":
                if str(self.tun_interface_state) == "UP":
                    return True
                else:
                    return False
            
            else:
                print("Didn't get the tunnel switch value - Please provide up or down as args")
                logger.console("Didn't get the tunnel switch value - Please provide up or down as args")
                return False
                
        except Exception as e:
            logger.console("Error in tunnel_interface_switch_invader status: {}".format(e))
    
    '''        
    ###############################################################################################################
    @keyword(name="Restart Tunnel interface from invader")
    ###############################################################################################################
    
    def restart_tunnel_interface_from_invader(self, *args, **kwargs):
        banner("Restart Tunnel interface from invader")
        self._load_kwargs(kwargs)
        logger.console("Kwargs are : {}".format(kwargs))
        verification_status = []
        try:
            verification_status_during_restart = []
            cmd= "sudo ip link delete dev {}".format(self.tun_value)
            tunnel_restart_cmd = easy.cli_run(cmd=cmd, host_ip=self.node_hostip, linux_user=self.username,linux_password=self.password)
            
            time.sleep(2)
            
            #Verification steps during Tunnel restart 
            self.tun_interface_state = "DOWN"
            kafka_memory_status = self.kafka_memory_validation(**kwargs)
            
            if kafka_memory_status == True:
                verification_status_during_restart.append("True")
            else:
                verification_status_during_restart.append("False")
                
            kafka_CPU_status = self.kafka_CPU_validation(**kwargs)
            
            if kafka_CPU_status == True:
                verification_status_during_restart.append("True")
            else:
                verification_status_during_restart.append("False")
            
            if kafka_memory_status == True:
                verification_status_during_restart.append("True")
            else:
                verification_status_during_restart.append("False")
                
            peer_IP_reachability_status = self.peer_IP_reachability(**kwargs)
            
            if peer_IP_reachability_status == True:
                verification_status_during_restart.append("True")
            else:
                verification_status_during_restart.append("False")
            print("Verification status during tunnel restart: {}".format(verification_status_during_restart))
            
            result = len(verification_status_during_restart) > 0 and all(elem == verification_status_during_restart[0] for elem in verification_status_during_restart)
            
            if result == True:
                verification_status.append("True")
            else:
                verification_status.append("False") 
                               
            time.sleep(30)
            
            verification_status_after_restart = []
            cmd= "sudo ip addr|grep tun"
            tunnel_down_status = easy.cli_run(cmd=cmd, host_ip=self.node_hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_tunnel_down_status = self._serialize_response(time.time(), tunnel_down_status)
            print("serialised_tunnel_down_status is:{}".format(serialised_tunnel_down_status))
            
            self.cmd_output = str(serialised_tunnel_down_status['Result']['stdout']).replace('\n', '').strip()
            
            self.tun_interface_state = re.findall("NOARP,(.*),LOWER", self.cmd_output)[0] 
            
            #Verification steps after Tunnel restart
            
            kafka_memory_status = self.kafka_memory_validation(**kwargs)
            
            if kafka_memory_status == True:
                verification_status_after_restart.append("True")
            else:
                verification_status_after_restart.append("False")
                
            kafka_CPU_status = self.kafka_CPU_validation(**kwargs)
            
            if kafka_CPU_status == True:
                verification_status_after_restart.append("True")
            else:
                verification_status_after_restart.append("False")
            
            if kafka_memory_status == True:
                verification_status_after_restart.append("True")
            else:
                verification_status_after_restart.append("False")
                
            peer_IP_reachability_status = self.peer_IP_reachability(**kwargs)
            
            if peer_IP_reachability_status == True:
                verification_status_after_restart.append("True")
            else:
                verification_status_after_restart.append("False")
            
            print("Verification status after tunnel restart: {}".format(verification_status_after_restart))
            
            result = len(verification_status_after_restart) > 0 and all(elem == verification_status_after_restart[0] for elem in verification_status_after_restart)
            
            if result == True:
                verification_status.append("True")
            else:
                verification_status.append("False")
            
            
            
            print("Verification status: {}".format(verification_status))
            result = len(verification_status) > 0 and all(elem == verification_status[0] for elem in verification_status)
            if result == True:
                return True
            else:
                return False
                    
        except Exception as e:
            logger.console("Error in tunnel_interface_switch_invader status: {}".format(e))
            
    ###############################################################################################################
    @keyword(name="Kill Tunnel interface from PCC")
    ###############################################################################################################
    
    def kill_tunnel_interface_from_pcc(self, *args, **kwargs):
        banner("Kill Tunnel interface from PCC")
        self._load_kwargs(kwargs)
        logger.console("Kwargs are : {}".format(kwargs))
        verification_status = []
        try:
            verification_status_during_kill = []
            cmd= "docker exec pccserver ps aux | grep ssh | grep -ie {} | awk '{print $2}'| xargs kill -9".format(self.tun_value)
            tunnel_kill_cmd = easy.cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            #Verification steps during Tunnel operation kill 
            self.tun_interface_state = "DOWN"
            kafka_memory_status = self.kafka_memory_validation(**kwargs)
            
            if kafka_memory_status == True:
                verification_status_during_kill.append("True")
            else:
                verification_status_during_kill.append("False")
                
            kafka_CPU_status = self.kafka_CPU_validation(**kwargs)
            
            if kafka_CPU_status == True:
                verification_status_during_kill.append("True")
            else:
                verification_status_during_kill.append("False")
            
            if kafka_memory_status == True:
                verification_status_during_kill.append("True")
            else:
                verification_status_during_kill.append("False")
                
            peer_IP_reachability_status = self.peer_IP_reachability(**kwargs)
            
            if peer_IP_reachability_status == True:
                verification_status_during_kill.append("True")
            else:
                verification_status_during_kill.append("False")
            print("Verification status during tunnel kill: {}".format(verification_status_during_kill))
                            
            result = len(verification_status_during_kill) > 0 and all(elem == verification_status_during_kill[0] for elem in verification_status_during_kill)
            
            if result == True:
                verification_status.append("True")
            else:
                verification_status.append("False")
            
            time.sleep(30)
            
            verification_status_after_kill =[]
            
            cmd= "docker exec pccserver ip addr|grep tun"
            grep_tun_status = easy.cli_run(cmd=cmd, host_ip=self.node_hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_grep_tun_status = self._serialize_response(time.time(), grep_tun_status)
            print("serialised_grep_tun_status is:{}".format(serialised_grep_tun_status))
            
            self.cmd_output = str(serialised_grep_tun_status['Result']['stdout']).replace('\n', '').strip()
            
            self.tun_interface_state = re.findall("state (.*) group", self.cmd_output)[0] 
            
            #Verification steps after Tunnel operation kill
            
            kafka_memory_status = self.kafka_memory_validation(**kwargs)
            
            if kafka_memory_status == True:
                verification_status_after_kill.append("True")
            else:
                verification_status_after_kill.append("False")
                
            kafka_CPU_status = self.kafka_CPU_validation(**kwargs)
            
            if kafka_CPU_status == True:
                verification_status_after_kill.append("True")
            else:
                verification_status_after_kill.append("False")
            
            if kafka_memory_status == True:
                verification_status_after_kill.append("True")
            else:
                verification_status_after_kill.append("False")
                
            peer_IP_reachability_status = self.peer_IP_reachability(**kwargs)
            
            if peer_IP_reachability_status == True:
                verification_status_after_kill.append("True")
            else:
                verification_status_after_kill.append("False")
            
            print("Verification status after tunnel kill: {}".format(verification_status_after_restart))
            
            result = len(verification_status_after_kill) > 0 and all(elem == verification_status_after_kill[0] for elem in verification_status_after_kill)
            
            if result == True:
                verification_status.append("True")
            else:
                verification_status.append("False")
            
            print("Verification status: {}".format(verification_status))
            result = len(verification_status) > 0 and all(elem == verification_status[0] for elem in verification_status)
            if result == True:
                return True
            else:
                return False
                    
        except Exception as e:
            logger.console("Error in kill_tunnel_interface_from_pcc status: {}".format(e))
     '''       
    
            
    
            
            
            
            
            
            
            
        
                
            
    
            
    
            
    
            
    
    
    
            
    
            
    
        
            
            
            
            
            
            
            
        
                
            
            
            
            
            
                
    
            
                     
    
            
    
