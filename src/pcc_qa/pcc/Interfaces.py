import re
import time
import json
import ast

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print, cmp_json
from pcc_qa.common.Result import get_response_data
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60*10

class Interfaces(PccBase):

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
        self.host_ip=None
        self.user="pcc"
        self.password="plat1na"
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Interface Set 1D Link")
    ###########################################################################
    def set_link_ip(self,*args,**kwargs):
        banner("PCC.Interface Set 1D Link")
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
                    ifname = data['interface']["name"]
                    interfaceId = data['interface']["id"]
                    mac=data['interface']["macAddress"]
                    ipv4=data['interface']["ipv4AddressesDesired"]
                    if str(self.cleanUp).lower()=="yes":
                        if eval(str(self.assign_ip)):
                            ipv4=eval(str(self.assign_ip))
                        else:
                            ipv4=[""]
                    else:
                        if self.assign_ip:
                            ipv4.extend(eval(str(self.assign_ip)))

                    payload={"ifName":ifname ,"nodeId":node_id,"interfaceId":interfaceId,"speed":self.speed,"ipv4Addresses":ipv4 ,"gateway":"","fecType":"","mediaType":"","macAddress":mac, "adminStatus":self.adminstatus,"management":"","managedByPcc":self.managedbypcc,"mtu":"1500","autoneg":self.autoneg}

                    print("Payload:-"+str(payload))
                    trace("Payload Data :- %s" % (payload))
                    break
        if count==1:
            return pcc.set_interface(conn,payload)
        else:
            return "Error"

    ###########################################################################
    @keyword(name="PCC.Interface Verify PCC")
    ###########################################################################
    def interface_verify_pcc(self,*args,**kwargs):
        banner("PCC.Interface Verify PCC")
        self._load_kwargs(kwargs)
        print("Kwargs:-"+str(kwargs))
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        if self.interface_name==None:
            print("Interface name is Empty or Wrong")
            return "Error"
       
        count=0
        node_id=easy.get_node_id_by_name(conn,self.node_name)
        response=pcc.get_node_by_id(conn,str(node_id))['Result']['Data']
        interfaces = eval(str(response))['interfaces']
        for data in interfaces:
            print("Interface Info:"+str(data))
            print("Name Looking For:"+str(self.interface_name))
            print("Name Find:"+str(data['interface']['name']))
            print("--------------------------")
            if str(data['interface']['name'])==str(self.interface_name):
                ipv4=data['interface']["ipv4AddressesDesired"]
                if ipv4:
                    print("IPV4:"+str(ipv4))
                    for ip in ipv4:
                        for assign_ip in eval(str(self.assign_ip)):
                            if assign_ip==ip:
                                count+=1
                else:
                    if self.cleanUp=='yes':
                        print("Interfaces are in clean state")
                        return "OK"
                    else:
                        print("IP are not assigned to interface")
                        return "Error"                        
        if count==len(eval(str(self.assign_ip))):
            print("Interface are set !!")
            return "OK"
        else:
            print("Could not verify all the interfaces on node")
            return "Error"

    ###########################################################################
    @keyword(name="PCC.Interface Apply")
    ###########################################################################
    def interface_apply(self,*args,**kwargs):
        banner("PCC.Interface Verify PCC")
        self._load_kwargs(kwargs)
        print("Kwargs:-"+str(kwargs))
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        node_id=easy.get_node_id_by_name(conn,self.node_name)
        print("Node ID:"+str(node_id))

        payload={"nodeId":node_id}
        print("Payload:"+str(payload))
        return pcc.apply_interface(conn,payload)

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
        counter=0
        while inf_ready == False:
            counter+=1
            if counter==15 or counter==20 or counter==26:
                print("Interface stucked in updating state, Refreshing interface UI ...")
                refresh=self.interface_apply()
                print("Refresh:"+str(refresh))
            node_id=easy.get_node_id_by_name(conn,self.node_name)
            response=pcc.get_node_by_id(conn,str(node_id))['Result']['Data']
            interfaces = eval(str(response))['interfaces']
            timeout_response=None
            for data in interfaces:
                if str(data['interface']["name"])==str(self.interface_name):
                    timeout_response=data
                    if str(data['interface']["intfState"]).lower() == "ready":
                        print(str(data))
                        inf_ready = True
                    elif re.search("failed",str(data['interface']["intfState"])):
                        print(str(data))
                        return "Error"
            if time.time() > timeout:
                print("Response Before Time Out: "+str(timeout_response))
                raise Exception("[PCC.Wait Until Interface Ready] Timeout")
            trace("  Waiting until Interface : is Ready .....")
            time.sleep(10)
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Set Interface Up")
    ###########################################################################
    def set_interface_up(self, *args, **kwargs):
        banner("PCC.Set Interface Up")
        self._load_kwargs(kwargs)
        
        cmd="sudo ip link set up {}".format(self.interface_name)
        interface_up = cli_run(self.host_ip,self.user,self.password,cmd)
        print("Interface Status:"+str(interface_up))
        check_cmd="sudo ip addr sh {}".format(self.interface_name)
        interface_status=cli_run(self.host_ip,self.user,self.password,check_cmd)
        status=str(self._serialize_response(time.time(),interface_status)['Result']['stdout']).strip()
        print("Interface Status Serialize:"+str(status))
        if re.search("UP",str(status)):    
            return "OK"
        else:
            return "Error"
            
        return "OK"
        
    ###########################################################################
    @keyword(name="PCC.Set Interface Down")
    ###########################################################################
    def set_interface_down(self, *args, **kwargs):
        banner("PCC.Set Interface Down")
        self._load_kwargs(kwargs)
        
        cmd="sudo ip link set down {}".format(self.interface_name)
        interface_down = cli_run(self.host_ip,self.user,self.password,cmd)
        print("Interface Status:"+str(interface_down))
        check_cmd="sudo ip addr sh {}".format(self.interface_name)
        interface_status=cli_run(self.host_ip,self.user,self.password,check_cmd)
        status=str(self._serialize_response(time.time(),interface_status)['Result']['stdout']).strip()
        print("Interface Status Serialize:"+str(status))
        if re.search("DOWN",str(status)):
            return "OK"
        else:
            return "Error"
                
        return "OK"