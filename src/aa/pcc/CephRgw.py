import re
import time
import json
import ast

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from aa.common import PccUtility as easy

from aa.common.Utils import banner, trace, pretty_print, cmp_json
from aa.common.Result import get_response_data
from aa.common.AaBase import AaBase
from aa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60*5

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
        self.targetNodeIp=None
        self.pcc=None
        self.port=None
        self.certificateName=None
        self.certificateID=None
        self.S3Accounts=[]
        self.secretKey=None
        self.accessKey=None
        self.user="pcc"
        self.password="cals0ft"
        self.fileName="rgwFile"


    ###########################################################################
    @keyword(name="PCC.Ceph Get Rgw Id")
    ###########################################################################
    def get_ceph_rgw_id_by_name(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Rgw Id")
        
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

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        if  self.cephPoolID==None:
            self.cephPoolID=easy.get_ceph_pool_id_by_name(conn,self.poolName)
        if self.certificateID==None:
            self.certificateID=easy.get_certificate_id_by_name(conn,self.certificateName)
        if  self.port:
            self.port=ast.literal_eval(str(self.port))
        if self.S3Accounts!=None or self.S3Accounts!=[]:
            tmp_cert={}
            for cert in eval(str(self.S3Accounts)):
                cert_id=easy.get_metadata_profile_id_by_name(conn,cert)
                tmp_cert[str(cert_id)]={}
            self.S3Accounts=tmp_cert           
        
        tmp_node=[]
        if self.targetNodes!=[] or self.targetNodes!='':
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

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        if  self.cephPoolID==None:
            self.cephPoolID=easy.get_ceph_pool_id_by_name(conn,self.poolName)
        if self.certificateID==None:
            self.certificateID=easy.get_certificate_id_by_name(conn,self.certificateName)
        if  self.port!=None or self.port!='':
            self.port=ast.literal_eval(str(self.port))
        if self.S3Accounts!=None or self.S3Accounts!=[]:
            tmp_cert={}
            for cert in eval(str(self.S3Accounts)):
                cert_id=easy.get_metadata_profile_id_by_name(conn,cert)
                tmp_cert[str(cert_id)]={}
            self.S3Accounts=tmp_cert
        
        tmp_node=[]
        if self.targetNodes!=[] or self.targetNodes!='':
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
        print("Kwargs:"+str(kwargs))

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        
        response = pcc.get_ceph_rgws(conn)
        print("Rgw Response:"+str(response))
        if not get_response_data(response):
            print("No Rgw found for delete")
            return "OK"
        for data in get_response_data(response):
            print("Response To Look :-"+str(data))
            print("Rados Gateway {} and id {} is deleting....".format(data['name'],data['ID']))
            self.ID=data['ID']
            self.name=data['name']
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

    ###########################################################################
    @keyword(name="PCC.Ceph Get Rgw Access Key")
    ###########################################################################
    def get_ceph_rgw_access_key(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Rgw Access Key")
        
        if  self.name==None:
            print("Ceph Rgw name is empty!!")
            return "Error"
        
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        rados_id = easy.get_ceph_rgw_id_by_name(conn,self.name)
        print("RadosId:"+str(rados_id))
        key_data = get_response_data(pcc.get_profiles_with_additional_data_for_specific_application(conn,"ceph",str(rados_id)))
        print("Response:"+str(key_data))
        print("Acess Key:"+str(key_data[0]['profile']["accessKey"]))
        if key_data[0]['profile']["accessKey"]:
            return key_data[0]['profile']["accessKey"]
        else:
            print("Can't extract Access Key")
            return "Error"
        return None
        
    ###########################################################################
    @keyword(name="PCC.Ceph Get Rgw Secret Key")
    ###########################################################################
    def get_ceph_rgw_secret_key(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get Rgw Secret Key")
        
        if  self.name==None:
            print("Ceph Rgw name is empty!!")
            return "Error"
        
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        rados_id = easy.get_ceph_rgw_id_by_name(conn,self.name)
        key_data = get_response_data(pcc.get_profiles_with_additional_data_for_specific_application(conn,"ceph",str(rados_id)))
        print("Response:"+str(key_data))
        print("Secret Key:"+str(key_data[0]['profile']["secretKey"]))
        if key_data[0]['profile']["secretKey"]:
            return key_data[0]['profile']["secretKey"]
        else:
            print("Can't extract Secret Key")
            return "Error"
        return None   

    ###########################################################################
    @keyword(name="PCC.Ceph Rgw Configure")
    ###########################################################################
    def ceph_rgw_configure(self,**kwargs):
        banner("PCC.Ceph Rgw Configure")
        self._load_kwargs(kwargs)
        
        cmd='sudo printf "%s\n" "{}" "{}" "" "{}:{}" "{}:{}" "" "" "" "" "n" "y" | s3cmd --configure'.format(self.accessKey,self.secretKey,self.targetNodeIp,self.port,self.targetNodeIp,self.port)
        print("Command:"+str(cmd))
        data=cli_run(self.pcc,self.user,self.password,cmd)
        
        if re.search("Configuration saved",str(data)):
            print("File is created Successfully, Changing check_ssl_certificate and check_ssl_hostname to False")
            cmd='sudo sed -i "s/check_ssl_certificate = True/check_ssl_certificate = False/g" /home/pcc/.s3cfg; sudo sed -i "s/check_ssl_hostname = True/check_ssl_hostname = False/g" /home/pcc/.s3cfg'
            output=cli_run(self.pcc,self.user,self.password,cmd)
            return "OK"
        else:
            print("Configuration not set properly")
            return "Error"
            
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Rgw Make Bucket")
    ###########################################################################
    def ceph_rgw_make_bucket(self,**kwargs):
        banner("PCC.Ceph Rgw Make Bucket")
        self._load_kwargs(kwargs)
        
        cmd='sudo s3cmd mb s3://BUCKET --access_key={} --secret_key={} --host={}:{}'.format(self.accessKey,self.secretKey,self.targetNodeIp,self.port)
        print("Command:"+str(cmd))
        data=cli_run(self.pcc,self.user,self.password,cmd)      
        if re.search("created",str(data)):
            print("Bucket Is Created")
            return "OK"
        else:
            print("Bucket is Not Created")
            return "Error"
        return
        
    ###########################################################################
    @keyword(name="PCC.Ceph Rgw Upload File To Bucket")
    ###########################################################################
    def ceph_rgw_upload_file_bucket(self,**kwargs):
        banner("PCC.Ceph Rgw Upload File To Bucket ")
        self._load_kwargs(kwargs)       
        cmd='sudo dd if=/dev/zero of={} bs=10MiB count=1'.format(self.fileName)
        file_create=cli_run(self.pcc,self.user,self.password,cmd)
        cmd='sudo s3cmd put {} s3://BUCKET/{} --access_key={} --secret_key={} --host={}:{}'.format(self.fileName,self.fileName,self.accessKey,self.secretKey,self.targetNodeIp,self.port)
        print("Command:"+str(cmd))
        trace("Command:"+str(cmd))
        data=cli_run(self.pcc,self.user,self.password,cmd)      
        if re.search("upload",str(data)):
            print("File is uploaded to bucket")
            cmd='sudo rm {}'.format(self.fileName)
            file_del=cli_run(self.pcc,self.user,self.password,cmd)
            return "OK"
        else:
            print("File is not uploaded")
            return "Error"
        return
        
    ###########################################################################
    @keyword(name="PCC.Ceph Rgw Get File From Bucket")
    ###########################################################################
    def ceph_rgw_get_file_bucket(self,**kwargs):
        banner("PCC.Ceph Rgw Get File To Bucket ")
        self._load_kwargs(kwargs)       
        cmd='sudo s3cmd get s3://BUCKET/{} --access_key={} --secret_key={} --host={}:{}'.format(self.fileName,self.accessKey,self.secretKey,self.targetNodeIp,self.port)
        print("Command:"+str(cmd))
        data=cli_run(self.pcc,self.user,self.password,cmd)      
        if re.search("download",str(data)):
            print("File is exracted from Bucket")
            cmd='sudo rm {}'.format(self.fileName)
            data=cli_run(self.pcc,self.user,self.password,cmd)
            return "OK"
        else:
            print("File is not extracted")
            return "Error"
        return

    ###########################################################################
    @keyword(name="PCC.Ceph Rgw List Buckets")
    ###########################################################################
    def ceph_rgw_list_buckets(self,**kwargs):
        banner("PCC.Ceph Rgw Delete Bucket")
        self._load_kwargs(kwargs)       
        cmd='sudo s3cmd ls'
        print("Command:"+str(cmd))
        data=cli_run(self.pcc,self.user,self.password,cmd)      
        if re.search("BUCKET",str(data)):
            return "OK"
        else:
            print("Buckets are not listed or Buckets are not created yet")
            return "Error"
        return

    ###########################################################################
    @keyword(name="PCC.Ceph Rgw Verify File Upload To Pool")
    ###########################################################################
    def ceph_rgw_verify_pool_upload_to_pool(self,**kwargs):
        banner("PCC.Ceph Rgw Verify File Upload To Pool")
        self._load_kwargs(kwargs)         
        time.sleep(10)     
        cmd="sudo ceph df| grep '{} ' | tr -s ' '|sed 's/^ *//' |cut -d ' ' -f6".format(self.poolName)
        print("Command:"+str(cmd))
        raw_data=cli_run(self.targetNodeIp,self.user,self.password,cmd)   
        data=self._serialize_response(time.time(),raw_data)['Result']['stdout']  
        print("Size used by pool {}:{}".format(self.poolName,data))
        if int(data.strip()) != 0:
            return "OK"
        else:
            return "Error"
        
    ###########################################################################
    @keyword(name="PCC.Ceph Rgw Delete File From Bucket")
    ###########################################################################
    def ceph_rgw_delete_file_bucket(self,**kwargs):
        banner("PCC.Ceph Rgw Delete File To Bucket")
        self._load_kwargs(kwargs)       
        cmd='sudo s3cmd del s3://BUCKET/{} --access_key={} --secret_key={} --host={}:{}'.format(self.fileName,self.accessKey,self.secretKey,self.targetNodeIp,self.port)
        print("Command:"+str(cmd))
        data=cli_run(self.pcc,self.user,self.password,cmd)      
        if re.search("delete",str(data)):
            print("File is deleted from Bucket")
            return "OK"
        else:
            print("File is not deleted")
            return "Error"
        return
        
    ###########################################################################
    @keyword(name="PCC.Ceph Rgw Delete Bucket")
    ###########################################################################
    def ceph_delete_bucket(self,**kwargs):
        banner("PCC.Ceph Rgw Delete Bucket")
        self._load_kwargs(kwargs)       
        cmd='sudo s3cmd rb s3://BUCKET --access_key={} --secret_key={} --host={}:{}'.format(self.accessKey,self.secretKey,self.targetNodeIp,self.port)
        print("Command:"+str(cmd))
        data=cli_run(self.pcc,self.user,self.password,cmd)      
        if re.search("removed",str(data)):
            print("Bucket is deleted successfully")
            return "OK"
        else:
            print("Bucket is not deleted")
            return "Error"
        return

    ###########################################################################
    @keyword(name="PCC.Ceph Rgw Verify BE Creation")
    ###########################################################################
    def ceph_rgw_verify_be_creation(self,**kwargs):
        banner("PCC.Ceph Rgw Verify BE Creation")
        self._load_kwargs(kwargs)
        
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e        

        ceph_be_cmd="sudo ceph -s"
        wait_time=400
        
        for i in range(20):
            time.sleep(20)
            wait_time-=20
            print("wait time left for RGW backend check {}s".format(wait_time))
            trace("wait time left for RGW backend check {}s".format(wait_time))
            failed_chk=[]
            success_chk=[]
            for ip in eval(str(self.targetNodeIp)):
                host_name=easy.get_host_name_by_ip(conn,ip)
                cmd_rgw="sudo systemctl status ceph-radosgw@rgw.{}.rgw0".format(host_name)
                ceph_check=cli_run(ip,self.user,self.password,ceph_be_cmd)
                rgw_check=cli_run(ip,self.user,self.password,cmd_rgw)
                if re.search("rgw",str(ceph_check)) and re.search("running",str(rgw_check)):
                    success_chk.append(ip)
                    
                else:
                    failed_chk.append(ip)
                    
                if len(success_chk)==len(eval(str(self.targetNodeIp))):
                    print("Backend verification successfuly done for : {}".format(success_chk))
                    return "OK"
        if wait_time==0:
            print("Rgw Check: "+str(rgw_check)) 
            print("Ceph Rgw Check: "+str(ceph_check))     
                              
        if failed_chk:  
            print("Rgw service are down for {}".format(failed_chk))     
            return "Error"
        else:
            return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Rgw Verify BE Deletion")
    ###########################################################################
    def ceph_rgw_verify_be_deletion(self,**kwargs):
        banner("PCC.Ceph Rgw Verify BE Deletion")
        self._load_kwargs(kwargs)

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e
        
        ceph_be_cmd="sudo ceph -s"
        wait_time=300
        
        for i in range(15):
            time.sleep(20)
            wait_time-=20
            print("wait time left for RGW backend check {}s".format(wait_time))
            trace("wait time left for RGW backend check {}s".format(wait_time))
            failed_chk=[]
            success_chk=[]
            for ip in eval(str(self.targetNodeIp)):
                host_name=easy.get_host_name_by_ip(conn,ip)
                cmd_rgw="sudo systemctl status ceph-radosgw@rgw.{}.rgw0".format(host_name)            
                ceph_check=cli_run(ip,self.user,self.password,ceph_be_cmd)
                rgw_check=cli_run(ip,self.user,self.password,cmd_rgw)
                if re.search("rgw",str(ceph_check)) and re.search("running",str(rgw_check)):
                    failed_chk.append(ip)
                else:
                    success_chk.append(ip)
                                         
                if len(success_chk)==len(eval(str(self.targetNodeIp))):
                    print("Backend verification successfuly done for : {}".format(success_chk))
                    return "OK"
                                              
        if failed_chk:  
            print("Rgw service are not down for {}".format(failed_chk))     
            return "Error"
        else:
            return "OK"
