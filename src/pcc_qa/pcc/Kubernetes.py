import time
import re
import json
import base64

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60*40
PCCSERVER_TIMEOUT_UPGRADE = 60*60


class Kubernetes(PccBase):
    def __init__(self):
        # Robot arguments definitions
        self.id = 0
        self.k8sVersion = None
        self.name = None
        self.cniPlugin = None
        self.nodes = []
        self.pools = []
        self.cluster_id = None
        self.networkClusterId=None
        self.networkClusterName=None
        self.DeployStatus = None
        self.appName = None
        self.appIds = None
        self.appNamespace = None
        self.gitUrl = None  
        self.gitRepoPath = None
        self.gitBranch = None
        self.label = None
        self.rolePolicy = None
        self.toAdd = []
        self.toRemove = []
        self.invader_id = None
        self.nodes_ip= None
        self.user="pcc"
        self.password="cals0ft"
        self.hostip = None
        self.storage_class_name = None
        self.replica = None
        self.external_ip = None
        self.access_mode = None
        self.pool_id = None 
        super().__init__()


    ###########################################################################
    @keyword(name="PCC.K8s Create Cluster")
    ###########################################################################
    def add_kubernetes(self, *args, **kwargs):
        banner("PCC.K8s Create Cluster")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        tmp_node=[]
        for node_name in eval(str(self.nodes)):
            node_id=easy.get_node_id_by_name(conn,node_name)
            tmp_node.append({"id":node_id})
        self.nodes=tmp_node

        tmp_pool=[]
        if self.pools:
            for pool in eval(str(self.pools)):
                 tmp_pool.append(easy.get_ceph_pool_id_by_name(conn,pool))
                 
        self.pools=tmp_pool
        
        if self.networkClusterName:
            self.networkClusterId=easy.get_network_clusters_id_by_name(conn,self.networkClusterName)
        
        payload = {
            "id": int(self.id),
            "k8sVersion": self.k8sVersion,
            "cniPlugin": self.cniPlugin,  
            "name": self.name,
            "nodes": self.nodes,
            "pools": self.pools,
            "networkClusterId": self.networkClusterId
        }
       
        print("paylod:-"+str(payload)) 
        return pcc.add_kubernetes(conn, payload)

    ###########################################################################
    @keyword(name="PCC.K8s Get Cluster Id")
    ###########################################################################
    def get_k8s_cluster_id_by_name(self,*args,**kwargs):
        banner("PCC.K8s Get Cluster Id")
        self._load_kwargs(kwargs)

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        cluster_id = easy.get_k8s_cluster_id_by_name(conn,self.name)
        return cluster_id

    ###########################################################################
    @keyword(name="PCC.K8s Get App Id")
    ###########################################################################
    def get_k8s_app_id_by_name(self,*args,**kwargs):
        banner("PCC.K8s Get App Id")
        self._load_kwargs(kwargs)

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        app_id = easy.get_k8s_app_id_by_name(conn,self.appName)
        return app_id
    
    ###########################################################################
    @keyword(name="PCC.K8s Delete Cluster")
    ###########################################################################
    def delete_kubernetes_by_id(self, *args, **kwargs): 
        banner("PCC.K8s Delete Cluster")
        self._load_kwargs(kwargs)

        if self.cluster_id == None:
            raise Exception("[PCC.Delete Cluster]: cluster id is not specified.")
        else:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            return pcc.delete_kubernetes_by_id(conn, str(self.cluster_id))

    ###########################################################################
    @keyword(name="PCC.K8s Delete All Cluster")
    ###########################################################################
    def delete_all_kubernetes(self, *args, **kwargs): 
        banner("PCC.K8s Delete All Cluster")
        self._load_kwargs(kwargs)

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
            
        response = pcc.get_kubernetes(conn)
        for data in get_response_data(response):
            print("Response To Look :-"+str(data))
            print("K8s {} and id {} is deleting....".format(data['name'],data['ID']))
            self.cluster_id=data['ID']
            del_response=pcc.delete_kubernetes_by_id(conn, str(self.cluster_id))
            if del_response['Result']['status']==200:
                del_check=self.k8s_wait_until_cluster_deleted()
                print("del_check:"+str(del_check))
                if del_check=="OK":
                    print("k8s {} is deleted sucessfully".format(data['name']))
                    return "OK"
                else:
                    print("k8s {} unable to delete".format(data['name']))
                    return "Error"
            else:
                print("Delete Response:"+str(del_response))
                print("Issue: Not getting 200 response back")
                return "Error"
                        
        return "OK" 

    ###########################################################################
    @keyword(name="PCC.K8s Wait Until Cluster is Ready")
    ###########################################################################
    def k8s_wait_until_cluster_ready(self, *args, **kwargs):
        banner("PCC.K8s Wait Until Cluster is Ready")
        self._load_kwargs(kwargs)

        if self.name == None:
            raise Exception("[PCC.Wait Until Cluster is Ready]: K8s Cluster Name is not specified." %args)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        cluster_ready = False
        timeout = time.time() + PCCSERVER_TIMEOUT
        capture_data=""

        time.sleep(60)
        while cluster_ready == False:
            response = pcc.get_kubernetes(conn)
            for data in get_response_data(response):            
                if str(data['name']).lower() == str(self.name).lower():
                    capture_data=data
                    if "progressPercentage" in data['latestAnsibleJob'].keys():
                        trace("  Waiting until cluster: %s is Ready, currently:  %s" % (data['ID'], data['latestAnsibleJob']['progressPercentage']))
                        if int(data['latestAnsibleJob']['progressPercentage'])==100 and (str(data['deployStatus']).lower() == 'installed' or str(data['deployStatus']).lower() == 'update completed'):
                            print("Response:-"+str(data))
                            cluster_ready = True
                    elif str(data['deployStatus']).lower() == 'installed' or str(data['deployStatus']).lower() == 'update completed':
                        print("Response:-"+str(data))
                        cluster_ready = True
                    if re.search("failed",str(data['deployStatus'])):
                        print("Response:-"+str(data))
                        return "Error"
            if time.time() > timeout:
                print("Response:-"+str(capture_data))
                raise Exception("[PCC.Wait Until Cluster is Ready] Timeout")
            trace("  Waiting until cluster: %s is Ready, currently:     %s" % (data['ID'], data['deployStatus']))
            time.sleep(5)
        return "OK"
        
    ###########################################################################
    @keyword(name="PCC.K8s Wait Until Cluster Deleted")
    ###########################################################################
    def k8s_wait_until_cluster_deleted(self, *args, **kwargs):
        banner("PCC.K8s Wait Until Cluster Deleted")
        self._load_kwargs(kwargs)

        if self.cluster_id == None:
            return {"Error": "[PCC.K8s Wait Until Cluster Deleted]: Id of the cluster is not specified."}

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        Id_found_in_list_of_clusters = True
        timeout = time.time() + PCCSERVER_TIMEOUT

        time.sleep(45)
        while Id_found_in_list_of_clusters == True:
            Id_found_in_list_of_clusters = False
            response = pcc.get_kubernetes(conn)
            for data in get_response_data(response):
                if str(data['ID']) == str(self.cluster_id):
                    print("K8s Delete Response:"+str(data))
                    Id_found_in_list_of_clusters = True
                elif re.search("failed",str(data['deployStatus'])):
                    print("K8s Delete Response:"+str(data))
                    return "Error"
            if time.time() > timeout:
                raise Exception("[PCC.K8s Wait Until Cluster Deleted] Timeout")
            if Id_found_in_list_of_clusters:
                trace("  Waiting until k8s cluster: %s is deleted. Timeout in %.1f seconds." % 
                       (data['name'], timeout-time.time()))
                time.sleep(5)
        return "OK"

    ###########################################################################
    @keyword(name="PCC.K8s Upgrade Cluster")
    ###########################################################################
    def upgrade_kubernetes_by_id(self, *args, **kwargs): 
        banner("PCC.K8s Upgrade Cluster")
        self._load_kwargs(kwargs)
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        tmp_pool=[]
        if self.pools:
            for pool in eval(str(self.pools)):
                 tmp_pool.append(easy.get_ceph_pool_id_by_name(conn,pool))
        self.pools=tmp_pool

        if self.networkClusterName:
            self.networkClusterId=easy.get_network_clusters_id_by_name(conn,self.networkClusterName)
                         
        payload = {
            "k8sVersion": self.k8sVersion,
            "pools": self.pools,
            "networkClusterId": self.networkClusterId
        }

        if self.cluster_id == None:
            raise Exception("[PCC.Upgrade Cluster]: cluster id is not specified.")
        else:
            return pcc.upgrade_kubernetes_by_id(conn,str(self.cluster_id),payload)


    ###########################################################################
    @keyword(name="PCC.K8s Add App")
    ###########################################################################
    def add_kubernetes_app(self, *args, **kwargs):
        banner("PCC.K8s Add App")
        self._load_kwargs(kwargs)

        if self.appName == "wordpress-mysql-stateful":
            helm_val_file = '''
            STORAGE_CLASS_NAME: {}
            REPLICAS: {}
            EXTERNAL_IP: {}
            ACCESS_MODE: {}
            '''.format(self.storage_class_name,self.replica,self.external_ip,self.access_mode)

            trace("Helm value file :{}".format(helm_val_file))
            message_bytes = helm_val_file.encode('ascii')
            base64_bytes =str(base64.b64encode(message_bytes)).replace("b'","").replace("'","")
            trace("Base64 :{}".format(base64_bytes))

            payload = [{
                "appName": self.appName,
                "appNamespace": self.appNamespace,
                "gitUrl": self.gitUrl,
                "gitRepoPath": self.gitRepoPath,
                "gitBranch": self.gitBranch,
                "helmValuesFile": base64_bytes,
                "label": self.label
            }]
        else:
            payload = [{
                "appName": self.appName,
                "appNamespace": self.appNamespace,
                "gitUrl": self.gitUrl,
                "gitRepoPath": self.gitRepoPath,
                "gitBranch": self.gitBranch,
                "label": self.label
            }]


