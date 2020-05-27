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
Ceph 2 RBDs with same name (Negative)
###################################################################################################################################
     [Documentation]                *Ceph 2 RBDs with same name*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=abc
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=abc

                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=abc
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Ceph Rbd Creation without rdb name (Negative)
###################################################################################################################################
     [Documentation]                *Ceph Rbd Creation without rdb name*
                               ...  keywords:
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
#Ceph Rbd where name contain special character "!@#$%^" (Negative)
####################################################################################################################################
#     [Documentation]                *Ceph Rbd where name contain special character "!@#$%^"*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Pool Id
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Create Rbd
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${pool_id}                  PCC.Ceph Get Pool Id
#                               ...  name=${CEPH_POOL_NAME}
#
#        ${response}                 PCC.Ceph Create Rbd
#                               ...  name=!@#$%^
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
####################################################################################################################################
#Ceph Rbd without pool name (Negative)
####################################################################################################################################
#     [Documentation]                *Ceph Rbd without pool name*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Pool Id
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Create Rbd
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${pool_id}                  PCC.Ceph Get Pool Id
#                               ...  name=${CEPH_POOL_NAME}
#
#        ${response}                 PCC.Ceph Create Rbd
#                               ...  name=${CEPH_RBD_NAME}
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  ceph_pool_id=
#                               ...  size=${CEPH_RBD_SIZE}
#                               ...  tags=${CEPH_RBD_TAGS}
#                               ...  image_feature=${CEPH_RBD_IMG}
#                               ...  size_units=${CEPH_RBD_SIZE_UNIT}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Not Be Equal As Strings      ${status_code}  200
#                                    
###################################################################################################################################
Ceph Rbd without pool(Negative)
###################################################################################################################################
     [Documentation]                *Ceph Rbd without pool*
                               ...  keywords:
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=xzymn

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=${CEPH_RBD_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create RBD and when it is in deploying state then try to delete it (Negative)
###################################################################################################################################
     [Documentation]                *Create RBD and when it is in deploying state then try to delete it*
                               ...  keywords:
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=abc1
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${id}                       PCC.Ceph Get Rbd Id
                               ...  name=abc1
                                    Pass Execution If    ${id} is ${None}    Rbd is alredy Deleted

        ${response}                 PCC.Ceph Delete Rbd
                               ...  id=${id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Ceph Rbd where size unit is in MiB
###################################################################################################################################
    [Documentation]                 *Ceph Rbd where size unit is in MiB*
                               ...  keywords:
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready

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
                               ...  size_units=MiB

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=${CEPH_RBD_NAME}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
#Ceph Rbd where size unit is in GiB
#####################################################################################################################################
#    [Documentation]                 *Creating Ceph Rbd*
#                            
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${pool_id}                  PCC.Ceph Get Pool Id
#                               ...  name=${CEPH_POOL_NAME}
#                               
#        ${response}                 PCC.Ceph Create Rbd
#                               ...  name=rbd1
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
#                               ...  name=rbd1
#
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
#####################################################################################################################################
#Ceph Rbd where size unit is in TiB
#####################################################################################################################################
#    [Documentation]                 *Creating Ceph Rbd*
#                               
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${pool_id}                  PCC.Ceph Get Pool Id
#                               ...  name=${CEPH_POOL_NAME}
#                               
#        ${response}                 PCC.Ceph Create Rbd
#                               ...  name=rbd2
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  ceph_pool_id=${pool_id}
#                               ...  size=1
#                               ...  tags=${CEPH_RBD_TAGS}
#                               ...  image_feature=${CEPH_RBD_IMG}
#                               ...  size_units=TiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}                   PCC.Ceph Wait Until Rbd Ready
#                               ...  name=rbd2
#
#                                    Should Be Equal As Strings      ${status}    OK
#
#####################################################################################################################################
#Ceph Rbd where size unit is in PiB
#####################################################################################################################################
#    [Documentation]                 *Creating Ceph Rbd*
#                               
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${pool_id}                  PCC.Ceph Get Pool Id
#                               ...  name=${CEPH_POOL_NAME}
#                               
#        ${response}                 PCC.Ceph Create Rbd
#                               ...  name=rbd3
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  ceph_pool_id=${pool_id}
#                               ...  size=1
#                               ...  tags=${CEPH_RBD_TAGS}
#                               ...  image_feature=${CEPH_RBD_IMG}
#                               ...  size_units=PiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}                   PCC.Ceph Wait Until Rbd Ready
#                               ...  name=rbd3
#
#                                    Should Be Equal As Strings      ${status}    OK
#
#####################################################################################################################################
#Ceph Rbd where size unit is in EiB
#####################################################################################################################################
#    [Documentation]                 *Creating Ceph Rbd*
#                               
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${pool_id}                  PCC.Ceph Get Pool Id
#                               ...  name=${CEPH_POOL_NAME}
#                               
#        ${response}                 PCC.Ceph Create Rbd
#                               ...  name=rbd4
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  ceph_pool_id=${pool_id}
#                               ...  size=1
#                               ...  tags=${CEPH_RBD_TAGS}
#                               ...  image_feature=${CEPH_RBD_IMG}
#                               ...  size_units=EiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}                   PCC.Ceph Wait Until Rbd Ready
#                               ...  name=rbd4
#
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
###################################################################################################################################
Ceph 2 RBDs using same pool
###################################################################################################################################
    [Documentation]                 *Ceph 2 RBDs using same pool*
                               ...  keywords:
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready


        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd5
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd5

                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd6
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd6

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Rbd with ROTATIONAL and SOLID_STATE tags
###################################################################################################################################
    [Documentation]                 *Ceph Rbd with ROTATIONAL and SOLID_STATE tags*
                               ...  keywords:
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd7
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=["ROTATIONAL","SOLID_STATE"]
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd7

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Rbd with ROTATIONAL and ALL tags
###################################################################################################################################
    [Documentation]                 *Ceph Rbd with ROTATIONAL and ALL tags*
                               ...  keywords:
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd8
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=["All"]
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd8

                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Ceph 2 RBDs with same pool, size, size unit and tags
###################################################################################################################################
    [Documentation]                 *Ceph 2 RBDs with same pool, size, size unit and tags*
                               ...  keywords:
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready


        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd9
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd9

                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=rbd10
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd10

                                    Should Be Equal As Strings      ${status}    OK

