import time
import os
import re
import ast
from robot.api.deco import keyword
from robot.api import logger
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
        
    ## Size converter function
    def convert(self,value, size):
        converter = {'B':1 * value,
                     'KiB':10 * value,
                     'MiB':100 * value,
                     'GiB':1000 * value,
                     'TiB':10000 * value,
                     'PiB':100000 * value,
                     'EiB':1000000 * value,
                     'KB': 10 * value,
                     'MB': 100 * value,
                     'GB': 1000 * value,
                     'TB': 10000 * value,
                     'PB': 100000 * value,
                     'EB': 1000000 * value
                     }
        if size in converter:
            return converter[size]
        else:
            return "Size not found in the list"
    
    
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
            cmd= "ip addr | grep control0"
            
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_status = self._serialize_response(time.time(), status)
            print("serialised_inet_ip_status is:{}".format(serialised_status))
            
            cmd_output = str(serialised_status['Result']['stdout']).replace('\n', '').strip()
            re_match = re.findall("inet (.*) scope", cmd_output)
            inet_ip = str(re_match).split("/")[0]
            
            return inet_ip.replace("['","")
        except Exception as e:
            trace("Error in get_ceph_inet_ip: {}".format(e))            
                
    ###############################################################################################################
    @keyword(name="PCC.Check Replicated Pool Creation After Erasure Pool RBD/FS Creation")
    ###############################################################################################################
    
    def check_replicated_pool_creation(self, *args, **kwargs):
        banner("Check Replicated Pool Creation After Erasure Pool RBD Creation")
        self._load_kwargs(kwargs)
        print("Kwargs are: {}".format(kwargs))
        print("Username: {}".format(self.username))
        print("Password: {}".format(self.password))
        try:
            cmd= "sudo ceph osd lspools"
            
            check_replicated_pool = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("check_replicated_pool output: {}".format(check_replicated_pool))
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
            cmd= "sudo ceph df detail | grep -w {}".format(self.erasure_pool_name)
            erasure_pool_stored_size = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_erasure_pool_stored_size = self._serialize_response(time.time(), erasure_pool_stored_size)
            
            cmd_output = str(serialised_erasure_pool_stored_size['Result']['stdout']).replace('\n', '').strip()
            
            splitting = cmd_output.split()
            
            print("value of erasure_pool: {}".format(splitting[2]))
            print("Size of erasure_pool: {}".format(splitting[3]))
            
            size_of_erasure_pool = self.convert(eval(splitting[2]), splitting[3])
            print("Size of erasure pool is: {}".format(size_of_erasure_pool)) 
            
            
            cmd= "sudo ceph df detail | grep -w {}".format(replicated_pool)
            erasure_pool_stored_size = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_erasure_pool_stored_size = self._serialize_response(time.time(), erasure_pool_stored_size)
            
            cmd_output = str(serialised_erasure_pool_stored_size['Result']['stdout']).replace('\n', '').strip()
            
            splitting = cmd_output.split()
            
            print("value of replicated pool: {}".format(splitting[2]))
            print("Size of replicated pool: {}".format(splitting[3]))
            
            size_of_replicated_pool = self.convert(eval(splitting[2]), splitting[3])
            print("Size of erasure pool is: {}".format(size_of_replicated_pool))
            
            
            return [size_of_erasure_pool, size_of_replicated_pool]
            
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
            
            inet_ip = self.get_ceph_inet_ip(**kwargs)
            print("Inet IP is : {}".format(inet_ip))
            
            #Maps rbd0
            cmd= "sudo rbd map {} --pool {} --name client.admin -m {} -k /etc/ceph/ceph.client.admin.keyring".format(self.rbd_name, self.erasure_pool_name, inet_ip)
            
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd1: {} executed successfully and status is:{}".format(cmd,status))
            
            time.sleep(2)
            
            #mkfs.ext4 rbd0 command execution
            cmd= "sudo mkfs.ext4 -m0 /dev/rbd0"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd2: {} executed successfully and status is:{}".format(cmd,status))
            
            time.sleep(2)
            
            #creating test_rbd_mnt folder
            cmd= "sudo mkdir /mnt/test_rbd_mnt"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd3: {} executed successfully and status is:{}".format(cmd,status))
            
            time.sleep(2)
            
            #Mounting to test_rbd_mnt to rbd0
            cmd= "sudo mount /dev/rbd0 /mnt/test_rbd_mnt".format(self.erasure_pool_name, self.rbd_name)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd4: {} executed successfully and status is:{}".format(cmd,status))
            
            time.sleep(2)
            
            #Creating sample 10mb file
            cmd= "sudo dd if=/dev/zero of=test_rbd_mnt_10mb.bin bs=10MiB count=1"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd5: {} executed successfully and status is:{}".format(cmd,status))
            
            time.sleep(2)
            
            #Copying sample 10mb file to test_rbd_mnt folder
            cmd= "sudo cp /home/pcc/test_rbd_mnt_10mb.bin /mnt/test_rbd_mnt"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd6: {} executed successfully and status is:{}".format(cmd,status))
            
            time.sleep(2)
            
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
            
            cmd= "sudo rados -p {} cache-flush-evict-all".format(replicated_pool)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd: {} executed successfully and status is : {}".format(cmd,status))
            
            return "OK"
        
        except Exception as e:
            trace("Error in flush_storage: {}".format(e))
            
    ###############################################################################################################
    @keyword(name="PCC.Mount FS to Mount Point")
    ###############################################################################################################
    
    def mount_fs(self, *args, **kwargs):
        banner("Mount FS to Mount Point")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            
            inet_ip = self.get_ceph_inet_ip(**kwargs)
            print("Inet IP is: {}".format(inet_ip))
            
            #creating test_rbd_mnt folder
            cmd= "sudo mkdir /mnt/test_fs_mnt"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd1: {} executed successfully and status is: {}".format(cmd, status))
            
            #Maps fs
            cmd= "sudo mount -t ceph {}:/ /mnt/test_fs_mnt -o name=admin,secret='ceph-authtool -p /etc/ceph/ceph.client.admin.keyring'".format(inet_ip)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd2: {} executed successfully and status is: {}".format(cmd, status))
            
            time.sleep(1)
            
            cmd= "sudo mount| grep test_fs_mnt"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd3: {} executed successfully and status is: {}".format(cmd, status))
            serialised_status = self._serialize_response(time.time(), status)
            cmd_output = str(serialised_status['Result']['stdout']).replace('\n', '').strip()
            
            if '/mnt/test_fs_mnt' in cmd_output:
                print("Found in string") 
            else:
                return "Error: test_fs_mnt file not found"
            
            #Creating sample 10mb file
            cmd= "sudo dd if=/dev/zero of=test_fs_mnt_10mb.bin bs=10MiB count=1"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd4: {} executed successfully and status is: {}".format(cmd, status))
            
            time.sleep(2)
            
            #Copying sample 10mb file to test_fs_mnt folder
            cmd= "sudo cp /home/pcc/test_fs_mnt_10mb.bin /mnt/test_fs_mnt"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd5: {} executed successfully and status is:{}".format(cmd,status))
            
            time.sleep(2)
            
            return "OK"
            
        except Exception as e:
            trace("Error in mount_fs: {}".format(e))
            
    ###############################################################################################################
    @keyword(name="PCC.Check FS Mount on other server")
    ###############################################################################################################
    
    def check_fs_mount(self, *args, **kwargs):
        banner("PCC.Check FS Mount on other server")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            print("username is '{}' and password is: '{}'".format(self.username,self.password))
            inet_ip = self.get_ceph_inet_ip(**kwargs)
            
            cmd= "sudo mkdir /mnt/test_fs_mnt"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd1: {} executed successfully and status is: {}".format(cmd, status))
            
            cmd= "sudo mount -t ceph {}:/ /mnt/test_fs_mnt -o name=admin,secret='ceph-authtool -p /etc/ceph/ceph.client.admin.keyring'".format(inet_ip)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd2: {} executed successfully and status is: {}".format(cmd, status))
            
            cmd= "sudo ls /mnt/test_fs_mnt".format(self.erasure_pool_name, self.rbd_name)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd3: {} executed successfully and status is: {}".format(cmd, status))
            
            serialised_status = self._serialize_response(time.time(), status)
            cmd_output = str(serialised_status['Result']['stdout']).replace('\n', '').strip()
            
            if 'test_fs_mnt_10mb.bin' in cmd_output:
                print("Data Found in output") 
            else:
                return "Error: 'test_fs_mnt_10mb.bin' file not found"
            
            return "OK"
            
        except Exception as e:
            trace("Error in check_fs_mount: {}".format(e))
    
    ###############################################################################################################
    @keyword(name="PCC.Unmount FS")
    ###############################################################################################################
    
    def unmount_fs(self, *args, **kwargs):
        banner("PCC.Unmount FS")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            print("username is '{}' and password is: '{}'".format(self.username,self.password))
            cmd= "sudo umount /mnt/test_fs_mnt"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd1: {} executed successfully and status is : {}".format(cmd,status))
        
            cmd= "sudo rm -rf /mnt/test_fs_mnt/"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd2: {} executed successfully and status is : {}".format(cmd,status))
            
            cmd= "sudo rm test_fs_mnt_10mb.bin"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd3: {} executed successfully and status is : {}".format(cmd,status))
            
            return "OK"
            
        except Exception as e:
            trace("Error in unmount_and_unmap_rbd: {}".format(e))
    
    
    
    ###############################################################################################################
    @keyword(name="PCC.Unmount and Unmap RBD")
    ###############################################################################################################
    
    def unmount_and_unmap_rbd(self, *args, **kwargs):
        banner("PCC.Unmount and Unmap RBD")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            cmd= "sudo umount /mnt/test_rbd_mnt"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd1: {} executed successfully and status is : {}".format(cmd,status))
            logger.console("cmd1: {} executed successfully and status is : {}".format(cmd,status))
            time.sleep(60*1) # Sleep for 2 minutes
            
            cmd= "sudo rbd unmap /dev/rbd0"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd2: {} executed successfully and status is : {}".format(cmd,status))
            logger.console("cmd2: {} executed successfully and status is : {}".format(cmd,status))
            time.sleep(60*1) # Sleep for 2 minutes
            
            cmd= "sudo rm -rf /mnt/test_rbd_mnt/"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd3: {} executed successfully and status is : {}".format(cmd,status))
            logger.console("cmd3: {} executed successfully and status is : {}".format(cmd,status))
            time.sleep(60*1) # Sleep for 2 minutes
            
            cmd= "sudo rm test_rbd_mnt_10mb.bin"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd4: {} executed successfully and status is : {}".format(cmd,status))
            logger.console("cmd4: {} executed successfully and status is : {}".format(cmd,status))
            time.sleep(60*1) # Sleep for 2 minutes
            
            return "OK"
            
        except Exception as e:
            trace("Error in unmount_and_unmap_rbd: {}".format(e))