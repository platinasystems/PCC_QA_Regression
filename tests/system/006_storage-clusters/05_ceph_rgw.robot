*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
        [Tags]    This
                                            Load Ceph Rgw Data    ${pcc_setup}
                                            Load Ipam Data    ${pcc_setup}
					    Load Ceph Pool Data    ${pcc_setup}
                                            Load Ceph Cluster Data    ${pcc_setup}
                                            Load Clusterhead 1 Test Data    ${pcc_setup}
                                            Load Clusterhead 2 Test Data    ${pcc_setup}
                                            Load Server 1 Test Data    ${pcc_setup}
                                            Load Server 2 Test Data    ${pcc_setup}
                                            Load Server 3 Test Data    ${pcc_setup}
            
        
        ${status}                           Login To PCC        testdata_key=${pcc_setup}
                                            Should Be Equal     ${status}  OK


###################################################################################################################################
Ceph Pool For Rgws
###################################################################################################################################

    [Documentation]                        *Ceph Ceph Pool For Rgws*
                                      ...  keywords:
                                      ...  PCC.Ceph Get Cluster Id
                                      ...  PCC.Ceph Create Pool
                                      ...  PCC.Ceph Wait Until Pool Ready
	#[Tags]    This
        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK
                                      
        ${cluster_id}                      PCC.Ceph Get Cluster Id
                                      ...  name=${CEPH_CLUSTER_NAME}
                                      
        ${response}                        PCC.Ceph Create Pool
                                      ...  name=${CEPH_RGW_POOLNAME}
                                      ...  ceph_cluster_id=${cluster_id}
                                      ...  size=${CEPH_POOL_SIZE}
                                      ...  tags=${CEPH_POOL_TAGS}
                                      ...  pool_type=${CEPH_POOL_TYPE}
                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                                      ...  quota=1
                                      ...  quota_unit=GiB
                                      
        ${status_code}                     Get Response Status Code        ${response}
        ${message}                         Get Response Message        ${response}
                                           Should Be Equal As Strings      ${status_code}  200
                                           
        ${status}                          PCC.Ceph Wait Until Pool Ready
                                      ...  name=${CEPH_RGW_POOLNAME}
                                           Should Be Equal As Strings      ${status}    OK
                                      
        ${response}                        PCC.Ceph Create Pool
                                      ...  name=rgw-pool-upd
                                      ...  ceph_cluster_id=${cluster_id}
                                      ...  size=${CEPH_POOL_SIZE}
                                      ...  tags=${CEPH_POOL_TAGS}
                                      ...  pool_type=${CEPH_POOL_TYPE}
                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                                      ...  quota=1
                                      ...  quota_unit=GiB
                                      
        ${status_code}                     Get Response Status Code        ${response}
        ${message}                         Get Response Message        ${response}
                                           Should Be Equal As Strings      ${status_code}  200

        ${status}                          PCC.Ceph Wait Until Pool Ready
                                      ...  name=rgw-pool-upd
                                           Should Be Equal As Strings      ${status}    OK       
                                           
        ${response}                        PCC.Ceph Create Pool
                                      ...  name=rgw-non-ceph
                                      ...  ceph_cluster_id=${cluster_id}
                                      ...  size=${CEPH_POOL_SIZE}
                                      ...  tags=${CEPH_POOL_TAGS}
                                      ...  pool_type=${CEPH_POOL_TYPE}
                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                                      ...  quota=1
                                      ...  quota_unit=GiB
                                      
        ${status_code}                     Get Response Status Code        ${response}
        ${message}                         Get Response Message        ${response}
                                           Should Be Equal As Strings      ${status_code}  200

        ${status}                          PCC.Ceph Wait Until Pool Ready
                                      ...  name=rgw-non-ceph
                                           Should Be Equal As Strings      ${status}    OK    
                                           
