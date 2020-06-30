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
        self.ApplicationId = None
        self.Active = None
        self.Files = []
        self.ProfileActive = None
        self.MaxBuckets = None
        self.maxBucketObjects = None
        self.maxBucketSize = None
        self.maxObjectSize = None
        self.maxUserSize = None
        self.maxUserObjects = None
        
        
        
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
                (dict) Data: 
                      {
                    
                        "name":"test",
                        "type":"ceph",
                        "applicationId":null,
                        "active":true,
                        "profile":{
                            "username":"testuser",
                            "email":"test123@test.com",
                            "active":true,
                            "maxBuckets":"2000",
                            "maxBucketObjects":2000,
                            "maxBucketSize":3994,
                            "maxObjectSize":2000,
                            "maxUserSize":7,
                            "maxUserObjects":30
                        },
                        "files":[]
                    
                    }  
                
            [Returns]
                (dict) Response: Add Metadata Profile response
                
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add Metadata Profile")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        print("Kwargs are: {}".format(kwargs))        
        
        payload =  {"name":self.Name,
                    "type":self.Type,
                    "applicationId":self.ApplicationId,
                    "active":bool(self.Active),
                    "files":self.Files,
                    "profile":{"username":self.Username,
                               "email":self.Email,
                               "active":self.ProfileActive,
                               "maxBuckets":self.MaxBuckets,
                               "maxBucketObjects":self.maxBucketObjects,
                               "maxBucketSize":self.maxBucketSize,
                               "maxObjectSize":self.maxObjectSize,
                               "maxUserSize":self.maxUserSize,
                               "maxUserObjects":self.maxUserObjects
                              }
                    
                    }                             
        dump = json.dumps(payload)
        multipart_data = {'data':(None,dump)}
    
        print("multipart_data: {}".format(multipart_data))
        response = pcc.add_metadata_profile(conn, multipart_data)
        print("Response from keyword: {}".format(response))
        return response
        
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
    def get_application_credential_profile_by_id(self, *args, **kwargs):
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
        return pcc.get_application_credential_profile_by_id(conn, str(self.Id))
        
    ###########################################################################
    @keyword(name="PCC.Get Profile By Type")
    ###########################################################################
    def get_application_credential_profile_by_type(self, *args, **kwargs):
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
        return pcc.get_application_credential_profile_by_type(conn, str(self.Type))
        
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
    def get_application_credential_profiles(self, *args, **kwargs):
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
        return pcc.get_application_credential_profiles(conn)
        
    ###########################################################################
    @keyword(name="PCC.Describe Profile By Id")
    ###########################################################################
    def describe_application_credential_profile_by_id(self, *args, **kwargs):
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
        return pcc.describe_application_credential_profile_by_id(conn, str(self.Id))
        
    ###########################################################################
    @keyword(name="PCC.Describe Profile per Type")
    ###########################################################################
    def describe_application_credential_profile_per_type(self, *args, **kwargs):
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
        return pcc.describe_application_credential_profile_per_type(conn, str(self.Type))
        
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
    def describe_application_credential_profiles(self, *args, **kwargs):
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
        return pcc.describe_application_credential_profiles(conn)
        
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
    def delete_application_credential_profile_by_id(self, *args, **kwargs):
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
        Id= easy.get_metadata_profile_id_by_name(conn,Name=self.Name)
        print("Id response: {}".format(Id))
        return pcc.delete_application_credential_profile_by_id(conn, str(Id))

    
        
    
        
    
        
