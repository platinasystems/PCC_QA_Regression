# *** Settings ***

# Resource    pcc_resources.robot

# *** Variables ***
# ${pcc_setup}    pcc_212

# *** Test Cases ***
# ###################################################################################################################################
# Login to PCC 
# ###################################################################################################################################
                
        
#         [Documentation]    *Login to PCC* test
        
        
#         ${status}        Login To PCC    ${pcc_setup}
                         
#                          Load Clusterhead 1 Test Data    ${pcc_setup}
#                          Load Clusterhead 2 Test Data    ${pcc_setup}
#                          Load Server 1 Test Data    ${pcc_setup}
#                          Load Server 2 Test Data    ${pcc_setup}
                         
#                          Load Container Registry Data    ${pcc_setup}
        
#         ${server1_id}    PCC.Get Node Id    Name=${SERVER_1_NAME}
#                          Log To Console    ${server1_id}
#                          Set Global Variable    ${server1_id}
                         
#         ${server2_id}    PCC.Get Node Id    Name=${SERVER_2_NAME}
#                          Log To Console    ${server2_id}
#                          Set Global Variable    ${server2_id}
                         
#         ${invader1_id}    PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
#                          Log To Console    ${invader1_id}
#                          Set Global Variable    ${invader1_id}
        
#         ${invader2_id}    PCC.Get Node Id    Name=${CLUSTERHEAD_2_NAME}
#                          Log To Console    ${invader2_id}
#                          Set Global Variable    ${invader2_id}
                         
# ####################################################################################################################################
# Cleanup Container Registry If Already Exists
# ####################################################################################################################################

#         [Documentation]    *Cleanup all CR* test
#                            ...  keywords:
#                            ...  PCC.Clean all CR
#                            ...  PCC.Wait for deletion of CR

#         ${result}    PCC.Clean all CR

#                      Log to Console    ${result}
#                      Should Be Equal As Strings    ${result}    OK


#         ${result}    PCC.Wait for deletion of CR
#                      #...    Name=addgy
#                      Log to Console    ${result}
#                      Should Be Equal As Strings    ${result}    OK

# ###################################################################################################################################
# Create a Container Registry(using Static mode) : TCP-825
# ###################################################################################################################################

#         [Documentation]    *Create CR* test
#                            ...  keywords:
#                            ...  PCC.Create Container Registry

#         ${response}    PCC.Create Container Registry
#                        ...    nodeID=${invader2_id}
#                        ...    Name=${STATIC_MODE_CR_NAME}
#                        ...    fullyQualifiedDomainName=${STATIC_MODE_CR_FQDN}
#                        ...    password=${STATIC_MODE_CR_PASSWORD}
#                        ...    secretKeyBase=${CR_SECRETKEYBASE}
#                        ...    databaseName=${CR_DATABASENAME}
#                        ...    databasePassword=${CR_DB_PWD}
#                        ...    port=${CR_PORT}
#                        ...    registryPort=${CR_REGISTRYPORT}
#                        ...    adminState=${CR_ADMIN_STATE}
#                        ...    storageType=named
#                        ...    storageLocation=testlocationstatic


#                        Log To Console    ${response}
#                        ${result}    Get Result    ${response}
#                        ${status}    Get From Dictionary    ${result}    status
#                        ${message}    Get From Dictionary    ${result}    message
#                        Log to Console    ${message}
#                        Should Be Equal As Strings    ${status}    200


#                        PCC.CR Wait For Creation
#                        ...    Name=${STATIC_MODE_CR_NAME}


# ###################################################################################################################################
# Create a Container Registry(using Auto mode) : TCP-578
# ###################################################################################################################################
#         [Documentation]    *Create CR* test
#                            ...  keywords:
#                            ...  PCC.Create Container Registry
        
        
#         ${response}    PCC.Create Container Registry

#                        ...    Name=${CR_NAME}
#                        ...    fullyQualifiedDomainName=${CR_FQDN}
#                        ...    password=${CR_PASSWORD}
#                        ...    secretKeyBase=${CR_SECRETKEYBASE}
#                        ...    databaseName=${CR_DATABASENAME}
#                        ...    databasePassword=${CR_DB_PWD}
#                        ...    port=${CR_PORT}
#                        ...    registryPort=${CR_REGISTRYPORT}
#                        ...    adminState=${CR_ADMIN_STATE}
#                        ...    storageType=mount
#                        ...    storageLocation=testlocation


#                        Log To Console    ${response}
#                        ${result}    Get Result    ${response}
#                        ${status}    Get From Dictionary    ${result}    status
#                        ${message}    Get From Dictionary    ${result}    message
#                        Log to Console    ${message}
#                        Should Be Equal    "${status}"    "200"


