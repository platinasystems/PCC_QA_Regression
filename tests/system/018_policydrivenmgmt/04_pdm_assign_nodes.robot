*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC
###################################################################################################################################


        [Documentation]    *Login to PCC* test

        [Tags]    onlydelete
        ${status}        Login To PCC    ${pcc_setup}

                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         Load Server 3 Test Data    ${pcc_setup}

                         Load Node Groups Data    ${pcc_setup}

###################################################################################################################################
Apply location -rack on single node by using edit button: TCP-1403
###################################################################################################################################

        [Documentation]    *Apply location on single node by using edit button * test
                           ...  keywords:
                           ...  PCC.Update Node

        ${node_id}    PCC.Get Node Id
                      ...  Name=${SERVER_2_NAME}
                      Log To Console    ${node_id}

        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent1_Id}

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${parent1_Id}
                        Log To Console    ${parent2_Id}

        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${parent2_Id}

                        Log To Console    ${parent3_Id}

        ${scope_id}    PCC.Get Scope Id
                        ...  scope_name=rack-1
                        ...  parentID=${parent3_Id}

                        Log To Console    ${scope_id}

        ${response}    PCC.Update Node
                       ...  Id=${node_id}
                       ...  Name=${SERVER_2_NAME}
                       ...  Host=${SERVER_2_HOST_IP}
                       ...  scopeId=${scope_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Check if a scope cannot be deleted if it has nodes assigned:TCP-1396
###################################################################################################################################

        [Documentation]    *Check if a scope cannot be deleted if it has nodes assigned* test
                           ...  keywords:
                           ...  PCC.Delete Scope
        [Tags]    Only
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent1_Id}

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${parent1_Id}
                        Log To Console    ${parent2_Id}

        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${parent2_Id}

                        Log To Console    ${parent3_Id}


        ${response}    PCC.Delete Scope
                       ...  scope_name=rack-1
                       ...  parentID=${parent3_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200

        ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Apply location -site on single node by using edit button:TCP-1404
###################################################################################################################################

        [Documentation]    *Apply location -site on single node by using edit button * test
                           ...  keywords:
                           ...  PCC.Update Node
        [Tags]    Only
        ${node_id}    PCC.Get Node Id
                      ...  Name=${SERVER_2_NAME}
                      Log To Console    ${node_id}

        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent1_Id}

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${parent1_Id}
                        Log To Console    ${parent2_Id}

        ${scope_id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${parent2_Id}

                        Log To Console    ${scope_id}

        ${response}    PCC.Update Node
                       ...  Id=${node_id}
                       ...  Name=${SERVER_2_NAME}
                       ...  Host=${SERVER_2_HOST_IP}
                       ...  scopeId=${scope_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Apply location -zone on single node by using edit button:TCP-1405
###################################################################################################################################

        [Documentation]    *Apply location -zone on single node by using edit button * test
                           ...  keywords:
                           ...  PCC.Update Node
        [Tags]    Only
        ${node_id}    PCC.Get Node Id
                      ...  Name=${SERVER_2_NAME}
                      Log To Console    ${node_id}

        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent1_Id}

        ${scope_id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${parent1_Id}
                        Log To Console    ${scope_id}

        ${response}    PCC.Update Node
                       ...  Id=${node_id}
                       ...  Name=${SERVER_2_NAME}
                       ...  scopeId=${scope_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200

###################################################################################################################################
Apply location - region on single node by using edit button: TCP-1406
###################################################################################################################################

        [Documentation]    *Apply location - region on single node by using edit button * test
                           ...  keywords:
                           ...  PCC.Update Node
        [Tags]    Only
        ${node_id}    PCC.Get Node Id
                      ...  Name=${SERVER_2_NAME}
                      Log To Console    ${node_id}

        ${scope_id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${scope_id}

        ${response}    PCC.Update Node
                       ...  Id=${node_id}
                       ...  Name=${SERVER_2_NAME}
                       ...  scopeId=${scope_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200

###################################################################################################################################
Apply location on multiple nodes - considered region (Negative):TCP-1402
###################################################################################################################################

        [Documentation]    *Apply location on multiple nodes - considered region (Negative) * test
                           ...  keywords:
                           ...  PCC.Apply scope to multiple nodes
        [Tags]    Only
        ${scope_id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${scope_id}


        ${status}      PCC.Apply scope to multiple nodes
                       ...  node_names=['${SERVER_2_NAME}','${CLUSTERHEAD_1_NAME}']
                       ...  scopeId=${scope_id}

                       Log to Console    ${status}
                       Should Not Be Equal As Strings    ${status}    OK

###################################################################################################################################
Apply location on multiple nodes - considered zone (Negative):TCP-1401
###################################################################################################################################

        [Documentation]    *Apply location on multiple nodes - considered zone (Negative) * test
                           ...  keywords:
                           ...  PCC.Apply scope to multiple nodes
        [Tags]    Only
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent1_Id}

        ${scope_id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${parent1_Id}
                        Log To Console    ${scope_id}

        ${status}      PCC.Apply scope to multiple nodes
                       ...  node_names=['${SERVER_2_NAME}','${CLUSTERHEAD_1_NAME}']
                       ...  scopeId=${scope_id}

                       Log to Console    ${status}
                       Should Not Be Equal As Strings    ${status}    OK

###################################################################################################################################
Apply location on multiple nodes - considered site:TCP-1400
###################################################################################################################################

        [Documentation]    *Apply location on multiple nodes - considered site* test
                           ...  keywords:
                           ...  PCC.Apply scope to multiple nodes

        [Tags]    Only
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent1_Id}

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${parent1_Id}
                        Log To Console    ${parent2_Id}

        ${scope_id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${parent2_Id}

                        Log To Console    ${scope_id}

        ${status}      PCC.Apply scope to multiple nodes
                       ...  node_names=['${SERVER_2_NAME}','${CLUSTERHEAD_1_NAME}']
                       ...  scopeId=${scope_id}

                       Log to Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

        ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Apply location on multiple nodes - considered rack:TCP-1399
###################################################################################################################################

        [Documentation]    *Apply location on multiple nodes - considered rack* test
                           ...  keywords:
                           ...  PCC.Update Node
        [Tags]    Only
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent1_Id}

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${parent1_Id}
                        Log To Console    ${parent2_Id}

        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${parent2_Id}

                        Log To Console    ${parent3_Id}

        ${scope_id}    PCC.Get Scope Id
                        ...  scope_name=rack-1
                        ...  parentID=${parent3_Id}

                        Log To Console    ${scope_id}

        ${status}      PCC.Apply scope to multiple nodes
                       ...  node_names=['${SERVER_2_NAME}','${CLUSTERHEAD_1_NAME}']
                       ...  scopeId=${scope_id}

                       Log to Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

        ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Re-assign default location to multiple nodes:TCP-1431
###################################################################################################################################

        [Documentation]    *Re-assign default location to multiple nodes* test
                           ...  keywords:
                           ...  PCC.Apply scope to multiple nodes
        [Tags]    Only
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=Default region
                        Log To Console    ${parent1_Id}

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=Default zone
                        ...  parentID=${parent1_Id}
                        Log To Console    ${parent2_Id}

        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=Default site
                        ...  parentID=${parent2_Id}

                        Log To Console    ${parent3_Id}

        ${scope_id}    PCC.Get Scope Id
                        ...  scope_name=Default rack
                        ...  parentID=${parent3_Id}

                        Log To Console    ${scope_id}

        ${status}      PCC.Apply scope to multiple nodes
                       ...  node_names=['${SERVER_2_NAME}','${SERVER_1_NAME}','${SERVER_3_NAME}','${CLUSTERHEAD_1_NAME}','${CLUSTERHEAD_2_NAME}']
                       ...  scopeId=${scope_id}

                       Log to Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

        ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Check if a rack can be deleted if it does not have nodes assigned:TCP-1392
###################################################################################################################################

        [Documentation]    *Check if a rack can be deleted if it does not have nodes assigned* test
                           ...  keywords:
                           ...  PCC.Delete Scope

        [Tags]    delete
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent1_Id}

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${parent1_Id}
                        Log To Console    ${parent2_Id}

        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${parent2_Id}

                        Log To Console    ${parent3_Id}


        ${response}    PCC.Delete Scope
                       ...  scope_name=rack-1
                       ...  parentID=${parent3_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Check if a site can be deleted if its child rack does not have nodes assigned:TCP-1393
###################################################################################################################################

        [Documentation]    *Check if a site can be deleted if its child rack does not have nodes assigned* test
                           ...  keywords:
                           ...  PCC.Delete Scope
        [Tags]    delete
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent1_Id}

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${parent1_Id}
                        Log To Console    ${parent2_Id}

        ${response}    PCC.Delete Scope
                       ...  scope_name=site-1
                       ...  parentID=${parent2_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Check if a zone can be deleted if its child rack does not have nodes assigned:TCP-1394
###################################################################################################################################

        [Documentation]    *Check if a zone can be deleted if its child rack does not have nodes assigned* test
                           ...  keywords:
                           ...  PCC.Delete Scope
        [Tags]    delete
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent1_Id}


        ${response1}    PCC.Delete Scope
                       ...  scope_name=zone-2
                       ...  parentID=${parent1_Id}

                       Log To Console    ${response1}
                       ${result}    Get Result    ${response1}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Delete default zone under default region:TCP-1757
###################################################################################################################################

        [Documentation]    *Check if a zone can be deleted if its child rack does not have nodes assigned* test
                           ...  keywords:
                           ...  PCC.Delete Scope
        [Tags]    delete
        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=Default region
                        Log To Console    ${parent2_Id}


        ${response2}    PCC.Delete Scope
                       ...  scope_name=zone-un-default-region
                       ...  parentID=${parent2_Id}

                       Log To Console    ${response2}
                       ${result}    Get Result    ${response2}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK
###################################################################################################################################
Check if a region can be deleted if its child rack does not have nodes assigned:TCP-1395
###################################################################################################################################

        [Documentation]    *Check if a region can be deleted if its child rack does not have nodes assigned* test
                           ...  keywords:
                           ...  PCC.Delete Scope
        [Tags]    delete
        ${response}    PCC.Delete Scope
                       ...  scope_name=region-1

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

####################################################################################################################################
#Delete All Node Roles:TCP-1756
####################################################################################################################################
#
#        [Documentation]    *Delete All Node Roles* test
#                           ...  keywords:
#                           ...  PCC.Delete all Node roles
#        [Tags]    onlydelete
#
#        ${status}    PCC.Delete all Node roles
#
#                     Log To Console    ${status}
#                     Should Be Equal As Strings    ${status}    OK    Node role still exists
#
####################################################################################################################################
#Unassign Locations Assigned from All Policies:TCP-1443
####################################################################################################################################
#
#        [Documentation]    *Unassign Locations Assigned from All Policies* test
#                           ...  keywords:
#                           ...  PCC.Unassign Locations Assigned from All Policies
#
#
#        ${status}    PCC.Unassign Locations Assigned from All Policies
#
#                     Log To Console    ${status}
#                     Should Be Equal As Strings    ${status}    OK
#
####################################################################################################################################
#Delete All Policies:TCP-1443
####################################################################################################################################
#
#        [Documentation]    *Delete All Policies* test
#                           ...  keywords:
#                           ...  PCC.Delete All Policies
#
#
#        ${status}    PCC.Delete All Policies
#
#                     Log To Console    ${status}
#                     Should Be Equal As Strings    ${status}    OK


