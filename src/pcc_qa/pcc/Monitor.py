import re
import time
import json

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

class Monitor(PccBase):

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
        self.password="plat1na"
        self.check_disk=False
        self.check_health_level=False
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
                elif topic.lower()=='file system':
                    cmd="sudo df -ih"
                    cmd1="sudo df -Th"
                    print("#####################################")    
                    print("Topic:"+str(topic))
                    print("Topic Second Cmd:"+str(cmd1))
                    print("Host:"+str(ip))
                    fs_check_cmd=self._serialize_response(time.time(),cli_run(ip,self.user,self.password,cmd))['Result']['stdout']
                    fs_check_cmd1=self._serialize_response(time.time(),cli_run(ip,self.user,self.password,cmd))['Result']['stdout']
                    print("Topic first Cmd:"+str(cmd))
                    print("Command Output"+str(fs_check_cmd))
                    print("Topic Second Cmd:"+str(cmd1))
                    print("Command Output"+str(fs_check_cmd1))                   
                    if re.search("tmpfs",str(fs_check_cmd)) and re.search("tmpfs",str(fs_check_cmd1)):
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
                    payload = {
                        "query": "{{job='cpu',nodeId='{}'}}".format(nodeId)
                    }
                    data=get_response_data(pcc.query_metric(conn, payload))
                    print("##############--CPU--##################")
                    print("CPU Data:"+str(data))
                    print("#####################################")
                    if data:
                        continue
                    else:
                        failed_chk.append(nodeId)

                elif topic.lower()=='memory':
                    payload = {
                        "query": "{{job='memory',nodeId='{}'}}".format(nodeId)
                    }
                    data = get_response_data(pcc.query_metric(conn, payload))
                    print("###################--MEMORY--#############")    
                    print("Memory Data:"+str(data))
                    print("#####################################")
                    if data:
                        continue
                    else:
                        failed_chk.append(nodeId) 
                                           
                elif topic.lower()=='storage':
                    if not self.check_disk and not self.check_health_level:
                        payload = {
                            "query": "{{job='storage',nodeId='{}'}}".format(nodeId)
                        }
                        data = get_response_data(pcc.query_metric(conn, payload))

                        print("################--STORAGE--##############")
                        print("Storage Data:"+str(data))
                        print("#####################################")
                        if data:
                            continue
                        else:
                            failed_chk.append(nodeId)
                    if self.check_disk:
                        payload = {
                            "query": "{{job='storage',nodeId='{}',__name__=~'storageControllers:Drive:sdb:Online'}}".format(nodeId)
                        }
                        data = get_response_data(pcc.query_metric(conn, payload))

                        print("################--STORAGE--##############")
                        print("Storage Data:" + str(data))
                        print("#####################################")
                        if data:
                            value = data[0]["value"]
                            if value:
                                continue
                            failed_chk.append(nodeId)
                        else:
                            failed_chk.append(nodeId)
                    if self.check_health_level:
                        payload = {
                            "query": "{{job='storage',nodeId='{}',__name__=~'storageControllers:Drive:sdb:healthLevel'}}".format(
                                nodeId)
                        }
                        data = get_response_data(pcc.query_metric(conn, payload))

                        print("################--STORAGE--##############")
                        print("Storage Data:" + str(data))
                        print("#####################################")
                        if data:
                            continue
                        else:
                            failed_chk.append(nodeId)
                elif topic.lower()=='sensor':
                    payload = {
                        "query": "{{job='sensor',nodeId='{}'}}".format(nodeId)
                    }
                    data = get_response_data(pcc.query_metric(conn, payload))
                    print("################--SENSOR--#################")    
                    print("Sensor Data:"+str(data))
                    print("#####################################")                    
                    if data:
                        continue
                    else:
                        failed_chk.append(nodeId)                            

                elif topic.lower()=='system':
                    payload = {
                        "query": "{{job='system',nodeId='{}'}}".format(nodeId)
                    }
                    data = get_response_data(pcc.query_metric(conn, payload))
                    print("##################--SYSTEM--#################")    
                    print("System Data:"+str(data))
                    print("#####################################")                    
                    if data:
                        continue
                    else:
                        failed_chk.append(nodeId)                     

                elif topic.lower()=='network':
                    payload = {
                        "query": "{{job='network',nodeId='{}'}}".format(nodeId)
                    }
                    data = get_response_data(pcc.query_metric(conn, payload))
                    print("################--NETWORK--##################")    
                    print("Network Data:"+str(data))
                    print("#####################################")                    
                    if data:
                        continue
                    else:
                        failed_chk.append(nodeId) 
                        
                elif topic.lower()=='file system':
                    payload = {
                        "query": "{{job='partitions',nodeId='{}'}}".format(nodeId)
                    }
                    data = get_response_data(pcc.query_metric(conn, payload))
                    print("################--FILE SYSTEM--##################")    
                    print("File System Data:"+str(data))
                    print("#####################################")
                    if data:
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

    ###########################################################################
    @keyword(name="PCC.Monitor Verify Interface Counts")
    ###########################################################################
    def monitor_verify_interface_counts(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(kwargs))
        banner("PCC.Monitor Verify Interface Counts")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        if not self.nodes:
            print("Node names can not be empty!!")
            return "Error"
        failed_chk=[]
        for node_name in eval(str(self.nodes)):
            print("***********************************")
            print("Node:"+str(node_name))
            for topic in eval(str(self.category)):
                for ip in eval(str(self.nodes_ip)):
                    if topic.lower()=='network':
                        cmd="sudo ip link|cut -d' ' -f2|sed '/^$/d'|wc -l"
                        print("#####################################")    
                        print("Topic:"+str(topic))
                        print("Topic Cmd:"+str(cmd))
                        print("Host:"+str(ip))
                        network_check=self._serialize_response(time.time(),cli_run(ip,self.user,self.password,cmd))['Result']['stdout']
                        payload = {
                            "query": "{{job='network',nodeName='{}',__name__=~'interfaces:.*:bytesSent'}}".format(node_name)
                        }
                        data = get_response_data(pcc.query_metric(conn, payload))
                        trace("Interface Count API:"+str(len(data)))
                        trace("Interface Count BE:" + str(network_check))

                        if len(data)==int(network_check):
                            continue
                        else:
                          failed_chk.append(node_name)
                    else:
                        print("Invalid Category:"+str(topic))   
                        return "Error"                    
        if failed_chk:
            print("Could not verify the topics for Nodes: " + str(failed_chk))
            return "Error"
        else:
            return "OK"