#        payload = [{
#            "appName": self.appName,
#            "appNamespace": self.appNamespace,
#            "gitUrl": self.gitUrl,
#            "gitRepoPath": self.gitRepoPath,
#            "gitBranch": self.gitBranch,
#            "label": self.label
 #       }]
        print("Payload:-"+str(payload))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.add_kubernetes_app(conn,str(self.cluster_id),payload)
        
    ###########################################################################
    @keyword(name="PCC.K8s Delete App")
    ###########################################################################
    def delete_kubernetes_app_by_id(self, *args, **kwargs): 
        banner("PCC.K8s Delete App")
        self._load_kwargs(kwargs)
        
        payload = {
            "appIds":[self.appIds]
        }
        
        print("Payload:-"+str(payload))
        
        if self.appIds == None:
            raise Exception("[PCC.K8s Delete App]: App id is not specified.")
        else:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            return pcc.delete_kubernetes_app_by_id(conn, str(self.cluster_id),payload)

    ###########################################################################
    @keyword(name="PCC.K8s Update Cluster Nodes")
    ###########################################################################
    def modify_kubernetes_by_id(self, *args, **kwargs):
        banner("PCC.K8s Update Cluster Nodes")
        self._load_kwargs(kwargs)

        conn = BuiltIn().get_variable_value("${PCC_CONN}") 
        
        tmp_node=[]
        if len(eval(str(self.toAdd)))!=0 :
            for node_name in eval(str(self.toAdd)):
                node_id=easy.get_node_id_by_name(conn,node_name)
                tmp_node.append({"id":node_id})
            self.toAdd=tmp_node

        tmp_node=[]
        if len(eval(str(self.toRemove)))!=0 :
            for node_name in eval(str(self.toRemove)):
                node_id=easy.get_node_id_by_name(conn,node_name)
                tmp_node.append(node_id)
            self.toRemove=tmp_node
            
        payload = {
            "rolePolicy": self.rolePolicy,
            "toAdd": self.toAdd,
            "toRemove": self.toRemove
        }
        
        print("Payload:-"+str(payload))
                
        return pcc.modify_kubernetes_by_id(conn,str(self.cluster_id),payload)

    ###########################################################################
    @keyword(name="PCC.K8s Verify BE")
    ###########################################################################
    def verify_k8s_be(self, *args, **kwargs):
        cmd="sudo kubectl get nodes"
        banner("PCC.K8s Verify BE")
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(kwargs))

        for ip in eval(str(self.nodes_ip)):
            output=cli_run(cmd=cmd, host_ip=ip, linux_user=self.user,linux_password=self.password)
            print("Output:"+str(output))
            if re.search("Ready",str(output)):
                continue
            else:
                print("Could not verify K8s on "+str(ip))
                return "Error"
        return "OK"

    ###############################################################################################################
    @keyword(name="PCC.Get K8s Version")
    ###############################################################################################################

    def get_k8s_version(self, *args, **kwargs):
        banner("Get K8s Version")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            # Get Ceph Version
            #cmd = "kubectl version"
            #status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user, linux_password=self.password)
            #print("cmd: {} executed successfully and status is: {}".format(cmd, status))
            #return status

            print("Kwargs are: {}".format(kwargs))
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            print("conn is {}".format(conn))

            k8s_list = pcc.get_kubernetes(conn)
            print("k8s_list is {}".format(k8s_list))

            k8s_ver_list = {}
            for data in k8s_list["Result"]["Data"]:
                print("portus version of portus {} is {} ".format(data["name"], data["k8sVersion"]))
                k8s_ver_list[data["name"]] = data["k8sVersion"]
            print("k8s_ver_list is {}".format(k8s_ver_list))
            return k8s_ver_list

        except Exception as e:
            trace("Error in getting k8s version: {}".format(e))

    ###########################################################################
    @keyword(name="PCC.K8s Get Storage Class Name")
    ###########################################################################
    def get_k8s_storage_class_name(self,*args,**kwargs):
        banner("PCC.K8s Get Storage Class Name")
        self._load_kwargs(kwargs)
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            get_sc_list = pcc.get_kubernetes_strgclasses_by_id(conn,str(self.cluster_id))
            trace("Storage class response:{}".format(get_sc_list))
            #for data in get_response_data(get_sc_list):
            for data in get_sc_list["Result"]["Data"]:
                trace("Data:{}".format(data))
                if str(self.pool_id) == str(data["cephPoolId"]):
                    return data["sc_name"]
            else:
                return "Error: Storage class not found"
        except Exception as e:
            raise e
