#*** Settings ***
#Resource    pcc_resources.robot
#Library    Collections
#
#*** Variables ***
#${pcc_setup}    pcc_212
#
#*** Test Cases ***
####################################################################################################################################
#Login to PCC.
####################################################################################################################################
#
#        [Documentation]    *Login to PCC* test
#        [Tags]    OS_Verify
#        ${status}        Login To PCC    ${pcc_setup}
#                         Should Be Equal    ${status}  OK
#
#                         Load Clusterhead 1 Test Data    ${pcc_setup}
#                         Load Clusterhead 2 Test Data    ${pcc_setup}
#                         Load Server 1 Test Data    ${pcc_setup}
#                         Load Server 2 Test Data    ${pcc_setup}
#                         Load Server 3 Test Data    ${pcc_setup}
#                         Load Network Manager Data    ${pcc_setup}
#                         Load OpenSSH_Keys Data    ${pcc_setup}
#                         Load Ipam Data    ${pcc_setup}
#                         Load i28 Data    ${pcc_setup}
#                         Load OS-Deployment Data    ${pcc_setup}
#
#        ${server1_id}    PCC.Get Node Id    Name=${SERVER_1_NAME}
#                         Log To Console    ${server1_id}
#                         Set Global Variable    ${server1_id}
#
#######################################################################################################################################
#Add Nodes
######################################################################################################################################
#
#    [Documentation]    *Add Nodes* test
#    [Tags]    add
#    ${status}    PCC.Add mutliple nodes and check online
#                 ...  host_ips=['${CLUSTERHEAD_1_HOST_IP}', '${CLUSTERHEAD_2_HOST_IP}', '${SERVER_1_HOST_IP}']
#                 ...  Names=['${CLUSTERHEAD_1_NAME}', '${CLUSTERHEAD_2_NAME}', '${SERVER_1_NAME}']
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    OK
#
####################################################################################################################################
#Update OS Images
####################################################################################################################################
#
#    [Documentation]    *Update OS Images* test
#    [Tags]    Greenfield
#    ${result}    PCC.Update OS Images
#                 ...    host_ip=${PCC_HOST_IP}
#                 ...    username=${PCC_LINUX_USER}
#                 ...    password=${PCC_LINUX_PASSWORD}
#
#                 Log To Console    ${result}
#
####################################################################################################################################
#Add Public Key
####################################################################################################################################
#                
#        
#        [Documentation]    *Add Public Key* test
#        
#        ${response}    PCC.Add OpenSSH Key
#                       ...  Alias=${PUBLIC_KEY_ALIAS}
#                       ...  Description=${PUBLIC_KEY_DESCRIPTION}
#                       ...  Filename=${PUBLIC_KEY}
#  
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    statusCodeValue
#                       Should Be Equal As Strings    ${status}    200
#
####################################################################################################################################
#Adding Mass+LLDP To Invaders
####################################################################################################################################
#    [Documentation]                 *Adding Mass+LLDP To Invaders*
#                               ...  Keywords:
#                               ...  PCC.Add and Verify Roles On Nodes
#                               ...  PCC.Wait Until Roles Ready On Nodes      
#        
#        ${response}                 PCC.Add and Verify Roles On Nodes
#                               ...  nodes=["${CLUSTERHEAD_1_NAME}"]
#                               ...  roles=["Default","Baremetal Management Node"]
#                                    Should Be Equal As Strings      ${response}  OK
#
#        ${status_code}              PCC.Wait Until Roles Ready On Nodes
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                                    Should Be Equal As Strings      ${status_code}  OK
#
#
####################################################################################################################################
#Create Subnet and Network Manager For OS Test Cases  
####################################################################################################################################
#    [Documentation]                 *Create IPAM Subnet*
#                               ...  keywords:
#                               ...  PCC.Ipam Subnet Create
#                               ...  PCC.Wait Until Ipam Subnet Ready
#
#        ${response}                 PCC.Ipam Subnet Create
#                               ...  name=${IPAM_CONTROL_SUBNET_NAME}
#                               ...  subnet=${IPAM_CONTROL_SUBNET_IP}
#                               ...  pubAccess=False
#                               ...  routed=False
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    
#        ${status}                   PCC.Wait Until Ipam Subnet Ready
#                               ...  name=${IPAM_CONTROL_SUBNET_NAME}
#
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Ipam Subnet Create
#                               ...  name=${IPAM_DATA_SUBNET_NAME}
#                               ...  subnet=${IPAM_DATA_SUBNET_IP}
#                               ...  pubAccess=False
#                               ...  routed=False
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    
#        ${status}                   PCC.Wait Until Ipam Subnet Ready
#                               ...  name=${IPAM_DATA_SUBNET_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Network Manager Create
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               ...  nodes=${NETWORK_MANAGER_NODES}
#                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
#                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                  
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK 
#                               
#        ${status}                   PCC.Network Manager Verify BE      
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP} 
#                                    Should Be Equal As Strings      ${status}  OK          
#                                    
####################################################################################################################################
#Verify Provision Ready Status and update node, if not ready (TC-1)
####################################################################################################################################
#
#    [Documentation]    *Verify Provision Ready Status and update node, if not ready* test
#    [Tags]    OS
#    ${response}    PCC.Update Node for OS Deployment
#
#                   ...    Id=${server1_id}
#                   ...    Node_name=${SERVER_1_NAME}
#                   ...    Name=${SERVER_1_NAME}
#                   ...    host_ip=${SERVER_1_HOST_IP}
#                   ...    bmc_ip=${SERVER_1_BMC}
#                   ...    bmc_user=${SERVER_1_BMCUSER}
#                   ...    bmc_users=["${SERVER_1_BMCUSER}"]
#                   ...    bmc_password=${SERVER_1_BMCPWD}
#                   ...    server_console=${SERVER_1_CONSOLE}
#                   ...    managed=${SERVER_1_MANAGED_BY_PCC}
#
#                   Log To Console    ${response}
#                   ${result}    Get Result    ${response}
#                   ${status}    Get From Dictionary    ${result}    status
#                   ${message}    Get From Dictionary    ${result}    message
#                   Log to Console    ${message}
#                   Should Be Equal As Strings    ${status}    200
#
####################################################################################################################################
#Update OS details (centos76) - Brownfield
####################################################################################################################################
#
#    [Documentation]    *Update OS details (centos76) - Brownfield* test
#    [Tags]    OS
#    ${response}           PCC.Update OS details
#
#                          ...    Id=[${server1_id}]
#                          ...    image_name=${IMAGE_1_NAME}
#                          ...    locale=${LOCALE}
#                          ...    time_zone=${TIME_ZONE}
#                          ...    admin_user=${ADMIN_USER}
#                          ...    ssh_keys=["${SSH_KEYS}"]
#
#                          Log To Console    ${response}
#                          ${result}    Get Result    ${response}
#                          ${status}    Get From Dictionary    ${response}    StatusCode
#                          ${message}    Get From Dictionary    ${result}    message
#                          Log to Console    ${message}
#                          Should Be Equal As Strings    ${status}    200
#
#                          Log To Console    Sleeping for a while till OS gets updated
#                          Sleep    15 minutes
#                          Log To Console    Done sleeping
#
####################################################################################################################################
#Wait Until Node Ready (centos76) - Brownfield
####################################################################################################################################
#
#    [Documentation]    *Wait Until Node Ready (centos76) - Brownfield* test
#    [Tags]    OS
#    ${status}    PCC.Wait Until Node Ready
#                 ...    Name=${SERVER_1_NAME}
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    OK
#
#
#
####################################################################################################################################
#Verify OS details from PCC (centos76) - Brownfield
####################################################################################################################################
#
#    [Documentation]    *Verify OS details from PCC* test
#    [Tags]    OS_Verify
#    ${status}    PCC.Verify OS details from PCC
#                 ...  Name=${SERVER_1_NAME}
#                 ...  image_name=${IMAGE_1_NAME}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#
#                 Sleep    3 minutes
#
####################################################################################################################################
#Set Password on Server (CentOS)
###################################################################################################################################
#
#    [Documentation]    *Set Password on Server* test
#    [Tags]    Password
#    ${status}    PCC.Set password on Server
#                 ...  key_name=${KEY_NAME}
#                 ...  admin_user=${ADMIN_USER}
#                 ...  host_ip=${SERVER_1_HOST_IP}
#                 ...  password=${SERVER_1_PWD}
#                 ...  i28_username=${i28_USERNAME}
#                 ...  i28_hostip=${i28_HOST_IP}
#                 ...  i28_password=${i28_PASSWORD}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    OK
#                 
####################################################################################################################################
#Network Manager Refresh and Verify After Brownfield OS Deployment(centos76)
####################################################################################################################################
#    [Documentation]                 *Network Manager Refresh Interfaces For Server Falling in DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Network Manager Refresh
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#                               
#        ${response}                 PCC.Network Manager Refresh
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK 
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK 
# 
#        ${status}                   PCC.Network Manager Verify BE      
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK      
#
####################################################################################################################################
#Network Manager Update After Brownfield OS Deployment(centos76)
####################################################################################################################################
#    [Documentation]                 *Network Manager Update Interfaces For Server Not Falling In DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Get Network Manager Id
#                               ...  PCC.Network Manager Update
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#
#        ${network_id}               PCC.Get Network Manager Id
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               
#        ${response}                 PCC.Network Manager Update
#                               ...  id=${network_id}
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
#                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
#                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK 
#
#        ${status}                   PCC.Network Manager Verify BE      
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
#                                    
####################################################################################################################################
#Verify Provision Ready Status and update node, if not ready (TC-2)
####################################################################################################################################
#
#    [Documentation]    *Verify Provision Ready Status and update node, if not ready* test
#    [Tags]    OS
#    ${response}    PCC.Update Node for OS Deployment
#
#                   ...    Id=${server1_id}
#                   ...    Node_name=${SERVER_1_NAME}
#                   ...    Name=${SERVER_1_NAME}
#                   ...    host_ip=${SERVER_1_HOST_IP}
#                   ...    bmc_ip=${SERVER_1_BMC}
#                   ...    bmc_user=${SERVER_1_BMCUSER}
#                   ...    bmc_users=["${SERVER_1_BMCUSER}"]
#                   ...    bmc_password=${SERVER_1_BMCPWD}
#                   ...    server_console=${SERVER_1_CONSOLE}
#                   ...    managed=${SERVER_1_MANAGED_BY_PCC}
#
#                   Log To Console    ${response}
#                   ${result}    Get Result    ${response}
#                   ${status}    Get From Dictionary    ${result}    status
#                   ${message}    Get From Dictionary    ${result}    message
#                   Log to Console    ${message}
#                   Should Be Equal As Strings    ${status}    200
#                   
####################################################################################################################################
#Update OS details (ubuntu-bionic) - Brownfield
####################################################################################################################################
#
#    [Documentation]    *Update OS details (ubuntu-bionic) - Brownfield* test
#    [Tags]    OS
#    ${response}           PCC.Update OS details
#
#                          ...    Id=[${server1_id}]
#                          ...    image_name=${IMAGE_2_NAME}
#                          ...    locale=${LOCALE}
#                          ...    time_zone=${TIME_ZONE}
#                          ...    admin_user=${ADMIN_USER}
#                          ...    ssh_keys=["${SSH_KEYS}"]
#
#                          Log To Console    ${response}
#                          ${result}    Get Result    ${response}
#                          ${status}    Get From Dictionary    ${response}    StatusCode
#                          ${message}    Get From Dictionary    ${result}    message
#                          Log to Console    ${message}
#                          Should Be Equal As Strings    ${status}    200
#
#                          Log To Console    Sleeping for a while till OS gets updated
#                          Sleep    15 minutes
#                          Log To Console    Done sleeping
#
#
####################################################################################################################################
#Wait Until Node Ready (ubuntu-bionic) - Brownfield
####################################################################################################################################
#
#    [Documentation]    *Wait Until Node Ready (ubuntu-bionic) - Brownfield* test
#    [Tags]    OS
#    ${status}    PCC.Wait Until Node Ready
#                 ...    Name=${SERVER_1_NAME}
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    OK
#
#
#
####################################################################################################################################
#Verify OS details from PCC (ubuntu-bionic) - Brownfield
####################################################################################################################################
#
#    [Documentation]    *Verify OS details from PCC (ubuntu-bionic)* test
#    [Tags]    OS_Verify
#    ${status}    PCC.Verify OS details from PCC
#                 ...  Name=${SERVER_1_NAME}
#                 ...  image_name=${IMAGE_2_NAME}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#
####################################################################################################################################
#Set Password on Server (Ubuntu)
###################################################################################################################################
#
#    [Documentation]    *Set Password on Server* test
#    [Tags]    Password
#    ${status}    PCC.Set password on Server
#                 ...  key_name=${KEY_NAME}
#                 ...  admin_user=${ADMIN_USER}
#                 ...  host_ip=${SERVER_1_HOST_IP}
#                 ...  password=${SERVER_1_PWD}
#                 ...  i28_username=${i28_USERNAME}
#                 ...  i28_hostip=${i28_HOST_IP}
#                 ...  i28_password=${i28_PASSWORD}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    OK
#                 
####################################################################################################################################
#Network Manager Refresh and Verify After Brownfield OS Deployment(ubuntu-bionic)
####################################################################################################################################
#    [Documentation]                 *Network Manager Refresh Interfaces For Server Falling in DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Network Manager Refresh
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#                               
#        ${response}                 PCC.Network Manager Refresh
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK 
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK 
# 
#        ${status}                   PCC.Network Manager Verify BE      
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK      
#
####################################################################################################################################
#Network Manager Update After Brownfield OS Deployment(ubuntu-bionic)
####################################################################################################################################
#    [Documentation]                 *Network Manager Update Interfaces For Server Not Falling In DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Get Network Manager Id
#                               ...  PCC.Network Manager Update
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#
#        ${network_id}               PCC.Get Network Manager Id
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               
#        ${response}                 PCC.Network Manager Update
#                               ...  id=${network_id}
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
#                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
#                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK 
#
#        ${status}                   PCC.Network Manager Verify BE      
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
#                                    
####################################################################################################################################
#Network Manager Delete and Verify PCC After Brownfield OS Deployment
####################################################################################################################################
#    [Documentation]                 *Network Manager Verification PCC*
#                               ...  keywords:
#                               ...  PCC.Network Manager Delete
#                               ...  PCC.Wait Until Network Manager Ready
#                               
#        ${response}                 PCC.Network Manager Delete
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Deleted
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK