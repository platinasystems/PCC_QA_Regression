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
                         Load Server 3 Test Data    ${pcc_setup}
                         Load OpenSSH_Keys Data    ${pcc_setup}

                         Load OS-Deployment Data    ${pcc_setup}

        ${server3_id}    PCC.Get Node Id    Name=${SERVER_3_NAME}
                         Log To Console    ${server3_id}
                         Set Global Variable    ${server3_id}

######################################################################################################################################
#Add Nodes
######################################################################################################################################
#
#    [Documentation]    *Add Nodes* test
#    [Tags]    add
#    ${status}    PCC.Add mutliple nodes and check online
#                 ...  host_ips=['${CLUSTERHEAD_1_HOST_IP}', '${CLUSTERHEAD_2_HOST_IP}', '${SERVER_3_HOST_IP}']
#                 ...  Names=['${CLUSTERHEAD_1_NAME}', '${CLUSTERHEAD_2_NAME}', '${SERVER_3_NAME}']
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
#        ${response}    PCC.Add OpenSSH Key
#                       ...  Alias=${PUBLIC_KEY_ALIAS}
#                       ...  Description=${PUBLIC_KEY_DESCRIPTION}
#                       ...  Filename=${PUBLIC_KEY}
#                       ...  Type=${PUBLIC_TYPE}
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
#        ${response}                 PCC.Add and Verify Roles On Nodes
#                               ...  nodes=["${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
#                               ...  roles=["maas","lldp"]
#
#                                    Should Be Equal As Strings      ${response}  OK
#
#        ${status_code}              PCC.Wait Until Roles Ready On Nodes
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#
#                                    Should Be Equal As Strings      ${status_code}  OK
#
#        ${status_code}              PCC.Wait Until Roles Ready On Nodes
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#
#                                    Should Be Equal As Strings      ${status_code}  OK
#
#
#
#
####################################################################################################################################
#Verify Provision Ready Status and update node, if not ready (TC-1)
####################################################################################################################################
#
#    [Documentation]    *Verify Provision Ready Status and update node, if not ready* test
#    [Tags]    OS
#    ${response}    PCC.Update Node for OS Deployment
#
#                   ...    Id=${server3_id}
#                   ...    Node_name=${SERVER_3_NAME}
#                   ...    Name=${SERVER_3_NAME}
#                   ...    host_ip=${SERVER_3_HOST_IP}
#                   ...    bmc_ip=${SERVER_3_BMC}
#                   ...    bmc_user=${SERVER_3_BMCUSER}
#                   ...    bmc_users=["${SERVER_3_BMCUSER}"]
#                   ...    bmc_password=${SERVER_3_BMCPWD}
#                   ...    server_console=${SERVER_3_CONSOLE}
#                   ...    managed=${SERVER_3_MANAGED_BY_PCC}
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
#                          ...    Id=[${server3_id}]
#                          ...    image_name=${IMAGE_1_NAME}
#                          ...    locale=${LOCALE}
#                          ...    time_zone=${TIME_ZONE}
#                          ...    admin_user=${ADMIN_USER}
#                          ...    ssh_keys=["${SSH_KEYS}"]
#
#                          Log To Console    ${response}
#                          ${result}    Get Result    ${response}
#                          ${status}    Get From Dictionary    ${result}    status
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
#                 ...    Name=${SERVER_3_NAME}
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
#                 ...  Name=${SERVER_3_NAME}
#                 ...  image_name=${IMAGE_1_NAME}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#
#                 Sleep    3 minutes
#
#
#
####################################################################################################################################
#Verify Provision Ready Status and update node, if not ready (TC-2)
####################################################################################################################################
#
#    [Documentation]    *Verify Provision Ready Status and update node, if not ready* test
#    [Tags]    OS
#    ${response}    PCC.Update Node for OS Deployment
#
#                   ...    Id=${server3_id}
#                   ...    Node_name=${SERVER_3_NAME}
#                   ...    Name=${SERVER_3_NAME}
#                   ...    host_ip=${SERVER_3_HOST_IP}
#                   ...    bmc_ip=${SERVER_3_BMC}
#                   ...    bmc_user=${SERVER_3_BMCUSER}
#                   ...    bmc_users=["${SERVER_3_BMCUSER}"]
#                   ...    bmc_password=${SERVER_3_BMCPWD}
#                   ...    server_console=${SERVER_3_CONSOLE}
#                   ...    managed=${SERVER_3_MANAGED_BY_PCC}
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
#                          ...    Id=[${server3_id}]
#                          ...    image_name=${IMAGE_2_NAME}
#                          ...    locale=${LOCALE}
#                          ...    time_zone=${TIME_ZONE}
#                          ...    admin_user=${ADMIN_USER}
#                          ...    ssh_keys=["${SSH_KEYS}"]
#
#                          Log To Console    ${response}
#                          ${result}    Get Result    ${response}
#                          ${status}    Get From Dictionary    ${result}    status
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
#                 ...    Name=${SERVER_3_NAME}
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
#                 ...  Name=${SERVER_3_NAME}
#                 ...  image_name=${IMAGE_2_NAME}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True