import re
import time
import ast
from robot.api.deco import keyword
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy

from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase
from aa.common.Cli import cli_run

PCC_TIMEOUT = 60*5  # 5 min

class Nodes(AaBase):
    """ 
    Nodes
    """
    def __init__(self):
        self.Id = None
        self.ClusterId = 0
        self.Host = None
        self.Model = None
        self.Name = None
        self.Names = []
        self.SN = None
        self.Site_Id = 0
        self.Type_Id = 0
        self.adminUser = None
        self.bmc = None
        self.bmcPassword = None
        self.bmcUser = None
        self.bmcUsers = []
        self.bmcKey = None
        self.console = None
        self.interfaces = []
        self.managed = True
        self.owner = 0
        self.roles = []
        self.sshKeys = []
        self.standby = False
        self.tags = []
        self.tenants = []
        self.Vendor = None
        self.Iso_Id = 0
        self.Kernel_Id = 0
        self.hardwareInventoryId = 0
        self.hwAddr = None
        self.provisionStatus = None
        self.ready = True
        self.reimage = True
        self.status = None
        self.payload = None
        self.tenant = None
        self.tenant_id = None
        self.ids = None
        self.IP = None
        self.host_ips = []
        self.user= "pcc"
        self.password= "cals0ft"

        self.interface_name = []
        self.interface_id = []
        self.interface_mac = []
        self.interface_carrierStatus = []
        self.interface_managedByPcc = []
        self.interface_managedByPccDesired = []
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Add Node")
    ###########################################################################
    def add_node(self, *args, **kwargs):
        """
        Add Node to PCC
        [Args]
            (str) Name: Name of the Node
            ...
        [Returns]
            (dict) Response: Add Node response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add Node [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        payload = {
            "Name": self.Name,
            "ClusterId": self.ClusterId,
            "Host": self.Host,  
            "Model": self.Model,
            "SN": self.SN,
            "Site_Id": self.Site_Id,
            "Type_Id": self.Type_Id,
            "Vendor": self.Vendor,
            "adminUser": self.adminUser,
            "bmc": self.bmc,
            "bmcKey": self.bmcKey,
            "bmcPassword": self.bmcPassword,
            "bmcUser": self.bmcUser,
            "bmcUsers": self.bmcUsers,
            "console": self.console,
            "hardwareInventoryId": self.hardwareInventoryId,
            "hwAddr": self.hwAddr,
            "managed": self.managed,
            "owner": self.owner,
            "provisionStatus": self.provisionStatus,
            "ready": self.ready,
            "reimage": self.reimage,
            "roles": self.roles,
            "sshKeys": self.sshKeys,
            "standby": self.standby,
            "status": self.status,
            "tags": self.tags,
            "tenants": self.tenants
        }
        return pcc.add_node(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Get Nodes")
    ###########################################################################
    def get_nodes(self, *args, **kwargs):
        """
        Get Nodes
        [Args]
            None
        [Returns]
            (dict) Response: Get Node response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Nodes ")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_nodes(conn)

    ###########################################################################
    @keyword(name="PCC.Get Node")
    ###########################################################################
    def get_node(self, *args, **kwargs):
        """
        Get Node
        [Args]
            (str) Id
        [Returns]
            (dict) Response: Get Node response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Node")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_node_by_id(conn, self.Id)

    ###########################################################################
    @keyword(name="PCC.Get Node Id")
    ###########################################################################
    def get_node_id(self, *args, **kwargs):
        """
        Get Node Id
        [Args]
            (str) Name
        [Returns]
            (dict) Response: Get Node response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Node Id")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_node_id_by_name(conn, self.Name)

    ###########################################################################
    @keyword(name="PCC.Assign Tenant to Node")
    ###########################################################################
    def assign_tenant_to_node(self, *args, **kwargs):
        """
        Assigning Tenant to Node
        [Args]
            (int) tenant_id, ids = node_id
        [Returns]
            (dict) Response: Get Node response after Tenant is assigned (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Assign Tenant to Node")
        node_payload = {"tenant" : self.tenant_id,
                   "ids" : [self.ids]
                  }
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        response = pcc.update_tenant_to_node(conn, data=node_payload)
        return self.get_nodes(conn)

    ###########################################################################
    @keyword(name="PCC.Delete Node")
    ###########################################################################
    def delete_node(self, *args, **kwargs):
        """
        Delete Node
        [Args]
            (str) Id
        [Returns]
            (dict) Response: Delete Node response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Delete Node")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.delete_node_by_id(conn, str(self.Id))
    
    ###########################################################################
    @keyword(name="PCC.Wait Until Node Deleted")
    ###########################################################################
    def wait_until_node_deleted(self, *args, **kwargs):
        """
        Wait Until Node Deleted
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Node 
        [Returns]
            (dict) Wait time 
            (dict) Error response: If Exception occured
        """
        self._load_kwargs(kwargs)
        banner("PCC.Wait Until Node Deleted")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        found = True
        time_waited = 0
        timeout = time.time() + PCC_TIMEOUT
        while found:
            found = False
            node_list = pcc.get_nodes(conn)['Result']['Data']
            for node in node_list:
                if str(node['Name']) == str(self.Name):
                    found = True
            if time.time() > timeout:
                return {"Error": "Timeout"}
            if not found:
                time.sleep(5)
                time_waited += 5
        return "OK"
        
    ###########################################################################
    @keyword(name="PCC.Wait Until Node Ready")
    ###########################################################################    
    def wait_until_node_ready(self, *args, **kwargs):
        """
        Wait Until Node Ready
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Node 
        [Returns]
            (dict) Wait Time 
            (dict) Error response: If Exception occured
        """
        self._load_kwargs(kwargs)
        banner("PCC.Wait Until Node Ready")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        ready = False
        time_waited = 0
        PCC_TIMEOUT = 60*10 #10 minutes
        timeout = time.time() + PCC_TIMEOUT
        while not ready:
            ready = False
            node_list = pcc.get_nodes(conn)['Result']['Data']
            for node in node_list:
                if str(node['Name']) == str(self.Name):
                    if node['provisionStatus'] == 'Ready':
                        ready = True
            if time.time() > timeout:
                return {"Error": "Timeout"}
            if not ready:
                time.sleep(5)
                time_waited += 5
        return "OK"
        
    ###########################################################################
    @keyword(name="PCC.Check node exists")
    ###########################################################################
    def check_node_exists(self, *args, **kwargs):
        """
        Check if node already exists and provision status is Ready
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) IP: IP of the Node
        [Returns]
            (bool) True: if IP matches the node host in the list of nodes
                else False: if doesnot exists
            (dict) Error response: If Exception occured
        """
        self._load_kwargs(kwargs)
        banner("PCC.Check node exists")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        node_list = pcc.get_nodes(conn)['Result']['Data']
        try:
            for node in node_list:
                if (str(node['Host']) == str(self.IP)) and (str(node['provisionStatus']) == 'Ready'):
                    return True
            return False
        except Exception as e:
            return {"Error": str(e)}

    ###########################################################################
    @keyword(name="PCC.Update Node")
    ###########################################################################
    def update_node(self, *args, **kwargs):
        """
        Update Node 
        [Args]
            (str) Name: Name of the Node
            ...
        [Returns]
            (dict) Response: Update Node response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Update Node [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        payload = {
            "Id": self.Id,
            "Name": self.Name,
            "ClusterId": self.ClusterId,
            "Host": self.Host,  
            "Model": self.Model,
            "SN": self.SN,
            "Site_Id": self.Site_Id,
            "Type_Id": self.Type_Id,
            "Vendor": self.Vendor,
            "adminUser": self.adminUser,
            "bmc": self.bmc,
            "bmcKey": self.bmcKey,
            "bmcPassword": self.bmcPassword,
            "bmcUser": self.bmcUser,
            "bmcUsers": [self.bmcUser, "platina"],
            "console": self.console,
            "hardwareInventoryId": self.hardwareInventoryId,
            "hwAddr": self.hwAddr,
            "managed": self.managed,
            "owner": self.owner,
            "provisionStatus": self.provisionStatus,
            "ready": self.ready,
            "reimage": self.reimage,
            "roles": self.roles,
            "sshKeys": self.sshKeys,
            "standby": self.standby,
            "status": self.status,
            "tags": self.tags,
            "tenants": self.tenants,
            "interfaces": self.interfaces
        }
        return pcc.modify_node(conn, payload)
    
    ###############################################################################################################
    @keyword(name="PCC.Add mutliple nodes and check online")
    ###############################################################################################################   
    
    def add_multiple_nodes_and_check_online(self, *args, **kwargs):
        """
        Adds multiple nodes and checks online status 
        [Args]
            (list) Names: List of Names of the Nodes to be added
            (list) host_ips: List of Host of the Nodes to be added
            ...
        [Returns]
            (str) OK: Returns "OK" if all nodes are added successfully and are online
            else: returns "Error"
        """
        
        banner("Add mutliple nodes and check online")
        self._load_kwargs(kwargs)
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            wait_for_node_addition_status = []
            node_not_exists=[]
            for hostip in ast.literal_eval(self.host_ips):
                exists = self.check_node_exists(IP=hostip)
                if exists == False:
                    node_not_exists.append(hostip)
                    
            for node_hostip in node_not_exists:
                add_node_status = self.add_node(Host=node_hostip, managed= self.managed, standby = self.standby)
                
            for name in ast.literal_eval(self.Names):
                verify_node_online_status = self.wait_until_node_ready(Name=name)
                banner("verify_node_online_status : {}".format(verify_node_online_status))
                wait_for_node_addition_status.append(verify_node_online_status)
            print("wait_for_node_addition_status : {}".format(wait_for_node_addition_status))
            result = len(wait_for_node_addition_status) > 0 and all(elem == "OK" for elem in wait_for_node_addition_status)
            if result:
                return "OK"
            else:
                return "Error"
            
        except Exception as e:
            logger.console("Error in add_node_and_check_online status: {}".format(e))
    
    ###############################################################################################################
    @keyword(name="PCC.Delete mutliple nodes and wait until deletion")
    ###############################################################################################################   
    
    def delete_multiple_nodes_and_wait_until_deletion(self, *args, **kwargs):
        """
        Deletes multiple nodes/ all nodes 
        [Args]
            (list) Names: List of Names of the Nodes to be deleted
            or
            Don't provide any arguments if you want to delete all nodes
            ...
        [Returns]
            (str) OK: Returns "OK" if all nodes are deleted successfully
            else: returns "Error"
        """
        
        banner("Delete mutliple nodes and wait until deletion")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        try:
            if self.Names:
                deletion_status = []
                for name in ast.literal_eval(self.Names):
                    node_id= self.get_node_id(Name=name)
                    banner("Node id: {}".format(node_id))
                    delete_node_status = self.delete_node(Id=node_id)
                    logger.console(delete_node_status)
                        
                for name in ast.literal_eval(self.Names):
                    deletion_response = self.wait_until_node_deleted(Name=name)
                    deletion_status.append(deletion_response)
                print("deletion_status: {}".format(deletion_status))
                result = len(deletion_status) > 0 and all(elem == "OK" for elem in deletion_status)
                if result:
                    return "OK"
                else:
                    return "Error"
                    
                    
            else:
                response = self.get_nodes()
                list_id = []
                
                if get_response_data(response) == []:
                    return "OK"
                else:
                    for ids in get_response_data(response):
                        list_id.append(ids['id'])
                    print("list of id:{}".format(list_id))
                    for id_ in list_id:
                        response = self.delete_node(Id=id_)
                        
                deletion_status = False
                counter = 0
                while deletion_status == False:
                    counter+=1
                    response = self.get_nodes()
                    if get_response_data(response) != []:
                        time.sleep(6)
                        banner("All Nodes not yet deleted")
                        if counter < 50:
                            banner("Counter: {}".format(counter))
                            continue
                        else:
                            return "Error: All nodes not deleted"
                    elif get_response_data(response) == []:
                        deletion_status = True
                        banner("All Nodes deleted successfully")
                        return "OK"
                    else:
                        banner("Entered into continuous loop")
                        return "Error"
        except Exception as e:
            logger.console("Error in delete_multiple_nodes_and_wait_until_deletion status: {}".format(e))

    ###########################################################################
    @keyword(name="PCC.Node Verify Back End")
    ###########################################################################
    def verify_node_back_end(self, *args, **kwargs):

        banner("PCC.Node Verify Back End")
        self._load_kwargs(kwargs)
        print("Kwargs:{}".format(kwargs))
    
        pcc_agent_cmd="sudo systemctl status pccagent"
        sys_cllector_cmd="sudo systemctl status systemCollector"
        frr_cmd="sudo service frr status|head -10"

        failed_host=[]

        if self.host_ips:
            for host_ip in eval(str(self.host_ips)):
                logger.console("Verifying services for host {} .....".format(host_ip))
                pcc_agent_output=cli_run(host_ip,self.user,self.password,pcc_agent_cmd)
                sys_collector_output=cli_run(host_ip,self.user,self.password,sys_cllector_cmd)   
                logger.console("Pcc Agent Output: {}".format(pcc_agent_output))
                logger.console("System Collector Output: {}".format(sys_collector_output))
                #frr_output=cli_run(host_ip,self.user,self.password,frr_cmd)
                #logger.console("Frr Service Output: {}".format(frr_output))
                #if re.search("running",str(pcc_agent_output)) and re.search("running",str(sys_collector_output) and re.search("running",str(frr_output))):
                if re.search("running",str(pcc_agent_output)) and re.search("running",str(sys_collector_output)):
                    continue
                else:
                    
                    failed_host.append(host_ip)
                    continue                
        else:
            print("Host list is empty, please provide the host ip in a list for eg. host_ips=['000.00.0.00']")
            
        if failed_host:  
            print("Service are down for {}".format(failed_host))     
            return "Error"
        else:
            return "OK"
            
    #verifying sn and model number from front-end to backend        
    ###########################################################################
    @keyword(name="PCC.Node Verify Model And Serial Number")
    ###########################################################################
    def verify_model_and_serial_number(self, *args, **kwargs):
        banner("PCC.Node Verify Model And Serial Number")
        self._load_kwargs(kwargs)
        print("Kwargs:{}".format(kwargs))      
        conn = BuiltIn().get_variable_value("${PCC_CONN}")    
        serial_cmd="sudo dmidecode -s baseboard-serial-number"
        model_cmd="sudo dmidecode -s baseboard-product-name"       
        failed_host=[]
        if self.Names:
            for name in ast.literal_eval(self.Names):
                node_id= self.get_node_id(Name=name)
                node_details=get_response_data(pcc.get_node_summary_by_id(conn,str(node_id)))
                print("1. Node Summary:"+str(node_details))
                print("++++++++++++++++++++++++++++++++++++++++++++")
                print("2. Serial Number"+str(node_details['SN']))
                print("++++++++++++++++++++++++++++++++++++++++++++")
                print("3. Model Number"+str(node_details['Model']))
                print("++++++++++++++++++++++++++++++++++++++++++++")
                logger.console("Verifying services for host {} .....".format(node_details['Host']))
                print("Verifying services for host {} .....".format(node_details['Host']))
                serial_number=self._serialize_response(time.time(),cli_run(node_details['Host'], self.user, self.password, serial_cmd))['Result']['stdout']
                model_number=self._serialize_response(time.time(),cli_run(node_details['Host'], self.user, self.password, model_cmd))['Result']['stdout']
                print("Backend Serial Data:"+str(serial_number))
                print("Backend Model Data:"+str(model_number))
                if node_details['Model']==str(model_number.strip()) and node_details['SN']==str(serial_number.strip()):
                    continue
                else:
                    
                    failed_host.append(name)
                    continue                
        else:
            print("Node names is empty, please provide the node name list for eg. Names=['sv124','sv125']")           
        if failed_host:  
            print("Couldn't verify Serial and Model Number for {}".format(failed_host))     
            return "Error"
        else:
            return "OK"        