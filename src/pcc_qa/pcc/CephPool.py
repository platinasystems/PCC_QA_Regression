import re
import time
import json
import ast

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print, convert
from pcc_qa.common.Result import get_response_data, get_status_code
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60 * 3

class CephPool(PccBase):

    def __init__(self):

        # Robot arguments definitions
        self.id = None
        self.ceph_cluster_id = None
        self.name = ""
        self.size = None
        self.tags = []
        self.pool_type = ""
        self.quota = None
        self.quota_unit = ""
        self.user = "pcc"
        self.password="cals0ft"
        self.nodes_ip = []
        self.count = 0
        self.pool_name = None
        self.hostip = None
        self.storage_pool_id = None
        self.mode = None
        self.type = None
        self.data_pool_name = None
        self.cache_pool_name = None
        self.resilienceScheme = None
        self.filename = ""
        self.used_by_type = ""
        self.used_by_name = ""
        self.pg_num = 8
        self.no_deep_scrub = False
        self.no_scrub = False
        self.recovery_priority = 10
        self.recovery_op_priority = 5

        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Ceph Get Pool Id")
    ###########################################################################
    def get_ceph_pool_id_by_name(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        pool_id= None
        banner("PCC.Ceph Get Pool Id")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        pool_id = easy.get_ceph_pool_id_by_name(conn,self.name)
        return pool_id

    ###########################################################################
    @keyword(name="PCC.Ceph Pool Check Used By")
    ###########################################################################
    def check_used_by(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Pool Check Used By")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        response = get_response_data(pcc.get_ceph_pools_by_cluster_id(conn, str(self.ceph_cluster_id)))
        for pool in response:
            if pool["name"] == self.name:
                if self.used_by_type == "rbd":
                    cephRBD = pool["cephRBD"]
                    if cephRBD and cephRBD["name"] == self.used_by_name:
                        return "OK"
                if self.used_by_type == "fs":
                    cephFS = pool["cephFS"]
                    if cephFS and cephFS["name"] == self.used_by_name:
                        return "OK"
                if self.used_by_type == "rgw":
                    cephRGW = pool["cephRgw"]
                    if cephRGW and cephRGW["name"] == self.used_by_name:
                        return "OK"
        return "Error"

    ###########################################################################
    @keyword(name="PCC.Ceph Get All Pools Data")
    ###########################################################################
    def get_ceph_all_pools_data(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        pool_id= None
        banner("PCC.Ceph Get All Pool Data")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        response = get_response_data(pcc.get_ceph_pools(conn))
        return response

    ###########################################################################
    @keyword(name="PCC.Ceph Delete All Pools")
    ###########################################################################
    def delete_all_pools(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Delete All Pool")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        response = pcc.get_ceph_pools(conn)
        for data in get_response_data(response):
            if data['managed']:
                response=pcc.delete_ceph_pool_by_id(conn,str(data['id']),"")
                trace(response)
                status_code = get_status_code(response)
                if status_code == 202:
                    code = get_response_data(response)["code"]
                    response = pcc.delete_ceph_pool_by_id(conn, str(data['id']), "?code="+code)
                    if response['Result']['status'] == 200:
                        status=self.wait_until_pool_deleted(id=data['id'])
                        if status!="OK":
                            print("{} deletion failed".format(data['name']))
                            return "Error"
                    else:
                        return "Error"
                else:
                    return "Error"
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Delete Unused Pools")
    ###########################################################################
    def delete_unused_pools(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Delete Unused Pool")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        response = pcc.get_ceph_pools_by_cluster_id(conn, str(self.ceph_cluster_id))
        if get_response_data(response):
            for data in get_response_data(response):
                if data.get('managed') and not data.get('cephFS') and not data.get('cephRBD') and not data.get('cephRgw'):
                    response=pcc.delete_ceph_pool_by_id(conn,str(data['id']),"")
                    trace(response)
                    status_code = get_status_code(response)
                    if status_code == 202:
                        code = get_response_data(response)["code"]
                        response = pcc.delete_ceph_pool_by_id(conn, str(data['id']), "?code="+code)
                        if response['Result']['status'] == 200:
                            status=self.wait_until_pool_deleted(id=data['id'])
                            if status != "OK":
                                print("{} deletion failed".format(data['name']))
                                return "Error"
                        else:
                            return "Error"
                    else:
                        return "Error"
        return "OK"


    ###########################################################################
    @keyword(name="PCC.Ceph Get Pool Details For FS")
    ###########################################################################
    def get_pool_details_for_fs(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Pool Details For FS")

        temp=dict()        

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        response = pcc.get_ceph_pools(conn)['Result']['Data']
        print("Response:-"+str(response))
        for data in response:
            if str(data['name']) == str(self.name):
                temp["id"] = data["id"]
                temp["name"]= data["name"]
                temp["size"] = data["size"]
                temp["tags"] = []
                temp["ceph_cluster_id"] = data["ceph_cluster_id"]
                temp["type"] = data["type"]
                temp["resilienceScheme"] = data["resilienceScheme"]
                temp["quota"] = data["quota"]
                temp["quota_unit"] =  data["quota_unit"]
        return temp

    ###########################################################################
    @keyword(name="PCC.Ceph Get Multiple Pool Details For FS")
    ###########################################################################
    def get_multiple_pool_details_for_fs(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Pool Details For FS")

        temp=dict()
        temp_list=[]        

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        
        response = pcc.get_ceph_pools(conn)['Result']['Data']    
        for val in eval(str(self.name)):
            for data in response:
                if str(data['name']) == str(val):
                    temp["id"] = data["id"]
                    temp["name"]= data["name"]
                    temp["size"] = data["size"]
                    temp["tags"] = ["tags"]
                    temp["ceph_cluster_id"] = data["ceph_cluster_id"]
                    temp["type"] = data["type"]
                    temp["resilienceScheme"] = data["resilienceScheme"]
                    temp["quota"] = data["quota"]
                    temp["quota_unit"] =  data["quota_unit"]
            if len(temp)!=0:        
                temp_list.append(temp)
        return temp_list

    ###########################################################################
    @keyword(name="PCC.Ceph Create Pool")
    ###########################################################################
    def add_ceph_pool(self, *args, **kwargs):
        banner("PCC.Ceph Create Pool")
        self._load_kwargs(kwargs)

        if self.size:
            try:
                self.size= ast.literal_eval(str(self.size))
            except ValueError:
                print("Values is None or AlphaNumeric")

        if self.tags:
            self.tags=eval(self.tags)


        payload = {
            "name":self.name,
            "size":self.size,
            "tags":self.tags,
            "ceph_cluster_id":self.ceph_cluster_id,
            "type":self.pool_type,
            "resilienceScheme":self.resilienceScheme,
            "quota":self.quota,
            "quota_unit":self.quota_unit,
            "pgNum":self.pg_num,
            "noDeepScrubDesired": self.no_deep_scrub,
            "noScrubDesired": self.no_scrub,
            "recoveryPriorityDesired": self.recovery_priority,
            "recoveryOpPriorityDesired": self.recovery_op_priority
        }

        print(payload)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.add_ceph_pool(conn, payload)


    ###########################################################################
    @keyword(name="PCC.Ceph Create Pool Multiple")
    ###########################################################################
    def create_pool_multiple(self, *args, **kwargs):
        banner("PCC.Ceph Create Pool")
        self._load_kwargs(kwargs)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        if self.size:
            try:
                self.size= ast.literal_eval(str(self.size))
            except ValueError:
                print("Values is None or AlphaNumeric")

        if self.tags:
            self.tags=eval(self.tags)

        if self.count:
            self.count=int(self.count)

        name_bkup = self.name
        result = "OK"
        for i in range(1,self.count+1):
            name=str(name_bkup)+"-"+str(i)
            payload = {
                "name":name,
                "size":self.size,
                "tags":self.tags,
                "ceph_cluster_id":self.ceph_cluster_id,
                "type":self.pool_type,
                "resilienceScheme":self.resilienceScheme,
                "quota":self.quota,
                "quota_unit":self.quota_unit,
                "pgNum": self.pg_num,
                "noDeepScrubDesired": self.no_deep_scrub,
                "noScrubDesired": self.no_scrub,
                "recoveryPriorityDesired": self.recovery_priority,
                "recoveryOpPriorityDesired": self.recovery_op_priority
                }
            print(payload)
            response = pcc.add_ceph_pool(conn, payload)
            print(response)
            self.name = name
            status = self.wait_until_pool_ready()
            if status is not "OK":
                result = "Error"
        return result

    ###########################################################################
    @keyword(name="PCC.Ceph Delete Pool")
    ###########################################################################
    def delete_ceph_pool_by_id(self, *args, **kwargs):
        banner("PCC.Ceph Delete Pool")
        self._load_kwargs(kwargs)

        if self.id == None:
            return {"Error": "[PCC.Ceph Delete Pool]: Id of the Pool is not specified."}
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")

        except Exception as e:
            raise e

        response = pcc.delete_ceph_pool_by_id(conn, str(self.id), "")
        status_code = get_status_code(response)
        if status_code == 202:
            code = get_response_data(response)["code"]
            return pcc.delete_ceph_pool_by_id(conn, str(self.id), "?code=" + code)
        return response



    ###########################################################################
    @keyword(name="PCC.Ceph Wait Until Pool Ready")
    ###########################################################################
    def wait_until_pool_ready(self, *args, **kwargs):
        banner("PCC.Ceph Wait Until Pool Ready")
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
            response = pcc.get_ceph_pools(conn)
            if time.time() > timeout:
                return "[PCC.Ceph Wait Until Pool Ready] Timeout"
            for data in get_response_data(response):
                if str(data['name']).lower() == str(self.name).lower():
                    print(str(data))
                    if data['deploy_status'] == "completed":
                        pool_ready = True
                        return "OK"
                    if data['deploy_status'] == "failed":
                        return "Error"
                    else:
                        trace(" Waiting until pool : %s is Ready, currently: %s" % (data['name'], data['progressPercentage']))
                        time.sleep(5)



    ###########################################################################
    @keyword(name="PCC.Ceph Wait Until Pool Deleted")
    ###########################################################################
    def wait_until_pool_deleted(self, *args, **kwargs):
        banner("PCC.Ceph Wait Until Pool Deleted")

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
            response = pcc.get_ceph_pools(conn)
            for pool in get_response_data(response):
                if str(pool['id']) == str(self.id):
                    name = pool["name"]
                    Id_found_in_list_of_pools = True
            if time.time() > timeout:
                raise Exception("[PCC.Wait Until Pool Deleted] Timeout")
            if Id_found_in_list_of_pools:
                trace("Waiting until node: %s is deleted. Timeout in %.1f seconds." % 
                       (name, timeout-time.time()))
                time.sleep(5)
            else:
                trace("Pool deleted!")
        time.sleep(10)
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Pool Verify BE")
    ###########################################################################
    def verify_ceph_pool_be(self, *args, **kwargs):
        ceph_be_cmd="sudo ceph osd lspools"
        pool_params="sudo ceph osd pool get {pool} pg_num;".format(pool=self.name) \
                    + "sudo ceph osd pool get {pool} noscrub;".format(pool=self.name) \
                    + "sudo ceph osd pool get {pool} nodeep-scrub;".format(pool=self.name) \
                    + "sudo ceph osd pool get {pool} recovery_priority;".format(pool=self.name) \
                    + "sudo ceph osd pool get {pool} recovery_op_priority;".format(pool=self.name)

        banner("PCC.Ceph Pool Verify BE")
        self._load_kwargs(kwargs)
        pg_num= "pg_num: {}".format(self.pg_num)
        no_scrub= "noscrub: {}".format(self.no_scrub).lower()
        nodeep_scrub= "nodeep-scrub: {}".format(self.no_deep_scrub).lower()
        recovery_priority = "recovery_priority: {}".format(self.recovery_priority)
        recovery_op_priority = "recovery_op_priority: {}".format(self.recovery_op_priority)


        output = cli_run(self.hostip, self.user, self.password, ceph_be_cmd).stdout
        if re.search(self.name, output):
            output = cli_run(self.hostip, self.user, self.password, pool_params).stdout
            trace(output)
            if (re.search(pg_num, output) and
                re.search(no_scrub, output) and
                re.search(nodeep_scrub, output) and
                re.search(recovery_priority, output) and
                re.search(recovery_op_priority, output)):
                return "OK"
            else:
                return "Error"
        else:
            return "Error"

    ###########################################################################
    @keyword(name="PCC.Ceph Pool Update")
    ###########################################################################
    def modify_ceph_pool(self, *args, **kwargs):
        self._load_kwargs(kwargs)

        if self.size:
            try:
                self.size= ast.literal_eval(str(self.size))
            except ValueError:
                print("Values is None or AlphaNumeric")

        if self.tags:
            self.tags=eval(self.tags)

        try:
            payload = {
            "id":self.id,
            "name":self.name,
            "size":self.size,
            "tags":self.tags,
            "ceph_cluster_id":self.ceph_cluster_id,
            "type":self.pool_type,
            "resilienceScheme":self.resilienceScheme,
            "quota":self.quota,
            "quota_unit":self.quota_unit,
            "managed":True,
            "pgNum": self.pg_num,
            "noDeepScrubDesired": self.no_deep_scrub,
            "noScrubDesired": self.no_scrub,
            "recoveryPriorityDesired": self.recovery_priority,
            "recoveryOpPriorityDesired": self.recovery_op_priority
             }

            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            print(str(payload))
        except Exception as e:
            trace("[update_pool] EXCEPTION: %s" % str(e))
            raise Exception(e)

        return pcc.modify_ceph_pool(conn, payload)
        
    ###############################################################################################################
    @keyword(name="PCC.Get Stored Size for Replicated Pool")
    ###############################################################################################################
    
    def get_stored_size_replicated_pool(self, *args, **kwargs):
        banner("Get Stored Size for Replicated Pool")
        self._load_kwargs(kwargs)
        try:
            cmd= "sudo ceph df detail | grep -w {}".format(self.pool_name)
            replicated_pool_stored_size = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
            serialised_replicated_pool_stored_size = self._serialize_response(time.time(), replicated_pool_stored_size)
            cmd_output = str(serialised_replicated_pool_stored_size['Result']['stdout']).replace('\n', '').strip()
            
            splitting = cmd_output.split()
            print("splitting: {}".format(splitting))
            
            print("value of replicated pool: {}".format(splitting[3]))
            print("Size of replicated pool: {}".format(splitting[4]))
            
            size_of_replicated_pool = convert(eval(splitting[3]), splitting[4])
            print("Size of replicated pool is: {}".format(size_of_replicated_pool))
            
            return size_of_replicated_pool
            
        except Exception as e:
            trace("Error in get_stored_size_replicated_pool: {}".format(e))

    ###########################################################################
    @keyword(name="PCC.Ceph Get All Cache Pools Data")
    ###########################################################################
    def get_ceph_all_cache_pools_data(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get All Cache Pools Data")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        response = get_response_data(pcc.get_ceph_pool_caches(conn))
        return response
		
    ###########################################################################
    @keyword(name="PCC.Ceph Get Cache Pool By Cache Pool Id")
    ###########################################################################
    def get_ceph_cache_pool_by_cache_pool_id(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Cache Pool By Cache Pool Id")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        response = get_response_data(pcc.get_ceph_cache_pool_by_cache_id(conn, self.id))
        return response

    ###########################################################################
    @keyword(name="PCC.Ceph Add Cache Pool")
    ###########################################################################
    def add_ceph_cache_pool(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Add Cache Pool")
        trace("Kwargs are: {}".format(kwargs))
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        payload = { "storagePoolID": int(self.storage_pool_id),
                    "name": self.name,
                    "type": self.type,
                    "size": int(self.size),
                    "quota": self.quota,
                    "quota_unit": self.quota_unit,
                    "tags":ast.literal_eval(self.tags),
                    "resilienceScheme":self.resilienceScheme,
                    "ceph_cluster_id":self.ceph_cluster_id
		  }
        trace("Payload is :{}".format(payload))
        response = pcc.add_ceph_cache_pool(conn,payload)
        trace("Response is : {}".format(response))
        return response
		
    ###########################################################################
    @keyword(name="PCC.Ceph Update Cache Pool")
    ###########################################################################
    def update_ceph_cache_pool(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Update Cache Pool")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        payload = { "storagePoolID": int(self.storage_pool_id),
                    "name": self.name,
                    "type": self.type,
                    "size": int(self.size),
                    "quota": self.quota,
                    "quotaUnit": self.quota_unit,
                    "tags":ast.literal_eval(self.tags),
                    "resilienceScheme":self.resilienceScheme,
                    "ceph_cluster_id":self.ceph_cluster_id
                  }
        response = pcc.update_ceph_cache_pool(conn, data=payload,id=str(self.id))
        return response
		
    ###########################################################################
    @keyword(name="PCC.Ceph Delete Cache Pool")
    ###########################################################################
    def delete_ceph_cache_pool(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Delete Cache Pool")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
		
        response = get_response_data(pcc.delete_ceph_cache_pool_by_id(conn, str(id)))
        return response

    ###########################################################################
    @keyword(name="PCC.Ceph Validate storage and cache pool relation")
    ###########################################################################
    def validate_storage_and_cache_pool_relation(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Validate storage and cache pool relation")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        validation=[]
        get_all_pools_response = pcc.get_ceph_pools_by_cluster_id(conn,str(self.ceph_cluster_id))
        trace("get_all_pools_response: {}".format(get_all_pools_response))
        for data in get_response_data(get_all_pools_response):
            if (data['name']==self.data_pool_name) and (data['cachePool']['name']==self.cache_pool_name):
                validation.append("OK")
            if (data['name']==self.cache_pool_name) and (data['storagePool']['name']==self.data_pool_name):
                validation.append("OK")
        trace("Validation status: {}".format(validation))
        if (len(validation)==2) and (len(validation) > 0 and all(elem == "OK" for elem in validation)):
            return "OK"
        else:
            return "Validation failed for datapool- {} and cache_pool- {}".format(self.data_pool_name,self.cache_pool_name)



    ###########################################################################
    @keyword(name="PCC.Ceph Pool Add File By Size")
    ###########################################################################
    def add_file_to_pool_by_size(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Pool Add File By Size")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        file_name = self.size + "_file"
        cmd = "fallocate -l {} {}".format(self.size, file_name)
        out = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user, linux_password=self.password)
        cmd = "sudo rados -p {} put {} {}".format(self.name, file_name, file_name)
        out = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user, linux_password=self.password)
        cmd = "rm {}".format(file_name)
        out = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user, linux_password=self.password)
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Pool Delete File By Name")
    ###########################################################################
    def delete_file_from_pool(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Pool Delete File By Name")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        cmd = "sudo rados -p {} rm {}".format(self.name, self.filename)
        out = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user, linux_password=self.password)
        return "OK"