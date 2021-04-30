import time
import os
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data, get_result
from pcc_qa.common.PccBase import PccBase

class OpenSSHKeys(PccBase):
    """ 
    OpenSSHKeys
    """

    def __init__(self):
        self.Alias = None
        self.Filename = None
        self.Description = None
        self.Type = None
        self.Name = None
        super().__init__()  
        
        
    ###########################################################################
    @keyword(name="PCC.Add OpenSSH Key")
    ###########################################################################
    def add_openssh_key(self, *args, **kwargs):
        """
        Add OpenSSH Key
        [Args]
            (str) Alias: 
            (str) Filename:
            (str) Description:
        [Returns]
            (dict) Response: Add SSHKeys response
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add OpenSSH Key [Alias=%s]" % self.Alias)
        
        print("Kwargs are: {}".format(kwargs))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        filename_path = os.path.join("tests/test-data", self.Filename)
        multipart_data = {'file': open(filename_path, 'rb'), 'description':(None, self.Description)}
        
        print("Filename_path is {}".format(filename_path))
        return pcc.add_keys(conn, alias = self.Alias, description=self.Description,multipart_data=multipart_data )
        
    ###########################################################################
    @keyword(name="PCC.Get OpenSSH Key Id")
    ###########################################################################
    
    def get_openssh_key_id(self, *args, **kwargs):
        
        """
        Get OpenSSH Key Id
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the OpenSSH Key who's id is required (name=<Name>)
    
        [Returns]
            (int) Id: Id of the OpenSSH Key, or
                None: if no match found, or
            (dict) Error response: If Exception occured
        """
        
        banner("PCC.Get OpenSSH Key Id")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_openssh_keys_id_by_name(conn, self.Name)         

    ###########################################################################
    @keyword(name="PCC.Delete OpenSSH Key")
    ###########################################################################
    def delete_openssh_key(self, *args, **kwargs):
        """
        Delete OpenSSH Key
        [Args]
            (str) Alias
        [Returns]
            (dict) Delete OpenSSH Key Response
        """
        self._load_kwargs(kwargs)
        banner("PCC.Delete OpenSSH Key [Alias=%s]" % self.Alias)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        banner("Kwargs are: {}".format(kwargs))
        return pcc.delete_keys_by_alias(conn, alias = self.Alias)

    ###############################################################################################################
    @keyword(name="PCC.Delete All Keys")
    ###############################################################################################################   
    
    def cleanup_keys(self, *args, **kwargs):
        """
        PCC.Delete All Keys
        [Args]
            None
           
        [Returns]
            (str) OK: Returns "OK" if all keys are cleaned from nodes
            else: returns "Error"
        """
        
        banner("PCC.Delete All Keys")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        keys_deletion_status=[]
        try:
            keys_list = pcc.get_keys(conn)['Result']
            if keys_list == []:
                return "OK"
            else:
                for key in keys_list:
                    print("========= Deleting {} key ===========".format(key['alias']))
                    response= pcc.delete_keys_by_alias(conn, alias = key['alias'])
                    statuscode = response["StatusCode"]
                    print("Status code is :{}".format(statuscode))
                    keys_deletion_status.append(str(statuscode))
                status = len(keys_deletion_status) > 0 and all(elem == "200" for elem in keys_deletion_status)
                if status:
                    return "OK"
                return "All keys not deleted: {}".format(keys_deletion_status)
        except Exception as e:
            return {"Error": str(e)}
