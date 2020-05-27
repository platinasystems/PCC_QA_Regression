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
Ceph Rbd Multiple Creation 
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Multiple Creation *
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Wait Until Rbd Ready

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}

#####################
        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd30
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=6
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd30

                                    Should Be Equal As Strings      ${status}    OK

#####################
        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd31
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd31

                                    Should Be Equal As Strings      ${status}    OK

#####################
        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd32
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd32

                                    Should Be Equal As Strings      ${status}    OK

#####################
        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd33
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd33

                                    Should Be Equal As Strings      ${status}    OK

#####################
        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd34
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd34

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Rbd Update - Edit name - Remove name (Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Update - Edit name - Remove name*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Rbd Update
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Wait Until Rbd Ready

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd-invalid1
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd-invalid1

                                    Should Be Equal As Strings      ${status}    OK


        ${id}                       PCC.Ceph Get Rbd Id
                               ...  name=rbd-invalid1

        ${response}                 PCC.Ceph Rbd Update
                               ...  id=${id}
                               ...  name=
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=1
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Rbd Update - Remove pool (Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Update - Remove pool*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Rbd Update
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Wait Until Rbd Ready

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}

        ${id}                       PCC.Ceph Get Rbd Id
                               ...  name=rbd-invalid1

        ${response}                 PCC.Ceph Rbd Update
                               ...  id=${id}
                               ...  name=rbd-invalid1
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=
                               ...  size=1
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Ceph Rbd Update Name - Rename
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Update Name - Rename*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Rbd Update
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Wait Until Rbd Ready

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd-up
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd-up

                                    Should Be Equal As Strings      ${status}    OK


        ${id}                       PCC.Ceph Get Rbd Id
                               ...  name=rbd-up

        ${response}                 PCC.Ceph Rbd Update
                               ...  id=${id}
                               ...  name=rbd-rename
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=1
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd-rename

                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
#Ceph RBD Resize - Create 1 RBD image with 1GiB (image-feature=layring) on one replicated profile pool(pool_quota>100GiB) and extend image to 100GiB
####################################################################################################################################
#    [Documentation]                 *Updating Ceph RBD Size*
# 
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=pool-rbd
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  quota=120
#                               ...  quota_unit=GiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=pool-rbd
#
#                                    Should Be Equal As Strings      ${status}    OK        
#
#        ${pool_id}                  PCC.Ceph Get Pool Id
#                               ...  name=pool-rbd
#
#        ${response}                 PCC.Ceph Create Rbd
#                               ...  name=rbd-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  ceph_pool_id=${pool_id}
#                               ...  size=1
#                               ...  tags=${CEPH_RBD_TAGS}
#                               ...  image_feature=${CEPH_RBD_IMG}
#                               ...  size_units=GiB
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}                   PCC.Ceph Wait Until Rbd Ready
#                               ...  name=rbd-1
#
#                                    Should Be Equal As Strings      ${status}    OK
#     
#        ${id}                       PCC.Ceph Get Rbd Id
#                               ...  name=rbd-1
#
#        ${response}                 PCC.Ceph Rbd Update
#                               ...  id=${id}
#                               ...  name=rbd-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  ceph_pool_id=${pool_id}
#                               ...  size=100
#                               ...  tags=${CEPH_RBD_TAGS}
#                               ...  image_feature=${CEPH_RBD_IMG}
#                               ...  size_units=GiB
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rbd Ready
#                               ...  name=rbd-1
#
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
####################################################################################################################################
#Ceph RBD Resize - Create 1 RBD image with 1GiB (image-feature=layring) on one replicated profile pool(pool_quota>10GiB) and extend image to 10GiB
####################################################################################################################################
#    [Documentation]                 *Updating Ceph RBD Size*
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=pool-rbd1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  quota=11
#                               ...  quota_unit=GiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=pool-rbd1
#
#        ${pool_id}                  PCC.Ceph Get Pool Id
#                               ...  name=pool-rbd1
#
#        ${response}                 PCC.Ceph Create Rbd
#                               ...  name=rbd-2
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  ceph_pool_id=${pool_id}
#                               ...  size=1
#                               ...  tags=${CEPH_RBD_TAGS}
#                               ...  image_feature=${CEPH_RBD_IMG}
#                               ...  size_units=GiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}                   PCC.Ceph Wait Until Rbd Ready
#                               ...  name=rbd-2
#
#                                    Should Be Equal As Strings      ${status}    OK
# 
#     
#        ${id}                       PCC.Ceph Get Rbd Id
#                               ...  name=rbd-2
#
#        ${response}                 PCC.Ceph Rbd Update
#                               ...  id=${id}
#                               ...  name=rbd-2
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  ceph_pool_id=${pool_id}
#                               ...  size=10
#                               ...  tags=${CEPH_RBD_TAGS}
#                               ...  image_feature=${CEPH_RBD_IMG}
#                               ...  size_units=GiB
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rbd Ready
#                               ...  name=rbd-2
#
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
###################################################################################################################################
Ceph Rbd Resize_decrease 
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Resize_decrease*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Rbd Update
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Wait Until Rbd Ready
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}
                               
        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd-3
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=5
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd-3

                                    Should Be Equal As Strings      ${status}    OK
                                    
        ${id}                       PCC.Ceph Get Rbd Id
                               ...  name=rbd-3

        ${response}                 PCC.Ceph Rbd Update
                               ...  id=${id}
                               ...  name=rbd-3
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=4
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd-3

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Rbd Update - Resize_increase - greater than pool quota
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Update - Resize_increase - greater than pool quota*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Rbd Update
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Wait Until Rbd Ready

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool-rbd2
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=10
                               ...  quota_unit=MiB

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool-rbd2

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=pool-rbd2

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd-invalid
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=3
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=MiB
                               
        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd-invalid

                                    Should Be Equal As Strings      ${status}    OK

        ${id}                       PCC.Ceph Get Rbd Id
                               ...  name=rbd-invalid

        ${response}                 PCC.Ceph Rbd Update
                               ...  id=${id}
                               ...  name=rbd-invalid
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=11
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=MiB

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

