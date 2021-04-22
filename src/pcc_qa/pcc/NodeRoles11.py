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
        self.Id=None
        self.Name=None
        self.Description=None
        self.TemplateIds=None
        self.Owners=None
        super.__init__()

    '''{"id":0,"name":"pvt","description":"","templateIDs":[1],"owners":[1],"default":false}'''

    ########################################################################################
    @keyword(name="Get Node Roles")
    ########################################################################################
    def get_node_roles(self,*args,**kwargs):
        """ Get Node Roles.."""
        banner("..Get Node Roles...")
        self._load_kwargs(kwargs)
        conn=BuiltIn.get_variable_value('${PCC_CONN}')

        return pcc.get_roles(conn)

    ########################################################################################
    @keyword(name="Add Node Roles")
    ########################################################################################
    def add_node_roles(self,*args,**kwargs):
        """Add Node Roles."""
        banner("Add Node Roles")
        self._load_kwargs(kwargs)
        conn=BuiltIn.get_variable_value('$PCC_CONN')
        if Description not in kwargs:
            self.Description=None
        payload = {

            "name": self.Name,
            "description": self.Description,
            "templateIDs": self.TemplateIds,
            "owners": self.Owners,
        }
        '''{"id":0,"name":"node1","description":"","templateIDs":[1],"owners":[1],"default":false}'''

        return pcc.add_role(conn, data=payload)

    ########################################################################################
    @keyword(name="Modify Node Roles")
    ########################################################################################
    def modify_node_roles(self, *args, **kwargs):
        """Modify Node Roles."""

        banner("Modify Node Roles")
        self._load_kwargs(kwargs)
        conn = BuiltIn.get_variable_value('$PCC_CONN')
        if Description not in kwargs:
            self.Description = None

        payload = {
                "id": self.Id,
                "name": self.Name,
                "description": self.Description,
                "templateIDs": self.TemplateIds,
                "owners": self.Owners,
        }
        {"id":232,"name":"node2","description":"","templateIDs":[1],"owners":[1],"default":false}

        return pcc.modify_role(conn,str(self.Id), data=payload)

    ########################################################################################
    @keyword(name="Delete Node Roles")
    ########################################################################################
    def delete_node_roles(self, *args, **kwargs):
        """Delete Node Roles."""

        banner("Modify Node Roles")
        self._load_kwargs(kwargs)
        conn = BuiltIn.get_variable_value('$PCC_CONN')
        return pcc.delete_role_by_id(conn, str(self.Id))

    ###########################################################################
    @keyword(name="Get Tenant Id")
    ###########################################################################
    def get_tenant_id(self, *args, **kwargs):
        """Get tenant id"""
        self._load_kwargs(kwargs)
        banner("PCC.Get Tenant Id [name=%s]" % self.Name)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_tenant_id_by_name(conn, self.Name)

    ###########################################################################
    @keyword(name="Get Template Id")
    ###########################################################################
    def get_template_id_by_name(self, *args, **kwargs):
        """
        Get Id of Application with matching Name
        """
        self._load_kwargs(kwargs)
        banner("Get Template Id [Name=%s]" % self.Name)
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
    @keyword(name="Add Multiple Node Roles")
    ###########################################################################
    def add_multiple_node_roles(self, *args, **kwargs):
        """
        Add Node Role to PCC
        """
        self._load_kwargs(kwargs)
        banner("Add Multiple Node Roles" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        node_role_dict = {}
        for i in range(1, int(self.number_of_node_roles) + 1):
            node_role_dict["node_role{}".format(i)] = {"Name": "{}{}".format(self.Name, i),
                                                       "Description": "{}{}".format(self.Description, i)}

        response_status = []
        availability_status = []
        for node in node_role_dict.values():
            payload = {
                "name": node["Name"],
                "description": node["Description"],
                "templateIDs": ast.literal_eval(self.templateIDs),
                "owners": ast.literal_eval(self.owners)
            }

            add_node_role_response = pcc.add_role(conn, data=payload)
            print("add_cluster_response is: ", add_node_role_response)

            response_status.append(add_node_role_response['StatusCode'])
            time.sleep(1)
            availabilty_response = self.validate_node_role_by_name(Name=node["Name"])
            print("availabilty_response is: ", availabilty_response)

            availability_status.append(availabilty_response)

        response_result = len(response_status) > 0 and all(elem == 200 for elem in response_status)
        availability_result = len(availability_status) > 0 and all(
            elem == availability_status[0] for elem in availability_status)

        if (response_result) and (availability_result):
            return "OK"

        return "Error: All Node Roles not added"

    ###########################################################################
    @keyword(name="Delete Multiple Node Roles")
    ###########################################################################
    def delete_multiple_node_roles(self, *args, **kwargs):
        """
        Delete Multiple Node Roles from PCC

        """
        self._load_kwargs(kwargs)
        banner("Delete Multiple Node Roles" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        node_role_dict = {}

        for i in range(1, int(self.number_of_node_roles) + 1):
            node_role_dict["node_role{}".format(i)] = {"Name": "{}{}".format(self.Name, i)}

        response_status = []
        availability_status = []
        for node in node_role_dict.values():
            deletion_response = self.delete_node_role_by_name(Name=node["Name"])
            print("deletion_response is: ", deletion_response)

            response_status.append(deletion_response["StatusCode"])
            time.sleep(1)
            availabilty_response = self.validate_node_role_by_name(Name=node["Name"])
            print("availabilty_response is: ", availabilty_response)

            availability_status.append(availabilty_response)

        response_result = len(response_status) > 0 and all(elem == 200 for elem in response_status)
        availability_result = len(availability_status) > 0 and all(
            elem == availability_status[0] for elem in availability_status)

        if (response_result) and (availability_result):
            return "OK"

        return "Error: All Node Roles not deleted"

    ###########################################################################
    @keyword(name="Delete all Node roles")
    ###########################################################################
    def delete_all_node_roles(self, *args, **kwargs):
        """
        Delete all Node Roles
        """
        banner("Delete All Node roles")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        try:
            response = self.get_node_roles()
            list_node_roles = []

            for node_role in get_response_data(response):
                if node_role['name'] == "Default" or node_role['name'] == "Baremetal Management Node" or node_role[
                    'name'] == "Cluster Head" or node_role['name'] == "Ceph Resource" or node_role[
                    'name'] == "Kubernetes Resource" or node_role['name'] == "Network Resource":
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
                return {"Error": str(e)}
        except Exception as e:
            logger.console("Error in delete_all_node_roles status: {}".format(e))




