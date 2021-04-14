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
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       
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
Get Host IP used by CR
###################################################################################################################################
                
        [Documentation]    *Get Host IP used by CR* test
                           ...  keywords:
                           ...  PCC.Get Host IP
        [Tags]    Negative
        
        ${host_ip}    PCC.Get Host IP
                      ...  Name=${CR_NAME} 
                      Log To Console    ${host_ip}
                      Set Global Variable    ${host_ip}
                       
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
                     
###################################################################################################################################
Verify CR creation successful from backend : TCP-825
###################################################################################################################################

        [Documentation]    *Verify CR creation successful from backend* test
                           ...  keywords:
                           ...  Is Docker Container Up
                           ...  pcc_qa.common.LinuxUtils.Is FQDN reachable
                           ...  Is Port Used 
        
        
        ${container_up_result1}    Is Docker Container Up 
                     ...    container_name=portus_nginx_1
                     ...    hostip=${host_ip}
                     
        ${container_up_result2}    Is Docker Container Up 
                     ...    container_name=portus_background_1
                     ...    hostip=${host_ip}
                     
        ${container_up_result3}    Is Docker Container Up 
                     ...    container_name=portus_registry_1
                     ...    hostip=${host_ip}
                     
        ${container_up_result4}    Is Docker Container Up 
                     ...    container_name=portus_portus_1
                     ...    hostip=${host_ip}
                     
        ${container_up_result5}    Is Docker Container Up 
                     ...    container_name=portus_db_1
                     ...    hostip=${host_ip}
                     
                     Log to Console    ${container_up_result1}
                     Should Be Equal As Strings    ${container_up_result1}    OK
                     
                     Log to Console    ${container_up_result2}
                     Should Be Equal As Strings    ${container_up_result2}    OK
                     
                     Log to Console    ${container_up_result3}
                     Should Be Equal As Strings    ${container_up_result3}    OK
                     
                     Log to Console    ${container_up_result4}
                     Should Be Equal As Strings    ${container_up_result4}    OK
                     
                     Log to Console    ${container_up_result5}
                     Should Be Equal As Strings    ${container_up_result5}    OK
                     
        ${FQDN_reachability_result}    pcc_qa.common.LinuxUtils.Is FQDN reachable
                     ...    FQDN_name=${CR_FQDN}
                     ...    hostip=${host_ip}
                     
                     Log to Console    ${FQDN_reachability_result}
                     Should Be Equal As Strings    ${FQDN_reachability_result}    OK
                     
        ${Port_used_result}    Is Port Used   
                     ...    port_number=${CR_REGISTRYPORT}
                     ...    hostip=${host_ip}
                     
                     Log to Console    ${Port_used_result}
                     Should Be Equal As Strings    ${Port_used_result}    OK
                     
###################################################################################################################################
Checks if image pulled from Docker already exists and delete from local repo : TCP-837
###################################################################################################################################

        [Documentation]    *Checks if image exists and delete from local repo* test
                           ...  keywords:
                           ...  Check if image exists in local repo
                           ...  Delete image from local repo, if exists   
        
        
        ${check_image_status}    Check if image exists in local repo    
                                 ...    image_name=${CR_IMAGE_NAME}
                                 ...    hostip=${host_ip}
        
        ${delete_image_status}    Delete image from local repo, if exists
                                  ...    image_name=${CR_IMAGE_NAME}
                                  ...    hostip=${host_ip}
                                  Set Suite Variable    ${check_image_status}    "False"
                                  
                                  
###################################################################################################################################
Pull image from Docker Registry : TCP-837
###################################################################################################################################

        [Documentation]    *Pull image from Docker Registry* test
                           ...  keywords:
                           ...  Pull From Docker Registry
        
        ${return} =    Run Keyword If    ${check_image_status} == "False"
                       
                       ...    Pull From Docker Registry    image_name=${CR_IMAGE_NAME}    hostip=${host_ip}
                       ...    ELSE
                       
                       ...    Pull From Docker Registry    image_name=${CR_IMAGE_NAME}    hostip=${host_ip}
                       
                       Log to Console    ${return}
                       Should Be Equal As Strings    ${return}    OK
                       
###################################################################################################################################
Tag image : TCP-837
###################################################################################################################################

        [Documentation]    *Tag image* test
                           ...  keywords:
                           ...  Tag Image 
        
        ${result}    Tag Image
                     ...    image_name=${CR_IMAGE_NAME}
                     ...    registry_url=${CR_FQDN}
                     ...    port=${CR_REGISTRYPORT}
                     ...    custom_name=${CR_CUSTOM_IMAGE_NAME}
                     ...    hostip=${host_ip}
                     
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                     
###################################################################################################################################
Login to C-Registry : TCP-837
###################################################################################################################################

        [Documentation]    *Login to C-Registry* test
                           ...  keywords:
                           ...  PCC.CR login using docker
                           
        
        ${result}    PCC.CR login using docker
                             
                     ...    registryPort=${CR_REGISTRYPORT}
                     ...    portus_password=${AUTH_PROFILE_BIND_PWD}  
                     ...    fullyQualifiedDomainName=${CR_FQDN}
                     ...    portus_uname=${AUTH_PROFILE_UNAME}
                     ...    hostip=${host_ip}
                                     
                     Log To Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                     

