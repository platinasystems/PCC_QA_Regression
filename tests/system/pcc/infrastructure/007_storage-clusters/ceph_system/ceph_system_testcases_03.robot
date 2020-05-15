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
Ceph Pool Creation without name (Negative)
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation without name*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
#Ceph Pool Creation with name contain special characters only (Negative)
####################################################################################################################################
#
#    [Documentation]                 *Ceph Pool Creation without name*
#
#                               
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=@#$%^&
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=@#$%^&
#
#                                    Should Not Be Equal As Strings      ${status}    OK
#                                    
####################################################################################################################################
#Ceph Pool Creation with name contain only hyphens (Negative)
####################################################################################################################################
#
#    [Documentation]                 *Ceph Pool Creation without name*
#
#                               
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=------------
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=------------
#
#                                    Should Not Be Equal As Strings      ${status}    OK
#
#
####################################################################################################################################
#Ceph Pool Creation with Name greater then 48 length (Negative)
####################################################################################################################################
#
#    [Documentation]                 *Ceph Pool Creation with Name greater then 48 length*
#
#                               
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=qwettqqqqqqwettqqqqqqwettqqqqqqwettqqqqqerewtwrhg
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=qwettqqqqqqwettqqqqqqwettqqqqqqwettqqqqqerewtwrhg
#
#                                    Should Not Be Equal As Strings      ${status}    OK
#
#
###################################################################################################################################
Ceph Pool Creation without providing quota (Negative)
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation without providing quota*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=123pool
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

                                    
###################################################################################################################################
Ceph Pool Creation without quota unit (Negative)
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation without quota unit*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=${CEPH_POOL_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Ceph Pool Creation with decimal quota size (Negative)
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation with zero quota size*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=${CEPH_POOL_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=1.3
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

                                    
###################################################################################################################################
Ceph Pool Creation with zero quota size (Negative)
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation with zero quota size*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=${CEPH_POOL_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=0
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

                                    
###################################################################################################################################
Ceph Pool Creation with negative quota size (Negative)
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation with negative quota size*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=${CEPH_POOL_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=-2
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200


                                    
###################################################################################################################################
Ceph Pool Creation with quota size greater than 5 digit number (Negative)
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation with quota size greater than 5 digit number*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=${CEPH_POOL_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=123456
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200


###################################################################################################################################
#Ceph Pool Creation with quota size greater than 16 EiB (Negative)
####################################################################################################################################
#
#    [Documentation]                 *Ceph Pool Creation with quota size greater than 16 EiB*
#
#                               
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=${CEPH_POOL_NAME}
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  quota=17
#                               ...  quota_unit=EiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Not Be Equal As Strings      ${status_code}  200
#                                    
#                                    
###################################################################################################################################
Ceph Pool Creation and Verification with quota unit MiB
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation and Verification with quota unit MiB*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=${CEPH_POOL_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=10
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=${CEPH_POOL_NAME}
                              
###################################################################################################################################
Ceph Pool Creation and Verification with quota unit GiB
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation and Verification with quota unit GiB*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool1
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=10
                               ...  quota_unit=GiB

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool1                             

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Pool Creation and Verification with quota unit TiB
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation and Verification with quota unit TiB*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool2
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=10
                               ...  quota_unit=TiB

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool2                             

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Pool Creation and Verification with quota unit PiB
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation and Verification with quota unit PiB*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool3
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=10
                               ...  quota_unit=PiB

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool3                       

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Pool Creation and Verification with quota unit EiB
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation and Verification with quota unit EiB*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool4
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=10
                               ...  quota_unit=EiB

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool4                          

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Pool Creation and Verification with No. of Copies 1
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation and Verification with No. of Copies 1*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool5
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=1
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool5

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Pool Creation and Verification with No. of Copies 2
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation and Verification with No. of Copies 2*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool6
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=2
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool6

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Pool Creation and Verification with No. of Copies 3
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation and Verification with No. of Copies 3*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool7
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=3
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool7

                                    Should Be Equal As Strings      ${status}    OK

