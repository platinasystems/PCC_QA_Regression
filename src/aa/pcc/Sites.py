import time
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from platina_sdk import pcc_easy_api as easy

from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data, get_result
from aa.common.AaBase import AaBase

class Sites(AaBase):
    """ 
    Sites
    """

    def __init__(self):
        self.Name = None
        self.Id = None
        self.Ids = []
        self.owner = 0
        self.Description = None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Add Site")
    ###########################################################################
    def add_site(self, *args, **kwargs):
        """
        Add Site to PCC
        [Args]
            (str) Name: Name of the site
            (int) owner: 
            (str) Description: Description of the group
        [Returns]
            (dict) Response: Add Site response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add Site [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        try:
            payload = {
                "Name": self.Name,
                "Description": self.Description,
                "owner": self.owner
            }
        except Exception as e:
            raise e
        return pcc.add_site(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Get Sites")
    ###########################################################################
    def get_sites(self, *args, **kwargs):
        """
        Get sites from PCC
        [Args]
            None
        [Returns]
            (dict) Response: Get Sites response (includes any errors)
        """
        banner("PCC.Get Sites")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        return pcc.get_sites(conn)

    ###########################################################################
    @keyword(name="PCC.Get Site")
    ###########################################################################
    def get_site(self, *args, **kwargs):
        """
        Get Site from PCC
        [Args]
            (int) Id
        [Returns]
            (dict) Response: Get Site response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Site [Id=%s]" % self.Id)
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_site_by_id(conn, self.Id)


    ###########################################################################
    @keyword(name="PCC.Get Site Id")
    ###########################################################################
    def get_site_id(self, *args, **kwargs):
        """
        Get Site Id
        [Args]
            (str) Name
        [Returns]
            (int) Id: Site Id if there is one, 
                None: If not found
        """
        self._load_kwargs(kwargs)
        if self.Name == None:
            raise Exception("[PCC.Get Site Id]: Name of the site is not specified.")
        banner("PCC.Get Site Id [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_site_id_by_name(conn, self.Name)

    ###########################################################################
    @keyword(name="PCC.Delete Site")
    ###########################################################################
    def delete_site(self, *args, **kwargs):
        """
        Delete Sites for matching Ids
        [Args]
            (list) Ids
        [Returns]
            (dict) Delete Site Response
        """
        self._load_kwargs(kwargs)
        banner("PCC.Delete Sites [Ids=%s]" % self.Ids)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.delete_sites(conn, self.Ids)
