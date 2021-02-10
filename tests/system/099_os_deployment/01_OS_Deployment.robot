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
        [Tags]    Only
        ${status}        Login To PCC    ${pcc_setup}
                         Should Be Equal    ${status}  OK
			
			 Load PCC Test Data    ${pcc_setup}
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         Load Server 3 Test Data    ${pcc_setup}
                         Load Network Manager Data    ${pcc_setup}
                         Load OpenSSH_Keys Data    ${pcc_setup}
                         Load Ipam Data    ${pcc_setup}
                         Load i28 Data    ${pcc_setup}
                         Load OS-Deployment Data    ${pcc_setup}

        ${server2_id}    PCC.Get Node Id    Name=${SERVER_2_NAME}
                         Log To Console    ${server2_id}
                         Set Global Variable    ${server2_id}


######################################################################################################################################
#Add Nodes
######################################################################################################################################
#
#    [Documentation]    *Add Nodes* test
#
#    ${status}    PCC.Add mutliple nodes and check online
#                 ...  host_ips=['${CLUSTERHEAD_1_HOST_IP}', '${CLUSTERHEAD_2_HOST_IP}', '${SERVER_3_HOST_IP}']
#                 ...  Names=['${CLUSTERHEAD_1_NAME}', '${CLUSTERHEAD_2_NAME}', '${SERVER_3_NAME}']
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    OK
#
###################################################################################################################################
Update OS Images
###################################################################################################################################

        [Documentation]    *Update OS Images* test
                           ...  keywords:
                           ...  PCC.Update OS Images
        [Tags]    Only

        ${result}      PCC.Update OS Images
                       ...    setup_password=${PCC_SETUP_PWD}
                       ...    pcc_username=${PCC_USERNAME}
		       ...    pcc_password=${PCC_PASSWORD}	
		       ...    host_ip=${PCC_HOST_IP}
                       ...    username=${PCC_LINUX_USER}
                       ...    password=${PCC_LINUX_PASSWORD}

                       Log To Console    ${result}
                       Should Be Equal As Strings      ${result}  OK

###################################################################################################################################
Add Public Key
###################################################################################################################################


        [Documentation]    *Add Public Key* test

        ${key_id}    PCC.Get OpenSSH Key Id
                     ...    Name=${PUBLIC_KEY_ALIAS}

                     Log To Console    ${key_id}
                     Pass Execution If    ${key_id} is not ${None}    Key is alredy Created

        ${response}    PCC.Add OpenSSH Key
                       ...  Alias=${PUBLIC_KEY_ALIAS}
                       ...  Description=${PUBLIC_KEY_DESCRIPTION}
                       ...  Filename=${PUBLIC_KEY}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    statusCodeValue
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Adding Maas+LLDP To Invaders
###################################################################################################################################
    [Documentation]                 *Adding Maas+LLDP To Invaders*
                               ...  Keywords:
                               ...  PCC.Add and Verify Roles On Nodes
                               ...  PCC.Wait Until Roles Ready On Nodes

        ${response}                 PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  roles=["Default","Baremetal Management Node"]
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

    ${response}    PCC.Update Node for OS Deployment

                   ...    Id=${server2_id}
                   ...    Node_name=${SERVER_2_NAME}
                   ...    Name=${SERVER_2_NAME}
                   ...    host_ip=${SERVER_2_HOST_IP}
                   ...    bmc_ip=${SERVER_2_BMC}
                   ...    bmc_user=${SERVER_2_BMCUSER}
                   ...    bmc_users=["${SERVER_2_BMCUSER}"]
                   ...    bmc_password=${SERVER_2_BMCPWD}
                   ...    server_console=${SERVER_2_CONSOLE}
                   ...    managed=${SERVER_2_MANAGED_BY_PCC}

                   Log To Console    ${response}
                   ${result}    Get Result    ${response}
                   ${status}    Get From Dictionary    ${result}    status
                   ${message}    Get From Dictionary    ${result}    message
                   Log to Console    ${message}
                   Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Update OS details (centos78) - Brownfield
###################################################################################################################################

    [Documentation]    *Update OS details (centos78) - Brownfield* test

    ${response}           PCC.Update OS details

                          ...    Id=[${server2_id}]
                          ...    image_name=${IMAGE_1_NAME}
                          ...    locale=${LOCALE}
                          ...    time_zone=${TIME_ZONE}
                          ...    admin_user=${ADMIN_USER}
                          ...    ssh_keys=["${SSH_KEYS}"]

                          Log To Console    ${response}
                          ${result}    Get Result    ${response}
                          ${status}    Get From Dictionary    ${response}    StatusCode
                          ${message}    Get From Dictionary    ${result}    message
                          Log to Console    ${message}
                          Should Be Equal As Strings    ${status}    200

                          Log To Console    Sleeping for a while till OS gets updated
                          Sleep    15 minutes
                          Log To Console    Done sleeping

###################################################################################################################################
Wait Until Node Ready (centos78) - Brownfield
###################################################################################################################################

    [Documentation]    *Wait Until Node Ready (centos78) - Brownfield* test

    ${status}    PCC.Wait Until Node Ready
                 ...    Name=${SERVER_2_NAME}
                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK



