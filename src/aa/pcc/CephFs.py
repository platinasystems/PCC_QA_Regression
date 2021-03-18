import re
import time
import json
import ast
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy

from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase
from aa.common.Cli import cli_run

from aa.pcc.CephCluster import CephCluster

PCCSERVER_TIMEOUT = 60*10

class CephFs(AaBase):

    def __init__(self):

        # Robot arguments definitions

        self.id = None
        self.name = None
        self.metadata_pool = {}
        self.data_pool = []
        self.default_pool = {}
        self.ceph_cluster_id = None
        self.nodes_ip = []
        self.user="pcc"
        self.password="cals0ft"
        self.mount_folder_name = None
        self.dummy_file_name = None
        self.hostip = None
        self.inet_ip= None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Ceph Get Fs Id")
    ###########################################################################
    def get_ceph_fs_id_by_name(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        fs_id = None
        banner("PCC.Ceph Get Fs Id")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        fs_id = easy.get_ceph_fs_id_by_name(conn,self.name)
        return fs_id
        
    ###########################################################################
    @keyword(name="PCC.Ceph Get All Fs Data")
    ###########################################################################
    def get_ceph_all_fs_data(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        pool_id= None
        banner("PCC.Ceph Get All Fs Data")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        response = get_response_data(pcc.get_ceph_fs(conn))
        return response

    ###########################################################################
    @keyword(name="PCC.Ceph Create Fs")
    ###########################################################################
    def add_ceph_fs(self, *args, **kwargs):
        banner("PCC.Ceph Create Fs")
        self._load_kwargs(kwargs)

        #if re.search("^\[",str(self.data_pool))!=None and type(self.data_pool)!=list:
        #    self.data_pool=eval(self.data_pool)
        
        if 'name' not in kwargs:
            self.name = None
        if 'metadata_pool' not in kwargs:
            self.metadata_pool = {}
        if 'data_pool' not in kwargs:
            self.data_pool = []
        elif 'data_pool' in kwargs:
            self.data_pool = ast.literal_eval(self.data_pool)
        if 'default_pool' not in kwargs:
            self.default_pool = {}
        if 'ceph_cluster_id' not in kwargs:
            self.ceph_cluster_id = None
        
        payload = {
            "name": self.name,
            "metadata_pool": self.metadata_pool,
            "data_pools": self.data_pool,
            "default_pool": self.default_pool,
            "ceph_cluster_id": self.ceph_cluster_id
        }

        print(payload)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.add_ceph_fs(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Ceph Wait Until Fs Ready")
    ###########################################################################
    def wait_until_fs_ready(self, *args, **kwargs):
        banner("PCC.Ceph Wait Until Fs Ready")
        self._load_kwargs(kwargs)

        if self.name == None:
            return None
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        fs_ready = False
        timeout = time.time() + PCCSERVER_TIMEOUT

        while fs_ready == False:
            response = pcc.get_ceph_fs(conn)
            for data in get_response_data(response):
                if str(data['name']).lower() == str(self.name).lower():
                    print(str(data))
                    trace("  Waiting until Fs : %s is Ready, currently: %s" % (data['name'], data['progressPercentage']))
                    if str(data['deploy_status']) == "completed":
                        fs_ready = True
                    elif re.search("failed",str(data['deploy_status'])):
                        return "Error"
            if time.time() > timeout:
                raise Exception("[PCC.Ceph Wait Until Fs Ready] Timeout")
            time.sleep(5)
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Delete Fs")
    ###########################################################################
    def delete_ceph_fs_by_id(self, *args, **kwargs):
        banner("PCC.Ceph Delete Fs")
        self._load_kwargs(kwargs)

        if self.id == None:
            return {"Error": "[PCC.Ceph Delete Fs]: Id of the Fs is not specified."}
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        return pcc.delete_ceph_fs_by_id(conn,str(self.id))


    ###########################################################################
    @keyword(name="PCC.Ceph Wait Until Fs Deleted")
    ###########################################################################
    def wait_until_fs_deleted(self, *args, **kwargs):
        banner("PCC.Ceph Wait Until Fs Deleted")
        self._load_kwargs(kwargs)

        if self.id == None:
            return None
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        Id_found_in_list_of_Fs = True
        timeout = time.time() + PCCSERVER_TIMEOUT

        while Id_found_in_list_of_Fs == True:
            Id_found_in_list_of_Fs = False
            response = pcc.get_ceph_fs(conn)
            for data in get_response_data(response):
                print(data)
                if str(data['id']) == str(self.id):
                    Id_found_in_list_of_Fs = True
                elif re.search("failed",str(data['deploy_status'])):
                    return "Error"
            if time.time() > timeout:
                raise Exception("[PCC.Ceph Wait Until Fs Deleted] Timeout")
            if Id_found_in_list_of_Fs:
                trace("  Waiting until Fs: %s is deleted. Timeout in %.1f seconds." % 
                       (data['name'], timeout-time.time()))
                time.sleep(5)
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Fs Verify BE")
    ###########################################################################
    def verify_ceph_fs_be(self, *args, **kwargs):
        ceph_be_cmd="sudo ceph fs ls"
        banner("PCC.Ceph Fs Verify BE")
        self._load_kwargs(kwargs)

        for ip in self.nodes_ip:
            output=cli_run(ip,self.user,self.password,ceph_be_cmd)
            if re.search(self.name,str(output)):
                continue
            else:
                return None
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Update Fs")
    ###########################################################################
    def modify_ceph_fs(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        try:
            if 'name' not in kwargs:
                self.name = None
            if 'metadata_pool' not in kwargs:
                self.metadata_pool = None
            if 'data_pool' not in kwargs:
                self.data_pool = None
            elif 'data_pool' in kwargs:
                self.data_pool = ast.literal_eval(self.data_pool)
            if 'default_pool' not in kwargs:
                self.default_pool = None
            if 'ceph_cluster_id' not in kwargs:
                self.ceph_cluster_id = None
            
            payload = {

            "id":self.id,
            "name": self.name,
            "metadata_pool": self.metadata_pool,
            "data_pools": self.data_pool,
            "default_pool": self.default_pool,
            "ceph_cluster_id": self.ceph_cluster_id

        }

            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            print(str(payload))
        except Exception as e:
            trace("[update_] EXCEPTION: %s" % str(e))
            raise Exception(e)

        return pcc.modify_ceph_fs(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Ceph Delete All Fs")
    ###########################################################################
    def delete_ceph_all_fs(self, *args, **kwargs):
        banner("PCC.Ceph Delete All Fs")
        self._load_kwargs(kwargs)

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
            
        response = pcc.get_ceph_fs(conn)
        for data in get_response_data(response):
            print("Response To Look :-"+str(data))
            print("Ceph Fs {} and id {} is deleting....".format(data['name'],data['id']))
            self.id=data['id']
            del_response=pcc.delete_ceph_fs_by_id(conn, str(self.id))
            if del_response['Result']['status']==200:
                del_check=self.wait_until_fs_deleted()
                if del_check=="OK":
                    print("Ceph Fs {} is deleted sucessfully".format(data['name']))
                    return "OK"
                else:
                    print("Ceph Fs {} unable to delete".format(data['name']))
                    return "Error"
            else:
                print("Delete Response:"+str(del_response))
                print("Issue: Not getting 200 response back")
                return "Error"
                        
        return "OK"
        
    ###############################################################################################################
    @keyword(name="PCC.Mount FS to Mount Point")
    ###############################################################################################################
    
    def mount_fs(self, *args, **kwargs):
        banner("Mount FS to Mount Point")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            
            #inet_ip = CephCluster().get_ceph_inet_ip(**kwargs)
            #print("Inet IP is: {}".format(inet_ip))
            
            #Maps fs
            cmd= "sudo mount -t ceph {}:/ /mnt/{} -o name=admin,secret='ceph-authtool -p /etc/ceph/ceph.client.admin.keyring'".format(self.inet_ip,self.mount_folder_name)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
            print("cmd1: {} executed successfully and status is: {}".format(cmd, status))
            
            time.sleep(1)
            
            cmd= "sudo mount| grep test_fs_mnt"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
            print("cmd2: {} executed successfully and status is: {}".format(cmd, status))
            serialised_status = self._serialize_response(time.time(), status)
            cmd_output = str(serialised_status['Result']['stdout']).replace('\n', '').strip()
            
            if '/mnt/{}'.format(self.mount_folder_name) in cmd_output:
                print("Found in string") 
            else:
                return "Error: {} file not found".format(self.mount_folder_name)
            
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
            print("username is '{}' and password is: '{}'".format(self.user,self.password))
            #inet_ip = CephCluster().get_ceph_inet_ip(**kwargs)
            
            cmd= "sudo mkdir /mnt/{}".format(self.mount_folder_name)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
            print("cmd1: {} executed successfully and status is: {}".format(cmd, status))
            
            cmd= "sudo mount -t ceph {}:/ /mnt/{} -o name=admin,secret='ceph-authtool -p /etc/ceph/ceph.client.admin.keyring'".format(self.inet_ip,self.mount_folder_name)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
            print("cmd2: {} executed successfully and status is: {}".format(cmd, status))
            
            cmd= "sudo ls /mnt/{}".format(self.mount_folder_name)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
            print("cmd3: {} executed successfully and status is: {}".format(cmd, status))
            
            serialised_status = self._serialize_response(time.time(), status)
            cmd_output = str(serialised_status['Result']['stdout']).replace('\n', '').strip()
            
            if '{}'.format(self.dummy_file_name) in cmd_output:
                print("Data Found in output") 
            else:
                return "Error: '{}' file not found".format(self.dummy_file_name)
            
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
            print("username is '{}' and password is: '{}'".format(self.user,self.password))
            cmd= "sudo umount /mnt/{}".format(self.mount_folder_name)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
            print("cmd1: {} executed successfully and status is : {}".format(cmd,status))
        
            cmd= "sudo rm -rf /mnt/{}/".format(self.mount_folder_name)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.user,linux_password=self.password)
            print("cmd2: {} executed successfully and status is : {}".format(cmd,status))
            
            return "OK"
        except Exception as e:
            trace("Error in unmount_and_unmap_rbd: {}".format(e)) 
