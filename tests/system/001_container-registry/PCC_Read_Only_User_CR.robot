*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC.
###################################################################################################################################
                
        [Documentation]    *Login to PCC* test
        
        [Tags]    Tenant
        ${status}        Login To PCC    ${pcc_setup}
                         Should Be Equal    ${status}  OK
                         
                         
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         
                         Load Container Registry Data    ${pcc_setup}
                         Load Auth Profile Data    ${pcc_setup}
                         
        ${server1_id}    PCC.Get Node Id    Name=${SERVER_1_NAME}
                         Log To Console    ${server1_id}
                         Set Global Variable    ${server1_id}                 
        
        ${server2_id}    PCC.Get Node Id    Name=${SERVER_2_NAME}
                         Log To Console    ${server2_id}
                         Set Global Variable    ${server2_id}
                         
        ${invader1_id}    PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
                         Log To Console    ${invader1_id}
                         Set Global Variable    ${invader1_id}
                         
        ${server_id}     PCC.Get CR_Server Id    Name=${CR_NAME}
                         Log To Console    ${server_id}
                         Set Global Variable    ${server_id}
                                 
####################################################################################################################################
Cleanup Container Registry If Already Exists
####################################################################################################################################
        
        [Documentation]    *Cleanup all CR* test
                           ...  keywords:
                           ...  PCC.Clean all CR
                           ...  PCC.Wait for deletion of CR
        [Tags]    Only
        ${result}    PCC.Clean all CR
        
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                     
        
        ${result}    PCC.Wait for deletion of CR
                     
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                     
###################################################################################################################################
Cleanup Auth Profiles
###################################################################################################################################
        
        [Documentation]    *Clean-up Auth Profiles* test
                           ...  keywords:
                           ...  PCC.Delete All Auth Profile     
        
        ${result}    PCC.Delete All Auth Profile
        
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                     
                     Sleep    1 minutes


####################################################################################################################################
Assigning Tenant to Node and creating CR (using Tenant User)
####################################################################################################################################
        
        [Documentation]    *Assigning Tenant to Node* test
                           ...  keywords:
                           ...  PCC.Get Tenant Id   
                           ...  PCC.Assign Tenant to Node                   
        [Tags]    Only             
        ########  Getting Tenant ID   #######################################################################################  
                   
        ${tenant_id}    PCC.Get Tenant Id
                        ...    Name=${CR_TENANT_USER}
                        Set Global Variable    ${tenant_id} 
        
        ########  Assigning Tenant to Node   ################################################################################                
                        
        ${response}    PCC.Assign Tenant to Node
                       ...    tenant_id=${tenant_id}
                       ...    ids=${server1_id}
                      
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       
####################################################################################################################################
Login to PCC using Tenant User with Read Only Access
####################################################################################################################################
        
        [Documentation]    *Login to PCC using Tenant User* test
                           ...  keywords:
                           ...  PCC.Login
                           ...  PCC.Get Node Id
        [Tags]    Tenant                     
        
        ${PCC_CONN}             PCC.Login
                                ...    url=${PCC_URL}
                                ...    username=${READONLY_USER_PCC_USERNAME}    
                                ...    password=${READONLY_USER_PCC_PWD}
                                
                                Set Suite Variable      ${PCC_CONN}
                                
        ${login_success}        Set Variable If  "${PCC_CONN}" == "None"  ERROR  OK
                                Log to Console    ${login_success}
                                Should Be Equal As Strings    ${login_success}    OK
                                
        ${server1_id}           PCC.Get Node Id    Name=${SERVER_1_NAME}
                                Log To Console    ${server1_id}
                                Set Global Variable    ${server1_id}
                         
