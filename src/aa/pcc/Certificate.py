import time
import os
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy
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
        self.Private_key = None
        self.Certificate_upload = None
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
        banner("Kwargs are: {}".format(kwargs))
        if self.Private_key:
            private_key_path = os.path.join("tests/test-data", self.Private_key)
            certificate_path = os.path.join("tests/test-data", self.Certificate_upload)
            multipart_data = {'key': open(private_key_path, 'rb'),'file': open(certificate_path, 'rb'),  'description':(None, self.Description)}
            print("multipart data: {}".format(multipart_data))
        else:
            certificate_path = os.path.join("tests/test-data", self.Certificate_upload)
            multipart_data = {'file': open(certificate_path, 'rb'), 'description':(None, self.Description)}
            print("multipart data: {}".format(multipart_data))
        return pcc.add_certificate(conn, self.Alias, self.Description, multipart_data=multipart_data)

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
        return pcc.delete_certificate_by_id(conn, id=str(certificate_id))
        
    ###########################################################################
    @keyword(name="PCC.Get Certificate Id")
    ###########################################################################
    def get_certificate_id(self, *args, **kwargs):
        """
        Get Certificate Id
        [Args]
            (str) Alias
        [Returns]
            (dict) Get Certificate Id
        """
        self._load_kwargs(kwargs)
        banner("Kwargs are: {}".format(kwargs))
        banner("PCC.Get Certificate Id [Alias=%s]" % self.Alias)
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_certificate_id_by_name(conn, Name = self.Alias)

    ###############################################################################################################
    @keyword(name="PCC.Delete All Certificates")
    ###############################################################################################################

    def cleanup_certificates(self, *args, **kwargs):
        """
        PCC.Delete All Certificates
        [Args]
            None

        [Returns]
            (str) OK: Returns "OK" if all certificates are cleaned from PCC
            else: returns "Error"
        """

        banner("PCC.Delete All Certificates")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        certificate_deletion_status=[]
        try:
            certificate_list = pcc.get_certificates(conn)['Result']
            if certificate_list == []:
                return "OK"
            else:
                for certificate in certificate_list:
                    print("========= Deleting {} certificate ===========".format(certificate['alias']))
                    response= pcc.delete_certificate_by_id(conn, id=str(certificate['id']))
                    statuscode = response["StatusCode"]
                    print("Status code is :{}".format(statuscode))
                    certificate_deletion_status.append(str(statuscode))
                status = len(certificate_deletion_status) > 0 and all(elem == "200" for elem in certificate_deletion_status)
                if status:
                    return "OK"
                return "All certificates not deleted: {}".format(certificate_deletion_status)
        except Exception as e:
            return {"Error": str(e)}
        
        
        
