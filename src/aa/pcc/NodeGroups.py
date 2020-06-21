import time
from robot.api.deco import keyword
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy

from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase

class NodeGroups(AaBase):
    """ 
    NodeGroups
    """

    def __init__(self):
        self.Name = None
        self.Id = None
        self.Description = None
        self.Tenant = None
        self.owner = 1
        self.number_of_node_groups = None
        self.sample_name = None
        self.node_id = None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Add Node Group")
    ###########################################################################
    def add_node_group(self, *args, **kwargs):
        """
        Add Node Group to PCC
        [Args]
            (str) Name: Name of the group
            (int) owner: Tenant Id for the new group
            (str) Description: Description of the group
        [Returns]
            (dict) Response: Add Node Group response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add Node Group [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        payload = {
            "Name": self.Name,
            "Description": self.Description,
            "owner": self.owner
        }

        return pcc.add_cluster(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Get Node Groups")
    ###########################################################################
    def get_node_groups(self, *args, **kwargs):
        """
        Get Node Groups from PCC
        [Args]
            None
        [Returns]
            (dict) Response: Get Node Groups response (includes any errors)
        """
        banner("PCC.Get Node Groups")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_clusters(conn)

    ###########################################################################
    @keyword(name="PCC.Get Node Group")
    ###########################################################################
    def get_node_group(self, *args, **kwargs):
        """
        Get Node Group from PCC
        [Args]
            (int) Id
        [Returns]
            (dict) Response: Get Node Groups response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Node Group [Id=%s]" % self.Id)
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.get_cluster_by_id(conn, self.Id)

    ###########################################################################
    @keyword(name="PCC.Get Node Group Id")
    ###########################################################################
    def get_node_group_id(self, *args, **kwargs):
        """
        Get Node Group Id
        [Args]
            (str) Name
        [Returns]
            (int) Id: Node Group Id if there is one, 
                None: If not found
        """
        self._load_kwargs(kwargs)
        banner("PCC.Get Node Group Id [Name=%s]" % self.Name)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_node_group_id_by_name(conn, self.Name)

    ###########################################################################
    @keyword(name="PCC.Delete Node Group")
    ###########################################################################
    def delete_node_group(self, *args, **kwargs):
        """
        Delete Node Group for matching Id
        [Args]
            (int) Id
        [Returns]
            (dict) Delete Node Group Response
        """
        self._load_kwargs(kwargs)
        banner("PCC.Delete Node Group [Id=%s]" % self.Id)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.delete_cluster_by_id(conn, self.Id)
        
    ###########################################################################
    @keyword(name="PCC.Validate Node Group")
    ###########################################################################
    def validate_node_group_by_name(self, *args, **kwargs):
        """
        Validate Node Group by Name
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Cluster
        [Returns]
            "OK": If node group present in PCC
            else: "Node group not available" : If node group not present in PCC
            
        """
        self._load_kwargs(kwargs)
        banner("PCC.Validate Node Group")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        cluster_list = pcc.get_clusters(conn)['Result']['Data']
        try:
            for cluster in cluster_list:
                if str(cluster['Name']) == str(self.Name):
                    return "OK"
            return "Node group not available"
        except Exception as e:
            return {"Error": str(e)}
            
    ###########################################################################
    @keyword(name="PCC.Validate Node Group Description")
    ###########################################################################
        
    def validate_node_group_description_by_name(self, *args, **kwargs):
        """
        Validate Node Group Description by Name
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Cluster
            (str) Description: Description of the Cluster
        [Returns]
            "OK": If node group description matches
            else: "Description does not match" : If node group not present in PCC
            
        """
        self._load_kwargs(kwargs)
        banner("PCC.Validate Node Group")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        cluster_list = pcc.get_clusters(conn)['Result']['Data']
        try:
            for cluster in cluster_list:
                if str(cluster['Name']) == str(self.Name):
                    if str(cluster['Description']) == str(self.Description):
                        return "OK"
            return "Description does not match"
        except Exception as e:
            return {"Error": str(e)}

    ###########################################################################
    @keyword(name="PCC.Validate Node Group Assigned to Node")
    ###########################################################################
    def validate_node_group_assigned_to_node(self, *args, **kwargs):
        """
        Validate Node Group assigned to Node
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Node
            (str) Id : Id of the node group
        [Returns]
            "OK": If node group assigned to Node
            else: "Not assigned" : If node group not assigned to node
            
        """
        self._load_kwargs(kwargs)
        banner("PCC.Validate Node Group Assigned to Node")
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        nodes_response = pcc.get_nodes(conn)['Result']['Data']
        try:
            for node in nodes_response:
                if str(node['Name']) == str(self.Name):
                    if node['ClusterId'] == int(self.Id):
                        return "OK"
            return "Not assigned"
        except Exception as e:
            return {"Error": str(e)}
        
    ###########################################################################
    @keyword(name="PCC.Modify Node Group")
    ###########################################################################
    def modify_node_group(self, *args, **kwargs):
        """
        Modify Node Group
        [Args in kwargs]
            (dict) conn: Connection dictionary obtained after logging in
            (int) Id: Id of the cluster to be modified
            (string) Name: 
            (string) Description: 
            (int) owner: Tenant ID
             
        [Returns]
            (dict) Response: Add Cluster response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Modify Node Group [Name=%s]" % self.Name)
        payload = {
                    "Id":int(self.Id),
                    "Name":self.Name,
                    "Description":self.Description,
                    "owner":int(self.owner),
                  }
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.modify_cluster_by_id(conn, self.Id, data=payload)
        
    ###########################################################################
    @keyword(name="PCC.Add Multiple Node Groups")
    ###########################################################################
    def add_multiple_node_groups(self, *args, **kwargs):
        """
        Add Node Group to PCC
        [Args]
            (str) Names: Names of the node group
            (int) owner: Tenant Id for the new group
            (str) Descriptions: Descriptions of the node group
        [Returns]
            (dict) Response: Add Node Group response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add Multiple Node Groups [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        node_group_dict = {}
        for i in range(1,int(self.number_of_node_groups)+1):
            node_group_dict["node_group{}".format(i)]={"Name":"{}{}".format(self.Name,i),"Description":"{}{}".format(self.Description,i)}
        
        response_status = []
        availability_status = []
        for node in node_group_dict.values():
            payload= {
                      "Name": node["Name"],
                      "Description": node["Description"],
                      "owner": self.owner
                     }   
            
            add_cluster_response = pcc.add_cluster(conn, payload)
            print("add_cluster_response is: ",add_cluster_response)
            
            response_status.append(add_cluster_response['StatusCode'])
            
            availabilty_response = self.validate_node_group_by_name(Name=node["Name"])
            print("availabilty_response is: ",availabilty_response)
            
            availability_status.append(availabilty_response)
            
        response_result = len(response_status) > 0 and all(elem == 200 for elem in response_status)
        print("response_status : {}".format(response_status)) 
        print("response_result : {}".format(response_result)) 
        availability_result = len(availability_status) > 0 and all(elem == availability_status[0] for elem in availability_status)
        
        if (response_result) and (availability_result):
            return "OK"
            
        return "Error: All Node Groups not added to PCC"
        
    ###########################################################################
    @keyword(name="PCC.Delete Multiple Node Groups")
    ###########################################################################
    def delete_multiple_node_groups(self, *args, **kwargs):
        """
        Delete Multiple Node Group from PCC
        [Args]
            (str) Names: Names of the node group
            (int) owner: Tenant Id for the new group
            (str) Descriptions: Descriptions of the node group
        [Returns]
            (dict) Response: Add Node Group response (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Add Multiple Node Groups [Name=%s]" % self.Name)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        node_group_dict = {}
        
        for i in range(1,int(self.number_of_node_groups)+1):
            node_group_dict["node_group{}".format(i)]={"Name":"{}{}".format(self.Name,i)}
        
        response_status = []
        availability_status = []
        for node in node_group_dict.values():
            node_id = self.get_node_group_id(conn, Name= node["Name"])
            deletion_response = self.delete_node_group(conn, Id = node_id)
            print("deletion_response is: ",deletion_response)
            
            response_status.append(deletion_response["StatusCode"])
            
            availabilty_response = self.validate_node_group_by_name(Name=node["Name"])
            print("availabilty_response is: ",availabilty_response)
            
            availability_status.append(availabilty_response)
            
        response_result = len(response_status) > 0 and all(elem == 200 for elem in response_status) 
        print("response_status : {}".format(response_status)) 
        print("response_result : {}".format(response_result)) 
        availability_result = len(availability_status) > 0 and all(elem == availability_status[0] for elem in availability_status)
        
        if (response_result) and (availability_result):
            return "OK"
            
        return "Error: All Node Groups not deleted from PCC"
        
    ###########################################################################
    @keyword(name="PCC.Assign Node Group to Node")
    ###########################################################################
    def assign_node_group_to_node(self, *args, **kwargs):
        """
        Assign Node Group to Node
        [Args]
            (int) Id : Node group Id
        [Returns]
            (dict) Response: Get Node response after Node group is assigned (includes any errors)
        """
        self._load_kwargs(kwargs)
        banner("PCC.Assign Node Group to Node")
        node_payload = {"ClusterId" : int(self.Id),
                   "Id" : int(self.node_id)
                  }
        
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        response = pcc.modify_node(conn, data=node_payload)
        return pcc.get_nodes(conn)
        
    
    ###########################################################################
    @keyword(name="PCC.Delete all Node groups")
    ###########################################################################
    def delete_all_node_groups(self, *args, **kwargs):
        """
        Validate Node Group assigned to Node
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            
    
        [Returns]
            "OK": If all node groups are deleted
            else "Error"
            
        """
        banner("Delete All Node groups")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        try:
            response = pcc.get_clusters(conn)
            list_id = []
            
            if get_response_data(response) == []:
                return "OK"
            else:
                for ids in get_response_data(response):
                    list_id.append(ids['Id'])
                print("list of id:{}".format(list_id))
                for id_ in list_id:
                    response = pcc.delete_cluster_by_id(conn,str(id_))
                    
            deletion_status = False
            counter = 0
            while deletion_status == False:
                counter+=1
                response = pcc.get_clusters(conn)
                if get_response_data(response) != []:
                    time.sleep(2)
                    banner("All Node groups not yet deleted")
                    if counter < 50:
                        banner("Counter: {}".format(counter))
                        continue
                    else:
                        logger.console("Error: ['Timeout']")
                        break
                elif get_response_data(response) == []:
                    deletion_status = True
                    banner("All Nodes groups deleted successfully")
                    return "OK"
                else:
                    banner("Entered into continuous loop")
                    return "Error"
        
        except Exception as e:
            logger.console("Error in delete_all_node_groups status: {}".format(e))
    
    
            
                        
            
                    
            
            
        
        
        
