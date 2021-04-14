import time
import ast
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy
from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data, get_result
from pcc_qa.common.PccBase import PccBase

class Applications(PccBase):
    """ 
    Applications
    """

    def __init__(self):
        self.Name = None
        self.Id = None
        self.Description = None
        self.app_list = []
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Get Applications from Application Catalog")
    ###########################################################################
    def get_applications_from_app_catalog(self, *args, **kwargs):
        """
        Get Applications From App Catalog
        [Args]
            None
        [Returns]
            (dict) List of Applications from PCC
        """
        banner("PCC.Get Applications")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_templates(conn)

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
        
    ###########################################################################
    @keyword(name="PCC.Get Policy Enabled Apps")
    ###########################################################################
    def get_policy_enabled_apps(self, *args, **kwargs):
        """
        Get Policy Enabled Apps
        [Args]
            None
        [Returns]
            (dict) List of Policy Enabled Apps from PCC
        """
        banner("PCC.Get Policy Enabled Apps")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_policy_enabled_apps(conn)
        
    ###########################################################################
    @keyword(name="PCC.Validate Applications Present on PCC")
    ###########################################################################
    def validate_apps_on_pcc(self, *args, **kwargs):
        """
        PCC.Validate Applications Present on PCC
        [Args]
            None
        [Returns]
            (dict) List of Applications from PCC
        """
        banner("PCC.Validate Applications Present on PCC")
        self._load_kwargs(kwargs)
        print("Kwargs are: {}".format(kwargs))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        response = pcc.get_templates(conn)
        #return response
        
        temp_app_list = []
        for data in get_response_data(response):
            print(data)
            temp_app_list.append(data['longName'])
        print("app list from PCC: {}".format(temp_app_list))        
        if "app_list" in kwargs:
            self.app_list= ast.literal_eval(self.app_list)
        
        print("app list from user: {}".format(self.app_list)) 
        result = (set(self.app_list).issubset(set(temp_app_list)))
        print("Result is: {}".format(result))
        if result:
            return "OK"
        else:
            return "App doesnot exists: {}".format(list(set(self.app_list) - set(temp_app_list)))
