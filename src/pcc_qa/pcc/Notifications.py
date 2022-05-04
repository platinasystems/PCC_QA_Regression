from platina_sdk import pcc_api as pcc
from robot.api.deco import keyword
from pcc_qa.common.PccBase import PccBase
from robot.libraries.BuiltIn import BuiltIn
from pcc_qa.common.Utils import banner, trace

class Notifications(PccBase):


    def __init__(self):
        self.id=None
        self.type=""
        self.message=""

        # Robot arguments definitions
        super().__init__()


    ###########################################################################
    @keyword(name="PCC.Find Notification")
    ###########################################################################
    def find_notification(self, *args, **kwargs):

        self._load_kwargs(kwargs)
        banner("PCC.Find Notification")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        notifications = pcc.get_notification_history(conn)
        for n in notifications["Result"]["Data"]:
            if n["type"] == self.type and self.message in n["message"]:
                return "OK"
        return "Not Found"
