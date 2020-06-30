*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Ceph Rgw Data    ${pcc_setup}
                                    Load Ceph Pool Data    ${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
     

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK
                                   
###################################################################################################################################
Ceph Ceph Pool For Rgws
###################################################################################################################################

    [Documentation]                 *Ceph Ceph Pool For Rgws*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool
                               ...  name=${CEPH_RGW_POOLNAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=1
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=${CEPH_RGW_POOLNAME}
                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Ceph Certificate For Rgws
###################################################################################################################################

        [Documentation]              *Ceph Ceph Certificate For Rgws*
        
        ${cert_id}                   PCC.Get Certificate Id
                                ...  name=rgw-cert
                                     Pass Execution If    ${cert_id} is not ${None}    Certificate is already there        
                
        ${response}                  PCC.Add Certificate
                                ...  Alias=rgw-cert
                                ...  Description=certificate-for-rgw
                                ...  Private_key=rgw_key.key
                                ...  Certificate_upload=rgw.pem
  
                                     Log To Console    ${response}
        ${result}                    Get Result    ${response}
        ${status}                    Get From Dictionary    ${result}    statusCodeValue
                                     Should Be Equal As Strings    ${status}    200
                                    
###################################################################################################################################
Ceph Rados Gateway Creation
#####################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*
              
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
                                    
#####################################################################################################################################
Ceph Rados Gateway Update
#####################################################################################################################################
     [Documentation]                 *Ceph Rados Gateway Update*

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
     
        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
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
                                    
####################################################################################################################################
Ceph Rados Gateway Delete 
####################################################################################################################################

    [Documentation]                 *Ceph Rados Gateway Delete*
                             
        ${response}                 PCC.Ceph Delete Rgw
                               ...  name=${CEPH_RGW_NAME}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Deleted
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${status}    OK

