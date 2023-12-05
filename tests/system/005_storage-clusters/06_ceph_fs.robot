*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
       
                                    Load Ceph Rbd Data    ${pcc_setup}
                                    Load Ceph Pool Data    ${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Ceph Fs Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    Load K8s Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Ceph Delete Unused Pools
###################################################################################################################################

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${status}                   PCC.Ceph Delete Unused Pools
                               ...  ceph_cluster_id=${cluster_id}
                                    Should be equal as strings    ${status}    OK

                                    sleep  1m

##################################################################################################################################
Ceph Create Pool For CephFS
###################################################################################################################################
    [Documentation]                 *Ceph Create For CephFS*

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool Multiple
                               ...  count=8
                               ...  name=pool
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                               ...  quota=1
                               ...  quota_unit=GiB

                                    Should Be Equal As Strings      ${response}  OK

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=${CEPH_FS_META}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=${CEPH_FS_DATA}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=${CEPH_FS_DEFAULT}
                                    Should Be Equal As Strings      ${status}    OK

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

        ${status}                   PCC.Ceph Wait Until Fs Ready
                               ...  name=${CEPH_FS_NAME}

                                    Should Be Equal As Strings      ${status}    OK

        ${status}                    PCC.Ceph Fs Verify BE
                                ...  name=${CEPH_FS_NAME}
                                ...  user=${PCC_LINUX_USER}
                                ...  password=${PCC_LINUX_PASSWORD}
                                ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}

                                     Should Be Equal As Strings      ${status}    OK

##################################################################################################################################
Ceph MDS State
###################################################################################################################################
    [Documentation]                 *Ceph MDS State*


        ${response}                 PCC.Ceph Get MDS State
                               ...  name=${CEPH_CLUSTER_NAME}

                                    Should Be Equal As Strings      ${response}  OK

