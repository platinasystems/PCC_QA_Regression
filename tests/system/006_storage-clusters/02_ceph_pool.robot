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
Ceph Pool Creation without name (Negative)
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation without name*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK                               
                               
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
#####################################################################################################################################
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
#####################################################################################################################################
#Ceph Pool Creation with name contain only hyphens (Negative)
#####################################################################################################################################
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

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

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
                               ...  quota=-2
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200


                                    
###################################################################################################################################
Ceph Pool Creation with quota size greater than 5 digit number
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation with quota size greater than 5 digit number*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool123456
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=123456
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool123456
                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Ceph Pool Creation with quota size greater than 16 EiB (Negative)
####################################################################################################################################
    [Documentation]                 *Ceph Pool Creation with quota size greater than 16 EiB*

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
                               ...  quota=17
                               ...  quota_unit=EiB

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
                                    
###################################################################################################################################
Ceph Pool Creation and Verification with quota unit MiB
###################################################################################################################################
    [Documentation]                 *Ceph Pool Creation and Verification with quota unit MiB*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
 
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
                               ...  quota=1
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=${CEPH_POOL_NAME}
                                    Should Be Equal As Strings      ${status}    OK
                            
                              
###################################################################################################################################
Ceph Pool Creation and Verification with quota unit GiB
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation and Verification with quota unit GiB*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
 
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
 
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool1
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=1
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

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool2
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=1
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
  
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
  
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool3
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=1
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

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool4
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=1
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
  
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
  
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
                                    
        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool6
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=1
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool6
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool7
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=1
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool7
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Pool Creation for Fs
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation for Fs*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
 
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
 
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool9
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=1
                               ...  quota_unit=TiB

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool9                            

                                    Should Be Equal As Strings      ${status}    OK   

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool10
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=1
                               ...  quota_unit=TiB

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool10                            

                                    Should Be Equal As Strings      ${status}    OK      

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool11
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=1
                               ...  quota_unit=TiB

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool11                           

                                    Should Be Equal As Strings      ${status}    OK                                      
                                    
###################################################################################################################################
Ceph Pool Update Pool Name with existing Pool Name (Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Pool Update Pool Name with existing Pool Name*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
 
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
 
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=pool12

        ${response}                 PCC.Ceph Pool Update
                               ...  id=${pool_id}
                               ...  name=${CEPH_POOL_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
                               

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

                                    
###################################################################################################################################
Ceph Pool Edit Name
###################################################################################################################################
    [Documentation]                 *Ceph Pool Edit Name*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Pool Update
                               ...  PCC.Ceph Wait Until Pool Ready        

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=pool10

        ${response}                 PCC.Ceph Pool Update
                               ...  id=${pool_id}
                               ...  name=pool13
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
                               

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=pool13

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Pool Ugrade Quota Unit
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
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=PiB
                               
        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=${CEPH_POOL_NAME}

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Pool Downgrade Quota Unit
###################################################################################################################################
    [Documentation]                 *Ceph Pool Downgrade Quota Unit*
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
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=GiB
                               

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=${CEPH_POOL_NAME}

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Pool Ugrade Quota Size
###################################################################################################################################
    [Documentation]                 *Ceph Pool Ugrade Quota Size*   
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
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=4
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
                               

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=${CEPH_POOL_NAME}

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Pool Update Pool No of Copies
###################################################################################################################################
    [Documentation]                 *Ceph Pool Update Pool No of Copies*
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
                               ...  size=5
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
Ceph Pool Update Quota Size and Quota Unit together
###################################################################################################################################
    [Documentation]                 *Ceph Pool Update Quota Size and Quota Unit together*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
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
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=1
                               ...  quota_unit=GiB
                               

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=${CEPH_POOL_NAME}

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Pool Creation with pool size contain alphabets/ special characters (Negative)
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation with pool size contain alphabets/ special characters*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK 
 
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool7
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=abs
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
                                    
###################################################################################################################################
Ceph Pool Creation Duplicate (Negative)
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation Duplicate*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready

         ${status}                  PCC.Ceph Get Pcc Status
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
                               ...  quota=1
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
#Ceph Create 20 Pools
####################################################################################################################################
#    [Documentation]                 *Ceph Create 20 Pools*  
#                               ...  keywords:    
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Create Pool Multiple
#                               ...  PCC.Ceph Wait Until Pool Ready
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${response}                 PCC.Ceph Create Pool Multiple
#                               ...  count=20
#                               ...  name=xyz
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  quota=1
#                               ...  quota_unit=MiB
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=xyz-20
#
#                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Fetching Pool ID before backup
###################################################################################################################################   

         ${pool_id_before_backup}    PCC.Ceph Get Pool Id
                                     ...  name=${CEPH_POOL_NAME}                            
                                     Log To Console    ${pool_id_before_backup}
                                     Set Global Variable    ${pool_id_before_backup}  