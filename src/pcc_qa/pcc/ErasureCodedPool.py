import re
import time
import json
import ast

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60 * 3

class ErasureCodedPool(PccBase):

    def __init__(self):

        # Robot arguments definitions
        self.id = None
        self.ceph_cluster_id = None
        self.name = ""
        self.size = None
        self.tags =  []
        self.pool_type = ""
        self.quota = None
        self.quota_unit = ""
        self.user=""
        self.password=""
        self.nodes_ip=[]
        self.count=0
        self.ErasureCodeProfileID = None
        self.Datachunks = None
        self.Codingchunks = None
        self.resilienceScheme = None
        self.pg_num = 8
        self.StripeUnit = 4096
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Ceph Get Erasure Pool Id")
    ###########################################################################
    def get_erasure_erasure_ceph_pool_id_by_name(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        pool_id= None
        banner("PCC.Ceph Get Erasure Pool Id")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        pool_id = easy.get_erasure_ceph_pool_id_by_name(conn,Name=self.name)
        return pool_id

    ###########################################################################
    @keyword(name="PCC.Ceph Get All Erasure Pools Data")
    ###########################################################################
    def get_erasure_ceph_all_pools_data(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        pool_id= None
        banner("PCC.Ceph Get All Erasure Pools Data")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        response = get_response_data(pcc.get_erasure_ceph_pools(conn))
        return response

    ###########################################################################
    @keyword(name="PCC.Ceph Delete All Erasure Pools")
    ###########################################################################
    def delete_all_erasure_pools(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Delete All Erasure Pool")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        response = pcc.get_erasure_ceph_pools(conn)
        for data in get_response_data(response):
            response=pcc.delete_erasure_ceph_pool_by_id(conn,str(data['id']))
            status=self.wait_until_erasure_pool_deleted(id=data['id'])
            if status!="OK":
                print("{} deletion failed".format(data['name']))
                return "Error"
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Get Erasure Pool Details For FS")
    ###########################################################################
    def get_erasure_pool_details_for_fs(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Erasure Pool Details For FS")

        temp=dict()        

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        response = pcc.get_erasure_ceph_pools(conn)['Result']['Data']
        print("Response:-"+str(response))
        for data in response:
            if str(data['name']) == str(self.name):
                temp["id"] = data["id"]
                temp["name"]= data["name"]
                temp["size"] = data["size"]
                temp["tags"] = []
                temp["ceph_cluster_id"] = data["ceph_cluster_id"]
                temp["pool_type"] = data["pool_type"]
                temp["quota"] = data["quota"]
                temp["quota_unit"] =  data["quota_unit"]
        return temp

    ###########################################################################
    @keyword(name="PCC.Ceph Get Multiple Erasure Pool Details For FS")
    ###########################################################################
    def get_multiple_erasure_pool_details_for_fs(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Erasure Pool Details For FS")

        temp=dict()
        temp_list=[]        

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        
        response = pcc.get_erasure_ceph_pools(conn)['Result']['Data']    
        for val in eval(str(self.name)):
            for data in response:
                if str(data['name']) == str(val):
                    temp["id"] = data["id"]
                    temp["name"]= data["name"]
                    temp["size"] = data["size"]
                    temp["tags"] = ["tags"]
                    temp["ceph_cluster_id"] = data["ceph_cluster_id"]
                    temp["pool_type"] = data["pool_type"]
                    temp["quota"] = data["quota"]
                    temp["quota_unit"] =  data["quota_unit"]
            if len(temp)!=0:        
                temp_list.append(temp)
        return temp_list

    ###########################################################################
    @keyword(name="PCC.Ceph Create Erasure Pool")
    ###########################################################################
    def add_erasure_ceph_pool(self, *args, **kwargs):
        banner("PCC.Ceph Create Erasure Pool")
        self._load_kwargs(kwargs)
        print("Kwargs are: {}".format(kwargs))
        
        if self.size:
            try:
                self.size= ast.literal_eval(str(self.size))
            except ValueError:
                print("Values is None or AlphaNumeric")

        if self.tags:
            self.tags=eval(self.tags)
        
        if 'ErasureCodeProfileID' not in kwargs:
            self.ErasureCodeProfileID = None
        if 'name' not in kwargs:
            self.name = None
        if 'quota' not in kwargs:
            self.quota = None
        if 'quota_unit' not in kwargs:
            self.quota_unit = 'TiB'
        if 'Datachunks' and 'Codingchunks' not in kwargs:
            self.Datachunks = None
            self.Codingchunks = None
        
        if self.pool_type == "data" and self.resilienceScheme == "erasure" and self.Datachunks and self.Codingchunks:
            print("I am in 1")
            payload = {"name":self.name,
                      "type":self.pool_type,
                      "size":self.size,
                      "quota":self.quota,
                      "resilienceScheme":self.resilienceScheme,
                      "quota_unit":self.quota_unit,
                      "ceph_cluster_id":self.ceph_cluster_id,
                      "erasureCodeProfile":{"dataChunks":int(self.Datachunks), "codingChunks":int(self.Codingchunks), "stripeUnit":int(self.StripeUnit)},
                       "pgNum": int(self.pg_num)
                      }
                      
        elif self.pool_type == "data" and self.resilienceScheme == "erasure"  and self.ErasureCodeProfileID:
            print("I am in 2")
            payload = {"name":self.name,
                      "type":self.pool_type,
                      "size":self.size,
                      "quota":str(self.quota),
                      "quota_unit":self.quota_unit,
                      "resilienceScheme":self.resilienceScheme,
                      "ceph_cluster_id":self.ceph_cluster_id,
                      "erasureCodeProfileId":self.ErasureCodeProfileID,
                      "pgNum": int(self.pg_num)
                      }              
        
          
        else:
            print("I am in 3")
            payload = {"name":self.name,
                "size":self.size,
                "tags":self.tags,
                "ceph_cluster_id":self.ceph_cluster_id,
                "type":self.pool_type,
                "resilienceScheme":self.resilienceScheme,
                "quota":str(self.quota),
                "quota_unit":self.quota_unit,
                "pgNum": int(self.pg_num)
            }
            
        
        #payload = json.dumps(payload)
        print(payload)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.add_erasure_ceph_pool(conn, payload)


    ###########################################################################
    @keyword(name="PCC.Ceph Create Erasure Pool Multiple")
    ###########################################################################
    def create_erasure_pool_multiple(self, *args, **kwargs):
        banner("PCC.Ceph Create Erasure Pool")
        self._load_kwargs(kwargs)

        print("Kwargs are: {}".format(kwargs))         
        if self.size:
            try:
                self.size= ast.literal_eval(str(self.size))
            except ValueError:
                print("Values is None or AlphaNumeric")

        if self.tags:
            self.tags=eval(self.tags)

        if self.count:
            self.count=int(self.count)
        
        if 'ErasureCodeProfileID' not in kwargs:
            self.ErasureCodeProfileID = None
        if 'name' not in kwargs:
            self.name = None
        if 'quota' not in kwargs:
            self.quota = None
        if 'quota_unit' not in kwargs:
            self.quota_unit = 'TiB'
        if 'Datachunks' and 'Codingchunks' not in kwargs:
            self.Datachunks = None
            self.Codingchunks = None
        
        name_bkup = self.name
        for i in range(1,self.count+1):
            name=str(name_bkup)+"-"+str(i)
            
            if self.pool_type == "data" and self.resilienceScheme == "erasure"  and self.Datachunks and self.Codingchunks:
                print("I am in 1")
                payload = {"name":name,
                          "type":self.pool_type,
                          "size":self.size,
                          "quota":self.quota,
                          "quota_unit":self.quota_unit,
                          "resilienceScheme":self.resilienceScheme,
                          "ceph_cluster_id":self.ceph_cluster_id,
                          "erasureCodeProfile":{"dataChunks":int(self.Datachunks), "codingChunks":int(self.Codingchunks), "stripeUnit":int(self.StripeUnit)},
                          "pgNum": int(self.pg_num)
                          }
            
            if self.pool_type == "data" and self.resilienceScheme == "erasure"  and self.ErasureCodeProfileID:
                print("I am in 2")
                payload = {"name":name,
                          "type":self.pool_type,
                          "size":self.size,
                          "quota":self.quota,
                          "quota_unit":self.quota_unit,
                          "resilienceScheme":self.resilienceScheme,
                          "ceph_cluster_id":self.ceph_cluster_id,
                          "erasureCodeProfileId":self.ErasureCodeProfileID,
                           "pgNum": int(self.pg_num)
                          }
            
            else:
                print("I am in 3")
                payload = {"name":name,
                    "size":self.size,
                    "tags":self.tags,
                    "ceph_cluster_id":self.ceph_cluster_id,
                    "type":self.pool_type,
                    "quota":self.quota,
                    "resilienceScheme":self.resilienceScheme,
                    "quota_unit":self.quota_unit,
                    "pgNum": int(self.pg_num)
                    }
            #payload = json.dumps(payload)        
            print(payload)
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            if self.count==i:
                return pcc.add_erasure_ceph_pool(conn, payload)
            else:
                response=pcc.add_erasure_ceph_pool(conn, payload)
                print(response)
                self.name=name
                status=self.wait_until_pool_ready()
            time.sleep(10)

    ###########################################################################
    @keyword(name="PCC.Ceph Delete Erasure Pool")
    ###########################################################################
    def delete_erasure_ceph_pool_by_id(self, *args, **kwargs):
        banner("PCC.Ceph Delete Erasure Pool")
        self._load_kwargs(kwargs)

        if self.id == None:
            return {"Error": "[PCC.Ceph Delete Erasure Pool]: Id of the ErasurePool is not specified."}
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")

        except Exception as e:
            raise e
        return pcc.delete_erasure_ceph_pool_by_id(conn,str(self.id))


    ###########################################################################
    @keyword(name="PCC.Ceph Wait Until Erasure Pool Ready")
    ###########################################################################
    def wait_until_erasure_pool_ready(self, *args, **kwargs):
        banner("PCC.Ceph Wait Until Erasure Pool Ready")
        self._load_kwargs(kwargs)
        
        if self.name == None:
            return None
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        pool_ready = False
        timeout = time.time() + PCCSERVER_TIMEOUT
  
        while pool_ready == False:
            response = pcc.get_erasure_ceph_pools(conn)
            
            for data in get_response_data(response):
                print("Data to look into: {}".format(data))
                print("Name to look: {}".format(self.name))
                print("Name found in data: {}".format(str(data['name'])))
                if str(data['name']).lower() == str(self.name).lower():
                    print(str(data))
                    if data['deploy_status'] == "completed":
                        pool_ready = True
                    if data['deploy_status'] == "failed":
                        return "Error"
                    
            if time.time() > timeout:
                raise Exception("[PCC.Ceph Wait Until Erasure Pool Ready] Timeout")
            trace("  Waiting until erasure pool : %s is Ready, currently: %s" % (data['name'], data['progressPercentage']))
            time.sleep(5)
        return "OK"


    ###########################################################################
    @keyword(name="PCC.Ceph Wait Until Erasure Pool Deleted")
    ###########################################################################
    def wait_until_erasure_pool_deleted(self, *args, **kwargs):
        banner("PCC.Ceph Wait Until Erasure Pool Deleted")

        self._load_kwargs(kwargs)

        if self.id == None:
            # pool doesn't exist, nothing to wait for
            return "OK"
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        Id_found_in_list_of_pools = True
        timeout = time.time() + PCCSERVER_TIMEOUT

        while Id_found_in_list_of_pools == True:
            Id_found_in_list_of_pools = False
            response = pcc.get_erasure_ceph_pools(conn)
            for pool in get_response_data(response):
                if str(pool['id']) == str(self.id):
                    name = pool["name"]
                    Id_found_in_list_of_pools = True
                    break
            if time.time() > timeout:
                raise Exception("[PCC.Wait Until Erasure Pool Deleted] Timeout")
            if Id_found_in_list_of_pools:
                trace("Waiting until node: %s is deleted. Timeout in %.1f seconds." % 
                       (name, timeout-time.time()))
                time.sleep(5)
            else:
                trace("Erasure Pool deleted!")
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Erasure Pool Verify BE")
    ###########################################################################
    def verify_erasure_ceph_pool_be(self, *args, **kwargs):
        ceph_be_cmd="sudo ceph osd lspools"
        banner("PCC.Ceph Erasure Pool Verify BE")
        self._load_kwargs(kwargs)
        print("Kwargs are: {}".format(kwargs))

        for ip in self.nodes_ip:
            print("Current IP is {}".format(ip))
            output=cli_run(ip,self.user,self.password,ceph_be_cmd)
            print("Output of command with ip : {} is : {}".format(ip, output))
            if re.search(self.name,str(output)):
                continue
            else:
                return None
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Erasure Pool Update")
    ###########################################################################
    def modify_erasure_ceph_pool(self, *args, **kwargs):
        self._load_kwargs(kwargs)

        print("Kwargs are: {}".format(kwargs)) 
        if self.size:
            try:
                self.size= ast.literal_eval(str(self.size))
            except ValueError:
                print("Values is None or AlphaNumeric")

        if self.tags:
            self.tags=eval(self.tags)
        if 'ErasureCodeProfileID' not in kwargs:
            self.ErasureCodeProfileID = None
        if 'name' not in kwargs:
            self.name = None
        if 'quota' not in kwargs:
            self.quota = None
        if 'quota_unit' not in kwargs:
            self.quota_unit = 'TiB'
        if 'Datachunks' and 'Codingchunks' not in kwargs:
            self.Datachunks = None
            self.Codingchunks = None
        
        try:
            
            
            if self.pool_type == "data" and self.resilienceScheme == "erasure"  and self.Datachunks and self.Codingchunks:
                print("I am in 1")
                payload = {"id":self.id,
                          "name":self.name,
                          "type":self.pool_type,
                          "size":self.size,
                          "quota":self.quota,
                          "resilienceScheme":self.resilienceScheme,
                          "quota_unit":self.quota_unit,
                          "ceph_cluster_id":self.ceph_cluster_id,
                          "erasureCodeProfile":{"dataChunks":int(self.Datachunks), "codingChunks":int(self.Codingchunks)},
                          "pgNum": int(self.pg_num)
                          }
                          
            elif self.pool_type == "data" and self.resilienceScheme == "erasure" and self.ErasureCodeProfileID:
                print("I am in 2")
                payload = {"id":self.id,  
                          "name":self.name,
                          "type":self.pool_type,
                          "size":self.size,
                          "quota":self.quota,
                          "resilienceScheme":self.resilienceScheme,
                          "quota_unit":self.quota_unit,
                          "ceph_cluster_id":self.ceph_cluster_id,
                          "erasureCodeProfileId":self.ErasureCodeProfileID,
                          "pgNum": int(self.pg_num)
                          }
                          
            else:
                print("I am in 3")
                payload = {"id":self.id,
                "name":self.name,
                "size":self.size,
                "tags":self.tags,
                "ceph_cluster_id":self.ceph_cluster_id,
                "type":self.pool_type,
                "resilienceScheme":self.resilienceScheme,
                "quota":self.quota,
                "quota_unit":self.quota_unit,
                "pgNum": int(self.pg_num)
                 }
            #payload = json.dumps(payload)
            print("Payload in update is : {}".format(payload))
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            trace("[update_erasure_pool] EXCEPTION: %s" % str(e))
            raise Exception(e)

        return pcc.modify_erasure_ceph_pool(conn, payload)
