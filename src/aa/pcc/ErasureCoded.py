import time
import os
import ast
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy

from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data, get_result
from aa.common.AaBase import AaBase
from aa.common.Cli import cli_run

class ErasureCoded(AaBase):
    """ 
    ErasureCoded
    """

    def __init__(self):
        
        self.Id = None
        self.Name = None
        self.Directory = None
        self.Plugin = None
        self.StripeUnit = None
        self.CrushFailureDomain = None
        self.DataChunks = None
        self.CodingChunks = None
        self.CephClusterId = None
        self.erasure_profile_list = None
        self.hostip = None
        self.username = "pcc"
        self.password = "cals0ft"
        self.erasure_pool_name = None
        self.rbd_name = None
        
        
        super().__init__()
        
    ###########################################################################
    @keyword(name="PCC.Ceph Get All Erasure Coded Profiles")
    ###########################################################################
    def get_erasure_ceph_erasure_coded_profiles(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get All Erasure Coded Profiles")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        response = get_response_data(pcc.get_all_erasure_code_profile(conn))
        return response
    
    
    
    ###########################################################################
    @keyword(name="PCC.Create Erasure Code Profile")
    ###########################################################################
    
    def erasure_code_profile_create(self, *args, **kwargs):
        """
        Add Erasure Code Profile
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (dict) data: erasure profile data 
                    {   
                      "name":"str",                             - Name of the profile
                      "directory":"str",                        - Name of the directory
                      "plugin":"str",                           - Plugin name
                      "stripeUnit":"str",                       - Stripe Unit  
                      "crushFailureDomain":"str",               - Crush Failure Domain name
                      "dataChunks":"int",                       - Total Chunks of data 
                      "codingChunks":"int",                     - Chunks to be divided into 
                      "cephClusterId":"int"                     - Ceph Cluster ID 
                    
                    }
        [Returns]
            (dict) Response: Add Erasure Code Profile response (includes any errors)
        """
        banner("PCC.Create Erasure Code Profile")
        self._load_kwargs(kwargs)
        
        payload = {
                "name":self.Name,
                "directory":self.Directory,
                "plugin":self.Plugin,
                "stripeUnit":self.StripeUnit,
                "crushFailureDomain":self.CrushFailureDomain,
                "dataChunks":int(self.DataChunks),
                "codingChunks":int(self.CodingChunks),
                "cephClusterId":int(self.CephClusterId)
                }
       
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.add_erasure_code_profile(conn, data=payload)
        
    ###########################################################################
    @keyword(name="PCC.Get Erasure Code Profile Id")
    ###########################################################################
    
    def get_erasure_code_profile_id(self, *args, **kwargs): 
        """
        Get Erasure code profile Id by Name
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Erasure code profile
        [Returns]
            (int) Id: Id of the matchining Certificate, or
                None: if no match found, or
            (dict) Error response: If Exception occured
        """
        banner("PCC.Get Erasure Code Profile Id")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return easy.get_erasure_code_profile_id_by_name(conn, Name=self.Name)
    
    ###########################################################################
    @keyword(name="PCC.Update Erasure Code Profile")
    ###########################################################################
    
    def erasure_code_profile_update(self, *args, **kwargs):
        """
        Modify Erasure Code Profile
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (dict) data: Erasure Code Profile data
                    {   
                      "id":"int",                               - Id of the erasure code profile 
                      "name":"str",                             - Name of the profile
                      "directory":"str",                        - Name of the directory
                      "plugin":"str",                           - Plugin name
                      "stripeUnit":"str",                       - Stripe Unit  
                      "crushFailureDomain":"str",               - Crush Failure Domain name
                      "dataChunks":"int",                       - Total Chunks of data 
                      "codingChunks":"int",                     - Chunks to be divided into 
                      "cephClusterId":"int"                     - Ceph Cluster ID 
                    
                    }
        [Returns]
            (dict) Response: Modify Erasure Code Profile response (includes any errors)
        """
        banner("PCC.Update Erasure Code Profile")
        self._load_kwargs(kwargs)
        
        payload = {
                "id":int(self.Id),
                "name":self.Name,
                "directory":self.Directory,
                "plugin":self.Plugin,
                "stripeUnit":self.StripeUnit,
                "crushFailureDomain":self.CrushFailureDomain,
                "dataChunks":int(self.DataChunks),
                "codingChunks":int(self.CodingChunks),
                "cephClusterId":int(self.CephClusterId)
                }
       
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.modify_erasure_code_profile(conn, data=payload)
        
    
    
    
    ###########################################################################
    @keyword(name="PCC.Delete Erasure Code Profile")
    ###########################################################################
    
    def delete_erasure_code_profile(self, *args, **kwargs):
        
        """
        Delete Erasure Code Profile from PCC
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Erasure code profile
        [Returns]
            (int) Profile Id: Profile Id of the erasure code
            (dict) Error response: If Exception occured
        """
        banner("PCC.Delete Erasure Code Profile")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        
        profile_id = easy.get_erasure_code_profile_id_by_name(conn, Name=self.Name)
        return pcc.delete_erasure_code_profile_by_id(conn, Id= str(profile_id))
        
    ###########################################################################
    @keyword(name="PCC.Delete Multiple Erasure Code Profiles")
    ###########################################################################
    
    def delete_multiple_erasure_code_profile(self, *args, **kwargs):
        
        """
        Delete Multiple Erasure Code Profile from PCC
        [Args]
            (dict) conn: Connection dictionary obtained after logging in
            (str) Name: Name of the Erasure code profile
        [Returns]
            (int) Profile Id: Profile Id of the erasure code
            (dict) Error response: If Exception occured
        """
        banner("PCC.Delete Erasure Code Profile")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        if self.erasure_profile_list:
            erasure_profile_list = ast.literal_eval(self.erasure_profile_list)
            try:
                for profile in erasure_profile_list:
                    response = self.delete_erasure_code_profile(conn, Name= profile)
                    if response['StatusCode'] == 200:
                        continue
                    else:
                        return Error
                return "OK"   
            except Exception as e:
                return {"Error: {}".format(e)}
        else:
            try:
                response = pcc.get_all_erasure_code_profile(conn)
                list_id = []
                
                if get_response_data(response) == []:
                    return "OK"
                else:
                    for ids in get_response_data(response):
                        list_id.append(ids['id'])
                    print("list of id:{}".format(list_id))
                    for id_ in list_id:
                        response = pcc.delete_erasure_code_profile_by_id(conn, Id= str(id_))
                        
                deletion_status = False
                counter = 0
                while deletion_status == False:
                    counter+=1
                    response = pcc.get_all_erasure_code_profile(conn)
                    if get_response_data(response) != []:
                        time.sleep(5)
                        banner("All Erasure profiles not yet deleted")
                        if counter < 50:
                            banner("Counter: {}".format(counter))
                            continue
                        else:
                            trace("Error: ['Timeout']")
                            break
                    elif get_response_data(response) == []:
                        deletion_status = True
                        banner("All Erasure profiles deleted successfully")
                        return "OK"
                    else:
                        banner("Entered into continuous loop")
                        return "Error"
        
            except Exception as e:
                trace("Error in delete_all_node_groups status: {}".format(e))
                
    ###############################################################################################################
    @keyword(name="PCC.Get CEPH Inet IP")
    ###############################################################################################################
    
    def get_ceph_inet_ip(self, *args, **kwargs):
        banner("Get CEPH Inet IP")
        self._load_kwargs(kwargs)
        try:
            cmd= "ip addr | grep ceph0"
            
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_status = self._serialize_response(time.time(), status)
            print("serialised_inet_ip_status is:{}".format(serialised_status))
            
            cmd_output = str(serialised_check_replicated_pool['Result']['stdout']).replace('\n', '').strip()
            re_match = re.findall("inet (.*) brd", cmd_output)
            inet_ip = str(re_match).split("/")[0]
            
            return inet_ip
        except Exception as e:
            trace("Error in get_ceph_inet_ip: {}".format(e))            
    
    
    
    
    
                
    ###############################################################################################################
    @keyword(name="PCC.Check Replicated Pool Creation After Erasure Pool RBD Creation")
    ###############################################################################################################
    
    def check_replicated_pool_creation(self, *args, **kwargs):
        banner("Check Replicated Pool Creation After Erasure Pool RBD Creation")
        self._load_kwargs(kwargs)
        try:
            cmd= "sudo ceph osd lspool"
            
            check_replicated_pool = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_check_replicated_pool = self._serialize_response(time.time(), check_replicated_pool)
            print("serialised_check_replicated_pool is:{}".format(serialised_check_replicated_pool))
            
            cmd_output = str(serialised_check_replicated_pool['Result']['stdout']).replace('\n', '').strip()
            replicated_pool = str(self.erasure_pool_name) + "-hs"
            if replicated_pool in str(cmd_output):
                return "OK"
            else:
                return "Error"
        except Exception as e:
            trace("Error in check_replicated_pool_creation: {}".format(e))
            
    ###############################################################################################################
    @keyword(name="PCC.Get Stored Size for Replicated Pool and Erasure Pool")
    ###############################################################################################################
    
    def get_stored_size(self, *args, **kwargs):
        banner("Get Stored Size for Replicated Pool and Erasure Pool")
        self._load_kwargs(kwargs)
        try:
            replicated_pool = str(self.erasure_pool_name) + "-hs"
            cmd= "sudo ceph df detail | grep {}".format(self.erasure_pool_name)
            erasure_pool_stored_size = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_erasure_pool_stored_size = self._serialize_response(time.time(), erasure_pool_stored_size)
            print("serialised_stored_size is:{}".format(serialised_erasure_pool_stored_size))
            
            cmd_output = str(serialised_erasure_pool_stored_size['Result']['stdout']).replace('\n', '').strip()
            return cmd_output
            
            cmd= "sudo ceph df detail | grep {}".format(replicated_pool)
            replicated_pool_stored_size = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_replicated_pool_stored_size = self._serialize_response(time.time(), replicated_pool_stored_size)
            print("serialised_stored_size is:{}".format(serialised_replicated_pool_stored_size))
            
            cmd_output = str(serialised_replicated_pool_stored_size['Result']['stdout']).replace('\n', '').strip()
            
            
            
            
            '''
            if replicated_pool in str(cmd_output):
                return True
            else:
                return False
            '''    
        except Exception as e:
            trace("Error in get_stored_size: {}".format(e))
            
    ###############################################################################################################
    @keyword(name="PCC.Mount RBD to Mount Point")
    ###############################################################################################################
    
    def mount_rbd(self, *args, **kwargs):
        banner("Mount RBD to Mount Point")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            
            inet_ip = self.get_ceph_inet_ip()
            cmd= "rbd feature disable {}/{} object-map fast-diff deep-flatten".format(self.erasure_pool_name, self.rbd_name)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd1: {} executed successfully".format(cmd))
            
            cmd= "rbd map {} --pool {} --name client.admin -m {} -k /etc/ceph/ceph.client.admin.keyring".format(self.rbd_name, self.erasure_pool_name, inet_ip)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd2: {} executed successfully".format(cmd))
            
            cmd= "sudo mkdir /mnt/test_rbd_mnt"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd3: {} executed successfully".format(cmd))
            
            cmd= "sudo mount /dev/rbd0 /mnt/test_rbd_mnt".format(self.erasure_pool_name, self.rbd_name)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd4: {} executed successfully".format(cmd))
            
            cmd= "dd if=/dev/zero of=test_rbd_mnt_1gb.bin bs=1GiB count=1"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd5: {} executed successfully".format(cmd))
            
            cmd= "cp /home/pcc/test_rbd_mnt_1gb.bin /mnt/test_rbd_mnt"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd6: {} executed successfully".format(cmd))
            
            return "OK"
            
        except Exception as e:
            trace("Error in mount_rbd: {}".format(e))
    
    ###############################################################################################################
    @keyword(name="PCC.Flush replicated pool storage to erasure coded pool")
    ###############################################################################################################
    
    def flush_storage(self, *args, **kwargs):
        banner("Flush replicated pool storage to erasure coded pool")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            replicated_pool = str(self.erasure_pool_name) + "-hs"
            
            cmd= "rados -p {} cache-flush-evict-all".format(replicated_pool)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd: {} executed successfully".format(cmd))
            
            return "OK"
        
        except Exception as e:
            trace("Error in flush_storage: {}".format(e))
    
            
            
    
            
            
            
            
            
            
            
            
            
            
    
            
    
            
        
        
    
        
    
    
