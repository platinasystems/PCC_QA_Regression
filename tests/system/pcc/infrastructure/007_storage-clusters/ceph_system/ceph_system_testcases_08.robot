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
Create CephFS - with one pool created (Negative)
###################################################################################################################################
    [Documentation]                 *Create CephFS - with one pool created*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Create Fs


        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}


        ${response}                 PCC.Ceph Create Fs
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=
                               ...  default_pool=

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


        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Create Fs
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=
                               ...  data_pool=${data}
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


        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${response}                 PCC.Ceph Create Fs
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=${data}
                               ...  default_pool=

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


        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Create Fs
                               ...  name=
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=${data}
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


        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${default1}                 PCC.Ceph Get Pool Details For FS
                               ...  name= Pool4

        ${default2}                 PCC.Ceph Get Pool Details For FS
                               ...  name= Pool5

        ${response}                 PCC.Ceph Create Fs
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=${data}
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


        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${meta1}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool6

        ${meta2}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool7

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Create Fs
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=[${meta},${meta1},${meta2}]
                               ...  data_pool=${data}
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200    

###################################################################################################################################
Create CephFS - where name contains only special characters (Negative)
###################################################################################################################################
    [Documentation]                 *Create CephFS - where name contains only special characters*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Create Fs


        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=!@#$%^^

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
                                    Should Not Be Equal As Strings      ${status_code}  200    

###################################################################################################################################
Ceph Fs Creation and Verify
###################################################################################################################################
        [Documentation]             *Ceph Fs Creation and Verify*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Create Fs
                               ...  PCC.Ceph Wait Until Fs Ready                       


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

###################################################################################################################################
Update CephFS – when it is in deploying state (Negative) 
###################################################################################################################################
        [Documentation]             *Update CephFS – when it is in deploying state*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  Ceph Update Fs
                               ...  PCC.Ceph Wait Until Fs Ready 
                               
        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=pool4

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Update Fs
                               ...  id=${id}
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=${data}
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200


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
#
###################################################################################################################################
Ceph Fs Verification
###################################################################################################################################
    [Documentation]                 *Verifying Ceph FS*
                               ...  keywords:
                               ...  PCC.Ceph Wait Until Fs Ready

        ${status}                   PCC.Ceph Wait Until Fs Ready
                               ...  name=${CEPH_FS_NAME}

                                    Should Be Equal As Strings      ${status}    OK

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

        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}

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

        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${data1}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool7

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
                               ...  name=pool8

        ${response}                 PCC.Ceph Update Fs
                               ...  id=${id}
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=${data}
                               ...  default_pool=[${default},${default1}]

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

