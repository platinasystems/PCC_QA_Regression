import re
import time
import json
import ast

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print, cmp_json, midtext
from pcc_qa.common.Result import get_response_data
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60*40

class Pcc(PccBase):

    """
    Ceph Cluster
    """

    def __init__(self):

        # Robot arguments definitions

        self.user="pcc"
        self.password="cals0ft"
        self.hostip = None

        super().__init__()

    ###############################################################################################################
    @keyword(name="PCC.Get PCC Version")
    ###############################################################################################################

    def get_pcc_version(self, *args, **kwargs):
        banner("Get Pcc Version")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            # Get Pcc Version
            cmd = "docker exec -t pccserver ./pccserver --version"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user, linux_password=self.password)
            print("cmd: {} executed successfully and status is: {}".format(cmd, status))
            return status

        except Exception as e:
            trace("Error in getting pcc version: {}".format(e))
