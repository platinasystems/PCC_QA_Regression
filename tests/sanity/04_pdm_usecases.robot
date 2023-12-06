*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC
###################################################################################################################################


        [Documentation]    *Login to PCC* test

        ${status}        Login To PCC    ${pcc_setup}

                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         Load Network Manager Data    ${pcc_setup}
                         Load Tenant Data    ${pcc_setup}
                         Load Node Roles Data    ${pcc_setup}
                         Load Ceph Rgw Data    ${pcc_setup}

###################################################################################################################################
GET scoping object types: TCP-1361
###################################################################################################################################

        [Documentation]    *GET scoping object types* test
                           ...  keywords:
                           ...  PCC.Get Scope Types

        ${response}    PCC.Get Scope Types

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Create scoping object - Region:TCP-1362
###################################################################################################################################

        [Documentation]    *Create scoping object - Region* test
                           ...  keywords:
                           ...  PCC.Create Scope

        ${response}    PCC.Create Scope
                       ...  type=region
                       ...  scope_name=region-1
                       ...  description=region-description


                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=region-1

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Create scoping object - Zone:TCP-1363
###################################################################################################################################

        [Documentation]    *Create scoping object - Region* test
                           ...  keywords:
                           ...  PCC.Create Scope

        ${parent_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent_Id}

        ${response}    PCC.Create Scope
                       ...  type=zone
                       ...  scope_name=zone-1
                       ...  description=zone-description
                       ...  parentID=${parent_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=zone-1

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Create scoping object - Site:TCP-1364
###################################################################################################################################

        [Documentation]    *Create scoping object - Site* test
                           ...  keywords:
                           ...  PCC.Create Scope

        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${parent1_Id}

                        Log To Console    ${parent2_Id}

        ${response}    PCC.Create Scope
                       ...  type=site
                       ...  scope_name=site-1
                       ...  description=site-description
                       ...  parentID=${parent2_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=site-1

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Create scoping object - Rack:TCP-1365
###################################################################################################################################

        [Documentation]    *Create scoping object - Rack* test
                           ...  keywords:
                           ...  PCC.Create Scope

        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${parent1_Id}

        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${parent2_Id}

                        Log To Console    ${parent3_Id}

        ${response}    PCC.Create Scope
                       ...  type=rack
                       ...  scope_name=rack-1
                       ...  description=rack-description
                       ...  parentID=${parent3_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=rack-1

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

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
                        ...  scope_name=zone-1
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
Create a trusted ca policy
###################################################################################################################################

        [Documentation]    *Create a policy* test
                           ...  keywords:
                           ...  PCC.Create Policy

        ${cert_id}       PCC.Get Certificate Id
                         ...  Alias=${CEPH_RGW_CERT_NAME}
                         Log To Console    ${cert_id}

        ${app_id}        PCC.Get App Id from Policies
                         ...  Name=TRUSTED-CA-CERTIFICATE
                         Log To Console    ${app_id}

        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1

        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=zone-1
                         ...  parentID=${parent1_id}

        ${parent2_id}    PCC.Get Scope Id
                         ...  scope_name=site-1
                         ...  parentID=${scope1_id}

        ${scope2_id}     PCC.Get Scope Id
                         ...  scope_name=rack-1
                         ...  parentID=${parent2_id}

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=trust-ca-policy
                       ...  inputs=[{"name": "ca_certificate_list","value": "${cert_id}"}]
                       ...  scopeIds=[${scope2_id}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Create trusted ca node role
###################################################################################################################################

        [Documentation]    *Create node role with DNS client application* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role

        ${owner}       PCC.Get Tenant Id       Name=ROOT

        ${template_id}    PCC.Get Template Id    Name=TRUSTED-CA-CERTIFICATE
                          Log To Console    ${template_id}

        ${response}    PCC.Add Node Role
                       ...    Name=trusted-ca-certificate
                       ...    Description=trusted-ca-certificate
                       ...    templateIDs=[${template_id}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Associate trusted ca certificate node role
###################################################################################################################################
    [Documentation]                 *Associate trusted ca certificate client node role to all ceph nodes*
                               ...  Keywords:
                               ...  PCC.Add and Verify Roles On Nodes
                               ...  PCC.Wait Until Roles Ready On Nodes

        ${response}                 PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${SERVER_2_NAME}"]
                               ...  roles=["trusted-ca-certificate"]

                                    Should Be Equal As Strings      ${response}  OK

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

###################################################################################################################################
Verify Scope Policy Backend
###################################################################################################################################
    [Documentation]                 *Verify Scope Policy Backend*

    ${result}                PCC.Verify Certificate On Node
                        ...  ip=${SERVER_2_HOST_IP}
                        ...  Alias=rgw-crt

                             Should Be Equal As Strings    ${result}    OK

###################################################################################################################################
Re-assign default location to multiple nodes:TCP-1431
###################################################################################################################################

        [Documentation]    *Re-assign default location to multiple nodes* test
                           ...  keywords:
                           ...  PCC.Apply scope to multiple nodes

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
                       ...  node_names=['${SERVER_2_NAME}']
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


        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent1_Id}

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
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
                        ...  scope_name=zone-1
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
                       ...  scope_name=zone-1
                       ...  parentID=${parent1_Id}

                       Log To Console    ${response1}
                       ${result}    Get Result    ${response1}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200


###################################################################################################################################
Check if a region can be deleted if its child rack does not have nodes assigned:TCP-1395
###################################################################################################################################

        [Documentation]    *Check if a region can be deleted if its child rack does not have nodes assigned* test
                           ...  keywords:
                           ...  PCC.Delete Scope

        ${response}    PCC.Delete Scope
                       ...  scope_name=region-1

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