###################################################################################################################################
Create an Auth Profile after login as Read Only user (Negative)
###################################################################################################################################
        [Documentation]    *Create Auth Profile* test
                           ...  keywords:
                           ...  PCC.Create Auth Profile
        [Tags]    Tenant                   

        ${response}    PCC.Create Auth Profile 
                       ...    Name=${AUTH_PROFILE_NAME}
                       ...    type_auth=${AUTH_PROFILE_TYPE}
                       ...    domain=${AUTH_PROFILE_DOMAIN}
                       ...    port=${AUTH_PROFILE_PORT}
                       ...    userIDAttribute=${AUTH_PROFILE_UID_ATTRIBUTE}
                       ...    userBaseDN=${AUTH_PROFILE_UBDN}
                       ...    groupBaseDN=${AUTH_PROFILE_GBDN}
                       ...    anonymousBind=${AUTH_PROFILE_ANONYMOUSBIND}
                       ...    bindDN=${AUTH_PROFILE_BIND_DN}
                       ...    bindPassword=${AUTH_PROFILE_BIND_PWD}
                       ...    encryptionPolicy=${AUTH_PROFILE_ENCRYPTION}
                

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                         
###################################################################################################################################
Creation of CR (Using Read Only User, Static mode) (Negative)
###################################################################################################################################

        [Documentation]    *Creation of CR (Using Read Only User)* test
                           ...  keywords:
                           ...  PCC.Create Container Registry
                           ...  PCC.CR Wait For Creation
        
        [Tags]    CROnly
        
        ${response}    PCC.Create Container Registry 
                       ...    nodeID=${server1_id}
                       ...    Name=${CR_NAME}
                       ...    fullyQualifiedDomainName=${CR_FQDN}
                       ...    password=${CR_PASSWORD}
                       ...    secretKeyBase=${CR_SECRETKEYBASE}
                       ...    databaseName=${CR_DATABASENAME}
                       ...    databasePassword=${CR_DB_PWD}
                       ...    port=${CR_PORT}
                       ...    registryPort=${CR_REGISTRYPORT}
                       ...    adminState=${CR_ADMIN_STATE}
                       

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
####################################################################################################################################
Login to PCC using Tenant User
####################################################################################################################################
        
        [Documentation]    *Login to PCC using Tenant User* test
                           ...  keywords:
                           ...  PCC.Login
                           ...  PCC.Get Node Id
        [Tags]    Tenant                     
        
        ${PCC_CONN}             PCC.Login
                                ...    url=${PCC_URL}
                                ...    username=${TENANT_USER_PCC_USERNAME}    
                                ...    password=${TENANT_USER_PCC_PWD}
                                
                                Set Suite Variable      ${PCC_CONN}
                                
        ${login_success}        Set Variable If  "${PCC_CONN}" == "None"  ERROR  OK
                                Log to Console    ${login_success}
                                Should Be Equal As Strings    ${login_success}    OK
                                
        ${server1_id}           PCC.Get Node Id    Name=${SERVER_1_NAME}
                                Log To Console    ${server1_id}
                                Set Global Variable    ${server1_id}
                         
###################################################################################################################################
Create an Auth Profile after login as Tenant user : TCP-866
###################################################################################################################################
        [Documentation]    *Create Auth Profile* test
                           ...  keywords:
                           ...  PCC.Create Auth Profile
        [Tags]    Tenant                   

        ${response}    PCC.Create Auth Profile 
                       ...    Name=${AUTH_PROFILE_NAME}
                       ...    type_auth=${AUTH_PROFILE_TYPE}
                       ...    domain=${AUTH_PROFILE_DOMAIN}
                       ...    port=${AUTH_PROFILE_PORT}
                       ...    userIDAttribute=${AUTH_PROFILE_UID_ATTRIBUTE}
                       ...    userBaseDN=${AUTH_PROFILE_UBDN}
                       ...    groupBaseDN=${AUTH_PROFILE_GBDN}
                       ...    anonymousBind=${AUTH_PROFILE_ANONYMOUSBIND}
                       ...    bindDN=${AUTH_PROFILE_BIND_DN}
                       ...    bindPassword=${AUTH_PROFILE_BIND_PWD}
                       ...    encryptionPolicy=${AUTH_PROFILE_ENCRYPTION}
                

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
####################################################################################################################################
Get Auth Profile Id : TCP-866
####################################################################################################################################
        
        [Documentation]    *Get Auth Profile Id* test
                           ...  keywords:
                           ...  PCC.Get Auth Profile Id 
                           
        [Tags]    CROnly
        ${Auth_Profile_Id}    PCC.Get Auth Profile Id
                              ...    Name=${AUTH_PROFILE_NAME}
                     
                              Log To Console    ${Auth_Profile_Id}
                              Set Global Variable    ${Auth_Profile_Id}

                         
###################################################################################################################################
Creation of CR (Using Tenant User, Static mode) : TCP-825
###################################################################################################################################

        [Documentation]    *Creation of CR (Using Admin User)* test
                           ...  keywords:
                           ...  PCC.Create Container Registry
                           ...  PCC.CR Wait For Creation
        
        [Tags]    CROnly
        
        ${response}    PCC.Create Container Registry 
                       ...    nodeID=${server1_id}
                       ...    authenticationProfileId=${Auth_Profile_Id}
                       ...    Name=${CR_NAME}
                       ...    fullyQualifiedDomainName=${CR_FQDN}
                       ...    password=${CR_PASSWORD}
                       ...    secretKeyBase=${CR_SECRETKEYBASE}
                       ...    databaseName=${CR_DATABASENAME}
                       ...    databasePassword=${CR_DB_PWD}
                       ...    port=${CR_PORT}
                       ...    registryPort=${CR_REGISTRYPORT}
                       ...    adminState=${CR_ADMIN_STATE}
                       

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
                       
        ${status}      PCC.CR Wait For Creation
                       ...    Name=${CR_NAME}
                       
                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK      
        
                       
###################################################################################################################################
Verify CR creation successful from frontend : TCP-825
###################################################################################################################################

        [Documentation]    *Verify CR creation successful from frontend* test
                           ...  keywords:
                           ...  PCC.CR Verify Creation from PCC
        
        
        ${result}    PCC.CR Verify Creation from PCC
                     ...    Name=${CR_NAME}
                     Log to console    "${result}"
                     Should Be Equal As Strings    ${result}    OK
                     

