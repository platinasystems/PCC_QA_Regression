*** Settings ***
Resource    pcc_resources.robot
Library    Collections

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC.
###################################################################################################################################
        
        [Documentation]    *Login to PCC* test
        
        [Tags]    OS_Verify
        ${status}        Login To PCC    ${pcc_setup}
                         Should Be Equal    ${status}  OK
                         
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         
                         Load OS-Deployment Data    ${pcc_setup}
                         
        ${server1_id}    PCC.Get Node Id    Name=${SERVER_1_NAME}
                         Log To Console    ${server1_id}
                         Set Global Variable    ${server1_id}
        
        
        ${server2_id}    PCC.Get Node Id    Name=${SERVER_2_NAME}
                         Log To Console    ${server2_id}
                         Set Global Variable    ${server2_id}
                         
        ${invader1_id}    PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
                         Log To Console    ${invader1_id}
                         Set Global Variable    ${invader1_id}
                         
###################################################################################################################################
Update OS Images
###################################################################################################################################

    [Documentation]    *Update OS Images* test
    
    [Tags]    Greenfield
        
    ${result}    PCC.Update OS Images
                 ...    host_ip=${PCC_HOST_IP}
                 ...    username=${PCC_LINUX_USER}
                 ...    password=${PCC_LINUX_PASSWORD}
                   
                 Log To Console    ${result}
                 
###################################################################################################################################
Adding Mass+LLDP To Invaders
###################################################################################################################################
    [Documentation]                 *Adding Mass+LLDP To Invaders*
                               ...  Keywords:
                               ...  PCC.Add and Verify Roles On Nodes
                               ...  PCC.Wait Until Roles Ready On Nodes
        ${response}                 PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  roles=["maas","lldp"]

                                    Should Be Equal As Strings      ${response}  OK

        ${status_code}              PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                                     
                                    Should Be Equal As Strings      ${status_code}  OK     
                                      
        ${status_code}              PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${CLUSTERHEAD_2_NAME}

                                    Should Be Equal As Strings      ${status_code}  OK

                         
###################################################################################################################################
Verify Provision Ready Status and update node, if not ready (TC-1)
###################################################################################################################################

    [Documentation]    *Verify Provision Ready Status and update node, if not ready* test  
    [Tags]    OS
        
                 
    ${response}    PCC.Update Node for OS Deployment
                   
                   ...    Id=${server1_id}
                   ...    Node_name=${SERVER_1_NAME}
                   ...    Name=${SERVER_1_NAME}
                   ...    host_ip=${SERVER_1_HOST_IP}
                   ...    bmc_ip=${SERVER_1_BMC}
                   ...    bmc_user=${SERVER_1_BMCUSER}
                   ...    bmc_users=["${SERVER_1_BMCUSER}"]
                   ...    bmc_password=${SERVER_1_BMCPWD}
                   ...    server_console=${SERVER_1_CONSOLE}
                   ...    managed=${SERVER_1_MANAGED_BY_PCC}
                            
                   Log To Console    ${response}
                   ${result}    Get Result    ${response}
                   ${status}    Get From Dictionary    ${result}    status
                   ${message}    Get From Dictionary    ${result}    message
                   Log to Console    ${message}
                   Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Update OS details (centos76) - Brownfield
###################################################################################################################################

    [Documentation]    *Update OS details (centos76) - Brownfield* test                           
    [Tags]    OS               
                          
    ${response}           PCC.Update OS details 
    
                          ...    Id=[${server1_id}]   
                          ...    image_name=${IMAGE_1_NAME}
                          ...    locale=${LOCALE}
                          ...    time_zone=${TIME_ZONE}
                          ...    admin_user=${ADMIN_USER}
                          ...    ssh_keys=["${SSH_KEYS}"]
                   
                          Log To Console    ${response}
                          ${result}    Get Result    ${response}
                          ${status}    Get From Dictionary    ${result}    status
                          ${message}    Get From Dictionary    ${result}    message
                          Log to Console    ${message}
                          Should Be Equal As Strings    ${status}    200 
                          
                          Log To Console    Sleeping for a while till OS gets updated
                          Sleep    10 minutes 
                          Log To Console    Done sleeping

