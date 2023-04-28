*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Keywords ***

*** Test Cases ***
###################################################################################################################################
Load Test Variable
###############################################################################################################

                        Load PCC Test Data        ${pcc_setup}
                        Load Ceph Rgw Data    ${pcc_setup}
                        Load Ceph Cluster Data  ${pcc_setup}
                        Load Ceph Rgw Data Secondary   ${pcc_setup}
                        Load Ceph Cluster Data Secondary  ${pcc_setup}
                        Load Ceph Pool Data    ${pcc_setup}
                        Load Server 1 Test Data    ${pcc_setup}
                        Load Server 1 Secondary Test Data    ${pcc_setup}
                        Load Server 2 Test Data    ${pcc_setup}
                        Load Server 4 Secondary Test Data    ${pcc_setup}
                        Load Server 5 Secondary Test Data    ${pcc_setup}
                        Load Ceph Rgw Data Secondary    ${pcc_setup}
					    Load Ceph Pool Data Secondary   ${pcc_setup}
                        Load Ceph Cluster Data Secondary   ${pcc_setup}


        ${status}                   Login To PCC Secondary   ${pcc_setup}

####################################################################################################################################
#Node Dismiss
####################################################################################################################################
#    [Documentation]                 *Node Dismiss*
#
#    ${server_id}                  PCC.Get Node Id    Name=${SERVER_4_NAME_SECONDARY}
#
#
#    ${response}                    PCC.Node Dismiss
#                              ...  Id=${server_id}
#                              ...  force=${true}
#
#                                   ${result}    Get Result    ${response}
#                                   ${message}   Get Response Message        ${response}
#                                   ${status}    Get From Dictionary    ${result}    status
#                                   ${data}    Get From Dictionary    ${result}    Data
#                                   ${services}    Get From Dictionary    ${data}    details
#                                   Should Be Equal As Strings    ${status}    200
#
#                                   Log To Console    ${services}

                                   PCC.Verify Node Dismiss
                              ...  hostip=${SERVER_5_HOST_IP_SECONDARY}
                             # ...  services=${services}



####################################################################################################################################
#Verify Node dismiss
####################################################################################################################################
#    [Documentation]                 *Verify Node dismiss*
#
#    ${server_id}                  PCC.Get Node Id    Name=${SERVER_4_NAME_SECONDARY}
#
#
#    ${response}                    PCC.Node dismiss
#                              ...  Id=${server_id}
#                              ...  force=${true}
#
#                                   ${result}    Get Result    ${response}
#                                   ${message}   Get Response Message        ${response}
#                                   ${status}    Get From Dictionary    ${result}    status
#                                   Should Be Equal As Strings    ${status}    200
#
#
####################################################################################################################################
#BE Ceph Cleanup 2
####################################################################################################################################
#
#        ${status}                   PCC.Ceph Cleanup BE 2
#                               ...  nodes_ip=['${SERVER_4_HOST_IP_SECONDARY}']
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#
#                                    Should be equal as strings    ${status}    OK

####################################################################################################################################
#Ceph Cluster Update - Add Server
#####################################################################################################################################
#    [Documentation]                 *Ceph Cluster Update - Add Server*
#
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#
#        ${id}                       PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#
#        ${response}                 PCC.Ceph Cluster Update
#                               ...  id=${id}
#                               ...  nodes=${CEPH_CLUSTER_NODES_SECONDARY}
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK_SECONDARY}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${message}                  Get Response Message        ${response}
#
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Ceph Verify BE
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK