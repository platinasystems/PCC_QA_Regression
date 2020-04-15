import time
import os
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from platina_sdk import pcc_api as pcc
from platina_sdk import pcc_easy_api as easy
from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data, get_result
from aa.common.AaBase import AaBase

class NodeRoles(AaBase):
    """ 
    NodeRoles
    """

    def __init__(self):
        self.Name = None
        self.Id = None
        self.Description = None
        self.Applications = []
        self.Tenants = []
        self.owners = []
        self.templateIDs = []
        self.templateNames = None
        super().__init__()

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

        return easy.add_node_role(
            conn=conn, 
            Name=self.Name,
            Description=self.Description,
            Applications=self.Applications,
            Tenants=self.Tenants
            )

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
    @keyword(name="PCC.Delete Node Role")
    ###########################################################################
    def delete_node_role(self, *args, **kwargs):
        """
        Delete Node Role for matching Name
        [Args]
            (int) Name
        [Returns]
            (dict) Delete Node Role Response
        """
        self._load_kwargs(kwargs)
        banner("PCC.Delete Node Role [Id=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.delete_node_role_by_name(conn=conn, Name=self.Name)
