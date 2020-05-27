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
Ceph Pool Creation for Fs
###################################################################################################################################

    [Documentation]                 *Ceph Pool Creation for Fs*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=pool9
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=10
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
                               ...  quota=10
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
                               ...  quota=10
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
                               ...  quota_unit=EiB
                               

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
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Rbd Creation with decimal RBD size (Negative)
###################################################################################################################################
     [Documentation]                 *Ceph Rbd Creation with decimal RBD size*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd

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

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

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

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

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

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

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

