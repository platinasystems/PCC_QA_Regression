import re
import time
import json

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from platina_sdk import pcc_easy_api as easy

from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase

PCCSERVER_TIMEOUT = 60*20

class CephCluster(AaBase):

    """ 
    Ceph Cluster
    """

    def __init__(self):

        # Robot arguments definitions

        self.id = None
        self.name = None
        self.nodes = []
        self.tags =  []
        self.config = dict()
        self.controlCIDR=None
        self.igwPolicy=""
        self.nodes_ip=[]
        self.user=""
        self.password=""
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

        payload = {
            "name": self.name,
            "nodes": self.nodes,
            "tags": self.tags,
            "config": self.config,
            "controlCIDR":self.controlCIDR,
            "igwPolicy":self.igwPolicy
        }

        print(payload)
        return pcc.add_ceph_cluster(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Ceph Cluster Update")
    ###########################################################################
    def modify_ceph_clusters(self, *args, **kwargs):
        self._load_kwargs(kwargs)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        tmp_node=[]
        for node_name in eval(str(self.nodes)):
            node_id=easy.get_node_id_by_name(conn,node_name)
            tmp_node.append({"id":node_id})
        self.nodes=tmp_node

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

            print(str(payload))

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
                    if data['progressPercentage'] == 100:
                        cluster_ready = True
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
            output=easy.cli_run(ip,self.user,self.password,ceph_be_cmd)
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
            data=easy.cli_run(ip,self.user,self.password,cmd)
        time.sleep(30)
        return
