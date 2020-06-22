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
        self.config=dict()
        self.controlCIDR=None
        self.igwPolicy=""
        self.nodes_ip=[]
        self.user=""
        self.password=""
        self.data1=None
        self.data2=None
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
        if self.config:
            self.config=eval(str(self.config))

        payload = {
            "name": self.name,
            "nodes": self.nodes,
            "tags": self.tags,
            "config": self.config,
            "controlCIDR":self.controlCIDR,
            "igwPolicy":self.igwPolicy
        }

        print("Payload:-"+str(payload))
        return pcc.add_ceph_cluster(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Ceph Cluster Update")
    ###########################################################################
    def modify_ceph_clusters(self, *args, **kwargs):
        self._load_kwargs(kwargs)

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
                if not self.controlCIDR: 
                    self.controlCIDR=data['controlCIDR']
                if not self.tags:
                    self.tags=data['tags']
                if not self.igwPolicy:
                    self.igwPolicy=data['igwPolicy']
                if not self.name:
                    self.name=data['name']

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
        if self.config:
            self.config=eval(str(self.config))
       
        try:
            payload = {
            "id":self.id,
            "name": self.name,
            "nodes": self.nodes,
            "tags": self.tags,
            "config": self.config,
            "controlCIDR":self.controlCIDR,
            "igwPolicy":self.igwPolicy
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

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        return pcc.delete_ceph_cluster_by_id(conn, str(self.id))

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
  
        while cluster_ready == False:
            response = pcc.get_ceph_clusters(conn)
            for data in get_response_data(response):
                if str(data['name']).lower() == str(self.name).lower():
                    print("Response To Look :-"+str(data))
                    if data['progressPercentage'] == 100:
                        cluster_ready = True
                    elif re.search("failed",str(data['deploy_status'])):
                        return "Error"
            if time.time() > timeout:
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
                    Id_found_in_list_of_clusters = True
                elif re.search("failed",str(data['deploy_status'])):
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

        for ip in self.nodes_ip:
            output=cli_run(ip,self.user,self.password,ceph_be_cmd)
            print("Output:"+str(output))
            if re.search("HEALTH_OK",str(output)):
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
        
        response = pcc.get_ceph_clusters(conn)
        for data in get_response_data(response):
            print("Response To Look :-"+str(data))
            print("Ceph Cluster {} and id {} is deleting....".format(data['name'],data['id']))
            self.id=data['id']
            del_response=pcc.delete_ceph_cluster_by_id(conn, str(self.id))
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
