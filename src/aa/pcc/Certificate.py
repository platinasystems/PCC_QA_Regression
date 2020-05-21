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

class Certificate(AaBase):
    """ 
    Certificate
    """

    def __init__(self):
        self.Alias = None
        self.Filename = None
        self.Description = None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Add Certificate")
    ###########################################################################
    def add_certificate(self, *args, **kwargs):
        """
        Add Certificate
        [Args]
            (str) Alias: 
            (str) Filename:
            (str) Description:
        [Returns]
            (dict) Response: Add Certificate response
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add Certificate [Alias=%s]" % self.Alias)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        filename_path = os.path.join("tests/test-data", self.Filename)
        return pcc.add_certificate(conn, self.Alias, self.Description, filename_path)

    ###########################################################################
    @keyword(name="PCC.Delete Certificate")
    ###########################################################################
    def delete_certificate(self, *args, **kwargs):
        """
        Delete Certificate
        [Args]
            (str) Alias
        [Returns]
            (dict) Delete Certificate Response
        """
        self._load_kwargs(kwargs)
        banner("Kwargs are: {}".format(kwargs))
        banner("PCC.Delete Certificate [Alias=%s]" % self.Alias)
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        certificate_id = easy.get_certificate_id_by_name(conn, Name = self.Alias)
        banner("Certificate id is: {}".format(certificate_id))
        return pcc.delete_certificate_by_id(conn, Id=str(certificate_id))
        
        
        
