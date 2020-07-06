import re
import time
import json

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy

from aa.common.Utils import banner, trace, pretty_print, cmp_json
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase
from aa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60*2

class CephRgw(AaBase):

    """ 
    Ceph Rados Gateway
    """

    def __init__(self):

        # Robot arguments definitions

        self.ID=None
        self.name=None
        self.cephPoolID=None
        self.poolName=None
        self.targetNodes=[]
        self.port=None
        self.certificateName=None
        self.certificateID=None
        self.S3Accounts=[]


    ###########################################################################
    @keyword(name="PCC.Ceph Get Rgw Id")
    ###########################################################################
    def get_ceph_rgw_id_by_name(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Cluster Id")
        
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        rados_id = easy.get_ceph_rgw_id_by_name(conn,self.name)
        return rados_id

    ###########################################################################
    @keyword(name="PCC.Ceph Create Rgw")
    ###########################################################################
    def add_rados_gateway(self, *args, **kwargs):
        banner("PCC.Rados Gateway Create")
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(kwargs))

        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        if  self.cephPoolID==None:
            self.cephPoolID=easy.get_ceph_pool_id_by_name(conn,self.poolName)
        if self.certificateID==None:
            self.certificateID=easy.get_certificate_id_by_name(conn,self.certificateName)
        if  self.port!=None:
            self.port=int(self.port)
        if self.S3Accounts!=None or self.S3Accounts!=[]:
            tmp_cert={}
            for cert in eval(str(self.S3Accounts)):
                cert_id=easy.get_metadata_profile_id_by_name(conn,cert)
                tmp_cert[str(cert_id)]={}
            self.S3Accounts=tmp_cert           
        
        tmp_node=[]
        for node_name in eval(str(self.targetNodes)):
            print("Node Name:"+str(node_name))
            node_id=easy.get_node_id_by_name(conn,node_name)
            print("Node Id:"+str(node_id))
            tmp_node.append(node_id)
        print("Node List:"+str(tmp_node))
            
        self.targetNodes=tmp_node
        
        payload = {
                    "name":self.name,
                    "cephPoolID":self.cephPoolID,
                    "targetNodes":self.targetNodes,
                    "port":self.port,
                    "certificateID": self.certificateID,
                    "S3Accounts":self.S3Accounts 
                  }
        print("Payload:-"+str(payload))
        return pcc.add_ceph_rgw(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Ceph Update Rgw")
    ###########################################################################
    def modify_rados_gateway(self, *args, **kwargs):
        banner("PCC.Rados Gateway Update")
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(kwargs))

        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        if  self.cephPoolID==None:
            self.cephPoolID=easy.get_ceph_pool_id_by_name(conn,self.poolName)
        if self.certificateID==None:
            self.certificateID=easy.get_certificate_id_by_name(conn,self.certificateName)
        if  self.port!=None:
            self.port=int(self.port)
        if self.S3Accounts!=None or self.S3Accounts!=[]:
            tmp_cert={}
            for cert in eval(str(self.S3Accounts)):
                cert_id=easy.get_metadata_profile_id_by_name(conn,cert)
                tmp_cert[str(cert_id)]={}
            self.S3Accounts=tmp_cert
        
        tmp_node=[]
        for node_name in eval(str(self.targetNodes)):
            print("Node Name:"+str(node_name))
            node_id=easy.get_node_id_by_name(conn,node_name)
            print("Node Id:"+str(node_id))
            tmp_node.append(node_id)
        print("Node List:"+str(tmp_node))
            
        self.targetNodes=tmp_node
        
        payload = {
                    "ID":self.ID,
                    "name":self.name,
                    "cephPoolID":self.cephPoolID,
                    "targetNodes":self.targetNodes,
                    "port":self.port,
                    "certificateID": self.certificateID,
                    "S3Accounts":self.S3Accounts 
                }

        print("Payload:-"+str(payload))
        return pcc.modify_ceph_rgw(conn, payload, self.ID)
    
    ###########################################################################
    @keyword(name="PCC.Ceph Delete Rgw")
    ###########################################################################
    def delete_ceph_rgw_by_id(self, *args, **kwargs):
        banner("PCC.Ceph Delete Cluster")
        self._load_kwargs(kwargs)

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        if self.ID == None and self.name==None:
            return {"Error": "[PCC.Ceph Delete Cluster]: Id of the cluster is not specified."}
        
        self.ID=easy.get_ceph_rgw_id_by_name(conn,self.name)

        return pcc.delete_ceph_rgw_by_id(conn, str(self.ID))

    ###########################################################################
    @keyword(name="PCC.Ceph Wait Until Rgw Ready")
    ###########################################################################
    def wait_until_rados_ready(self, *args, **kwargs):
        banner("PCC.Wait Until Rados Gateway Ready")
        self._load_kwargs(kwargs)
        print("Kwargs"+str(kwargs))

        if self.name == None:
            return None
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        gateway_ready = False
        timeout = time.time() + PCCSERVER_TIMEOUT
  
        while gateway_ready == False:
            response = pcc.get_ceph_rgws(conn)
            for data in get_response_data(response):
                if str(data['name']).lower() == str(self.name).lower():
                    print("Response To Look :-"+str(data))
                    if data['progressPercentage'] == 100:
                        gateway_ready = True
                    elif re.search("failed",str(data['deploy_status'])):
                        return "Error"
            if time.time() > timeout:
                raise Exception("[PCC.Ceph Wait Until Rgw Ready] Timeout")
            trace("  Waiting until cluster: %s is Ready, currently: %s" % (data['name'], data['progressPercentage']))
            time.sleep(5)
        return "OK"


    ###########################################################################
    @keyword(name="PCC.Ceph Wait Until Rgw Deleted")
    ###########################################################################
    def wait_until_rados_deleted(self, *args, **kwargs):
        banner("PCC.Wait Until Rados Gateway Deleted")
        self._load_kwargs(kwargs)

        if self.name == None:
            return {"Error": "[PCC.Wait Until Rados Gateway Deleted]: Name of the Rgw is not specified."}

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        Id_found_in_list_of_rgws = True
        timeout = time.time() + PCCSERVER_TIMEOUT

        while Id_found_in_list_of_rgws == True:
            Id_found_in_list_of_rgws = False
            response=get_response_data(pcc.get_ceph_rgws(conn))
            print("Response:"+str(response))
            if response!=None:
                for data in response:
                    if str(data['name']) == str(self.name):
                        Id_found_in_list_of_rgws = True         
                    if time.time() > timeout:
                        raise Exception("[PCC.Wait Until Rados Gateway Deleted] Timeout")
                    if Id_found_in_list_of_rgws:
                        trace("  Waiting until Rgws: %s is deleted. Timeout in %.1f seconds." %(data['name'], timeout-time.time()))
            time.sleep(5)
        return "OK"


    ###########################################################################
    @keyword(name="PCC.Ceph Delete All Rgw")
    ###########################################################################
    def delete_all_rgws(self, *args, **kwargs):
        banner("PCC.Rados Gateway Delete All")
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(Kwargs))

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        
        response = pcc.get_ceph_rgws(conn)
        for data in get_response_data(response):
            print("Response To Look :-"+str(data))
            print("Rados Gateway {} and id {} is deleting....".format(data['name'],data['id']))
            self.ID=data['id']
            del_response=pcc.delete_ceph_rgw_by_id(conn, str(self.ID))
            if del_response['Result']['status']==200:
                del_check=self.wait_until_rados_deleted()
                if del_check=="OK":
                    print("Rados Gateway {} is deleted sucessfully".format(data['name']))
                    return "OK"
                else:
                    print("Rados Gateway {} unable to delete".format(data['name']))
                    return "Error"
            else:
                print("Delete Response:"+str(del_response))
                print("Issue: Not getting 200 response back")
                return "Error"

        return "OK"
