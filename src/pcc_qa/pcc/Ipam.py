import re
import ast
import time
import json

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print, cmp_json
from pcc_qa.common.Result import get_response_data
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60*3

class Ipam(PccBase):

    """ 
    IPAM(subnet-objs)
    """

    def __init__(self):

        # Robot arguments definitions
        self.id=None
        self.name=None
        self.subnet=None
        self.pubAccess=None
        self.routed=None
        self.usedBy=None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Ipam Subnet Get Id")
    ###########################################################################
    def ipam_subnet_get_id(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ipam Subnet Get Id") 
        print("Kwargs:"+str(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        ipam_id = easy.get_subnet_id_by_name(conn,self.name)
        return ipam_id

    ###########################################################################
    @keyword(name="PCC.Ipam Subnet Create")
    ###########################################################################
    def create_ipam_subnet(self, *args, **kwargs):
        banner("PCC.Ipam Subnet Create")
        self._load_kwargs(kwargs)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        if self.pubAccess=="True" or self.pubAccess=="true":
            self.pubAccess=True
        else:
            self.pubAccess=False
 
        if self.routed=="True" or self.routed=="true":
            self.routed=True
        else:
            self.routed=False
                  
        payload = {
                    'id':0,
                    'name':self.name,
                    'subnet':self.subnet,
                    'pubAccess':json.loads(json.dumps(self.pubAccess)),
                    'routed':json.loads(json.dumps(self.routed))
                   }
 
        print("Payload:-"+str(payload))
        return pcc.add_subnet_obj(conn, payload)


    ###########################################################################
    @keyword(name="PCC.Ipam Subnet Update")
    ###########################################################################
    def update_ipam_subnet(self, *args, **kwargs):
        banner("PCC.Ipam Subnet Update")
        self._load_kwargs(kwargs)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        if self.pubAccess=="True" or self.pubAccess=="true":
            self.pubAccess=True
        else:
            self.pubAccess=False
 
        if self.routed=="True" or self.routed=="true":
            self.routed=True
        else:
            self.routed=False
        
        if self.id:
            self.id=int(self.id)
            
        payload = {
                    'id':self.id,
                    'name':self.name,
                    'subnet':self.subnet,
                    'pubAccess':json.loads(json.dumps(self.pubAccess)),
                    'routed':json.loads(json.dumps(self.routed))
                   }
 
        print("Payload:-"+str(payload))
        return pcc.modify_subnet_obj(conn, payload)

    
    ###########################################################################
    @keyword(name="PCC.Ipam Subnet Delete")
    ###########################################################################
    def delete_ipam_subnet_by_id(self, *args, **kwargs):
        banner("PCC.Ipam Subnet Delete")
        self._load_kwargs(kwargs)

        if self.name == None:
            return {"Error": "[PCC.Subnet Delete]: Name of the subnet is not specified."}

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
            
        self.id=easy.get_subnet_id_by_name(conn,self.name)

        return pcc.delete_subnet_obj_by_id(conn, str(self.id))


    ###########################################################################
    @keyword(name="PCC.Verify Ipam Subnet Updated")
    ###########################################################################
    def verify_ipam_subnet_updated(self, *args, **kwargs):
        banner("PCC.Verify Ipam Subnet Updated")
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(kwargs))

        if self.name == None:
            print("Name is Empty, Please provide valid name.")
            return "Error"
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        timeout = time.time() + PCCSERVER_TIMEOUT
  
        response = pcc.get_subnet_objs(conn)
        for data in get_response_data(response):
            if str(data['name']).lower() == str(self.name).lower():
                print("Data to Look:"+str(data))
                for key in kwargs:
                    if data[key]==kwargs[key]:
                        continue
                    else:
                        print("Not Updated Propery, there is mismatch {}!={}".format(data[key],kwargs[key]))
                        return "Error"        
        return "OK"                

    ###########################################################################
    @keyword(name="PCC.Wait Until Ipam Subnet Ready")
    ###########################################################################
    def wait_until_ipam_subnet_ready(self, *args, **kwargs):
        banner("PCC.Wait Until Ipam Subnet Ready")
        self._load_kwargs(kwargs)

        if self.name == None:
            return None
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        timeout = time.time() + PCCSERVER_TIMEOUT
  
        response = pcc.get_subnet_objs(conn)
        for data in get_response_data(response):
            if str(data['name']).lower() == str(self.name).lower():
                print("Response To Look :-"+str(data))
                return "OK"                
            time.sleep(5)
        print("Could not find any entry for subnet "+str(self.name)+" on PCC UI")
        return "Error"


    ###########################################################################
    @keyword(name="PCC.Wait Until Ipam Subnet Deleted")
    ###########################################################################
    def wait_until_ipam_subnet_deleted(self, *args, **kwargs):
        banner("PCC.Wait Until Ipam Subnet Deleted")
        self._load_kwargs(kwargs)

        if self.name == None:
            return None
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        timeout = time.time() + PCCSERVER_TIMEOUT
        
        time.sleep(30)
        response = pcc.get_subnet_objs(conn)
        for data in get_response_data(response):
            if str(data['name']).lower() == str(self.name).lower():
                print("Response To Look :-"+str(data))
                print("Could not able to delete subnet "+str(self.name))
                return "Error"                
            time.sleep(5)
        print("Subnet {} deleted sucessfully".format(self.name))
        return "OK"


    ###########################################################################
    @keyword(name="PCC.Ipam Subnet Delete All")
    ###########################################################################
    def delete_all_ipam_subnets(self, *args, **kwargs):
        banner("PCC.Ipam Subnet Delete All")
        self._load_kwargs(kwargs)

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        
        failed_del=[]
        response = pcc.get_subnet_objs(conn)
        
        if not get_response_data(response):
            print("No subnet found for delete !!")
            return "OK"
            
        for data in get_response_data(response):
            print("Response To Look :-"+str(data))
            print("Subnet {} and id {} is deleting....".format(data['name'],data['id']))
            self.id=data['id']
            del_response=pcc.delete_subnet_obj_by_id(conn, str(self.id))
            if del_response['Result']['status']==200:
                continue
            else:
                print("Delete Response:"+str(del_response))
                failed_del.append(data['name'])
                continue
        if failed_del:
            print("Could not delete following Subnets: "+str(failed_del))
            return "Error"
        return "OK"


