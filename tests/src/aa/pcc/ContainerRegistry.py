import time
from robot.api.deco import keyword
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data
#from motorframework.api import nodes
from pcc_qa.pcc.Nodes import Nodes

class ContainerRegistry(PccBase):
    def __init__(self):
        # Robot arguments definitions

        self.ID = 0
        self.Name = None
        self.node_name = None
        self.nodeID = None
        self.fullyQualifiedDomainName = None
        self.FQDN = None
        self.password = None
        self.secretKeyBase = None
        self.databaseName = None
        self.secretKeyBase = None
        self.databasePassword = None
        self.port = 3000
        self.registryPort = 5000
        self.adminState = None
        self.cluster_id = None
        self.availability = "false"
        self.running = "false"
        self.CR_ID = None
        self.portus_uname = None
        self.authenticationProfileId = None
        self.storageLocation = None
        self.registryCertId = None
        self.registryKeyId = None
        self.storageType = None
        
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Create Container Registry")
    ###########################################################################
    
    def cr_create(self, *args, **kwargs):
        
        """
        Create Container Registry
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (dict) data: Payload (nodeID=<nodeID>, name=<Name>, fullyQualifiedDomainName=<fullyQualifiedDomainName>, password=<password>, secretKeyBase=<secretKeyBase>, databaseName=<databaseName>, databasePassword=<databasePassword>, port=<port>, registryPort=<registryPort>, adminState=<adminState>, authenticationProfileId=<authenticationProfileId>)
    
        [Returns]
            (dict) Response: Create Container Registry response (includes any errors)
        """
        
        banner("PCC.Creating Container Registry")
        self._load_kwargs(kwargs)
        
        if self.nodeID:
            payload = {
                "registryCertId":self.registryCertId,
                "registryKeyId":self.registryKeyId,
                "storageLocation":self.storageLocation,
                "nodeID": self.nodeID,
                "name": self.Name,
                "fullyQualifiedDomainName": self.fullyQualifiedDomainName,
                "password":self.password,
                "secretKeyBase":self.secretKeyBase,
                "databaseName":self.databaseName,
                "databasePassword":self.databasePassword,
                "port":int(self.port),
                "registryPort":int(self.registryPort),
                "adminState":str(self.adminState),
                "authenticationProfileId":self.authenticationProfileId,
                "storageType":self.storageType
                
                }
        else:
            payload = {
                "registryCertId":self.registryCertId,
                "registryKeyId":self.registryKeyId,
                "storageLocation":self.storageLocation,
                "name": self.Name,
                "fullyQualifiedDomainName": self.fullyQualifiedDomainName,
                "password":self.password,
                "secretKeyBase":self.secretKeyBase,
                "databaseName":self.databaseName,
                "databasePassword":self.databasePassword,
                "port":int(self.port),
                "registryPort":int(self.registryPort),
                "adminState":str(self.adminState),
                "authenticationProfileId":self.authenticationProfileId,
                "storageType":self.storageType
                }
        
        print("Payload is :{}".format(payload))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.add_portus(conn, data=payload)
            
    

    ###########################################################################
    @keyword(name="PCC.Get CR Id")
    ###########################################################################
    
    def get_CR_id(self, *args, **kwargs):
        
        """
        Get Container Registry Id
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Container Registry who's id is required (name=<Name>)
    
        [Returns]
            (int) Id: Id of the Container Registry, or
                None: if no match found, or
            (dict) Error response: If Exception occured
        """
        
        banner("PCC.Get CR Id")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_portus_id_by_name(conn, self.Name)
    
            
    ###########################################################################
    @keyword(name="PCC.Get CR_Server Id")
    ###########################################################################
    
    def get_CR_server_id(self, *args, **kwargs):
        
        """
        Get Server Id used by Container Registry
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Container Registry who's server id is required (name=<Name>)
    
        [Returns]
            (int) Id: Server Id of the Container Registry, or
                None: if no match found, or
            (dict) Error response: If Exception occured
        """
        
        banner("PCC.Get CR_Server Id")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_server_id_used_by_portus(conn, self.Name)
            
    ###########################################################################
    @keyword(name="PCC.Get Host IP")
    ###########################################################################
    
    def get_Host_IP(self, *args, **kwargs):
        
        """
        Get Host IP used by Container Registry
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Container Registry who's Host IP is required (name=<Name>)
    
        [Returns]
            (str) Host IP: Host IP used by the Container Registry, or
                None: if no match found, or
            (dict) Error response: If Exception occured
        """
        
        banner("PCC.Get Host IP")
        self._load_kwargs(kwargs)
        try:
            server_id = self.get_CR_server_id(**kwargs)
            node_ids_response = Nodes().get_nodes(**kwargs)
            print("node_ids_response: {}".format(node_ids_response))
            
            for node in get_response_data(node_ids_response):
                if server_id == node['Id']:
                    return node['Host']
        except Exception as e:
            logger.console("Error in get_Host_IP: {}".format(e))
            
    ###########################################################################
    @keyword(name="PCC.CR Wait For Creation")
    ###########################################################################
    
    def wait_for_cr_create(self, *args, **kwargs):
        
        """
        Wait for creation of Container Registry
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Container Registry to wait for(name=<Name>)
    
        [Returns]
            (str) OK: OK if Container Registry has been created on PCC, else
            Error
                
        """
        
        banner("PCC.CR Wait For Creation")
        self._load_kwargs(kwargs)
        self.CR_ID = self.get_CR_id(**kwargs)
        if self.CR_ID!= None:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        else:
            return "Object with {} not found".format(self.Name)
    
        for i in range(1,60):
            time.sleep(10)
            banner("Loop: {}".format(i))
            response = pcc.get_portus_by_id(conn, id=str(self.CR_ID))
            print("Response is:{}".format(response))
            
            node = get_response_data(response)
            try:
                if node['name'] == self.Name:
                    self.availability = node["available"]
                    print("availability status: ",self.availability)
                    banner("availability is: {}".format(self.availability))
                    if self.availability == True:
                        if node.get("portusInfo") != None:
                            self.running = node["portusInfo"]["running"]
                            print("running status: ",self.running)
                            banner("running is: {}".format(self.running))
                            if self.running == True:
                                return "OK"
                            else:
                                continue
                    else:
                        continue # continue for loop if availability is false
                if i>=49:
                    return {"Error: Timeout while creating Container Registry: {}".format(self.Name)}
            except Exception as e:
                print("Error in creating CR: {}".format(self.Name))
                return "Error in creating CR: {}".format(self.Name)
            
    ###########################################################################
    @keyword(name="PCC.CR Verify Creation from PCC")
    ###########################################################################
    
    def verify_CR_creation(self, *args, **kwargs):
        
        """
        Verify creation of Container Registry on PCC
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Container Registry to check if it is created on PCC(name=<Name>)
    
        [Returns]
            (str) OK: OK if Container Registry has been created on PCC, else
            Error
                
        """
        
        banner("PCC.CR Verify Creation from PCC")
        self._load_kwargs(kwargs)
        self.CR_ID = self.get_CR_id(**kwargs)
        if self.CR_ID!= None:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        else:
            return "Object with {} not found".format(self.Name)
    
        response = pcc.get_portus_by_id(conn, id=str(self.CR_ID))
    
        try:
            node= response['Result']['Data']
            
            if str(node['name']) == str(self.Name):
                self.availability = node.get("available")
                banner("availability from verify_CR_creation: {}".format(self.availability))
                try:
                    if node.get("portusInfo") != None:
                        self.running = node["portusInfo"]["running"]
                except Exception as e:
                    print("Exception in portusinfo: ",e)
                    self.running == False
            if self.availability == True and self.running == True:
                banner("Service is available")
                return "OK"
            else:
                banner("Service not available")
                return "Error"
        except Exception as e:
            logger.console("Response doesnot have [Result][Data] and exception is : {}".format(e))
            
    
            
    ###########################################################################
    @keyword(name="PCC.Update Container Registry")
    ###########################################################################       
    
    def update_CR(self,*args, **kwargs):
        
        """
        Updates Container Registry
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (dict) data: Payload (nodeID=<nodeID>, name=<name>, fullyQualifiedDomainName=<fullyQualifiedDomainName>, password=<password>, secretKeyBase=<secretKeyBase>, databaseName=<databaseName>, databasePassword=<databasePassword>, port=<port>, registryPort=<registryPort>, adminState=<adminState>, authenticationProfileId=<authenticationProfileId>)
    
        [Returns]
            (dict) Response: Update Container Registry response (includes any errors)
        """
        
        banner("PCC.Update Container Registry")
        self._load_kwargs(kwargs)
        self.CR_ID= self.get_CR_id(**kwargs)
        payload = {
                "id":self.CR_ID,
                "registryCertId":self.registryCertId,
                "registryKeyId":self.registryKeyId,
                "storageLocation":self.storageLocation,
                "nodeID": self.get_CR_server_id(**kwargs),
                "name": str(self.Name),
                "fullyQualifiedDomainName": str(self.fullyQualifiedDomainName),
                "password":str(self.password),
                "secretKeyBase":str(self.secretKeyBase),
                "databaseName":str(self.databaseName),
                "databasePassword":str(self.databasePassword),
                "port":int(self.port),
                "registryPort":int(self.registryPort),
                "adminState":str(self.adminState),
                "storageType":self.storageType
                }
        
        banner("Payload: {}".format(payload))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.modify_portus(conn, payload)
                    
    ###########################################################################
    @keyword(name="PCC.CR Wait For CR updation")
    ###########################################################################
    
    def wait_for_CR_updation(self, *args, **kwargs):
        
        """
        Wait for updation of Container Registry
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Container Registry to wait for(name=<Name>)
    
        [Returns]
            (str) OK: OK if Container Registry has been updated on PCC, else
            Error
                
        """
        
        banner("PCC.CR Wait For Updation")
        self._load_kwargs(kwargs)
        self.CR_ID = self.get_CR_id(**kwargs)
        if self.CR_ID!= None:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        else:
            return "Object with {} not found".format(self.Name)
    
        for i in range(1,60):
            time.sleep(10)
            banner("Loop: {}".format(i))
            response = pcc.get_portus_by_id(conn, id=str(self.CR_ID))
            print("Response is:{}".format(response))
            
            node = get_response_data(response)
            try:
                if node['name'] == self.Name:
                    self.availability = node["available"]
                    print("availability status: ",self.availability)
                    banner("availability is: {}".format(self.availability))
                    if self.availability == True:
                        if node.get("portusInfo") != None:
                            self.running = node["portusInfo"]["running"]
                            print("running status: ",self.running)
                            banner("running is: {}".format(self.running))
                            if self.running == True:
                                return "OK"
                            else:
                                continue
                    else:
                        continue # continue for loop if availability is false
                if i>=49:
                    return {"Error: Timeout while updating Container Registry: {}".format(self.Name)}
            except Exception as e:
                print("Error in updating CR: {}".format(self.Name))
                return "Error in updating CR: {}".format(self.Name)
    
    ###########################################################################
    @keyword(name="PCC.CR Delete")
    ###########################################################################
    
    def CR_delete(self, *args, **kwargs):
        
        """
        Delete Container Registry by Id or Name
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Id: Id
    
        [Returns]
            (dict) Response: Delete Container Registry response (includes any errors)
        """
        
        banner("PCC.CR Delete new")
        self._load_kwargs(kwargs)
        try:
            if self.Name == None:
                raise Exception("[PCC.Delete Cluster]: cluster name is not specified.")
            else:
                self.CR_ID= self.get_CR_id(**kwargs)
                conn = BuiltIn().get_variable_value("${PCC_CONN}")
                return pcc.delete_portus_by_id(conn, id=str(self.CR_ID))    
                
        except Exception as e:
            logger.console("Error in CR deletion: "+str(e))
                
    ###########################################################################
    @keyword(name="PCC.Clean all CR")
    ###########################################################################
                
    # returns response of cleanup all CR
    # <usage> clean_all_CR
    
    def clean_all_CR(self, *args, **kwargs):
        
        """
        Delete All Container Registry
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            
        [Returns]
            (str) OK: OK if All Container Registry are deleted (includes any errors)
        """
        
        banner("PCC.Clean all CR")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        response = pcc.get_portus(conn)
        
        list_id = []
        if get_response_data(response)==[]:
            return "OK"
        else:
            try:
                for ids in get_response_data(response):
                    list_id.append(ids['id'])
                print("list of id:{}".format(list_id))                
            except Exception as e:
                logger.console("Error: {}".format(e))
            response_code_list = []
            try:
                for id_ in list_id:
                    response = pcc.delete_portus_by_id(conn, id=str(id_))
                    print()
                    response_code_list.append(response['StatusCode'])
                result = len(response_code_list) > 0 and all(elem == response_code_list[0] for elem in response_code_list) 
                if result:
                    return "OK"  
                else:
                    return "Error"  
            except Exception as e:
                logger.console("Error in clean all CR: {}".format(e))
            
    ###########################################################################
    @keyword(name="PCC.Wait for deletion of CR")
    ###########################################################################
    
    # waits for CR deletion and returns OK if CR is deleted successfully 
    # <usage> wait_for_CR_deletion(name=<name>)
    
    def wait_for_CR_deletion(self, *args, **kwargs):
        
        """
        Wait for deletion of Container Registry
    
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the specific Container Registry to wait for delete (name=<Name>), 
            if Name is not provided, it will wait for all Container Registries to delete
    
        [Returns]
            (str) OK: OK if Container Registry has been deleted on PCC, else
            Error
                
        """
        
        banner("PCC.Wait for deletion of CR")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        try:    
            if self.Name == None:
                deletion_status = False
                counter = 0
                while deletion_status == False:
                    counter+=1
                    response = pcc.get_portus(conn)
                    if get_response_data(response) != []:
                        time.sleep(6)
                        banner("All CR not yet deleted")
                        if counter < 40:
                            banner("Counter: {}".format(counter))
                            continue
                        else:
                            break
                    elif get_response_data(response) == []:
                        deletion_status = True
                        banner("All CR deleted successfully")
                    else:
                        banner("Entered into continuous loop")
                        break
                    if deletion_status == True:
                        return "OK"
                    else:
                        return "Error in deletion status of CR"
                        
            elif self.Name:
                deletion_status = False
                counter=0
                while deletion_status == False:
                    counter+=1
                    CR_availability_status = []
                    response = pcc.get_portus(conn)
                    for node in get_response_data(response):
                        CR_availability_status.append(node['name'])
                    if self.Name in CR_availability_status:
                        banner("Named CR still not deleted")
                        time.sleep(6)
                        if counter < 40:
                            banner("Counter: {}".format(counter))
                            continue
                        else:
                            break
                    elif self.Name not in CR_availability_status:
                        banner("Named CR deleted successfully")
                        deletion_status = True
                        break
                    else:
                        banner("Error in Named CR, Entered into continuous loop")
                        break
                            
                if deletion_status == True:
                    return "OK"
                else:
                    return "Error in deletion status of CR"
                
            else:
                return "Neither name provided nor name is None"
                
        except Exception as e:
            logger.console("Error in wait for CR deletion with id: {}".format(e))