###################################################################################################################################
#Create Erasure CEPH Pool with 4:2 chunks For Raos
####################################################################################################################################
#
#     [Documentation]                 *Get Erasure Code Profile Id* test
#                                     ...  keywords:
#                                     ...  PCC.Get Erasure Code Profile Id
#                                     ...  PCC.Ceph Get Cluster Id
#                                     ...  PCC.Ceph Create Erasure Pool
#                           
#        ${cluster_id}                PCC.Ceph Get Cluster Id
#                                     ...  name=${CEPH_CLUSTER_NAME}
#                         
#                                                  
#        ${response}                  PCC.Ceph Create Erasure Pool                
#                                     ...  name=rados-erasure
#                                     ...  ceph_cluster_id=${cluster_id}
#                                     ...  size=${CEPH_POOL_SIZE}
#                                     ...  pool_type=erasure
#                                     ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                                     ...  quota=${CEPH_POOL_QUOTA}
#                                     ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#                                     ...  Datachunks=4
#                                     ...  Codingchunks=2
#                               
#        ${status_code}               Get Response Status Code        ${response}     
#                                     Should Be Equal As Strings      ${status_code}  200
#        
#        
#        ${status}                    PCC.Ceph Wait Until Erasure Pool Ready
#                                     ...  name=rados-erasure
#                                     Should Be Equal As Strings      ${status}    OK
#
###################################################################################################################################
Create Application credential profile without application For Rados
###################################################################################################################################

        [Documentation]               *Create Metadata Profile* test
                                      ...  keywords:
                                      ...  PCC.Add Metadata Profile
        #[Tags]    This
        ${response}                   PCC.Add Metadata Profile
                                      ...    Name=${CEPH_RGW_S3ACCOUNTS}
                                      ...    Type=ceph
                                      ...    Username=profile_without_app
                                      ...    Email=profile_without_app@gmail.com
                                      ...    Active=True
                                      
                                      Log To Console    ${response}
                                      ${result}    Get Result    ${response}
                                      ${status}    Get From Dictionary    ${result}    status
                                      ${message}    Get From Dictionary    ${result}    message
                                      Log to Console    ${message}
                                      Should Be Equal As Strings    ${status}    200
                       
##################################################################################################################################
Ceph Ceph Certificate For Rgws
###################################################################################################################################

        [Documentation]              *Ceph Ceph Certificate For Rgws*
        #[Tags]    This
        ${cert_id}                   PCC.Get Certificate Id
                                ...  Alias=${CEPH_RGW_CERT_NAME}
                                     Pass Execution If    ${cert_id} is not ${None}    Certificate is already there        

        ${response}                  PCC.Add Certificate
                                ...  Alias=${CEPH_RGW_CERT_NAME}
                                ...  Description=certificate-for-rgw
                                ...  Private_key=domain.key
                                ...  Certificate_upload=domain.crt

                                     Log To Console    ${response}
        ${result}                    Get Result    ${response}
        ${status}                    Get From Dictionary    ${result}    statusCodeValue
                                     Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Creating RGW using a pool that is used by other Ceph front-ends (Negative)
#####################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
              
        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_POOL_TYPE}
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                           
        ${status_code}              Get Response Status Code        ${response} 
        ${message}                  Get Response Message        ${response}    
                                    Should Not Be Equal As Strings      ${status_code}  200

                                    
###################################################################################################################################
#Creating RGW without name (Negative)
######################################################################################################################################
#
#     [Documentation]                 *Ceph Rados Gateway Creation*
#              
#        ${response}                 PCC.Ceph Create Rgw
#                               ...  name=
#                               ...  poolName=${CEPH_RGW_POOLNAME}
#                               ...  targetNodes=${CEPH_RGW_NODES}
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                           
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Not Be Equal As Strings      ${status_code}  200    
#
###################################################################################################################################
Creating RGW without pool name (Negative)
#####################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
              
        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                           
        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200   

###################################################################################################################################
#Creating RGW without port (Negative)
######################################################################################################################################
#
#     [Documentation]                 *Ceph Rados Gateway Creation*
#              
#        ${response}                 PCC.Ceph Create Rgw
#                               ...  name=${CEPH_RGW_NAME}
#                               ...  poolName=${CEPH_RGW_POOLNAME}
#                               ...  targetNodes=${CEPH_RGW_NODES}
#                               ...  port=
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                           
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Not Be Equal As Strings      ${status_code}  200   
#
#
###################################################################################################################################
Creating RGW without certificate (Negative)
#####################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
              
        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=
                           
        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200                                       