####################################################################################################################################
Login to PCC using Tenant User with Read Only Access after creation of CR using Read Write Access Tenant User
####################################################################################################################################
        
        [Documentation]    *Login to PCC using Tenant User* test
                           ...  keywords:
                           ...  PCC.Login
                           ...  PCC.Get Node Id
        [Tags]    Tenant                     
        
        ${PCC_CONN}             PCC.Login
                                ...    url=${PCC_URL}
                                ...    username=${READONLY_USER_PCC_USERNAME}    
                                ...    password=${READONLY_USER_PCC_PWD}
                                
                                Set Suite Variable      ${PCC_CONN}
                                
        ${login_success}        Set Variable If  "${PCC_CONN}" == "None"  ERROR  OK
                                Log to Console    ${login_success}
                                Should Be Equal As Strings    ${login_success}    OK
                                
        ${server1_id}           PCC.Get Node Id    Name=${SERVER_1_NAME}
                                Log To Console    ${server1_id}
                                Set Global Variable    ${server1_id}
                                
###################################################################################################################################
Update CR using Read Only user
###################################################################################################################################
        
        [Documentation]    *Edit FQDN* test
                           ...  keywords:
                           ...  PCC.Update Container Registry
                                   
        
        ${response}    PCC.Update Container Registry 
                       
                       ...    nodeID=${server_id}
                       ...    authenticationProfileId=${Auth_Profile_Id}
                       ...    Name=${CR_NAME}
                       ...    fullyQualifiedDomainName=${CR_MODIFIED_FQDN}
                       ...    password=${CR_PASSWORD}
                       ...    secretKeyBase=${CR_SECRETKEYBASE}
                       ...    databaseName=${CR_DATABASENAME}
                       ...    databasePassword=${CR_DB_PWD}
                       ...    port=${CR_PORT}
                       ...    registryPort=${CR_REGISTRYPORT}
                       ...    adminState=${CR_ADMIN_STATE}
                       ...    storageType=mount
                       ...    storageLocation=testlocation
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Update an Auth Profile after login as Read Only user
###################################################################################################################################
        [Documentation]    *Update Auth Profile* test
                           ...  keywords:
                           ...  PCC.Create Auth Profile
        [Tags]    Tenant                   
                       
        ${response}    PCC.Update Auth Profile 
                       
                       ...    Name=ReadOnlyAuth
                       ...    type_auth=${AUTH_PROFILE_TYPE}
                       ...    domain=${AUTH_PROFILE_DOMAIN}
                       ...    port=${AUTH_PROFILE_PORT}
                       ...    userIDAttribute=${AUTH_PROFILE_UID_ATTRIBUTE}
                       ...    userBaseDN=${AUTH_PROFILE_UBDN}
                       ...    groupBaseDN=${AUTH_PROFILE_GBDN}
                       ...    anonymousBind=${AUTH_PROFILE_ANONYMOUSBIND}
                       ...    bindDN=${AUTH_PROFILE_BIND_DN}
                       ...    bindPassword=${AUTH_PROFILE_BIND_PWD}
                       ...    encryptionPolicy=${AUTH_PROFILE_ENCRYPTION}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal    "${status}"    "200"
                       
                       Sleep    5s

###################################################################################################################################
Fetching IDs for backup and restore
###################################################################################################################################                       
        
        ${auth_profile_id_before_backup}    PCC.Get Auth Profile Id
                                            ...    Name=${AUTH_PROFILE_NAME}
                                   
                                            Log To Console    ${auth_profile_id_before_backup}
                                            Set Global Variable    ${auth_profile_id_before_backup}  
                                            
        ${CR_id_before_backup}              PCC.Get CR Id
                                            ...    Name=${CR_NAME}  
                                            
                                            Log To Console    ${CR_id_before_backup}
                                            Set Global Variable    ${CR_id_before_backup}
                                            
                       
#####################################################################################################################################
#Cleanup Container Registry using Read Only user
#####################################################################################################################################
#        
#        [Documentation]    *Cleanup all CR* test
#                           ...  keywords:
#                           ...  PCC.Clean all CR
#                           ...  PCC.Wait for deletion of CR
#        
#        ${result}    PCC.Clean all CR
#        
#                     Log to Console    ${result}
#                     Should Not Be Equal As Strings    ${result}    OK
#                     
####################################################################################################################################
#Cleanup Auth Profiles using Read Only user
####################################################################################################################################
#        
#        [Documentation]    *Clean-up Auth Profiles* test
#                           ...  keywords:
#                           ...  PCC.Delete All Auth Profile     
#        
#        ${result}    PCC.Delete All Auth Profile
#        
#                     Log to Console    ${result}
#                     Should Not Be Equal As Strings    ${result}    OK
#                     

                         

                     

                     
                     

                

                     
