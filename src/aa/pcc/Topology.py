import re
import time
import json
import ast

from robot.api.deco import keyword
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from platina_sdk import pcc_easy_api as easy

from aa.common.Utils import banner, trace, pretty_print, cmp_json
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase

PCCSERVER_TIMEOUT = 60*5

class Topology(AaBase):
    
    def __init__(self):
        
        self.interface = None
        self.invaders_hostip = None
        self.servers_hostip = None
        self.username = "pcc"
        self.password = "cals0ft"
        
        
    ###########################################################################
    @keyword(name="PCC.Show neighbors on Invader")
    ###########################################################################
    def show_neighbors_on_invader(self,*args,**kwargs):
        banner("PCC.Show neighbors on Invader")
        self._load_kwargs(kwargs)
        
        try:
            invader_interfaces = []
            for hostip in ast.literal_eval(self.invaders_hostip):
                cmd= "sudo lldpcli show neighbors |grep xeth"
                command_execution = easy.cli_run(cmd=cmd, host_ip=hostip, linux_user=self.username,
                                              linux_password=self.password)
                
                serialised_command_execution = self._serialize_response(time.time(), command_execution)
                logger.console("Serialised: {}".format(serialised_command_execution))
                
                cmd_output = str(serialised_command_execution['Result']['stdout']).strip()
                
                print("Show neighbor on Invader output : {}".format(cmd_output))
                
                interfaces = re.findall("\W(xeth(.*)), via\W",cmd_output)
                for interface in interfaces:
                    invader_interfaces.append(interface[0])
            
            banner("Invader interfaces : {}".format(set(invader_interfaces)))          
            return invader_interfaces
            
        except Exception as e:
            logger.console("Error in Show neighbors on Invader: " + e)
            
    ###########################################################################
    @keyword(name="PCC.Show neighbors on Server")
    ###########################################################################
    def show_neighbors_on_server(self,*args,**kwargs):
        banner("PCC.Show neighbors on Server")
        self._load_kwargs(kwargs)
        
        try:
            server_interfaces = []
            for hostip in ast.literal_eval(self.servers_hostip):
                cmd= "sudo lldpcli show neighbors |grep xeth"
                command_execution = easy.cli_run(cmd=cmd, host_ip=hostip, linux_user=self.username,
                                              linux_password=self.password)
                
                serialised_command_execution = self._serialize_response(time.time(), command_execution)
                logger.console("Serialised: {}".format(serialised_command_execution))
                cmd_output = str(serialised_command_execution['Result']['stdout']).strip()
                
                print("Show neighbor on Server output : {}".format(cmd_output))
                
                interfaces = re.findall("\W(xeth(.*))\n\W",cmd_output)
                for interface in interfaces:
                    server_interfaces.append(interface[0])
            banner("Server interfaces : {}".format(set(server_interfaces)))        
            return server_interfaces
            
        except Exception as e:
            logger.console("Error in Show neighbors on Server: " + e)
            
    
    ###########################################################################
    @keyword(name="PCC.Verify LLDP Neighbors")
    ###########################################################################
    def verify_neighbors(self,*args,**kwargs):
        banner("PCC.Verify LLDP Neighbors")
        self._load_kwargs(kwargs)     
        
        server_interfaces = self.show_neighbors_on_server(**kwargs)
        invader_interfaces = self.show_neighbors_on_invader(**kwargs)
        
        result = set(server_interfaces).issubset(set(invader_interfaces))
        if result:
            return "OK"
            
        else:
            return "Error: LLDP Neighbors are not correct"
            
    
    
         
