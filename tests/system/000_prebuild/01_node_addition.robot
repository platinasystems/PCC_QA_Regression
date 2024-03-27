*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Clusterhead 1 Test Data        ${pcc_setup}
                                    Load Server 1 Test Data        ${pcc_setup}
                                    Load Server 2 Test Data        ${pcc_setup}
                                    Load Server 3 Test Data        ${pcc_setup}
                                    
        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK
                                    
#####################################################################################################################################
Add Nodes
#####################################################################################################################################

    [Documentation]                 *Add Nodes Test*                 
    
    ${status}                       PCC.Add multiple nodes and check online
                                    ...  host_ips=['${CLUSTERHEAD_1_HOST_IP}','${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}','${SERVER_3_HOST_IP}']
                                    ...  Names=['${CLUSTERHEAD_1_NAME}','${SERVER_1_NAME}','${SERVER_2_NAME}','${SERVER_3_NAME}']

                                    Log To Console    ${status}
                                    Should be equal as strings    ${status}    OK
#                                    Sleep    180s

####################################################################################################################################
#Nodes Verification Back End (Services should be running and active)
####################################################################################################################################
#    [Documentation]                      *Nodes Verification Back End*
#                                    ...  keywords:
#                                    ...  PCC.Node Verify Back End
#
#        ${status}                   PCC.Node Verify Back End
#                                    ...  host_ips=["${SERVER_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
#                                    Log To Console    ${status}
#                                    Run Keyword If  "${status}" != "OK"  Fatal Error
#                                    Should Be Equal As Strings      ${status}    OK


####################################################################################################################################
#Login To PCC Secondary
####################################################################################################################################
#
#                                    Load Clusterhead 1 Secondary Test Data        ${pcc_setup}
#                                    Load Clusterhead 2 Secondary Test Data        ${pcc_setup}
#
#                                    Load Server 1 Secondary Test Data        ${pcc_setup}
#                                    Load Server 2 Secondary Test Data        ${pcc_setup}
#                                    Load Server 3 Secondary Test Data        ${pcc_setup}
#                                    Load Server 4 Secondary Test Data        ${pcc_setup}
#                                    Load Server 5 Secondary Test Data        ${pcc_setup}
#                                    Load Server 6 Secondary Test Data        ${pcc_setup}
#
#        ${status}                   Login To PCC Secondary        testdata_key=${pcc_setup}
#                                    Should Be Equal     ${status}  OK
#
######################################################################################################################################
#Add Nodes
######################################################################################################################################
#
#    [Documentation]                 *Add Nodes Test*
#
#    ${status}                       PCC.Add multiple nodes and check online
#                                    ...  host_ips=['${CLUSTERHEAD_1_HOST_IP_SECONDARY}', '${CLUSTERHEAD_2_HOST_IP_SECONDARY}', '${SERVER_1_HOST_IP_SECONDARY}','${SERVER_2_HOST_IP_SECONDARY}','${SERVER_3_HOST_IP_SECONDARY}','${SERVER_4_HOST_IP_SECONDARY}','${SERVER_5_HOST_IP_SECONDARY}','${SERVER_6_HOST_IP_SECONDARY}']
#                                    ...  Names=['${CLUSTERHEAD_1_NAME_SECONDARY}', '${CLUSTERHEAD_2_NAME_SECONDARY}', '${SERVER_1_NAME_SECONDARY}','${SERVER_2_NAME_SECONDARY}','${SERVER_3_NAME_SECONDARY}','${SERVER_4_NAME_SECONDARY}','${SERVER_5_NAME_SECONDARY}','${SERVER_6_NAME_SECONDARY}']
#
#                                    Log To Console    ${status}
#                                    Should be equal as strings    ${status}    OK
##                                    Sleep    180s

####################################################################################################################################
#Nodes Verification Back End (Services should be running and active)
####################################################################################################################################
#    [Documentation]                      *Nodes Verification Back End*
#                                    ...  keywords:
#                                    ...  PCC.Node Verify Back End
#
#        ${status}                   PCC.Node Verify Back End
#                                    ...  host_ips=['${CLUSTERHEAD_1_HOST_IP_SECONDARY}', '${CLUSTERHEAD_2_HOST_IP_SECONDARY}', '${SERVER_1_HOST_IP_SECONDARY}','${SERVER_2_HOST_IP_SECONDARY}','${SERVER_3_HOST_IP_SECONDARY}','${SERVER_4_HOST_IP_SECONDARY}','${SERVER_5_HOST_IP_SECONDARY}','${SERVER_6_HOST_IP_SECONDARY}']
#                                    Log To Console    ${status}
#                                    Run Keyword If  "${status}" != "OK"  Fatal Error
#				                    Should Be Equal As Strings      ${status}    OK

