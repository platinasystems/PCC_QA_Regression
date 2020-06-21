import time
import re
import json
import requests
import sys
import urllib3
import distro
import time
from robot.api.deco import keyword
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy

from aa.common.AaBase import AaBase
from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data

class Auth_Profile(AaBase):
    def __init__(self):
        # Robot arguments definitions
        
        self.Name = None
        self.type_auth = None
        self.domain = None
        self.port = None
        self.userIDAttribute = None
        self.userBaseDN = None
        self.anonymousBind = None
        self.bindDN = None
        self.bindPassword = None
        self.groupBaseDN = None
        self.encryptionPolicy =None
        self.AuthProfile_ID = None
        
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Create Auth Profile")
    ###########################################################################
    
    def Auth_profile_creation(self, *args, **kwargs):
        """
        Create Authentication Profile
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (dict) data: Payload (name=<Name>, type_auth=<type_auth>, domain=<domain>, port=<port>, userIDAttribute=<userIDAttribute>, userBaseDN=<userBaseDN>, groupBaseDN=<groupBaseDN>, anonymousBind=<anonymousBind>, bindDN=<bindDN>, bindPassword=<bindPassword>, encryptionPolicy=<encryptionPolicy>)
    
        [Returns]
            (dict) Response: Create Authentication Profile response (includes any errors)
        """
    
    
        banner("PCC.Creating Auth Profile")
        self._load_kwargs(kwargs)
        payload = {
                "name": self.Name,
                "type": self.type_auth,
                "tenant":1,
                "profile":{    
                "domain":self.domain,
                "port":self.port,
                "userIDAttribute":self.userIDAttribute,
                "userBaseDN":self.userBaseDN,
                "groupBaseDN":self.groupBaseDN,
                "anonymousBind":bool(self.anonymousBind),
                "bindDN":self.bindDN,
                "bindPassword":self.bindPassword,
                "encryptionPolicy":self.encryptionPolicy
                }
                }
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.add_profile(conn, data=payload)

    ###########################################################################
    @keyword(name="PCC.Get Auth Profile Id")
    ###########################################################################
    
    def get_profile_id(self, *args, **kwargs):
        
        """
        Get Authentication Profile Id
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Auth Profile who's id is required (name=<name>)
    
        [Returns]
            (int) Id: Id of the Authentication Profile, or
                None: if no match found, or
            (dict) Error response: If Exception occured
        """
        
        self._load_kwargs(kwargs)
        banner("PCC.Get Id [Name=%s]" % self.Name)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_profile_id_by_name(conn, Name=self.Name)
            
    
    ###########################################################################
    @keyword(name="PCC.Update Auth Profile")
    ###########################################################################       
   
    def update_auth_profile(self, *args, **kwargs):
    
        """
        Updates Authentication Profile
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (dict) data: Payload (id=<AuthProfile_ID>, name=<Name>, type_auth=<type_auth>, domain=<domain>, port=<port>, userIDAttribute=<userIDAttribute>, userBaseDN=<userBaseDN>, groupBaseDN=<groupBaseDN>, anonymousBind=<anonymousBind>, bindDN=<bindDN>, bindPassword=<bindPassword>, encryptionPolicy=<encryptionPolicy>)
    
        [Returns]
            (dict) Response: Update Authentication Profile response (includes any errors)
        """
    
        banner("PCC.Update Auth Profile")
        self._load_kwargs(kwargs)
        self.AuthProfile_ID = self.get_profile_id(**kwargs)
        payload = {
                "id":self.AuthProfile_ID,
                "name": self.Name,
                "type": self.type_auth,
                "tenant":1,
                "profile":{    
                "domain":self.domain,
                "port":self.port,
                "userIDAttribute":self.userIDAttribute,
                "userBaseDN":self.userBaseDN,
                "groupBaseDN":self.groupBaseDN,
                "anonymousBind":bool(self.anonymousBind),
                "bindDN":self.bindDN,
                "bindPassword":self.bindPassword,
                "encryptionPolicy":self.encryptionPolicy
                }
                }
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.modify_profile(conn, data=payload)        
           
            
    ###########################################################################
    @keyword(name="PCC.Delete Auth Profile")
    ###########################################################################
    
    def authprofile_delete(self, *args, **kwargs):
        
        """
        Delete Authentication Profile by Id
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Id: Id
    
        [Returns]
            (dict) Response: Delete Authentication Profile response (includes any errors)
        """
        
        banner("PCC.CR Delete new")
        self._load_kwargs(kwargs)
        try:
            if self.Name == None:
                logger.console("[PCC.Delete Cluster]: cluster name is not specified.")
            else:
                self.AuthProfile_ID = self.get_profile_id(**kwargs)
                conn = BuiltIn().get_variable_value("${PCC_CONN}")
                return pcc.delete_profile_by_id(conn, id=str(self.AuthProfile_ID)) 
        except Exception as e:
            logger.console("Error in Auth Profile deletion: "+str(e))
                
                
    ###########################################################################
    @keyword(name="PCC.Delete All Auth Profile")
    ###########################################################################
    
    def clean_all_authprofile(self, *args, **kwargs):
        
        """
        Delete All Authentication Profiles
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            
        [Returns]
            (bool) OK: OK if All Authentication Profiles are deleted (includes any errors)
        """
        
        banner("PCC.Clean all AuthProfile")
        self._load_kwargs(kwargs)
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        response = pcc.get_profiles(conn)
        print("Response is :{}".format(response))
        
        list_id = []
        if get_response_data(response)==[]:
            print("No auth profile available")
            return "OK"
        else:
            try:
                for ids in get_response_data(response):
                    list_id.append(ids['id'])
                print("list of id:{}".format(list_id))                
            except Exception as e:
                logger.console("Error in clean_all_AuthProfile: {}".format(e))
            response_code_list = []
            try:
                for id_ in list_id:
                    response = pcc.delete_profile_by_id(conn, id=str(id_))
                    response_code_list.append(str(response['StatusCode']))
                result = len(response_code_list) > 0 and all(elem == response_code_list[0] for elem in response_code_list) 
                if result == True:
                    return "OK"    
            except Exception as e:
                logger.console("Error in clean_all_AuthProfile: {}".format(e))