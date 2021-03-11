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
				    Sleep    180s

###################################################################################################################################
Nodes Verification Back End (Services should be running and active)
###################################################################################################################################
    [Documentation]                      *Nodes Verification Back End*
                                    ...  keywords:
                                    ...  PCC.Node Verify Back End


    [Tags]        backend

        ${status}                   PCC.Node Verify Back End
                                    ...  host_ips=["${SERVER_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                                    Log To Console    ${status}
                                    Run Keyword If  "${status}" != "OK"  Fatal Error
				    Should Be Equal As Strings      ${status}    OK


        ${status}                   PCC.Verify LLDP Neighbors
                             ...    servers_hostip=['${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}']
                             ...    invaders_hostip=['${CLUSTERHEAD_1_HOST_IP}','${CLUSTERHEAD_2_HOST_IP}']

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.OS Package repository
                             ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
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

        ${status}                   CLI.Automatic Upgrades Validation
                             ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    Automatic upgrades set to Yes from backend

        ${status}                   PCC.Check NTP services from backend
                              ...   targetNodeIp=['${SERVER_2_HOST_IP}','${SERVER_1_HOST_IP}','${CLUSTERHEAD_1_HOST_IP}','${CLUSTERHEAD_2_HOST_IP}']

                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK


        ${status}                   CLI.Validate Ethtool
                             ...    host_ips=['${CLUSTERHEAD_1_HOST_IP}','${CLUSTERHEAD_2_HOST_IP}','${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}']
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

