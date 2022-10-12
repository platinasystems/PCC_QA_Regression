import re
import time
import json

from datetime import datetime, timedelta
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print, cmp_json
from pcc_qa.common.Result import get_response_data
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60*10
START_TIME = (datetime.now() - timedelta(hours = 1)).isoformat()[:-3]+'Z'
END_TIME = datetime.utcnow().isoformat()[:-3]+'Z'
STEP = 36

class Promethius(PccBase):

    """ 
    Monitoring and Stats
    """

    def __init__(self):

        # Robot arguments definitions
        self.nodes=[]
        self.nodes_ip=[]
        pcc_promethius_objects=[]
        self.user="admin"
        self.password="admin"
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Monitor Verify Promethius Data Availability")
    ###########################################################################
    def monitor_verify_data_availabilty(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(kwargs))
        banner("PCC.Monitor Verify Promethius Data Availability")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        if not self.nodes:
            print("Node names can not be empty!!")
            return "Error"            
        tmp_node=[]        
        failed_chk=[]
        for node_name in eval(str(self.nodes)):
            print("Getting Node Id for -"+str(node_name))
            node_id=easy.get_node_id_by_name(conn,node_name)
            print(" Node Id retrieved -"+str(node_id))
            tmp_node.append(node_id)
        self.nodes=tmp_node
        for nodeId in self.nodes:
            print("***********************************")
            print("NodeID:"+str(nodeId))
            for promethius_object in eval(str(self.category)):
                print("Topic:"+str(promethius_object))
                #{"query":"healthLevel{nodeName=\"sv60\"}&start=2022-10-06T15:45:58.989Z&end=2022-10-06T16:45:5.989Z&step=36"}
                if promethius_object=='healthLevel':
                    payload = f'healthLevel{{nodeName="{nodeId}"}}&start={START_TIME}&end={END_TIME}&step={STEP}'
                    data=get_response_data(pcc.query_metric(conn, payload))
                    print("##############--healthLevel--##################")
                    print("healthLevel Data:"+str(data))
                    print("#####################################")
                    if data:
                        continue
                    else:
                        failed_chk.append(nodeId)
                else:
                    print("Invalid Objct:"+str(promethius_object))   
                    return "Error"
                
                if promethius_object=='clusterHealthLevel':
                    payload = f'healthLevel{{nodeName="{nodeId}"}}&start={START_TIME}&end={END_TIME}&step={STEP}'
                    data=get_response_data(pcc.query_metric(conn, payload))
                    print("##############--clusterHealthLevel--##################")
                    print("healthLevel Data:"+str(data))
                    print("#####################################")
                    if data:
                        continue
                    else:
                        failed_chk.append(nodeId)
                else:
                    print("Invalid Objct:"+str(promethius_object))   
                    return "Error"
                    
        if failed_chk:
            print("Could not verify the topics for Node ids: "+str())
            return "Error"
        else:
            return "OK"                                                        
