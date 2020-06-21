import time
import ast
from robot.api.deco import keyword
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy

from aa.common.AaBase import AaBase
from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data
from aa.pcc.Nodes import Nodes
from aa.common.Cli import cli_run

PCC_TIMEOUT = 60*10  #10 min

class OS_Deployment(AaBase):
    def __init__(self):
        # Robot arguments definitions

        self.Id = None
        self.Name = None
        self.Node_name = None
        self.host_ip = None
        self.username = None
        self.password = None
        self.bmc_ip = None
        self.bmc_user = None
        self.bmc_users = None
        self.bmc_password = None
        self.server_console = None
        self.managed = None
        self.image_name = None
        self.locale = None
        self.time_zone = None
        self.admin_user = None
        self.ssh_keys = None
        self.interface_name = None
        self.ipv4Address = None
        self.gateway = None
        self.management = "true"
        self.managed_by_PCC = None
        self.adminStatus = None
        self.key_name = None
        self.i28_hostip = None
        self.i28_username = None
        self.i28_password = None
        
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Check Provision Ready Status")
    ###########################################################################
    
    def check_provision_ready_status(self, *args, **kwargs):
        
        banner("PCC.Check Provision Ready Status")
        self._load_kwargs(kwargs)
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        node_list = pcc.get_nodes(conn)['Result']['Data']
        try:
            for node in node_list:
                if str(node['Name']) == str(self.Name):
                    return node['ready']
            return None
        except Exception as e:
            return {"Error": str(e)}
            
    ###########################################################################
    @keyword(name="PCC.Update Node for OS Deployment")
    ###########################################################################
    
    def update_node(self, *args, **kwargs):
        
        banner("PCC.Update Node for OS Deployment")
        self._load_kwargs(kwargs)
        print("kwargs are: {}".format(kwargs))
        print("I am here")
        bmc_users = ast.literal_eval(self.bmc_users)
        print("after ast")
        logger.console("bmc_user : {}".format(bmc_users))
        payload={"Id":int(self.Id),
                "Name":self.Node_name,
                "Host":self.host_ip,
                "owner":1,
                "bmc":self.bmc_ip,
                "bmcUser":self.bmc_user,
                "bmcUsers":bmc_users,
                "bmcPassword":self.bmc_password,
                "console":self.server_console,
                "managed":bool(self.managed),
                }
        print("After payload")
        logger.console("Payload : {}".format(payload))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        provison_ready = self.check_provision_ready_status(**kwargs)
        
        logger.console("provison_ready : {}".format(provison_ready))
        if provison_ready == False:
            logger.console("I am inside if")
            return pcc.modify_node(conn, data=payload)
        else:
            logger.console("I am inside else")
            return {'Result': {'message':'Provision ready status is already true','status': 200}}
            
    
    ###########################################################################
    @keyword(name="PCC.Update OS details")
    ###########################################################################
    
    def update_OS(self, *args, **kwargs):
        
        '''
            sample_payload= {"nodes":[61],
                            "image":"ubuntu-disco",
                            "locale":"en-US",
                            "timezone":"PDT",
                            "adminUser":"RasikB",
                            "sshKeys":["RasikB"]
                            }
        '''
        banner("PCC.Update Node for OS Deployment")
        self._load_kwargs(kwargs)
         
        payload = {"nodes":ast.literal_eval(self.Id),
                  "image":self.image_name,
                  "locale":self.locale,
                  "timezone":self.time_zone,
                  "adminUser":self.admin_user,
                  "sshKeys":ast.literal_eval(self.ssh_keys)
                  }
        logger.console("Payload : {}".format(payload))          
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.update_deployment(conn, data = payload)
    
    ###########################################################################
    @keyword(name="PCC.Get OS version by node name")
    ###########################################################################
    
    def get_OS_version_by_node_name(self, *args, **kwargs):
        """
        Get OS version by Node Name
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the node
        [Returns]
            (string) OS_Version: Version of OS of the matchining node, or
                None: if no match found, or
            (dict) Error response: If Exception occured
        """

        banner("PCC.Get OS version by node name")
        self._load_kwargs(kwargs)
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        try:
            Id = Nodes().get_node_id(conn, Name=self.Name)
            
            logger.console("Node Id is: {}".format(Id))  
            OS_version = Nodes().get_node_by_id(conn, id= str(Id))['Result']['Data']['systemData']['osVersion']
            
            return OS_version
        except Exception as e:
            return {"Error": str(e)}
        
    ###########################################################################
    @keyword(name="PCC.Verify OS details from PCC")
    ###########################################################################
    
    def verify_OS_details_from_PCC(self, *args, **kwargs):
        '''
        ## Image
        get on "pccserver/images"
        fetch label by name
        
        get details by node id
        
        get get_node_by_id and return os version in sysytem data
        
        search os version in label of images
        
        
        '''
        banner("PCC.Update Node for OS Deployment")
        self._load_kwargs(kwargs)
        logger.console("kwargs in verify_OS_details_from_PCC are: {}".format(kwargs))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        label_name = easy.get_OS_label_by_name(conn, Name=self.image_name)
        logger.console("label_name: {}".format(label_name))
        OS_version = self.get_OS_version_by_node_name(**kwargs)
        logger.console("OS_version: {}".format(OS_version))
        if str(OS_version) in str(label_name):
            print("OS deployed successfully")
            return True
        else:
            print("Error in deploying OS")
            return False
        
        
        
        
    ###########################################################################
    @keyword(name="PCC.Pxe-boot node")
    ###########################################################################
    
    def pxe_boot_node(self, *args, **kwargs):
    
        banner("PCC.Pxe-boot node")
        self._load_kwargs(kwargs)
        logger.console("kwargs are: {}".format(kwargs))
        cmd_1 = "ipmitool -I lanplus -H {} -U ADMIN -P ADMIN chassis bootdev pxe".format(self.bmc_ip)
        
        logger.console("command 1 hitting is: {}".format(cmd_1))
        cmd_1_output = cli_run(cmd=cmd_1, host_ip=self.host_ip, linux_user=self.username,linux_password=self.password)
        logger.console("cmd_1_output:{}".format(cmd_1_output))
        cmd_2 = "ipmitool -I lanplus -H {} -U ADMIN -P ADMIN chassis power cycle".format(self.bmc_ip)
        
        logger.console("command 2 hitting is: {}".format(cmd_2))
        cmd_2_output = cli_run(cmd=cmd_2, host_ip=self.host_ip, linux_user=self.username,linux_password=self.password)

        if cmd_1_output and cmd_2_output:
            return "OK"
        else:
            return "Error: Pxe-boot failed over server: {}".format(self.bmc_ip)

    
    ###########################################################################
    @keyword(name="PCC.Wait until pxe booted node added to PCC")
    ###########################################################################
    
    def wait_until_PXE_booted_node_added(self, *args, **kwargs):
        banner("PCC.Wait until pxe booted node added to PCC")
        self._load_kwargs(kwargs)
        logger.console("Kwargs are: {}".format(kwargs))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        notfound = True
        counter=0
        while notfound:
            counter+=1
            node_list = pcc.get_nodes(conn)['Result']['Data']
            logger.console("Counter {}: Pxe-booted server not added yet to PCC".format(counter))
            if counter<= 300:
                time.sleep(5)
                for node in node_list:
                    if node['Name'] == self.Name:
                        notfound=False
                        logger.console("Pxe-booted server added to PCC")
                        return "OK"
                    
            else:
                logger.console("Pxe-booted server not found")
                break
        return "Error: Pxe-booted server not found"
                
        
        
    
        
    ###########################################################################
    @keyword(name="PCC.Get interface id")
    ###########################################################################
    
    def get_interface_id(self, *args, **kwargs):
        banner("PCC.Get interface id")
        self._load_kwargs(kwargs)
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_interface_id_by_name(conn, Name=self.interface_name)
        
    ###########################################################################
    @keyword(name="PCC.Edit interface of pxe-booted node")
    ###########################################################################
    
    def edit_interface_pxe_booted_node(self, *args, **kwargs):
        '''
        {         
                  "ifName":"xeth1-1",
                  "nodeId":46,
                  "interfaceId":1097,
                  "speed":null,
                  "ipv4Addresses":["203.17.3.32/31"],
                  "gateway":null,
                  "management":"true",
                  "managedByPcc":true}
                  
        post on https://172.17.2.242:9999/pccserver/interface
        '''
        banner("PCC.Edit interface of pxe-booted node")
        self._load_kwargs(kwargs)
        
        interface_id = self.get_interface_id(**kwargs)
        
        payload= {"ifName":self.interface_name,
                  "nodeId":int(self.Id),
                  "interfaceId":interface_id,
                  "ipv4Addresses":ast.literal_eval(self.ipv4Address),
                  "gateway":self.gateway,
                  "management":str(self.management),
                  "managedByPcc":bool(self.managed_by_PCC),
                  "adminStatus":self.adminStatus
                  }
                  
                  
        conn = BuiltIn().get_variable_value("${PCC_CONN}")          
        return pcc.apply_interface(conn, data=payload)
        
        
    ###########################################################################
    @keyword(name="PCC.Find management interface")
    ###########################################################################
    
    def get_topologies_(self, *args, **kwargs):
        banner("PCC.Find management interface")
        self._load_kwargs(kwargs)
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        ## Interfaces from Topology
        topology_response =  pcc.get_topologies(conn)['Result']['Data']
        
        interface_list= []
        for interfaces in topology_response:
            if interfaces['NodeName'] == self.Node_name:
                for link in interfaces['links']:
                    interface_list.append(link['interface_name'])
                    
        
        ## Interfaces from node properties            
        node_details = pcc.get_node_by_id(conn, id = str(self.Id))['Result']['Data']['HardwareInventory']['Network']
        
        li= []
        interface_dict = {}
        for interfaces in node_details.values():
            name=interfaces['name']
            status = interfaces["link"]
            interface_dict[name]= status
            
        list_of_online_interfaces = [key  for (key, value) in interface_dict.items() if value == 'yes']
        
        ## Finding the available online interfaces which will be set as Management Interface
        list_of_online_interfaces = set(list_of_online_interfaces)
        interface_list = set(interface_list)
        
        management_interfaces = list_of_online_interfaces - interface_list
        
        for management_interface in management_interfaces:
            logger.console(management_interface)
        
        return management_interface 
        
    ###########################################################################
    @keyword(name="PCC.Set password on Server")
    ###########################################################################
    
    def set_password_on_server(self, *args, **kwargs):
        banner("PCC.Set password on Server")
        self._load_kwargs(kwargs)             
        
        try:
            cmd = r"""ssh -i {} {}@{} -t 'echo -e "{}\n{}" | sudo passwd pcc'""".format(self.key_name, self.admin_user, self.host_ip, self.password,self.password)
            
            password_reset = cli_run(cmd=cmd, host_ip=self.i28_hostip, linux_user=self.i28_username,linux_password=self.i28_password)
            
            serialised_password_reset = self._serialize_response(time.time(), password_reset)
            print("serialised_password_reset is:{}".format(serialised_password_reset))
            
            cmd_output = str(serialised_password_reset['Result']['stdout']).replace('\n', '').strip()
            
            print("output of set_password_on_server:{}".format(cmd_output))
            if "updated successfully" in self.cmd_output:
                return "OK"
            else:
                return "Error"
        except Exception as e:
            logger.console("Error in set password on server: " + str(e))
            
    ###########################################################################
    @keyword(name="PCC.Update OS Images")
    ###########################################################################
    
    def update_OS_images(self, *args, **kwargs):
        banner("PCC.Update OS Images")
        self._load_kwargs(kwargs)             
        
        try:
            cmd = "sudo chown -R pcc:pcc /srv/pcc; curl http://172.17.2.253/bugbits/baremetal/update-prod | bash"
            
            update_OS_images = cli_run(cmd=cmd, host_ip=self.host_ip, linux_user=self.username,linux_password=self.password)
            
            serialised_update_OS_images = self._serialize_response(time.time(), update_OS_images)
            print("serialised_update_OS_images is:{}".format(serialised_update_OS_images))
            
            cmd_output = str(serialised_update_OS_images['Result']['stdout']).replace('\n', '').strip()
            
            print("output of serialised_update_OS_images:{}".format(cmd_output))
            if "Finished" in self.cmd_output:
                return "OK"
            else:
                return "Error"
        except Exception as e:
            logger.console("Error in Update OS Images: " + str(e))    
                 
        
        
        
        
        
    
    
    
        
    
        
