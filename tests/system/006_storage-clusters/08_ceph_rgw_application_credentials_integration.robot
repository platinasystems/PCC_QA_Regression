*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_215

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

       [Tags]    Only
       
       
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
Ceph Pool For Rgws
###################################################################################################################################

    [Documentation]                        *Ceph Ceph Pool For Rgws*
                                      ...  keywords:
                                      ...  PCC.Ceph Get Cluster Id
                                      ...  PCC.Ceph Create Pool
                                      ...  PCC.Ceph Wait Until Pool Ready
        
        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK
                                      
        ${cluster_id}                      PCC.Ceph Get Cluster Id
                                      ...  name=${CEPH_CLUSTER_NAME}
                                      
        ${response}                        PCC.Ceph Create Pool
                                      ...  name=pool-for-app-credentials
                                      ...  ceph_cluster_id=${cluster_id}
                                      ...  size=${CEPH_POOL_SIZE}
                                      ...  tags=${CEPH_POOL_TAGS}
                                      ...  pool_type=${CEPH_POOL_TYPE}
                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                                      ...  quota=1
                                      ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
                                      
        ${status_code}                     Get Response Status Code        ${response}     
                                           Should Be Equal As Strings      ${status_code}  200
                                           
        ${status}                          PCC.Ceph Wait Until Pool Ready
                                      ...  name=pool-for-app-credentials
                                           Should Be Equal As Strings      ${status}    OK
####################################################################################################################################
#Create and Delete Metadata Application credential profile without application for 20 times
####################################################################################################################################
#
#        [Documentation]               *Create Metadata Profile* test
#                                      ...  keywords:
#                                      ...  PCC.Add Metadata Profile
#
#        FOR    ${i}    IN RANGE    1    20
#
#                ${response}                   PCC.Add Metadata Profile
#                                              ...    Name=test_app_credential
#                                              ...    Type=ceph
#                                              ...    Username=profile_without_app
#                                              ...    Email=profile_without_app@gmail.com
#                                              ...    Active=True
#
#                                              Log To Console    ${response}
#                                              ${result}    Get Result    ${response}
#                                              ${status}    Get From Dictionary    ${result}    status
#                                              ${message}    Get From Dictionary    ${result}    message
#                                              Log to Console    ${message}
#                                              Should Be Equal As Strings    ${status}    200
#
#
#                 ${response}    PCC.Delete All Profiles
#
#                                Log To Console    ${response}
#        END
#
###################################################################################################################################
Create Metadata Application credential profile without application For Rados
###################################################################################################################################

        [Documentation]               *Create Metadata Profile* test
                                      ...  keywords:
                                      ...  PCC.Add Metadata Profile

        ${status}                     PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                      Should Be Equal As Strings      ${status}    OK
             
        ${response}                   PCC.Add Metadata Profile
                                      ...    Name=test_app_credential
                                      ...    Type=ceph
                                      ...    Username=profile_without_app
                                      ...    Email=profile_without_app@gmail.com
                                      ...    Active=True
                                      
                                      Log To Console    ${response}
                                      ${result}    Get Result    ${response}
                                      ${status}    Get From Dictionary    ${result}    status
                                      ${message}    Get From Dictionary    ${result}    message
                                      Log to Console    ${message}
                                      Should Be Equal As Strings    ${status}    200
                                      
        ${profile_id}                 PCC.Get Profile by Id
                                      ...    Name=test_app_credential
                                      
                                      Log to Console    ${profile_id}
                                      
