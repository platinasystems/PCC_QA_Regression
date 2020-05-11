import time
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from platina_sdk import pcc_easy_api as easy

from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data, get_result
from aa.common.AaBase import AaBase

class Roles(AaBase):
    """ 
    Roles
    """

    def __init__(self):
        self.Name = None
        self.Id = None
        self.Description = None
        self.groupOperations = []
        self.groupOperationsText = []
        self.owner = None
        self.templateIDs = []
        self.templateNames = None
        super().__init__()



    ###########################################################################
    @keyword(name="PCC.Add Role")
    ###########################################################################
    def add_role(self, *args, **kwargs):
        """
        Add Role

        [Args]
            (str) Name: Name of the Role
            (str) description: of the Role
            (list) groupOperations: List of dictionaries containing ids of ops
            (int) owner

        [Returns]
            (dict) Response: Add Role response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add Role [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.add_role(conn, self.Name, self.Description, self.owner, self.groupOperations)

    ###########################################################################
    @keyword(name="PCC.Get Role Id")
    ###########################################################################
    def get_role_id(self, *args, **kwargs):
        """
        Get Role Id
        [Args]
            (str) Name
        [Returns]
            (int) id: Role Id if there is one, 
                None: If not found
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Role Id [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_role_id_by_name(conn, self.Name)

    ###########################################################################
    @keyword(name="PCC.Delete Role")
    ###########################################################################
    def delete_role(self, *args, **kwargs):
        """
        Delete Role for matching Id
        [Args]
            (int) Id
        [Returns]
            (dict) Delete Role Response
        """
        self._load_kwargs(kwargs)
        banner("PCC.Delete Role [Id=%s]" % self.Id)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.delete_role_by_id(conn, self.Id)