###################################################################################################################################
Push to C-Registry : TCP-837
###################################################################################################################################

        [Documentation]    *Push to C-Registry* test
                           ...  keywords:
                           ...  Push To Registry 
        
        
        ${result}    Push To Registry
                     
                     ...    registry_url=${CR_FQDN}
                     ...    port=${CR_REGISTRYPORT}
                     ...    custom_name=${CR_CUSTOM_IMAGE_NAME}
                     ...    hostip=${host_ip}
                     
                     
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                     
###################################################################################################################################
Checks if image pulled from CR already exists and delete from local repo : TCP-837
###################################################################################################################################

        [Documentation]    *Checks if image exists and delete from local repo* test
                           ...  keywords:
                           ...  Check if image exists in local repo
                           ...  Delete image from local repo, if exists
                           
        
        ${check_image_status}    Check if image exists in local repo    
                                 ...    image_name=${CR_CUSTOM_IMAGE_NAME}
                                 ...    hostip=${host_ip}
                                 
                                 
        ${return} =    Run Keyword If    "${check_image_status}" == "OK"
                       ...    Delete image from local repo, if exists    image_name=${CR_FQDN}:${CR_REGISTRYPORT}/${CR_CUSTOM_IMAGE_NAME}    hostip=${host_ip}
                       
                       Log to Console    ${return}
                       Should Be Equal As Strings    ${return}    OK
                       
###################################################################################################################################
Pull from CRegistry to server : TCP-837
###################################################################################################################################

        [Documentation]    *Pull from CRegistry to server* test
                           ...  keywords:
                           ...  Pull From Registry
                           
        
        ${result}    Pull From Registry
                     
                     ...    image_name=${CR_CUSTOM_IMAGE_NAME}
                     ...    registry_url=${CR_FQDN}
                     ...    registryPort=${CR_REGISTRYPORT}
                     ...    hostip=${host_ip}
                     
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                     
###################################################################################################################################
Verify image pulled to server : TCP-837
###################################################################################################################################

        [Documentation]    *Verify image pulled to server* test
                           ...  keywords:
                           ...  Check if image exists in local repo
        
        ${result}    Check if image exists in local repo
                     
                     ...    image_name=${CR_CUSTOM_IMAGE_NAME}
                     ...    hostip=${host_ip}
                     
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK

###################################################################################################################################
Passing wrong FQDN while Tagging image, Pushing Image and Pulling image, TCP: 602 (Negative)
###################################################################################################################################
       
       [Documentation]    *Verify image pulled to server* test
                           ...  keywords:
                           ...  Check if image exists in local repo
                           
                           
                           
       ${result}    Tag Image
                     ...    image_name=${CR_IMAGE_NAME}
                     ...    registry_url=${CR_INVALID_FQDN}
                     ...    port=${CR_REGISTRYPORT}
                     ...    custom_name=${CR_CUSTOM_IMAGE_NAME}
                     ...    hostip=${host_ip}
                     
                     Log to Console    ${result}
                     Should Not Be Equal As Strings    ${result}    OK
                     
                                         
       ${result}    PCC.CR login using docker
                             
                     ...    registryPort=${CR_REGISTRYPORT}
                     ...    portus_password=${AUTH_PROFILE_BIND_PWD}  
                     ...    fullyQualifiedDomainName=${CR_INVALID_FQDN}
                     ...    portus_uname=${AUTH_PROFILE_UNAME}
                     ...    hostip=${host_ip}
                                     
                     Log To Console    ${result}
                     Should Not Be Equal As Strings    ${result}    OK 
                     
       ${result}    Push To Registry
                     
                     ...    registry_url=${CR_INVALID_FQDN}
                     ...    port=${CR_REGISTRYPORT}
                     ...    custom_name=${CR_CUSTOM_IMAGE_NAME}
                     ...    hostip=${host_ip}
                     
                     
                     Log to Console    ${result}
                     Should Not Be Equal As Strings    ${result}    OK             
                     
       ${result}    Pull From Registry
                     
                     ...    image_name=${CR_CUSTOM_IMAGE_NAME}
                     ...    registry_url=${CR_INVALID_FQDN}
                     ...    registryPort=${CR_REGISTRYPORT}
                     ...    hostip=${host_ip}
                     
                     Log to Console    ${result}
                     Should Not Be Equal As Strings    ${result}    OK 

