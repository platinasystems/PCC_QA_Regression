*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Ipam Data    ${pcc_setup}
                                    Load Ceph Rbd Data    ${pcc_setup}
                                    Load Ceph Pool Data    ${pcc_setup}
                                    Load Ceph Rgw Data    ${pcc_setup}
                                    Load Ceph Fs Data    ${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup} 
                                    Load Network Manager Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

                                                                        
###################################################################################################################################
Ceph Cluster Creation
###################################################################################################################################
    [Documentation]                 *Creating Ceph Cluster*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready
                               ...  PCC.Ceph Verify BE
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Wait Until Pool Ready
                               ...  PCC.Ceph Pool Verify BE
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Pass Execution If    ${id} is not ${None}    Cluster is alredy Created

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK 

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Ceph Cluster Verification PCC
###################################################################################################################################
    [Documentation]                 *Verifying Ceph cluster*
                               ...  keywords:
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Cluster Verification Back End
###################################################################################################################################
    [Documentation]                 *Verifying Ceph cluster BE*
                               ...  keywords:
                               ...  PCC.Ceph Verify BE

        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Pool Creation And PCC Verification
###################################################################################################################################
    [Documentation]                 *Creating Ceph Pool*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Get Pcc Status
                               
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=${CEPH_POOL_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=${CEPH_POOL_NAME}

                                    Should Be Equal As Strings      ${status}    OK 
 
        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool1
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
        
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool1
                                    Should Be Equal As Strings      ${status}    OK
                                    
        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool2
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
 
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool2
                                    Should Be Equal As Strings      ${status}    OK 
        
        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool3
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool3
                                    Should Be Equal As Strings      ${status}    OK                                    
                                    
        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool4
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool4
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Pool
                               ...  name=${CEPH_RGW_POOLNAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=2
                               ...  quota_unit=GiB

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=${CEPH_RGW_POOLNAME}
                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Pool Verification Back End
###################################################################################################################################
    [Documentation]                 *Verifying Ceph Pool BE*
                               ...  keywords:
                               ...  PCC.Ceph Pool Verify BE

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK                               
                               
        ${status}                   PCC.Ceph Pool Verify BE
                               ...  name=${CEPH_POOL_NAME}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Rbd Creation
###################################################################################################################################
    [Documentation]                 *Creating Ceph Rbd*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
 
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
 
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=${CEPH_RBD_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Rbd Verification
###################################################################################################################################
    [Documentation]                 *Verifying Ceph RBD*
                               ...  keywords:
                               ...  PCC.Ceph Wait Until Rbd Ready
 
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
 
        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=${CEPH_RBD_NAME}

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Pool Update Size
###################################################################################################################################
    [Documentation]                 *Updating Ceph Pool Size*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Pool Update
                               ...  PCC.Ceph Wait Until Pool Ready

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}

        ${response}                 PCC.Ceph Pool Update
                               ...  id=${pool_id}
                               ...  name=${CEPH_POOL_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=1
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
                               

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=${CEPH_POOL_NAME}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Rbd Update Size
###################################################################################################################################
    [Documentation]                 *Updating Ceph RBD Size*
                               ...  keywords:
                               ...  PCC.Ceph Rbd Update
                               ...  PCC.Ceph Get Rbd Id
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Get Cluster Id
 
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}
     
        ${id}                       PCC.Ceph Get Rbd Id
                               ...  name=${CEPH_RBD_NAME}

        ${response}                 PCC.Ceph Rbd Update
                               ...  id=${id}
                               ...  name=${CEPH_RBD_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=1
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=${CEPH_RBD_NAME}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Rados Gateway Creation With Replicated Pool Without S3 Accounts
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
                               ...  certificateName=${CEPH_RGW_CERT_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_Cluster_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK

###################################################################################################################################
Ceph Fs Creation
###################################################################################################################################
    [Documentation]                 *Creating Cepf FS*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Create Fs
 
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK 
    
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Create Fs
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=[${data}]
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Ceph Fs Verification
###################################################################################################################################
    [Documentation]                 *Verifying Ceph FS*
                               ...  keywords:
                               ...  PCC.Ceph Wait Until Fs Ready

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
                               
        ${status}                   PCC.Ceph Wait Until Fs Ready
                               ...  name=${CEPH_FS_NAME}
                   
                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Ceph Fs Verification Back End
###################################################################################################################################
    [Documentation]                 *Verifying the Fs from BE*
                                ...  keywords:
                                ...  PCC.Ceph Fs Verify BE

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
                                
        ${status}                    PCC.Ceph Fs Verify BE
                                ...  name=${CEPH_FS_NAME}
                                ...  user=${PCC_LINUX_USER}
                                ...  password=${PCC_LINUX_PASSWORD}
                                ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
   
                                     Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Fs Update
###################################################################################################################################
    [Documentation]                 *Updating Ceph Fs*
                               ...  keywords:
                               ...  PCC.Ceph Get Fs Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Update Fs
                               ...  PCC.Ceph Wait Until Fs Ready

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
                                
        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=pool4

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Update Fs
                               ...  id=${id}
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=[${data}]
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Fs Ready
                               ...  name=${CEPH_FS_NAME}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Cluster Update - Add Invader
###################################################################################################################################
    [Documentation]                 *Ceph Cluster Update - Add Invade*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK 

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK
                                    

                                    
