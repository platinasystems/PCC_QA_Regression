import re
import time
import json
import ast

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from robot.api import logger

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print, cmp_json
from pcc_qa.common.Result import get_response_data
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60*40

class ApplicationCredentialManager(PccBase):

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
        self.readPermission = True
        self.writePermission = True
        self.deletePermission = True
        
        
        
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
        if "MaxBuckets" in kwargs:
            if kwargs['MaxBuckets'].isnumeric(): 
                self.MaxBuckets= ast.literal_eval(self.MaxBuckets)
            else:
                self.MaxBuckets= kwargs['MaxBuckets']
        if "maxBucketObjects" in kwargs:
            if kwargs['maxBucketObjects'].isnumeric(): 
                self.maxBucketObjects = ast.literal_eval(self.maxBucketObjects)
            else:
                self.maxBucketObjects= kwargs['maxBucketObjects']
        if "maxBucketSize" in kwargs:
            if kwargs['maxBucketSize'].isnumeric(): 
                self.maxBucketSize = ast.literal_eval(self.maxBucketSize)
            else:
                self.maxBucketSize= kwargs['maxBucketSize']
        if "maxObjectSize" in kwargs:
            if kwargs['maxObjectSize'].isnumeric(): 
                self.maxObjectSize = ast.literal_eval(self.maxObjectSize)
            else:
                self.maxObjectSize= kwargs['maxObjectSize']
        if "maxUserSize" in kwargs:
            if kwargs['maxUserSize'].isnumeric(): 
                self.maxUserSize = ast.literal_eval(self.maxUserSize)
            else:
                self.maxUserSize= kwargs['maxUserSize']
        if "maxUserObjects" in kwargs:
            if kwargs['maxUserObjects'].isnumeric(): 
                self.maxUserObjects = ast.literal_eval(self.maxUserObjects)
            else:
                self.maxUserObjects= kwargs['maxUserObjects']
        
        
        payload =  {"name":self.Name,
                    "type":self.Type,
                    "applicationId":self.ApplicationId,
                    "active":bool(self.Active),
                    "files":self.Files,
                    "profile":{
                               "readPermission":self.readPermission,
                               "deletePermission":self.deletePermission,
                               "writePermission":self.writePermission, 
                               "active":self.ProfileActive,
                               "maxBuckets":self.MaxBuckets,
                               "maxBucketObjects":self.maxBucketObjects,
                               "maxBucketSize":self.maxBucketSize,
                               "maxObjectSize":self.maxObjectSize,
                               "maxUserSize":self.maxUserSize,
                               "maxUserObjects":self.maxUserObjects
                              }
                    
                    } 
        print("Payload is {}".format(payload))                            
        dump = json.dumps(payload)
        multipart_data = {'data':(None,dump)}
    
        print("multipart_data: {}".format(multipart_data))
        response = pcc.add_metadata_profile(conn, multipart_data)
        print("Response from keyword: {}".format(response))
        return response
        
    ###########################################################################
    @keyword(name="PCC.Update Metadata Profile")
    ###########################################################################
    def update_metadata_profile(self, *args, **kwargs):
        """
        Update Metadata Profile
            [Args]
                (dict) Data: 
                      {
                        "id":2
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
                (dict) Response: Update Metadata Profile response
                
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add Metadata Profile")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        print("Kwargs are: {}".format(kwargs))
                
        payload =  {"id":self.Id,
                    "name":self.Name,
                    "type":self.Type,
                    "applicationId":self.ApplicationId,
                    "active":bool(self.Active),
                    "files":self.Files,
                    "profile":{"username":self.Name,
                               "readPermission":self.readPermission,
                               "deletePermission":self.deletePermission,
                               "writePermission":self.writePermission 
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
        Id= easy.get_metadata_profile_id_by_name(conn,Name=self.Name)
        print("Id response: {}".format(Id))
        return pcc.get_application_credential_profile_by_id(conn, str(Id))
        
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
        Id= easy.get_metadata_profile_id_by_name(conn,Name=self.Name)
        return pcc.describe_application_credential_profile_by_id(conn, str(Id))
        
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
        return pcc.describe_metadata_profiles(conn)
        
    ###########################################################################
    @keyword(name="PCC.Get Profile Id")
    ###########################################################################
    def get_profile_id(self, *args, **kwargs):
        """
        Get Profile Id
        [Args]
            (str) Name
        [Returns]
            (int) Id: Profile Id if there is one, 
                None: If not found
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Profile Id [Name=%s]" % self.Name)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_metadata_profile_id_by_name(conn, self.Name)
        
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
    
    ###########################################################################
    @keyword(name="PCC.Delete All Profiles")
    ###########################################################################
    
    def delete_all_profiles(self, *args, **kwargs):
        
        """
        Delete All Profiles
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            
        [Returns]
            (bool) OK: OK if All Profiles are deleted (includes any errors)
        """
        
        banner("PCC.Delete All Profiles")
        self._load_kwargs(kwargs)
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        response = self.get_metadata_profiles(conn)
        print("Response is :{}".format(response))
        
        list_id = []
        if get_response_data(response)==None:
            print("No metadata profiles available on PCC")
            return "OK"
        else:
            try:
                for ids in get_response_data(response):
                    list_id.append(ids['id'])
                print("list of id:{}".format(list_id))                
            except Exception as e:
                logger.console("Error in Delete All Profiles: {}".format(e))
            response_code_list = []
            try:
                for id_ in list_id:
                    response = pcc.delete_application_credential_profile_by_id(conn, str(id_))
                    response_code_list.append(str(response['StatusCode']))
                result = len(response_code_list) > 0 and all(elem == '200' for elem in response_code_list) 
                if result == True:
                    return "OK"    
            except Exception as e:
                logger.console("Error in Delete All Profiles: {}".format(e))    
                
    #################################################################################
    @keyword(name="PCC.Get Profiles with additional data for specific application")
    #################################################################################
    def get_profiles_with_additional_data_for_specific_application(self, *args, **kwargs):
        """
        Get Profiles with additional data for specific application
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str)  type: Type of application
            (str)  application_id: Application Id 
        [Returns]
            (dict) Response: Get Profiles with additional data for specific application response (includes any errors)
        """
        banner("PCC.Get Profiles with additional data for specific application")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_profiles_with_additional_data_for_specific_application(conn, type = str(self.Type), application_id = str(self.ApplicationId))
        
    #################################################################################
    @keyword(name="PCC.Describe Profiles per type and application")
    #################################################################################
    def describe_profiles_per_type_and_application(self, *args, **kwargs):
        """
        Describe Profiles per type and application
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str)  type: Type of application
            (str)  application_id: Application Id 
        [Returns]
            (dict) Response: Describe Profiles per type and application response (includes any errors)
        """
        banner("PCC.Describe Profiles per type and application")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.describe_profiles_per_type_and_application(conn, type = str(self.Type), application_id = str(self.ApplicationId))
        
    #################################################################################
    @keyword(name="PCC.Get Profile Types")
    #################################################################################
    def get_profile_types(self, *args, **kwargs):
        """
        Get Profile Types
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
        [Returns]
            (dict) Response: Get Profile Types response (includes any errors)
        """
        banner("PCC.Get Profile Types")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_profile_types(conn)
        
    #################################################################################
    @keyword(name="PCC.Get Profile Template Per Type")
    #################################################################################
    def get_profiles_template_per_type(self, *args, **kwargs):
        """
        Get Profile Types
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str)  type: Type of application
        [Returns]
            (dict) Response: Get Profile Types response (includes any errors)
        """
        banner("PCC.Get Profile Template Per Type")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_profiles_template_per_type(conn, str(self.Type)) 
        
    #################################################################################
    @keyword(name="PCC.Get Application Id used by Profile")
    #################################################################################
    def get_application_id_used_by_profile(self, *args, **kwargs):
        """
        Get Application Id used by Profile
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str)  type: Type of application
        [Returns]
            (dict) Response: Get Application Id used by Profile response (includes any errors)
        """
        banner("PCC.Get Application Id used by Profile")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        try:
            profiles_list = self.get_application_credential_profiles(conn)['Result']['Data']
            for profile in profiles_list:
                if str(profile['name']) == str(self.Name):
                    return profile['applicationId']
            return None
        except Exception as e:
            return {"Error": str(e)}           
    
