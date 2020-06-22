import re
import time
import json
import ast

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy

from aa.common.Utils import banner, trace, pretty_print, cmp_json
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase
from aa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60*40

class ApplicationCredentialManager(AaBase):

    """ 
    Application Credential Manager
    """

    def __init__(self):

        # Robot arguments definitions
        
        self.pgpassword = None
        self.tenant_name = None
        self.setup_ip = None
        self.user = "pcc"
        self.password = "Cals0ft" 
        self.Id = None  
        self.Type = None
        self.Name = None
        self.Username = None
        self.Email = None
        self.Type = None
        self.Filename = None
        
        
        
        super().__init__()
        
    ###########################################################################
    @keyword(name="PCC.Verify Tenant Buckets")
    ###########################################################################
    def verify_tenant_buckets(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Verify Tenant Buckets")

        print("kwargs in Verify Tenant Buckets :-  "+str(kwargs))        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        ####  cmd ---- '''PGPASSWORD=plat1na psql -h 172.17.2.213 -U jwtuser jwt -c "SELECT * from tenants where name='platina';"'''
        
        cmd = '''PGPASSWORD={} psql -h {} -U jwtuser jwt -c "SELECT * from tenants where name='{}';"'''.format(self.pgpassword, self.setup_ip, self.tenant_name)
        
        
        output=cli_run(cmd=cmd, host_ip=self.setup_ip, linux_user=self.user, linux_password=self.password)
        
        serialise_output=json.loads(self._serialize_response(time.time(),output)['Result']['stdout'])
        print("Serialize Output:"+str(serialise_output))
        trace("Serialize Output:- %s " % (serialise_output))
        
        if serialise_output['status']==200 and serialise_output['error']=="":
            return serialise_output
        return "Error"
        
        
    ###########################################################################
    @keyword(name="PCC.Add Metadata Profile")
    ###########################################################################
    def add_metadata_profile(self, *args, **kwargs):
        """
        Add Metadata Profile
        [Args]
            (str) Filename:
            (str) data:
        [Returns]
            (dict) Response: Add Metadata Profile response
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add Metadata Profile")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        print("Kwargs are: {}".format(kwargs))
        if self.Filename:
            filename_path = os.path.join("tests/test-data", self.Filename)
        else:
            filename_path = None
        
        payload = {
                  "name":self.Name,
                  "type":self.Type,
                  "profile":{
                             "username":self.Username,
                             "email":self.Email 
                            }
                  }
        
        '''
        payload = {
                  '\"name\"':self.Name.replace("'","'\""),
                  '\"type\"':self.Type.replace("'","'\""),
                  '\"profile\"':{
                             '\"username\"':self.Username.replace("'","'\""),
                             '\"email\"':self.Email.replace("'","'\"")
                            }
                  }
        '''
        print("Type of payload is {} \n Payload is {}".format(type(payload),payload))
        return pcc.add_metadata_profile(conn, payload, filename_path)
        
    ###########################################################################
    @keyword(name="PCC.Get Metadata Profiles")
    ###########################################################################
    def get_metadata_profiles(self, *args, **kwargs):
        """
        Get Metadata Profiles from PCC
        [Args]
            None
        [Returns]
            (dict) Response: Get Metadata Profiles response (includes any errors)
        """
        banner("PCC.Get Metadata Profiles")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_metadata_profiles(conn)
        
    ###########################################################################
    @keyword(name="PCC.Get Profile by Id")
    ###########################################################################
    def get_authprofile_by_id(self, *args, **kwargs):
        """
        Get Profile by Id
        [Args]
            None
        [Returns]
            (dict) Response: Get Profile by Id response (includes any errors)
        """
        banner("PCC.Get Profile by Id")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_authprofile_by_id(conn, str(self.Id))
        
    ###########################################################################
    @keyword(name="PCC.Get Profile By Type")
    ###########################################################################
    def get_profile_by_type(self, *args, **kwargs):
        """
        Get Profile By Type
        [Args]
            None
        [Returns]
            (dict) Response: Get Profile By Type response (includes any errors)
        """
        banner("PCC.Get Profile By Type")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_profile_by_type(conn, str(self.Type))
        
    ###########################################################################
    @keyword(name="PCC.Get Metadata Profile By Type")
    ###########################################################################
    def get_metadata_profile_by_type(self, *args, **kwargs):
        """
        Get Metadata Profile By Type
        [Args]
            None
        [Returns]
            (dict) Response: Get Metadata Profile By Type response (includes any errors)
        """
        banner("PCC.Get Metadata Profile By Type")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_metadata_profile_by_type(conn, str(self.Type))
        
    ###########################################################################
    @keyword(name="PCC.Get Profiles")
    ###########################################################################
    def get_authprofiles(self, *args, **kwargs):
        """
        Get Profiles
        [Args]
            None
        [Returns]
            (dict) Response: Get Profiles response (includes any errors)
        """
        banner("PCC.Get Profiles")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_authprofiles(conn)
        
    ###########################################################################
    @keyword(name="PCC.Describe Profile By Id")
    ###########################################################################
    def describe_profile_by_id(self, *args, **kwargs):
        """
        Describe Profile By Id
        [Args]
            None
        [Returns]
            (dict) Response: Describe Profile By Id response (includes any errors)
        """
        banner("PCC.Describe Profile By Id")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.describe_profile_by_id(conn, str(self.Id))
        
    ###########################################################################
    @keyword(name="PCC.Describe Profile per Type")
    ###########################################################################
    def describe_profile_per_type(self, *args, **kwargs):
        """
        Describe Profile per Type
        [Args]
            None
        [Returns]
            (dict) Response: Describe Profile per Type response (includes any errors)
        """
        banner("PCC.Describe Profile per Type")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.describe_profile_per_type(conn, str(self.Type))
        
    ###########################################################################
    @keyword(name="PCC.Describe Metadata Profile per Type")
    ###########################################################################
    def describe_metadata_profile_per_type(self, *args, **kwargs):
        """
        Describe Metadata Profile per Type
        [Args]
            None
        [Returns]
            (dict) Response: Describe Metadata Profile per Type response (includes any errors)
        """
        banner("PCC.Describe Metadata Profile per Type")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.describe_metadata_profile_per_type(conn, str(self.Type))
        
    ###########################################################################
    @keyword(name="PCC.Describe Profiles")
    ###########################################################################
    def describe_profiles(self, *args, **kwargs):
        """
        Describe Profiles
        [Args]
            None
        [Returns]
            (dict) Response: Describe Profiles response (includes any errors)
        """
        banner("PCC.Describe Profiles")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.describe_profiles(conn)
        
    ###########################################################################
    @keyword(name="PCC.Describe Metadata Profiles")
    ###########################################################################
    def describe_metadata_profiles(self, *args, **kwargs):
        """
        Describe Metadata Profiles
        [Args]
            None
        [Returns]
            (dict) Response: Describe Metadata Profiles response (includes any errors)
        """
        banner("PCC.Describe Metadata Profiles")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.describe_metadata_profiles(conn, str(self.Type))
        
    ###########################################################################
    @keyword(name="PCC.Delete Profile By Id")
    ###########################################################################
    def delete_authprofile_by_id(self, *args, **kwargs):
        """
        Delete Profile By Id
        [Args]
            None
        [Returns]
            (dict) Response: Delete Profile By Id response (includes any errors)
        """
        banner("PCC.Delete Profile By Id")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.delete_authprofile_by_id(conn, str(self.Id))
    
        
    
        
    
        
