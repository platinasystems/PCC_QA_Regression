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

PCCSERVER_TIMEOUT = 60*6

class CephRbd(AaBase):

    def __init__(self):

        # Robot arguments definitions
        self.id=None
        self.ceph_pool_id = None
        self.ceph_cluster_id = None
        self.name = ""
        self.size = None
        self.size_units=""
        self.tags =  []
        self.image_feature = ""
        self.count=0
        self.pool_name = None
        self.username = "pcc"
        self.password = "cals0ft"
        self.hostip = None
        self.mount_folder_name = None
        self.inet_ip = None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Ceph Get Rbd Id")
    ###########################################################################
    def get_ceph_rbd_id_by_name(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        rbd_id= None
        banner("PCC.Ceph Get Rbd Id")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        rbd_id = easy.get_ceph_rbd_id_by_name(conn,self.name)
        return rbd_id

    ###########################################################################
    @keyword(name="PCC.Ceph Get All Rbds Data")
    ###########################################################################
    def get_ceph_all_rbds_data(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        pool_id= None
        banner("PCC.Ceph Get All Rbds Data")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        response = get_response_data(pcc.get_ceph_rbds(conn))
        return response

    ###########################################################################
    @keyword(name="PCC.Ceph Delete All Rbds")
    ###########################################################################
    def delete_all_rbds(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Delete All Rbds")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        response = pcc.get_ceph_rbds(conn)
        for data in get_response_data(response):
            response=self.delete_ceph_rbd_by_id(id=data['id'])
            status=self.wait_until_rbd_deleted(id=data['id'])
            if status!="OK":
                print("{} deletion failed".format(data['name']))
                return "Error"
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Create Rbd")
    ###########################################################################
    def add_ceph_rbds(self, *args, **kwargs):
        banner("PCC.Ceph Create Rbd")
        self._load_kwargs(kwargs)

        if self.tags:
            self.tags=eval(self.tags)

        payload = {

            "ceph_pool_id":self.ceph_pool_id,
            "ceph_cluster_id":self.ceph_cluster_id,
            "name":self.name,
            "size":self.size, 
            "size_units": self.size_units,
            "tags":self.tags, 
            "image_feature":self.image_feature

        }

        print(payload)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.add_ceph_rbds(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Ceph Create Rbd Multiple")
    ###########################################################################
    def create_rbd_multiple(self, *args, **kwargs):
        banner("PCC.Ceph Create Rbd")
        self._load_kwargs(kwargs)

        if self.tags:
            self.tags=eval(self.tags)

        if self.count:
            self.count=int(self.count)

        for i in range(1, self.count + 1):
            name = str(self.name) + "-" + str(i)
            payload = {
                "ceph_pool_id":self.ceph_pool_id,
                "ceph_cluster_id":self.ceph_cluster_id,
                "name":name,
                "size":self.size,
                "size_units": self.size_units,
                "tags":self.tags,
                "image_feature":self.image_feature
                }

            print(payload)
            conn = BuiltIn().get_variable_value("${PCC_CONN}")

            if self.count == i:
                return pcc.add_ceph_rbds(conn, payload)
            else:
               response = pcc.add_ceph_rbds(conn, payload)
               print(response)

            time.sleep(5)
              

    ###########################################################################
    @keyword(name="PCC.Ceph Delete Rbd")
    ###########################################################################
    def delete_ceph_rbd_by_id(self, *args, **kwargs):
        banner("PCC.Ceph Delete Rbd")
        self._load_kwargs(kwargs)

        if self.id == None:
            return {"Error": "[PCC.Ceph Delete Rbd]: Id of the Rbd is not specified."}
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        return pcc.delete_ceph_rbd_by_id(conn,str(self.id))


    ###########################################################################
    @keyword(name="PCC.Ceph Wait Until Rbd Deleted")
    ###########################################################################
    def wait_until_rbd_deleted(self, *args, **kwargs):
        banner("PCC.Ceph Wait Until Rbd Deleted")
        self._load_kwargs(kwargs)

        if self.id == None:
            return None
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        Id_found_in_list_of_rbd = True
        timeout = time.time() + PCCSERVER_TIMEOUT

        while Id_found_in_list_of_rbd == True:
            Id_found_in_list_of_rbd = False
            response = pcc.get_ceph_rbds(conn)
            for data in get_response_data(response):
                print(data)
                if str(data['id']) == str(self.id):
                    Id_found_in_list_of_rbd = True
            if time.time() > timeout:
                raise Exception("[PCC.Ceph Wait Until Rbd Deleted] Timeout")
            if Id_found_in_list_of_rbd:
                trace("  Waiting until rbd: %s is deleted. Timeout in %.1f seconds." % 
                       (data['name'], timeout-time.time()))
                time.sleep(5)
        time.sleep(10)
        return "OK"



    ###########################################################################
    @keyword(name="PCC.Ceph Wait Until Rbd Ready")
    ###########################################################################
    def wait_until_rbd_ready(self, *args, **kwargs):
        banner("PCC.Ceph Wait Until Rbd Ready")
        self._load_kwargs(kwargs)

        if self.name == None:
            return None
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        rbd_ready = False
        timeout = time.time() + PCCSERVER_TIMEOUT

        while rbd_ready == False:
            response = pcc.get_ceph_rbds(conn)
            for data in get_response_data(response):
                print(str(data))
                if str(data['name']).lower() == str(self.name).lower():
                    if data['deploy_status'] == "completed":
                        rbd_ready = True
                    if data['deploy_status'] == "failed":
                        return "Error"
            if time.time() > timeout:
                raise Exception("[PCC.Ceph Wait Until Rbd Ready] Timeout")
            trace("  Waiting until rbd : %s is Ready, currently: %s" % (data['name'], data['progressPercentage']))
            time.sleep(5)
        time.sleep(10)
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Rbd Update")
    ###########################################################################
    def modify_ceph_rbds(self, *args, **kwargs):
        self._load_kwargs(kwargs)

        if self.tags:
            self.tags=eval(self.tags)

        try:
            payload = {

            "id":self.id,
            "ceph_pool_id":self.ceph_pool_id,
            "ceph_cluster_id":self.ceph_cluster_id,
            "name":self.name,
            "size":self.size,
            "size_units": self.size_units,
            "tags":self.tags,
            "image_feature":self.image_feature

        }

            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            print(str(payload))
        except Exception as e:
            trace("[update_] EXCEPTION: %s" % str(e))
            raise Exception(e)

        return pcc.modify_ceph_rbds(conn, payload)
        
    ###############################################################################################################
    @keyword(name="PCC.Map RBD")
    ###############################################################################################################
    
    def map_rbd(self, *args, **kwargs):
        banner("Map RBD")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            
            #inet_ip = CephCluster().get_ceph_inet_ip(**kwargs)
            #print("Inet IP is : {}".format(inet_ip))
            
            #Maps rbd0
            cmd= "sudo rbd map {} --pool {} --name client.admin -m {} -k /etc/ceph/ceph.client.admin.keyring".format(self.name, self.pool_name, self.inet_ip)
            
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            trace("cmd1: {} executed successfully and status is:{}".format(cmd,str(status)))
            print("cmd1: {} executed successfully and status is:{}".format(cmd,str(status)))            
            time.sleep(2)
            
            #mkfs.ext4 rbd0 command execution
            cmd= "sudo mkfs.ext4 -m0 /dev/rbd0"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            trace("cmd2: {} executed successfully and status is:{}".format(cmd,str(status)))
            print("cmd2: {} executed successfully and status is:{}".format(cmd,str(status)))
            time.sleep(2)            
            return "OK"
            
        except Exception as e:
            trace("Error in map_rbd: {}".format(e))
            
    ###############################################################################################################
    @keyword(name="PCC.Mount RBD To Mount Point")
    ###############################################################################################################
    
    def mount_rbd(self, *args, **kwargs):
        banner("Mount RBD To Mount Point")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            #Mount rbd0
            cmd= "sudo mount /dev/rbd0 /mnt/{}".format(self.mount_folder_name)
            
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            trace("cmd1: {} executed successfully and status is:{}".format(cmd,status))
            
            time.sleep(5)
            return "OK"
            
        except Exception as e:
            trace("Error in mount_rbd: {}".format(e))
            
    ###############################################################################################################
    @keyword(name="PCC.Unmount and Unmap RBD")
    ###############################################################################################################
    
    def unmount_and_unmap_rbd(self, *args, **kwargs):
        banner("PCC.Unmount and Unmap RBD")
        self._load_kwargs(kwargs)
        try:
            print("Kwargs are: {}".format(kwargs))
            cmd= "sudo umount /mnt/{}".format(self.mount_folder_name)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd1: {} executed successfully and status is : {}".format(cmd,status))
            trace("cmd1: {} executed successfully and status is : {}".format(cmd,status))
            time.sleep(60*1) # Sleep for 2 minutes
            
            cmd= "sudo rbd unmap /dev/rbd0"
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd2: {} executed successfully and status is : {}".format(cmd,status))
            trace("cmd2: {} executed successfully and status is : {}".format(cmd,status))
            time.sleep(60*2) # Sleep for 2 minutes
            
            cmd= "sudo rm -rf /mnt/{}/".format(self.mount_folder_name)
            status = cli_run(cmd=cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            print("cmd3: {} executed successfully and status is : {}".format(cmd,status))
            trace("cmd3: {} executed successfully and status is : {}".format(cmd,status))
            time.sleep(60*2) # Sleep for 2 minutes
            
            return "OK"
        except Exception as e:
                trace("Error in unmount_and_unmap_rbd: {}".format(e))
