import time
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data, get_result
from pcc_qa.common.PccBase import PccBase

class Roles(PccBase):
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
        self.Owner=None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Add Read Only Role")
    ###########################################################################
    def add_read_only_role(self, *args, **kwargs):
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
        print("conn is {}".format(conn))
        payload = {
            "name": self.Name,
            "description": self.Description,
            "owner": int(self.owner),
            "groupOperations":[{"id":1},{"id":3},{"id":5},{"id":7},{"id":9}]
        }
        return pcc.add_user_role(conn,payload)


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
        print("conn is {}".format(conn))
        return easy.add_role(conn, self.Name, self.Description, self.owner, self.groupOperations)

    ###########################################################################
    @keyword(name="PCC.Get Role Id")
    ########################################################################### 
    def get_role_id_by_name(self, *args, **kwargs):
        """
        Get Role Id by Name
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Role 
        [Returns]
            (int) Id: Id of the matchining Role, or
                None: if no match found, or
            (dict) Error response: If Exception occured
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Role Id by Name [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        #role_list = pcc.get_user_roles(conn)['Result']['Data']
        role_list = pcc.get_user_roles(conn)['Result']
        print('role_list= ',role_list)
        try:
            for role in role_list:
                if (str(role['owner']) == str(self.Owner)) and (str(role['name']) == str(self.Name)):
                    return role['id']
            return None
        except Exception as e:
            return {"Error": str(e)}
   

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

    ###########################################################################
    @keyword(name="PCC.Validate Role")
    ###########################################################################
    def validate_role_by_name(self, *args, **kwargs):
        """
        Validate Role
            (str) Name: Name of the Role
        [Returns]
            "OK" if Name is found
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Role Id by Name [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        # role_list = pcc.get_user_roles(conn)['Result']['Data']
        role_list = pcc.get_user_roles(conn)['Result']
        print('role_list= {}'.format(role_list))
        try:
            for role in role_list:
                if str(role['name']) == str(self.Name):
                    return "OK"
            return "Error"
        except Exception as e:
            return {"Error": str(e)}
