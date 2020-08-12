import re
import time
import json

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy

from aa.common.Utils import banner, trace, pretty_print, cmp_json
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase
from aa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60*10

class NetworkManager(AaBase):

    """ 
    Network Manager
    """

    def __init__(self):

        # Robot arguments definitions
        self.id=None
        self.name=None
        self.nodes=[]
        self.nodes_ip=[]
        self.controlCIDR=None
        self.controlCIDRId=None
        self.dataCIDR=None
        self.dataCIDRId=None
        self.igwPolicy=None
        self.user="pcc"
        self.password="cals0ft"
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Get Network Manager Id")
    ###########################################################################
    def get_network_clusters_id(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Get Network Manager Id") 
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        network_id = easy.get_network_clusters_id_by_name(conn,self.name)
        return network_id

    ###########################################################################
    @keyword(name="PCC.Network Manager Create")
    ###########################################################################
    def network_manager_create(self, *args, **kwargs):
        banner("PCC.Create Network Manager")
        self._load_kwargs(kwargs)

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
            
        tmp_node=[]
        for node_name in eval(str(self.nodes)):
            print("Getting Node Id for -"+str(node_name))
            node_id=easy.get_node_id_by_name(conn,node_name)
            print(" Node Id retrieved -"+str(node_id))
            tmp_node.append({"id":node_id})
        self.nodes=tmp_node
        
        if self.controlCIDR:
            self.controlCIDRId=easy.get_subnet_id_by_name(conn,self.controlCIDR)

        if self.dataCIDR:
            self.dataCIDRId=easy.get_subnet_id_by_name(conn,self.dataCIDR)
       
        payload = {
            "name": self.name,
            "nodes": self.nodes,
            "controlCIDRId":self.controlCIDRId,
            "dataCIDRId":self.dataCIDRId,
            "igwPolicy":self.igwPolicy
        }

        print("Payload:-"+str(payload))
        return pcc.add_network_cluster(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Network Manager Update")
    ###########################################################################
    def network_manager_update(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(kwargs))
        banner("PCC.Network Manager Update")
        
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            print("[update_cluster] EXCEPTION: %s" % str(e))
            raise Exception(e)
 
        tmp_node=[]
        for node_name in eval(str(self.nodes)):
            print("Getting Node Id for -"+str(node_name))
            node_id=easy.get_node_id_by_name(conn,node_name)
            print(" Node Id retrieved -"+str(node_id))
            tmp_node.append({"id":node_id})
        self.nodes=tmp_node
        
        if self.controlCIDR:
            self.controlCIDRId=easy.get_subnet_id_by_name(conn,self.controlCIDR)

        if self.dataCIDR:
            self.dataCIDRId=easy.get_subnet_id_by_name(conn,self.dataCIDR)
       
        payload ={
            "id":self.id,
            "name": self.name,
            "nodes": self.nodes,
            "controlCIDRId":self.controlCIDRId,
            "dataCIDRId":self.dataCIDRId,
            "igwPolicy":self.igwPolicy
            }
            
        print("Payload:"+str(payload))
   
        return pcc.modify_network_cluster(conn, payload)
    
    ###########################################################################
    @keyword(name="PCC.Network Manager Delete")
    ###########################################################################
    def delete_network_cluster_by_id(self, *args, **kwargs):
        banner("PCC.Network Manager Delete")
        self._load_kwargs(kwargs)

        if self.name == None:
            return {"Error": "[PCC.Network Manager Delete]: Name of the Network Manager is not specified."}

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
            
        self.id=easy.get_network_clusters_id_by_name(conn,self.name)

        return pcc.delete_network_cluster_by_id(conn, str(self.id))

    ###########################################################################
    @keyword(name="PCC.Network Manager Refresh")
    ###########################################################################
    def refresh_network_cluster_by_id(self, *args, **kwargs):
        banner("PCC.Network Manager Refresh")
        self._load_kwargs(kwargs)

        if self.name == None:
            return {"Error": "[PCC.Network Manager Delete]: Name of the Network Manager is not specified."}

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
            
        self.id=easy.get_network_clusters_id_by_name(conn,self.name)

        return pcc.refresh_network_cluster_by_id(conn, str(self.id))

    ###########################################################################
    @keyword(name="PCC.Wait Until Network Manager Ready")
    ###########################################################################
    def wait_until_network_manager_ready(self, *args, **kwargs):
        banner("PCC.Wait Until Network Manager Ready")
        self._load_kwargs(kwargs)

        if self.name == None:
            return None
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        network_ready = False
        timeout = time.time() + PCCSERVER_TIMEOUT
  
        while network_ready == False:
            response = pcc.get_network_clusters(conn)
            for data in get_response_data(response):
                if str(data['name']).lower() == str(self.name).lower():
                    print("Response To Look :-"+str(data))
                    if data['progressPercentage'] == 100:
                        network_ready = True
                    elif re.search("failed",str(data['deploy_status'])):
                        return "Error"
            if time.time() > timeout:
                raise Exception("[PCC.Wait Until Network Manager Ready] Timeout")
            trace("  Waiting until network manager: %s is Ready, currently: %s" % (data['name'], data['progressPercentage']))
            time.sleep(5)
        return "OK"


    ###########################################################################
    @keyword(name="PCC.Wait Until Network Manager Deleted")
    ###########################################################################
    def wait_until_network_manager_deleted(self, *args, **kwargs):
        banner("PCC.Wait Until Network Manager Deleted")
        self._load_kwargs(kwargs)

        if self.name == None:
            return {"Error": "[PCC.Wait Until Network Manager Deleted]: Name of the cluster is not specified."}

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        Id_found_in_list_of_networks = True
        timeout = time.time() + PCCSERVER_TIMEOUT

        self.id=easy.get_network_clusters_id_by_name(conn,self.name)

        while Id_found_in_list_of_networks == True:
            Id_found_in_list_of_networks = False
            response = pcc.get_network_clusters(conn)
            for data in get_response_data(response):
                if str(data['id']) == str(self.id):
                    Id_found_in_list_of_networks = True
                elif re.search("failed",str(data['deploy_status'])):
                    return "Error"            
            if time.time() > timeout:
                raise Exception("[PCC.Wait Until Network Manager Deleted] Timeout")
            if Id_found_in_list_of_networks:
                trace("  Waiting until n: %s is deleted. Timeout in %.1f seconds." % 
                       (data['name'], timeout-time.time()))
                time.sleep(5)
        return "OK"


    ###########################################################################
    @keyword(name="PCC.Network Manager Delete All")
    ###########################################################################
    def delete_all_network_manager(self, *args, **kwargs):
        banner("PCC.Network Manager Delete All")
        self._load_kwargs(kwargs)

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        
        response = pcc.get_network_clusters(conn)
        for data in get_response_data(response):
            print("Response To Look :-"+str(data))
            print("Network Manager {} and id {} is deleting....".format(data['name'],data['id']))
            self.id=data['id']
            del_response=pcc.delete_network_cluster_by_id(conn, str(self.id))
            if del_response['Result']['status']==200:
                del_check=self.wait_until_network_manager_deleted()
                if del_check=="OK":
                    print("Network Manager {} is deleted sucessfully".format(data['name']))
                    return "OK"
                else:
                    print("Network Manager {} unable to delete".format(data['name']))
                    return "Error"
            else:
                print("Delete Response:"+str(del_response))
                print("Issue: Not getting 200 response back")
                return "Error"

        return "OK"

    ###########################################################################
    @keyword(name="PCC.Verify Default IgwPolicy BE")
    ###########################################################################
    def verify_igwpolicy(self, *args, **kwargs):
        banner("PCC.Verify Default IgwPolicy BE")
        self._load_kwargs(kwargs)
        
        cmd="sudo ip addr sh |grep 172.17|rev | cut -d' ' -f1 |rev"
        for ip in eval(str(self.nodes)):
            print("Node:"+str(ip))
            interface=cli_run(ip,self.user,self.password,cmd)
            print("Cmd Interface:"+str(interface))
            interface=str(self._serialize_response(time.time(),interface)['Result']['stdout']).strip()
            print("----------------------------------------------")
            print("Interface:"+str(interface))
            ping_cmd="ping -I "+str(interface)+" 8.8.8.8| head -3"
            print("Ping Cmd:-"+str(ping_cmd))
            ping_output=cli_run(ip,self.user,self.password,ping_cmd)        
            ping_output=self._serialize_response(time.time(),ping_output)['Result']['stdout']  
            print("----------------------------------------------")
            print("Ping Output:"+str(ping_output))
            if re.search("time=",str(ping_output), re.IGNORECASE):    
                continue  
            elif re.search("Unreachable",str(ping_output), re.IGNORECASE):
                print("Ping Unreachable for "+ str(ip))
                return "Error"     
            else:
                print("Could not verify")
                return "Error"
            
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Network Manager Verify BE")
    ###########################################################################
    def network_manager_verify_be(self,**kwargs):
        banner("PCC.Network Manager Verify BE")
        self._load_kwargs(kwargs)
        
        success_chk=[]
        failed_chk=[]
        cmd="sudo vtysh -c 'sh ip ospf nei'  && ip addr sh control0|wc -l"
        for ip in eval(str(self.nodes_ip)):
            print("Network verification for {} is in progress ...".format(ip))
            trace("Network verification for {} is in progress ...".format(ip))
            network_check=cli_run(ip,self.user,self.password,cmd)
            if re.search(self.dataCIDR,str(network_check)):
                success_chk.append(ip)         
            else:
                failed_chk.append(ip)
                    
        if len(success_chk)==len(eval(str(self.nodes_ip))):
            print("Backend verification successfuly done for : {}".format(success_chk))
            return "OK"
                                 
        if failed_chk:  
            print("Nework is not properly set for {}".format(failed_chk))     
            return "Error"
        else:
            return "OK"