###################################################################################################################################
Verify OS details from PCC (centos78) - Brownfield
###################################################################################################################################

    [Documentation]    *Verify OS details from PCC* test

    ${status}    PCC.Verify OS details from PCC
                 ...  Name=${SERVER_2_NAME}
                 ...  image_name=${IMAGE_1_NAME}

                 Log To Console    ${status}
                 Should be equal as strings    ${status}    True

                 Sleep    3 minutes

###################################################################################################################################
Set Password on Server (CentOS)
##################################################################################################################################

    [Documentation]    *Set Password on Server* test

    ${status}    PCC.Set password on Server
                 ...  key_name=${KEY_NAME}
                 ...  admin_user=${ADMIN_USER}
                 ...  host_ip=${SERVER_2_HOST_IP}
                 ...  password=${SERVER_2_PWD}
                 ...  i28_username=${i28_USERNAME}
                 ...  i28_hostip=${i28_HOST_IP}
                 ...  i28_password=${i28_PASSWORD}

                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK

###################################################################################################################################
Network Manager Refresh and Verify After Brownfield OS Deployment(centos78)
###################################################################################################################################
    [Documentation]                 *Network Manager Refresh Interfaces For Server Falling in DataCIDR*
                               ...  keywords:
                               ...  PCC.Network Manager Refresh
                               ...  PCC.Wait Until Network Manager Ready
                               ...  PCC.Network Manager Verify BE

        ${response}                 PCC.Network Manager Refresh
                               ...  name=${NETWORK_MANAGER_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Network Manager Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_2_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}"]
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                                    Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
#Network Manager Update After Brownfield OS Deployment(centos78)
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
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_2_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
#
###################################################################################################################################
Verify Provision Ready Status and update node, if not ready (TC-2)
###################################################################################################################################

    [Documentation]    *Verify Provision Ready Status and update node, if not ready* test
    [Tags]    Only
    ${response}    PCC.Update Node for OS Deployment

                   ...    Id=${server2_id}
                   ...    Node_name=${SERVER_2_NAME}
                   ...    Name=${SERVER_2_NAME}
                   ...    host_ip=${SERVER_2_HOST_IP}
                   ...    bmc_ip=${SERVER_2_BMC}
                   ...    bmc_user=${SERVER_2_BMCUSER}
                   ...    bmc_users=["${SERVER_2_BMCUSER}"]
                   ...    bmc_password=${SERVER_2_BMCPWD}
                   ...    server_console=${SERVER_2_CONSOLE}
                   ...    managed=${SERVER_2_MANAGED_BY_PCC}

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
    [Tags]    Only
    ${response}           PCC.Update OS details

                          ...    Id=[${server2_id}]
                          ...    image_name=${IMAGE_2_NAME}
                          ...    locale=${LOCALE}
                          ...    time_zone=${TIME_ZONE}
                          ...    admin_user=${ADMIN_USER}
                          ...    ssh_keys=["${SSH_KEYS}"]

                          Log To Console    ${response}
                          ${result}    Get Result    ${response}
                          ${status}    Get From Dictionary    ${response}    StatusCode
                          ${message}    Get From Dictionary    ${result}    message
                          Log to Console    ${message}
                          Should Be Equal As Strings    ${status}    200

                          Log To Console    Sleeping for a while till OS gets updated
                          Sleep    15 minutes
                          Log To Console    Done sleeping


###################################################################################################################################
Wait Until Node Ready (ubuntu-bionic) - Brownfield
###################################################################################################################################

    [Documentation]    *Wait Until Node Ready (ubuntu-bionic) - Brownfield* test
    [Tags]    Only
    ${status}    PCC.Wait Until Node Ready
                 ...    Name=${SERVER_2_NAME}
                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK



###################################################################################################################################
Verify OS details from PCC (ubuntu-bionic) - Brownfield
###################################################################################################################################

    [Documentation]    *Verify OS details from PCC (ubuntu-bionic)* test
    [Tags]    Only
    ${status}    PCC.Verify OS details from PCC
                 ...  Name=${SERVER_2_NAME}
                 ...  image_name=${IMAGE_2_NAME}

                 Log To Console    ${status}
                 Should be equal as strings    ${status}    True

###################################################################################################################################
Set Password on Server (Ubuntu)
##################################################################################################################################

    [Documentation]    *Set Password on Server* test
    [Tags]    Only
    ${status}    PCC.Set password on Server
                 ...  key_name=${KEY_NAME}
                 ...  admin_user=${ADMIN_USER}
                 ...  host_ip=${SERVER_2_HOST_IP}
                 ...  password=${SERVER_2_PWD}
                 ...  i28_username=${i28_USERNAME}
                 ...  i28_hostip=${i28_HOST_IP}
                 ...  i28_password=${i28_PASSWORD}

                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK

###################################################################################################################################
Network Manager Refresh and Verify After Brownfield OS Deployment(ubuntu-focal)
###################################################################################################################################
    [Documentation]                 *Network Manager Refresh Interfaces For Server Falling in DataCIDR*
                               ...  keywords:
                               ...  PCC.Network Manager Refresh
                               ...  PCC.Wait Until Network Manager Ready
                               ...  PCC.Network Manager Verify BE

        ${response}                 PCC.Network Manager Refresh
                               ...  name=${NETWORK_MANAGER_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Network Manager Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_2_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}"]
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                                    Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
#Network Manager Update After Brownfield OS Deployment(ubuntu-focal)
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
#                               ...  nodes=["${SERVER_2_NAME}","${SERVER_3_NAME}","${CLUSTERHEAD_1_NAME}"]
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
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_3_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
