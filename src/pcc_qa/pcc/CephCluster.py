import re
import time
import json
import ast
from time import sleep
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print, cmp_json, midtext
from pcc_qa.common.Result import get_response_data, get_status_code
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60*40

class CephCluster(PccBase):

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
        self.password="plat1na"
        self.data1=None
        self.data2=None
        self.state=None
        self.limit=None
        self.state_status=None
        self.forceRemove=None
        self.hostip= None
        self.mount_path=None
        self.mount_folder_name= None
        self.dummy_file_name = None
        self.dummy_file_size = None
        self.operation_to_perform = None
        self.storage_types= None
        self.node_location = None
        self.server = None
        self.osdScrubBeginHourDesired = 18
        self.osdScrubEndHourDesired = 6
        self.osdRecoverySleepHddDesired = 0.5
        self.osdRecoverySleepSsdDesired = 0
        self.osdRecoverySleepHybridDesired = 0.1
        self.osdRecoveryPriorityDesired = 3
        self.osdRecoveryOpPriorityDesired = 1
        self.osdMaxBackfillsDesired = 1
        self.osdScrubSleepDesired = 0.1
        self.osdScrubPriorityDesired = 2
        self.osdDeepScrubStrideDesired = 1048576
        self.osdDeleteSleepHybridDesired = 3
        self.osdSnapTrimPriorityDesired = 1
        self.osdRecoveryMaxActiveHddDesired = 1
        self.osdRecoveryMaxActiveSsdDesired = 5
        self.osdMemoryTargetFlashDesired = 17179869184
        self.osdMemoryTargetRotationalDesired = 8589934592
        self.osdMemoryTargetFullRotationalDesired = 4294967296
        self.osd_ids = None
        self.osd_ids_deleted = None
        self.services = None
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
    @keyword(name="PCC.Verify Ceph Cluster OSDs Params")
    ###########################################################################
    def verify_ceph_osd_params(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("Verify Ceph Cluster OSDs Params")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        cluster = easy.get_ceph_cluster_by_name(conn, self.name)
        print(cluster)
        if ((self.osdScrubBeginHourDesired == cluster["osdScrubBeginHourDesired"]) and
            (self.osdScrubEndHourDesired == cluster["osdScrubEndHourDesired"]) and
            (self.osdRecoverySleepHddDesired == cluster["osdRecoverySleepHddDesired"]) and
            (self.osdRecoverySleepSsdDesired == cluster["osdRecoverySleepSsdDesired"]) and
            (self.osdRecoverySleepHybridDesired == cluster["osdRecoverySleepHybridDesired"]) and
            (self.osdRecoveryPriorityDesired == cluster["osdRecoveryPriorityDesired"]) and
            (self.osdRecoveryOpPriorityDesired == cluster["osdRecoveryOpPriorityDesired"]) and
            (self.osdMaxBackfillsDesired == cluster["osdMaxBackfillsDesired"]) and
            (self.osdScrubSleepDesired == cluster["osdScrubSleepDesired"]) and
            (self.osdScrubPriorityDesired == cluster["osdScrubPriorityDesired"]) and
            (self.osdDeepScrubStrideDesired ==  cluster["osdDeepScrubStrideDesired"]) and
            (self.osdDeleteSleepHybridDesired == cluster["osdDeleteSleepHybridDesired"]) and
            (self.osdSnapTrimPriorityDesired == cluster["osdSnapTrimPriorityDesired"]) and
            (self.osdRecoveryMaxActiveHddDesired == cluster["osdRecoveryMaxActiveHddDesired"]) and
            (self.osdRecoveryMaxActiveSsdDesired == cluster["osdRecoveryMaxActiveSsdDesired"]) and
            (self.osdMemoryTargetFlashDesired == cluster["osdMemoryTargetFlashDesired"]) and
            (self.osdMemoryTargetRotationalDesired == cluster["osdMemoryTargetRotationalDesired"]) and
            (self.osdMemoryTargetFullRotationalDesired == cluster["osdMemoryTargetFullRotationalDesired"])):
            return "OK"
        self.show_desired_parameters()
        return "Error"

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
            "networkClusterId": self.networkClusterId,
            "networkClusterId": self.networkClusterId,
            "osdScrubBeginHourDesired": self.osdScrubBeginHourDesired,
            "osdScrubEndHourDesired": self.osdScrubEndHourDesired,
            "osdRecoverySleepHddDesired": self.osdRecoverySleepHddDesired,
            "osdRecoverySleepSsdDesired": self.osdRecoverySleepSsdDesired,
            "osdRecoverySleepHybridDesired": self.osdRecoverySleepHybridDesired,
            "osdRecoveryPriorityDesired": self.osdRecoveryPriorityDesired,
            "osdRecoveryOpPriorityDesired": self.osdRecoveryOpPriorityDesired,
            "osdMaxBackfillsDesired": self.osdMaxBackfillsDesired,
            "osdScrubSleepDesired": self.osdScrubSleepDesired,
            "osdScrubPriorityDesired": self.osdScrubPriorityDesired,
            "osdDeepScrubStrideDesired": self.osdDeepScrubStrideDesired,
            "osdDeleteSleepHybridDesired": self.osdDeleteSleepHybridDesired,
            "osdSnapTrimPriorityDesired": self.osdSnapTrimPriorityDesired,
            "osdRecoveryMaxActiveHddDesired": self.osdRecoveryMaxActiveHddDesired,
            "osdRecoveryMaxActiveSsdDesired": self.osdRecoveryMaxActiveSsdDesired,
            "osdMemoryTargetFlashDesired": self.osdMemoryTargetFlashDesired,
            "osdMemoryTargetRotationalDesired": self.osdMemoryTargetRotationalDesired,
            "osdMemoryTargetFullRotationalDesired": self.osdMemoryTargetFullRotationalDesired
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
        trace(tmp_node)
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
            "networkClusterId": self.networkClusterId,
            "osdScrubBeginHourDesired": self.osdScrubBeginHourDesired,
            "osdScrubEndHourDesired": self.osdScrubEndHourDesired,
            "osdRecoverySleepHddDesired": self.osdRecoverySleepHddDesired,
            "osdRecoverySleepSsdDesired": self.osdRecoverySleepSsdDesired,
            "osdRecoverySleepHybridDesired": self.osdRecoverySleepHybridDesired,
            "osdRecoveryPriorityDesired": self.osdRecoveryPriorityDesired,
            "osdRecoveryOpPriorityDesired": self.osdRecoveryOpPriorityDesired,
            "osdMaxBackfillsDesired": self.osdMaxBackfillsDesired,
            "osdScrubSleepDesired": self.osdScrubSleepDesired,
            "osdScrubPriorityDesired": self.osdScrubPriorityDesired,
            "osdDeepScrubStrideDesired": self.osdDeepScrubStrideDesired,
            "osdDeleteSleepHybridDesired": self.osdDeleteSleepHybridDesired,
            "osdSnapTrimPriorityDesired": self.osdSnapTrimPriorityDesired,
            "osdRecoveryMaxActiveHddDesired": self.osdRecoveryMaxActiveHddDesired,
            "osdRecoveryMaxActiveSsdDesired": self.osdRecoveryMaxActiveSsdDesired,
            "osdMemoryTargetFlashDesired": self.osdMemoryTargetFlashDesired,
            "osdMemoryTargetRotationalDesired": self.osdMemoryTargetRotationalDesired,
            "osdMemoryTargetFullRotationalDesired": self.osdMemoryTargetFullRotationalDesired
             }

            trace("Payload:-"+str(payload))

        except Exception as e:
            trace("[update_cluster] EXCEPTION: %s" % str(e))
            raise Exception(e)

        response = pcc.modify_ceph_clusters(conn, payload, "")
        status_code = get_status_code(response)
        if status_code == 202:
            code = get_response_data(response)["code"]
            return pcc.modify_ceph_clusters(conn, payload, "?code=" + code)
        return response

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
        response = pcc.delete_ceph_cluster_by_id(conn, str(self.id), payload, "")
        trace(response)
        status_code = get_status_code(response)
        if status_code == 202:
            code = get_response_data(response)["code"]
            return pcc.delete_ceph_cluster_by_id(conn, str(self.id), payload, "?code=" + code)
        return response

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
                    if data['deploy_status'] == 'failed':
                        return "Error"
            if time.time() > timeout:
                raise Exception("[PCC.Ceph Wait Until Cluster Deleted] Timeout")
            if Id_found_in_list_of_clusters:             
                trace("  Waiting until cluster: %s is deleted. Timeout in %.1f seconds." % 
                       (data['name'], timeout-time.time()))
                time.sleep(5)
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Show Desired Parameters")
    ###########################################################################
    def show_desired_parameters(self, *args, **kwargs):
        banner("PCC.Ceph Show Desired Parameters")
        self._load_kwargs(kwargs)
        print("osd_deep_scrub_stride = {}".format(self.osdDeepScrubStrideDesired))
        print("osd_delete_sleep_hybrid = {}".format(self.osdDeleteSleepHybridDesired))
        print("osd_max_backfills = {}".format(self.osdMaxBackfillsDesired))
        print("osd_recovery_max_active_hdd = {}".format(self.osdRecoveryMaxActiveHddDesired))
        print("osd_recovery_max_active_ssd = {}".format(self.osdRecoveryMaxActiveSsdDesired))
        print("osd_recovery_op_priority = {}".format(self.osdRecoveryOpPriorityDesired))
        print("osd_recovery_priority = {}".format(self.osdRecoveryPriorityDesired))
        print("osd_recovery_sleep_hdd = {}".format(self.osdRecoverySleepHddDesired))
        print("osd_recovery_sleep_ssd = {}".format(self.osdRecoverySleepSsdDesired))
        print("osd_recovery_sleep_hybrid = {}".format(self.osdRecoverySleepHybridDesired))
        print("osd_scrub_begin_hour = {}".format(self.osdScrubBeginHourDesired))
        print("osd_scrub_end_hour = {}".format(self.osdScrubEndHourDesired))
        print("osd_scrub_priority = {}".format(self.osdScrubPriorityDesired))
        print("osd_scrub_sleep = {}".format(self.osdScrubSleepDesired))
        print("osd_snap_trim_priority = {}".format(self.osdSnapTrimPriorityDesired))

    ###########################################################################
    @keyword(name="PCC.Ceph Verify BE")
    ###########################################################################
    def verify_ceph_be(self, *args, **kwargs):
        ceph_be_cmd="sudo ceph -s"
        ceph_conf ="sudo cat /etc/ceph/ceph.conf"
        banner("PCC.Ceph Verify BE")
        self._load_kwargs(kwargs)
        osd_deep_scrub_stride = "osd_deep_scrub_stride = {}".format(self.osdDeepScrubStrideDesired)
        osd_delete_sleep_hybrid = "osd_delete_sleep_hybrid = {}".format(self.osdDeleteSleepHybridDesired)
        osd_max_backfills = "osd_max_backfills = {}".format(self.osdMaxBackfillsDesired)
        osd_recovery_max_active_hdd = "osd_recovery_max_active_hdd = {}".format(self.osdRecoveryMaxActiveHddDesired)
        osd_recovery_max_active_ssd = "osd_recovery_max_active_ssd = {}".format(self.osdRecoveryMaxActiveSsdDesired)
        osd_recovery_op_priority = "osd_recovery_op_priority = {}".format(self.osdRecoveryOpPriorityDesired)
        osd_recovery_priority = "osd_recovery_priority = {}".format(self.osdRecoveryPriorityDesired)
        osd_recovery_sleep_hdd = "osd_recovery_sleep_hdd = {}".format(self.osdRecoverySleepHddDesired)
        osd_recovery_sleep_ssd = "osd_recovery_sleep_ssd = {}".format(self.osdRecoverySleepSsdDesired)
        osd_recovery_sleep_hybrid = "osd_recovery_sleep_hybrid = {}".format(self.osdRecoverySleepHybridDesired)
        osd_scrub_begin_hour = "osd_scrub_begin_hour = {}".format(self.osdScrubBeginHourDesired)
        osd_scrub_end_hour = "osd_scrub_end_hour = {}".format(self.osdScrubEndHourDesired)
        osd_scrub_priority = "osd_scrub_priority = {}".format(self.osdScrubPriorityDesired)
        osd_scrub_sleep = "osd_scrub_sleep = {}".format(self.osdScrubSleepDesired)
        osd_snap_trim_priority = "osd_snap_trim_priority = {}".format(self.osdSnapTrimPriorityDesired)


        for ip in eval(str(self.nodes_ip)):
            output=cli_run(ip,self.user,self.password,ceph_be_cmd)
            print("Output:"+str(output))
            if re.search("HEALTH_OK",str(output)) or re.search("HEALTH_WARN",str(output)):
                osd_memory_target = "osd_memory_target = {}".format(self.osdMemoryTargetRotationalDesired)
                has_ssd = cli_run(ip, self.user, self.password,"lsblk -d -o name,rota | grep 'sdb\|sdc' | grep 0" ).stdout != ""
                if has_ssd:
                    osd_memory_target = "osd_memory_target = {}".format(self.osdMemoryTargetFlashDesired)
                output = cli_run(ip, self.user, self.password, ceph_conf).stdout
                print("ceph.conf: {}".format(output))
                if (re.search(osd_deep_scrub_stride, output)
                    and re.search(osd_delete_sleep_hybrid, output)
                    and re.search(osd_max_backfills, output)
                    and re.search(osd_recovery_max_active_hdd, output)
                    and re.search(osd_recovery_max_active_ssd, output)
                    and re.search(osd_recovery_op_priority, output)
                    and re.search(osd_recovery_priority, output)
                    and re.search(osd_recovery_sleep_hdd, output)
                    and re.search(osd_recovery_sleep_ssd, output)
                    and re.search(osd_recovery_sleep_hybrid, output)
                    and re.search(osd_scrub_begin_hour, output)
                    and re.search(osd_scrub_end_hour, output)
                    and re.search(osd_scrub_priority, output)
                    and re.search(osd_scrub_sleep, output)
                    and re.search(osd_memory_target, output)
                    and re.search(osd_snap_trim_priority, output)):
                    continue
                else:
                    self.show_desired_parameters()
                    return "Error"
            else:
                trace("Ceph Health Status: HEALTH_ERR")
                return "Error"
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Cleanup BE 2")
    ###########################################################################
    def ceph_cleanup_be_2(self,**kwargs):
        self._load_kwargs(kwargs)

        trace(self.nodes_ip)
        for ip in eval(self.nodes_ip):
            trace(ip)
            trace("Cleaning disks on host: " + ip)
            # list vgs and remove them
            trace("List ceph vgs and remove them")
            cmd = 'sudo vgs'
            out = cli_run(ip, self.user, self.password, cmd)
            trace(out)
            vgs = [s for s in out.stdout.split(" ") if "ceph_data_" in s]
            for v in vgs:
                cmd = 'sudo vgremove ' + v + ' -y'
                out = cli_run(ip, self.user, self.password, cmd)
                trace(out)
            sleep(3)

            # list pvs and remove them
            trace("List pvs and remove them")
            cmd = "sudo pvs"
            out = cli_run(ip, self.user, self.password, cmd)
            trace(out)
            pvs = [s for s in out.stdout.split(" ") if "/dev/" in s and "sda" not in s]
            for p in pvs:
                cmd = 'sudo pvremove ' + p + ' -y'
                out = cli_run(ip, self.user, self.password, cmd)
                trace(out)
            sleep(3)

            # list disks and wipe
            trace("List disks and wipe them")
            cmd = 'sudo lsblk -nd'
            out = cli_run(ip, self.user, self.password, cmd)
            trace(out)
            disks = [s.strip("\n") for s in out.stdout.split(" ") if "sd" in s and "sda" not in s]
            for d in disks:
                cmd = 'sudo wipefs -a /dev/' + d
                out = cli_run(ip, self.user, self.password, cmd)
                trace(out)
            sleep(3)

            cmd = 'sudo lsblk'
            out = cli_run(ip, self.user, self.password, cmd)
            trace(out)
            trace("-----------------------------------")
        return "OK"


    ###########################################################################
    @keyword(name="PCC.Ceph Cleanup BE")
    ###########################################################################
    def ceph_cleanup_be(self,**kwargs):
        self._load_kwargs(kwargs)
        cmd1 = "sudo lsblk | grep 'disk' | awk '{print $1}'"
        
        for ip in self.nodes_ip:
            trace("======== cmd: {} is getting executed ========".format(cmd1))
            print("======== cmd: {} is getting executed ========".format(cmd1))
            trace(ip)
            trace(self.user)
            trace(self.password)
            drives_op = cli_run(host_ip=ip, linux_user=self.user, linux_password=self.password, cmd=cmd1)

            trace("Drives_op: {}".format(str(drives_op)))
            print("Drives_op: {}".format(str(drives_op)))

            serialized_drives = str(self._serialize_response(time.time(), drives_op )['Result']['stdout']).strip().split('\n')[1:]
            trace("serialized_drives: {}".format(serialized_drives))
            print("serialized_drives: {}".format(serialized_drives))
            for drive in serialized_drives:
                cmd2="sudo wipefs -a /dev/{}".format(drive.strip())
                trace("======== cmd: {} is getting executed ========".format(cmd2))
                print("======== cmd: {} is getting executed ========".format(cmd2))
                clean_drives_op = cli_run(host_ip=ip,linux_user=self.user,linux_password=self.password,cmd=cmd2)
                trace("Clean drives output:{}".format(str(clean_drives_op)))
                print("Clean drives output:{}".format(str(clean_drives_op)))
                time.sleep(5)
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Cleanup BE Tables")
    ###########################################################################
    def ceph_cleanup_be_tables(self,**kwargs):
        self._load_kwargs(kwargs)
        cmd='sudo iptables -t nat -F && iptables -t filter -F && iptables -t mangle -F && > /etc/frr/frr.conf && > /etc/frr/ospfd.conf && > /etc/frr/zebra.conf && sudo systemctl restart frr && vtysh -c "show run" && ip link del ceph0 && ip link del lo0 && ip link del control0'
        for ip in self.nodes_ip:
            data=cli_run(ip,self.user,self.password,cmd)
        time.sleep(30)
        return "OK"
        
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
  
        if str(self.forceRemove).lower()=="true":
            payload={"forceRemove":True}
        else:
            payload={"forceRemove":False}
        print("Payload:"+str(payload))
        response = pcc.get_ceph_clusters(conn)
        for data in get_response_data(response):
            print("Response To Look :-"+str(data))
            print("Ceph Cluster {} and id {} is deleting....".format(data['name'],data['id']))
            self.id=data['id']
            response=pcc.delete_ceph_cluster_by_id(conn, str(self.id), payload, "")
            trace(response)
            status_code = get_status_code(response)
            if status_code == 202:
                code = get_response_data(response)["code"]
                del_response = pcc.delete_ceph_cluster_by_id(conn, str(self.id), payload, "?code=" + code)
                if del_response['Result']['status'] == 200:
                    del_check=self.wait_until_cluster_deleted()
                    if del_check == "OK":
                        print("Ceph Cluster {} is deleted sucessfully".format(data['name']))
                        return "OK"
                    else:
                        print("Ceph Cluster {} unable to delete".format(data['name']))
                        return "Error"
                else:
                    print("Delete Response:"+str(del_response))
                    print("Issue: Not getting 200 response back")
                    return "Error"
            else:
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
        banner("PCC.Ceph Make Osds Up : {}".format(self.name))
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
            cmd="sudo systemctl -f start ceph-osd@{}".format(data['osd'])
            cmd_exec=cli_run(host_ip,self.user,self.password,cmd)
            print("cmd:"+str(cmd))
            print("cmd output:"+str(cmd_exec))    
            time.sleep(60)
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
    @keyword(name="PCC.Ceph Make Mons Restart")
    ###########################################################################
    def make_ceph_mons_restart(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Make Mons Restart : {}".format(self.name))
        print("Kwargs:"+str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e 
        cluster_id = easy.get_ceph_cluster_id_by_name(conn,self.name)
        print("Cluster Name: {} Id: {}".format(self.name,cluster_id))  
        response = pcc.get_ceph_clusters_state(conn,str(cluster_id),'mons')
        host_ip=None
        for data in get_response_data(response):
            print("Data:"+str(data))
            trace("Data:"+str(data))
            print("Server:"+str(data['server']))
            host_ip=easy.get_hostip_by_name(conn,data['server'])
            print("Host Ip:"+str(host_ip))
            cmd="sudo systemctl -f restart ceph-mon@{}".format(data['server'])
            cmd_exec=cli_run(host_ip,self.user,self.password,cmd)
            print("cmd:"+str(cmd))
            print("cmd output:"+str(cmd_exec))    
            time.sleep(10)            
            cmd_verify="sudo systemctl status ceph-mon@{} |grep running |wc -l".format(data['server'].split(".")[0])
            cmd_verify_exec= cli_run(host_ip,self.user,self.password, cmd_verify)
            serialise_output=self._serialize_response(time.time(), cmd_verify_exec )['Result']['stdout']
            print("cmd:"+str(cmd_verify))
            print("cmd output:"+str(cmd_verify_exec))    
            print("Serialise Output:"+str(serialise_output))            
            if int(serialise_output)==1:
                print("{} restarted sucessfully !!!".format(data['server']))
                continue
            else:
                print("Command execution could not restart mon {}".format(data['server']))
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
        
    ###############################################################################################################
    @keyword(name="PCC.Get CEPH Inet IP")
    ###############################################################################################################
    
    def get_ceph_inet_ip(self, *args, **kwargs):
        banner("Get CEPH Inet IP")
        self._load_kwargs(kwargs)
        try:
            cmd= "sudo ip addr | grep control0"
            print("Command is: {}".format(cmd))
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
            
            serialised_status = self._serialize_response(time.time(), status)
            print("serialised_inet_ip_status is:{}".format(serialised_status))
            
            cmd_output = str(serialised_status['Result']['stdout']).replace('\n', '').strip()
            re_match = re.findall("inet (.*) scope", cmd_output)
            inet_ip = str(re_match).split("/")[0]
            print("Inet ip is : {}".format(inet_ip))
            return inet_ip.replace("['","")
        except Exception as e:
            trace("Error in get_ceph_inet_ip: {}".format(e))
    
    ###############################################################################################################
    @keyword(name="Create mount folder")
    ###############################################################################################################
    
    def create_mount_folder(self, *args, **kwargs):
        banner("Create mount folder")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            #Creating mount folder
            cmd= "sudo mkdir /mnt/{}".format(self.mount_folder_name)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
            print("cmd: {} executed successfully and status is: {}".format(cmd, status))            
            return "OK"
            
        except Exception as e:
            trace("Error in creating mount folder: {}".format(e))
    
    
        
    ###############################################################################################################
    @keyword(name="Create dummy file and copy to mount path")
    ###############################################################################################################
    
    def create_dummy_file_copy_to_mount_path(self, *args, **kwargs):
        banner("Create dummy file and copy to mount path")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            #Creating dummy file
            cmd= "sudo dd if=/dev/zero of={} bs={} count=1".format(self.dummy_file_name, self.dummy_file_size)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
            print("cmd4: {} executed successfully and status is: {}".format(cmd, status))
            
            time.sleep(2)
            
            #Copying sample 2mb file to mount folder
            cmd= "sudo cp /home/pcc/{} /mnt/{}".format(self.dummy_file_name, self.mount_folder_name)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
            print("cmd5: {} executed successfully and status is:{}".format(cmd,status))
            
            time.sleep(2)
            
            return "OK"
            
        except Exception as e:
            trace("Error in create_dummy_file_copy_to_mount_path : {}".format(e))
            
    ###############################################################################################################
    @keyword(name="Remove dummy file")
    ###############################################################################################################
    
    def remove_dummy_file(self, *args, **kwargs):
        banner("Remove dummy file")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            print("username is '{}' and password is: '{}'".format(self.user,self.password))
            cmd= "sudo rm -rf /home/pcc/{}".format(self.dummy_file_name)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
            print("cmd3: {} executed successfully and status is : {}".format(cmd,status))
            
            return "OK"
            
        except Exception as e:
            trace("Error in removing dummy file: {}".format(e))
            
    ###############################################################################################################
    @keyword(name="PCC.Operation to perform on all CEPH daemons")
    ###############################################################################################################
    
    def operation_to_perform_on_all_ceph_daemons(self, *args, **kwargs):
        banner("PCC.Operation to perform on all CEPH daemons")
        self._load_kwargs(kwargs)
        print("Kwargs are: {}".format(kwargs))
        try:
            try:
                conn = BuiltIn().get_variable_value("${PCC_CONN}")
            except Exception as e:
                raise e
            host_name = easy.get_host_name_by_ip(conn,self.hostip)
            if "operation_to_perform" not in kwargs:
                self.operation_to_perform = None
            
            if self.operation_to_perform:    
                cmd_list = ["sudo systemctl {} ceph-mon@{}","sudo systemctl {} ceph-mds@{}","sudo systemctl {} ceph-mgr@{}"]
                cmd_with_host_name = [x.format(self.operation_to_perform.lower(), host_name) for x in cmd_list]
            else:
                return "Please provide a valid operation to perform. Choose from 'Start', 'Stop', 'Status'" 
            for cmd_run in cmd_with_host_name:
                print("Command is: {}".format(cmd_run))
                status = cli_run(cmd=cmd_run, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
                print("status: {}".format(status))
                time.sleep(2)
                trace("Command: {} executed successfully".format(cmd_run))
                
            return "OK"
            
        except Exception as e:
            trace("Error in Operation to perform on_all_ceph_daemons: {}".format(e))
            
            
    ###############################################################################################################
    @keyword(name="PCC.Operation to perform on All OSD Daemons Of Node")
    ###############################################################################################################
    
    def operation_to_perform_on_all_osds_daemons_of_node(self, *args, **kwargs):
        banner("PCC.Operation to perform on All OSD Daemons Of Node")
        self._load_kwargs(kwargs)
        print("Kwargs are: {}".format(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        try:
            if "operation_to_perform" not in kwargs:
                self.operation_to_perform = None
            
            cluster_id = easy.get_ceph_cluster_id_by_name(conn,self.name)
            print("Cluster Name: {} Id: {}".format(self.name,cluster_id))  
            response = pcc.get_ceph_clusters_state(conn,str(cluster_id),'osds')
            host_name = easy.get_hostname_by_ip(conn,Hostip=self.hostip)
            osd_ids= [data['osd'] for data in get_response_data(response) if data['server']==host_name]
            
            for osd_id in osd_ids:
                if self.operation_to_perform:
                    cmd =  "sudo systemctl {} ceph-osd@{}".format(self.operation_to_perform.lower(), osd_id)
                    status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
                    print("Status is: {}".format(status))
                    time.sleep(2)
                    trace("Command: {} executed successfully".format(cmd))   
                else:
                    return "Please provide a valid operation to perform. Choose from 'Start', 'Stop', 'Status'" 
            
            return "OK"
                       
        except Exception as e:
            trace("Error in stop_all_osds_daemons_of_node: {}".format(e))

    ###########################################################################
    @keyword(name="PCC.Ceph Reboot Manager And Verify")
    ###########################################################################
    def cephi_mgr_reboot_and_verify(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Reboot Manager And Verify")
        print("Kwargs:"+str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        manager_node_cmd='sudo ceph -s |grep mgr | cut -d "," -f1 | cut -d ":" -f2|cut -d "(" -f1'
        node=self._serialize_response(time.time(),cli_run(self.hostip,self.user,self.password,manager_node_cmd))
        print("Node Info:"+str(node))
        node_name=str(node["Result"]["stdout"]).strip()
        print("Reboot node name:"+str(node_name))
        node_ip=easy.get_hostip_by_name(conn,node_name)
        print("Reboot node ip:"+str(node_ip))
        if type(node_ip) != str:
            print("Unable to fetch host ip of "+str(node))
            return "Error"
        print("Rebooting host "+str(node_ip))
        trace("Rebooting host "+str(node_ip))

        cmd = "sudo reboot"
        restart_cmd = cli_run(node_ip,self.user,self.password,cmd)
        banner("Sleeping")
        time.sleep(180)
        banner("Done sleeping")
        cmd = "ping {} -c 4".format(node_ip)
        restart_up_status = cli_run(node_ip,self.user,self.password, cmd)
        if re.search("0% packet loss", str(restart_up_status)):
            cmd="sudo systemctl status ceph-mgr@{}".format(node_name.split(".")[0])
            cmd_output=cli_run(node_ip,self.user,self.password,cmd)
            if re.search("active", str(cmd_output)):
                return "OK"
            else:
                print(cmd_output)
                return "Error"
        else:
            print("Unable to reboot {}".format(node_ip))
            return "Error"

    ###########################################################################
    @keyword(name="PCC.Ceph Nodes OSDs Architecture Validation")
    ###########################################################################
    def ceph_node_osd_architecture_validation(self, *args, **kwargs):
        banner("PCC.Ceph Nodes OSDs Architecture Validation")
        self._load_kwargs(kwargs)
        if self.name == None:
            return "Please provide Ceph cluster name"
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = self.get_ceph_cluster_id_by_name(conn,self.name)
        response = pcc.get_ceph_clusters_state(conn,id=str(cluster_id),state='osds')
        response_data = get_response_data(response)
        servers = list(set([x['server'] for x in response_data]))
        trace("Servers are:{}".format(servers))
        temp_dict = {}
        for server in servers:
            temp_osd_ids = []
            for data in response_data:
                if data['server']== server:
                    temp_osd_ids.append(data['osd'])
            temp_dict[server] = temp_osd_ids
        architecture_from_pcc = temp_dict
        trace("architecture_from_pcc:{}".format(architecture_from_pcc))
        cmd = 'sudo ceph node ls osd -f json-pretty'
        status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
        print("cmd: {} executed successfully and status is: {}".format(cmd, status))
        serialised_status = self._serialize_response(time.time(), status)
        trace("serialised_status: {}".format(serialised_status))
        cmd_output = str(serialised_status['Result']['stdout']).replace('\n', '').strip()
        architecture_from_backend = json.loads(cmd_output)
        trace("architecture_from_backend:{}".format(architecture_from_backend))
        if architecture_from_pcc == architecture_from_backend:
            return "OK"
        else:
            return "Architecture of Node and OSDs doesn't match -- architecture_from_pcc :{} and architecture_from_backend : {}".format(architecture_from_pcc,architecture_from_backend)


    ###############################################################################################################
    @keyword(name="CLI.Validate CEPH Storage Type")
    ###############################################################################################################
    
    def validate_ceph_storage_type(self, *args, **kwargs):
        banner("CLI.Validate CEPH Storage Type")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            cmd= "sudo grep -ri 'bluestore\|filestore' /var/lib/ceph/osd/"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
            print("cmd: {} executed successfully and status is: {}".format(cmd, status))
            serialised_status = self._serialize_response(time.time(), status)
          
            cmd_output = str(serialised_status['Result']['stdout']).replace('\n', '').strip()
            trace("Command output is:{}".format(cmd_output))
            validation_status =[]
            for storage_type in ast.literal_eval(self.storage_types):
                if re.search(storage_type, cmd_output):
                    validation_status.append("OK")
                else:
                    validation_status.append("Storage type:{} not found on host:{}".format(storage_type,self.hostip))
            trace("validation_status: {}".format(validation_status))
            result = len(validation_status) > 0 and all(elem == "OK" for elem in validation_status) 
            if result:
                return "OK"  
            else:
                return "Validation unsuccessful for CEPH storage type. Validation status is:{}".format(validation_status) 
            
        except Exception as e:
            trace("Error in validate_ceph_storage_type: {}".format(e))

    ###############################################################################################################
    @keyword(name="CLI.Validate CEPH Crush Map From Backend")
    ###############################################################################################################
    
    def validate_ceph_crush_map_from_backend(self, *args, **kwargs):
        banner("CLI.Validate CEPH Crush Map From Backend")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            cmd= "sudo ceph osd tree|awk '/region|zone|datacenter|rack|host/ {print $4}'"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
            print("cmd: {} executed successfully and status is: {}".format(cmd, status))
            serialised_status = self._serialize_response(time.time(), status)
          
            cmd_output = str(serialised_status['Result']['stdout']).replace('\n', '').strip()
            trace("Command output is:{}".format(cmd_output))
            validation_status =[]
            for node_name, location in ast.literal_eval(self.node_location).items():
                if node_name.lower() in cmd_output:
                    validation_status.append("OK")
                else:
                    validation_status.append("{} not present in from_backend".format(node_name))
                for loc in location:
                    if loc.lower() in cmd_output:
                        validation_status.append("OK")
                    else:
                        validation_status.append("{} not present in backend for node:{}".format(loc,node_name))
                        
            trace("validation_status: {}".format(validation_status))
            result = len(validation_status) > 0 and all(elem == "OK" for elem in validation_status) 
            if result:
                return "OK"  
            else:
                return "Validation unsuccessful for CEPH crush map. Validation status is:{}".format(validation_status) 
            
        except Exception as e:
            trace("Error in validate_ceph_crush_map_from_backend: {}".format(e))

    ###########################################################################
    @keyword(name="PCC.Ceph Active Manager And Verify")
    ###########################################################################
    def ceph_active_manager(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Active Manager And Verify")
        print("Kwargs:"+str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            trace("Connection:{}".format(conn))
        except Exception as e:
            raise e
        manager_node_cmd='sudo ceph -s |grep mgr | cut -d "," -f1 | cut -d ":" -f2|cut -d "(" -f1'
        trace("Manager node:{}".format(manager_node_cmd))
        node=self._serialize_response(time.time(),cli_run(self.hostip,self.user,self.password,manager_node_cmd))
        trace("Node Info:"+str(node))
        node_name=str(node["Result"]["stdout"]).strip()
        trace("Active Manager node name:"+str(node_name))
        node_ip=easy.get_hostip_by_name(conn,node_name)
        print("Active manager node ip:"+str(node_ip))
        if type(node_ip) != str:
            print("Unable to fetch host ip of "+str(node))
            return "Error"
        else:
            return node_ip

    ###############################################################################################################
    @keyword(name="PCC.Ceph Get Nodes State")
    ###############################################################################################################
    def get_nodes_state(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Nodes State")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)
        resp = pcc.get_ceph_state_nodes(conn, str(cluster_id))
        status = get_status_code(resp)
        state_nodes = get_response_data(resp)
        if status != 200:
            return "Error"
        nodes = get_response_data(pcc.get_ceph_cluster_by_id(conn, str(cluster_id)))["nodes"]
        trace(nodes)
        for node in nodes:
            name = node["name"]
            roles = node["roles"]
            node_found = False
            for state_node in state_nodes:
                if name == state_node["hostname"]:
                    trace("{} found".format(name))
                    node_found = True
                    for role in roles:
                        service_found = False
                        for service in state_node["services"]:
                            if role[:-1] in service["type"]:
                                trace("Service {} found on host {}".format(role, name))
                                service_found = True
                        if not service_found:
                            trace("Service {} not found on host {}".format(role, name))
                            return "Error"
            if not node_found:
                trace("{} not found".format(name))
                return "Error"
        return "OK"

    ###############################################################################################################
    @keyword(name="PCC.Ceph Get Mons State")
    ###############################################################################################################
    def get_mons_state(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Mons State")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)
        resp = pcc.get_ceph_state_mons(conn, str(cluster_id))
        status = get_status_code(resp)
        state_mons = get_response_data(resp)
        if status != 200:
            return "Error"
        nodes = get_response_data(pcc.get_ceph_cluster_by_id(conn, str(cluster_id)))["nodes"]
        for node in nodes:
            if "mons" in node["roles"]:
                found = False
                for state_mon in state_mons:
                    if node["name"] == state_mon["server"] and node["name"].split(".")[0] == state_mon["name"]:
                        trace("Mon {} found on host {}".format(node["name"].split(".")[0], node["name"]))
                        found = True
                if not found:
                    trace("Mon {} not found on host {}".format(node["name"].split(".")[0], node["name"]))
                    return "Error"
        return "OK"


    ###############################################################################################################
    @keyword(name="PCC.Ceph Get MDS State")
    ###############################################################################################################
    def get_mds_state(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get MDS State")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)
        resp = pcc.get_ceph_state_mds(conn, str(cluster_id))
        status = get_status_code(resp)
        state_mdss = get_response_data(resp)["nodes"]
        trace(state_mdss)
        if status != 200:
            return "Error"
        nodes = get_response_data(pcc.get_ceph_cluster_by_id(conn, str(cluster_id)))["nodes"]
        for node in nodes:
            if "mdss" in node["roles"]:
                trace("checking {}".format(node["name"]))
                found = False
                for state_mds in state_mdss:
                    if node["name"].split(".")[0] == state_mds["name"]:
                        trace("Mds {} found on host {}".format(node["name"].split(".")[0], node["name"]))
                        found = True
                if not found:
                    trace("Mds {} not found on host {}".format(node["name"].split(".")[0], node["name"]))
                    return "Error"
        return "OK"
    
    ###############################################################################################################
    @keyword(name="PCC.Ceph Get Used Drives")
    ###############################################################################################################
    def get_used_drives(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Used drives : {}".format(self.name))
        print("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)
        trace("Cluster Name: {} Id: {}".format(self.name, cluster_id))

        nodes_drives_dict = {}
        if not cluster_id:
            raise Exception("[PCC.Ceph Get Used drives]: cluster id is not specified.")
        else:
            try:
                list_of_used_drives = pcc.get_used_drives_by_cluster_id(conn, str(cluster_id))['Result'][
                    'Data']

                for ids, values in list_of_used_drives.items():
                    drive_names = []
                    for data in values:
                        drive_names.append(data["name"])

                    nodes_drives_dict[ids] = drive_names

                trace(nodes_drives_dict)
                return nodes_drives_dict
            except Exception as e:
                return {"...Error in get_used_drives": str(e)}

    ###############################################################################################################
    @keyword(name="PCC.Ceph Get Used Drives by Hostname")
    ###############################################################################################################
    def get_used_drives_by_hostname(self, server_name=None, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Used drives : {}".format(self.name))
        print("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)
        trace("Cluster Name: {} Id: {}".format(self.name, cluster_id))
        drive_names = []
        list_of_used_drives = pcc.get_used_drives_by_cluster_id(conn, str(cluster_id))['Result']['Data']
        host_id = easy.get_node_id_by_name(conn, server_name)
        trace("host_id: {}".format(host_id))
        for ids, values in list_of_used_drives.items():
            if int(ids) == host_id:
                trace("debug")
                for data in values:
                    drive_names.append(data["id"])
        # break
        trace(drive_names)
        return drive_names

    ###############################################################################################################
    @keyword(name="PCC.Ceph Get Unused drives")
    ###############################################################################################################
    def get_unused_drives(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Unused drives : {}".format(self.name))
        print("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)
        print("Cluster Name: {} Id: {}".format(self.name, str(cluster_id)))

        nodes_drives_dict = {}
        if not cluster_id:
            raise Exception("[PCC.Ceph Get Unused drives]: cluster id is not specified.")
        else:
            try:
                list_of_unused_drives = pcc.get_unused_drives_by_cluster_id(conn, str(cluster_id))['Result'][
                    'Data']
                trace(list_of_unused_drives)
                for ids, values in list_of_unused_drives.items():
                    drive_names = []
                    for data in values:
                        drive_names.append(data["name"])

                    nodes_drives_dict[ids] = drive_names

                print(nodes_drives_dict)
                return nodes_drives_dict
            except Exception as e:
                return {"...Error in test get_unused_drives": str(e)}

    ###############################################################################################################
    @keyword(name="PCC.Ceph Get Unused Drives by Hostname")
    ###############################################################################################################
    def get_unused_drives_by_hostname(self, server_name=None, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Unused drives : {}".format(self.name))
        print("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)
        trace("Cluster Name: {} Id: {}".format(self.name, str(cluster_id)))
        drive_names = []
        list_of_unused_drives = pcc.get_unused_drives_by_cluster_id(conn, str(cluster_id))['Result'][
            'Data']
        trace(list_of_unused_drives)
        host_id = easy.get_node_id_by_name(conn, server_name)
        print("host_id: {}".format(host_id))
        for ids, values in list_of_unused_drives.items():
            if int(ids) == host_id:
                for data in values:
                    drive_names.append(data["id"])
            # break
        print(drive_names)
        return drive_names


    ###############################################################################################################
    @keyword(name="PCC.Ceph Verify Osds State By Hostname")
    ###############################################################################################################
    def ceph_verify_osds_state_by_hostname(self, server_name=None, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Verify Osds State By Hostname")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)
        print("Cluster Name: {} Id: {}".format(self.name, cluster_id))
        osds = pcc.get_osds_by_cluster_id(conn, str(cluster_id))['Result']['Data']
        for osd in osds:
            if osd["server"] == self.server:
                print("osd id {} has state: {}".format(osd["osd"],osd["state"]))
                if self.state_status not in osd["state"]:
                    return "Error"
        return "OK"


    ###############################################################################################################
    @keyword(name="PCC.Ceph get OSD Drives by Hostname")
    ###############################################################################################################
    def get_osd_drives_by_hostname(self, server_name=None, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph get OSD Drives by Hostname : {}".format(self.name))
        print("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)
        print("Cluster Name: {} Id: {}".format(self.name, cluster_id))
        response_data = pcc.get_osds_by_cluster_id(conn, str(cluster_id))['Result'][
            'Data']
        trace(response_data)
        temp_osd_ids = []

        for data in response_data:
            trace(data['server'])
            if data['server'] == server_name:
                temp_osd_ids.append(data['osd'])
                trace(temp_osd_ids)

        print("temp_osd_ids:{}".format(temp_osd_ids))
        return temp_osd_ids

    ###############################################################################################################
    @keyword(name="PCC.Ceph Get OSD IDs By Cluster Name")
    ###############################################################################################################
    def get_osd_ids(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get OSD IDs By Cluster Name : {}".format(self.name))
        print("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)
        print("Cluster Name: {} Id: {}".format(self.name, cluster_id))
        response_data = pcc.get_osds_by_cluster_id(conn, str(cluster_id))['Result'][
            'Data']
        trace(response_data)
        temp_osd_ids = []

        for data in response_data:
            temp_osd_ids.append(data['osd'])
            trace(temp_osd_ids)

        print("temp_osd_ids:{}".format(temp_osd_ids))
        return temp_osd_ids

    ###############################################################################################################
    @keyword(name="PCC.Ceph Reconcile OSDs")
    ###############################################################################################################
    def reconcile_osds(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Reconcile OSDs, cluster : {}".format(self.name))
        print("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)

        payload = {
            "ids": self.osd_ids
        }
        response = pcc.reconcile_osds(conn, str(cluster_id), payload)
        status_code = get_status_code(response)
        if status_code == 200:
            return "OK"
        return "Error"

    ###############################################################################################################
    @keyword(name="PCC.Ceph get OSD drive names by osd id")
    ################################################################################################################
    def get_osd_drivename_by_hostname_osd_id(self, osd_id=None, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph get OSD drive names by osd id : {}".format(self.name))
        print("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)
        print("Cluster Name: {} Id: {}".format(self.name, cluster_id))
        response_data = pcc.get_osds_by_cluster_id(conn, str(cluster_id))['Result'][
            'Data']
        trace(response_data)

        for data in response_data:
            if data['osd'] == osd_id:
                drivename = data['driveName']
                trace(drivename)
                break

        print("drivename:{}".format(drivename))
        return drivename

    ###############################################################################################################
    @keyword(name="PCC.Ceph Delete OSD drives")
    ###############################################################################################################
    def delete_osd_drive(self, osd_id=[], wipe=True, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Delete OSD drives : {}".format(self.name))
        print("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)
        print("Cluster Name: {} Id: {}".format(self.name, cluster_id))
        try:

            payload = {
                "ids": osd_id,
                "wipe": wipe
            }
            print("payload {}".format(payload))
            response = pcc.delete_osd_from_cluster(conn, str(cluster_id), "", payload)
            print("response: {}".format(response))
            code = get_response_data(response)["code"]
            print("code: {}".format(code))
            return pcc.delete_osd_from_cluster(conn, str(cluster_id), "?code=" + code, payload)
        except Exception as e:
            return {"...Error in delete_osd_drive test": str(e)}

    ###############################################################################################################
    @keyword(name="PCC.Ceph Add OSD drives")
    ###############################################################################################################
    def add_osd_drive(self, osd_id=None, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Add OSD drives : {}".format(self.name))
        print("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)
        print("Cluster Name: {} Id: {}".format(self.name, cluster_id))
        trace("osd_id:{}".format(osd_id))
        payload = {
            "driveIDs": [osd_id]
        }
        try:
            print("payload: {}".format(payload))
            response = pcc.add_osd_to_cluster(conn, str(cluster_id), payload)
            print("response: {}".format(response))
            return response
        except Exception as e:
            return {"...Error in add_osd_drive test": str(e)}

    ###############################################################################################################
    @keyword(name="PCC.Ceph Add All OSD drives By NodeID")
    ###############################################################################################################
    def add_all_osd_drives_by_node_id(self, node_id=None, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Add All OSD drives By NodeID..... : {}".format(self.name))
        print("Kwargs:" + str(kwargs))
        trace(node_id)
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)
        print("Cluster Name: {} Id: {}".format(self.name, cluster_id))

        payload = {
            "nodeIDs": [node_id]
        }
        try:
            print("payload: {}".format(payload))
            response = pcc.add_osd_to_cluster(conn, str(cluster_id), payload)
            print("response: {}".format(response))
            return response
        except Exception as e:
            return {"...Error in add_osd_drive test": str(e)}

    ###############################################################################################################
    @keyword(name="PCC.Ceph Wait Until OSD Deleted")
    ###############################################################################################################
    def wait_until_osd_deleted(self, osd_id=None, *args, **kwargs):
        banner("PCC.Ceph Wait Until OSD Deleted")
        self._load_kwargs(kwargs)

        if osd_id is None:
            return {"Error": "osd_id of the cluster is not specified."}

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.name)
        print("Cluster Name: {} Id: {}".format(self.name, cluster_id))
        id_found_in_list_osds = True
        timeout = time.time() + PCCSERVER_TIMEOUT

        while id_found_in_list_osds:
            id_found_in_list_osds = False
            response_data = pcc.get_osds_by_cluster_id(conn, str(cluster_id))['Result'][
                'Data']
            trace(response_data)

            for data in response_data:
                trace(data)
                trace(data['osd'])
                if data['osd'] == osd_id:
                    print("Response:-"+str(data))
                    trace(str(data))
                    if re.search('removing', str(data['state'])):
                        id_found_in_list_osds = True
                        break
            if time.time() > timeout:
                raise Exception("[PCC.Ceph Wait Until OSD Deleted] Timeout")
            if id_found_in_list_osds:
                trace("Waiting until cluster osd : %s is deleted. Timeout in %.1f seconds." %
                       (data['state'], timeout-time.time()))
                time.sleep(5)
        return "OK"

    ###############################################################################################################
    @keyword(name="PCC.Verify OSD Status BE")
    ###############################################################################################################
    def verify_osd_status_be(self, osd_id=None, *args, **kwargs):
        banner("PCC.Verify OSD Status BE")
        self._load_kwargs(kwargs)

        cmd = "sudo systemctl status ceph-osd@{}".format(osd_id)
        cmd_exec = cli_run(self.hostip, self.user, self.password, cmd)
        pattern = "Active: " + self.state
        if re.search(pattern, str(cmd_exec)):
            return "OK"
        return "Error"

    ###############################################################################################################
    @keyword(name="PCC.Verify Crush Map")
    ###############################################################################################################
    def verify_crush_map(self, *args, **kwargs):
        banner("PCC.Verify Crush Map")
        self._load_kwargs(kwargs)

        cmd = "sudo ceph osd tree"
        cmd_exec = cli_run(self.hostip, self.user, self.password, cmd)
        cmd_out = cmd_exec.stdout
        if self.server:
            host = self.server.split(".")[0]
        else:
            host = None

#       host,osds present
        if self.osd_ids:
            if host and (not re.search(host, cmd_out)):
                return "Error"
            for osd_id in self.osd_ids:
                osd = "osd.{} ".format(osd_id)
                if not re.search(osd, cmd_out):
                    return "Error"

#       host,osds not present
        if self.osd_ids_deleted:
            if host and re.search(host, cmd_out):
                return "Error"
            for osd_id in self.osd_ids_deleted:
                osd = "osd.{} ".format(osd_id)
                if re.search(osd, cmd_out):
                    return "Error"
        return "OK"

    ###############################################################################################################
    @keyword(name="PCC.Get CEPH RGW HAPROXY IP")
    ###############################################################################################################
    def get_ceph_rgw_haproxy_ip(self, *args, **kwargs):
        banner("Get CEPH rgw haproxy IP")
        self._load_kwargs(kwargs)
        try:
            cmd = "sudo netstat -ntlp |grep haproxy"
            print("Command is: {}".format(cmd))
            status = cli_run(self.hostip, self.user, self.password, cmd)
            print(status)
            serialised_status = self._serialize_response(time.time(), status)
            print("serialised_haproxy_ip_status is:{}".format(serialised_status))

            cmd_output = str(serialised_status['Result']['stdout']).replace('\n', '').strip()
            print("cli output:", cmd_output)

            control_ip = self.get_ceph_inet_ip(self.hostip,self.user, self.password)
            print("control_ip:", control_ip)
            if re.search(str(control_ip), cmd_output):
                return "OK"
            return "Error"
        except Exception as e:
            trace("Error in get_ceph_rgw_haproxy_ip: {}".format(e))

    ###########################################################################
    @keyword(name="PCC.Verify Node Dismiss")
    ###########################################################################
    def verify_node_dismiss(self, *args, **kwargs):
        banner("PCC.Verify Node Dismiss")
        self._load_kwargs(kwargs)
        server_name = self.services["mon"][0]

        cmd = 'sudo ceph mgr metadata -f json'
        out = cli_run(self.hostip, self.user, self.password, cmd)
        ceph_mgrs_out = json.loads(out.stdout)
        cmd = 'sudo ceph -s -f json'
        out = cli_run(self.hostip, self.user, self.password, cmd)
        ceph_status = json.loads(out.stdout)
        cmd = 'sudo ceph mds metadata'
        out = cli_run(self.hostip, self.user, self.password, cmd)
        ceph_mds_out = json.loads(out.stdout)
        cmd = 'sudo ceph osd tree'
        out = cli_run(self.hostip, self.user, self.password, cmd)
        ceph_osd_tree = out.stdout
        trace(ceph_osd_tree)

        ceph_mons = ceph_status["quorum_names"]

        ceph_mgrs = []
        for mgr in ceph_mgrs_out:
            ceph_mgrs.append(mgr["name"])

        ceph_mds = []
        for mds in ceph_mds_out:
            ceph_mds.append(mds["name"])

        trace(ceph_mgrs)
        trace(ceph_mons)
        trace(ceph_mds)

        error = False
        if "mds" in self.services.keys():
            if server_name in ceph_mds:
                trace("Error: found mds {} service".format(server_name))
                error = True

        if "mgr" in self.services.keys():
            if server_name in ceph_mgrs:
                trace("Error: found mgr {} service".format(server_name))
                error = True

        if "mon" in self.services.keys():
            if server_name in ceph_mons:
                trace("Error: found mon {} service".format(server_name))
                error = True

        if "rgw" in self.services.keys():
            daemon = "{}.rgw0".format(server_name)
            if re.search(daemon, str(ceph_status)):
                trace("Error: found rgw {} service".format(server_name))
                error = True

        if "osd" in self.services.keys():
            if re.search(server_name, ceph_osd_tree):
                trace("Error: found host {} in ceph osd tree".format(server_name))
                error = True
            for osd in self.services["osd"]:
                osd = "{} ".format(osd)
                if re.search(osd, ceph_osd_tree):
                    trace("Error: found {} service".format(osd))
                    error = True

        if error:
            return "Error"
        return "OK"

    ###############################################################################################################
    @keyword(name="PCC.Ceph Add Mon")
    ###############################################################################################################
    def add_mon(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Add Mon")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        payload = {}
        #add mon on specific server, else it is autoselected
        if self.server:
            node_id = easy.get_node_id_by_name(conn, self.server)
            payload["id"] = node_id
        return pcc.add_mon(conn, str(self.id), payload)


    ###############################################################################################################
    @keyword(name="PCC.Verify Mon Addition")
    ###############################################################################################################
    def verify_mon_addition(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Verify Mon Addition")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        response = pcc.get_ceph_clusters_state(conn, str(self.id), "mons")
        mons = get_response_data(response)
        for mon in mons:
            if self.server == mon["server"]:
                return "OK"
        return "Error"

