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

class Alerting(AaBase):

    """ 
    Alerting
    """

    def __init__(self):

        # Robot arguments definitions

        self.name=None
        self.nodes=[]
        self.nodeIds=[]
        self.parameter=None
        self.operator=None
        self.value=None
        self.time=None
        self.templateId=[]
        self.auth_data=None
        self.setup_ip=None
        self.user="pcc"
        self.password="Cals0ft"        
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Alert Post Template")
    ###########################################################################
    def alert_post_template(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Alert Template Post")

        print("kwargs:-"+str(kwargs))        

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
            
        tmp_node=[]
        for node_name in eval(str(self.nodes)):
            node_id=easy.get_node_id_by_name(conn,node_name)
            print("Node-Name:-"+str(node_name))
            print("Node-Id:-"+str(node_id))
            tmp_node.append(node_id)
        self.nodeIds=tmp_node
        print("Node Ids:-"+str(self.nodeIds))
        
        if self.templateId:
            self.templateId=ast.literal_eval(str(self.templateId))
       
        payload = {
            "name": self.name,
            "nodeIds": self.nodeIds,
            "parameter": self.parameter,
            "operator": self.operator,
            "value":self.value,
            "time":self.time,
            "templateId":self.templateId
        }        

        print("Payload:-"+str(payload))
        trace("Payload:- %s " % (payload))
        token=self.auth_data["token"]
        print("Authorization:-"+str(token))
        
        cmd_strct='curl -k -X POST --data \'{}\' -H "Content-type:application/json" -H "Authorization:Bearer {}" https://{}:9999/platina-monitor/alerts/rules'
        cmd=cmd_strct.format(json.dumps(payload),token,self.setup_ip)
        print("Command:-"+str(cmd))
        
        output=easy.cli_run(self.setup_ip,self.user,self.password,cmd)
        serialise_output=json.loads(AaBase()._serialize_response(time.time(),output)['Result']['stdout'])
        print("Serialize Output:"+str(serialise_output))
        trace("Serialize Output:- %s " % (serialise_output))
        if serialise_output['status']==0:
            return "OK"
        return "Error"

    ###########################################################################
    @keyword(name="PCC.Alert Get Rule Id")
    ###########################################################################
    def alert_get_rule_id(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Alert Get Id")

        print("kwargs:-"+str(kwargs))        

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
            
        if self.auth_data==None or self.name==None or self.setup_ip==None:
            return "Error: Auth Data or Name or Setup IP is missing"
              
        token=self.auth_data["token"]
        print("Authorization:-"+str(token))        
        cmd_strct='curl -k -XGET -H "Content-type:application/json" -H "Authorization:Bearer {}" https://{}:9999/platina-monitor/alerts/rules'
        cmd=cmd_strct.format(token,self.setup_ip)
        print("Command:-"+str(cmd))
        
        output=easy.cli_run(self.setup_ip,self.user,self.password,cmd)
        serialise_output=json.loads(AaBase()._serialize_response(time.time(),output)['Result']['stdout'])
        print("Serialize Output:"+str(serialise_output))
        trace("Serialize Output:- %s " % (serialise_output))
        for data in serialise_output['Data']:
             print("DATA:-"+str(data))
             if str(data['name']).lower()==str(self.name).lower():
                 print("inside")
                 return data['id']
                 
        return None
        
    ###########################################################################
    @keyword(name="PCC.Alert Update Rule")
    ###########################################################################
    def alert_update_rule(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Alert Update")

        print("kwargs:-"+str(kwargs))        

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
            
        tmp_node=[]
        for node_name in eval(str(self.nodes)):
            node_id=easy.get_node_id_by_name(conn,node_name)
            print("Node-Name:-"+str(node_name))
            print("Node-Id:-"+str(node_id))
            tmp_node.append(node_id)
        self.nodeIds=tmp_node
        print("Node Ids:-"+str(self.nodeIds))
        
        if self.templateId:
            self.templateId=ast.literal_eval(str(self.templateId))
       
        payload = {
            "name": self.name,
            "nodeIds": self.nodeIds,
            "parameter": self.parameter,
            "operator": self.operator,
            "value":self.value,
            "time":self.time,
            "templateId":self.templateId
        }        

        print("Payload:-"+str(payload))
        trace("Payload:- %s " % (payload))
        token=self.auth_data["token"]
        print("Authorization:-"+str(token))
        
        alert_id=self.alert_get_rule_id()
        print("Alert Rule Id:-"+str(alert_id))
        cmd_strct='curl -k -X PUT --data \'{}\' -H "Content-type:application/json" -H "Authorization:Bearer {}" https://{}:9999/platina-monitor/alerts/rules/{}'
        cmd=cmd_strct.format(json.dumps(payload),token,self.setup_ip,alert_id)
        print("Command:-"+str(cmd))
        
        output=easy.cli_run(self.setup_ip,self.user,self.password,cmd)
        serialise_output=json.loads(AaBase()._serialize_response(time.time(),output)['Result']['stdout'])
        print("Serialize Output:"+str(serialise_output))
        trace("Serialize Output:- %s " % (serialise_output))
        if serialise_output['status']==0:
            return "OK"
        return "Error"

    ###########################################################################
    @keyword(name="PCC.Alert Delete Rule")
    ###########################################################################
    def alert_delete_rule(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Alert Get Id")

        print("kwargs:-"+str(kwargs))        

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
            
        if self.auth_data==None or self.name==None or self.setup_ip==None:
            return "Error: Auth Data or Name or Setup IP is missing"
              
        alert_id=self.alert_get_rule_id()
        print("Alert Rule Id:-"+str(alert_id))      
        
        token=self.auth_data["token"]
        print("Authorization:-"+str(token))        
        cmd_strct='curl -k -XDELETE -H "Content-type:application/json" -H "Authorization:Bearer {}" https://{}:9999/platina-monitor/alerts/rules/{}'
        cmd=cmd_strct.format(token,self.setup_ip,alert_id)
        print("Command:-"+str(cmd))
        
        output=easy.cli_run(self.setup_ip,self.user,self.password,cmd)
        serialise_output=json.loads(AaBase()._serialize_response(time.time(),output)['Result']['stdout'])
        print("Serialize Output:"+str(serialise_output))
        trace("Serialize Output:- %s " % (serialise_output))
        if serialise_output['status']==0:
            return "OK"
        return "Error" 