###################################################################################################################################
Wait Until Node Ready (centos76) - Brownfield
###################################################################################################################################

    [Documentation]    *Wait Until Node Ready (centos76) - Brownfield* test                           
    [Tags]    OS

                          
    ${status}    PCC.Wait Until Node Ready  
                 ...    Name=${SERVER_1_NAME} 
                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK
                 
                 
                 
###################################################################################################################################
Verify OS details from PCC (centos76) - Brownfield
###################################################################################################################################

    [Documentation]    *Verify OS details from PCC* test 
    
    [Tags]    OS_Verify
    ${status}    PCC.Verify OS details from PCC
                 ...  Name=${SERVER_1_NAME}
                 ...  image_name=${IMAGE_1_NAME}
                 
                 Log To Console    ${status}
                 Should be equal as strings    ${status}    True
                 
###################################################################################################################################
Verify Provision Ready Status and update node, if not ready (TC-2)
###################################################################################################################################

    [Documentation]    *Verify Provision Ready Status and update node, if not ready* test  
    [Tags]    OS
        
                 
    ${response}    PCC.Update Node for OS Deployment
                   
                   ...    Id=${server1_id}
                   ...    Node_name=${SERVER_1_NAME}
                   ...    Name=${SERVER_1_NAME}
                   ...    host_ip=${SERVER_1_HOST_IP}
                   ...    bmc_ip=${SERVER_1_BMC}
                   ...    bmc_user=${SERVER_1_BMCUSER}
                   ...    bmc_users=["${SERVER_1_BMCUSER}"]
                   ...    bmc_password=${SERVER_1_BMCPWD}
                   ...    server_console=${SERVER_1_CONSOLE}
                   ...    managed=${SERVER_1_MANAGED_BY_PCC}
                            
                   Log To Console    ${response}
                   ${result}    Get Result    ${response}
                   ${status}    Get From Dictionary    ${result}    status
                   ${message}    Get From Dictionary    ${result}    message
                   Log to Console    ${message}
                   Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Update OS details (ubuntu-bionic) - Brownfield
###################################################################################################################################

    [Documentation]    *Update OS details (ubuntu-bionic) - Brownfield* test                           
    [Tags]    OS               
                          
    ${response}           PCC.Update OS details 
    
                          ...    Id=[${server1_id}]   
                          ...    image_name=${IMAGE_2_NAME}
                          ...    locale=${LOCALE}
                          ...    time_zone=${TIME_ZONE}
                          ...    admin_user=${ADMIN_USER}
                          ...    ssh_keys=["${SSH_KEYS}"]
                   
                          Log To Console    ${response}
                          ${result}    Get Result    ${response}
                          ${status}    Get From Dictionary    ${result}    status
                          ${message}    Get From Dictionary    ${result}    message
                          Log to Console    ${message}
                          Should Be Equal As Strings    ${status}    200 
                          
                          Log To Console    Sleeping for a while till OS gets updated
                          Sleep    10 minutes 
                          Log To Console    Done sleeping

###################################################################################################################################
Wait Until Node Ready (ubuntu-bionic) - Brownfield
###################################################################################################################################

    [Documentation]    *Wait Until Node Ready (ubuntu-bionic) - Brownfield* test                           
    [Tags]    OS

                          
    ${status}    PCC.Wait Until Node Ready  
                 ...    Name=${SERVER_1_NAME} 
                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK
                 
                 
                 
###################################################################################################################################
Verify OS details from PCC (ubuntu-bionic) - Brownfield
###################################################################################################################################

    [Documentation]    *Verify OS details from PCC (ubuntu-bionic)* test 
    
    [Tags]    OS_Verify
    ${status}    PCC.Verify OS details from PCC
                 ...  Name=${SERVER_1_NAME}
                 ...  image_name=${IMAGE_2_NAME}
                 
                 Log To Console    ${status}
                 Should be equal as strings    ${status}    True
