import time
import ast
from robot.api.deco import keyword
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy
from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data, get_status_code
from pcc_qa.common.PccBase import PccBase

class Tags(PccBase):
    """
    Tags
    """

    def __init__(self):
        self.Name = ""
        self.Id = None
        self.Description = ""
        self.PolicyIDs = None
        self.Policies = None

        super().__init__()

    ###########################################################################
    @keyword(name="PCC.List Tags")
    ###########################################################################
    def get_tags(self, *args, **kwargs):
        banner("PCC.List Tags")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        return pcc.get_tags(conn)

    ###########################################################################
    @keyword(name="PCC.Get Tag By Name")
    ###########################################################################
    def get_tag_by_name(self, *args, **kwargs):
        banner("PCC.Get Tag By Name")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        tags = get_response_data(pcc.get_tags(conn))

        for tag in tags:
            if tag["name"] == self.Name:
                return tag
        return "Not Found"

    ###########################################################################
    @keyword(name="PCC.Get Tag By Id")
    ###########################################################################
    def get_tag_by_id(self, *args, **kwargs):
        banner("PCC.Get Tag By Id")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        tags = get_response_data(pcc.get_tags(conn))

        for tag in tags:
            if tag["id"] == self.Id:
                return tag
        return "Not Found"

    ###########################################################################
    @keyword(name="PCC.Create Tag")
    ###########################################################################
    def add_tag(self, *args, **kwargs):
        banner("PCC.Create Tag")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        if self.PolicyIDs:
            self.PolicyIDs = ast.literal_eval(self.PolicyIDs)
        else:
            self.PolicyIDs = []

        payload = {
            "name": self.Name,
            "description": self.Description,
            "policyIDs": self.PolicyIDs
        }

        print("payload:-" + str(payload))
        return pcc.add_tag(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Edit Tag")
    ###########################################################################
    def edit_tag(self, *args, **kwargs):
        banner("PCC.Edit Tag")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        if self.PolicyIDs:
            self.PolicyIDs = ast.literal_eval(self.PolicyIDs)
        else:
            self.PolicyIDs = []

        payload = {
            "id": self.Id,
            "name": self.Name,
            "description": self.Description,
            "policyIDs": self.PolicyIDs
        }

        print("payload:-" + str(payload))
        return pcc.edit_tag(conn, str(self.Id), payload)

    ###########################################################################
    @keyword(name="PCC.Delete Tag")
    ###########################################################################
    def delete_tag(self, *args, **kwargs):
        banner("PCC.Delete Tag")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        return pcc.delete_tag(conn, str(self.Id))

    ###########################################################################
    @keyword(name="PCC.Delete All Tag")
    ###########################################################################
    def delete_all_tag(self, *args, **kwargs):
        banner("PCC.Delete All Tag")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        tags = get_response_data(pcc.get_tags(conn))
        if not tags:
            return "OK"
        result = "OK"
        for tag in tags:
           resp = pcc.delete_tag(conn, str(tag["id"]))
           status_code = get_status_code(resp)
           if status_code != 200:
               result = "Error"
        return result







