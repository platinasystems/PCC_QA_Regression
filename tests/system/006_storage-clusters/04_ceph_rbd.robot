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
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    Load K8s Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK
 
 
###################################################################################################################################
Ceph Rbd Creation with decimal RBD size (Negative)
###################################################################################################################################
     [Documentation]                 *Ceph Rbd Creation with decimal RBD size*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}
                               
        ${response}                 PCC.Ceph Create Rbd
                               ...  name=${CEPH_RBD_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=1.2
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Rbd Creation with negative RBD size (Negative)
###################################################################################################################################
     [Documentation]                 *Ceph Rbd Creation with negative RBD size*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}
                               
        ${response}                 PCC.Ceph Create Rbd
                               ...  name=${CEPH_RBD_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=-1
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Rbd Creation with zero RBD size (Negative)
###################################################################################################################################
     [Documentation]                 *Ceph Rbd Creation with zero RBD size*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}
                               
        ${response}                 PCC.Ceph Create Rbd
                               ...  name=${CEPH_RBD_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=0
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Ceph Rbd Creation with alphabet or special charaters RBD size (Negative)
###################################################################################################################################
     [Documentation]                 *Ceph Rbd Creation with alphabet or special charaters RBD size*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}
                               
        ${response}                 PCC.Ceph Create Rbd
                               ...  name=${CEPH_RBD_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=asda23
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Rbd Creation without image size (Negative)
###################################################################################################################################
     [Documentation]                 *Ceph Rbd Creation without image size*
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
                               ...  size=None
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Ceph 2 RBDs with same name (Negative)
###################################################################################################################################
     [Documentation]                *Ceph 2 RBDs with same name*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

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

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

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
###################################################################################################################################
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

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

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

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

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

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

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
#Ceph Rbd with ROTATIONAL and SOLID_STATE tags
####################################################################################################################################
#    [Documentation]                 *Ceph Rbd with ROTATIONAL and SOLID_STATE tags*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Pool Id
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Create Rbd
#                               ...  PCC.Ceph Wait Until Rbd Ready
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${pool_id}                  PCC.Ceph Get Pool Id
#                               ...  name=${CEPH_POOL_NAME}
#
#        ${response}                 PCC.Ceph Create Rbd
#                               ...  name=rbd7
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  ceph_pool_id=${pool_id}
#                               ...  size=${CEPH_RBD_SIZE}
#                               ...  tags=["ROTATIONAL","SOLID_STATE"]
#                               ...  image_feature=${CEPH_RBD_IMG}
#                               ...  size_units=${CEPH_RBD_SIZE_UNIT}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}                   PCC.Ceph Wait Until Rbd Ready
#                               ...  name=rbd7
#
#                                    Should Be Equal As Strings      ${status}    OK
#
###################################################################################################################################
#Ceph Rbd with ROTATIONAL and ALL tags
####################################################################################################################################
#    [Documentation]                 *Ceph Rbd with ROTATIONAL and ALL tags*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Pool Id
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Create Rbd
#                               ...  PCC.Ceph Wait Until Rbd Ready
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${pool_id}                  PCC.Ceph Get Pool Id
#                               ...  name=${CEPH_POOL_NAME}
#
#        ${response}                 PCC.Ceph Create Rbd
#                               ...  name=rbd8
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  ceph_pool_id=${pool_id}
#                               ...  size=${CEPH_RBD_SIZE}
#                               ...  tags=["All"]
#                               ...  image_feature=${CEPH_RBD_IMG}
#                               ...  size_units=${CEPH_RBD_SIZE_UNIT}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}                   PCC.Ceph Wait Until Rbd Ready
#                               ...  name=rbd8
#
#                                    Should Be Equal As Strings      ${status}    OK
#
###################################################################################################################################
Ceph 2 RBDs with same pool, size, size unit and tags
###################################################################################################################################
    [Documentation]                 *Ceph 2 RBDs with same pool, size, size unit and tags*
                               ...  keywords:
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

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

###################################################################################################################################
Ceph Rbd Multiple Creation 
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Multiple Creation *
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Wait Until Rbd Ready

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

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

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

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

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

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

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

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
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
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
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
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
  
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
  
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

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool-rbd2
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
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

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool-rbd0
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
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

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

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
Ceph Rbd Mount Test
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Mount Test*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready
                               ...  PCC.Ceph Rbd Update
							   
							   
        ###  Get INET IP  ###
        ${inet_ip}     PCC.Get CEPH Inet IP
                       ...    hostip=${SERVER_1_HOST_IP}

                       Log To Console    ${inet_ip}
                       Set Global Variable    ${inet_ip}

        ###  Get Stored size before mount  ###
        ${size_replicated_pool_before_mount}      PCC.Get Stored Size for Replicated Pool
                                                  ...    hostip=${SERVER_1_HOST_IP}
                                                  ...    pool_name=${CEPH_POOL_NAME}

                                                  Log To Console    ${size_replicated_pool_before_mount}
                                                  Set Suite Variable    ${size_replicated_pool_before_mount}

        ###  Mount RBD to Mount Point  ###


        ${status}    Create mount folder
                     ...    mount_folder_name=test_rbd_mnt
                     ...    hostip=${SERVER_1_HOST_IP}
                     ...    user=${PCC_LINUX_USER}
                     ...    password=${PCC_LINUX_PASSWORD}

                     Log To Console    ${status}
                     Should be equal as strings    ${status}    OK

        ${status}    PCC.Map RBD
					 ...    name=rbd-5
					 ...    pool_name=${CEPH_POOL_NAME}
					 ...    inet_ip=${inet_ip}
					 
					 Log To Console    ${status}
                     Should be equal as strings    ${status}    OK
		
		
		${status}      PCC.Mount RBD to Mount Point
                       ...    mount_folder_name=test_rbd_mnt
                       ...    hostip=${SERVER_1_HOST_IP}
                       ...    username=${PCC_LINUX_USER}
                       ...    password=${PCC_LINUX_PASSWORD}

                       Log To Console    ${status}
                       Should be equal as strings    ${status}    OK

                       Sleep    1 minutes 

        ${status}      Create dummy file and copy to mount path
                       ...    dummy_file_name=test_rbd_mnt_4mb.bin
                       ...    dummy_file_size=4MiB
                       ...    mount_folder_name=test_rbd_mnt
                       ...    hostip=${SERVER_1_HOST_IP}
                       ...    user=${PCC_LINUX_USER}
                       ...    password=${PCC_LINUX_PASSWORD}  

                       Log To Console    ${status}
                       Should be equal as strings    ${status}    OK     

                       Sleep    2 minutes  


        ###  Get Stored size after mount  ###
        ${size_replicated_pool_after_mount}     PCC.Get Stored Size for Replicated Pool
                                                ...    hostip=${SERVER_1_HOST_IP}
                                                ...    pool_name=${CEPH_POOL_NAME}

                                                Log To Console    ${size_replicated_pool_after_mount}
                                                Set Suite Variable    ${size_replicated_pool_after_mount}
                                                Should Be True    ${size_replicated_pool_after_mount} > ${size_replicated_pool_before_mount}
		
		###  Unmount and unmap RBD  ###
		${status}		PCC.Unmount and Unmap RBD
						...    mount_folder_name=test_rbd_mnt
						...    hostip=${SERVER_1_HOST_IP}
                        ...    user=${PCC_LINUX_USER}
                        ...    password=${PCC_LINUX_PASSWORD}
						
						Log To Console    ${status}
                        Should be equal as strings    ${status}    OK
						
		${status}    Remove dummy file
                     ...    dummy_file_name=test_rbd_mnt_4mb.bin
                     ...    hostip=${SERVER_1_HOST_IP} 
					 ...    user=${PCC_LINUX_USER}
                     ...    password=${PCC_LINUX_PASSWORD}
					 Log To Console    ${status}
                     Should be equal as strings    ${status}    OK

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
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
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
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
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
###################################################################################################################################
#Ceph Create 20 Rbd
####################################################################################################################################
#    [Documentation]                 *Ceph Create 20 Rbd*  
#                               ...  keywords:    
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Create Rbd Multiple
#                               ...  PCC.Ceph Wait Until Rbd Ready
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${pool_id}                  PCC.Ceph Get Pool Id
#                               ...  name=xyz-2
#
#        ${response}                 PCC.Ceph Create Rbd Multiple
#                               ...  count=20
#                               ...  name=abc
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  ceph_pool_id=${pool_id}
#                               ...  size=1
#                               ...  tags=${CEPH_RBD_TAGS}
#                               ...  image_feature=${CEPH_RBD_IMG}
#                               ...  size_units=${CEPH_RBD_SIZE_UNIT}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}                   PCC.Ceph Wait Until Rbd Ready
#                               ...  name=abc-20
#
#                                    Should Be Equal As Strings      ${status}    OK
#
#
#

###################################################################################################################################
Fetching RBD ID before backup
###################################################################################################################################   

         ${rbd_id_before_backup}    PCC.Ceph Get Rbd Id
                                    ...  name=rbd-5                            
                                    Log To Console    ${rbd_id_before_backup}
                                    Set Global Variable    ${rbd_id_before_backup}  
