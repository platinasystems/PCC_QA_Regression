*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC
###################################################################################################################################
        [Documentation]    *Login to PCC* test
        [Tags]    Login  
        ${status}        Login To PCC    ${pcc_setup}
                         Should Be Equal    ${status}  OK
                         
                         
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         
                         Load Container Registry Data    ${pcc_setup}
                         Load Auth Profile Data    ${pcc_setup}
                         

        ${server2_id}    PCC.Get Node Id    Name=${SERVER_2_NAME}
                         Log To Console    ${server2_id}
                         Set Global Variable    ${server2_id}
                         
        ${invader1_id}    PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
                         Log To Console    ${invader1_id}
                         Set Global Variable    ${invader1_id}
                         
                         
####################################################################################################################################
#Get Host IP used by CR
####################################################################################################################################
#                
#        [Documentation]    *Get Host IP used by CR* test
#                           ...  keywords:
#                           ...  PCC.Get Host IP
#        
#        ${host_ip}    PCC.Get Host IP
#                      ...  Name=${CR_NAME} 
#                      Log To Console    ${host_ip}
#                      Set Global Variable    ${host_ip}
#                         
####################################################################################################################################
#Restart Containers
####################################################################################################################################                    
#
#        [Documentation]    *Restarts containers from backend* test
#                           ...  keywords:
#                           ...  Restart Containers
#        
#        
#        ${container_up_result1}    Restart Containers 
#                     ...    container_name=portus_nginx_1
#                     ...    hostip=${host_ip}
#                     
#        ${container_up_result2}    Restart Containers 
#                     ...    container_name=portus_background_1
#                     ...    hostip=${host_ip}
#                     
#        ${container_up_result3}    Restart Containers 
#                     ...    container_name=portus_registry_1
#                     ...    hostip=${host_ip}
#                     
#        ${container_up_result4}    Restart Containers 
#                     ...    container_name=portus_portus_1
#                     ...    hostip=${host_ip}
#                     
#        ${container_up_result5}    Restart Containers 
#                     ...    container_name=portus_db_1
#                     ...    hostip=${host_ip}
#                     
#                     Log to Console    ${container_up_result1}
#                     Should Be Equal As Strings    ${container_up_result1}    OK
#                     
#                     Log to Console    ${container_up_result2}
#                     Should Be Equal As Strings    ${container_up_result2}    OK
#                     
#                     Log to Console    ${container_up_result3}
#                     Should Be Equal As Strings    ${container_up_result3}    OK
#                     
#                     Log to Console    ${container_up_result4}
#                     Should Be Equal As Strings    ${container_up_result4}    OK
#                     
#                     Log to Console    ${container_up_result5}
#                     Should Be Equal As Strings    ${container_up_result5}    OK
#                     
#                     Sleep    2 minutes
#                     
####################################################################################################################################
#Verify Container Registry from Backend after restarting containers
####################################################################################################################################
#        
#        [Documentation]    *Verify CR from backend* test
#                           ...  keywords:
#                           ...  Is Docker Container Up
#                           ...  aa.common.LinuxUtils.Is FQDN reachable
#                           ...  Is Port Used
#        
#                      
#        ${container_up_result1}    Is Docker Container Up 
#                     ...    container_name=portus_nginx_1
#                     ...    hostip=${host_ip}
#                     
#        ${container_up_result2}    Is Docker Container Up 
#                     ...    container_name=portus_background_1
#                     ...    hostip=${host_ip}
#                     
#        ${container_up_result3}    Is Docker Container Up 
#                     ...    container_name=portus_registry_1
#                     ...    hostip=${host_ip}
#                     
#                     
#        ${container_up_result4}    Is Docker Container Up 
#                     ...    container_name=portus_portus_1
#                     ...    hostip=${host_ip}
#                     
#        ${container_up_result5}    Is Docker Container Up 
#                     ...    container_name=portus_db_1
#                     ...    hostip=${host_ip}
#                     
#                     Log to Console    ${container_up_result1}
#                     Should Be Equal As Strings    ${container_up_result1}    OK
#                     
#                     Log to Console    ${container_up_result2}
#                     Should Be Equal As Strings    ${container_up_result2}    OK
#                     
#                     Log to Console    ${container_up_result3}
#                     Should Be Equal As Strings    ${container_up_result3}    OK
#                     
#                     Log to Console    ${container_up_result4}
#                     Should Be Equal As Strings    ${container_up_result4}    OK
#                     
#                     Log to Console    ${container_up_result5}
#                     Should Be Equal As Strings    ${container_up_result5}    OK
#                     
#        ${FQDN_reachability_result}    aa.common.LinuxUtils.Is FQDN reachable
#                     ...    FQDN_name=${CR_FQDN}
#                     ...    hostip=${host_ip}
#                     
#                     Log to Console    ${FQDN_reachability_result}
#                     Should Be Equal As Strings    ${FQDN_reachability_result}    OK
#                     
#        ${Port_used_result}    Is Port Used   
#                     ...    port_number=${CR_REGISTRYPORT}
#                     ...    hostip=${host_ip}
#                     
#                     Log to Console    ${Port_used_result}
#                     Should Be Equal As Strings    ${Port_used_result}    OK
#                     
#                     
#                     
####################################################################################################################################
#Verify Container registry from PCC after restarting Containers
####################################################################################################################################
#        
#        [Documentation]    *Verify Container registry from PCC after restart of Containers* test
#                           ...  keywords:
#                           ...  PCC.CR Verify Creation from PCC 
#        
#                               
#        ${result}    PCC.CR Verify Creation from PCC
#                     ...    Name=${CR_NAME}
#                     Log to console    "${result}"
#                     Should Be Equal As Strings    ${result}    OK
#                     Sleep    1 minutes
#                     
####################################################################################################################################
#Login to C-Registry after restarting containers
####################################################################################################################################
#
#        [Documentation]    *Login to C-Registry* test
#                           ...  keywords:
#                           ...  PCC.CR login using docker  
#        
#        
#        ${result}    PCC.CR login using docker
#                             
#                     
#                     ...    registryPort=${CR_REGISTRYPORT}
#                     ...    portus_password=${CR_PASSWORD}  
#                     ...    fullyQualifiedDomainName=${CR_FQDN}
#                     ...    portus_uname=${CR_PORTUS_UNAME}
#                     ...    hostip=${host_ip}
#                                     
#                     Log To Console    ${result}
#                     Should Be Equal As Strings    ${result}    OK
#                     
####################################################################################################################################
#Checks if image pulled from CR exists after restarting containers
####################################################################################################################################
#
#        [Documentation]    *Checks if image exists after restarting containers* test
#                           ...  keywords:
#                           ...  Check if image exists in local repo
#                           
#        
#        ${check_image_status}    Check if image exists in local repo    
#                                 ...    image_name=${CR_CUSTOM_IMAGE_NAME}
#                                 ...    hostip=${host_ip}
#                                 
#                                 Should Be Equal As Strings    ${check_image_status}    OK
#                                 
####################################################################################################################################
#Restart server on which CR is hosted
####################################################################################################################################
#        
#        [Documentation]    *Restart server on which CR is hosted* test
#                           ...  keywords
#                           ...  Restart node
#        
#        ${restart_status}    Restart node
#                             ...  hostip=${host_ip}
#                             ...  time_to_wait=240
#                             Log to console    ${restart_status}
#                             Should Be Equal As Strings    ${restart_status}    OK
#                             Sleep    6 minutes
#                             
####################################################################################################################################
#Verify Container Registry from Backend, after restarting server
####################################################################################################################################
#        
#        [Documentation]    *Verify CR from backend* test
#                           ...  keywords:
#                           ...  Is Docker Container Up
#                           ...  aa.common.LinuxUtils.Is FQDN reachable
#                           ...  Is Port Used 
#                            
#                      
#        ${container_up_result1}    Is Docker Container Up 
#                     ...    container_name=portus_nginx_1
#                     ...    hostip=${host_ip}
#                     
#        ${container_up_result2}    Is Docker Container Up 
#                     ...    container_name=portus_background_1
#                     ...    hostip=${host_ip}
#                     
#        ${container_up_result3}    Is Docker Container Up 
#                     ...    container_name=portus_registry_1
#                     ...    hostip=${host_ip}
#                     
#        ${container_up_result4}    Is Docker Container Up 
#                     ...    container_name=portus_portus_1
#                     ...    hostip=${host_ip}
#                     
#        ${container_up_result5}    Is Docker Container Up 
#                     ...    container_name=portus_db_1
#                     ...    hostip=${host_ip}
#                     
#                     Log to Console    ${container_up_result1}
#                     Should Be Equal As Strings    ${container_up_result1}    OK
#                     
#                     Log to Console    ${container_up_result2}
#                     Should Be Equal As Strings    ${container_up_result2}    OK
#                     
#                     Log to Console    ${container_up_result3}
#                     Should Be Equal As Strings    ${container_up_result3}    OK
#                     
#                     Log to Console    ${container_up_result4}
#                     Should Be Equal As Strings    ${container_up_result4}    OK
#                     
#                     Log to Console    ${container_up_result5}
#                     Should Be Equal As Strings    ${container_up_result5}    OK
#                     
#        ${FQDN_reachability_result}    aa.common.LinuxUtils.Is FQDN reachable
#                     ...    FQDN_name=${CR_FQDN}
#                     ...    hostip=${host_ip}
#                     
#                     Log to Console    ${FQDN_reachability_result}
#                     Should Be Equal As Strings    ${FQDN_reachability_result}    OK
#                     
#        ${Port_used_result}    Is Port Used   
#                     ...    port_number=${CR_REGISTRYPORT}
#                     ...    hostip=${host_ip}
#                     
#                     Log to Console    ${Port_used_result}
#                     Should Be Equal As Strings    ${Port_used_result}    OK
#                     
#                     
#                     
####################################################################################################################################
#Verify Container registry from PCC, after restarting server
####################################################################################################################################
#        
#        [Documentation]    *Verify Container registry from PCC after restart of server* test
#                           ...  keywords:
#                           ...  PCC.CR Verify Creation from PCC 
#                               
#        ${result}    PCC.CR Verify Creation from PCC
#                     ...    Name=${CR_NAME}
#                     Log to console    "${result}"
#                     Should Be Equal As Strings    ${result}    OK
#                     Sleep    1 minutes
#                     
####################################################################################################################################
#Login to C-Registry, after restarting server
####################################################################################################################################
#
#        [Documentation]    *Login to C-Registry* test
#                           ...  keywords:
#                           ...  PCC.CR login using docker  
#        [Tags]    Login
#        
#        ${result}    PCC.CR login using docker
#                             
#                     
#                     ...    registryPort=${CR_REGISTRYPORT}
#                     ...    portus_password=${CR_PASSWORD}  
#                     ...    fullyQualifiedDomainName=${CR_FQDN}
#                     ...    portus_uname=${CR_PORTUS_UNAME}
#                     ...    hostip=${host_ip}
#                                     
#                     Log To Console    ${result}
#                     Should Be Equal As Strings    ${result}    OK
#                     
####################################################################################################################################
#Checks if image pulled from CR exists after restarting server
####################################################################################################################################
#
#        [Documentation]    *Checks if image exists after restarting server* test
#                           ...  keywords:
#                           ...  Check if image exists in local repo
#                                                   
#                           
#        
#        ${check_image_status}    Check if image exists in local repo    
#                                 ...    image_name=${CR_CUSTOM_IMAGE_NAME}
#                                 ...    hostip=${host_ip}
#                                 
#                                 Should Be Equal As Strings    ${check_image_status}    OK
#                                 
####################################################################################################################################
#Restart PCC setup 
####################################################################################################################################
#        
#        [Documentation]    *Restart PCC setup* test
#                           ...  keywords
#                           ...  Restart node
#        
#        ${restart_status}    Restart node
#                             ...  hostip=${PCC_HOST_IP}
#                             ...  time_to_wait=240
#                             Log to console    ${restart_status}
#                             Should Be Equal As Strings    ${restart_status}    OK
#                             Sleep    6 minutes
#                             
####################################################################################################################################
#Verify Container Registry from Backend, after restarting PCC setup
####################################################################################################################################
#        
#        [Documentation]    *Verify CR from backend* test
#                           ...  keywords:
#                           ...  Is Docker Container Up
#                           ...  aa.common.LinuxUtils.Is FQDN reachable
#                           ...  Is Port Used
#                      
#        ${container_up_result1}    Is Docker Container Up 
#                     ...    container_name=portus_nginx_1
#                     ...    hostip=${host_ip}
#                     
#        ${container_up_result2}    Is Docker Container Up 
#                     ...    container_name=portus_background_1
#                     ...    hostip=${host_ip}
#                     
#        ${container_up_result3}    Is Docker Container Up 
#                     ...    container_name=portus_registry_1
#                     ...    hostip=${host_ip}
#                     
#        ${container_up_result4}    Is Docker Container Up 
#                     ...    container_name=portus_portus_1
#                     ...    hostip=${host_ip}
#                     
#        ${container_up_result5}    Is Docker Container Up 
#                     ...    container_name=portus_db_1
#                     ...    hostip=${host_ip}
#                     
#                     Log to Console    ${container_up_result1}
#                     Should Be Equal As Strings    ${container_up_result1}    OK
#                     
#                     Log to Console    ${container_up_result2}
#                     Should Be Equal As Strings    ${container_up_result2}    OK
#                     
#                     Log to Console    ${container_up_result3}
#                     Should Be Equal As Strings    ${container_up_result3}    OK
#                     
#                     Log to Console    ${container_up_result4}
#                     Should Be Equal As Strings    ${container_up_result4}    OK
#                     
#                     Log to Console    ${container_up_result5}
#                     Should Be Equal As Strings    ${container_up_result5}    OK
#                     
#        ${FQDN_reachability_result}    aa.common.LinuxUtils.Is FQDN reachable
#                     ...    FQDN_name=${CR_FQDN}
#                     ...    hostip=${host_ip}
#                     
#                     Log to Console    ${FQDN_reachability_result}
#                     Should Be Equal As Strings    ${FQDN_reachability_result}    OK
#                     
#        ${Port_used_result}    Is Port Used   
#                     ...    port_number=${CR_REGISTRYPORT}
#                     ...    hostip=${host_ip}
#                     
#                     Log to Console    ${Port_used_result}
#                     Should Be Equal As Strings    ${Port_used_result}    OK
#                     
#                     
#                     
####################################################################################################################################
#Verify Container registry from PCC, after restarting PCC setup
####################################################################################################################################
#        
#        [Documentation]    *Verify Container registry from PCC after restart of Containers* test
#                           ...  keywords:
#                           ...  PCC.CR Verify Creation from PCC 
#        
#                               
#        ${result}    PCC.CR Verify Creation from PCC
#                     ...    Name=${CR_NAME}
#                     
#                     Log to console    "${result}"
#                     Should Be Equal As Strings    ${result}    OK
#                     Sleep    1 minutes
#                     
####################################################################################################################################
#Login to C-Registry, after restarting PCC setup
####################################################################################################################################
#
#        [Documentation]    *Login to C-Registry* test
#                           ...  keywords:
#                           ...  PCC.CR login using docker  
#        
#        
#        ${result}    PCC.CR login using docker
#                             
#                     
#                     ...    registryPort=${CR_REGISTRYPORT}
#                     ...    portus_password=${CR_PASSWORD}  
#                     ...    fullyQualifiedDomainName=${CR_FQDN}
#                     ...    portus_uname=${CR_PORTUS_UNAME}
#                     ...    hostip=${host_ip}
#                     
#                                     
#                     Log To Console    ${result}
#                     Should Be Equal As Strings    ${result}    OK
#                     
####################################################################################################################################
#Checks if image pulled from CR exists after restarting PCC setup
####################################################################################################################################
#
#        [Documentation]    *Checks if image exists after restarting PCC setup* test
#                           ...  keywords:
#                           ...  Check if image exists in local repo
#                                                   
#                           
#        
#        ${check_image_status}    Check if image exists in local repo    
#                                 ...    image_name=${CR_CUSTOM_IMAGE_NAME}
#                                 ...    hostip=${host_ip}
#                                 
#                                 Should Be Equal As Strings    ${check_image_status}    OK
                             
####################################################################################################################################
Cleanup Container Registry
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
                     
###################################################################################################################################
Cleanup Auth Profiles
###################################################################################################################################
        
        [Documentation]    *Clean-up Auth Profiles* test
                           ...  keywords:
                           ...  PCC.Delete All Auth Profile     
        
        [Tags]    Login
        ########  Cleanup Auth Profile   ################################################################################
        
        ${result}    PCC.Delete All Auth Profile
        
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                     
                     Sleep    1 minutes
                     

                                 

                                 
                