####################################################################################################################################
Login to PCC using Admin User
####################################################################################################################################
        
        [Documentation]    *Login to PCC using Tenant User* test
                           ...  keywords:
                           ...  PCC.Login
                           ...  PCC.Get Node Id
                             
        
        ${status}        Login To PCC    ${pcc_setup}
                         Should Be Equal    ${status}  OK
                         
                         
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         
                         Load Container Registry Data    ${pcc_setup}
                         

        ${server1_id}    PCC.Get Node Id    Name=${SERVER_1_NAME}
                         Log To Console    ${server1_id}
                         Set Global Variable    ${server1_id}
                         
###################################################################################################################################
Verify CR created by Tenant user is visible or not, by Admin User
###################################################################################################################################

        [Documentation]    *Verify CR creation successful from frontend* test
                           ...  keywords:
                           ...  PCC.CR Verify Creation from PCC
        
        
        ${result}    PCC.CR Verify Creation from PCC
                     ...    Name=${CR_NAME}
                     Log to console    "${result}"
                     Should Be Equal As Strings    ${result}    OK
                     
####################################################################################################################################
Re-assigning ROOT to Node 
####################################################################################################################################
        
        [Documentation]    *Re-assigning ROOT user to Node* test
                           ...  keywords:
                           ...  PCC.Get Tenant Id   
                           ...  PCC.Assign Tenant to Node                   
                     
        ########  Getting ROOT ID   #######################################################################################  
                   
        ${tenant_id}    PCC.Get Tenant Id
                        ...    Name=ROOT
                        Set Global Variable    ${tenant_id} 
        
        ########  Assigning Tenant to Node   ################################################################################                
                        
        ${response}    PCC.Assign Tenant to Node
                       ...    tenant=${tenant_id}
                       ...    ids=${server1_id}
                      
                       Log To Console    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                     
####################################################################################################################################
Login to PCC using Tenant User after assigning node to ROOT user
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
                                
        ${server1_id}    PCC.Get Node Id    Name=${SERVER_1_NAME}
                         Log To Console    ${server1_id}
                         Set Global Variable    ${server1_id}
                         
###################################################################################################################################
Cleanup Auth Profiles after login as Tenant user
###################################################################################################################################
        
        [Documentation]    *Clean-up Auth Profiles* test
                           ...  keywords:
                           ...  PCC.Delete All Auth Profile     
        
        [Tags]    Tenant
        ########  Cleanup Auth Profile   ################################################################################
        
        ${result}    PCC.Delete All Auth Profile
        
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                     
                     Sleep    1 minutes
                     
        ${status}    PCC.CR Wait For CR updation
                     ...    Name=${CR_NAME}
                     
                     Log to Console    ${status}
                     Should Be Equal As Strings    ${status}    OK
                          
####################################################################################################################################
Cleanup Container Registry after login as Tenant user
####################################################################################################################################
        
        [Documentation]    *Cleanup all CR* test
                           ...  keywords:
                           ...  PCC.Clean all CR
                           ...  PCC.Wait for deletion of CR
        
        ${result}    PCC.Clean all CR
        
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                     
        
        ${result}    PCC.Wait for deletion of CR
                     
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                     
####################################################################################################################################
#User should not be able to access Portus URL and images : TCP- 591 (Negative)
####################################################################################################################################
#
#        [Documentation]    *User should not be able to access Portus URL and images* test
#                           ...  keywords:
#                           ...  Check if image exists in local repo
#                           ...  Delete image from local repo, if exists
#                           ...  pcc_qa.common.LinuxUtils.Is FQDN reachable
#
#        [Tags]    Negative
#
#        ${check_image_status}    Check if image exists in local repo
#                                 ...    image_name=${CR_CUSTOM_IMAGE_NAME}
#                                 ...    hostip=${host_ip}
#
#        ${return} =    Run Keyword If    "${check_image_status}" == "OK"
#                       ...    Delete image from local repo, if exists    image_name=${CR_FQDN}:${CR_REGISTRYPORT}/${CR_CUSTOM_IMAGE_NAME}    hostip=${host_ip}
#
#                       Log to Console    ${return}
#                       Should Be Equal As Strings    ${return}    OK
#
#        ${FQDN_reachability_result}    pcc_qa.common.LinuxUtils.Is FQDN reachable
#                             ...    FQDN_name=${CR_FQDN}
#                             ...    hostip=${host_ip}
#
#                             Log to Console    ${FQDN_reachability_result}
#                             Should Not Be Equal As Strings    ${FQDN_reachability_result}    OK
#
#        ${result}    Pull From Registry
#
#                     ...    image_name=${CR_CUSTOM_IMAGE_NAME}
#                     ...    registry_url=${CR_FQDN}
#                     ...    registryPort=${CR_REGISTRYPORT}
#                     ...    hostip=${host_ip}
#
#                     Log to Console    ${result}
#                     Should Not Be Equal As Strings    ${result}    OK