#                        PCC.CR Wait For Creation
#                        ...    Name=${CR_NAME}

                       
                       
# ###################################################################################################################################
# Get Host IP used by CR in Auto Mode
# ###################################################################################################################################
                
#         [Documentation]    *Get Host IP used by CR in Auto Mode* test
#                            ...  keywords:
#                            ...  PCC.Get Host IP
        
#         ${host_ip}    PCC.Get Host IP
#                       ...  Name=calsoft1 
#                       Log To Console    ${host_ip}
#                       Set Global Variable    ${host_ip}
                       
# ###################################################################################################################################
# Verify CR creation successful from frontend : TCP-578
# ###################################################################################################################################

#         [Documentation]    *Verify CR creation successful from frontend and backend* test
#                            ...  keywords:
#                            ...  PCC.CR Verify Creation from PCC
#                            ...  Is Docker Container Up
#                            ...  motorframework.common.LinuxUtils.Is FQDN reachable
#                            ...  Is Port Used
                            
        
        
#         ${result}    PCC.CR Verify Creation from PCC
#                      ...    Name=${CR_NAME}
#                      Log to console    "${result}"
#                      Should Be Equal As Strings    ${result}    OK
                     
                     
# ###################################################################################################################################
# Verify CR creation successful from backend : TCP-578
# ###################################################################################################################################

#         [Documentation]    *Verify CR creation successful from backend* test
                            
        
        
#         ${container_up_result1}    Is Docker Container Up 
#                      ...    container_name=portus_nginx_1
#                      ...    hostip=${host_ip}
                     
#         ${container_up_result2}    Is Docker Container Up 
#                      ...    container_name=portus_background_1
#                      ...    hostip=${host_ip}
                     
#         ${container_up_result3}    Is Docker Container Up 
#                      ...    container_name=portus_registry_1
#                      ...    hostip=${host_ip}
                     
#         ${container_up_result4}    Is Docker Container Up 
#                      ...    container_name=portus_portus_1
#                      ...    hostip=${host_ip}
                     
#         ${container_up_result5}    Is Docker Container Up 
#                      ...    container_name=portus_db_1
#                      ...    hostip=${host_ip}
                     
#                      Log to Console    ${container_up_result1}
#                      Should Be Equal As Strings    ${container_up_result1}    OK
                     
#                      Log to Console    ${container_up_result2}
#                      Should Be Equal As Strings    ${container_up_result2}    OK
                     
#                      Log to Console    ${container_up_result3}
#                      Should Be Equal As Strings    ${container_up_result3}    OK
                     
#                      Log to Console    ${container_up_result4}
#                      Should Be Equal As Strings    ${container_up_result4}    OK
                     
#                      Log to Console    ${container_up_result5}
#                      Should Be Equal As Strings    ${container_up_result5}    OK
                     
#         ${FQDN_reachability_result}    pcc_qa.common.LinuxUtils.Is FQDN reachable
#                      ...    FQDN_name=${CR_FQDN}
#                      ...    hostip=${host_ip}
                     
#                      Log to Console    ${FQDN_reachability_result}
#                      Should Be Equal As Strings    ${FQDN_reachability_result}    OK
                     
#         ${Port_used_result}    Is Port Used   
#                      ...    port_number=${CR_REGISTRYPORT}
#                      ...    hostip=${host_ip}
                     
#                      Log to Console    ${Port_used_result}
#                      Should Be Equal As Strings    ${Port_used_result}    OK
                     
                     
# ###################################################################################################################################
# Checks if image pulled from Docker already exists and delete from local repo : TCP-837
# ###################################################################################################################################

#         [Documentation]    *Checks if image exists and delete from local repo* test
#                            ...  keywords:
#                            ...  Check if image exists in local repo
#                            ...  Delete image from local repo, if exists 
        
        
#         ${check_image_status}    Check if image exists in local repo    
#                                  ...    image_name=${CR_IMAGE_NAME}
#                                  ...    hostip=${host_ip}
        
        
#         ${delete_image_status}    Delete image from local repo, if exists
#                                   ...    image_name=${CR_IMAGE_NAME}
#                                   ...    hostip=${host_ip}
#                                   Set Suite Variable    ${check_image_status}    "False"
                                  
                                  
# ###################################################################################################################################
# Pull image from Docker Registry : TCP-837
# ###################################################################################################################################

