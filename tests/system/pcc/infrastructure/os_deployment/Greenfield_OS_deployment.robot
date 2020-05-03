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
        
        [Tags]    OS
        
        ${status}        Login To PCC    ${pcc_setup}
                         Should Be Equal    ${status}  OK
                         
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         
                         Load OS-Deployment Data    ${pcc_setup}
                         Load PXE-Boot Data    ${pcc_setup}
                         
                         
        ${server2_id}    PCC.Get Node Id    Name=${SERVER_2_NAME}
                         Log To Console    ${server2_id}
                         Set Global Variable    ${server2_id}
                         
        ${invader1_id}    PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
                         Log To Console    ${invader1_id}
                         Set Global Variable    ${invader1_id}


        
                         
###################################################################################################################################
PXE-Boot node
###################################################################################################################################

    [Documentation]    *PXE- Boot node* test
    
    [Tags]    Greenfield
    
    ${result}    PCC.Pxe-boot node 
                 ...    bmc_ip=${SERVER_1_BMC}
                 ...    host_ip=172.17.2.28
                 ...    username=pcc
                 ...    password=cals0ft
                 
                 Log To Console    ${result}
                 Should be equal as strings    ${result}    OK

###################################################################################################################################
Wait till PXE-Boot Node added to PCC, and Check Provision Status
###################################################################################################################################

    [Documentation]    *PXE- Boot node* test
    
    [Tags]    Greenfield

    ${result}    PCC.Wait until pxe booted node added to PCC
                 ...    Name=${PXE_BOOTED_SERVER}  
                 
                 Log To Console    ${result}
                 Should be equal as strings    ${result}    OK                 
    
    ${status}    PCC.Wait Until Node Ready  
                 ...    Name=${PXE_BOOTED_SERVER} 
                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK
                 
###################################################################################################################################
Update Node for OS Deployment  
###################################################################################################################################

    [Documentation]    *Update Node for OS Deployment* test                 
               
    [Tags]    Greenfield
    
    ${pxe_booted_server_id}    PCC.Get Node Id    Name=${PXE_BOOTED_SERVER}
                               Log To Console    ${pxe_booted_server_id}
                               Set Suite Variable    ${pxe_booted_server_id}
                 
                 
    ${response}    PCC.Update Node for OS Deployment
                   
                   ...    Id=${pxe_booted_server_id}
                   ...    Node_name=${SERVER_1_NAME}
                   ...    Name=${PXE_BOOTED_SERVER}
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
Get Management Interface to be set 
###################################################################################################################################

    [Documentation]    *Get Topologies Test Case* test                 
               
    [Tags]    Update
    
    ${server1_id}    PCC.Get Node Id    Name=${SERVER_1_NAME}
                     
                     Log To Console    ${server1_id}
                     Set Global Variable    ${server1_id}
    
    
    ${management_interface}    PCC.Find management interface
                               ...    Node_name=${SERVER_1_NAME}
                               ...    Id= ${server1_id}   
                  
                               Log To Console    ${management_interface}
                               Set Suite Variable    ${management_interface}


###################################################################################################################################
Update interface of pxe-booted node
###################################################################################################################################

    [Documentation]    *Update interface of pxe-booted node* test                                    
                   
    [Tags]    Update
                   
    ${response}    PCC.Edit interface of pxe-booted node
                   ...    interface_name=${management_interface}
                   ...    Id=${server1_id}
                   ...    ipv4Address=["${SERVER_1_MGMT_IP}"]
                   ...    gateway=${GATEWAY}
                   ...    managed_by_PCC=${SERVER_1_MANAGED_BY_PCC}
                   ...    adminStatus=${ADMINSTATUS_UP}
                   
                   Log To Console    ${response}
                   ${result}    Get Result    ${response}
                   ${status}    Get From Dictionary    ${result}    status
                   ${message}    Get From Dictionary    ${result}    message
                   Log to Console    ${message}
                   Should Be Equal As Strings    ${status}    200
                   
                   
    ${status}    PCC.Wait Until Node Ready  
                 ...    Name=${SERVER_1_NAME} 
                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK
                 
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
Update OS details (centos76)
###################################################################################################################################

    [Documentation]    *Update OS details (centos76)* test                           
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
                          
                          Log To Console    Sleeping for a while till OS gets deployed
                          Sleep    10 minutes 
                          Log To Console    Done sleeping

###################################################################################################################################
Wait Until Node Ready (centos76)
###################################################################################################################################

    [Documentation]    *Wait Until Node Ready (centos76)* test                           
    [Tags]    OS

                          
    ${status}    PCC.Wait Until Node Ready  
                 ...    Name=${SERVER_1_NAME} 
                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK
                 
                 
                 
###################################################################################################################################
Verify OS details from PCC (centos76)
###################################################################################################################################

    [Documentation]    *Verify OS details from PCC* test 
    
    [Tags]    OS_Verify
    
    ${status}    PCC.Verify OS details from PCC
                 ...  Name=${SERVER_1_NAME}
                 ...  image_name=${IMAGE_1_NAME}
                 
                 Log To Console    ${status}
                 Should be equal as strings    ${status}    True
                   
                 
                 
    
    
    
    
    
    
    
    
    
