import time
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data, get_result
from pcc_qa.common.PccBase import PccBase

class Users(PccBase):
    """ 
    Roles
    """

    def __init__(self):
        self.UserName = None
        self.Tenant_ID = None
        self.FirstName = None
        self.LastName = None
        self.Email = None
        self.Role_ID =None
        self.Active = None
        self.Token = None
        self.Password = None
        super().__init__()

        '''
        {"username": "anurag.jain@calsoftinc.com", "tenant": 4, "firstname": "Anurag", "lastname": "jain",
         "email": "anurag.jain@calsoftinc.com", "roleID": 8, "active": true,
         "source": "https://172.17.2.218:9999/gui/setPass", "protect": false}
        '''
    ###########################################################################
    @keyword(name="PCC.Add Read Only User")
    ###########################################################################
    def add_read_only_user(self, *args, **kwargs):
        """
        Add User
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add User [Name=%s]" % self.UserName)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        payload = {
            "firstname": self.FirstName,
            "Lastname": self.LastName,
            "email": self.Email,
            "roleID": self.Role_ID,
            "active": 'true'
        }
        return pcc.add_user(conn,payload)

    ###########################################################################
    @keyword(name="PCC.Create User Password")
    ###########################################################################
    def create_user_password(self, *args, **kwargs):
        """
        Create User Password
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add User [Name=%s]" % self.Link)
        conn = BuiltIn().get_variable_value("${password_token}")

        payload = {"password": self.Password}


        return pcc.add_user(conn,payload)
