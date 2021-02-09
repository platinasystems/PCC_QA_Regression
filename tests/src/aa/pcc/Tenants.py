import time
import ast
from robot.api.deco import keyword
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy
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
    def validate_tenant_by_name(self, *args, **kwargs):
        """
        Validate Tenant by Name
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Tenant
        [Returns]
            "OK": If Tenant present in PCC
            else: "Tenant not available" : If Tenant not present in PCC
            
        """
        self._load_kwargs(kwargs)
        banner("PCC.Validate Tenant [name=%s]" % self.Name)
        print("Kwargs are:{}".format(kwargs))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        tenant_list = pcc.get_tenant_list(conn)['Result']
        print("tenant_list: ",tenant_list)
        try:
            for tenant in tenant_list:
                if str(tenant['name']) == str(self.Name):
                    return "OK"
            return "Tenant not available"
        except Exception as e:
            return {"Error": str(e)}
    
    ###########################################################################
    @keyword(name="PCC.Validate Tenant Description")
    ###########################################################################    
    def validate_tenant_description_by_name(self, *args, **kwargs):
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
        banner("PCC.Validate Tenant Description")
        print("Kwargs are:{}".format(kwargs))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        tenant_list = pcc.get_tenant_list(conn)['Result']
        try:
            for tenant in tenant_list:
                if str(tenant['name']) == str(self.Name):
                    if str(tenant['description']) == str(self.Description):
                        return "OK"
            return "Description does not match"
        except Exception as e:
            return {"Error": str(e)}

    ###########################################################################
    @keyword(name="PCC.Validate Tenant Assigned to Node")
    ###########################################################################
    def validate_tenant_assigned_to_node(self, *args, **kwargs):
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
        banner("Validate Tenant Assigned to Node")
        print("Kwargs are:{}".format(kwargs))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        nodes_response = pcc.get_nodes(conn)['Result']['Data']
        try:
            for node in nodes_response:
                if str(node['Name']) == str(self.Name):
                    if node['tenant'] == str(self.Tenant_Name):
                        return "OK"
            return "Not assigned"
        except Exception as e:
            return {"Error": str(e)}
        
    
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
        
   ###########################################################################
    @keyword(name="PCC.Delete All Tenants")
    ###########################################################################
    def delete_all_tenants(self, *args, **kwargs):
        """
        Delete All Tenants
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (list) tenants: Tenants list to be deleted

        [Returns]
            "OK": If all Tenants are deleted
            else "Error"

        """
        banner("Delete All Tenants")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        banner("Kwargs are: {}".format(kwargs))
        try:
            tenant_list = self.get_tenant_list(conn)['Result']
            trace(tenant_list)
            tenant_names = [tenant['name'] for tenant in tenant_list]
            trace("tenant_names: {}".format(tenant_names))
            if tenant_names == ['ROOT']:
                return "OK"
            elif tenant_names == ['ROOT','Tenant_6']:
                return "OK"
            else:
                tenants_to_be_deleted = set(tenant_names)- set(['ROOT','Tenant_6'])
                trace("tenants_to_be_deleted: {}".format(tenants_to_be_deleted))
                for tenant in list(tenants_to_be_deleted):
                    trace("Deleting tenant: {}".format(tenant))
                    tenant_id = self.get_tenant_id(Name=tenant)
                    response = self.delete_tenant(Id= str(tenant_id))
                    if response['StatusCode'] == 200:
                        continue
                    else:
                        return Error
                return "OK"
        except Exception as e:
            return {"Error: {}".format(e)} 
