import re
import time
import json

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from platina_sdk import pcc_easy_api as easy

from aa.common.Utils import banner, trace, pretty_print
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase

PCCSERVER_TIMEOUT = 60*10

class CephFs(AaBase):

    def __init__(self):

        # Robot arguments definitions

        self.id = None
        self.name = None
        self.metadata_pool = dict()
        self.data_pool = dict()
        self.default_pool = dict()
        self.ceph_cluster_id = None
        self.nodes_ip = []
        self.user=""
        self.password=""
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

        if re.search("^\[",str(self.data_pool))!=None and type(self.data_pool)!=list:
            self.data_pool=eval(self.data_pool)

        payload = {
            "name": self.name,
            "metadata_pool": self.metadata_pool,
            "data_pool": self.data_pool,
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
                print(str(data))
                if str(data['name']).lower() == str(self.name).lower():
                    if str(data['deploy_status']) == "completed":
                        fs_ready = True
                    elif re.search("failed",str(data['deploy_status'])):
                        return "Error"
            if time.time() > timeout:
                raise Exception("[PCC.Ceph Wait Until Fs Ready] Timeout")
            trace("  Waiting until Fs : %s is Ready, currently: %s" % (data['name'], data['progressPercentage']))
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
            output=easy.cli_run(ip,self.user,self.password,ceph_be_cmd)
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
            payload = {

            "id":self.id,
            "name": self.name,
            "metadata_pool": self.metadata_pool,
            "data_pool": self.data_pool,
            "default_pool": self.default_pool,
            "ceph_cluster_id": self.ceph_cluster_id

        }

            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            print(str(payload))
        except Exception as e:
            trace("[update_] EXCEPTION: %s" % str(e))
            raise Exception(e)

        return pcc.modify_ceph_fs(conn, payload)
