import re
import time
import json
import ast

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from platina_sdk import pcc_easy_api as easy

from aa.common.Utils import banner, trace, pretty_print, cmp_json
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase


PCCSERVER_TIMEOUT = 60*40

class SAS_Enclosure(AaBase):

    """ 
    SAS Enclosure
    """

    def __init__(self):

        # Robot arguments definitions
        
        self.auth_data= None
        self.setup_ip=None
        self.user="pcc"
        self.password="Cals0ft"     
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Get SAS Enclosures")
    ###########################################################################
    def get_SAS_enclosures(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Get SAS Enclosures")

        print("kwargs:-"+str(kwargs))        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        token=self.auth_data["token"]
        print("Authorization token:-"+str(token))
        
        cmd ='curl -k -X GET "https://{}:9999/pccserver/v2/enclosures" -H "accept: application/json" -H "Authorization: Bearer {}"'.format(self.setup_ip,token)
        
        
        output=easy.cli_run(cmd=cmd, host_ip=self.setup_ip, linux_user=self.user,linux_password=self.password)
        
        serialise_output=json.loads(self._serialize_response(time.time(),output)['Result']['stdout'])
        print("Serialize Output:"+str(serialise_output))
        trace("Serialize Output:- %s " % (serialise_output))
        
        if serialise_output['status']==200 and serialise_output['error']=="":
            return "OK"
        return "Error"