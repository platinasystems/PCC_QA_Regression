import time
import re
import json

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data, get_status_code
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60 * 40
PCCSERVER_TIMEOUT_UPGRADE = 60 * 60


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
        self.networkClusterId = None
        self.networkClusterName = None
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
        self.nodes_ip = None
        self.user = "pcc"
        self.password = "cals0ft"
        self.hostip = None
        self.storageClassIds = None
        self.forceRemove = False

        super().__init__()

    ###########################################################################
    @keyword(name="PCC.K8s Create Cluster")
    ###########################################################################
    def add_kubernetes(self, *args, **kwargs):
        banner("PCC.K8s Create Cluster")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        tmp_node = []
        for node_name in eval(str(self.nodes)):
            node_id = easy.get_node_id_by_name(conn, node_name)
            tmp_node.append({"id": node_id})
        self.nodes = tmp_node

        tmp_pool = []
        if self.pools:
            for pool in eval(str(self.pools)):
                tmp_pool.append(easy.get_ceph_pool_id_by_name(conn, pool))

        self.pools = tmp_pool

        if self.networkClusterName:
            self.networkClusterId = easy.get_network_clusters_id_by_name(conn, self.networkClusterName)

        payload = {
            "id": int(self.id),
            "k8sVersion": self.k8sVersion,
            "cniPlugin": self.cniPlugin,
            "name": self.name,
            "nodes": self.nodes,
            "pools": self.pools,
            "networkClusterId": self.networkClusterId
        }

        print("paylod:-" + str(payload))
        trace(str(payload))
        return pcc.add_kubernetes(conn, payload)

    ###########################################################################
    @keyword(name="PCC.K8s Get Cluster Id")
    ###########################################################################
    def get_k8s_cluster_id_by_name(self, *args, **kwargs):
        banner("PCC.K8s Get Cluster Id")
        self._load_kwargs(kwargs)

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        cluster_id = easy.get_k8s_cluster_id_by_name(conn, self.name)
        trace(cluster_id)
        return cluster_id

    ###########################################################################
    @keyword(name="PCC.K8s Get App Id")
    ###########################################################################
    def get_k8s_app_id_by_name(self, *args, **kwargs):
        banner("PCC.K8s Get App Id")
        self._load_kwargs(kwargs)

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        app_id = easy.get_k8s_app_id_by_name(conn, self.appName)
        trace(app_id)
        return app_id

    ###########################################################################
    @keyword(name="PCC.K8s Delete Cluster")
    ###########################################################################
    def delete_kubernetes_by_id(self, *args, **kwargs):
        banner("PCC.K8s Delete Cluster")
        self._load_kwargs(kwargs)

        payload = {"forceRemove": self.forceRemove}

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        print("Payoad:"+str(payload))
        response = pcc.delete_kubernetes_by_id(conn, str(self.id), payload, "")
        status_code = get_status_code(response)
        if status_code == 202:
            code = get_response_data(response)["code"]
            return pcc.delete_kubernetes_by_id(conn, str(self.id), payload, "?code=" + code)
        return response

    ###########################################################################
    @keyword(name="PCC.K8s Get Storage Class Ids")
    ###########################################################################
    def get_kubernetes_storageclassid_by_name(self, *args, **kwargs):
        banner("PCC.K8s Get Storage Class Ids")
        self._load_kwargs(kwargs)
        strgClassId = []
        if not self.cluster_id:
            raise Exception("[PCC.K8s Get Storage Class Ids]: cluster id is not specified.")
        else:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            try:
                list_of_k8s_strgclasses = pcc.get_kubernetes_strgclasses_by_id(conn, str(self.cluster_id))['Result'][
                    'Data']
                trace(list_of_k8s_strgclasses)
                for pool in eval(str(self.pools)):
                    for data in list_of_k8s_strgclasses:
                        poolname = "-" + pool + "-"
                        if re.search(poolname, data['sc_name']):
                            strgClassId.append(data['id'])
                            break
                self.storageClassIds = strgClassId
                return self.storageClassIds
            except Exception as e:
                return {"...Error in test": str(e)}

    ###########################################################################
    @keyword(name="PCC.K8s delete Storage Classes")
    ###########################################################################
    def delete_kubernetes_storageclasses_by_id(self, *args, **kwargs):
        banner("PCC.K8s delete Storage Classes")
        self._load_kwargs(kwargs)
        if not self.storageClassIds:
            raise Exception("[PCC.K8s delete Storage Classes]: Storage ClassId is not specified.")
        if not self.cluster_id:
            raise Exception("[PCC.K8s delete Storage Classes]: cluster id is not specified.")
        else:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            payload = {
                "ids": self.storageClassIds
            }

            print("payload:-" + str(payload))
            trace(str(payload))
            return pcc.delete_kubernetes_strgclasses_by_id(conn, str(self.cluster_id), payload)

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

        payload={"forceRemove":self.forceRemove}

        response = pcc.get_kubernetes(conn)
        for data in get_response_data(response):
            print("Response To Look :-" + str(data))
            print("K8s {} and id {} is deleting....".format(data['name'], data['ID']))
            trace("K8s {} and id {} is deleting....".format(data['name'], data['ID']))
            self.cluster_id = data['ID']
            response = pcc.delete_kubernetes_by_id(conn, str(self.cluster_id), payload, "")
            status_code = get_status_code(response)
            if status_code == 202:
                code = get_response_data(response)["code"]
                del_response = pcc.delete_kubernetes_by_id(conn, str(self.id), payload, "?code=" + code)
                if del_response['Result']['status'] == 200:
                    del_check = self.k8s_wait_until_cluster_deleted()
                    if del_check == "OK":
                        print("k8s Cluster {} is deleted sucessfully".format(data['name']))
                        return "OK"
                    else:
                        print("k8s Cluster {} unable to delete".format(data['name']))
                        return "Error"
                else:
                    print("Delete Response:" + str(del_response))
                    print("Issue: Not getting 200 response back")
                    return "Error"
            else:
                return "Error"
        return "OK"

        ###########################################################################

    @keyword(name="PCC.K8s Wait Until Cluster is Ready")
    ###########################################################################
    def k8s_wait_until_cluster_ready(self, *args, **kwargs):
        banner("PCC.K8s Wait Until Cluster is Ready")
        self._load_kwargs(kwargs)

        if self.name == None:
            raise Exception("[PCC.Wait Until Cluster is Ready]: K8s Cluster Name is not specified." % args)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        cluster_ready = False
        timeout = time.time() + PCCSERVER_TIMEOUT
        capture_data = ""

        time.sleep(60)
        while cluster_ready == False:
            response = pcc.get_kubernetes(conn)
            trace(response)
            for data in get_response_data(response):
                if str(data['name']).lower() == str(self.name).lower():
                    capture_data = data

                    if "progressPercentage" in data['latestAnsibleJob'].keys():
                        trace("  Waiting until cluster: %s is Ready, currently:  %s" % (
                        data['ID'], data['latestAnsibleJob']['progressPercentage']))
                        if int(data['latestAnsibleJob']['progressPercentage']) == 100 and (
                                str(data['deployStatus']).lower() == 'installed' or str(
                                data['deployStatus']).lower() == 'update completed'):
                            print("Response:-" + str(data))
                            cluster_ready = True
                        elif re.search("failed", data['latestAnsibleJob']['status']):
                            print("Response:-" + str(data))
                            return "Error"
                    elif str(data['deployStatus']).lower() == 'installed' or str(
                            data['deployStatus']).lower() == 'update completed':
                        print("Response:-" + str(data))
                        cluster_ready = True
                    if re.search("failed", str(data['deployStatus'])):
                        print("Response:-" + str(data))
                        return "Error"
            if time.time() > timeout:
                print("Response:-" + str(capture_data))
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
                    print("K8s Delete Response:" + str(data))
                    Id_found_in_list_of_clusters = True
                elif re.search("failed", str(data['deployStatus'])):
                    print("K8s Delete Response:" + str(data))
                    return "Error"
            if time.time() > timeout:
                raise Exception("[PCC.K8s Wait Until Cluster Deleted] Timeout")
            if Id_found_in_list_of_clusters:
                trace("  Waiting until k8s cluster: %s is deleted. Timeout in %.1f seconds." %
                      (data['name'], timeout - time.time()))
                time.sleep(5)
        return "OK"

    ###########################################################################
    @keyword(name="PCC.K8s Upgrade Cluster")
    ###########################################################################
    def upgrade_kubernetes_by_id(self, *args, **kwargs):
        banner("PCC.K8s Upgrade Cluster")
        self._load_kwargs(kwargs)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        trace("test")
        tmp_pool = []
        trace(self.pools)

        if self.pools:
            for pool in eval(str(self.pools)):
                trace(pool)
                trace(easy.get_ceph_pool_id_by_name(conn, pool))
                tmp_pool.append(easy.get_ceph_pool_id_by_name(conn, pool))

        self.pools = tmp_pool

        # if self.networkClusterName:
        #   self.networkClusterId=easy.get_network_clusters_id_by_name(conn,self.networkClusterName)
        trace(tmp_pool)
        payload = {
            "k8sVersion": self.k8sVersion,
            "pools": self.pools
            # "networkClusterId": self.networkClusterId
        }

        if self.cluster_id is None:
            raise Exception("[PCC.Upgrade Cluster]: cluster id is not specified.")
        else:
            return pcc.upgrade_kubernetes_by_id(conn, str(self.cluster_id), payload)

    ###########################################################################
    @keyword(name="PCC.K8s Add App")
    ###########################################################################
    def add_kubernetes_app(self, *args, **kwargs):
        banner("PCC.K8s Add App")
        self._load_kwargs(kwargs)

        payload = [{
            "appName": self.appName,
            "appNamespace": self.appNamespace,
            "gitUrl": self.gitUrl,
            "gitRepoPath": self.gitRepoPath,
            "gitBranch": self.gitBranch,
            "label": self.label
        }]
        print("Payload:-" + str(payload))
        trace(str(payload))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.add_kubernetes_app(conn, str(self.cluster_id), payload)

    ###########################################################################
    @keyword(name="PCC.K8s Delete App")
    ###########################################################################
    def delete_kubernetes_app_by_id(self, *args, **kwargs):
        banner("PCC.K8s Delete App")
        self._load_kwargs(kwargs)

        payload = {
            "appIds": [self.appIds]
        }

        print("Payload:-" + str(payload))

        if self.appIds == None:
            raise Exception("[PCC.K8s Delete App]: App id is not specified.")
        else:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            return pcc.delete_kubernetes_app_by_id(conn, str(self.cluster_id), payload)

    ###########################################################################
    @keyword(name="PCC.K8s Update Cluster Nodes")
    ###########################################################################
    def modify_kubernetes_by_id(self, *args, **kwargs):
        banner("PCC.K8s Update Cluster Nodes")
        self._load_kwargs(kwargs)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        tmp_node = []
        if len(eval(str(self.toAdd))) != 0:
            for node_name in eval(str(self.toAdd)):
                node_id = easy.get_node_id_by_name(conn, node_name)
                tmp_node.append({"id": node_id})
            self.toAdd = tmp_node

        tmp_node = []
        if len(eval(str(self.toRemove))) != 0:
            for node_name in eval(str(self.toRemove)):
                node_id = easy.get_node_id_by_name(conn, node_name)
                tmp_node.append(node_id)
            self.toRemove = tmp_node

        payload = {
            "rolePolicy": self.rolePolicy,
            "toAdd": self.toAdd,
            "toRemove": self.toRemove
        }

        print("Payload:-" + str(payload))

        return pcc.modify_kubernetes_by_id(conn, str(self.cluster_id), payload)

    ###########################################################################
    @keyword(name="PCC.K8s Verify BE")
    ###########################################################################
    def verify_k8s_be(self, *args, **kwargs):
        cmd = "sudo kubectl get nodes"
        banner("PCC.K8s Verify BE")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))

        for ip in eval(str(self.nodes_ip)):
            output = cli_run(cmd=cmd, host_ip=ip, linux_user=self.user, linux_password=self.password)
            print("Output:" + str(output))
            if re.search("Ready", str(output)):
                continue
            else:
                print("Could not verify K8s on " + str(ip))
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
            # cmd = "kubectl version"
            # status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user, linux_password=self.password)
            # print("cmd: {} executed successfully and status is: {}".format(cmd, status))
            # return status

            print("Kwargs are: {}".format(kwargs))
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            print("conn is {}".format(conn))

            k8s_list = pcc.get_kubernetes(conn)
            print("k8s_list is {}".format(k8s_list))
            trace("k8s_list is {}".format(k8s_list))

            k8s_ver_list = {}
            for data in k8s_list["Result"]["Data"]:
                print("portus version of portus {} is {} ".format(data["name"], data["k8sVersion"]))
                # trace("portus version of portus {} is {} ".format(data["name"], data["k8sVersion"]))
                k8s_ver_list[data["name"]] = data["k8sVersion"]
            print("k8s_ver_list is {}".format(k8s_ver_list))
            #  trace("k8s_ver_list is {}".format(k8s_ver_list))
            return k8s_ver_list

        except Exception as e:
            trace("Error in getting k8s version: {}".format(e))


