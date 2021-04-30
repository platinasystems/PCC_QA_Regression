import time
import os
import ast
from robot.api import logger
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy
from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data, get_result
from pcc_qa.common.PccBase import PccBase

class NodeRoles(PccBase):
    """ 
    NodeRoles
    """

    def __init__(self):
        self.Name = None
        self.nodes = None
        self.Id = None
        self.Description = None
        self.owners = []
        self.templateIDs = []
        self.number_of_node_roles = None
        self.templateNames = None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Get Node Roles")
    ###########################################################################
    def get_node_roles(self, *args, **kwargs):
        """
        Get Node Roles from PCC
        [Args]
            None
        [Returns]
            (dict) Response: Get Node Roles response (includes any errors)
        """
        banner("PCC.Get Node Roles")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_roles(conn)
    
    ###########################################################################
    @keyword(name="PCC.Add Node Role")
    ###########################################################################
    def add_node_role(self, *args, **kwargs):
        """
        Add Node Role
        [Args]
            (str) name: name of the Node Role
        [Returns]
            (dict) Response: Add Node Role response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add Node Role [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        print("Kwargs are: {}".format(kwargs))
        if "Description" not in kwargs:
            self.Description = None
        
        payload ={
                  "name":self.Name,
                  "description":self.Description,
                  "templateIDs":ast.literal_eval(self.templateIDs),
                  "owners":ast.literal_eval(self.owners)
                  }
                  
        return pcc.add_role(conn, data=payload)
        
    ###########################################################################
    @keyword(name="PCC.Get Template Id")
    ###########################################################################
    def get_template_id_by_name(self, *args, **kwargs):
        """
        Get Id of Application with matching Name 
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Template
        [Returns]
            (int) Id: Id of the matchining Application, or
                None: if no match found, or
            (dict) Error response: If Exception occured
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Template Id [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        print("Kwargs are: {}".format(kwargs))
        
        template_list = pcc.get_templates(conn)['Result']['Data']
        try:
            for template in template_list:
                if str(template['name'].lower()) == str(self.Name).lower():
                    return template['id']
            return None
        except Exception as e:
            return {"Error": str(e)}
    
    ###########################################################################
    @keyword(name="PCC.Get Node Role Id")
    ###########################################################################
    def get_node_role_id(self, *args, **kwargs):
        """
        Get Node Role Id
        [Args]
            (str) Name
        [Returns]
            (int) Id: Node Role Id if there is one, 
                None: If not found
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Node Role Id [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_node_role_id_by_name(conn=conn, Name=self.Name)

    ###########################################################################
    @keyword(name="PCC.Validate Node Role")
    ###########################################################################
    def validate_node_role_by_name(self, *args, **kwargs):
        """
        Validate Node Role by Name
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Node Role
        [Returns]
            "OK": If node role present in PCC
            else: "Node role not available" : If node role not present in PCC
            
        """
        self._load_kwargs(kwargs)
        banner("PCC.Validate Node Role")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        noderoles_list = pcc.get_roles(conn)['Result']['Data']
        try:
            for noderole in noderoles_list:
                if str(noderole['name']) == str(self.Name):
                    return "OK"
            return "Node role not available"
        except Exception as e:
            return {"Error": str(e)}
            
    ###########################################################################
    @keyword(name="PCC.Verify Node Role On Nodes")
    ###########################################################################
    def verify_node_roles_on_nodes(self, *args, **kwargs):
        """
        Verify node role on Nodes
        [Args]
            (list) nodes: name of pcc nodes
            (list) roles: name of roles
        [Returns]
            (dict) Response: OK if node role exists on the node (includes any errors)
        """
        self._load_kwargs(kwargs)
        print("kwargs:-"+str(kwargs))
        banner("PCC.Verify Node Role On Nodes")
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        node_role_id = self.get_node_role_id(conn,Name= self.Name)
        for node in ast.literal_eval(self.nodes):
            print("Node from user is: {}".format(node))
            response = pcc.get_nodes(conn)
            for data in get_response_data(response):
                self.Id=data['Id']
                self.Host=data['Host']
                print("node name from pcc: {}".format(data['Name']).lower())
                if str(data['Name']).lower() == str(node).lower():
                    if data['roles'] == None:
                        return "No roles present on node"
                    if node_role_id in data['roles']:
                        return "OK"
                    else:
                        return "Node role {} not present on node: {}".format(self.Name, node)
            
    ###########################################################################
    @keyword(name="PCC.Delete Node Role")
    ###########################################################################        
    def delete_node_role_by_name(self, *args, **kwargs):
        """
        Delete Node Role by Name
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name
        [Returns]
            (dict) Response: Delete Roles response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Validate Node Role")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        Id = self.get_node_role_id(Name=self.Name)
        return pcc.delete_role_by_id(conn, str(Id))
    
    ###########################################################################
    @keyword(name="PCC.Modify Node Role")
    ###########################################################################
    def modify_node_role(self, *args, **kwargs):
        """
        Modify Node Role
        [Args]
            (str) name: name of the Node Role
        [Returns]
            (dict) Response: Add Node Role response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Modify Node Role [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        print("Kwargs are: {}".format(kwargs))
        
        banner("Type of Id: {}".format(type(kwargs['Id'])))
        if "Description" not in kwargs:
            self.Description = None
        
        payload ={
                  "id":self.Id,
                  "name":self.Name,
                  "description":self.Description,
                  "templateIDs":ast.literal_eval(self.templateIDs),
                  "owners":ast.literal_eval(self.owners)
                  }
                  
        return pcc.modify_role(conn,str(self.Id), data=payload)
        
        
    ###########################################################################
    @keyword(name="PCC.Add Multiple Node Roles")
    ###########################################################################
    def add_multiple_node_roles(self, *args, **kwargs):
        """
        Add Node Role to PCC
        [Args]
            (str) Names: Names of the node role
            (int) owner: Tenant Id for the new group
            (str) Descriptions: Descriptions of the node role
            number_of_node_roles: Number of node roles to be added
        [Returns]
            (dict) Response: Add Node Role response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add Multiple Node Roles [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        node_role_dict = {}
        for i in range(1,int(self.number_of_node_roles)+1):
            node_role_dict["node_role{}".format(i)]={"Name":"{}{}".format(self.Name,i),"Description":"{}{}".format(self.Description,i)}
        
        response_status = []
        availability_status = []
        for node in node_role_dict.values():
            payload= {
                      "name": node["Name"],
                      "description": node["Description"],
                      "templateIDs":ast.literal_eval(self.templateIDs),
                      "owners":ast.literal_eval(self.owners)
                     }   
            
            add_node_role_response = pcc.add_role(conn, data=payload)
            print("add_cluster_response is: ",add_node_role_response)
            
            response_status.append(add_node_role_response['StatusCode'])
            time.sleep(1)
            availabilty_response = self.validate_node_role_by_name(Name=node["Name"])
            print("availabilty_response is: ",availabilty_response)
            
            availability_status.append(availabilty_response)
            
        response_result = len(response_status) > 0 and all(elem == 200 for elem in response_status) 
        availability_result = len(availability_status) > 0 and all(elem == availability_status[0] for elem in availability_status)
        
        if (response_result) and (availability_result):
            return "OK"
            
        return "Error: All Node Roles not added to PCC"
        
    ###########################################################################
    @keyword(name="PCC.Delete Multiple Node Roles")
    ###########################################################################
    def delete_multiple_node_roles(self, *args, **kwargs):
        """
        Delete Multiple Node Roles from PCC
        [Args]
            (str) Id: Id of the node role
            number_of_node_roles: Number of node roles to be deleted
        [Returns]
            (dict) Response: Add Node Role response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Delete Multiple Node Roles [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        node_role_dict = {}
        
        for i in range(1,int(self.number_of_node_roles)+1):
            node_role_dict["node_role{}".format(i)]={"Name":"{}{}".format(self.Name,i)}
        
        response_status = []
        availability_status = []
        for node in node_role_dict.values():
            deletion_response = self.delete_node_role_by_name(Name=node["Name"])
            print("deletion_response is: ",deletion_response)
            
            response_status.append(deletion_response["StatusCode"])
            time.sleep(1)
            availabilty_response = self.validate_node_role_by_name(Name=node["Name"])
            print("availabilty_response is: ",availabilty_response)
            
            availability_status.append(availabilty_response)
        
        response_result = len(response_status) > 0 and all(elem == 200 for elem in response_status)     
        availability_result = len(availability_status) > 0 and all(elem == availability_status[0] for elem in availability_status)
        
        if (response_result) and (availability_result):
            return "OK"
            
        return "Error: All Node Roles not deleted from PCC"
        
        
    ###########################################################################
    @keyword(name="PCC.Delete all Node roles")
    ###########################################################################
    def delete_all_node_roles(self, *args, **kwargs):
        """
        Delete all Node Roles
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            
    
        [Returns]
            "OK": If all node roles are deleted
            else "Error"
            
        """
        banner("Delete All Node roles")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        try:
            response = self.get_node_roles()
            list_node_roles = []
            
            for node_role in get_response_data(response):
                if node_role['name']== "Default" or node_role['name']== "Baremetal Management Node" or node_role['name']== "Cluster Head" or node_role['name']== "Ceph Resource" or node_role['name']== "Kubernetes Resource" or node_role['name']== "Network Resource":
                    continue
                list_node_roles.append(node_role['name'])
            print("list of node roles: {}".format(list_node_roles))
            response_status = []
            
            try:
                if list_node_roles == []:
                    return "OK"
                else:
                    for node in list_node_roles:
                        print("Node is : " + node)
                        Id = self.get_node_role_id(Name=node)
                        response = pcc.delete_role_by_id(conn, str(Id))
                        print("Response: {}".format(response))
                        response_status.append(response["StatusCode"])
                    response_result = len(response_status) > 0 and all(elem == 200 for elem in response_status)
                    if response_result:
                        return "OK"
                    else:
                        return response_status  
            except Exception as e:
                return {"Error":str(e)}     
        except Exception as e:
            logger.console("Error in delete_all_node_roles status: {}".format(e))
