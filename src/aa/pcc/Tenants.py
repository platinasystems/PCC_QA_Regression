import time
import ast
from robot.api.deco import keyword
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from platina_sdk import pcc_api as pcc
from aa.common import PccEasyApi as easy
from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data, get_result
from aa.common.AaBase import AaBase

class Tenants(AaBase):
    """ 
    Tenants
    """

    def __init__(self):
        self.Name = None
        self.Id = None
        self.Description = None
        self.Parent_id = None
        self.Tenant_Name = None
        self.Tenant_list = None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Get Tenant List")
    ###########################################################################
    def get_tenant_list(self, *args, **kwargs):
        """
        Get list of tenants from PCC
        [Args]
            None
        [Returns]
            (dict) Response dictionary: Including the list of tenants
            (dict) Error response: If Exception occured
        """
        banner("PCC.Get Tenant List")
        self._load_kwargs(kwargs)
        print("Kwargs are:{}".format(kwargs))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_tenant_list(conn)

    ###########################################################################
    @keyword(name="PCC.Get Tenant Id")
    ###########################################################################
    def get_tenant_id(self, *args, **kwargs):
        """
        Get Id of tenant with matching Name from PCC
        [Args]
            Name
        [Returns]
            (int) Id: Id of the matchining tenant, or
                None: if no match found, or
            (dict) Error response: If Exception occured
        """

        self._load_kwargs(kwargs)
        banner("PCC.Get Tenant Id [name=%s]" % self.Name)
        print("Kwargs are:{}".format(kwargs))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_tenant_id_by_name(conn, self.Name)
        
    ###########################################################################
    @keyword(name="PCC.Add Tenant")
    ###########################################################################
    def add_tenant(self, *args, **kwargs):
        """
        Add Tenant
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (dict) data: tenant
                    {   
                      "name":"string",  # Name of the Tenant
                      "description":"string", # Description of the Tenant
                      "parent":"int"  #Id of the Tenant user , if ROOT is the parent- then the input will be 1.
                    
                    }
        [Returns]
            (dict) Response: Add Tenant response (includes any errors)
        """
        banner("PCC.Add Tenant")
        self._load_kwargs(kwargs)
        print("Kwargs are:{}".format(kwargs))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        payload = {
                    "name":self.Name,
                    "description":self.Description,
                    "parent":int(self.Parent_id)
                  }
        
        return pcc.add_tenant(conn, data = payload)
        
    ###########################################################################
    @keyword(name="PCC.Modify Tenant")
    ###########################################################################
    def modify_tenant(self, *args, **kwargs):
        """
        Modify Tenant
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (dict) data: tenant
                    {  
                      "id": "int",            # Id of the Tenant
                      "name":"string",        # Name of the Tenant
                      "description":"string", # Description of the Tenant
                      "parent":"int"          # Id of the Parent , if ROOT is the parent- then the parent Id will be 1.
                    
                    }
        [Returns]
            (dict) Response: Modify Tenant response (includes any errors)
        """
        banner("PCC.Modify Tenant")
        self._load_kwargs(kwargs)
        print("Kwargs are:{}".format(kwargs))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        payload = {
                    "id":int(self.Id),
                    "name":self.Name,
                    "description":self.Description,
                    "parent":int(self.Parent_id)
                  }
        
        return pcc.modify_tenant(conn, data = payload)
        
    ###########################################################################
    @keyword(name="PCC.Delete Tenant")
    ###########################################################################
    def delete_tenant(self, *args, **kwargs):
        """
        Delete Template by Id
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) data: Id of tenant
                  
                  {
                    "Id": "int"    # Id of the Tenant
                  }
    
        [Returns]
            (dict) Response: Delete Template response (includes any errors)
        """
        banner("PCC.Delete Tenant")
        self._load_kwargs(kwargs)
        
        print("Kwargs are:{}".format(kwargs))
        banner("Type of Id in Delete Tenant: {}".format(type(kwargs['Id'])))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        payload = {
                    "id":str(self.Id),
                  }
                  
        banner("Payload: {}".format(payload))
        return pcc.delete_tenant_by_id(conn, data = payload)
        
    ###########################################################################
    @keyword(name="PCC.Validate Tenant")
    ###########################################################################
    def validate_tenant(self, *args, **kwargs):
        """
        Validate Tenant 
        [Args]
          (dict) conn: Connection dictionary obtained after logging in
          (str) Name: Name of the Tenant

        [Returns]
          "OK": If Tenant present in PCC
          else: "Tenant not available" : If Tenant not present in PCC
            
        """
        self._load_kwargs(kwargs)
        banner("PCC.Validate Tenant [Name=%s]" % self.Name)
        print("Kwargs are:{}".format(kwargs))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.validate_tenant_by_name(conn, self.Name)
        
    
    ###########################################################################
    @keyword(name="PCC.Validate Tenant Description")
    ###########################################################################
    def validate_tenant_description(self, *args, **kwargs):
        """
        Validate Tenant Desciption by Name
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Tenant
            (str) Description: Description of the Tenant
    
        [Returns]
            "OK": If Tenant description matches
            else: "Description does not match" 
            
        """
        self._load_kwargs(kwargs)
        banner("PCC.Validate Node Group Description [Name=%s]" % self.Name)
        print("Kwargs are:{}".format(kwargs))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.validate_tenant_description_by_name(conn, self.Name, self.Description)
        
    ###########################################################################
    @keyword(name="PCC.Validate Tenant Assigned to Node")
    ###########################################################################
    def validate_tenant_assignment(self, *args, **kwargs):
        """
        Validate tenant assigned to Node
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Node
            (str) Tenant_Name : Name of the tenant
    
        [Returns]
            "OK": If tenant assigned to Node
            else: "Not assigned" : If tenant not assigned to node
            
        """
        self._load_kwargs(kwargs)
        banner("PCC.Validate Node Group Assigned to Node [Name=%s]" % self.Tenant_Name)
        print("Kwargs are:{}".format(kwargs))
        logger.console("Kwargs are: {}".format(kwargs)) 
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.validate_tenant_assigned_to_node(conn, Name=self.Name, Tenant_Name=self.Tenant_Name)
    
    ###########################################################################
    @keyword(name="PCC.Delete Multiple Tenants")
    ###########################################################################
    def delete_multiple_tenants(self, *args, **kwargs):
        """
        Delete Multiple Tenants
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (list) tenants: Tenants list to be deleted
    
        [Returns]
            "OK": If all Tenants are deleted
            else "Error"
            
        """
        banner("Delete Multiple Tenants")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        banner("Kwargs are: {}".format(kwargs))
        try:
            tenant_list = ast.literal_eval(self.Tenant_list)
            for tenant in tenant_list:
                tenant_id = self.get_tenant_id(Name=tenant)
                response = self.delete_tenant(Id= str(tenant_id))
                if response['StatusCode'] == 200:
                    continue
                else:
                    return Error
            return "OK"
        except Exception as e:
            return {"Error: {}".format(e)}
        
    
