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

class Cli(AaBase):
    """ 
    Cli
    """

    def __init__(self):
        self.cmd = None
        self.host_ip = None
        self.linux_password = None
        self.linux_user = None
        super().__init__()

    ###########################################################################
    @keyword(name="CLI.Run")
    ###########################################################################
    def cli_run(self, *args, **kwargs):
        """
        CLI Run
        [Args]
            (str) cmd: 
            (str) host_ip:
            (str) linux_password:
            (str) linux_user:
        [Returns]
            (dict) Response: CLI Run response
        """
        self._load_kwargs(kwargs)
        banner("CLI.Run ip=%s [cmd=%s]" % (self.host_ip, self.cmd))
        return easy.cli_run(self.host_ip, self.linux_user, self.linux_password, self.cmd)