#         [Documentation]    *Pull image from Docker Registry* test
#                            ...  keywords:
#                            ...  Pull From Docker Registry
                           
        
#         ${return} =    Run Keyword If    ${check_image_status} == "False"
                       
#                        ...    Pull From Docker Registry    image_name=${CR_IMAGE_NAME}    hostip=${host_ip}
#                        ...    ELSE
                       
#                        ...    Pull From Docker Registry    image_name=${CR_IMAGE_NAME}    hostip=${host_ip}
                       
#                        Log to Console    ${return}
#                        Should Be Equal As Strings    ${return}    OK
                       
# ###################################################################################################################################
# Tag image : TCP-837
# ###################################################################################################################################

#         [Documentation]    *Tag image* test
#                            ...  keywords:
#                            ...  Tag Image
        
        
#         ${result}    Tag Image
#                      ...    image_name=${CR_IMAGE_NAME}
#                      ...    registry_url=${CR_FQDN}
#                      ...    port=${CR_REGISTRYPORT}
#                      ...    custom_name=${CR_CUSTOM_IMAGE_NAME}
#                      ...    hostip=${host_ip}
                     
#                      Log to Console    ${result}
#                      Should Be Equal As Strings    ${result}    OK
                     
# ###################################################################################################################################
# Login to C-Registry : TCP-837
# ###################################################################################################################################

#         [Documentation]    *Login to C-Registry* test
#                            ...  keywords:
#                            ...  PCC.CR login using docker  
        
#         ${result}    PCC.CR login using docker
                             
#                      ...    registryPort=${CR_REGISTRYPORT}
#                      ...    portus_password=${CR_PASSWORD}  
#                      ...    fullyQualifiedDomainName=${CR_FQDN}
#                      ...    portus_uname=${CR_PORTUS_UNAME}
#                      ...    hostip=${host_ip}
                                     
#                      Log To Console    ${result}
#                      Should Be Equal As Strings    ${result}    OK
                     

# ###################################################################################################################################
# Push to C-Registry : TCP-837
# ###################################################################################################################################

#         [Documentation]    *Push to C-Registry* test
#                            ...  keywords:
#                            ...  Push To Registry   
        
#         ${result}    Push To Registry
                     
#                      ...    registry_url=${CR_FQDN}
#                      ...    port=${CR_REGISTRYPORT}
#                      ...    custom_name=${CR_CUSTOM_IMAGE_NAME}
#                      ...    hostip=${host_ip}
                     
                     
#                      Log to Console    ${result}
#                      Should Be Equal As Strings    ${result}    OK
                     
# ###################################################################################################################################
# Checks if image pulled from CR already exists and delete from local repo : TCP-837
# ###################################################################################################################################

#         [Documentation]    *Checks if image exists and delete from local repo* test
#                            ...  keywords:
#                            ...  Check if image exists in local repo
#                            ...  Delete image from local repo, if exists
                           
                            
        
#         ${check_image_status}    Check if image exists in local repo    
#                                  ...    image_name=${CR_CUSTOM_IMAGE_NAME}
#                                  ...    hostip=${host_ip}
                                 
#         ${return} =    Run Keyword If    "${check_image_status}" == "OK"
#                        ...    Delete image from local repo, if exists    image_name=${CR_FQDN}:${CR_REGISTRYPORT}/${CR_CUSTOM_IMAGE_NAME}    hostip=${host_ip}
                       
#                        Log to Console    ${return}
#                        Should Be Equal As Strings    ${return}    OK
                       
# ###################################################################################################################################
# Pull from CRegistry to server : TCP-837
# ###################################################################################################################################

#         [Documentation]    *Pull from CRegistry to server* test
#                            ...  keywords:
#                            ...  Pull From Registry
        
        
#         ${result}    Pull From Registry
                     
#                      ...    image_name=${CR_CUSTOM_IMAGE_NAME}
#                      ...    registry_url=${CR_FQDN}
#                      ...    registryPort=${CR_REGISTRYPORT}
#                      ...    hostip=${host_ip}
                     
#                      Log to Console    ${result}
#                      Should Be Equal As Strings    ${result}    OK
                     
# ###################################################################################################################################
# Verify image pulled to server : TCP-837
# ###################################################################################################################################

#         [Documentation]    *Verify image pulled to server* test
#                            ...  keywords:
#                            ...  Check if image exists in local repo 
        
        
        
#         ${result}    Check if image exists in local repo
                     
#                      ...    image_name=${CR_CUSTOM_IMAGE_NAME}
#                      ...    hostip=${host_ip}
                     
#                      Log to Console    ${result}
#                      Should Be Equal As Strings    ${result}    OK
