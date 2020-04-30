import re
import time
import json
import ast

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from platina_sdk import pcc_easy_api as easy

from aa.common.Utils import banner, trace, pretty_print, cmp_json
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase

PCCSERVER_TIMEOUT = 60*5

class Interfaces(AaBase):

    """ 
    Interfaces
    """

    def __init__(self):

        # Robot arguments definitions

        self.node_name=None
        self.assign_ip=[]
        self.interface_name=None
        self.speed=None
        self.autoneg=None
        self.adminstatus=None
        self.managedbypcc=None
        self.cleanUp=None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Set 1D Link")
    ###########################################################################
    def set_link_ip(self,*args,**kwargs):
        banner("PCC.Set 1D Link")
        self._load_kwargs(kwargs)
        print("Kwargs:-"+str(kwargs))
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        if self.speed:
            self.speed=int(self.speed)
            
        if self.managedbypcc:
            self.managedbypcc=ast.literal_eval(str(self.managedbypcc))
        
        count=0
        node_id=easy.get_node_id_by_name(conn,self.node_name)
        response=pcc.get_node_by_id(conn,str(node_id))['Result']['Data']
        print("Response For Node Interfaces:-"+str(response))
        interfaces = eval(str(response))['interfaces']
        if self.interface_name!= None:
            for data in interfaces:
                trace("Interface Data :- %s" % (data))
                print("-----------------")
                print(data['interface']["name"])
                print(self.interface_name)
                print("---------------------")
                if str(data['interface']["name"])==str(self.interface_name):
                    count=1
                    print("inside")
                    ifname = data['interface']["name"]
                    interfaceId = data['interface']["id"]
                    ipv4=data['interface']["ipv4AddressesDesired"]
                    if str(self.cleanUp).lower()=="yes":
                        ipv4=eval(str(self.assign_ip))
                    else:
                        ipv4.extend(eval(str(self.assign_ip)))
                    mac=data['interface']["macAddress"]
                    payload={"ifName":ifname ,"nodeId":node_id,"interfaceId":interfaceId,"speed":self.speed,"ipv4Addresses":ipv4 ,"gateway":"","fecType":"","mediaType":"","macAddress":mac, "adminStatus":self.adminstatus,"management":"","managedByPcc":self.managedbypcc,"mtu":"1500","autoneg":self.autoneg}
                    print("Payload:-"+str(payload))
                    trace("Payload Data :- %s" % (payload))
                    break
        if count==1:
            return pcc.apply_interface(conn,payload)
        else:
            return "Error"

    ###########################################################################
    @keyword(name="PCC.Wait Until Interface Ready")
    ###########################################################################
    def wait_until_interface_ready(self, *args, **kwargs):
        banner("PCC.Wait Until Interface Ready")
        self._load_kwargs(kwargs)
        print("Kwargs:-"+str(kwargs))
        if self.node_name == None:
            return None
        if self.interface_name == None:
            return None
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        inf_ready = False
        timeout = time.time() + PCCSERVER_TIMEOUT

        while inf_ready == False:
            node_id=easy.get_node_id_by_name(conn,self.node_name)
            response=pcc.get_node_by_id(conn,str(node_id))['Result']['Data']
            interfaces = eval(str(response))['interfaces']
            for data in interfaces:
                print(str(data))
                if str(data['interface']["name"])==str(self.interface_name):
                    if str(data['interface']["intfState"]).lower() == "ready":
                        inf_ready = True
                    elif re.search("failed",str(data['interface']["intfState"])):
                        return "Error"
            if time.time() > timeout:
                raise Exception("[PCC.Wait Until Interface Ready] Timeout")
            trace("  Waiting until Interface : is Ready .....")
            time.sleep(5)
        return "OK"
