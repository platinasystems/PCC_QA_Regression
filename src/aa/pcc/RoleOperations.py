import time
import os
import re
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy
from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data, get_result
from aa.common.AaBase import AaBase
from aa.common.Cli import cli_run

PCC_TIMEOUT = 60*15  # 15 min

class RoleOperations(AaBase):
    """ 
    RoleOperations
    """

    def __init__(self):
        self.nodes=[]
        self.roles=[]
        self.Id=None
        self.Host=None
        self.node_name=None
        self.user="pcc"
        self.password="cals0ft"
        self.nodes_ip=[]
        self.tags=None

    ###########################################################################
    @keyword(name="PCC.Add and Verify Roles On Nodes")
    ###########################################################################
    def add_and_verify_roles_on_nodes(self, *args, **kwargs):
        """
        Add Roles and Verify to Nodes
        [Args]
            (list) nodes: name of pcc nodes
            (list) roles: name of roles
        [Returns]
            (dict) Response: Add Node Role response (includes any errors)
        """
        self._load_kwargs(kwargs)
        print("kwargs:-"+str(kwargs))
        banner("PCC.Add and Verify Roles On Nodes")
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        payload = None
        tmp_id = None
        
        for node in eval(str(self.nodes)):
            role_ids=[]
            response = pcc.get_nodes(conn)
            for data in get_response_data(response):
                self.Id=data['Id']
                self.Host=data['Host']
                if str(data['Name']).lower() == str(node).lower():
                    for role in eval(str(self.roles)):
                        tmp_id=easy.get_node_role_id_by_name(conn,str(role))
                        print("Role-Id:-"+str(role)+"-"+str(tmp_id))
                        role_ids.append(tmp_id)
                    payload={
                             "Id":self.Id,
                             "Host":self.Host,
                             "roles":role_ids
                             }
                    print("Payload:-"+str(payload))
                    api_response=pcc.modify_node(conn, payload)
                    print("API Response:-"+str(api_response))
                    if api_response['Result']['status']==200:
                        continue
                    else:
                        return api_response
        
        return "OK"
                      
    ###########################################################################
    @keyword(name="PCC.Add and Verify Tags On Nodes")
    ###########################################################################
    def add_and_verify_tags_on_nodes(self, *args, **kwargs):
        """
        Add Roles and Verify Tags to Nodes
        [Args]
            (list) nodes: name of pcc nodes
            (list) tags: name of tags
        [Returns]
            (dict) Response: Add Node tags response (includes any errors)
        """
        self._load_kwargs(kwargs)
        print("kwargs:-"+str(kwargs))
        banner("PCC.Add and Verify Tags On Nodes")
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        for node in eval(str(self.nodes)):
            response = pcc.get_nodes(conn)
            for data in get_response_data(response):
                self.Id=data['Id']
                self.Host=data['Host']
                if str(data['Name']).lower() == str(node).lower():
                    payload={
                             "Id":self.Id,
                             "Host":self.Host,
                             "tags":eval(str(self.tags))
                             }
                    print("Payload:-"+str(payload))
                    api_response=pcc.modify_node(conn, payload)
                    print("API Response:-"+str(api_response))
                    if api_response['Result']['status']==200:
                        continue
                    else:
                        return api_response       
        return "OK"                      

    ###########################################################################
    @keyword(name="PCC.Wait Until Roles Ready On Nodes")
    ###########################################################################
    def wait_until_node_ready(self, *args, **kwargs):
        """
        Wait Until Node Ready
        [Args]
            (str) Name: Name of the Node 
        [Returns]
            (str) Ok 
            (str) Error response: If Exception occured
        """
        self._load_kwargs(kwargs)
        print("kwargs:-"+str(kwargs))
        banner("PCC.Wait Until Roles Ready On Nodes")

        ready = False
        status=None

        timeout = time.time() + PCC_TIMEOUT
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        time.sleep(10)
        while not ready:
            ready = False
            node_list = pcc.get_nodes(conn)['Result']['Data']
            tmp_response=None
            for node in node_list:
                if str(node['Name']).lower() == str(self.node_name).lower():
                    tmp_response=node
                    status=node['provisionStatus']
                    if node['provisionStatus'] == 'Ready':
                        print("Node Response:-"+str(node))
                        ready = True
                        return "OK"
                    elif re.search("failed",str(node['provisionStatus'])):
                        print("Node Response:-"+str(node))
                        return "Failed"
            if time.time() > timeout:
                print("Node Response:"+str(tmp_response))
                return {"Error": "Timeout"}
            if not ready:
                trace("Waiting until node: %s is Ready, currently status: %s" % (self.node_name, status))
                time.sleep(5)

        

    ###########################################################################
    @keyword(name="PCC.Delete and Verify Roles On Nodes")
    ###########################################################################
    def delete_and_verify_roles_on_nodes(self, *args, **kwargs):
        """
        Delete Roles and Verify to Nodes
        [Args]
            (list) nodes: name of pcc nodes
            (list) roles: name of roles
        [Returns]
            (dict) Response: Add Node Role response (includes any errors)
        """
        self._load_kwargs(kwargs)
        print("kwargs:-"+str(kwargs))
        banner("PCC.Delete and Verify Roles On Nodes")
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        payload=None
        tmp_id=None
        
        for node in eval(str(self.nodes)):
            role_ids=[]
            response = pcc.get_nodes(conn)
            for data in get_response_data(response):
                self.Id=data['Id']
                role_ids=data['roles']          
                if str(data['Name']).lower() == str(node).lower():
                    print("Role_Ids_On_Node:-"+str(role_ids))
                    if role_ids:
                        for role in eval(str(self.roles)):
                            tmp_id=easy.get_node_role_id_by_name(conn,str(role))
                            print("Role-Id to Remove:-"+str(role)+"-"+str(tmp_id))
                            if tmp_id in eval(str(role_ids)):
                                role_ids.remove(tmp_id)
                        payload={
                                 "Id":self.Id,
                                 "roles":role_ids
                                 }
                        print("Payload:-"+str(payload))
                        api_response=pcc.modify_node(conn, payload)
                        print("API Response:-"+str(api_response))
                        if api_response['Result']['status']==200:
                            continue
                        else:
                            return api_response
                    else:
                        return "OK"       
        return "OK"
        
    ###########################################################################
    @keyword(name="PCC.Maas Verify BE")
    ###########################################################################
    def verify_maas_be(self, *args, **kwargs):  
        banner("PCC.Mass Verify BE")
        self._load_kwargs(kwargs)
        print("Kwargs:-"+str(kwargs))    
        mass_cmd="ps -aef | grep ROOT"        
        time.sleep(30)
        for ip in eval(str(self.nodes_ip)):
            output=cli_run(ip,self.user,self.password,mass_cmd)
            print("Output:"+str(output))
            if re.search("lighttpd.conf",str(output)) and re.search("tinyproxy.conf",str(output)) and re.search("dnsmasq",str(output)):
                continue
            else:
                return None
        return "OK"   
        
    ###########################################################################
    @keyword(name="PCC.Lldp Verify BE")
    ###########################################################################
    def verify_lldp_be(self, *args, **kwargs):
        banner("PCC.Lldp Verify BE")
        self._load_kwargs(kwargs)
        print("Kwargs:-"+str(kwargs))    
        lldp_cmd="sudo service lldpd status"       
        time.sleep(30)
        for ip in eval(str(self.nodes_ip)):
            output=cli_run(ip,self.user,self.password,lldp_cmd)
            print("Output:"+str(output))
            if re.search("running",str(output)):
                continue
            else:
                return None
        return "OK"      