###################################################################################################################################
Check Pool Used By FS
###################################################################################################################################
    [Documentation]                 *Check Pool Used By FS*

    ${cluster_id}                   PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

    ${response}                     PCC.Ceph Pool Check Used By
                               ...  name=${CEPH_FS_DATA}
                               ...  used_by_type=fs
                               ...  used_by_name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}

                                    Should Be Equal As Strings      ${response}    OK

        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}
                                    Pass Execution If    ${id} is ${None}    Fs is alredy Deleted

        ${response}                 PCC.Ceph Delete Fs
                               ...  id=${id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Fs Deleted
                               ...  id=${id}
                                    Should Be Equal     ${status}  OK


###################################################################################################################################
Create CephFS - with mutiple data pools
###################################################################################################################################
    [Documentation]                 *Create CephFS - with mutiple data pools*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Create Fs
                               ...  PCC.Ceph Wait Until Fs Ready
                               ...  PCC.Ceph Wait Until Fs Deleted
                               ...  PCC.Ceph Get Fs Id
                               ...  PCC.Ceph Fs Verify BE

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${data1}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool-4

        ${data2}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool-5

        ${data3}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool-6

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Create Fs
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=[${data},${data1},${data2},${data3}]
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Fs Ready
                               ...  name=${CEPH_FS_NAME}

                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Fs Verify BE
                               ...  name=${CEPH_FS_NAME}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}

                                    Should Be Equal As Strings      ${status}    OK

        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}
                                    Pass Execution If    ${id} is ${None}    Fs is alredy Deleted

        ${response}                 PCC.Ceph Delete Fs
                               ...  id=${id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Fs Deleted
                               ...  id=${id}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Create CephFS - without selecting data pool
###################################################################################################################################
    [Documentation]                 *Create CephFS - without selecting data pool*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Create Fs
                               ...  PCC.Ceph Wait Until Fs Ready
                               ...  PCC.Ceph Wait Until Fs Deleted
                               ...  PCC.Ceph Get Fs Id
                               ...  PCC.Ceph Fs Verify BE   

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}


        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Create Fs
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Fs Ready
                               ...  name=${CEPH_FS_NAME}

                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Fs Verify BE
                               ...  name=${CEPH_FS_NAME}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}

                                    Should Be Equal As Strings      ${status}    OK

        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}
                                    Pass Execution If    ${id} is ${None}    Fs is alredy Deleted

        ${response}                 PCC.Ceph Delete Fs
                               ...  id=${id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Fs Deleted
                               ...  id=${id}
                                    Should Be Equal     ${status}  OK


###################################################################################################################################
Create CephFS - without pool creation (Negative)
###################################################################################################################################
    [Documentation]                 *Create CephFS - without pool creation*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Create Fs

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Fs
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create CephFS - without selecting metadata pool (Negative)
###################################################################################################################################
    [Documentation]                 *Create CephFS - without selecting metadata pool*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Create Fs

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Create Fs
                               ...  name=cfs2
                               ...  ceph_cluster_id=${cluster_id}
                               ...  data_pool=[${data}]
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create CephFS - without selecting default pool (Negative)
###################################################################################################################################
    [Documentation]                 *Create CephFS - without selecting default pool*
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

        ${response}                 PCC.Ceph Create Fs
                               ...  name=cfs3
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=[${data}]

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create CephFS - without CephFS name (Negative) 
###################################################################################################################################
    [Documentation]                 *Create CephFS - without CephFS name*
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
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=[${data}]
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200    

###################################################################################################################################
Create CephFS - with multiple default pools (Negative) 
###################################################################################################################################
    [Documentation]                 *Create CephFS - with multiple default pools*
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

        ${default1}                 PCC.Ceph Get Pool Details For FS
                               ...  name= pool-4

        ${default2}                 PCC.Ceph Get Pool Details For FS
                               ...  name= pool-5

        ${response}                 PCC.Ceph Create Fs
                               ...  name=cfs4
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=[${data}]
                               ...  default_pool=[${default},${default1},${default2}]

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200    

###################################################################################################################################
Create CephFS - with multiple metadata pools (Negative) 
###################################################################################################################################
    [Documentation]                 *Create CephFS - with multiple metadata pools*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Create Fs

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${meta1}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool-6

        ${meta2}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool-7

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Create Fs
                               ...  name=cfs5
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=[${meta},${meta1},${meta2}]
                               ...  data_pool=[${data}]
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200    

####################################################################################################################################
#Create CephFS - where name contains only special characters (Negative)
####################################################################################################################################
#    [Documentation]                 *Create CephFS - where name contains only special characters*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Get Pool Details For FS
#                               ...  PCC.Ceph Create Fs
#
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME}
#
#        ${meta}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=${CEPH_FS_META}
#
#        ${data}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=${CEPH_FS_DATA}
#
#        ${default}                  PCC.Ceph Get Pool Details For FS
#                               ...  name=${CEPH_FS_DEFAULT}
#
#        ${response}                 PCC.Ceph Create Fs
#                               ...  name=!@#$%^^
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  metadata_pool=${meta}
#                               ...  data_pool=[${data}]
#                               ...  default_pool=${default}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Not Be Equal As Strings      ${status_code}  200    
#                                    
###################################################################################################################################
Ceph Fs Creation and Verify
###################################################################################################################################
        [Documentation]             *Ceph Fs Creation and Verify*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Create Fs
                               ...  PCC.Ceph Wait Until Fs Ready                       

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
Update CephFS – when it is in deploying state (Negative) 
###################################################################################################################################
        [Documentation]             *Update CephFS – when it is in deploying state*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  Ceph Update Fs
                               ...  PCC.Ceph Wait Until Fs Ready 

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
                               
        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=pool-4

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

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
                                    Should Not Be Equal As Strings      ${status_code}  200
        
        ${status}                   PCC.Ceph Wait Until Fs Ready
                               ...  name=${CEPH_FS_NAME}
                               
                                    Should Be Equal As Strings      ${status}    OK
        
###################################################################################################################################
#Pools used for CephFS should not be shown in rbd create pool_list (Negative)
####################################################################################################################################
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#                               
#        ${pool_id}                  PCC.Ceph Get Pool Id
#                               ...  name=${CEPH_FS_DATA}
#                               
#        ${response}                 PCC.Ceph Create Rbd
#                               ...  name=rbd-fail
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  ceph_pool_id=${pool_id}
#                               ...  size=${CEPH_RBD_SIZE}
#                               ...  tags=${CEPH_RBD_TAGS}
#                               ...  image_feature=${CEPH_RBD_IMG}
#                               ...  size_units=${CEPH_RBD_SIZE_UNIT}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Not Be Equal As Strings      ${status_code}  200
#                                    
###################################################################################################################################
#Remove pool – which is a part of CephFS (Negative)
####################################################################################################################################
#    [Documentation]                 *Delete Pool if it exist*
#                               
#        ${id}                       PCC.Ceph Get Pool Id
#                               ...  name=${CEPH_FS_DATA}
#                                    Pass Execution If    ${id} is ${None}    Pool is alredy Deleted
#
#        ${response}                 PCC.Ceph Delete Pool
#                               ...  id=${id}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Not Be Equal As Strings      ${status_code}  200
#                                    

###################################################################################################################################
Ceph Fs Update with multiple pool data
###################################################################################################################################
    [Documentation]                 *Ceph Fs Update with multiple pool data*
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
                               ...  name=${CEPH_FS_DATA}

        ${data1}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool-4

        ${data2}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool-5

        ${data3}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool-6

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Update Fs
                               ...  id=${id}
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=[${data},${data1},${data2},${data3}]
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Fs Ready
                               ...  name=${CEPH_FS_NAME}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Fs Update Data Pool with One pool data 
###################################################################################################################################
    [Documentation]                 *Ceph Fs Update Data Pool with One pool data*
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
                               ...  name=${CEPH_FS_DATA}

        ${data1}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool-7

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Update Fs
                               ...  id=${id}
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=[${data},${data1}]
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Fs Ready
                               ...  name=${CEPH_FS_NAME}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Update CephFS - add_default_pool (Negative)
###################################################################################################################################
    [Documentation]                 *Update CephFS - add_default_pool*
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
                               ...  name=${CEPH_FS_DATA}

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${default1}                 PCC.Ceph Get Pool Details For FS
                               ...  name=pool-8

        ${response}                 PCC.Ceph Update Fs
                               ...  id=${id}
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=[${data}]
                               ...  default_pool=[${default},${default1}]

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Update CephFS - add_metadata_pool (Negative)
###################################################################################################################################
    [Documentation]                 *Update CephFS - add_metadata_pool*
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

        ${meta1}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool-8

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}


        ${response}                 PCC.Ceph Update Fs
                               ...  id=${id}
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=[${meta},${meta1}]
                               ...  data_pool=[${data}]
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Update CephFS - remove_default_pool (Negative)
###################################################################################################################################
    [Documentation]                 *Update CephFS - remove_default_pool*
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
                               ...  name=${CEPH_FS_DATA}

        ${response}                 PCC.Ceph Update Fs
                               ...  id=${id}
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=[${data}]


        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Update CephFS - remove_data_pools 
###################################################################################################################################
    [Documentation]                 *Update CephFS - remove_default_pool*
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

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Update Fs
                               ...  id=${id}
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Fs Ready
                               ...  name=${CEPH_FS_NAME}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Update CephFS - remove_data_pool_along_with_default_data_pool 
