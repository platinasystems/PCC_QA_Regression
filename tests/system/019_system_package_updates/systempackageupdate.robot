#*** Settings ***
#Resource    pcc_resources.robot
#
#*** Variables ***
#${pcc_setup}                 pcc_218
#
#*** Test Cases ***
####################################################################################################################################
#Login
####################################################################################################################################
#      [Tags]    Only
#                                    Load Ipam Data    ${pcc_setup}
#                                    Load Ceph Rbd Data    ${pcc_setup}
#                                    Load Ceph Pool Data    ${pcc_setup}
#                                    Load Ceph Cluster Data    ${pcc_setup}
#                                    Load Clusterhead 1 Test Data    ${pcc_setup}
#                                    Load Clusterhead 2 Test Data    ${pcc_setup}
#                                    Load Server 1 Test Data    ${pcc_setup}
#                                    Load Server 2 Test Data    ${pcc_setup}
#                                    Load Network Manager Data    ${pcc_setup}
#
#        ${status}                   Login To PCC        testdata_key=${pcc_setup}
#                                    Should Be Equal     ${status}  OK
#
####################################################################################################################################
#Check if PCC have a new entry under the applications list to represent the packages (TCP-1576,1577,1578,1580,1581)
####################################################################################################################################
#
#
#        ${status}                   PCC.Validate Applications Present on PCC
#                               ...  app_list=["OS Packages Repository","Docker Community Package Repository","Ceph Community Package Repository","FRRouting Community Package Repository","Platina Systems Packages"]
#
#                               Log To Console   ${status}
#                               Should Be Equal As Strings    ${status}    OK
#
####################################################################################################################################
#Check if PCC define default node role for the following to include Platina Systems Package Repository (TCP-1582,1583,1584,1585)
####################################################################################################################################
#
#        ## Check for Cluster Head node role
#        ${status}          PCC.Validate Node Role
#                           ...    Name=Cluster Head
#
#                           Log To Console   ${status}
#                           Should Be Equal As Strings    ${status}    OK
#
#        ## Check for Ceph Resource node role
#        ${status}          PCC.Validate Node Role
#                           ...    Name=Ceph Resource
#
#                           Log To Console   ${status}
#                           Should Be Equal As Strings    ${status}    OK
#
#        ## Check for Kubernetes Resource node role
#        ${status}          PCC.Validate Node Role
#                           ...    Name=Kubernetes Resource
#
#                           Log To Console   ${status}
#                           Should Be Equal As Strings    ${status}    OK
#
#        ## Check for Network Resource node role
#        ${status}          PCC.Validate Node Role
#                           ...    Name=Network Resource
#
#                           Log To Console   ${status}
#                           Should Be Equal As Strings    ${status}    OK
#
#
######################################################################################################################################
#Check if PCC assign the Default node role to the node when a node is added to PCC (TCP-1586)
######################################################################################################################################
#
#        [Documentation]    *Check if PCC assign the Default node role to the node when a node is added to PCC* test
#        [Tags]    Only
#        ###### Deleting the node #####
#        ${network_id}              PCC.Get Network Manager Id
#                              ...  name=${NETWORK_MANAGER_NAME}
#                                   Pass Execution If    ${network_id} is not ${None}    Network Cluster is Present Deleting Aborted
#
#        ${status}                  PCC.Delete mutliple nodes and wait until deletion
#                              ...  Names=['${SERVER_1_NAME}']
#
#                                   Log To Console    ${status}
#                                   Should be equal as strings    ${status}    OK
#
#        ######  Adding Node  ######
#        ${add_node_response}    PCC.Add Node
#                                ...    Host=${SERVER_1_HOST_IP}
#
#                                Log To Console    ${add_node_response}
#                                ${result}    Get Result    ${add_node_response}
#                                ${status}    Get From Dictionary    ${result}    status
#                                ${message}    Get From Dictionary    ${result}    message
#                                Log to Console    ${message}
#                                Should Be Equal As Strings    ${status}    200
#
#                                Sleep    2s
#
#        ${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${SERVER_1_NAME}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK
#
#        ${status}    PCC.Verify Node Role On Nodes
#                     ...    Name=Default
#                     ...    nodes=["${SERVER_1_NAME}"]
#
#                     Log To Console    ${status}
#                     Should Be Equal As Strings    ${status}    OK
#
#
#################################################################################################################################################################
#Check if user is able to assign the Cluster Head, CEPH resource, Kubernetes resource, Network resource node role to the cluster head(TCP-1587, 1660, 1661, 1662)
#################################################################################################################################################################
#    [Documentation]                 *Check if user is able to assign the Cluster Head node role to the cluster head*
#                               ...  Keywords:
#                               ...  PCC.Add and Verify Roles On Nodes
#                               ...  PCC.Wait Until Roles Ready On Nodes
#
#
#        ${response}                 PCC.Add and Verify Roles On Nodes
#                               ...  nodes=["${CLUSTERHEAD_1_NAME}"]
#                               ...  roles=["Cluster Head", "Ceph Resource", "Kubernetes Resource", "Network Resource"]
#
#                                    Should Be Equal As Strings      ${response}  OK
#
#        ${status_code}              PCC.Wait Until Roles Ready On Nodes
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#
#                                    Should Be Equal As Strings      ${status_code}  OK
#
