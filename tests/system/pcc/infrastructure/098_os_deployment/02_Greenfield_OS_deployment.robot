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
        [Tags]    Password
        ${status}        Login To PCC    ${pcc_setup}
                         Should Be Equal    ${status}  OK

                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}

                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         Load Server 3 Test Data    ${pcc_setup}

                         Load i28 Data    ${pcc_setup}

                         Load OS-Deployment Data    ${pcc_setup}
                         Load PXE-Boot Data    ${pcc_setup}
                         Load OpenSSH_Keys Data    ${pcc_setup}

        ${server3_id}    PCC.Get Node Id    Name=${SERVER_3_NAME}
                         Log To Console    ${server3_id}
                         Set Global Variable    ${server3_id}


###################################################################################################################################
Delete node which needs to be PXE-Booted
###################################################################################################################################

    [Documentation]    *Delete node which needs to be PXE-Booted* test
    [Tags]    Greenfield
    ${response}    PCC.Delete Node
                   ...    Id=${server3_id}

                   Log To Console    ${response}
                   ${result}    Get Result    ${response}
                   ${status}    Get From Dictionary    ${result}    status
                   ${message}    Get From Dictionary    ${result}    message
                   Log to Console    ${message}
                   Should Be Equal As Strings    ${status}    200

    ${result}    PCC.Wait Until Node Deleted
                 ...    Name=${SERVER_3_NAME}

                 Log To Console    ${result}
                 Should be equal as strings    ${result}    OK


###################################################################################################################################
PXE-Boot node
###################################################################################################################################

    [Documentation]    *PXE- Boot node* test
    [Tags]    Greenfield
    ${result}    PCC.Pxe-boot node
                 ...    bmc_ip=${SERVER_3_BMC}
                 ...    host_ip=${i28_HOST_IP}
                 ...    username=${i28_USERNAME}
                 ...    password=${i28_PASSWORD}

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
                   ...    Node_name=${SERVER_3_NAME}
                   ...    Name=${PXE_BOOTED_SERVER}
                   ...    bmc_ip=${SERVER_3_BMC}
                   ...    bmc_user=${SERVER_3_BMCUSER}
                   ...    bmc_users=["${SERVER_3_BMCUSER}"]
                   ...    bmc_password=${SERVER_3_BMCPWD}
                   ...    server_console=${SERVER_3_CONSOLE}
                   ...    managed=${SERVER_3_MANAGED_BY_PCC}

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
    ${server3_id}    PCC.Get Node Id    Name=${SERVER_3_NAME}

                     Log To Console    ${server3_id}
                     Set Global Variable    ${server3_id}


    ${management_interface}    PCC.Find management interface
                               ...    Node_name=${SERVER_3_NAME}
                               ...    Id= ${server3_id}

                               Log To Console    ${management_interface}
                               Set Suite Variable    ${management_interface}

###################################################################################################################################
Update interface of pxe-booted node
###################################################################################################################################

    [Documentation]    *Update interface of pxe-booted node* test
    [Tags]    Update
    ${response}    PCC.Edit interface of pxe-booted node
                   ...    interface_name=eth2
                   ...    Id=${server3_id}
                   ...    ipv4Address=["${SERVER_3_MGMT_IP}"]
                   ...    gateway=${GATEWAY}
                   ...    managed_by_PCC=${SERVER_3_MANAGED_BY_PCC}
                   ...    adminStatus=${ADMINSTATUS_UP}

                   Log To Console    ${response}
                   ${result}    Get Result    ${response}
                   ${status}    Get From Dictionary    ${result}    status
                   ${message}    Get From Dictionary    ${result}    message
                   Log to Console    ${message}
                   Should Be Equal As Strings    ${status}    200


    ${status}    PCC.Wait Until Node Ready
                 ...    Name=${SERVER_3_NAME}
                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK

###################################################################################################################################
Verify Provision Ready Status and update node, if not ready (TC-1)
###################################################################################################################################

    [Documentation]    *Verify Provision Ready Status and update node, if not ready* test
    [Tags]    OS
    ${response}    PCC.Update Node for OS Deployment

                   ...    Id=${server3_id}
                   ...    Node_name=${SERVER_3_NAME}
                   ...    Name=${SERVER_3_NAME}
                   ...    host_ip=${SERVER_3_HOST_IP}
                   ...    bmc_ip=${SERVER_3_BMC}
                   ...    bmc_user=${SERVER_3_BMCUSER}
                   ...    bmc_users=["${SERVER_3_BMCUSER}"]
                   ...    bmc_password=${SERVER_3_BMCPWD}
                   ...    server_console=${SERVER_3_CONSOLE}
                   ...    managed=${SERVER_3_MANAGED_BY_PCC}

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

                          ...    Id=[${server3_id}]
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
                          Sleep    15 minutes
                          Log To Console    Done sleeping

###################################################################################################################################
Wait Until Node Ready (centos76)
###################################################################################################################################

    [Documentation]    *Wait Until Node Ready (centos76)* test
    [Tags]    OS
    ${status}    PCC.Wait Until Node Ready
                 ...    Name=${SERVER_3_NAME}
                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK



###################################################################################################################################
Verify OS details from PCC (centos76)
###################################################################################################################################

    [Documentation]    *Verify OS details from PCC* test
    [Tags]    OS_Verify
    ${status}    PCC.Verify OS details from PCC
                 ...  Name=${SERVER_3_NAME}
                 ...  image_name=${IMAGE_1_NAME}

                 Log To Console    ${status}
                 Should be equal as strings    ${status}    True

###################################################################################################################################
Deleting Mass+LLDP From Nodes
###################################################################################################################################
    [Documentation]                 *Deleting Mass+LLDP From Nodes*
                               ...  Keywords:
                               ...  PCC.Delete and Verify Roles On Nodes
                               ...  PCC.Wait Until Roles Ready On Nodes
        ${response}                 PCC.Delete and Verify Roles On Nodes
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
#Set Password on Server
###################################################################################################################################
#
#    [Documentation]    *Set Password on Server* test
#    [Tags]    Password
#    ${status}    PCC.Set password on Server
#                 ...  key_name=${KEY_NAME}
#                 ...  admin_user=${ADMIN_USER}
#                 ...  host_ip=${SERVER_3_HOST_IP}
#                 ...  password=${SERVER_3_PWD}
#                 ...  i28_username=${i28_USERNAME}
#                 ...  i28_hostip=${i28_HOST_IP}
#                 ...  i28_password=${i28_PASSWORD}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    OK

###################################################################################################################################
Delete Key
###################################################################################################################################


        [Documentation]    *Delete Key* test
        ${response}    PCC.Delete OpenSSH Key
                       ...  Alias=${PUBLIC_KEY_ALIAS}

                       Log To Console    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
