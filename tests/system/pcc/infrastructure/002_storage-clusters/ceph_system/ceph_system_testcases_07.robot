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

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Ceph Rbd Resize_increase - equal to pool quota 
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Resize_increase - equal to pool quota*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready
                               ...  PCC.Ceph Rbd Update

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool-rbd0
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=10
                               ...  quota_unit=MiB

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool-rbd0



        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=pool-rbd0

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd-4
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=3
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd-4

                                    Should Be Equal As Strings      ${status}    OK

        ${id}                       PCC.Ceph Get Rbd Id
                               ...  name=rbd-4

        ${response}                 PCC.Ceph Rbd Update
                               ...  id=${id}
                               ...  name=rbd-4
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=10
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=MiB

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd-4

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Rbd Resize_increase 
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Resize_increase*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready
                               ...  PCC.Ceph Rbd Update

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd-5
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=5
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd-5

                                    Should Be Equal As Strings      ${status}    OK
                                    
        ${id}                       PCC.Ceph Get Rbd Id
                               ...  name=rbd-5

        ${response}                 PCC.Ceph Rbd Update
                               ...  id=${id}
                               ...  name=rbd-5
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=6
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd-5

                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
#Ceph Rbd Change pool (Negative)
####################################################################################################################################
#    [Documentation]                 *Creating Ceph Rbd*
#                               
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=pool-rbd3
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  quota=10
#                               ...  quota_unit=MiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=pool-rbd3
#                               
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=pool-rbd4
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  quota=10
#                               ...  quota_unit=MiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=pool-rbd4
#
#        ${pool_id}                  PCC.Ceph Get Pool Id
#                               ...  name=pool-rbd3
#                               
#        ${response}                 PCC.Ceph Create Rbd
#                               ...  name=rbd66
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  ceph_pool_id=${pool_id}
#                               ...  size=${CEPH_RBD_SIZE}
#                               ...  tags=${CEPH_RBD_TAGS}
#                               ...  image_feature=${CEPH_RBD_IMG}
#                               ...  size_units=${CEPH_RBD_SIZE_UNIT}
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}                   PCC.Ceph Wait Until Rbd Ready
#                               ...  name=rbd66
#
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
#        ${id}                       PCC.Ceph Get Rbd Id
#                               ...  name=rbd66
#                               
#        ${pool_id}                  PCC.Ceph Get Pool Id
#                               ...  name=pool-rbd4
#
#        ${response}                 PCC.Ceph Rbd Update
#                               ...  id=${id}
#                               ...  name=rbd66
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
#                                    
###################################################################################################################################
Ceph Fs Creation
###################################################################################################################################
    [Documentation]                 *Creating Cepf FS*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Create Fs


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
                               ...  data_pool=${data}
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

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${data1}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool4

        ${data2}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool5

        ${data3}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool6

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
Create CephFS - deploying and completed status 
###################################################################################################################################
    [Documentation]                 *Create CephFS - deploying and completed status*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Create Fs
                               ...  PCC.Ceph Wait Until Fs Ready
                               ...  PCC.Ceph Wait Until Fs Deleted
                               ...  PCC.Ceph Get Fs Id
                               ...  PCC.Ceph Fs Verify BE    

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
                               ...  data_pool=${data}
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

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Create Fs
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=
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


        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Fs
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=
                               ...  data_pool=
                               ...  default_pool=

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

