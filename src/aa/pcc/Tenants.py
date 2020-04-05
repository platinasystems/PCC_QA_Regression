import time
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from platina_sdk import pcc_api as pcc
from platina_sdk import pcc_easy_api as easy
from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data, get_result
from aa.common.AaBase import AaBase

class Tenants(AaBase):
    """ 
    Tenants
    """

    def __init__(self):
        self.Name = None
        self.Id = None
        self.Description = None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Get Tenant List")
    ###########################################################################
    def get_tenant_list(self, *args, **kwargs):
        """
        Get list of tenants from PCC
        [Args]
            None
        [Returns]
            (dict) Response dictionary: Including the list of tenants
            (dict) Error response: If Exception occured
        """
        banner("PCC.Get Tenant List")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_tenant_list(conn)

    ###########################################################################
    @keyword(name="PCC.Get Tenant Id")
    ###########################################################################
    def get_tenant_id(self, *args, **kwargs):
        """
        Get Id of tenant with matching Name from PCC
        [Args]
            Name
        [Returns]
            (int) Id: Id of the matchining tenant, or
                None: if no match found, or
            (dict) Error response: If Exception occured
        """

        self._load_kwargs(kwargs)
        banner("PCC.Get Tenant Id [name=%s]" % self.Name)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_tenant_id(conn, self.Name)
