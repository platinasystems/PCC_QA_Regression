import time
import ast
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from platina_sdk import pcc_easy_api as easy

from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase

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
        self.host_ips = []

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
        response = pcc.assigning_tenant_to_node(conn, data=node_payload)
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
        return pcc.delete_node_by_id(conn, self.Id)

    ###########################################################################
    @keyword(name="PCC.Wait Until Node Deleted")
    ###########################################################################
    def wait_until_node_deleted(self, *args, **kwargs):
        """
        Wait Until Node Deleted
        [Args]
            (str) Name
        [Returns]
            (dict) OK
            (dict) Error if timeout
        """
        self._load_kwargs(kwargs)
        banner("PCC.Wait Until Node Deleted")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.wait_until_node_deleted(conn, self.Name)


    ###########################################################################
    @keyword(name="PCC.Wait Until Node Ready")
    ###########################################################################
    def wait_until_node_ready(self, *args, **kwargs):
        """
        Wait Until Node Ready
        [Args]
            (str) Name
        [Returns]
            (dict) OK
            (dict) Error if timeout
        """
        self._load_kwargs(kwargs)
        banner("PCC.Wait Until Node Ready")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.wait_until_node_ready(conn, self.Name)
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
            wait_for_node_addition_status = []
            for hostip in ast.literal_eval(self.host_ips):
                add_node_status = self.add_node(Host=hostip, managed= self.managed, standby = self.standby)
                
            for name in ast.literal_eval(self.Names):
                verify_node_online_status = self.wait_until_node_ready(Name=name)
                banner("verify_node_online_status : {}".format(verify_node_online_status))
                wait_for_node_addition_status.append(verify_node_online_status)
            print("wait_for_node_addition_status : {}".format(wait_for_node_addition_status))
            result = len(wait_for_node_addition_status) > 0 and all(elem == wait_for_node_addition_status[0] for elem in wait_for_node_addition_status)
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
        
        try:
            if self.Names:
                deletion_status = []
                for name in ast.literal_eval(self.Names):
                    node_id= self.get_node_id(Name=name)
                    banner("Node id: {}".format(node_id))
                    delete_node_status = self.delete_node(Id=str(node_id))
                    logger.console(delete_node_status)
                        
                for name in ast.literal_eval(self.Names):
                    deletion_response = self.wait_until_node_deleted(Name=name)
                    deletion_status.append(deletion_response)
                print("deletion_status: {}".format(deletion_status))
                result = len(deletion_status) > 0 and all(elem == deletion_status[0] for elem in deletion_status)
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
                        response = self.delete_node(Id=str(id_))
                        
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
                            break
                    elif get_response_data(response) == []:
                        deletion_status = True
                        banner("All Nodes deleted successfully")
                        return "OK"
                    else:
                        banner("Entered into continuous loop")
                        return "Error"
        except Exception as e:
            logger.console("Error in delete_multiple_nodes_and_wait_until_deletion status: {}".format(e))
