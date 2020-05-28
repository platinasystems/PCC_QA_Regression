import time
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from platina_sdk import pcc_api as pcc
from aa.common import PccEasyApi as easy
from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data, get_result
from aa.common.AaBase import AaBase

class Applications(AaBase):
    """ 
    Applications
    """

    def __init__(self):
        self.Name = None
        self.Id = None
        self.Description = None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Get Applications")
    ###########################################################################
    def get_applications(self, *args, **kwargs):
        """
        Get Applications
        [Args]
            None
        [Returns]
            (dict) List of Applications from PCC
        """
        banner("PCC.Get Applications")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_apps(conn)

    ###########################################################################
    @keyword(name="PCC.Get Application Id")
    ###########################################################################
    def get_application_id(self, *args, **kwargs):
        """
        Get Application Id
        [Args]
            (str) Name: Of the application we want Id
        [Returns]
            (int) Id: If found id of the application, otherwise None
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Application Id [Name=%s]" % self.Name)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_app_id_by_name(conn, self.Name)
