*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC 
###################################################################################################################################
                
        
        [Documentation]    *Login to PCC* test
        [Tags]    Only
        
       
        ${status}        Login To PCC    ${pcc_setup}
                         
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         
                         Load Node Groups Data    ${pcc_setup}
                         Load Tenant Data    ${pcc_setup}
                         Load Node Roles Data    ${pcc_setup}
                         
                         
###################################################################################################################################
Create node role with DNS client application:TCP-1428
###################################################################################################################################

        [Documentation]    *Create node role with DNS client application* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role
        
        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id}    PCC.Get Template Id    Name=DNS
                          Log To Console    ${template_id}
                             
        ${response}    PCC.Add Node Role
                       ...    Name=DNS_NODE_ROLE
                       ...    Description=DNS_NR_DESC
                       ...    templateIDs=[${template_id}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
                       Sleep    2s
                       
        ${status}    PCC.Validate Node Role
                     ...    Name=DNS_NODE_ROLE
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists
                     
###################################################################################################################################
Create node role with NTP client application:TCP-1429
###################################################################################################################################

        [Documentation]    *Create node role with NTP client application* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role
        
        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}

        ${template_id}    PCC.Get Template Id    Name=NTP
                          Log To Console    ${template_id}

        ${response}    PCC.Add Node Role
                       ...    Name=NTP_NODE_ROLE
                       ...    Description=NTP_NR_DESC
                       ...    templateIDs=[${template_id}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                       Sleep    2s

        ${status}    PCC.Validate Node Role
                     ...    Name=NTP_NODE_ROLE

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists
                     
###################################################################################################################################
Create node role with SNMPv2 client application:TCP-1430
###################################################################################################################################

        [Documentation]    *Create node role with SNMPv2 client application* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role
        
        
        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id}    PCC.Get Template Id    Name=SNMP
                          Log To Console    ${template_id}
                             
        ${response}    PCC.Add Node Role
                       ...    Name=SNMPv2_NODE_ROLE
                       ...    Description=SNMPv2_NR_DESC
                       ...    templateIDs=[${template_id}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
                       Sleep    2s
                       
        ${status}    PCC.Validate Node Role
                     ...    Name=SNMPv2_NODE_ROLE
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists
                     
###################################################################################################################################
Associate DNS, NTP, SNMPv2 client node role with a node:TCP-1428, TCP-1429, TCP-1430
###################################################################################################################################
    [Documentation]                 *Associate DNS, NTP, SNMPv2 client node role with a node*
                               ...  Keywords:
                               ...  PCC.Add and Verify Roles On Nodes
                               ...  PCC.Wait Until Roles Ready On Nodes
        
        [Tags]    Only
        ${response}                 PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${CLUSTERHEAD_1_NAME}","${SERVER_2_NAME}"]
                               ...  roles=["DNS_NODE_ROLE", "SNMPv2_NODE_ROLE","NTP_NODE_ROLE"]
                                    
                                    Should Be Equal As Strings      ${response}  OK

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${CLUSTERHEAD_1_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                                    
        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                                      
###################################################################################################################################
Filter all policy-enabled apps:TCP-1759
###################################################################################################################################

        [Documentation]    *Filter all policy-enabled apps* test
                           ...  keywords:
                           ...  PCC.Get Policy Enabled Apps
        
        [Tags]    Only
        ${response}    PCC.Get Policy Enabled Apps
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Removing Node Roles From Nodes:TCP-1758
###################################################################################################################################
    [Documentation]                 *Removing Node Roles From Nodes*
                               ...  Keywords:
                               ...  PCC.Delete and Verify Roles On Nodes
                               ...  PCC.Wait Until Roles Ready On Nodes
        [Tags]    Only                       
        ${response}                 PCC.Delete and Verify Roles On Nodes
                               ...  nodes=["${CLUSTERHEAD_1_NAME}","${SERVER_2_NAME}"]
                               ...  roles=["DNS_NODE_ROLE", "SNMPv2_NODE_ROLE","NTP_NODE_ROLE"]

                                    Should Be Equal As Strings      ${response}  OK


        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${CLUSTERHEAD_1_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                                    
        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        
                                    
                                    
      
