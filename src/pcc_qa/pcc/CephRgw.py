import re
import time
import json
import ast

from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy
from pcc_qa.common.PccUtility import get_ceph_cluster_id_by_name, get_node_by_id


from pcc_qa.common.Utils import banner, trace, pretty_print, cmp_json
from pcc_qa.common.Result import get_response_data, get_status_code
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60*8

class CephRgw(PccBase):

    """ 
    Ceph Rados Gateway
    """

    def __init__(self):

        # Robot arguments definitions

        self.ID=None
        self.name=None
        self.cephPoolID=None
        self.poolName=None
        self.targetNodeIp=None
        self.pcc=None
        self.port=None
        self.certificateName=None
        self.certificateUrl=""
        self.certificateID=None
        self.S3Accounts=[]
        self.secretKey=None
        self.accessKey=None
        self.user="pcc"
        self.service_ip="no"
        self.password="cals0ft"
        self.fileName="rgwFile"
        self.bucketName="testbucket"
        self.control_cidr=None
        self.data_cidr=None
        self.ceph_cluster_name = None
        self.num_daemons_map = None
        self.zone_group = ""
        self.zone = ""
        self.policy_id = None
        self.node_name = ""

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

        rados_id = easy.get_ceph_rgw_id_by_name(conn,Name= self.name,Ceph_cluster_name=self.ceph_cluster_name)
        return rados_id

    ###########################################################################
    @keyword(name="PCC.Ceph Get RGW By Name")
    ###########################################################################
    def get_ceph_rgw_by_name(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get RGW By Name")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        ceph_cluster_id = str(get_ceph_cluster_id_by_name(conn, Name=self.ceph_cluster_name))
        list_of_ceph_rgws = pcc.get_ceph_rgws(conn, ceph_cluster_id)['Result']['Data']
        trace(list_of_ceph_rgws)
        for ceph_rgw in list_of_ceph_rgws:
            if ceph_rgw['name'] == self.name:
                return ceph_rgw
        return []

    ###########################################################################
    @keyword(name="PCC.Ceph Get RGW By Id")
    ###########################################################################
    def get_ceph_rgw_by_id(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get RGW By Id")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        ceph_cluster_id = str(get_ceph_cluster_id_by_name(conn, Name=self.ceph_cluster_name))
        list_of_ceph_rgws = pcc.get_ceph_rgws(conn, ceph_cluster_id)['Result']['Data']
        trace(list_of_ceph_rgws)
        for ceph_rgw in list_of_ceph_rgws:
            if ceph_rgw['ID'] == self.ID:
                return ceph_rgw
        return []

    ###########################################################################
    @keyword(name="PCC.Ceph Get RGW Interfaces Map")
    ###########################################################################
    def get_ceph_rgw_interface(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Ceph Get RGW Interfaces Map")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        ceph_cluster_id = str(get_ceph_cluster_id_by_name(conn, Name=self.ceph_cluster_name))
        list_of_ceph_rgws = pcc.get_ceph_rgws(conn, ceph_cluster_id)['Result']['Data']
        trace(list_of_ceph_rgws)
        for ceph_rgw in list_of_ceph_rgws:
            if ceph_rgw['name'] == self.name:
                trace(ceph_rgw["interfaces"])
                return ceph_rgw["interfaces"]
        return "Error"

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

        if self.cephPoolID==None:
            self.cephPoolID=easy.get_ceph_pool_id_by_name(conn,self.poolName)
        if self.certificateID==None:
            self.certificateID=easy.get_certificate_id_by_name(conn,self.certificateName)
        if self.port:
            self.port=ast.literal_eval(str(self.port))
        if self.S3Accounts:
            tmp_S3Accounts = {}

            for cred in eval(str(self.S3Accounts)):
                metadata_cred_id = easy.get_metadata_profile_id_by_name(conn, cred)
                if type(metadata_cred_id) is not dict and metadata_cred_id:
                    tmp_S3Accounts[str(metadata_cred_id)] = {}

            self.S3Accounts = tmp_S3Accounts
        else:
            self.S3Accounts = {}

        tmp_daemons_map = {}
        if self.num_daemons_map:
            for node_name,num_daemons in self.num_daemons_map.items():
                node_id = easy.get_node_id_by_name(conn, node_name)
                tmp_daemons_map[str(node_id)] = num_daemons
        self.num_daemons_map = tmp_daemons_map
        
        payload = {
                    "name":self.name,
                    "cephPoolID":self.cephPoolID,
                    "numDaemonsMap": self.num_daemons_map,
                    "port":self.port,
                    "certificateID": self.certificateID,
                    "address":self.certificateUrl,
                    "S3Accounts":self.S3Accounts,
                    "zonegroup":self.zone_group,
                    "zone":self.zone
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
        if self.S3Accounts:
            tmp_S3Accounts = {}

            for cred in eval(str(self.S3Accounts)):
                cred_profiles = easy.get_app_credentials_profile_by_name(conn, cred)
                if type(cred_profiles) is not dict:
                    for cred_profile in cred_profiles:
                        if cred_profile["applicationId"] == self.ID:
                            tmp_S3Accounts[str(cred_profile["id"])] = {}
                            break

                metadata_cred_id = easy.get_metadata_profile_id_by_name(conn, cred)
                if type(metadata_cred_id) is not dict and metadata_cred_id:
                    tmp_S3Accounts[str(metadata_cred_id)] = {}

            self.S3Accounts = tmp_S3Accounts
        else:
            self.S3Accounts = {}
        
        tmp_daemons_map = {}
        if self.num_daemons_map:
            for node_name,num_daemons in self.num_daemons_map.items():
                node_id = easy.get_node_id_by_name(conn, node_name)
                tmp_daemons_map[str(node_id)] = num_daemons
        self.num_daemons_map = tmp_daemons_map

        payload = {
                    "ID":self.ID,
                    "name":self.name,
                    "cephPoolID":self.cephPoolID,
                    "numDaemonsMap": self.num_daemons_map,
                    "port":self.port,
                    "certificateID": self.certificateID,
                    "address": self.certificateUrl,
                    "S3Accounts":self.S3Accounts,
                    "zonegroup": self.zone_group,
                    "zone": self.zone
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
        
        self.ID = easy.get_ceph_rgw_id_by_name(conn,Name= self.name,Ceph_cluster_name=self.ceph_cluster_name)

        response = pcc.delete_ceph_rgw_by_id(conn, str(self.ID), "")
        status_code = get_status_code(response)
        if status_code == 202:
            code = get_response_data(response)["code"]
            return pcc.delete_ceph_rgw_by_id(conn, str(self.ID), "?code=" + code)
        return response

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
        ceph_cluster_id = str(easy.get_ceph_cluster_id_by_name(conn, Name=self.ceph_cluster_name))
        while True:
            response = pcc.get_ceph_rgws(conn, ceph_cluster_id)
            for data in get_response_data(response):
                if str(data['name']).lower() == str(self.name).lower():
                    print("Response To Look :-"+str(data))
                    trace("  Waiting until %s is Ready, current status: %s" % (str(data['name']),str(data.get('deploy_status'))))
                    if data.get('deploy_status') == "completed":
                        return "OK"
                    elif re.search("failed", str(data.get('deploy_status'))):
                        return "Error"
                    else:
                        break
            if time.time() > timeout:
                return "[PCC.Ceph Wait Until Rgw Ready] Timeout"
            time.sleep(15)


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
        ceph_cluster_id = easy.get_ceph_cluster_id_by_name(conn, self.ceph_cluster_name)
        while Id_found_in_list_of_rgws == True:
            Id_found_in_list_of_rgws = False
            response=get_response_data(pcc.get_ceph_rgws(conn,ceph_cluster_id))
            print("Response:"+str(response))
            if response!=None:
                for data in response:
                    if str(data['name']) == str(self.name):
                        Id_found_in_list_of_rgws = True
                        if data['deploy_status'] == 'failed':
                            return "Error"
                    if time.time() > timeout:
                        raise Exception("[PCC.Wait Until Rados Gateway Deleted] Timeout")
                    if Id_found_in_list_of_rgws:
                        trace("  Waiting until Rgws: %s is deleted. Timeout in %.1f seconds." %(data['name'], timeout-time.time()))
            time.sleep(15)
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
        ceph_cluster_id = str(easy.get_ceph_cluster_id_by_name(conn, Name=self.ceph_cluster_name))
        if ceph_cluster_id == "None":
            return "OK"
        response = pcc.get_ceph_rgws(conn, ceph_cluster_id)
        print("Rgw Response:"+str(response))
        if not get_response_data(response):
            print("No Rgw found for delete")
            return "OK"
        for data in get_response_data(response):
            print("Response To Look :-"+str(data))
            print("Rados Gateway {} and id {} is deleting....".format(data['name'],data['ID']))
            self.ID=data['ID']
            self.name=data['name']
            del_response = pcc.delete_ceph_rgw_by_id(conn, str(self.ID), "")
            status_code = get_status_code(del_response)
            code = get_response_data(del_response)["code"]
            if status_code == 202:
                del_response = pcc.delete_ceph_rgw_by_id(conn, str(self.ID), "?code=" + code)
                if del_response['Result']['status'] == 200:
                    del_check=self.wait_until_rados_deleted()
                    if del_check == "OK":
                        print("Rados Gateway {} is deleted sucessfully".format(data['name']))
                        continue
                    else:
                        print("Rados Gateway {} unable to delete".format(data['name']))
                        return "Error"
                else:
                    print("Delete Response:"+str(del_response))
                    print("Issue: Not getting 200 response back")
                    return "Error"
            else:
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

        rados_id = easy.get_ceph_rgw_id_by_name(conn,Name= self.name,Ceph_cluster_name=self.ceph_cluster_name)
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

        rados_id = easy.get_ceph_rgw_id_by_name(conn,Name= self.name,Ceph_cluster_name=self.ceph_cluster_name)
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
            cmd='sudo sed -i "s/check_ssl_certificate = True/check_ssl_certificate = False/g" /home/pcc/.s3cfg; sudo sed -i "s/check_ssl_hostname = True/check_ssl_hostname = False/g" /home/pcc/.s3cfg; sudo sed -i "s/signature_v2 = False/signature_v2 = True/g" /home/pcc/.s3cfg'
            output=cli_run(self.pcc,self.user,self.password,cmd)
            return "OK"
        else:
            print("Configuration not set properly")
            return "Error"
            
        return "OK"

    ###########################################################################
    @keyword(name="PCC.Ceph Rgw Update Configure")
    ###########################################################################
    def ceph_rgw_update_configure(self, **kwargs):
        banner("PCC.Ceph Rgw Update Configure")
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(kwargs))
        main_cmd=""
        if self.accessKey:
            main_cmd+='sudo sed -i "s/access_key =.*/access_key = {}/g" /home/pcc/.s3cfg;'.format(self.accessKey)
        if self.secretKey:
            main_cmd+='sudo sed -i "s/secret_key =.*/secret_key = {}/g" /home/pcc/.s3cfg;'.format(self.secretKey)
        if self.targetNodeIp:
            if self.port:
                main_cmd += 'sudo sed -i "s/host_base =.*/host_base = {}:{}/g" /home/pcc/.s3cfg'.format(self.targetNodeIp,self.port)
            else:
                main_cmd += 'sudo sed -i "s/host_base =.*/host_base = {}:443/g" /home/pcc/.s3cfg'.format(self.targetNodeIp)
            print("Command=" + str(main_cmd))
            output = cli_run(self.pcc, self.user, self.password, main_cmd)
            print(output)
            return "OK"
        else:
            if self.service_ip.lower()=="yes":
                cmd='sudo ip addr show | grep control0 | tail -1 | tr -s " " |cut -d " " -f3|cut -d "/" -f1'
                cmd_out=self._serialize_response(time.time(),cli_run(self.pcc,self.user,self.password,cmd))['Result']['stdout'].strip()
                print("Host ip to update:"+str(cmd_out))
                if self.port:
                    main_cmd += 'sudo sed -i "s/host_base =.*/host_base = {}:{}/g" /home/pcc/.s3cfg'.format(str(cmd_out),
                                                                                                       self.port)
                else:
                    main_cmd += 'sudo sed -i "s/host_base =.*/host_base = {}:443/g" /home/pcc/.s3cfg'.format(str(cmd_out))
                print("Command="+str(main_cmd))
                output = cli_run(self.pcc, self.user, self.password, main_cmd)
                print(output)
                return "OK"
            else:
                if not self.data_cidr:
                    return "Please provide Data CIDR"
                cmd='sudo vtysh -c "show run" |grep {} |tail -1 |tr -s " "| cut -d " " -f6'.format(self.data_cidr[0:8])
                cmd_out=self._serialize_response(time.time(),cli_run(self.pcc,self.user,self.password,cmd))['Result']['stdout'].strip()
                print("Host ip to update:"+str(cmd_out))
                if self.port:
                    main_cmd += "sudo sed -i 's/host_base =.*/host_base = {}:{}/g' /home/pcc/.s3cfg".format(str(cmd_out),self.port)
                else:
                    main_cmd += "sudo sed -i 's/host_base =.*/host_base = {}:443/g' /home/pcc/.s3cfg".format(str(cmd_out))
                print("Command=" + str(main_cmd))
                output = cli_run(self.pcc, self.user, self.password, main_cmd)
                print(output)
                return "OK"
        print("Configuration not updated sucessfully")
        return "Configuration not updated sucessfully"

    ###########################################################################
    @keyword(name="PCC.Ceph Rgw Make Bucket")
    ###########################################################################
    def ceph_rgw_make_bucket(self,**kwargs):
        banner("PCC.Ceph Rgw Make Bucket")
        self._load_kwargs(kwargs)
        
        cmd='sudo s3cmd mb s3://{} -c /home/pcc/.s3cfg'.format(self.bucketName)
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
        cmd='sudo s3cmd put {} s3://{}/{} -c /home/pcc/.s3cfg'.format(self.fileName,self.bucketName,self.fileName)
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
        cmd='sudo s3cmd get s3://testbucket/{} -c /home/pcc/.s3cfg --skip-existing'.format(self.fileName)
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
        banner("PCC.Ceph Rgw List Buckets")
        self._load_kwargs(kwargs)       
        cmd='sudo s3cmd ls -c /home/pcc/.s3cfg'
        print("Command:"+str(cmd))
        data=cli_run(self.pcc,self.user,self.password,cmd)      
        if re.search("testbucket",str(data)):
            return "OK"
        else:
            print("Buckets are not listed or Buckets are not created yet")
            return "Error"
        return

    ###########################################################################
    @keyword(name="PCC.Ceph Rgw List Objects inside Buckets")
    ###########################################################################
    def ceph_rgw_list_objects(self,**kwargs):
        banner("PCC.Ceph Rgw List Objects inside Buckets")
        self._load_kwargs(kwargs)
        cmd='sudo s3cmd ls s3://testbucket  -c /home/pcc/.s3cfg'
        print("Command:"+str(cmd))
        data=cli_run(self.pcc,self.user,self.password,cmd)
        if re.search(self.fileName,str(data)):
            return "OK"
        else:
            print("File is not listed")
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
        cmd='sudo s3cmd del s3://testbucket/{} -c /home/pcc/.s3cfg'.format(self.fileName)
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
        cmd='sudo s3cmd rb s3://testbucket -c /home/pcc/.s3cfg'
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
    @keyword(name="PCC.Ceph Verify RGW Node role")
    ###########################################################################
    def ceph_verify_rgw_node_role(self, **kwargs):
        banner("PCC.Ceph Verify RGW Node role")
        self._load_kwargs(kwargs)

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        cluster = easy.get_ceph_cluster_by_name(conn, self.ceph_cluster_name)
        nodes = cluster["nodes"]

        ceph_rgws = pcc.get_ceph_rgws(conn, cluster["id"])['Result']['Data']

        rgw_nodes = set()
        for rgw in ceph_rgws:
            rgw_nodes = rgw_nodes.union(rgw["numDaemonsMap"].keys())

        for node in nodes:
            if str(node["id"]) in rgw_nodes and "rgws" not in node["roles"]:
                print("Node {} should have rgws ceph node role".format(node["name"]))
                return "Error"
            elif str(node["id"]) not in rgw_nodes and "rgws" in node["roles"]:
                print("Node {} should not have rgws ceph node role".format(node["name"]))
                return "Error"
        return "OK"


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

        rgw = self.get_ceph_rgw_by_name()
        trace(rgw)
        if not rgw:
            print("No RGW Found")
            return "Error"

        self.num_daemons_map = {}
        for node_id in rgw["numDaemonsMap"].keys():
            num_daemon = rgw["numDaemonsMap"][node_id]
            interfaces = rgw["interfaces"][node_id]
            trace(num_daemon)
            trace(interfaces)
            node_name = get_node_by_id(conn=conn, Id=node_id)["Name"]
            trace(node_name)
            if num_daemon == len(interfaces):
                self.num_daemons_map[node_name] = {"num_daemon":num_daemon, "interfaces":interfaces}
            else:
                print("Mismatch num daemon {} num interfaces {}".format(num_daemon,len(interfaces)))
                return "Error"
        trace(self.num_daemons_map)

        tick = 30
        ceph_be_cmd = "sudo ceph -s"
        wait_time = 5 * tick
        
        while wait_time > 0:
            failed = False
            failed_chk_map = {}
            if self.num_daemons_map:
                for host_name, daemons in self.num_daemons_map.items():
                    host_ip = easy.get_hostip_by_name(conn, host_name)
                    ceph_conf_cmd = "sudo cat /etc/ceph/ceph.conf"
                    ceph_conf = cli_run(host_ip, self.user, self.password, ceph_conf_cmd)
                    realm_conf = "rgw_realm = {}".format(rgw["realm"])
                    zone_conf = "rgw_zone = {}".format(rgw["zone"])
                    zonegroup_conf = "rgw_zonegroup = {}".format(rgw["zonegroup"])
                    if not re.search(realm_conf, str(ceph_conf)) or not re.search(zone_conf,str(ceph_conf)) or not re.search(zonegroup_conf, str(ceph_conf)):
                        print("Mismatch on realm/zone/zonegroup conf {}".format(str(ceph_conf)))
                        return "Error"
                    failed_chk_map[host_name] = 0
                    for j in range(daemons["num_daemon"]):
                        intf = daemons["interfaces"][j]
                        intf_cmd = "sudo netstat -ntlp | grep radosgw | grep {}:{}".format(intf,rgw["port"])
                        cmd_rgw="sudo systemctl status ceph-radosgw@rgw.{}.rgw{}".format(host_name.split(".")[0],j)
                        ceph_check=cli_run(host_ip,self.user,self.password,ceph_be_cmd)
                        rgw_check=cli_run(host_ip,self.user,self.password,cmd_rgw)
                        intf_check=cli_run(host_ip,self.user,self.password,intf_cmd)
                        print("=========== ceph_check output is: {} \n==============".format(str(ceph_check)))
                        print("=========== rgw_check output is: {} \n==============".format(str(rgw_check)))
                        print("=========== intf_check output is: {} \n==============".format(str(intf_check)))
                        trace("=========== ceph_check output is: {} \n==============".format(str(ceph_check)))
                        trace("=========== rgw_check output is: {} \n==============".format(str(rgw_check)))
                        trace("=========== intf_check output is: {} \n==============".format(str(intf_check)))
                        if re.search("rgw",str(ceph_check)) and re.search("running",str(rgw_check)) and str(intf_check.stdout):
                            continue
                        else:
                            failed_chk_map[host_name] += 1
                    if failed_chk_map[host_name] > 0:
                        failed = True
                if not failed:
                    return "OK"
            time.sleep(tick)
            wait_time -= tick
            print("wait time left for RGW backend check {}s".format(wait_time))
            trace("wait time left for RGW backend check {}s".format(wait_time))

        print("Number Of Instances Down Per Node: {}".format(failed_chk_map))
        return "Error"


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

        tick = 30
        ceph_be_cmd = "sudo ceph -s"
        wait_time = 5 * tick

        while wait_time > 0:
            failed = False
            failed_chk_map = {}
            if self.num_daemons_map:
                for host_name, num_daemons in self.num_daemons_map.items():
                    host_ip = easy.get_hostip_by_name(conn, host_name)
                    failed_chk_map[host_name] = 0
                    for j in range(num_daemons):
                        cmd_rgw = "sudo systemctl status ceph-radosgw@rgw.{}.rgw{}".format(host_name.split(".")[0], j)
                        ceph_check = cli_run(host_ip, self.user, self.password, ceph_be_cmd)
                        rgw_check = cli_run(host_ip, self.user, self.password, cmd_rgw)
                        print("=========== ceph_check output is: {} \n==============".format(str(ceph_check)))
                        print("=========== rgw_check output is: {} \n==============".format(str(rgw_check)))
                        if re.search("rgw", str(ceph_check)) and re.search("running", str(rgw_check)):
                            failed_chk_map[host_name] += 1
                    if failed_chk_map[host_name] > 0:
                        failed = True
                if not failed:
                    return "OK"
            time.sleep(tick)
            wait_time -= tick
            print("wait time left for RGW backend check {}s".format(wait_time))
            trace("wait time left for RGW backend check {}s".format(wait_time))

        print("Number Of Instances Up Per Node: {}".format(failed_chk_map))
        return "Error"

    ###########################################################################
    @keyword(name="PCC.Ceph Rgw Verify Service IP BE")
    ###########################################################################
    def ceph_rgw_verify_service_ip_be(self, **kwargs):
        banner("PCC.Ceph Rgw Verify Service IP BE")
        self._load_kwargs(kwargs)
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
        except Exception as e:
            raise e

        if self.targetNodeIp:
            ip=self.targetNodeIp
        elif self.pcc:
            ip=self.pcc
        else:
            return "Target node is not provided"

        cmd="sudo netstat -ntlp |grep rados"
        ntlp_check = cli_run(ip, self.user, self.password, cmd)
        if self.service_ip.lower()=="yes":
            if re.search(self.control_cidr[0:8], str(ntlp_check)):
                return "OK"
            else:
                print("Could not verify service ip for ntlp check")
                return "Could not verify service ip for ntlp check"
        else:
            if re.search(self.control_cidr[0:8], str(ntlp_check)):
                print("Could not verify service ip for ntlp check")
                return "Could not verify service ip for ntlp check"
            else:
                return "OK"

        return "Please provide service_ip keyword with yes/no"


    ###############################################################################################################
    @keyword(name="PCC.Verify HAProxy BE")
    ###############################################################################################################
    def verify_haproxy_be(self, *args, **kwargs):
        banner("PCC.Verify HAProxy BE")
        self._load_kwargs(kwargs)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        node = easy.get_node_by_name(conn,self.name)
        policy = get_response_data(pcc.get_policy(conn,str(self.policy_id)))

        for i in policy["inputs"]:
            if i["name"] == "lb_name":
                lb_name = i["value"]
            if i["name"] == "lb_balance_method":
                lb_balance_method = "balance {}".format(i["value"])
            elif i["name"] == "lb_backends":
                lb_backends = int(i["value"])
            elif i["name"] == "lb_frontend":
                lb_frontend = "bind {}".format(i["value"])
                frontend_ip = i["value"]
            elif i["name"] == "lb_mode":
                lb_mode = i["value"]

        self.ID = lb_backends
        rgw = self.get_ceph_rgw_by_id()
        interfaces = rgw["interfaces"][str(node["Id"])]

        lb_backends = []
        for i in range(len(interfaces)):
            lb_backends.append("server {}-{} {}:{}".format(node["Name"], i, interfaces[i], rgw["port"]))

        if "control_ip" in lb_frontend:
            control_ip = easy.get_ceph_inet_ip(node["Host"],self.user,self.password)
            trace(control_ip)
            lb_frontend = lb_frontend.replace("control_ip",control_ip)
            frontend_ip = frontend_ip.replace("control_ip",control_ip)

        intf_cmd = "sudo netstat -ntlp | grep haproxy | grep {}".format(frontend_ip)
        intf_check = cli_run(node["Host"], self.user, self.password, intf_cmd)
        trace("interface check: {}".format(intf_check))
        if not str(intf_check.stdout):
            return "Error"

        cmd = "sudo cat /etc/haproxy/haproxy.cfg"
        cmd_out = cli_run(node["Host"], self.user, self.password, cmd)
        output = self._serialize_response(time.time(), cmd_out)['Result']['stdout']
        output = output.split("####")
        for out in output:
            frontend= "frontend {}".format(lb_name)
            if frontend in out:
                if re.search(lb_balance_method,out) and re.search(lb_frontend,out):
                    for lb_backend in lb_backends:
                        if not re.search(lb_backend,out):
                            return "Error"
                    return "OK"
                return "Error"
        return "Error"
