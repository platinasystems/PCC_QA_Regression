from pcc_qa.common.PccBase import PccBase
from robot.libraries.BuiltIn import BuiltIn
from platina_sdk import pcc_api as pcc
from pcc_qa.common.Utils import banner
from pcc_qa.common.Result import get_response_data
import re
from robot.api.deco import keyword

class Search(PccBase):
    """
    Search
    """
    def __init__(self):
        self.key = ""
        self.value = ""

        super().__init__()


    ###########################################################################
    @keyword(name="PCC.Get Search Data")
    ###########################################################################
    def get_search_data(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Get Search Data")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        return pcc.audit_search(conn)

    ###########################################################################
    @keyword(name="PCC.Find In Search Data")
    ###########################################################################
    def find_search_data(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Find In Search Data")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        search_data = get_response_data(pcc.audit_search(conn))

        for data in search_data:
            key_data = str(data[self.key])
            print(key_data)
            if re.search(self.value,key_data):
                return "OK"
        return "Error"





