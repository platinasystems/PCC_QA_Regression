from pcc_qa.common.PccBase import PccBase
from robot.api.deco import keyword
from pcc_qa.common.Utils import banner
from robot.libraries.BuiltIn import BuiltIn
from platina_sdk import pcc_api as pcc

class CephTrust(PccBase):

    """
    Ceph Trust
    """

    def __init__(self):

        # Robot arguments definitions
        self.id = None
        self.status = ""
        self.deployStatus= ""
        self.progressPercentage = None
        self.remoteID = None
        self.trustFileLink = ""
        self.appType = "rgw"
        self.masterAppID = None
        self.masterAppID = ""
        self.side = ""
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Ceph Primary Start Trust")
    ###########################################################################
    def primary_start_trust(self, *args, **kwargs):
        banner("PCC.Ceph Primary Start Trust")
        self._load_kwargs(kwargs)

        payload = {
            "side": "master",
            "masterAppID": self.masterAppID,
            "appType": self.appType
        }

        print(payload)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.start_trust_creation(conn, payload)