###################################################################################################################################
#Ceph Create Certificate For Rgws
####################################################################################################################################
#
#        [Documentation]              *Ceph Ceph Certificate For Rgws*
#        [Tags]    Only
#        ${cert_id}                   PCC.Get Certificate Id
#                                ...  Alias=rgw-cert
#                                     Pass Execution If    ${cert_id} is not ${None}    Certificate is already there        
#                
#        ${response}                  PCC.Add Certificate
#                                ...  Alias=rgw-cert
#                                ...  Description=certificate-for-rgw
#                                ...  Private_key=rgw_key.key
#                                ...  Certificate_upload=rgw.pem
#  
#                                     Log To Console    ${response}
#        ${result}                    Get Result    ${response}
#        ${status}                    Get From Dictionary    ${result}    statusCodeValue
#                                     Should Be Equal As Strings    ${status}    200
#                                     
###################################################################################################################################
Ceph Rados Gateway Creation With Replicated Pool Without S3 Accounts
#####################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=pool-for-app-credentials
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                           
        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
	${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
                               ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

#####################################################################################################################################
Ceph Rados Add S3Account 
#####################################################################################################################################
     [Documentation]                 *Ceph Rados Gateway Update*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt
     
        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=pool-for-app-credentials
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  S3Accounts=["test_app_credential"]
                               
        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_Cluster_NAME}
                                    Should Be Equal As Strings      ${status}    OK
	
	${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			       ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=["${SERVER_1_HOST_IP}"]
                                    Should Be Equal As Strings      ${backend_status}    OK
                                    Sleep    3 minutes

                            
###################################################################################################################################
Create Application credential profile with application
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile


        ${status}      PCC.Ceph Get Pcc Status
                       ...  name=ceph-pvt
                       Should Be Equal As Strings      ${status}    OK

        ${rgw_id}      PCC.Ceph Get Rgw Id
                       ...    name=${CEPH_RGW_NAME}
		       ...  ceph_cluster_name=ceph-pvt

        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_app
                       ...    Type=ceph
                       ...    Username=profile_with_app
                       ...    Email=profile_with_app@gmail.com
                       ...    Active=True
                       ...    ApplicationId=${rgw_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Get Application credentials Profile by Id 
###################################################################################################################################

        [Documentation]    *Get Profile by Id* test
                           ...  keywords:
                           ...  PCC.Get Profile by Id
        
        ${status}      PCC.Ceph Get Pcc Status
                       ...  name=ceph-pvt
                       Should Be Equal As Strings      ${status}    OK
        
        
        ${response}    PCC.Get Profile by Id
                       ...    Name=profile_with_app
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Get Application credential Profile By Type
###################################################################################################################################

        [Documentation]    *Get Profile By Type* test
                           ...  keywords:
                           ...  PCC.Get Profile By Type
        
 
        ${status}      PCC.Ceph Get Pcc Status
                       ...  name=ceph-pvt
                       Should Be Equal As Strings      ${status}    OK
 
        
        ${response}    PCC.Get Profile By Type
                       ...    Type=ceph
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200 
                       
###################################################################################################################################
Get Application credential Profiles
###################################################################################################################################

        [Documentation]    *Get Profiles* test
                           ...  keywords:
                           ...  PCC.Get Profiles
        
 
        ${status}      PCC.Ceph Get Pcc Status
                       ...  name=ceph-pvt
                       Should Be Equal As Strings      ${status}    OK        
        
        ${response}    PCC.Get Profiles
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Get the Application credential profiles with additional data for a specific application
###################################################################################################################################

        [Documentation]    *Get the profiles with additional data for a specific application* test
                           ...  keywords:
                           ...  PCC.Get Profiles with additional data for specific application

 
        ${status}      PCC.Ceph Get Pcc Status
                       ...  name=ceph-pvt
                       Should Be Equal As Strings      ${status}    OK

        ${rgw_id}      PCC.Ceph Get Rgw Id
                       ...    name=${CEPH_RGW_NAME}
			...  ceph_cluster_name=ceph-pvt

        ${response}    PCC.Get Profiles with additional data for specific application
                       ...    Type=ceph
                       ...    ApplicationId=${rgw_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Describe Application credential Profile By Id
###################################################################################################################################

        [Documentation]    *Describe Profile By Id* test
                           ...  keywords:
                           ...  PCC.Describe Profile By Id
        
        ${status}      PCC.Ceph Get Pcc Status
                       ...  name=ceph-pvt
                       Should Be Equal As Strings      ${status}    OK
        
        ${response}    PCC.Describe Profile By Id
                       ...    Name=profile_with_app 
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Describe Application credential Profile per Type
###################################################################################################################################

        [Documentation]    *Describe Profile per Type* test
                           ...  keywords:
                           ...  PCC.Describe Profile per Type
        
  
        ${status}      PCC.Ceph Get Pcc Status
                       ...  name=ceph-pvt
                       Should Be Equal As Strings      ${status}    OK       
        
        ${response}    PCC.Describe Profile per Type
                       ...    Type=ceph
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200 
                       
###################################################################################################################################
Describe Application credential Profiles per type and application
###################################################################################################################################

        [Documentation]    *Describe Profiles per type and application* test
                           ...  keywords:
                           ...  PCC.Describe Profiles per type and application

 
        ${status}      PCC.Ceph Get Pcc Status
                       ...  name=ceph-pvt
                       Should Be Equal As Strings      ${status}    OK

        ${rgw_id}      PCC.Ceph Get Rgw Id
                       ...    name=${CEPH_RGW_NAME}
			...  ceph_cluster_name=ceph-pvt
        
        ${response}    PCC.Describe Profiles per type and application
                       ...    Type=ceph
                       ...    ApplicationId=${rgw_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Describe Application credential Profiles
###################################################################################################################################

        [Documentation]    *Describe Profiles* test
                           ...  keywords:
                           ...  PCC.Describe Profiles
        
 
        ${status}      PCC.Ceph Get Pcc Status
                       ...  name=ceph-pvt
                       Should Be Equal As Strings      ${status}    OK        
        
        ${response}    PCC.Describe Profiles
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Get Application credentials Profile Types
###################################################################################################################################

        [Documentation]    *Get Profile Types* test
                           ...  keywords:
                           ...  PCC.Get Profile Types
 
        ${status}      PCC.Ceph Get Pcc Status
                       ...  name=ceph-pvt
                       Should Be Equal As Strings      ${status}    OK        
        
        ${response}    PCC.Get Profile Types
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Get Application credentials Profile Template Per Type
###################################################################################################################################

        [Documentation]    *Get Profile Template Per Type* test
                           ...  keywords:
                           ...  PCC.Get Profile Template Per Type
        
  
        ${status}      PCC.Ceph Get Pcc Status
                       ...  name=ceph-pvt
                       Should Be Equal As Strings      ${status}    OK       
        
        ${response}    PCC.Get Profile Template Per Type
                       ...    Type=ceph   
        
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Create multiple Application credential profile with same application
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile

 
        ${status}      PCC.Ceph Get Pcc Status
                       ...  name=ceph-pvt
                       Should Be Equal As Strings      ${status}    OK

        ${rgw_id}      PCC.Ceph Get Rgw Id
                       ...    name=${CEPH_RGW_NAME}
			...  ceph_cluster_name=ceph-pvt

        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_app_multiple
                       ...    Type=ceph
                       ...    Username=profile_with_app_multiple
                       ...    Email=profile_with_app_multiple@gmail.com
                       ...    Active=True
                       ...    ApplicationId=${rgw_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
        ${application_id}    PCC.Get Application Id used by Profile
                             ...    Name=profile_with_app_multiple
                             
                       Pass Execution if    ${application_id} == ${rgw_id}   Application Id matches
                       
###################################################################################################################################
Create Application credential profile with same application using duplicate name (Negative)
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile

 
        ${status}      PCC.Ceph Get Pcc Status
                       ...  name=ceph-pvt
                       Should Be Equal As Strings      ${status}    OK

        ${rgw_id}      PCC.Ceph Get Rgw Id
                       ...    name=${CEPH_RGW_NAME}
			...  ceph_cluster_name=ceph-pvt

        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_app_multiple
                       ...    Type=ceph
                       ...    Username=profile_with_app_multiple
                       ...    Email=profile_with_app_multiple@gmail.com
                       ...    Active=True
                       ...    ApplicationId=${rgw_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200  
                       
###################################################################################################################################
Fetching RGW ID before backup
###################################################################################################################################   

 
        ${status}                       PCC.Ceph Get Pcc Status
                                        ...  name=ceph-pvt
                                        Should Be Equal As Strings      ${status}    OK

         ${RGW_id_before_backup}        PCC.Ceph Get Rgw Id
                                        ...    name=${CEPH_RGW_NAME}
					...  ceph_cluster_name=ceph-pvt                           
                                        Log To Console    ${RGW_id_before_backup}
                                        Set Global Variable    ${RGW_id_before_backup}    
                                             
#####################################################################################################################################
#Application credential profile should be deleted if Application gets deleted 
#####################################################################################################################################
#
#    [Documentation]                 *Application credential profile should be deleted if Application gets deleted *
#
#        ${response}                 PCC.Ceph Delete Rgw
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rgw Deleted
#                               ...  name=${CEPH_RGW_NAME}
#				...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
#                                    Log to Console    Sleeping
#                                    Sleep    2 minute
#
#        ${response}    PCC.Get Profile by Id
#                       ...    Name=profile_with_app_multiple
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       ${data}    Get From Dictionary    ${result}    Data
#                       Log to Console    ${message}
#                       Should Be Equal As Strings    ${data}    None
#
#        ${response}    PCC.Get Profile by Id
#                       ...    Name=profile_with_app
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       ${data}    Get From Dictionary    ${result}    Data
#                       Log to Console    ${message}
#                       Should Be Equal As Strings    ${data}    None
#                       
#
#
####################################################################################################################################
#Ceph Pool Single Delete.
####################################################################################################################################
#    [Documentation]                 *Deleting single pool*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Pool Id
#                               ...  PCC.Ceph Delete Pool
#                               ...  PCC.Ceph Wait Until Pool Deleted
#
#        ${id}                       PCC.Ceph Get Pool Id
#                               ...  name=pool-for-app-credentials
#                                    Pass Execution If    ${id} is ${None}    Pool is already Deleted
#
#        ${response}                 PCC.Ceph Delete Pool
#                               ...  id=${id}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Deleted
#                               ...  id=${id}
#                                    Should Be Equal     ${status}  OK
#        
####################################################################################################################################
#Delete All Profiles
####################################################################################################################################
#
#        [Documentation]    *PCC.Delete All Profiles* test
#                           ...  keywords:
#                           ...  PCC.Delete All Profiles
#        
#        [Tags]    DeleteOnly
#        
#        ${response}    PCC.Delete All Profiles
#                       
#                       Log To Console    ${response}
                             
                             
