import time
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from platina_sdk import pcc_easy_api as easy

from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data, get_result
from aa.common.AaBase import AaBase

class OpenSSHKeys(AaBase):
    """ 
    OpenSSHKeys
    """

    def __init__(self):
        self.Alias = None
        self.Filename = None
        self.Description = None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Add OpenSSH Key")
    ###########################################################################
    def add_openssh_key(self, *args, **kwargs):
        """
        Add OpenSSH Key
        [Args]
            (str) Alias: 
            (str) Filename:
            (str) Description:
        [Returns]
            (dict) Response: Add SSHKeys response
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add OpenSSH Key [Alias=%s]" % self.Alias)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.add_openssh_key(conn, self.Alias, self.Description, self.Filename)

    ###########################################################################
    @keyword(name="PCC.Delete OpenSSH Key")
    ###########################################################################
    def delete_openssh_key(self, *args, **kwargs):
        """
        Delete OpenSSH Key
        [Args]
            (str) Alias
        [Returns]
            (dict) Delete OpenSSH Key Response
        """
        self._load_kwargs(kwargs)
        banner("PCC.Delete OpenSSH Key [Alias=%s]" % self.Alias)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.delete_openssh_key(conn, self.Alias)
