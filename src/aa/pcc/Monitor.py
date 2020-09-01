import re
import time
import json

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy

from aa.common.Utils import banner, trace, pretty_print, cmp_json
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase
from aa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60*10

class Monitor(AaBase):

    """ 
    Monitoring and Stats
    """

    def __init__(self):

        # Robot arguments definitions
        self.id=None
        self.category=[]
        self.nodes=[]
        self.nodes_ip=[]
        self.user="pcc"
        self.password="cals0ft"
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Monitor Verify Node Health")
    ###########################################################################
    def monitor_verify_node_health(self, *args, **kwargs):
        banner("PCC.Monitor Verify Node Health")
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e           
        if not self.nodes:
            print("Node names can not be empty!!")
            return "Error"            
        tmp_node=[]
        for node_name in eval(str(self.nodes)):
            print("Getting Node Id for -"+str(node_name))
            node_id=easy.get_node_id_by_name(conn,node_name)
            print(" Node Id retrieved -"+str(node_id))
            tmp_node.append(node_id)
        self.nodes=tmp_node

        payload = {
            "unit":"HOUR",
            "value":1
        }
    
        for nodeId in eval(str(self.nodes)):
            health=pcc.add_monitor_cache(conn, "summary", str(nodeId), payload)   
            status=health['Result']['metrics'][0]['overallStatus']['status']
            if status.lower()!='ok' and status.lower()!='warning':
                print("Health status node ID {} : {}".format(nodeId,health['Result']['metrics'][0]['overallStatus']['status']))
                return "Error"
            else:
                print("NodeId:"+str(nodeId))
                print("Health Status:"+str(health['Result']['metrics'][0]['overallStatus']['status']))
        return "OK" 


    ###########################################################################
    @keyword(name="PCC.Monitor Verify Data Availability BE")
    ###########################################################################
    def monitor_verify_data_availabilty_be(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(kwargs))
        banner("PCC.Monitor Verify Data Availability BE")
        failed_chk=[]
        cmd=None
        if not self.nodes_ip or not self.category:
            print("Node IPs and Categories can't be empty")
            return "Error"
        for ip in eval(str(self.nodes_ip)):
            for topic in eval(str(self.category)):
                if topic.lower()=='cpu':
                    cmd="sudo top -n 1 -b|head -3|tail -1"
                    print("#####################################")    
                    print("Topic:"+str(topic))
                    print("Topic Cmd:"+str(cmd))
                    print("Host:"+str(ip))
                    cpu_check=self._serialize_response(time.time(),cli_run(ip,self.user,self.password,cmd))['Result']['stdout']
                    cpu_list=re.sub('[^0-9,]', '', str(cpu_check)).split(',')
                    print("Topic List:"+str(cpu_list))
                    if cpu_list:
                        continue
                    else:
                        failed_chk.append(ip)
                    print("#####################################")
                elif topic.lower()=='memory':
                    cmd="sudo top -n 1 -b|head -4|tail -1"
                    print("#####################################")    
                    print("Topic:"+str(topic))
                    print("Topic Cmd:"+str(cmd))
                    print("Host:"+str(ip))
                    mem_check=self._serialize_response(time.time(),cli_run(ip,self.user,self.password,cmd))['Result']['stdout']
                    mem_list=re.sub('[^0-9,]', '', mem_check).split(',')
                    print("Topic List:"+str(mem_list))
                    if mem_list:
                        continue
                    else:
                        failed_chk.append(ip)
                    print("#####################################")
        if failed_chk:
            print("Could not verify the topics for "+str())
            return "Error"
        else:
            return "OK"


    ###########################################################################
    @keyword(name="PCC.Monitor Verify Data Availability")
    ###########################################################################
    def monitor_verify_data_availabilty(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(kwargs))
        banner("PCC.Monitor Verify Data Availability")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e                 
        payload = {
            "unit":"HOUR",
            "value":1
        }
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
            for topic in eval(str(self.category)):
                print("Topic:"+str(topic))
                if topic.lower()=='cpu':
                    data=pcc.add_monitor_cache(conn, "cpu", str(nodeId), payload) 
                    us=data['Result']['metrics'][0]['us']
                    print("##############--CPU--##################") 
                    print("us:"+str(us))   
                    print("CPU Data:"+str(data))
                    trace("CPU Data:"+str(data))
                    print("#####################################")
                    if us:
                        continue
                    else:
                        failed_chk.append(nodeId)

                elif topic.lower()=='memory':
                    data=pcc.add_monitor_cache(conn, "memory", str(nodeId), payload)  
                    totalMem=data['Result']['metrics'][0]['totalMem']
                    print("###################--MEMORY--#############")    
                    print("Memory Data:"+str(data))
                    print("totalMem:"+str(totalMem))
                    trace("Memory Data:"+str(data))
                    print("#####################################")                    

                    if totalMem:
                        continue
                    else:
                        failed_chk.append(nodeId)                    
                elif topic.lower()=='storage':
                    data=pcc.add_monitor_cache(conn, "storage", str(nodeId), payload)  
                    storageControllers=data['Result']['metrics'][0]['storageControllers']
                    
                    print("################--STORAGE--##############")    
                    print("Storage Data:"+str(data))
                    print("storageControllers:"+str(storageControllers))
                    trace("Storage Data:"+str(data))
                    print("#####################################")
                    if storageControllers:
                        continue
                    else:
                        failed_chk.append(nodeId)                     

                elif topic.lower()=='sensor':
                    data=pcc.add_monitor_cache(conn, "sensor", str(nodeId), payload)  
                    cpuMaxTemp=data['Result']['metrics'][0]['cpuMaxTemp']
                    print("################--SENSOR--#################")    
                    print("Sensor Data:"+str(data))
                    trace("Sensor Data:"+str(data))
                    print("cpuMaxTemp:"+str(cpuMaxTemp))
                    print("#####################################")                    
                    if cpuMaxTemp:
                        continue
                    else:
                        failed_chk.append(nodeId)                            

                elif topic.lower()=='system':
                    data=pcc.add_monitor_cache(conn, "system", str(nodeId), payload)  
                    totProcesses=data['Result']['metrics'][0]['totProcesses']
                    print("##################--SYSTEM--#################")    
                    print("System Data:"+str(data))
                    print("totProcesses:"+str(totProcesses))
                    trace("System Data:"+str(data))
                    print("#####################################")                    
                    if totProcesses:
                        continue
                    else:
                        failed_chk.append(nodeId)                     

                elif topic.lower()=='network':
                    data=pcc.add_monitor_cache(conn, "network", str(nodeId), payload)  
                    interfaces=data['Result']['metrics'][0]['interfaces']
                    print("################--NETWORK--##################")    
                    print("Network Data:"+str(data))
                    print("interfaces:"+str(cpuMaxTemp))
                    trace("Network Data:"+str(data))
                    print("#####################################")                    
                    if interfaces:
                        continue
                    else:
                        failed_chk.append(nodeId) 
                else:
                    print("Invalid Category:"+str(topic))   
                    return "Error"
                    
        if failed_chk:
            print("Could not verify the topics for Node ids: "+str())
            return "Error"
        else:
            return "OK"                                                        