###################################################################################################################################
    [Documentation]                 *Update CephFS - remove_data_pool_along_with_default_data_pool*
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

        ${response}                 PCC.Ceph Update Fs
                               ...  id=${id}
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}


        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Ceph Cluster Delete when Ceph FS is present (Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster Delete when Ceph FS is present*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Delete Cluster
                               ...  PCC.Ceph Wait Until Cluster Deleted
                               ...  PCC.Ceph Cleanup BE

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Pass Execution If    ${id} is ${None}    Cluster is alredy Deleted

        ${response}                 PCC.Ceph Delete Cluster
                               ...  id=${id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Fs Delete To Create Another
###################################################################################################################################
    [Documentation]                 *Delete Fs if it exist*   
                               ...  keywords:
                               ...  PCC.Ceph Get Fs Id
                               ...  PCC.Ceph Delete Fs
                               ...  PCC.Ceph Wait Until Fs Deleted

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}
                                    Pass Execution If    ${id} is ${None}    Fs is alredy Deleted

        ${response}                 PCC.Ceph Delete Fs
                               ...  id=${id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Fs Deleted
                               ...  id=${id}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Pool released from RBD is used for creating/updating CephFS
###################################################################################################################################
    [Documentation]                 *Pool released from RBD is used for creating/updating CephFS*   
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool Multiple
                               ...  PCC.Ceph Wait Until Pool Ready
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready
                               ...  PCC.Ceph Get Rbd Id
                               ...  PCC.Ceph Delete Rbd
                               ...  PCC.Ceph Wait Until Rbd Deleted
                               ...  PCC.Ceph Get Fs Id
                               ...  PCC.Ceph Wait Until Fs Ready
                               ...  PCC.Ceph Create Fs
                               ...  PCC.Ceph Wait Until Fs Ready

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool Multiple
                               ...  count=3
                               ...  name=fs
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                               ...  quota=1
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

                                    Should Be Equal As Strings      ${response}  OK

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=fs-3

                                    Should Be Equal As Strings      ${status}    OK


        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=fs-1

        ${response}                 PCC.Ceph Create Rbd
                               ...  pool_type=replicated
			                   ...  name=fs-rbd
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=fs-rbd

                                    Should Be Equal As Strings      ${status}    OK

        ${id}                       PCC.Ceph Get Rbd Id
                               ...  name=fs-rbd
                                    Pass Execution If    ${id} is ${None}    Rbd is alredy Deleted

        ${response}                 PCC.Ceph Delete Rbd
                               ...  id=${id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rbd Deleted
                               ...  id=${id}
                                    Should Be Equal     ${status}  OK

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=fs-1

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=fs-2

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=fs-3
        ${response}                 PCC.Ceph Create Fs
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
Mount FS test case
################################################################################################################################### 

        ###  Get INET IP  ###
        ${inet_ip}     PCC.Get CEPH Inet IP
                       ...    hostip=${SERVER_1_HOST_IP}

                       Log To Console    ${inet_ip}
                       Set Global Variable    ${inet_ip}

        ###  Get Stored size before mount  ###
        ${size_replicated_pool_before_mount}      PCC.Get Stored Size for Replicated Pool
                                                  ...    hostip=${SERVER_2_HOST_IP}
                                                  ...    pool_name=fs-3

                                                  Log To Console    ${size_replicated_pool_before_mount}
                                                  Set Suite Variable    ${size_replicated_pool_before_mount}

        ###  Mount FS to Mount Point  ###


        ${status}    Create mount folder
                     ...    mount_folder_name=test_fs_mnt
                     ...    hostip=${SERVER_2_HOST_IP}
                     ...    user=${PCC_LINUX_USER}
                     ...    password=${PCC_LINUX_PASSWORD}

                     Log To Console    ${status}
                     Should be equal as strings    ${status}    OK

        ${status}      PCC.Mount FS to Mount Point
                       ...    mount_folder_name=test_fs_mnt
                       ...    hostip=${SERVER_2_HOST_IP}
                       ...    user=${PCC_LINUX_USER}
                       ...    password=${PCC_LINUX_PASSWORD}
		       ...    inet_ip=${inet_ip}

                       Log To Console    ${status}
                       Should be equal as strings    ${status}    OK

                       Sleep    1 minutes 

        ${status}      Create dummy file and copy to mount path
                       ...    dummy_file_name=test_fs_mnt_1mb.bin
                       ...    dummy_file_size=1KiB
                       ...    mount_folder_name=test_fs_mnt
                       ...    hostip=${SERVER_2_HOST_IP}
                       ...    user=${PCC_LINUX_USER}
                       ...    password=${PCC_LINUX_PASSWORD}  

                       Log To Console    ${status}
                       Should be equal as strings    ${status}    OK     

                       Sleep    2 minutes  


        ###  Get Stored size after mount  ###
        ${size_replicated_pool_after_mount}     PCC.Get Stored Size for Replicated Pool
						...    hostip=${SERVER_2_HOST_IP}
                                                ...    pool_name=fs-3

                                                Log To Console    ${size_replicated_pool_after_mount}
                                                Set Suite Variable    ${size_replicated_pool_after_mount}
                                                Should Be True    ${size_replicated_pool_after_mount} > ${size_replicated_pool_before_mount}

        

        ###  Unmount FS and removing file created while FS mount ###                                            
        ${status}      PCC.Unmount FS
                       ...    hostip=${SERVER_2_HOST_IP} 
                       ...    user=${PCC_LINUX_USER}
                       ...    password=${PCC_LINUX_PASSWORD}
                       ...    mount_folder_name=test_fs_mnt

                       Log To Console    ${status}
                       Should be equal as strings    ${status}    OK    

         ${status}    Remove dummy file
                     ...    dummy_file_name=test_fs_mnt_1mb.bin
                     ...    hostip=${SERVER_2_HOST_IP} 
                     ...    user=${PCC_LINUX_USER}
                     ...    password=${PCC_LINUX_PASSWORD}         

		     Log To Console    ${status}
                     Should be equal as strings    ${status}    OK


###################################################################################################################################
Fetching Ceph FS ID before backup
###################################################################################################################################   

         ${ceph_fs_id_before_backup}        PCC.Ceph Get Fs Id
                                            ...  name=${CEPH_FS_NAME}                            
                                            Log To Console    ${ceph_fs_id_before_backup}
                                            Set Global Variable    ${ceph_fs_id_before_backup}

###################################################################################################################################
Ceph Fs Delete
###################################################################################################################################
    [Documentation]                 *Delete Fs if it exist*
                               ...  keywords:
                               ...  PCC.Ceph Delete All Fs
        ${status}                   PCC.Ceph Delete All Fs
                                    Should be equal as strings    ${status}    OK
                      