###################################################################################################################################
#Creating RGW without hosts/nodes (Negative)
######################################################################################################################################
#
#     [Documentation]                 *Ceph Rados Gateway Creation*
#              
#        ${response}                 PCC.Ceph Create Rgw
#                               ...  name=${CEPH_RGW_NAME}
#                               ...  poolName=${CEPH_RGW_POOLNAME}
#                               ...  targetNodes=[]
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                           
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Not Be Equal As Strings      ${status_code}  200  
#                                    
###################################################################################################################################
#Creating RGW with non alphanumeric name (Negative)
######################################################################################################################################
#
#     [Documentation]                 *Ceph Rados Gateway Creation*
#              
#        ${response}                 PCC.Ceph Create Rgw
#                               ...  name=@#$%^&
#                               ...  poolName=${CEPH_RGW_POOLNAME}
#                               ...  targetNodes=${CEPH_RGW_NODES}
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                           
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Not Be Equal As Strings      ${status_code}  200 
#                                    
###################################################################################################################################
Ceph Rados Gateway Creation With Replicated Pool Without S3 Accounts
#####################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*
	#[Tags]    This
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
              
        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                           
        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK      

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${SERVER_2_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK 
                                    
#####################################################################################################################################
#Ceph Rados Update Pool
######################################################################################################################################
#     [Documentation]                 *Ceph Rados Gateway Update*
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#     
#        ${response}                 PCC.Ceph Update Rgw
#                               ...  ID=${rgw_id}
#                               ...  name=${CEPH_RGW_NAME}
#                               ...  poolName=rgw-pool-upd
#                               ...  targetNodes=${CEPH_RGW_NODES}
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                                                        
#####################################################################################################################################
#Ceph Rados Add S3Account 
#####################################################################################################################################
#     [Documentation]                *Ceph Rados Gateway Update*
#	#[Tags]    This
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME}
#			       ...  ceph_cluster_name=ceph-pvt
#     
#        ${response}                 PCC.Ceph Update Rgw
#                               ...  ID=${rgw_id}
#                               ...  name=${CEPH_RGW_NAME}
#                               ...  poolName=${CEPH_RGW_POOLNAME}
#                               ...  targetNodes=${CEPH_RGW_NODES}
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]
#                              
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    
#        ${status}                   PCC.Ceph Wait Until Rgw Ready
#                               ...  name=${CEPH_RGW_NAME}
#			       ...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
#                               ...  targetNodeIp=['${SERVER_2_HOST_IP}']
#                                    Should Be Equal As Strings      ${backend_status}    OK 
#                                    
#####################################################################################################################################
Ceph Rados Update Port 
#####################################################################################################################################
     [Documentation]                 *Ceph Rados Gateway Update*
	[Tags]    This
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt
     
        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=446
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]
                               
        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK   

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${SERVER_2_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK 
				    
				    Sleep    3 minutes
                                    
#####################################################################################################################################
Ceph Rados Update Nodes (Add Node)
#####################################################################################################################################
     [Documentation]                *Ceph Rados Gateway Update*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt
     
        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=["${SERVER_2_NAME}","${SERVER_1_NAME}"]
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]
                               
        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK  

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=["${SERVER_1_HOST_IP}"]
                                    Should Be Equal As Strings      ${backend_status}    OK 

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=["${SERVER_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${backend_status}    OK  
                                    Sleep    3 minutes

#####################################################################################################################################
#Ceph Rados Update Certificte 
######################################################################################################################################
#     [Documentation]                 *Ceph Rados Gateway Update*
#        
#        ${cert_id}                   PCC.Get Certificate Id
#                                ...  Alias=cert-upd
#                                     Pass Execution If    ${cert_id} is not ${None}    Certificate is already there        
#                
#        ${response}                  PCC.Add Certificate
#                                ...  Alias=cert-upd
#                                ...  Description=certificate-for-rgw
#                                ...  Private_key=rgw_key.key
#                                ...  Certificate_upload=rgw.crt
#  
#                                     Log To Console    ${response}
#        ${result}                    Get Result    ${response}
#        ${status}                    Get From Dictionary    ${result}    statusCodeValue
#                                     Should Be Equal As Strings    ${status}    200
#
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#     
#        ${response}                 PCC.Ceph Update Rgw
#                               ...  ID=${rgw_id}
#                               ...  name=${CEPH_RGW_NAME}
#                               ...  poolName=${CEPH_RGW_POOLNAME}
#                               ...  targetNodes=${CEPH_RGW_NODES}
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=cert-upd
#                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_Cluster_NAME}
#                                    Should Be Equal As Strings      ${status}    OK      
#
#        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
#                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
#                                    Should Be Equal As Strings      ${backend_status}    OK 
#                                    
####################################################################################################################################
Ceph Rados Gateway Delete 
####################################################################################################################################

    [Documentation]                 *Ceph Rados Gateway Delete*
  
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
  
        ${response}                 PCC.Ceph Delete Rgw
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Deleted
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
                               ...  targetNodeIp=['${SERVER_2_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK
	                            Sleep    5 minutes
				                                    
###################################################################################################################################
Ceph Rados Gateway Creation With Replicated Pool With S3 Accounts
#####################################################################################################################################

     [Documentation]                *Ceph Rados Gateway Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
             
        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]
                           
        ${status_code}              Get Response Status Code        ${response}   
        ${message}                  Get Response Message        ${response}  
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK      

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK 
                                    
###################################################################################################################################
Create Rgw Configuration File (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

                                           Sleep    3 minutes
        ${accessKey}                       PCC.Ceph Get Rgw Access Key
                                      ...  name=${CEPH_RGW_NAME}
				      ...  ceph_cluster_name=ceph-pvt

        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
                                      ...  name=${CEPH_RGW_NAME}
				      ...  ceph_cluster_name=ceph-pvt

        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=0.0.0.0
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create Rgw Bucket (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Create Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Make Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
List Rgw Bucket (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *List Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Update Rgw Configuration File With Control IP And Try To ADD File (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*


        ${status}                          PCC.Ceph Rgw Update Configure
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  service_ip=yes
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Upload File To Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}
                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify File Is Upload on Pool (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Verify File Is Uploaded on Pool*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Verify File Upload To Pool
                                      ...  poolName=${CEPH_RGW_POOLNAME}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete A File From Rgw Bucket (ServiceIp As Default)
####################################################################################################################################
    [Documentation]                        *Delete a file from Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Update Rgw Configuration File With Data IP And Try To ADD File (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*


        ${status}                          PCC.Ceph Rgw Update Configure
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  service_ip=no
                                      ...  data_cidr=${IPAM_DATA_SUBNET_IP}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Upload File To Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}
                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify File Is Upload on Pool (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Verify File Is Uploaded on Pool*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Verify File Upload To Pool
                                      ...  poolName=${CEPH_RGW_POOLNAME}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Get A File From Rgw Bucket (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Get a file from Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Get File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete Rgw Bucket When Bucket Is Not Empty (ServiceIp As Default) (Negative)
###################################################################################################################################
      [Documentation]                      *Delete Rgw Bucket When Bucket Is Not Empty*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Not Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete A File From Rgw Bucket (ServiceIp As Default)
####################################################################################################################################
    [Documentation]                        *Delete a file from Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete Rgw Bucket (ServiceIp As Default)
###################################################################################################################################
      [Documentation]                      *Delete Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

                                           
#####################################################################################################################################
#Ceph Rados Remove S3Account (ServiceIp As Default)
#####################################################################################################################################
#     [Documentation]                 *Ceph Rados Gateway Update*

#         ${status}                   PCC.Ceph Get Pcc Status
#                                ...  name=ceph-pvt
#                                     Should Be Equal As Strings      ${status}    OK

#         ${rgw_id}                   PCC.Ceph Get Rgw Id
#                                ...  name=${CEPH_RGW_NAME}
# 			       ...  ceph_cluster_name=ceph-pvt
     
#         ${response}                 PCC.Ceph Update Rgw
#                                ...  ID=${rgw_id}
#                                ...  name=${CEPH_RGW_NAME}
#                                ...  poolName=${CEPH_RGW_POOLNAME}
#                                ...  targetNodes=${CEPH_RGW_NODES}
#                                ...  port=${CEPH_RGW_PORT}
#                                ...  certificateName=${CEPH_RGW_CERT_NAME}
                               
#         ${status_code}              Get Response Status Code        ${response}     
#         ${message}                  Get Response Message        ${response}
#                                     Should Be Equal As Strings      ${status_code}  200

#         ${status}                   PCC.Ceph Wait Until Rgw Ready
#                                ...  name=${CEPH_RGW_NAME}
#  			       ...  ceph_cluster_name=ceph-pvt
#                                     Should Be Equal As Strings      ${status}    OK  

#         ${backend_status}           PCC.Ceph Rgw Verify BE Creation
#                                ...  targetNodeIp=['${SERVER_2_HOST_IP}']
#                                     Should Be Equal As Strings      ${backend_status}    OK         
                                    
####################################################################################################################################
Ceph Rados Gateway Delete (ServiceIp As Default)
####################################################################################################################################

    [Documentation]                 *Ceph Rados Gateway Delete*
 
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
 
        ${response}                 PCC.Ceph Delete Rgw
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt

        ${status_code}              Get Response Status Code        ${response}    
        ${message}                  Get Response Message        ${response} 
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Deleted
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK
				    Sleep    5 minutes
                                    
###################################################################################################################################
#Ceph Rados Gateway Creation With Replicated Pool With S3 Accounts (ServiceIp As NodeIp)
######################################################################################################################################
#
#     [Documentation]                *Ceph Rados Gateway Creation*
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#             
#        ${response}                 PCC.Ceph Create Rgw
#                               ...  name=${CEPH_RGW_NAME}
#                               ...  poolName=${CEPH_RGW_POOLNAME}
#                               ...  targetNodes=${CEPH_RGW_NODES}
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]
#                               ...  service_ip=yes
#                           
#        ${status_code}              Get Response Status Code        ${response}   
#        ${message}                  Get Response Message        ${response}  
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}                   PCC.Ceph Wait Until Rgw Ready
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK      
#
#        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
#                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
#                                    Should Be Equal As Strings      ${backend_status}    OK 
#                                    
#        ${backend_status}           PCC.Ceph Rgw Verify Service IP BE
#                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
#                                    Should Be Equal As Strings      ${backend_status}    OK 
#                                    
####################################################################################################################################
#Create Rgw Configuration File (ServiceIp As NodeIp)
####################################################################################################################################
#    [Documentation]                        *Create Rgw Configuration File*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#                                           Sleep    2 minutes
#        ${accessKey}                       PCC.Ceph Get Rgw Access Key
#                                      ...  name=${CEPH_RGW_NAME}
#				       ...  ceph_cluster_name=ceph-pvt	
#
#        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
#                                      ...  name=${CEPH_RGW_NAME}
#				       ...  ceph_cluster_name=ceph-pvt	
#
#        ${status}                          PCC.Ceph Rgw Configure
#                                      ...  accessKey=${accessKey}
#                                      ...  secretKey=${secretKey}
#                                      ...  pcc=${SERVER_2_HOST_IP}
#                                      ...  targetNodeIp=0.0.0.0
#                                      ...  port=${CEPH_RGW_PORT}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Create Rgw Update Configuration File (ServiceIp As NodeIp)
####################################################################################################################################
#    [Documentation]                        *Create Rgw Configuration File*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#                                           Sleep    2 minutes
#        ${accessKey}                       PCC.Ceph Get Rgw Access Key
#                                      ...  name=${CEPH_RGW_NAME}
#					...  ceph_cluster_name=ceph-pvt
#
#        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
#                                      ...  name=${CEPH_RGW_NAME}
#					...  ceph_cluster_name=ceph-pvt
#
#        ${status}                          PCC.Ceph Rgw Configure
#                                      ...  pcc=${SERVER_2_HOST_IP}
#                                      ...  service_ip=0.0.0.0
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Create Rgw Bucket (ServiceIp As NodeIp)
####################################################################################################################################
#    [Documentation]                        *Create Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Make Bucket
#                                      ...  pcc=${SERVER_2_HOST_IP}
#                                      ...  targetNodeIp=${SERVER_2_HOST_IP}
#                                      ...  port=${CEPH_RGW_PORT}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#List Rgw Bucket (ServiceIp As NodeIp)
####################################################################################################################################
#    [Documentation]                        *List Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw List Buckets
#                                      ...  pcc=${SERVER_2_HOST_IP}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Update Rgw Configuration File With Data IP And Try To ADD File (ServiceIp As NodeIp)(Negative)
####################################################################################################################################
#    [Documentation]                        *Create Rgw Configuration File*
#
#
#        ${status}                          PCC.Ceph Rgw Update Configure
#                                      ...  pcc=${SERVER_2_HOST_IP}
#                                      ...  service_ip=no
#                                      ...  data_cidr=${IPAM_DATA_SUBNET_IP}
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Upload File To Bucket
#                                      ...  pcc=${SERVER_2_HOST_IP}
#                                      ...  targetNodeIp=${SERVER_2_HOST_IP}
#                                      ...  port=${CEPH_RGW_PORT}
#                                           Should Not Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Update Rgw Configuration File With Control IP And Try To ADD File (ServiceIp As NodeIp)
####################################################################################################################################
#    [Documentation]                        *Create Rgw Configuration File*
#
#        ${status}                          PCC.Ceph Rgw Update Configure
#                                      ...  pcc=${SERVER_2_HOST_IP}
#                                      ...  service_ip=yes
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Upload File To Bucket
#                                      ...  pcc=${SERVER_2_HOST_IP}
#                                      ...  targetNodeIp=${SERVER_2_HOST_IP}
#                                      ...  port=${CEPH_RGW_PORT}
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Verify File Is Upload on Pool (ServiceIp As NodeIp)
####################################################################################################################################
#    [Documentation]                        *Verify File Is Uploaded on Pool*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Verify File Upload To Pool
#                                      ...  poolName=${CEPH_RGW_POOLNAME}
#                                      ...  targetNodeIp=${SERVER_2_HOST_IP}
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Get A File From Rgw Bucket (ServiceIp As NodeIp)
####################################################################################################################################
#    [Documentation]                        *Get a file from Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Get File From Bucket
#                                      ...  pcc=${SERVER_2_HOST_IP}
#                                      ...  targetNodeIp=${SERVER_2_HOST_IP}
#                                      ...  port=${CEPH_RGW_PORT}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Delete Rgw Bucket When Bucket Is Not Empty (ServiceIp As NodeIp) (Negative)
####################################################################################################################################
#      [Documentation]                      *Delete Rgw Bucket When Bucket Is Not Empty*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Delete Bucket
#                                      ...  pcc=${SERVER_2_HOST_IP}
#                                      ...  targetNodeIp=${SERVER_2_HOST_IP}
#                                      ...  port=${CEPH_RGW_PORT}
#
#                                           Should Not Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Delete A File From Rgw Bucket (ServiceIp As NodeIp)
#####################################################################################################################################
#    [Documentation]                        *Delete a file from Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Delete File From Bucket
#                                      ...  pcc=${SERVER_2_HOST_IP}
#                                      ...  targetNodeIp=${SERVER_2_HOST_IP}
#                                      ...  port=${CEPH_RGW_PORT}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Delete Rgw Bucket (ServiceIp As NodeIp)
####################################################################################################################################
#      [Documentation]                      *Delete Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Delete Bucket
#                                      ...  pcc=${SERVER_2_HOST_IP}
#                                      ...  targetNodeIp=${SERVER_2_HOST_IP}
#                                      ...  port=${CEPH_RGW_PORT}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
#                                           
######################################################################################################################################
#Ceph Rados Remove S3Account (ServiceIp As NodeIp)
######################################################################################################################################
#     [Documentation]                 *Ceph Rados Gateway Update*
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#     
#        ${response}                 PCC.Ceph Update Rgw
#                               ...  ID=${rgw_id}
#                               ...  name=${CEPH_RGW_NAME}
#                               ...  poolName=${CEPH_RGW_POOLNAME}
#                               ...  targetNodes=${CEPH_RGW_NODES}
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rgw Ready
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
#                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
#                                    Should Be Equal As Strings      ${backend_status}    OK         
#                                    
#####################################################################################################################################
#Ceph Rados Gateway Delete (ServiceIp As NodeIp)
#####################################################################################################################################
#
#    [Documentation]                 *Ceph Rados Gateway Delete*
# 
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
# 
#        ${response}                 PCC.Ceph Delete Rgw
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#
#        ${status_code}              Get Response Status Code        ${response}    
#        ${message}                  Get Response Message        ${response} 
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rgw Deleted
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
#                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
#                                    Should Be Equal As Strings      ${backend_status}    OK                                    
###################################################################################################################################
#Ceph Rados Gateway Creation With Erasure Pool Without S3 Accounts
######################################################################################################################################
#
#     [Documentation]                 *Ceph Rados Gateway Creation*
#              
#        ${response}                 PCC.Ceph Create Rgw
#                               ...  name=${CEPH_RGW_NAME}
#                               ...  poolName=rados-erasure
#                               ...  targetNodes=${CEPH_RGW_NODES}
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                           
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_Cluster_NAME}
#                                    Should Be Equal As Strings      ${status}    OK       
#
#####################################################################################################################################
#Ceph Rados Gateway Delete 
#####################################################################################################################################
#
#    [Documentation]                 *Ceph Rados Gateway Delete*
#                             
#        ${response}                 PCC.Ceph Delete Rgw
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rgw Deleted
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
###################################################################################################################################
#Ceph Rados Gateway Creation With Erasure Pool With S3 Accounts
######################################################################################################################################
#
#     [Documentation]                 *Ceph Rados Gateway Creation*
#              
#        ${response}                 PCC.Ceph Create Rgw
#                               ...  name=${CEPH_RGW_NAME}
#                               ...  poolName=rados-erasure
#                               ...  targetNodes=${CEPH_RGW_NODES}
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]
#                           
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_Cluster_NAME}
#                                    Should Be Equal As Strings      ${status}    OK   
#
#####################################################################################################################################
#Ceph Rados Gateway Delete 
#####################################################################################################################################
#
#    [Documentation]                 *Ceph Rados Gateway Delete*
#                             
#        ${response}                 PCC.Ceph Delete Rgw
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rgw Deleted
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#                                   
#                                    
#####################################################################################################################################
Ceph Rados Create with Multiple Nodes
#####################################################################################################################################
     [Documentation]                 *Ceph Rados Gateway Create*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK  
  
        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=["${SERVER_2_NAME}","${SERVER_1_NAME}"]
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]
                               
        ${status_code}              Get Response Status Code        ${response}  
        ${message}                  Get Response Message        ${response}   
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK  

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK 
                                    
#####################################################################################################################################
Ceph Rados Remove One Node
#####################################################################################################################################
     [Documentation]                 *Ceph Rados Gateway Update*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt
     
        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=["${SERVER_2_NAME}"]
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]
                               
        ${status_code}              Get Response Status Code        ${response}    
        ${message}                  Get Response Message        ${response} 
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt	
                                    Should Be Equal As Strings      ${status}    OK  

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${SERVER_2_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK 
                                    
#####################################################################################################################################
Ceph Rados Gateway Delete 
#####################################################################################################################################

    [Documentation]                 *Ceph Rados Gateway Delete*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
                             
        ${response}                 PCC.Ceph Delete Rgw
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt

        ${status_code}              Get Response Status Code        ${response}  
        ${message}                  Get Response Message        ${response}   
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Deleted
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
                               ...  targetNodeIp=['${SERVER_2_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK
 				    Sleep    5 minutes

###################################################################################################################################
Ceph Rados Gateway Creation With Replicated Pool Without S3 Accounts For Non Ceph Node
#####################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
              
        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=rgw-non-ceph
                               ...  targetNodes=["${SERVER_3_NAME}"]
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                           
        ${status_code}              Get Response Status Code        ${response}  
        ${message}                  Get Response Message        ${response}   
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK      

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${SERVER_3_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK  

#####################################################################################################################################
Ceph Rados Gateway Delete 
#####################################################################################################################################

    [Documentation]                 *Ceph Rados Gateway Delete*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
                             
        ${response}                 PCC.Ceph Delete Rgw
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt

        ${status_code}              Get Response Status Code        ${response} 
        ${message}                  Get Response Message        ${response}    
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Deleted
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt	
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
                               ...  targetNodeIp=['${SERVER_3_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK
				    Sleep    5 minutes
                                    
#####################################################################################################################################
#App credentials associated with RGW instance would work with each node running RGW service 
######################################################################################################################################
#     [Documentation]                 *App credentials associated with RGW instance would work with each node running RGW service *
#     
#        ${response}                 PCC.Ceph Create Rgw
#                               ...  name=${CEPH_RGW_NAME}
#                               ...  poolName=${CEPH_RGW_POOLNAME}
#                               ...  targetNodes=["${SERVER_2_NAME}","${SERVER_1_NAME}"]
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_Cluster_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
#        ${accessKey}                PCC.Ceph Get Rgw Access Key
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#                              
#        ${secretKey}                PCC.Ceph Get Rgw Secret Key
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#                               
#        ${status}                   PCC.Ceph Rgw Configure
#                               ...  accessKey=${accessKey}
#                               ...  secretKey=${secretKey}
#                               ...  pcc=${PCC_HOST_IP}
#                               ...  targetNodeIp=${SERVER_2_HOST_IP}
#                               ...  port=${CEPH_RGW_PORT}
#                               
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
#        ${status}                   PCC.Ceph Rgw Make Bucket
#                               ...  accessKey=${accessKey}
#                               ...  secretKey=${secretKey}
#                               ...  pcc=${PCC_HOST_IP}
#                               ...  targetNodeIp=${SERVER_2_HOST_IP}
#                               ...  port=${CEPH_RGW_PORT}
#                               
#                                    Should Be Equal As Strings      ${status}    OK          
#
#        ${status}                   PCC.Ceph Rgw Configure
#                               ...  accessKey=${accessKey}
#                               ...  secretKey=${secretKey}
#                               ...  pcc=${PCC_HOST_IP}
#                               ...  targetNodeIp=${SERVER_2_HOST_IP}
#                               ...  port=${CEPH_RGW_PORT}
#                               
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
#        ${status}                   PCC.Ceph Rgw Make Bucket
#                               ...  accessKey=${accessKey}
#                               ...  secretKey=${secretKey}
#                               ...  pcc=${PCC_HOST_IP}
#                               ...  targetNodeIp=${SERVER_2_HOST_IP}
#                               ...  port=${CEPH_RGW_PORT}
#                               
#                                    Should Be Equal As Strings      ${status}    OK     
#
######################################################################################################################################
#Ceph Rados Gateway Delete 
######################################################################################################################################
#
#    [Documentation]                 *Ceph Rados Gateway Delete*
#                             
#        ${response}                 PCC.Ceph Delete Rgw
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rgw Deleted
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
######################################################################################################################################
#App-credentials do not work when they are deleted from Rgw
######################################################################################################################################
#     [Documentation]                 *App credentials associated with RGW instance would work with each node running RGW service *
#     
#        ${response}                 PCC.Ceph Create Rgw
#                               ...  name=${CEPH_RGW_NAME}
#                               ...  poolName=${CEPH_RGW_POOLNAME}
#                               ...  targetNodes=${CEPH_RGW_NODES}
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_Cluster_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
#        ${accessKey}                PCC.Ceph Get Rgw Access Key
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#                              
#        ${secretKey}                PCC.Ceph Get Rgw Secret Key
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#                               
#        ${status}                   PCC.Ceph Rgw Configure
#                               ...  accessKey=${accessKey}
#                               ...  secretKey=${secretKey}
#                               ...  pcc=${PCC_HOST_IP}
#                               ...  targetNodeIp=${SERVER_2_HOST_IP}
#                               ...  port=${CEPH_RGW_PORT}
#                               
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
#        ${status}                   PCC.Ceph Rgw Make Bucket
#                               ...  accessKey=${accessKey}
#                               ...  secretKey=${secretKey}
#                               ...  pcc=${PCC_HOST_IP}
#                               ...  targetNodeIp=${SERVER_2_HOST_IP}
#                               ...  port=${CEPH_RGW_PORT}
#                               
#                                    Should Be Equal As Strings      ${status}    OK     
#                                    
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#     
#        ${response}                 PCC.Ceph Update Rgw
#                               ...  ID=${rgw_id}
#                               ...  name=${CEPH_RGW_NAME}
#                               ...  poolName=${CEPH_RGW_POOLNAME}
#                               ...  targetNodes=${CEPH_RGW_NODES}
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_Cluster_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
#        ${status}                   PCC.Ceph Rgw Configure
#                               ...  accessKey=${accessKey}
#                               ...  secretKey=${secretKey}
#                               ...  pcc=${PCC_HOST_IP}
#                               ...  targetNodeIp=${SERVER_2_HOST_IP}
#                               ...  port=${CEPH_RGW_PORT}
#                               
#                                    Should Not Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete Metadata Profile
###################################################################################################################################

        [Documentation]         *Create Metadata Profile* test
                                ...  keywords:
                                ...  PCC.Delete Profile By Id
                                                              
        ${response}             PCC.Delete Profile By Id
                                ...    Name=${CEPH_RGW_S3ACCOUNTS}
                               
                                Log To Console    ${response}

