import time
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from platina_sdk import pcc_easy_api as easy

from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase

class NodeGroups(AaBase):
    """ 
    NodeGroups
    """

    def __init__(self):
        self.Name = None
        self.Id = None
        self.Description = None
        self.Tenant = None
        self.owner = None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Add Node Group")
    ###########################################################################
    def add_node_group(self, *args, **kwargs):
        """
        Add Node Group to PCC
        [Args]
            (str) Name: Name of the group
            (int) owner: Tenant Id for the new group
            (str) Description: Description of the group
        [Returns]
            (dict) Response: Add Node Group response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add Node Group [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        payload = {
            "Name": self.Name,
            "Description": self.Description,
            "owner": self.owner
        }

        return pcc.add_cluster(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Get Node Groups")
    ###########################################################################
    def get_node_groups(self, *args, **kwargs):
        """
        Get Node Groups from PCC
        [Args]
            None
        [Returns]
            (dict) Response: Get Node Groups response (includes any errors)
        """
        banner("PCC.Get Node Groups")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_clusters(conn)

    ###########################################################################
    @keyword(name="PCC.Get Node Group")
    ###########################################################################
    def get_node_group(self, *args, **kwargs):
        """
        Get Node Group from PCC
        [Args]
            (int) Id
        [Returns]
            (dict) Response: Get Node Groups response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Node Group [Id=%s]" % self.Id)
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_cluster_by_id(conn, self.Id)

    ###########################################################################
    @keyword(name="PCC.Get Node Group Id")
    ###########################################################################
    def get_node_group_id(self, *args, **kwargs):
        """
        Get Node Group Id
        [Args]
            (str) Name
        [Returns]
            (int) Id: Node Group Id if there is one, 
                None: If not found
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Node Group Id [Name=%s]" % self.Name)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_node_group_id_by_name(conn, self.Name)

    ###########################################################################
    @keyword(name="PCC.Delete Node Group")
    ###########################################################################
    def delete_node_group(self, *args, **kwargs):
        """
        Delete Node Group for matching Id
        [Args]
            (int) Id
        [Returns]
            (dict) Delete Node Group Response
        """
        self._load_kwargs(kwargs)
        banner("PCC.Delete Node Group [Id=%s]" % self.Id)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.delete_cluster_by_id(conn, self.Id)
