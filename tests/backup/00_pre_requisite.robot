*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

    [Tags]        backend

                                    Load Clusterhead 1 Test Data        ${pcc_setup}
                                    Load Clusterhead 2 Test Data        ${pcc_setup}

                                    Load Server 1 Test Data        ${pcc_setup}
                                    Load Server 2 Test Data        ${pcc_setup}
                                    Load Server 3 Test Data        ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

#####################################################################################################################################
Add Nodes
#####################################################################################################################################

    [Documentation]                 *Add Nodes Test*

    ${status}                       PCC.Add mutliple nodes and check online
                                    ...  host_ips=['${CLUSTERHEAD_1_HOST_IP}', '${CLUSTERHEAD_2_HOST_IP}', '${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}','${SERVER_3_HOST_IP}']
                                    ...  Names=['${CLUSTERHEAD_1_NAME}', '${CLUSTERHEAD_2_NAME}', '${SERVER_1_NAME}','${SERVER_2_NAME}','${SERVER_3_NAME}']

                                    Log To Console    ${status}
				    Should be equal as strings    ${status}    OK

    ${status}                 PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK


#################################################################################################################################################################
Verify Default node role is installed
#################################################################################################################################################################

        [Documentation]    *Verify Default node role is installed* test

        #### Checking if PCC assign the Default node role to the node when a node is added to PCC #####
        ${status}    PCC.Verify Node Role On Nodes
                     ...    Name=Default
                     ...    nodes=["${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}","${SERVER_1_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK


###################################################################################################################################
Nodes Verification Back End (Services should be running and active)
###################################################################################################################################
    [Documentation]                      *Nodes Verification Back End*
                                    ...  keywords:
                                    ...  PCC.Node Verify Back End




        ${status}                   PCC.Node Verify Back End
                                    ...  host_ips=["${SERVER_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                                    Log To Console    ${status}
                                    Run Keyword If  "${status}" != "OK"  Fatal Error
				    Should Be Equal As Strings      ${status}    OK


        ${status}                   PCC.Verify LLDP Neighbors
                             ...    servers_hostip=['${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}','${SERVER_3_HOST_IP}']
                             ...    invaders_hostip=['${CLUSTERHEAD_1_HOST_IP}','${CLUSTERHEAD_2_HOST_IP}']

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.OS Package repository
                             ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.OS Package repository
                             ...    host_ip=${CLUSTERHEAD_2_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.OS Package repository
                             ...    host_ip=${SERVER_1_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.OS Package repository
                             ...    host_ip=${SERVER_2_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.OS Package repository
                             ...    host_ip=${SERVER_3_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK


        ${status}                   CLI.Validate Node Self Healing
                             ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.Validate Node Self Healing
                             ...    host_ip=${CLUSTERHEAD_2_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK


        ${status}                   CLI.Validate Node Self Healing
                             ...    host_ip=${SERVER_1_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.Validate Node Self Healing
                             ...    host_ip=${SERVER_2_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.Validate Node Self Healing
                             ...    host_ip=${SERVER_3_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.Automatic Upgrades Validation
                             ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    Automatic upgrades set to Yes from backend

        ${status}                   PCC.Check NTP services from backend
                              ...   targetNodeIp=['${SERVER_2_HOST_IP}','${SERVER_1_HOST_IP}','${SERVER_3_HOST_IP}','${CLUSTERHEAD_1_HOST_IP}','${CLUSTERHEAD_2_HOST_IP}']

                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK


        ${status}                   CLI.Validate Ethtool
                             ...    host_ips=['${CLUSTERHEAD_1_HOST_IP}','${CLUSTERHEAD_2_HOST_IP}','${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}','${SERVER_3_HOST_IP}']
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK



##################################################################################################################################
Ceph Certificate For Rgws
###################################################################################################################################

        [Documentation]              *Ceph Ceph Certificate For Rgws*

        ${cert_id}                   PCC.Get Certificate Id
                                ...  Alias=${CEPH_RGW_CERT_NAME}
                                     Pass Execution If    ${cert_id} is not ${None}    Certificate is already there

        ${response}                  PCC.Add Certificate
                                ...  Alias=${CEPH_RGW_CERT_NAME}
                                ...  Description=certificate-for-rgw
                                ...  Private_key=domain.key
                                ...  Certificate_upload=domain.crt

                                     Log To Console    ${response}
        ${result}                    Get Result    ${response}
        ${status}                    Get From Dictionary    ${result}    statusCodeValue
                                     Should Be Equal As Strings    ${status}    200


##################################################################################################################################
#Cli PCC Pull Code
####################################################################################################################################
#        [Documentation]         *Cli PCC Pull Code*
#
#            ${result}            CLI.PCC Pull Code
#                            ...  host_ip=${PCC_HOST_IP}
#                            ...  linux_user=${PCC_LINUX_USER}
#                            ...  linux_password=${PCC_LINUX_PASSWORD}
#                            ...  pcc_version_cmd=sudo /home/pcc/platina-cli-ws/platina-cli pull --configRepo master -p ${PCC_SETUP_PWD}
#
#                                 Should Be Equal     ${result}       OK
#
####################################################################################################################################
#Cli PCC Set Keys
####################################################################################################################################
#        [Documentation]         *Cli PCC Set Keys*
#
#                                 Load PCC Test Data        testdata_key=${pcc_setup}
#            ${result}            CLI.Pcc Set Keys
#                            ...  host_ip=${PCC_HOST_IP}
#                            ...  linux_user=${PCC_LINUX_USER}
#                            ...  linux_password=${PCC_LINUX_PASSWORD}
#                            ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_2_HOST_IP}"]
#
#                                 Should Be Equal     ${result}       OK

#####################################################################################################################################
Install net-tools on nodes
#####################################################################################################################################

    [Documentation]    *Install net-tools on nodes* test
    [Tags]    add

    ${status}    Install net-tools command


                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK

####### Commenting interface cleanup code for pcc242 nodes ######
#
####################################################################################################################################
#Set Interfaces For ${CLUSTERHEAD_1_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${CLUSTERHEAD_1_NAME}(i43)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth5
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=40000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth5
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth5
#                               ...  assign_ip=[]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth1-1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth1-1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth1-1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth1-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth1-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth1-2
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${CLUSTERHEAD_2_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${CLUSTERHEAD_2_NAME} (i42)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth5
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=40000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth5
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth5
#                               ...  assign_ip=[]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth1-1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth1-1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth1-1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth1-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth1-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth1-2
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${SERVER_1_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${SERVER_1_NAME}*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp129s0
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_1_NAME}
#                               ...  interface_name=enp129s0
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp129s0
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp129s0d1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_1_NAME}
#                               ...  interface_name=enp129s0d1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp129s0d1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${SERVER_2_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${SERVER_2_NAME} (sv125)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp129s0
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_2_NAME}
#                               ...  interface_name=enp129s0
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp129s0
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp129s0d1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_2_NAME}
#                               ...  interface_name=enp129s0d1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp129s0d1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${SERVER_3_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${SERVER_3_NAME} (sv110)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=p3p1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=40000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_3_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_3_NAME}
#                               ...  interface_name=p3p1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=p3p1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=p3p2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=40000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_3_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_3_NAME}
#                               ...  interface_name=p3p2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=p3p2
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK

#
######### Uncommenting cleanup script for 212 nodes ###########
#
####################################################################################################################################
#Set Interfaces For ${CLUSTERHEAD_1_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${CLUSTERHEAD_1_NAME}(i43)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth6-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth6-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth6-2
#                               ...  assign_ip=[]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-2
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${CLUSTERHEAD_2_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${CLUSTERHEAD_2_NAME} (i42)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth6-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth6-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth6-2
#                               ...  assign_ip=[]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-2
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${SERVER_1_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${SERVER_1_NAME}*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${SERVER_2_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${SERVER_2_NAME} (sv125)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_2_NAME}
#                               ...  interface_name=enp130s0
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_2_NAME}
#                               ...  interface_name=enp130s0d1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${SERVER_3_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${SERVER_3_NAME} (sv110)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=ens2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_3_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_3_NAME}
#                               ...  interface_name=ens2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=ens2
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=ens2d1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_3_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_3_NAME}
#                               ...  interface_name=ens2d1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=ens2d1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK

