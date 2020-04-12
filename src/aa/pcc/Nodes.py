import time
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
        self.ids = None

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
