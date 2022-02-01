import time
import json
import ast
import math
import re

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print, cmp_json
from pcc_qa.common.Result import get_response_data
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60 * 10


class Dashboard(PccBase):
    def __init__(self):
        self.k8s = None
        self.nwtcluster = None
        self.nodes = None
        self.objects = None
        self.cephcluster_name = None
        self.nodeip = None
        self.user = "pcc"
        self.password = "cals0ft"
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Dashboard Verify object graph")
    ###########################################################################
    def verify_object_graph(self, *arg, **kwargs):
        banner("PCC.Dashboard verify object graph")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        response = pcc.get_object_graph(conn)
        print("Response:" + str(response))
        failed_objects = []
        for object in eval(str(self.objects)):
            if object in get_response_data(response):
                continue
            else:
                failed_objects.append(object)
        if failed_objects:
            print("Could not verified following objects " + str(failed_objects))
            return "Error"
        else:
            print("All of {} are verified".format(self.objects))
            return "OK"

    ###########################################################################
    @keyword(name="PCC.Dashboard verify object count")
    ###########################################################################
    def verify_object_count(self, *arg, **kwargs):
        banner("PCC.Dashboard verify object count")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        response = pcc.get_object_graph(conn)
        print("Response:" + str(response))
        failed_objects1 = []
        for object in eval(str(self.objects)):
            if object == "Node":
                response1 = pcc.get_nodes(conn)
                data1 = get_response_data(response1)
                count = len(data1)
                data2 = get_response_data(response)
                count1 = data2["Node"]['countTotal']
                if count == count1:
                    print("Correct Node count : {}".format(count))
                    continue
                else:
                    failed_objects1.append(object)

            elif object == "CephCluster":
                response1 = pcc.get_ceph_clusters(conn)
                data1 = get_response_data(response1)
                count = len(data1)
                data2 = get_response_data(response)
                count1 = data2["CephCluster"]['countTotal']
                if count == count1:
                    print("Correct ceph count : {}".format(count))
                else:
                    failed_objects1.append(object)

            elif object == "NetworkCluster":
                response1 = pcc.get_network_clusters(conn)
                data1 = get_response_data(response1)
                count = len(data1)
                data2 = get_response_data(response)
                count1 = data2["NetworkCluster"]['countTotal']
                if count == count1:
                    print("Correct network count : {}".format(count))
                else:
                    failed_objects1.append(object)

            elif object == "K8sCluster":
                response1 = pcc.get_kubernetes(conn)
                data1 = get_response_data(response1)
                count = len(data1)
                data2 = get_response_data(response)
                count1 = data2["K8sCluster"]['countTotal']
                if count == count1:
                    print("Correct k8s count : {}".format(count))
                else:
                    failed_objects1.append(object)

        if failed_objects1:
            print("Could not verified following objects " + str(failed_objects1))
            return "Count Comparison Failed"
        else:
            print("All of {} are verified".format(self.objects))
            return "OK"

    ###########################################################################
    @keyword(name="PCC.Dashboard Verify object health")
    ###########################################################################
    def verify_object_health(self, *arg, **kwargs):
        banner("PCC.Dashboard verify object health")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        response = pcc.get_object_graph(conn)
        print("Response:" + str(response))
        failed_objects1 = []
        okcount = 0
        warningcount = 0
        errorcount = 0

        for object in eval(str(self.objects)):
            if object == "K8sCluster":
                response1 = pcc.get_kubernetes(conn)
                data1 = get_response_data(response1)
                count = len(data1)
                for x in range(count):
                    data = data1[x]
                    if data["healthStatus"] == "good":
                        okcount += 1
                    elif data["healthStatus"] == "warning":
                        warningcount += 1
                    elif data["healthStatus"] == "notok":
                        errorcount += 1
                    else:
                        print("k8s health count is missing on k8s cluster page")
                data2 = get_response_data(response)
                count1 = data2["K8sCluster"]['countOK']
                count2 = data2["K8sCluster"]["countWarning"]
                count3 = data2["K8sCluster"]["countNotOK"]
                if count1 == okcount:
                    print("Correct k8s OK count : {}".format(okcount))
                elif count2 == warningcount:
                    print("Correct k8s Warning count : {}".format(warningcount))
                elif count3 == errorcount:
                    print("Correct k8s Error count : {}".format(errorcount))
                else:
                    failed_objects1.append(object)

            if object == "Node":
                response1 = pcc.get_nodes(conn)
                data1 = get_response_data(response1)
                count = len(data1)
                for x in range(count):
                    data = data1[x]
                    if data["status"] == "OK":
                        okcount += 1
                    elif data["status"] == "WARNING":
                        warningcount += 1
                    elif data["status"] == "NOTOK":
                        errorcount += 1
                    else:
                        print("Nodes health count is missing on Node summary page")
                data2 = get_response_data(response)
                count1 = data2["Node"]['countOK']
                count2 = data2["Node"]["countWarning"]
                count3 = data2["Node"]["countNotOK"]
                if count1 == okcount:
                    print("Correct node OK count : {}".format(okcount))
                elif count2 == warningcount:
                    print("Correct node Warning count : {}".format(warningcount))
                elif count3 == errorcount:
                    print("Correct node Error count : {}".format(errorcount))
                else:
                    failed_objects1.append(object)

            if object == "CephCluster":
                response1 = pcc.get_ceph_clusters(conn)
                data1 = get_response_data(response1)
                count = len(data1)
                for x in range(count):
                    data = data1[x]
                    if data["status"] == "OK":
                        okcount += 1
                    elif data["status"] == "WARNING":
                        warningcount += 1
                    elif data["status"] == "NOTOK":
                        errorcount += 1
                    else:
                        print("Nodes health count is missing on Node summary page")
                data2 = get_response_data(response)
                count1 = data2["Node"]['countOK']
                count2 = data2["Node"]["countWarning"]
                count3 = data2["Node"]["countNotOK"]
                if count1 == okcount:
                    print("Correct node OK count : {}".format(okcount))
                elif count2 == warningcount:
                    print("Correct node Warning count : {}".format(warningcount))
                elif count3 == errorcount:
                    print("Correct node Error count : {}".format(errorcount))
                else:
                    failed_objects1.append(object)

            if object == "NetworkCluster":
                response1 = pcc.get_network_clusters(conn)
                data1 = get_response_data(response1)
                count = len(data1)
                for x in range(count):
                    data = data1[x]
                    if data["health"] == "OK":
                        okcount += 1
                    elif data["health"] == "WARNING":
                        warningcount += 1
                    elif data["health"] == "NOTOK":
                        errorcount += 1
                    else:
                        print("Network health count is missing on Network cluster page")
                data2 = get_response_data(response)
                count1 = data2["Node"]['countOK']
                count2 = data2["Node"]["countWarning"]
                count3 = data2["Node"]["countNotOK"]
                if count1 == okcount:
                    print("Correct node OK count : {}".format(okcount))
                elif count2 == warningcount:
                    print("Correct node Warning count : {}".format(warningcount))
                elif count3 == errorcount:
                    print("Correct node Error count : {}".format(errorcount))
                else:
                    failed_objects1.append(object)
        if failed_objects1:
            print("Could not verified following objects " + str(failed_objects1))
            return "Health Comparison Failed"
        else:
            print("All of {} are verified".format(self.objects))
            return "OK"

    ###########################################################################
    @keyword(name="PCC.Dashboard Verify object metrics")
    ###########################################################################
    def verify_object_metrics(self, *arg, **kwargs):
        banner("PCC.Dashboard Verify object metrics")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        response = pcc.get_object_metrics(conn)
        print("Response:" + str(response))
        failed_objects = []
        for object in eval(str(self.objects)):
            if object == "Node":
                for data in get_response_data(response):
                    if data["pccObjectType"] == "Node":
                        for item in data["metricsList"]:
                            if item["metricName"] == "cpuLoad":
                                print("Node metric cpu load is correct")
                            elif item["metricName"] == "usedMemory":
                                print("Node metric used memory is correct")
                            else:
                                print("Metrics is not showing for {} node".format(data["pccObjectName"]))
                                failed_objects.append(data["pccObjectType"])

            elif object == "CephCluster":
                for data in get_response_data(response):
                    if data["pccObjectType"] == "CephCluster":
                        for item in data["metricsList"]:
                            if item["metricName"] == "capacityUsed":
                                print("Ceph cluster capacity metric is showing on the Summary page")
                            else:
                                print("Metrics is not showing for {} node".format(data["pccObjectName"]))
                                failed_objects.append(data["pccObjectType"])
            elif object == "K8sCluster":
                for data in get_response_data(response):
                    if data["pccObjectType"] == object:
                        for item in data["metricsList"]:
                            if item["metricName"] == "cpuLoad":
                                print("Node metric cpu load is correct")
                            elif item["metricName"] == "usedMemory":
                                print("Node metric used memory is correct")
                            else:
                                print("Metrics is not showing for {} node".format(data["pccObjectName"]))
                                failed_objects.append(data["pccObjectType"])

            else:
                print("{} object not found".format(object))

            if failed_objects:
                print("Could not verified following objects " + str(failed_objects))
                return "Metric Comparison Failed"
            else:
                print("All of {} are verified".format(self.objects))
                return "OK"

    ###########################################################################
    @keyword(name="PCC.Dashboard Verify object location")
    ###########################################################################
    def verify_object_location(self, *arg, **kwargs):
        banner("PCC.Dashboard Verify object location")
        self._load_kwargs(kwargs)
        trace("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            trace("Connection:{}".format(conn))
        except Exception as e:
            raise e
        dashboard_response = pcc.get_object_metrics(conn)
        trace("Dashboard response: {}".format(dashboard_response))
        nodesummary_response = pcc.get_nodes(conn)
        trace("Node summary response: {}".format(nodesummary_response))
        failed_objects = []
        dashboard_dict = {}
        node_summary_dict = {}

        ### Parsing Dashboard data
        for object in eval(str(self.objects)):
            if object == "Node":
                for data in get_response_data(dashboard_response):
                    if data["pccObjectType"] == object:
                        node_name = data["pccObjectName"]
                        for item in data["scopes"][0]:
                            location_id = item["id"]
                            break
                        dashboard_dict[node_name] = location_id
        trace("Dashboard dictonary:{}".format(dashboard_dict))
        ### Parsing Nodesummary data
        for data in get_response_data(nodesummary_response):
            node_name_from_nodesummary = data['Name']
            scope_id = data['scope']['id']
            node_summary_dict[node_name_from_nodesummary] = scope_id

        trace("Nodesummary dictonary:{}".format(node_summary_dict))
        if dashboard_dict == node_summary_dict:
            return "OK"
        else:
            return "Location Validation failed"

    ###########################################################################
    @keyword(name="PCC.Dashboard Verify Object Health/Kernel/OS Information")
    ###########################################################################
    def verify_object_information(self, *arg, **kwargs):
        banner("PCC.Dashboard Verify Object Health/Kernel/OS Information")
        self._load_kwargs(kwargs)
        print("Kwargs:" + str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        dashboard_response = pcc.get_object_metrics(conn)
        k8s_response = pcc.get_kubernetes(conn)
        ceph_clusters_response = pcc.get_ceph_clusters(conn)
        network_cluster_response = pcc.get_network_clusters(conn)
        node_summary_response = pcc.get_nodes(conn)

        failed_objects = []
        ceph_cluster_dashboard_dict = {}
        ceph_cluster_dict = {}
        k8s_dashboard = {}
        network_dashboard = {}
        network_cluster = {}
        node_dashboard = {}
        node_summary = {}
        k8s_cluster = {}

        for object in eval(str(self.objects)):
            for data in get_response_data(dashboard_response):
                if object == "K8sCluster":
                    if data["pccObjectType"] == object:
                        k8s_dashboard["Name"] = data["pccObjectName"]
                        if data["health"]["description"].lower() == "everything is ok":
                            k8s_dashboard["Health"] = "good"
                        trace("K8s Dashboard:{}".format(k8s_dashboard))
                        for data1 in get_response_data(k8s_response):
                            if data1["name"] == k8s_dashboard["Name"]:
                                k8s_cluster["Name"] = data1["name"]
                                k8s_cluster["Health"] = data1["healthStatus"]

                        trace("K8s cluster:{}".format(k8s_cluster))    
                        if k8s_cluster == k8s_dashboard:
                            print("Correct K8s information")
                        else:
                            failed_objects.append(k8s_dashboard["Name"])

                if object == "CephCluster":
                    if data["pccObjectType"] == object:
                        ceph_cluster_dashboard_dict["Name"] = data["pccObjectName"]
                        ceph_cluster_dashboard_dict["Health"] = set()
                        for item in data["pccObjectDetails"]:
                            if item["topic"] == "Health":
                                for data in item["message"]:
                                    ceph_cluster_dashboard_dict["Health"].add(''.join(e for e in data["message"] if e.isalnum()))
                            elif item["topic"] == "Capacity Usage":
                                for data in item["message"]:
                                    capacity_value = str(round(eval(data["message"].split(" ")[3]))) + " " +data["message"].split(" ")[4]
                                    ceph_cluster_dashboard_dict["Total Capacity"] = capacity_value
                            elif item["topic"] == "Version":
                                for data in item["message"]:
                                    message = data["message"].split(" ")
                                    ceph_cluster_dashboard_dict["Version"] = message[0]+" " +message[1]

                        trace("Ceph Cluster dashboard:{}".format(ceph_cluster_dashboard_dict))

                        for ceph in get_response_data(ceph_clusters_response):
                            if ceph["name"] == ceph_cluster_dashboard_dict["Name"]:
                                ceph_cluster_dict["Name"] = ceph["name"]
                                ceph_id = easy.get_ceph_cluster_id_by_name(conn, ceph["name"])
                                ceph_response = pcc.get_ceph_cluster_health_by_id(conn, str(ceph_id))
    
                                ceph_health_response = get_response_data(ceph_response)
                                
                                ceph_cluster_description = ceph_health_response["summary"].split(";")
                                trace("Ceph health description:{}".format(ceph_cluster_description))
                                if ceph_cluster_description == []:
                                    ceph_cluster_dict["Health"]="Everythingisgood"
                                else:
                                    ceph_cluster_dict["Health"] = set(["".join(e for e in c if e.isalnum()) for c in ceph_cluster_description]) 
                                cmd1 = 'sudo ceph --version'
                                cmd2 = 'sudo ceph -s | grep usage | cut -d "/" -f2 | cut -d "a" -f1'
                                cmd_execution1 = cli_run(self.nodeip, self.user, self.password, cmd1)
                                trace("command execution:{}".format(cmd_execution1))
                                cmd_execution_2 = cli_run(self.nodeip, self.user, self.password, cmd2)
                                serialise_output_1 = self._serialize_response(time.time(), cmd_execution1)['Result']['stdout'].split()
                                trace("serialise output:{}".format(serialise_output_1))
                                ceph_cluster_dict["Version"] = serialise_output_1[2]+" "+serialise_output_1[4]
                                serialise_output_2 = self._serialize_response(time.time(), cmd_execution_2)['Result']['stdout']
                                ceph_cluster_dict["Total Capacity"] = serialise_output_2.strip()

                        trace("Ceph cluster:{}".format(ceph_cluster_dict))    
                        if ceph_cluster_dashboard_dict == ceph_cluster_dict:
                            print("Ceph cluster related information is correct")
                        else:
                            failed_objects.append(ceph_cluster_dashboard_dict["Name"])
                elif object == "NetworkCluster":
                    if data["pccObjectType"] == object:
                        network_dashboard["Name"] = data["pccObjectName"]
                        network_dashboard["Health"] = data["health"]["health"]
                        print("network Dashboard : {}".format(network_dashboard))
                        for network in get_response_data(network_cluster_response):
                            if network["name"] == network_dashboard["Name"]:
                                network_cluster["Name"] = network["name"]
                                network_cluster["Health"] = network["health"]
    
                        print("Network Cluster : {}".format(network_cluster))
                        if network_dashboard == network_cluster:
                            print("Network cluster related information is correct")
                        else:
                            failed_objects.append(network_dashboard["Name"])

                elif object == "Node":
                    if data["pccObjectType"] == object:
                        node_dashboard["Name"] = data["pccObjectName"]
                        for item in data["pccObjectDetails"]:
                            if item["topic"] == "Kernel":
                                node_dashboard["Kernel"] = item["message"].lower()
                            elif item["topic"] == "OS":
                                node_dashboard["OS"] = item["message"].lower()
                        trace("Node Dashboard: {}".format(node_dashboard))
                        for data in get_response_data(node_summary_response):
                            if data["Name"] == node_dashboard["Name"]:
                                if "Id" in data:
                                    id = data["Id"]
                                elif "nodeId" in data:
                                    id = data["nodeId"]
    
                                get_node_response = get_response_data(pcc.get_node_by_id(conn, str(id)))
                                node_summary["Name"] = data["Name"]
    
                                node_summary["Kernel"] = str(get_node_response["systemData"]["kernel"].lower()).strip()
    
                                node_summary["OS"] = str(
                                    get_node_response["systemData"]["osName"].lower()).strip() + " " + str(
                                    get_node_response["systemData"]["baseIso"].lower()).strip()
    
                            trace("Node summary: {}".format(node_summary))

                        if node_summary == node_dashboard:
                            print("Node related information is correct")
                        else:
                            failed_objects.append(node_dashboard["Name"])

        if failed_objects:
            trace("Following objects are failed : {}".format(failed_objects))
            return "Comparison failed"
        else:
            return "OK"
    ###########################################################################
    @keyword(name="PCC.Dashboard Storage Page Validation")
    ###########################################################################
    def storage_page_validation(self, *arg, **kwargs):
        banner("PCC.Dashboard Storage Page Validation")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        node_summary_response = pcc.get_nodes(conn)
        cmd = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "Total_Capacity"'
        cmd_2 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "name"'
        cmd_3 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "ioTime"'
        cmd_4 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "iopsInProgress"'
        cmd_5 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "readBytes"'
        cmd_6 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "readTime"'
        cmd_7 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "readCount"'
        cmd_8 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "writeBytes"'
        cmd_9 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "writeCount"'
        cmd_10 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "writeTime"'
        cmd_11 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "weightedIO"'
        trace("Command:{}".format(str(cmd)))
        failed_object=[]
        for data in get_response_data(node_summary_response):
            host_ip = data["Host"]
            trace(host_ip)
            cmd_execution = cli_run(str(host_ip), self.user, self.password, cmd)
            cmd_execution_2 = cli_run(str(host_ip), self.user, self.password, cmd_2)
            cmd_execution_3 = cli_run(str(host_ip), self.user, self.password, cmd_3)
            cmd_execution_4 = cli_run(str(host_ip), self.user, self.password, cmd_4)
            cmd_execution_5 = cli_run(str(host_ip), self.user, self.password, cmd_5)
            cmd_execution_6 = cli_run(str(host_ip), self.user, self.password, cmd_6)
            cmd_execution_7 = cli_run(str(host_ip), self.user, self.password, cmd_7)
            cmd_execution_8 = cli_run(str(host_ip), self.user, self.password, cmd_8)
            cmd_execution_9 = cli_run(str(host_ip), self.user, self.password, cmd_9)
            cmd_execution_10 = cli_run(str(host_ip), self.user, self.password, cmd_10)
            cmd_execution_11 = cli_run(str(host_ip), self.user, self.password, cmd_11)

            serialise_output_1 = self._serialize_response(time.time(), cmd_execution)['Result']['stdout']
            serialise_output_2 = self._serialize_response(time.time(), cmd_execution_2)['Result']['stdout']
            serialise_output_3 = self._serialize_response(time.time(), cmd_execution_3)['Result']['stdout']
            serialise_output_4 = self._serialize_response(time.time(), cmd_execution_4)['Result']['stdout']
            serialise_output_5 = self._serialize_response(time.time(), cmd_execution_5)['Result']['stdout']
            serialise_output_6 = self._serialize_response(time.time(), cmd_execution_6)['Result']['stdout']
            serialise_output_7 = self._serialize_response(time.time(), cmd_execution_7)['Result']['stdout']
            serialise_output_8 = self._serialize_response(time.time(), cmd_execution_8)['Result']['stdout']
            serialise_output_9 = self._serialize_response(time.time(), cmd_execution_9)['Result']['stdout']
            serialise_output_10 = self._serialize_response(time.time(), cmd_execution_10)['Result']['stdout']
            serialise_output_11 = self._serialize_response(time.time(), cmd_execution_11)['Result']['stdout']

            trace(serialise_output_1)
            trace(serialise_output_2)
            trace(serialise_output_3)
            trace(serialise_output_4)
            trace(serialise_output_5)
            trace(serialise_output_6)
            trace(serialise_output_7)
            trace(serialise_output_8)
            trace(serialise_output_9)
            trace(serialise_output_10)
            trace(serialise_output_11)

            if re.search("fail",str(serialise_output_1),re.IGNORECASE):
                print("Total capacity validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Total Capacity validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_2),re.IGNORECASE):
                print("Drive name validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Drive name validation pass for {}".format(host_ip))
            
            if re.search("fail",str(serialise_output_3),re.IGNORECASE):
                print("IO Time validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("IO time validation pass for {}".format(host_ip))
           
            if re.search("fail",str(serialise_output_4),re.IGNORECASE):
                print("IOPs in progress validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("IOPs in progress validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_5),re.IGNORECASE):
                print("Read validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Read validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_6),re.IGNORECASE):
                print("Read Time validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Read Time validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_7),re.IGNORECASE):
                print("Read Count validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Read Count validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_8),re.IGNORECASE):
                print("Write validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Write validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_9),re.IGNORECASE):
                print("Write count validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Write Count validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_10),re.IGNORECASE):
                print("Write time validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Write time validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_11),re.IGNORECASE):
                print("Weighted IO validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Weighted IO time validation pass for {}".format(host_ip))

        if failed_object:
            return "Physical-->storage page validation failed"
        else:
            return "OK"
    ###########################################################################
    @keyword(name="PCC.Dashboard Filesystem Page Validation")
    ###########################################################################
    def filesystem_page_validation(self, *arg, **kwargs):
        banner("PCC.Dashboard Filesystem Page Validation")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        node_summary_response = pcc.get_nodes(conn)
        cmd = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "device"'
        cmd_2 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "fstype"'
        cmd_3 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "mountpoint"'
        cmd_4 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "total"'
        cmd_5 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "used"'
        cmd_6 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "free"'
        cmd_7 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "usedPercent"'
        cmd_8 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "inodesTotal"'
        cmd_9 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "inodesFree"'
        cmd_10 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "inodesUsed"'
        cmd_11 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "inodesUsedPercent"'
        cmd_12 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "mountoptions"'
        trace("Command:{}".format(str(cmd)))
        failed_object = []
        for data in get_response_data(node_summary_response):
            host_ip = data["Host"]
            trace(host_ip)
            cmd_execution = cli_run(str(host_ip), self.user, self.password, cmd)
            cmd_execution_2 = cli_run(str(host_ip), self.user, self.password, cmd_2)
            cmd_execution_3 = cli_run(str(host_ip), self.user, self.password, cmd_3)
            cmd_execution_4 = cli_run(str(host_ip), self.user, self.password, cmd_4)
            cmd_execution_5 = cli_run(str(host_ip), self.user, self.password, cmd_5)
            cmd_execution_6 = cli_run(str(host_ip), self.user, self.password, cmd_6)
            cmd_execution_7 = cli_run(str(host_ip), self.user, self.password, cmd_7)
            cmd_execution_8 = cli_run(str(host_ip), self.user, self.password, cmd_8)
            cmd_execution_9 = cli_run(str(host_ip), self.user, self.password, cmd_9)
            cmd_execution_10 = cli_run(str(host_ip), self.user, self.password, cmd_10)
            cmd_execution_11 = cli_run(str(host_ip), self.user, self.password, cmd_11)
            cmd_execution_12 = cli_run(str(host_ip), self.user, self.password, cmd_12)

            serialise_output_1 = self._serialize_response(time.time(), cmd_execution)['Result']['stdout']
            serialise_output_2 = self._serialize_response(time.time(), cmd_execution_2)['Result']['stdout']
            serialise_output_3 = self._serialize_response(time.time(), cmd_execution_3)['Result']['stdout']
            serialise_output_4 = self._serialize_response(time.time(), cmd_execution_4)['Result']['stdout']
            serialise_output_5 = self._serialize_response(time.time(), cmd_execution_5)['Result']['stdout']
            serialise_output_6 = self._serialize_response(time.time(), cmd_execution_6)['Result']['stdout']
            serialise_output_7 = self._serialize_response(time.time(), cmd_execution_7)['Result']['stdout']
            serialise_output_8 = self._serialize_response(time.time(), cmd_execution_8)['Result']['stdout']
            serialise_output_9 = self._serialize_response(time.time(), cmd_execution_9)['Result']['stdout']
            serialise_output_10 = self._serialize_response(time.time(), cmd_execution_10)['Result']['stdout']
            serialise_output_11 = self._serialize_response(time.time(), cmd_execution_11)['Result']['stdout']
            serialise_output_12 = self._serialize_response(time.time(), cmd_execution_12)['Result']['stdout']

            trace(serialise_output_1)
            trace(serialise_output_2)
            trace(serialise_output_3)
            trace(serialise_output_4)
            trace(serialise_output_5)
            trace(serialise_output_6)
            trace(serialise_output_7)
            trace(serialise_output_8)
            trace(serialise_output_9)
            trace(serialise_output_10)
            trace(serialise_output_11)
            trace(serialise_output_12)

            if re.search("fail",str(serialise_output_1),re.IGNORECASE):
                print("Device validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Device validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_2),re.IGNORECASE):
                print("FS type validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("FS type validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_3),re.IGNORECASE):
                print("Mount point validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Mount point validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_4),re.IGNORECASE):
                print("Total validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Total validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_5),re.IGNORECASE):
                print("Used validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Used validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_6),re.IGNORECASE):
                print("Free validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Free validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_7),re.IGNORECASE):
                print("Used percent validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Used percent validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_8),re.IGNORECASE):
                print("Inode total failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Inode total pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_9),re.IGNORECASE):
                print("Inode free validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Inode free validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_10),re.IGNORECASE):
                print("Inode used validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Inode used validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_11),re.IGNORECASE):
                print("Inode used percent validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Inode used percent validation pass for {}".format(host_ip))

            if re.search("fail",str(serialise_output_12),re.IGNORECASE):
                print("Mount option validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Mount option validation pass for {}".format(host_ip))

        if failed_object:
            return "Physical-->Filesystem page validation failed"
        else:
            return "OK"
    ###########################################################################
    @keyword(name="PCC.Dashboard Monitor Page Storage Controller Validation")
    ###########################################################################
    def monitor_page_storage_controller_validation(self, *arg, **kwargs):
        banner("PCC.Dashboard Monitor Page Storage Controller Validation")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        node_summary_response = pcc.get_nodes(conn)
        cmd = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "controller"'
        cmd_2 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "model"'
        cmd_3 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "revision"'
        cmd_4 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "businfo"'
        cmd_5 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "subsystem"'
        cmd_6 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "driver"'
        cmd_7 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep -w "Type"'

        # Online and vendor both are invalidate
        # cmd_8 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "Online"'
        # cmd_9 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "vendor"'

        trace("Command:{}".format(str(cmd)))
        failed_object = []
        for data in get_response_data(node_summary_response):
            host_ip = data["Host"]
            trace(host_ip)
            cmd_execution = cli_run(str(host_ip), self.user, self.password, cmd)
            cmd_execution_2 = cli_run(str(host_ip), self.user, self.password, cmd_2)
            cmd_execution_3 = cli_run(str(host_ip), self.user, self.password, cmd_3)
            cmd_execution_4 = cli_run(str(host_ip), self.user, self.password, cmd_4)
            cmd_execution_5 = cli_run(str(host_ip), self.user, self.password, cmd_5)
            cmd_execution_6 = cli_run(str(host_ip), self.user, self.password, cmd_6)
            cmd_execution_7 = cli_run(str(host_ip), self.user, self.password, cmd_7)

            serialise_output_1 = self._serialize_response(time.time(), cmd_execution)['Result']['stdout']
            serialise_output_2 = self._serialize_response(time.time(), cmd_execution_2)['Result']['stdout']
            serialise_output_3 = self._serialize_response(time.time(), cmd_execution_3)['Result']['stdout']
            serialise_output_4 = self._serialize_response(time.time(), cmd_execution_4)['Result']['stdout']
            serialise_output_5 = self._serialize_response(time.time(), cmd_execution_5)['Result']['stdout']
            serialise_output_6 = self._serialize_response(time.time(), cmd_execution_6)['Result']['stdout']
            serialise_output_7 = self._serialize_response(time.time(), cmd_execution_7)['Result']['stdout']

            trace(serialise_output_1)
            trace(serialise_output_2)
            trace(serialise_output_3)
            trace(serialise_output_4)
            trace(serialise_output_5)
            trace(serialise_output_6)
            trace(serialise_output_7)

            if re.search("fail", str(serialise_output_1), re.IGNORECASE):
                print("Storage controller name validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Storage controller name validation pass for {}".format(host_ip))

            if re.search("fail", str(serialise_output_2), re.IGNORECASE):
                print("Storage Model name  validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Storage Model name  validation pass for {}".format(host_ip))

            if re.search("fail", str(serialise_output_3), re.IGNORECASE):
                print("Revision validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Revision validation pass for {}".format(host_ip))

            if re.search("fail", str(serialise_output_4), re.IGNORECASE):
                print("Bus info validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Bus info validation pass for {}".format(host_ip))

            if re.search("fail", str(serialise_output_5), re.IGNORECASE):
                print("Subsystem validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Subsystem validation pass for {}".format(host_ip))

            if re.search("fail", str(serialise_output_6), re.IGNORECASE):
                print("Driver validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Driver validation pass for {}".format(host_ip))

            if re.search("fail", str(serialise_output_7), re.IGNORECASE):
                print("Type validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Type validation pass for {}".format(host_ip))

        if failed_object:
            print("Following nodes are failed:{}".format(failed_object))
            return "Monitor Page Storage Controller Validation failed"
        else:
            return "OK"

    ###########################################################################
    @keyword(name="PCC.Dashboard Monitor Page Partitions Validation")
    ###########################################################################
    def monitor_page_partition_validation(self, *arg, **kwargs):
        banner("PCC.Dashboard Monitor Page partition Validation")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        node_summary_response = pcc.get_nodes(conn)
        cmd = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep -w "name"'
        cmd_2 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "size"'
        trace("Command:{}".format(str(cmd)))
        failed_object = []
        for data in get_response_data(node_summary_response):
            host_ip = data["Host"]
            trace(host_ip)
            cmd_execution = cli_run(str(host_ip), self.user, self.password, cmd)
            cmd_execution_2 = cli_run(str(host_ip), self.user, self.password, cmd_2)

            serialise_output_1 = self._serialize_response(time.time(), cmd_execution)['Result']['stdout']
            serialise_output_2 = self._serialize_response(time.time(), cmd_execution_2)['Result']['stdout']

            trace(serialise_output_1)
            trace(serialise_output_2)

            if re.search("fail", str(serialise_output_1), re.IGNORECASE):
                print("Partition name validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Partition name validation pass for {}".format(host_ip))

            if re.search("fail", str(serialise_output_2), re.IGNORECASE):
                print("Partition size  validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Partition size validation pass for {}".format(host_ip))

        if failed_object:
            print("Following nodes are failed: {}".format(failed_object))
            return "Monitor page partition validation failed"
        else:
            return "OK"

    ###########################################################################
    @keyword(name="PCC.Dashboard Monitor Page Filesystem Validation")
    ###########################################################################
    def monitor_page_filesystem_validation(self, *arg, **kwargs):
        banner("PCC.Dashboard Monitor Page Filesystem Validation")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        node_summary_response = pcc.get_nodes(conn)
        cmd = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "total"'
        cmd_2 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "mountpoint"'
        cmd_3 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "fstype"'
        cmd_4 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "free"'
        cmd_5 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "avail"'
        cmd_6 = 'sudo /opt/platina/pcc/bin/systemCollector test storage validate | grep "device"'

        trace("Command:{}".format(str(cmd)))
        failed_object = []
        for data in get_response_data(node_summary_response):
            host_ip = data["Host"]
            trace(host_ip)
            cmd_execution = cli_run(str(host_ip), self.user, self.password, cmd)
            cmd_execution_2 = cli_run(str(host_ip), self.user, self.password, cmd_2)
            cmd_execution_3 = cli_run(str(host_ip), self.user, self.password, cmd_3)
            cmd_execution_4 = cli_run(str(host_ip), self.user, self.password, cmd_4)
            cmd_execution_5 = cli_run(str(host_ip), self.user, self.password, cmd_5)
            cmd_execution_6 = cli_run(str(host_ip), self.user, self.password, cmd_6)

            serialise_output_1 = self._serialize_response(time.time(), cmd_execution)['Result']['stdout']
            serialise_output_2 = self._serialize_response(time.time(), cmd_execution_2)['Result']['stdout']
            serialise_output_3 = self._serialize_response(time.time(), cmd_execution_3)['Result']['stdout']
            serialise_output_4 = self._serialize_response(time.time(), cmd_execution_4)['Result']['stdout']
            serialise_output_5 = self._serialize_response(time.time(), cmd_execution_5)['Result']['stdout']
            serialise_output_6 = self._serialize_response(time.time(), cmd_execution_6)['Result']['stdout']

            trace(serialise_output_1)
            trace(serialise_output_2)
            trace(serialise_output_3)
            trace(serialise_output_4)
            trace(serialise_output_5)
            trace(serialise_output_6)

            if re.search("fail", str(serialise_output_1), re.IGNORECASE):
                print("Filesystem capacity validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Filesystem capacity validation pass for {}".format(host_ip))

            if re.search("fail", str(serialise_output_2), re.IGNORECASE):
                print("Filesystem mount point validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Filesystem mount point validation pass for {}".format(host_ip))

            if re.search("fail", str(serialise_output_3), re.IGNORECASE):
                print("Filesystem type validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Filesystem type validation pass for {}".format(host_ip))

            if re.search("fail", str(serialise_output_4), re.IGNORECASE):
                print(" Filesystem free memory validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Filesystem free memory validation pass for {}".format(host_ip))

            if re.search("fail", str(serialise_output_5), re.IGNORECASE):
                print("Filesystem available memory validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Filesystem available memory validation pass for {}".format(host_ip))

            if re.search("fail", str(serialise_output_6), re.IGNORECASE):
                print("Filesystem device label validation failed for {}".format(host_ip))
                failed_object.append(host_ip)
            else:
                print("Filesystem device label validation pass for {}".format(host_ip))

        if failed_object:
            print("Following nodes are failed:{}".format(failed_object))
            return "Monitor Page filesystem Validation failed"
        else:
            return "OK"
