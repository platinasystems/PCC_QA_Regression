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
        
        self.auth_data = None
        self.setup_ip = None
        self.user = "pcc"
        self.password = "Cals0ft"   
        self.slot_name = None 
        self.led_status = None 
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Get SAS Enclosures")
    ###########################################################################
    def get_SAS_enclosures(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Get SAS Enclosures")

        print("kwargs in Get SAS Enclosure :-  "+str(kwargs))        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        token=self.auth_data["token"]
        print("Authorization token:-"+str(token))
        
        cmd ='curl -k -X GET "https://{}:9999/pccserver/v2/enclosures" -H "accept: application/json" -H "Authorization: Bearer {}"'.format(self.setup_ip,token)
        
        
        output=easy.cli_run(cmd=cmd, host_ip=self.setup_ip, linux_user=self.user,linux_password=self.password)
        
        serialise_output=json.loads(self._serialize_response(time.time(),output)['Result']['stdout'])
        print("Serialize Output:"+str(serialise_output))
        trace("Serialize Output:- %s " % (serialise_output))
        
        if serialise_output['status']==200 and serialise_output['error']=="":
            return serialise_output
        return "Error"
    
    
    
    ###########################################################################
    @keyword(name="PCC.Get Sub-Enclosure Slot Id")
    ###########################################################################
    def get_sub_enclosure_slot_id(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Get Sub-Enclosure Slot Id")

        print("kwargs in get sub enclosure slot id :-  {}".format(str(kwargs)))        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")  
        try:
            sub_enclosures = self.get_SAS_enclosures()['Data'][0]['subenclosures'][0]['slots']
            
            for slots in sub_enclosures:
                if str(slots['deviceName'])== str(self.slot_name):
                    trace("Slot name found")
                    return slots['slotID']
            trace("Slot not found")
            return "Error: Slot_name not found"
        except Exception as e:
            return {'Error':str(e)}
        
              
    
        
    ###########################################################################
    @keyword(name="PCC.Update SAS Enclosure")
    ###########################################################################
    def update_SAS_enclosure(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Update SAS Enclosure")

        print("kwargs:-"+str(kwargs))        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        payload = {
                    "ledOn": json.loads(self.led_status.lower())
                  }        

        print("Payload:-"+str(payload))
        trace("Payload:- %s " % (payload))
        
        token=self.auth_data["token"]
        
        slot_id=self.get_sub_enclosure_slot_id(**kwargs)
        banner("Slot id is: {}".format(slot_id))
        
        cmd_strct = """curl -k -X PUT --data \'{}\' -H "Content-type:application/json" -H "Authorization:Bearer {}" https://{}:9999/pccserver/v2/enclosures/1/slots/{}"""
        cmd=cmd_strct.format(json.dumps(payload),token,self.setup_ip,slot_id)
        print("Command:-"+str(cmd))
        
        output=easy.cli_run(self.setup_ip,self.user,self.password,cmd)
        serialise_output=json.loads(AaBase()._serialize_response(time.time(),output)['Result']['stdout'])
        print("Serialize Output:"+str(serialise_output))
        trace("Serialize Output:- %s " % (serialise_output))
        if serialise_output['status']==200 and serialise_output['error']=="":
            return serialise_output
        return "Error"
        
        