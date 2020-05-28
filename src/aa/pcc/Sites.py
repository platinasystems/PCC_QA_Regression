import time
import re
from robot.api.deco import keyword
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from aa.common import PccEasyApi as easy

from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase

PCC_TIMEOUT = 60*3 # 3 min

class Sites(AaBase):
    """ 
    Sites
    """

    def __init__(self):
        self.Name=None
        self.Id=None
        self.Description= ""
        self.count=None
        self.Site_Id=None
        self.node_id=None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Add Sites")
    ###########################################################################
    def add_sites(self, *args, **kwargs):
        """
        Add Site
        [Args in kwargs]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name
            (str) Description
        [Returns]
            (dict) Response: Add Site response (includes any errors)
        """
        
        self._load_kwargs(kwargs)
        banner("PCC.Add Sites [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        payload = {
            "Name": self.Name,
            "Description": self.Description
            }
        
        print("Payload:-"+str(payload))
        return pcc.add_site(conn, payload)
    
    ###########################################################################
    @keyword(name="PCC.Get Sites")
    ###########################################################################
    def get_sites(self, *args, **kwargs):
        """
        Get Node Groups from PCC
        [Args]
            None
        [Returns]
            (dict) Response: Get Node Groups response (includes any errors)
        """
        banner("PCC.Get Sites")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_sites(conn)


    ###########################################################################
    @keyword(name="PCC.Get Sites Id")
    ###########################################################################
    def get_sites_id_by_name(self, *args, **kwargs):
        """
        Get Site from PCC
        [Args]
            (str) Name
        [Returns]
            (int) Id (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Sites [Name=%s]" % self.Name)
        if self.Name==None:
            print("Name of Site is Empty")
            return "Error"
                
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_site_id_by_name(conn, self.Name)

    ###########################################################################
    @keyword(name="PCC.Delete Sites")
    ###########################################################################
    def delete_sites(self, *args, **kwargs):
        """
        Delete Site for matching Id
        [Args]
            (str) Name
        [Returns]
            (dict) Delete Site Response
        """
        self._load_kwargs(kwargs)
        banner("PCC.Delete Sites")
        
        if self.Name==None:
            print("Name of Site is Empty")
            return "Error"     
            
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        self.Id=easy.get_site_id_by_name(conn,self.Name)
        
        if not self.Id:
            print("Can't fetch Id for %s" % self.Name)
            return "Error"
        return pcc.delete_sites(conn, [self.Id])
        
    ###########################################################################
    @keyword(name="PCC.Verify Sites Add")
    ###########################################################################
    def verify_sites_add(self, *args, **kwargs):
        """
        Validate Site 
        [Args]
            (str) Name
        [Returns]
            (str) "OK":If Site present in PCC
            else: "Error" : If Site not present in PCC
            
        """
        self._load_kwargs(kwargs)
        banner("PCC.Verify Sites Add [Name=%s]" % self.Name)
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        time.sleep(10)
        response = pcc.get_sites(conn)
        for data in get_response_data(response):
            print("Site_Response:"+str(data))
            trace("Looking if site %s is added or not...." % self.Name)
            print("Response Name:"+str(data['Name']))
            print("Name to look:"+str(self.Name))
            if str(data['Name']).lower() == str(self.Name).lower():
                print("inside")
                return "OK"
        print("Site %s is not added yet" % self.Name)
        return "Error"

    ###########################################################################
    @keyword(name="PCC.Verify Sites Delete")
    ###########################################################################
    def verify_sites_delete(self, *args, **kwargs):
        """
        Validate Site 
        [Args]
            (str) Name
        [Returns]
            (str) "OK":If Site present in PCC
            else: "Error" : If Site not present in PCC
            
        """
        self._load_kwargs(kwargs)
        banner("PCC.Validate Sites Delete [Name=%s]" % self.Name)
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        time.sleep(5)
        response = pcc.get_sites(conn)
        for data in get_response_data(response):
            print("Site_Response:+"+str(data))
            trace("Looking if site %s is deleted or not...." % self.Name)
            if str(data['Name']).lower() == str(self.Name).lower():
                print("Site %s is not deleted yet" % self.Name)
                return "Error"       
        return "OK"
                       
    ###########################################################################
    @keyword(name="PCC.Modify Sites")
    ###########################################################################
    def modify_sites(self, *args, **kwargs):
        """
        Modify Site
        [Args in kwargs]
            (dict) conn: Connection dictionary obtained after logging in
            (int) Id: Id of the cluster to be modified
            (string) Name: 
            (string) Description: 
             
        [Returns]
            (dict) Response: Add Cluster response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Modify Sites [Name=%s]" % self.Name)
     
        if not self.Id:
            print("Id of Site is None")

        payload = {
                    "Id":int(self.Id),
                    "Name":self.Name,
                    "Description":self.Description,
                  }
        print("Payload:-"+str(payload))
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.modify_site(conn,str(self.Id),payload)
        
    ###########################################################################
    @keyword(name="PCC.Add Multiple Sites and Verify")
    ###########################################################################
    def add_multiple_sites_and_verify(self, *args, **kwargs):
        """
        Add Site to PCC
        [Args]
            (str) Names: Names of the Site
            (str) Descriptions: Descriptions of the Site
        [Returns]
            (str) "OK" if all are added else "Error" (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add Multiple Sites [Name=%s] and Verify" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        site_name=self.Name
        for i in range(1,int(self.count)+1):
            self.Name=str(site_name)+str(i)
            print("Tmp Name:-"+str(self.Name))
            payload = {
                        "Name": self.Name,
                        "Description": self.Description
                      }
            print("Payload:-"+str(payload))
            response=pcc.add_site(conn, payload)
            status=self.verify_sites_add()
            if status=="OK":
                continue
            else:
                print("Can't verify %s Site" % self.Name) 
                return "Error"
        return "OK"
        
    ###########################################################################
    @keyword(name="PCC.Delete All Sites")
    ###########################################################################
    def delete_multiple_node_Sites(self, *args, **kwargs):
        """
        Delete Multiple Site from PCC
        [Args]
            (str) Names: Names of the Site
            (int) owner: Tenant Id for the new Site
            (str) Descriptions: Descriptions of the Site
        [Returns]
            (str) "OK" if all are deleted else "Error" (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Delete All Sites")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        response = pcc.get_sites(conn)
        for data in get_response_data(response):
            print("Site_Response:"+str(data))
            status_code=pcc.delete_sites(conn, [data['Id']])
            time.sleep(10)
            self.Name=data['Name']
            status=self.verify_sites_delete()
            if status=="OK":
                continue
            else:
                print("Error while deleting % Site" % self.Name)
                return "Error"
        return "OK"            
            
    ###########################################################################
    @keyword(name="PCC.Assign Sites to Node")
    ###########################################################################
    def assign_node_sites_to_node(self, *args, **kwargs):
        """
        Assign Site to Node
        [Args]
            (int) Id : Site Id
        [Returns]
            (dict) Response: Get Node response after Site is assigned (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Assign Site to Node")
        if self.Id:
            self.Id=int(self.Id)
        else:
            self.Id=0
        if self.node_id:
            self.node_id=int(self.node_id)
            
        payload = {"Site_Id" : self.Id,
                   "Id" : self.node_id
                  }
        print("Payload:"+str(payload))
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.modify_node(conn, payload)
            
    ###########################################################################
    @keyword(name="PCC.Verify Sites Assigned to Node")
    ###########################################################################
    def verify_node_sites_assignment(self, *args, **kwargs):
        """
        Validate Site assigned to Node
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Node
            (str) Id : Id of the Site
    
        [Returns]
            "OK": If Site assigned to Node
            else: "Error" : If Site not assigned to node
            
        """
        self._load_kwargs(kwargs)
        banner("PCC.Validate Site Assigned to Node [Name=%s]" % self.Name)
        
        logger.console("Kwargs are: {}".format(kwargs)) 
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        ready = False
        status=None

        timeout = time.time() + PCC_TIMEOUT
        while not ready:
            node_list = pcc.get_nodes(conn)['Result']['Data']
            for node in node_list:
                if int(node['Id']) == int(self.node_id):
                    print("Node Response:-"+str(node))
                    status=node['provisionStatus']
                    if node['provisionStatus'] == 'Ready':
                        ready = True
                    elif re.search("failed",str(node['provisionStatus'])):
                        return "Failed"
            if time.time() > timeout:
                return {"Error": "Timeout"}
            if not ready:
                trace("Waiting until node is Ready")
                time.sleep(5)
        return "OK"