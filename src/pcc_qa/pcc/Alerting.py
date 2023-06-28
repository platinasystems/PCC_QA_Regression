import re
import time
import json
import ast

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print, cmp_json
from pcc_qa.common.Result import get_response_data
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run
from pcc_qa.pcc import Gmail

PCCSERVER_TIMEOUT = 60*1

class Alerting(PccBase):

    """ 
    Alerting
    """

    def __init__(self):

        # Robot arguments definitions
        self.id=None
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
        self.filename=None
        self.mail=""
        self.cc=""
        self.info=[],
        self.disabled = False
        self.subject=""
        self.send_resolved = True

        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Alert Create Rule Template")
    ###########################################################################
    def alert_create_rule_template(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Alert Create Rule Template")

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
        return pcc.add_alert_rule(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Alert Create Rule Raw")
    ###########################################################################
    def alert_create_rule_raw(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Alert Create Rule Raw")
        print("kwargs:-"+str(kwargs))        

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
            
        
        if self.templateId:
            self.templateId=ast.literal_eval(str(self.templateId))

        token=self.auth_data["token"]
        print("Authorization:-"+str(token))
        
        cmd_strct='cd /home/pcc/rules;curl -k -X POST --data-binary @{} -H "Authorization:Bearer {}" -H "Content-type: application/x-yaml" -H "Accept: application/x-yaml" https://127.0.0.1:9999/platina-monitor/alerts/rules'
        cmd=cmd_strct.format(self.filename,token)
        print("Command:-"+str(cmd))
        
        output=cli_run(self.setup_ip,self.user,self.password,cmd)
        serialise_output=PccBase()._serialize_response(time.time(),output)['Result']['stdout']
        print("Serialize Output:"+str(serialise_output))
        trace("Serialize Output:- %s " % (serialise_output))
        if re.search("statuscode: 200",serialise_output) and re.search("messagetype: OK",serialise_output):
            return "OK"
        return "Error"

    ###########################################################################
    @keyword(name="PCC.Alert Get Rule Id")
    ###########################################################################
    def alert_get_rule_id(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Alert Get Rule Id")
        print("kwargs:-"+str(kwargs))        

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        alert_id = easy.get_alert_id_by_name(conn,self.name)
        return alert_id
        
    ###########################################################################
    @keyword(name="PCC.Alert Update Rule")
    ###########################################################################
    def alert_update_rule(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Alert Update Rule")

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
        return pcc.modify_alert_rule(conn, payload, self.id)

    ###########################################################################
    @keyword(name="PCC.Alert Delete Rule")
    ###########################################################################
    def alert_delete_rule(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Alert Delete Rule")

        print("kwargs:-"+str(kwargs))        

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e           
        if self.id==None:      
            self.id=self.alert_get_rule_id(self.name)
            print("Alert Rule Id:-"+str(self.id))      
        
        return pcc.delete_alert_rule_by_id(conn, str(self.id))

    ###########################################################################
    @keyword(name="PCC.Alert Delete All Rule")
    ###########################################################################
    def alert_delete_all_rule(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Alert Delete All Rule")
        print("kwargs:-"+str(kwargs))        

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e           
            
        default_alerts=["memory high usage","memory very high usage","cpu high temp","drive decreased","osds down/out","ceph pools high usage","ceph pools very high usage"]
        response = pcc.get_alert_rules(conn)
        for data in get_response_data(response):
            self.id=data["id"]
            self.name=data["name"]
            print("Alert Rule Id:-"+str(self.id))
            print("Alert Rule Name:-"+str(self.name))
            if self.id and data["name"].lower() not in default_alerts:
                tmp=self.alert_delete_rule()
                time.sleep(3)
                if self.alert_get_rule_id(id=self.id):
                    print("Alert {} and id {} is not deleted:".format(self.name,self.id))
                    return "Error"  
        return "OK"
        
    ###########################################################################
    @keyword(name="PCC.Alert Verify Rule")
    ###########################################################################
    def alert_verify_rule(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Alert Verify Rule")

        print("kwargs:-"+str(kwargs))        

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        
        time.sleep(20)
        
        response = pcc.get_alert_rules(conn)
        for data in get_response_data(response):
            print("Response:"+str(data))
            if str(data['name']).lower() == str(self.name).lower():
                return "OK"
        print("Could not verify the alert rule in the response: " +str(self.name))           
        return "Error"

    ###########################################################################
    @keyword(name="PCC.Alert Verify Raw Rule")
    ###########################################################################
    def alert_verify_raw_rule(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Alert Verify Raw Rule")

        print("kwargs:-"+str(kwargs))        

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
            
        if self.auth_data==None or self.name==None or self.setup_ip==None:
            return "Error: Auth Data or Name or Setup IP is missing"
        
        time.sleep(10)
              
        token=self.auth_data["token"]
        print("Authorization:-"+str(token))        
        cmd_strct='curl -k -XGET -H "Content-type:application/json" -H "Authorization:Bearer {}" https://{}:9999/platina-monitor/alerts/rules'
        cmd=cmd_strct.format(token,self.setup_ip)
        print("Command:-"+str(cmd))
        
        output=cli_run(self.setup_ip,self.user,self.password,cmd)
        serialise_output=json.loads(PccBase()._serialize_response(time.time(),output)['Result']['stdout'])
        print("Serialize Output:"+str(serialise_output))
        trace("Serialize Output:- %s " % (serialise_output))
        for data in serialise_output['Data']:
             print("DATA:-"+str(data))
             if re.search(self.name,data['rule'],re.IGNORECASE):
                 return "OK"
             if str(data['name']).lower()==str(self.name).lower():
                 for key,value in kwargs.items():
                     if str(key)=="auth_data" or str(key)=="setup_ip" or str(key)=="user" or str(key)=="password":
                         continue
                     elif str(key)=="nodes":
                         tmp_node=[]
                         print("inside")
                         for node_name in eval(str(self.nodes)):
                             node_id=easy.get_node_id_by_name(conn,node_name)
                             tmp_node.append(node_id)
                         if str(data['nodeIds'])==str(tmp_node):
                             continue
                     elif str(data[key])==str(value):
                         continue
                     else:
                         print("Could not verfiy all the Values")
                         return "Error"
                 return "OK"                
        return "Error"

    ###########################################################################
    @keyword(name="PCC.Alert Edit Rule Notifications")
    ###########################################################################
    def alert_edit_rule_notifications(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Alert Edit Rule Notifications")

        print("kwargs:-" + str(kwargs))

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        payload = {
                   "sendResolved": self.send_resolved,
                   "notifications": [
                      {
                         "service": "email",
                         "inputs": [
                            {
                               "name": "to",
                               "value": self.mail
                            },
                            {
                               "name": "cc",
                               "value": self.cc
                            },
                            {
                                "name": "subject",
                                "value": self.subject
                            }
                         ]
                      }
                   ]
                }
        print("Payload:-" + str(payload))
        return pcc.modify_alert_rule(conn, payload, self.id)

    ###########################################################################
    @keyword(name="PCC.Alert Set Disabled Flag")
    ###########################################################################
    def alert_set_disabled(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Alert Set Disabled Flag")

        print("kwargs:-" + str(kwargs))

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        payload = {
            "disabled": self.disabled,
            "sendResolved": self.send_resolved
        }
        print("Payload:-" + str(payload))
        return pcc.modify_alert_rule(conn, payload, self.id)


    ###########################################################################
    @keyword(name="PCC.Find Alert Mail")
    ###########################################################################
    def find_alert_mail(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.PCC.Find Alert Mail")

        print("kwargs:-" + str(kwargs))
        if self.mail:
            for v in self.info:
                if v not in self.mail:
                    return "Not Found"
            return "OK"
        return "Not Found"


