import re
import time
import ast
from robot.api.deco import keyword
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run

PCC_TIMEOUT = 60*5  # 5 min

class Nodes(PccBase):
    """ 
    Nodes
    """
    def __init__(self):
        self.Id = None
        self.ClusterId = 0
        self.Host = None
        self.Model = None
        self.Name = None
        self.Names = []
        self.SN = None
        self.Site_Id = 0
        self.Type_Id = 0
        self.adminUser = None
        self.bmc = None
        self.bmcPassword = None
        self.bmcUser = None
        self.bmcUsers = []
        self.bmcKey = None
        self.console = None
        self.interfaces = []
        self.managed = True
        self.owner = 0
        self.roles = []
        self.sshKeys = []
        self.standby = False
        self.tags = []
        self.tenants = []
        self.Vendor = None
        self.Iso_Id = 0
        self.Kernel_Id = 0
        self.hardwareInventoryId = 0
        self.hwAddr = None
        self.provisionStatus = None
        self.ready = True
        self.reimage = True
        self.status = None
        self.payload = None
        self.tenant = None
        self.tenant_id = None
        self.ids = None
        self.IP = None
        self.host_ips = []
        self.user= "pcc"
        self.password= "cals0ft"
        self.scopeId = None
        
        self.interface_name = []
        self.interface_id = []
        self.interface_mac = []
        self.interface_carrierStatus = []
        self.interface_managedByPcc = []
        self.interface_managedByPccDesired = []
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Add Node")
    ###########################################################################
    def add_node(self, *args, **kwargs):
        """
        Add Node to PCC
        [Args]
            (str) Name: Name of the Node
            ...
        [Returns]
            (dict) Response: Add Node response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add Node [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        if "roles" in kwargs:
            self.roles = ast.literal_eval(self.roles)
        payload = {
            "Name": self.Name,
            "ClusterId": self.ClusterId,
            "Host": self.Host,  
            "Model": self.Model,
            "SN": self.SN,
            "Site_Id": self.Site_Id,
            "Vendor": self.Vendor,
            "adminUser": self.adminUser,
            "bmc": self.bmc,
            "bmcKey": self.bmcKey,
            "bmcPassword": self.bmcPassword,
            "bmcUser": self.bmcUser,
            "bmcUsers": self.bmcUsers,
            "console": self.console,
            "hardwareInventoryId": self.hardwareInventoryId,
            "hwAddr": self.hwAddr,
            "managed": self.managed,
            "owner": self.owner,
            "provisionStatus": self.provisionStatus,
            "ready": self.ready,
            "reimage": self.reimage,
            "roles": self.roles,
            "sshKeys": self.sshKeys,
            "standby": self.standby,
            "status": self.status,
            "tags": self.tags,
            "tenants": self.tenants,
            "scopeId":self.scopeId
        }
        print("Payload is : {}".format(payload))
        return pcc.add_node(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Get Nodes")
    ###########################################################################
    def get_nodes(self, *args, **kwargs):
        """
        Get Nodes
        [Args]
            None
        [Returns]
            (dict) Response: Get Node response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Nodes ")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_nodes(conn)

    ###########################################################################
    @keyword(name="PCC.Get Node")
    ###########################################################################
    def get_node(self, *args, **kwargs):
        """
        Get Node
        [Args]
            (str) Id
        [Returns]
            (dict) Response: Get Node response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Node")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_node_by_id(conn, self.Id)

    ###########################################################################
    @keyword(name="PCC.Get Node Id")
    ###########################################################################
    def get_node_id(self, *args, **kwargs):
        """
        Get Node Id
        [Args]
            (str) Name
        [Returns]
            (dict) Response: Get Node response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Node Id")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_node_id_by_name(conn, self.Name)

    ###########################################################################
    @keyword(name="PCC.Assign Tenant to Node")
    ###########################################################################
    def assign_tenant_to_node(self, *args, **kwargs):
        """
        Assigning Tenant to Node
        [Args]
            (int) tenant_id, ids = node_id
        [Returns]
            (dict) Response: Get Node response after Tenant is assigned (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Assign Tenant to Node")
        node_payload = {"tenant" : self.tenant_id,
                   "ids" : [self.ids]
                  }
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        response = pcc.update_tenant_to_node(conn, data=node_payload)
        return self.get_nodes(conn)

    ###########################################################################
    @keyword(name="PCC.Delete Node")
    ###########################################################################
    def delete_node(self, *args, **kwargs):
        """
        Delete Node
        [Args]
            (str) Id
        [Returns]
            (dict) Response: Delete Node response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Delete Node")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.delete_node_by_id(conn, str(self.Id))
    
    ###########################################################################
    @keyword(name="PCC.Wait Until Node Deleted")
    ###########################################################################
    def wait_until_node_deleted(self, *args, **kwargs):
        """
        Wait Until Node Deleted
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Node 
        [Returns]
            (dict) Wait time 
            (dict) Error response: If Exception occured
        """
        self._load_kwargs(kwargs)
        banner("PCC.Wait Until Node Deleted")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        found = True
        time_waited = 0
        timeout = time.time() + PCC_TIMEOUT
        try:
            while found:
                node_list = pcc.get_nodes(conn)['Result']['Data']
                if node_list ==None:
                    return "OK"
                if re.search(self.Name,str(node_list)):
                    trace("Node:{} not yet deleted".format(self.Name))
                    time.sleep(3)
                    if time.time()>timeout:
                        return {"Error": "Timeout"}
                else:
                    return "OK"
        except Exception as e:
            return "Exception encountered: {}".format(e)
        
    ###########################################################################
    @keyword(name="PCC.Wait Until Node Ready")
    ###########################################################################    
    def wait_until_node_ready(self, *args, **kwargs):
        """
        Wait Until Node Ready
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Node 
        [Returns]
            (dict) Wait Time 
            (dict) Error response: If Exception occured
        """
        self._load_kwargs(kwargs)
        banner("PCC.Wait Until Node Ready")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        ready = False
        time.sleep(10)
        time_waited = 0
        PCC_TIMEOUT = 60*10 #10 minutes
        timeout = time.time() + PCC_TIMEOUT
        while not ready:
            ready = False
            node_list = pcc.get_nodes(conn)['Result']['Data']
            for node in node_list:
                if str(node['Name']) == str(self.Name):
                    if node['provisionStatus'] == 'Ready':
                        trace("Node:{} is ready".format(self.Name))
                        return "OK"
                    if "fail" in node['provisionStatus']:
                        return "Wait until node ready status - Failed. Node Status is {}".format(node['provisionStatus'])
            if time.time() > timeout:
                return {"Error": "Timeout"}
            if not ready:
                trace("Node:{} is not yet ready".format(self.Name))
                time.sleep(5)
                time_waited += 5
        
        
    ###########################################################################
    @keyword(name="PCC.Check node exists")
    ###########################################################################
    def check_node_exists(self, *args, **kwargs):
        """
        Check if node already exists and provision status is Ready
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) IP: IP of the Node
        [Returns]
            (bool) True: if IP matches the node host in the list of nodes
                else False: if doesnot exists
            (dict) Error response: If Exception occured
        """
        self._load_kwargs(kwargs)
        banner("PCC.Check node exists")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        node_list = pcc.get_nodes(conn)['Result']['Data']
        print("node_list_status: {}".format(node_list))
        try:
            if node_list == None:
                return False
            for node in node_list:
                print("Node in check node exists: {}".format(node))
                if (str(node['Host']) == str(self.IP)) and (str(node['provisionStatus']) == 'Ready'):
                    return True
            return False
        except Exception as e:
            print("In exception of check node exists"+ str(e))
            return {"Error": str(e)}

    ###########################################################################
    @keyword(name="PCC.Update Node")
    ###########################################################################
    def update_node(self, *args, **kwargs):
        """
        Update Node 
        [Args]
            (str) Name: Name of the Node
            ...
        [Returns]
            (dict) Response: Update Node response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Update Node [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        print("Kwargs are: {}".format(kwargs))
        if "roles" in kwargs:
            self.roles = ast.literal_eval(self.roles)
        payload = {
            "Id": self.Id,
            "Name": self.Name,
            "ClusterId": self.ClusterId,
            "Host": self.Host,  
            "Model": self.Model,
            "SN": self.SN,
            "Site_Id": self.Site_Id,
            "Vendor": self.Vendor,
            "adminUser": self.adminUser,
            "bmc": self.bmc,
            "bmcKey": self.bmcKey,
            "bmcPassword": self.bmcPassword,
            "bmcUser": self.bmcUser,
            "bmcUsers": self.bmcUsers,
            "console": self.console,
            "hardwareInventoryId": self.hardwareInventoryId,
            "hwAddr": self.hwAddr,
            "managed": self.managed,
            "owner": self.owner,
            "provisionStatus": self.provisionStatus,
            "ready": self.ready,
            "reimage": self.reimage,
            "roles": self.roles,
            "sshKeys": self.sshKeys,
            "standby": self.standby,
            "status": self.status,
            "tags": self.tags,
            "tenants": self.tenants,
            "scopeId":self.scopeId,
            "interfaces": self.interfaces
        }
        print("Payload in update node is :{}".format(payload))
        return pcc.modify_node(conn, payload)
    
    ###############################################################################################################
    @keyword(name="PCC.Add mutliple nodes and check online")
    ###############################################################################################################   
    
    def add_multiple_nodes_and_check_online(self, *args, **kwargs):
        """
        Adds multiple nodes and checks online status 
        [Args]
            (list) Names: List of Names of the Nodes to be added
            (list) host_ips: List of Host of the Nodes to be added
            ...
        [Returns]
            (str) OK: Returns "OK" if all nodes are added successfully and are online
            else: returns "Error"
        """
        
        banner("Add mutliple nodes and check online")
        self._load_kwargs(kwargs)
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            wait_for_node_addition_status = []
            node_not_exists=[]
            print("Kwargs are: {}".format(kwargs))
            for hostip in ast.literal_eval(self.host_ips):
                print("Host ip: {}".format(hostip))
                exists = self.check_node_exists(IP=hostip)
                print("exists status: {}".format(exists))
                if exists == False:
                    node_not_exists.append(hostip)
            print("node_not_exists:{}".format(node_not_exists))    
            for node_hostip in node_not_exists:
                trace("adding node: {}".format(node_hostip))
                add_node_status = self.add_node(Host=node_hostip, managed= self.managed, standby = self.standby)
                
            for name in ast.literal_eval(self.Names):
                verify_node_online_status = self.wait_until_node_ready(Name=name)
                banner("verify_node_online_status : {}".format(verify_node_online_status))
                wait_for_node_addition_status.append(verify_node_online_status)
            print("wait_for_node_addition_status : {}".format(wait_for_node_addition_status))
            result = len(wait_for_node_addition_status) > 0 and all(elem == "OK" for elem in wait_for_node_addition_status)
            if result:
                return "OK"
            else:
                return "Error"
            
        except Exception as e:
            logger.console("Error in add_node_and_check_online status: {}".format(e))
    
    ###############################################################################################################
    @keyword(name="PCC.Delete mutliple nodes and wait until deletion")
    ###############################################################################################################   
    
    def delete_multiple_nodes_and_wait_until_deletion(self, *args, **kwargs):
        """
        Deletes multiple nodes/ all nodes 
        [Args]
            (list) Names: List of Names of the Nodes to be deleted
            or
            Don't provide any arguments if you want to delete all nodes
            ...
        [Returns]
            (str) OK: Returns "OK" if all nodes are deleted successfully
            else: returns "Error"
        """
        
        banner("Delete mutliple nodes and wait until deletion")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        try:
            if self.Names:
                deletion_status = []
                for name in ast.literal_eval(self.Names):
                    node_id= self.get_node_id(Name=name)
                    banner("Node id: {}".format(node_id))
                    delete_node_status = self.delete_node(Id=node_id)
                    logger.console(delete_node_status)
                        
                for name in ast.literal_eval(self.Names):
                    deletion_response = self.wait_until_node_deleted(Name=name)
                    deletion_status.append(deletion_response)
                print("deletion_status: {}".format(deletion_status))
                result = len(deletion_status) > 0 and all(elem == "OK" for elem in deletion_status)
                if result:
                    return "OK"
                else:
                    return "Error"
                    
                    
            else:
                response = self.get_nodes()
                deletion_status_code = []
                node_ready_status = []
                if get_response_data(response) == None:
                    return "OK"
                else:
                    for node in get_response_data(response):
                        deletion_response = self.delete_node(Id=node['Id']) 
                        deletion_status_code.append(deletion_response['StatusCode'])
                        
                        wait_until_deletion_response = self.wait_until_node_deleted(Name=node['Name'])
                        node_ready_status.append(wait_until_deletion_response)
                    
                    trace("deletion_status_code: {}".format(deletion_status_code))
                    trace("node_ready_status: {}".format(node_ready_status))
                    result1 = len(deletion_status_code) > 0 and all(elem == 200 for elem in deletion_status_code)
                    result2 = len(node_ready_status) > 0 and all(elem == "OK" for elem in node_ready_status)
                    
                    if result1 and result2:
                        return "OK"
                    else:
                        return "Node deletion status is {} and wait until status is {}".format(deletion_status_code,node_ready_status)

        except Exception as e:
            return "Exception encountered: {}".format(e)

    ###########################################################################
    @keyword(name="PCC.Node Verify Back End")
    ###########################################################################
    def verify_node_back_end(self, *args, **kwargs):

        banner("PCC.Node Verify Back End")
        self._load_kwargs(kwargs)
        print("Kwargs:{}".format(kwargs))
    
        pcc_agent_cmd="sudo systemctl status pccagent"
        sys_cllector_cmd="sudo systemctl status systemCollector"
        frr_cmd="sudo service frr status|head -10"

        failed_host=[]

        if self.host_ips:
            for host_ip in eval(str(self.host_ips)):
                logger.console("Verifying services for host {} .....".format(host_ip))
                pcc_agent_output=cli_run(host_ip,self.user,self.password,pcc_agent_cmd)
                sys_collector_output=cli_run(host_ip,self.user,self.password,sys_cllector_cmd)   
                logger.console("Pcc Agent Output: {}".format(pcc_agent_output))
                logger.console("System Collector Output: {}".format(sys_collector_output))
                #frr_output=cli_run(host_ip,self.user,self.password,frr_cmd)
                #logger.console("Frr Service Output: {}".format(frr_output))
                #if re.search("running",str(pcc_agent_output)) and re.search("running",str(sys_collector_output) and re.search("running",str(frr_output))):
                if re.search("running",str(pcc_agent_output)) and re.search("running",str(sys_collector_output)):
                    continue
                else:
                    
                    failed_host.append(host_ip)
                    continue                
        else:
            print("Host list is empty, please provide the host ip in a list for eg. host_ips=['000.00.0.00']")
            
        if failed_host:  
            print("Service are down for {}".format(failed_host))
            BuiltIn().fatal_error('Stoping the exectuion, Nodes are not properly added please check !!!')
            return "Error"
        else:
            return "OK"

    ###########################################################################
    @keyword(name="PCC.Node Verify Back End After Deletion")
    ###########################################################################
    def verify_node_back_end_after_deletion(self, *args, **kwargs):

        banner("PCC.Node Verify Back End After Deletion")
        self._load_kwargs(kwargs)
        print("Kwargs:{}".format(kwargs))
    
        pcc_agent_cmd="sudo systemctl status pccagent"
        sys_cllector_cmd="sudo systemctl status systemCollector"
        frr_cmd="sudo service frr status|head -10"

        failed_host=[]

        if self.host_ips:
            for host_ip in eval(str(self.host_ips)):
                logger.console("Verifying services for host {} .....".format(host_ip))
                pcc_agent_output=cli_run(host_ip,self.user,self.password,pcc_agent_cmd)
                sys_collector_output=cli_run(host_ip,self.user,self.password,sys_cllector_cmd)   
                logger.console("Pcc Agent Output: {}".format(pcc_agent_output))
                logger.console("System Collector Output: {}".format(sys_collector_output))
                #frr_output=cli_run(host_ip,self.user,self.password,frr_cmd)
                #logger.console("Frr Service Output: {}".format(frr_output))
                #if re.search("running",str(pcc_agent_output)) and re.search("running",str(sys_collector_output) and re.search("running",str(frr_output))):
                if re.search("running",str(pcc_agent_output)) and re.search("running",str(sys_collector_output)):
                    continue
                else:
                    
                    failed_host.append(host_ip)
                    continue                
        else:
            print("Host list is empty, please provide the host ip in a list for eg. host_ips=['000.00.0.00']")
            
        if failed_host:  
            print("Service are down for {}".format(failed_host))
            return "Error"
        else:
            return "OK"
            
    #verifying sn and model number from front-end to backend        
    ###########################################################################
    @keyword(name="PCC.Node Verify Model And Serial Number")
    ###########################################################################
    def verify_model_and_serial_number(self, *args, **kwargs):
        banner("PCC.Node Verify Model And Serial Number")
        self._load_kwargs(kwargs)
        print("Kwargs:{}".format(kwargs))      
        conn = BuiltIn().get_variable_value("${PCC_CONN}")    
        serial_cmd="sudo dmidecode -s baseboard-serial-number"
        model_cmd="sudo dmidecode -s baseboard-product-name"       
        failed_host=[]
        if self.Names:
            for name in ast.literal_eval(self.Names):
                node_id= self.get_node_id(Name=name)
                node_details=get_response_data(pcc.get_node_summary_by_id(conn,str(node_id)))
                print("1. Node Summary:"+str(node_details))
                print("++++++++++++++++++++++++++++++++++++++++++++")
                print("2. Serial Number"+str(node_details['SN']))
                print("++++++++++++++++++++++++++++++++++++++++++++")
                print("3. Model Number"+str(node_details['Model']))
                print("++++++++++++++++++++++++++++++++++++++++++++")
                logger.console("Verifying services for host {} .....".format(node_details['Host']))
                print("Verifying services for host {} .....".format(node_details['Host']))
                serial_number=self._serialize_response(time.time(),cli_run(node_details['Host'], self.user, self.password, serial_cmd))['Result']['stdout']
                model_number=self._serialize_response(time.time(),cli_run(node_details['Host'], self.user, self.password, model_cmd))['Result']['stdout']
                print("Backend Serial Data:"+str(serial_number))
                print("Backend Model Data:"+str(model_number))
                if node_details['Model']==str(model_number.strip()) and node_details['SN']==str(serial_number.strip()):
                    continue
                else:
                    
                    failed_host.append(name)
                    continue                
        else:
            print("Node names is empty, please provide the node name list for eg. Names=['sv124','sv125']")           
        if failed_host:  
            print("Couldn't verify Serial and Model Number for {}".format(failed_host))     
            return "Error"
        else:
            return "OK" 
            
    ###########################################################################
    @keyword(name="PCC.Node Verify Kafka Container")
    ###########################################################################
    def verify_node_kafka_container(self, *args, **kwargs):
        banner("PCC.Node Verify Kafka Container")
        self._load_kwargs(kwargs)
        print("Kwargs:{}".format(kwargs))
    
        cmd="sudo timeout -s SIGKILL 60s docker exec kafka /usr/local/bin/kafka-avro-console-consumer --topic summary --bootstrap-server localhost:9092"
        failed_name=[]

        if self.Names and self.Host:
            logger.console("Verifying nodes info in Kafka container ....")
            output=cli_run(self.Host,self.user,self.password,cmd)
            logger.console("Kafka container output: {}".format(output))
            for name in eval(str(self.Names)):
                print("Verifying {} ...".format(name))
                if re.search(name,str(output)):
                    continue
                else:
                    
                    failed_name.append(name)
                    continue                
        else:
            print("Either Host or Names are empty!!")
            return "Error"
                     
        if failed_name:  
            print("Host not verified in Kafka container: {}".format(failed_name))     
            return "Error"
        else:
            return "OK"

    ###############################################################################################################
    @keyword(name="PCC.Cleanup features associated to Node")
    ###############################################################################################################

    def cleanup_features_associated_to_node(self, *args, **kwargs):
        """
        Cleanup features associated to Node
        [Args]
            (list) Names: List of Names of the Nodes to be deleted
            or
            Don't provide any arguments if you want to delete all nodes
            ...
        [Returns]
            (str) OK: Returns "OK" if all nodes are deleted successfully
            else: returns "Error"
        """

        banner("Cleanup features associated to Node")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        try:
            response = self.get_nodes()
            update_response_status = []
            node_names = []
            wait_until_node_ready_resp = []
            
            if get_response_data(response) == []:
                return "No nodes present on PCC"
            else:
                counter=1
                for node in get_response_data(response):
                    print("Node:{} output - {}".format(counter, node))
                    counter+=1
                    node_names.append(node['Name'])
                    
                    payload = { "Id":node['Id'],
                                "ClusterId":0,
                                "roles":[1],
                                "scopeId":int(self.scopeId)}
                    
                    update_resp = pcc.modify_node(conn, payload)
                    update_response_status.append(update_resp['StatusCode'])
                update_result = len(update_response_status) > 0 and all(elem == 200 for elem in update_response_status)
                banner("Node names : {}".format(node_names))
                for names in node_names:
                    resp = self.wait_until_node_ready(Name=names)
                    wait_until_node_ready_resp.append(resp)
                node_ready_result = len(wait_until_node_ready_resp) > 0 and all(elem == "OK" for elem in wait_until_node_ready_resp)
                
                if update_result and node_ready_result:
                    return "OK"
                return "Features not yet deleted ->  node update response is: {} and node ready status is {}".format(update_response_status,wait_until_node_ready_resp)
                    
        except Exception as e:
            return "Exception encountered: {}".format(e)

    ###############################################################################################################
    @keyword(name="PCC.Cleanup images present on Node from backend")
    ###############################################################################################################   
    
    def cleanup_images_present_on_node(self, *args, **kwargs):
        """
        PCC.Cleanup images present on Node from backend
        [Args]
            None
           
        [Returns]
            (str) OK: Returns "OK" if all images are cleaned from nodes
            else: returns "Error"
        """
        
        banner("PCC.Cleanup images present on Node from backend")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        try:
            response = self.get_nodes()
            node_hostips = []
            image_deletion_status=[]
            
            if get_response_data(response) == []:
                return "No nodes present on PCC"
            else:
                counter=1
                for node in get_response_data(response):
                    node_hostips.append(node['Host'])
                cmd = "sudo docker images -a|wc -l"
                cmd1 = "sudo docker rmi -f $(sudo docker images -a -q)" 
                cmd2 = "sudo docker images -a -q|wc -l"
                print("Cmd1 is: {}".format(cmd1))
                print("Cmd2 is: {}".format(cmd2))
                for hostip in node_hostips:
                    cmd_response = self._serialize_response(time.time(),cli_run(hostip, self.user, self.password, cmd))['Result']['stdout']
                    if str(cmd_response).strip() == "1":
                        image_deletion_status.append("OK")
                    else:
                        cmd1_response = self._serialize_response(time.time(),cli_run(hostip, self.user, self.password, cmd1))['Result']['stdout']
                        if re.search("Deleted:",str(cmd1_response)) or re.search("Untagged:",str(cmd1_response)):
                            image_deletion_status.append("OK")
                        else:
                            image_deletion_status.append("Failed at {} for node {}".format(cmd1,hostip))
                        time.sleep(1)
                    
                        cmd2_response = self._serialize_response(time.time(),cli_run(hostip, self.user, self.password, cmd2))['Result']['stdout']
                        if str(cmd2_response).strip() == "0":
                            image_deletion_status.append("OK")
                        else:
                            image_deletion_status.append("Failed at {} for node {}".format(cmd2,hostip))
                    
                    
                status = len(image_deletion_status) > 0 and all(elem == "OK" for elem in image_deletion_status)
                
                if status:
                    return "OK"
                return "Images not yet deleted from nodes->  status is: {} and image_deletion_status is {}".format(status, image_deletion_status)
                    
        except Exception as e:
            return "Exception encountered: {}".format(e)

    ###########################################################################
    @keyword(name="PCC.Wait Until All Nodes are Ready")
    ###########################################################################    
    def wait_until_all_nodes_are_ready(self, *args, **kwargs):
        """
        Wait Until Node Ready
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Node 
        [Returns]
            (dict) Wait Time 
            (dict) Error response: If Exception occured
        """
        self._load_kwargs(kwargs)
        banner("PCC.Wait Until All Nodes are Ready")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        all_node_list = pcc.get_nodes(conn)['Result']['Data']
        node_ready_status = []
        try:
            for node_name in all_node_list:
                ready = False
                time_waited = 0
                PCC_TIMEOUT = 60*10 #10 minutes
                timeout = time.time() + PCC_TIMEOUT
                while not ready:
                    ready = False
                    node_list = pcc.get_nodes(conn)['Result']['Data']
                    for node in node_list:
                        if str(node['Name']) == str(node_name['Name']):
                            if node['provisionStatus'] == 'Ready':
                                trace("Node:{} is ready".format(node_name['Name']))
                                node_ready_status.append("OK")
                                ready=True
                                break
                            if "fail" in node['provisionStatus']:
                                node_ready_status.append("Failed:{}".format(node['Name']))
                                trace("Wait until node ready status - Failed on node {}. Node Status is {}".format(node_name['Name'],node['provisionStatus']))
                                print("Wait until node ready status - Failed on node {}. Node Status is {}".format(node_name['Name'],node['provisionStatus']))
                                ready=True
                                break
                            if time.time() > timeout:
                                print("Error: Timeout for node {}".format(node_name['Name']))
                                node_ready_status.append("Timeout: {}".format(node_name['Name']))
                                ready=True
                                break
                            if not ready:
                                trace("Node:{} is not yet ready".format(node_name['Name']))
                                time.sleep(5)
                                time_waited += 5
            node_ready_result = len(node_ready_status) > 0 and all(elem == "OK" for elem in node_ready_status)
            if node_ready_result:
                return "OK"
            else:
                return "Wait Until Node ready status is: {}".format(node_ready_status)
        except Exception as e:
            return "Exception encountered: {}".format(e)
