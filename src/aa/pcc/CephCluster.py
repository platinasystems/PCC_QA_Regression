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

PCCSERVER_TIMEOUT = 60*40

class CephCluster(AaBase):

    """ 
    Ceph Cluster
    """

    def __init__(self):

        # Robot arguments definitions

        self.id=None
        self.name=None
        self.nodes=[]
        self.tags=[]
        self.networkClusterId=None
        self.networkClusterName=None
        self.nodes_ip=[]
        self.user="pcc"
        self.password="cals0ft"
        self.data1=None
        self.data2=None
        self.state=None
        self.limit=None
        self.state_status=None
        self.forceRemove=None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Ceph Get Cluster Id")
    ###########################################################################
    def get_ceph_cluster_id_by_name(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Cluster Id")
        
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        cluster_id = easy.get_ceph_cluster_id_by_name(conn,self.name)
        return cluster_id

    ###########################################################################
    @keyword(name="PCC.Ceph Compare Data")
    ###########################################################################
    def ceph_compare_data(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Compare Data")

        return cmp_json(self.data1,self.data2)

    ###########################################################################
    @keyword(name="PCC.Ceph Create Cluster")
    ###########################################################################
    def add_ceph_cluster(self, *args, **kwargs):
        banner("PCC.Ceph Create Cluster")
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(kwargs))

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        tmp_node=[]
        for node_name in eval(str(self.nodes)):
            print("Getting Node Id for -"+str(node_name))
            node_id=easy.get_node_id_by_name(conn,node_name)
            print(" Node Id retrieved -"+str(node_id))
            tmp_node.append({"id":node_id})
        self.nodes=tmp_node
        
        if self.tags:
            self.tags=eval(str(self.tags))

        self.networkClusterId=easy.get_network_clusters_id_by_name(conn,self.networkClusterName)

        payload = {
            "name": self.name,
            "nodes": self.nodes,
            "tags": self.tags,
            "networkClusterId": self.networkClusterId
        }

        print("Payload:-"+str(payload))
        return pcc.add_ceph_cluster(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Ceph Cluster Update")
    ###########################################################################
    def modify_ceph_clusters(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(kwargs))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        tmp_node=[]
        payload_nodes=[]

        for node_name in eval(str(self.nodes)):
            node_id=easy.get_node_id_by_name(conn,node_name)
            tmp_node.append(node_id)

        self.nodes=[]
        response = pcc.get_ceph_clusters(conn)
        for data in get_response_data(response):
            if str(data['name']).lower() == str(self.name).lower():
                payload_nodes=eval(str(data['nodes']))
                if not self.tags:
                    self.tags=data['tags']
                if not self.name:
                    self.name=data['name']
                if not self.networkClusterName:
                    self.networkClusterId=data['networkClusterId']
                else:
                    self.networkClusterId=easy.get_network_clusters_id_by_name(conn,self.networkClusterName)

        for id in tmp_node:
            count=0
            for data in payload_nodes:
                if int(data['id'])==int(id):
                    self.nodes.append(data)
                    count=1
            if count==0:
                self.nodes.append({"id":int(id)}) 
        
        if self.tags:
            self.tags=eval(str(self.tags))

       
        try:
            payload = {
            "id":self.id,
            "name": self.name,
            "nodes": self.nodes,
            "tags": self.tags,
            "networkClusterId": self.networkClusterId
             }

            print("Payload:-"+str(payload))

        except Exception as e:
            trace("[update_cluster] EXCEPTION: %s" % str(e))
            raise Exception(e)

        return pcc.modify_ceph_clusters(conn, payload)
    
    ###########################################################################
    @keyword(name="PCC.Ceph Delete Cluster")
    ###########################################################################
    def delete_ceph_cluster_by_id(self, *args, **kwargs):
        banner("PCC.Ceph Delete Cluster")
        self._load_kwargs(kwargs)

        if self.id == None:
            return {"Error": "[PCC.Ceph Delete Cluster]: Id of the cluster is not specified."}

        if str(self.forceRemove).lower()=="true":
            payload={"forceRemove":True}
        else:
            payload={"forceRemove":False}
            
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        print("Payoad:"+str(payload))
        return pcc.delete_ceph_cluster_by_id(conn, str(self.id), payload)

    ###########################################################################
    @keyword(name="PCC.Ceph Wait Until Cluster Ready")
    ###########################################################################
    def wait_until_cluster_ready(self, *args, **kwargs):
        banner("PCC.Ceph Wait Until Cluster Ready")
        self._load_kwargs(kwargs)

        if self.name == None:
            return None
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        cluster_ready = False
        timeout = time.time() + PCCSERVER_TIMEOUT
        capture_data=""
  
        while cluster_ready == False:
            response = pcc.get_ceph_clusters(conn)
            for data in get_response_data(response):
                if str(data['name']).lower() == str(self.name).lower():
                    capture_data=data
                    if data['progressPercentage'] == 100 or data['deploy_status'].lower() == "completed":
                        print("Response To Look :-"+str(data))
                        cluster_ready = True
                    elif re.search("failed",str(data['deploy_status'])):
                        print("Response:-"+str(data))
                        return "Error"
            if time.time() > timeout:
                print("Response:-"+str(capture_data))
                raise Exception("[PCC.Ceph Wait Until Cluster Ready] Timeout")
            trace("  Waiting until cluster: %s is Ready, currently: %s" % (data['name'], data['progressPercentage']))
            time.sleep(5)       
        return "OK"


    ###########################################################################
    @keyword(name="PCC.Ceph Wait Until Cluster Deleted")
    ###########################################################################
    def wait_until_cluster_deleted(self, *args, **kwargs):
        banner("PCC.Ceph Wait Until Cluster Deleted")
        self._load_kwargs(kwargs)

        if self.id == None:
            return {"Error": "[PCC.Ceph Delete Cluster]: Id of the cluster is not specified."}

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        Id_found_in_list_of_clusters = True
        timeout = time.time() + PCCSERVER_TIMEOUT

        while Id_found_in_list_of_clusters == True:
            Id_found_in_list_of_clusters = False
            response = pcc.get_ceph_clusters(conn)
            for data in get_response_data(response):
                if str(data['id']) == str(self.id):
                    print("Response:-"+str(data))
                    Id_found_in_list_of_clusters = True
                elif re.search("failed",str(data['deploy_status'])):
                    print("Response:-"+str(data))
                    return "Error"            
            if time.time() > timeout:
                raise Exception("[PCC.Ceph Wait Until Cluster Deleted] Timeout")
            if Id_found_in_list_of_clusters:             
                trace("  Waiting until cluster: %s is deleted. Timeout in %.1f seconds." % 
                       (data['name'], timeout-time.time()))
                time.sleep(5)
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Verify BE")
    ###########################################################################
    def verify_ceph_be(self, *args, **kwargs):
        ceph_be_cmd="sudo ceph -s"
        banner("PCC.Ceph Verify BE")
        self._load_kwargs(kwargs)

        for ip in eval(str(self.nodes_ip)):
            output=cli_run(ip,self.user,self.password,ceph_be_cmd)
            print("Output:"+str(output))
            if re.search("HEALTH_OK",str(output)) or re.search("HEALTH_WARN",str(output)):
                continue
            else:
                return None
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Cleanup BE")
    ###########################################################################
    def ceph_cleanup_be(self,**kwargs):
        self._load_kwargs(kwargs)
        cmd="sudo wipefs -a /dev/sdb; sudo wipefs -a /dev/sdc"
        for ip in self.nodes_ip:
            data=cli_run(ip,self.user,self.password,cmd)
        time.sleep(30)
        return

    ###########################################################################
    @keyword(name="PCC.Ceph Cleanup BE Tables")
    ###########################################################################
    def ceph_cleanup_be_tables(self,**kwargs):
        self._load_kwargs(kwargs)
        cmd='sudo iptables -t nat -F && iptables -t filter -F && iptables -t mangle -F && > /etc/frr/frr.conf && > /etc/frr/ospfd.conf && > /etc/frr/zebra.conf && sudo systemctl restart frr && vtysh -c "show run" && ip link del ceph0 && ip link del lo0 && ip link del control0'
        for ip in self.nodes_ip:
            data=cli_run(ip,self.user,self.password,cmd)
        time.sleep(30)
        return
        
    ###########################################################################
    @keyword(name="PCC.Ceph Delete All Cluster")
    ###########################################################################
    def delete_all_ceph_cluster(self, *args, **kwargs):
        banner("PCC.Ceph Delete All Cluster")
        self._load_kwargs(kwargs)

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
  
        payload={"forceRemove":False}
        print("Payload:"+str(payload))
        
        response = pcc.get_ceph_clusters(conn)
        for data in get_response_data(response):
            print("Response To Look :-"+str(data))
            print("Ceph Cluster {} and id {} is deleting....".format(data['name'],data['id']))
            self.id=data['id']
            del_response=pcc.delete_ceph_cluster_by_id(conn, str(self.id), payload)
            if del_response['Result']['status']==200:
                del_check=self.wait_until_cluster_deleted()
                if del_check=="OK":
                    print("Ceph Cluster {} is deleted sucessfully".format(data['name']))
                    return "OK"
                else:
                    print("Ceph Cluster {} unable to delete".format(data['name']))
                    return "Error"
            else:
                print("Delete Response:"+str(del_response))
                print("Issue: Not getting 200 response back")
                return "Error"

        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Get State Nodes")
    ###########################################################################
    def get_ceph_state_nodes(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get State Nodes: {}".format(self.state))
        print("Kwargs:"+str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e 
        cluster_id = easy.get_ceph_cluster_id_by_name(conn,self.name)
        print("Cluster Name: {} Id: {}".format(self.name,cluster_id))
        nodes=[]  
        nodes_name=[]
        response = pcc.get_ceph_clusters_state(conn,str(cluster_id),str(self.state))
        trace("Response:"+str(response))
        if self.state.lower()=='mds':
            for val in get_response_data(response)['nodes']:
                if self.state_status:
                    if re.search(self.state_status,val['state']):
                        nodes_name.append(val['name'])
                        nodes.append(easy.get_hostip_by_name(conn,val['name']))                        
                else:
                    nodes_name.append(val['name'])
                    nodes.append(easy.get_hostip_by_name(conn,val['name']))
        else:
            for data in get_response_data(response):
                print("Data:"+str(data))
                nodes_name.append(data['server'])
                nodes.append(easy.get_hostip_by_name(conn,data['server']))   
        nodes=list(set(nodes))
        print("{} Nodes Host IP's: {}".format(self.state,str(nodes)))
        print("{} Nodes Name: {}".format(self.state,str(nodes_name)))
        trace("{} Nodes: {}".format(self.state,str(nodes)))
        return nodes 

    ###########################################################################
    @keyword(name="PCC.Ceph Make Osds Down")
    ###########################################################################
    def make_ceph_osds_down(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Make Osds Down: {}".format(self.name))
        print("Kwargs:"+str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e 
        cluster_id = easy.get_ceph_cluster_id_by_name(conn,self.name)
        print("Cluster Name: {} Id: {}".format(self.name,cluster_id))  
        response = pcc.get_ceph_clusters_state(conn,str(cluster_id),'osds')
        host_ip=None
        count=0
        if self.limit:
            for data in get_response_data(response):
                print("Count:"+str(count))
                print("Limit:"+str(self.limit))
                print("Data:"+str(data))
                trace("Data:"+str(data))
                print("Server:"+str(data['server']))
                print("Osd Id:"+str(data['osd']))
                if count==int(self.limit):
                    print("Limit reached, exiting the loop !!!")
                    break
                count+=1    
                host_ip=easy.get_hostip_by_name(conn,data['server'])
                print("Host Ip:"+str(host_ip))
                cmd="sudo systemctl stop ceph-osd@{}".format(data['osd'])
                cmd_exec=cli_run(host_ip,self.user,self.password,cmd)
                print("cmd:"+str(cmd))
                print("cmd output:"+str(cmd_exec))
                time.sleep(10)
                cmd_verify="sudo ceph osd tree|grep osd.{} |grep down|wc -l".format(data['osd'])
                cmd_verify_exec= cli_run(host_ip,self.user,self.password,cmd_verify)
                serialise_output=self._serialize_response(time.time(), cmd_verify_exec )['Result']['stdout']
                print("cmd:"+str(cmd_verify))
                print("cmd output:"+str(cmd_verify_exec))
                print("Serialise Output:"+str(serialise_output))  
                if int(serialise_output)==1:
                    print("{} ods id {} down sucessfully !!!".format(data['server'],data['osd']))
                    continue
                else:
                    print("Command execution could not make osd id {} down".format(data['osd']))
                    return "Error"

        else:
            for data in get_response_data(response):
                print("Data:"+str(data))
                trace("Data:"+str(data))
                print("Server:"+str(data['server']))
                print("Osd Id:"+str(data['osd']))
                host_ip=easy.get_hostip_by_name(conn,data['server'])
                print("Host Ip:"+str(host_ip))
                cmd="sudo systemctl stop ceph-osd@{}".format(data['osd'])
                cmd_exec=cli_run(host_ip,self.user,self.password,cmd)
                print("cmd:"+str(cmd))
                print("cmd output:"+str(cmd_exec))          
                time.sleep(10)      
                cmd_verify="sudo ceph osd tree|grep osd.{} |grep down|wc -l".format(data['osd'])
                cmd_verify_exec= cli_run(host_ip,self.user,self.password,cmd_verify)
                serialise_output=self._serialize_response(time.time(), cmd_verify_exec )['Result']['stdout']
                print("cmd:"+str(cmd_verify))
                print("cmd output:"+str(cmd_verify_exec))   
                print("Serialise Output:"+str(serialise_output))               
                if int(serialise_output)==1:
                    print("{} ods id {} down sucessfully !!!".format(data['server'],data['osd']))
                    continue
                else:
                    print("Command execution could not make osd id {} down".format(data['osd']))
                    return "Error"        
        return "OK"  

    ###########################################################################
    @keyword(name="PCC.Ceph Make Osds Up")
    ###########################################################################
    def make_ceph_osds_up(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Make Osds Down : {}".format(self.name))
        print("Kwargs:"+str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e 
        cluster_id = easy.get_ceph_cluster_id_by_name(conn,self.name)
        print("Cluster Name: {} Id: {}".format(self.name,cluster_id))  
        response = pcc.get_ceph_clusters_state(conn,str(cluster_id),'osds')
        host_ip=None
        for data in get_response_data(response):
            print("Data:"+str(data))
            trace("Data:"+str(data))
            print("Server:"+str(data['server']))
            print("Osd Id:"+str(data['osd']))
            host_ip=easy.get_hostip_by_name(conn,data['server'])
            print("Host Ip:"+str(host_ip))
            cmd="sudo systemctl restart ceph-osd@{}".format(data['osd'])
            cmd_exec=cli_run(host_ip,self.user,self.password,cmd)
            print("cmd:"+str(cmd))
            print("cmd output:"+str(cmd_exec))    
            time.sleep(10)            
            cmd_verify="sudo ceph osd tree|grep osd.{} |grep up|wc -l".format(data['osd'])
            cmd_verify_exec= cli_run(host_ip,self.user,self.password, cmd_verify)
            serialise_output=self._serialize_response(time.time(), cmd_verify_exec )['Result']['stdout']
            print("cmd:"+str(cmd_verify))
            print("cmd output:"+str(cmd_verify_exec))    
            print("Serialise Output:"+str(serialise_output))            
            if int(serialise_output)==1:
                print("{} ods id {} up sucessfully !!!".format(data['server'],data['osd']))
                continue
            else:
                print("Command execution could not make osd id {} up".format(data['osd']))
                return "Error"        
        return "OK" 
     
    ###########################################################################
    @keyword(name="PCC.Ceph Get Pcc Status")
    ###########################################################################
    def ceph_get_pcc_status(self, *args, **kwargs):
        banner("PCC.Ceph Get UI Status")
        self._load_kwargs(kwargs)
        if self.name == None:
            return None
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        response = pcc.get_ceph_clusters(conn)
        for data in get_response_data(response):
            if str(data['name']).lower() == str(self.name).lower():
                if data['progressPercentage'] == 100 or data['deploy_status'].lower() == "completed":
                    print("Response:"+str(data))
                    return "OK"
                else:
                    print("Response:"+str(data))
                    return "Error"
        return "OK"