*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_242

*** Test Cases ***
###################################################################################################################################
Login to PCC 
###################################################################################################################################
                
        
        [Documentation]    *Login to PCC* test
        [Tags]    Delete
        
        ${status}        Login To PCC    ${pcc_setup}
                         
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         Load Tenant Data    ${pcc_setup}
                         Load Node Roles Data    ${pcc_setup}
                         
        ${server1_id}    PCC.Get Node Id    Name=${SERVER_1_NAME}
                         Log To Console    ${server1_id}
                         Set Global Variable    ${server1_id}
                         
        ${server2_id}    PCC.Get Node Id    Name=${SERVER_2_NAME}
                         Log To Console    ${server2_id}
                         Set Global Variable    ${server2_id}
                         
        ${invader1_id}    PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
                         Log To Console    ${invader1_id}
                         Set Global Variable    ${invader1_id}
                         
                         
###################################################################################################################################
PCC Node Roles - Verify if user can access node roles
###################################################################################################################################

        [Documentation]    *PCC Node Roles - Verify if user can access node roles* test
                           ...  keywords:
                           ...  PCC.Get Node Roles
                           
                           
                           
        ${response}    PCC.Get Node Roles
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
PCC Node Role Creation
###################################################################################################################################

        [Documentation]    *PCC Node Role Creation* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id}    PCC.Get Template Id    Name=${APP_1}
                             
        ${response}    PCC.Add Node Role
                       ...    Name=${NODE_ROLE_1}
                       ...    Description=${NODE_ROLE_DESC_1}
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
                     ...    Name=${NODE_ROLE_1}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists
                       
###################################################################################################################################
PCC Node Role Creation Without Name (Negative)
###################################################################################################################################

        [Documentation]    *PCC Node Role Creation Without Name* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id}    PCC.Get Template Id    Name=${APP_1}
                             
        ${response}    PCC.Add Node Role
                       ...    Name=''
                       ...    Description=${NODE_ROLE_DESC_1}
                       ...    templateIDs=[${template_id}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
PCC Node Role Creation Without Description
###################################################################################################################################

        [Documentation]    *PCC Node Role Creation Without Description* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id}    PCC.Get Template Id    Name=${APP_1}
                             
        ${response}    PCC.Add Node Role
                       ...    Name=${NODE_ROLE_2}
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
                     ...    Name=${NODE_ROLE_2}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists
                     
###################################################################################################################################
PCC Node Role Creation Without Application
###################################################################################################################################

        [Documentation]    *PCC Node Role Creation Without Application* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
                             
        ${response}    PCC.Add Node Role
                       ...    Name=${NODE_ROLE_3}
                       ...    Description=${NODE_ROLE_DESC_3}
                       ...    templateIDs=[]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
                       Sleep    2s
                       
        ${status}    PCC.Validate Node Role
                     ...    Name=${NODE_ROLE_3}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists
                     
###################################################################################################################################
PCC Node Role Creation Without Tenant
###################################################################################################################################

        [Documentation]    *PCC Node Role Creation Without Tenant* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id}    PCC.Get Template Id    Name=${APP_2}                     
        
        ${response}    PCC.Add Node Role
                       ...    Name=${NODE_ROLE_4}
                       ...    Description=${NODE_ROLE_DESC_4}
                       ...    templateIDs=[${template_id}]
                       ...    owners=[]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
                       Sleep    2s
                       
        ${status}    PCC.Validate Node Role
                     ...    Name=${NODE_ROLE_4}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists
                     
###################################################################################################################################
PCC Node Role Creation With All Fields Empty (Negative)
###################################################################################################################################

        [Documentation]    *PCC Node Role Creation With All Fields Empty* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id}    PCC.Get Template Id    Name=${APP_2}                     
        
        ${response}    PCC.Add Node Role
                       ...    Name=''
                       ...    templateIDs=[]
                       ...    owners=[]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
PCC Edit Node Role
###################################################################################################################################

        [Documentation]    *PCC Edit Node Role* test
                           ...  keywords:
                           ...  PCC.Modify Node Role
                           ...  PCC.Validate Node Role

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id}    PCC.Get Template Id    Name=${APP_1} 
        
        ${node_role_id}    PCC.Get Node Role Id    Name=${NODE_ROLE_4}
                            
        
        ${response}    PCC.Modify Node Role
                       ...    Id=${node_role_id}
                       ...    Name=${NODE_ROLE_5}
                       ...    Description=${NODE_ROLE_DESC_5}
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
                     ...    Name=${NODE_ROLE_5}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists
                     
###################################################################################################################################
Create Duplicate Node(Negative)
###################################################################################################################################

        [Documentation]    *Create Duplicate Node* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id}    PCC.Get Template Id    Name=${APP_1}
                             
        ${response}    PCC.Add Node Role
                       ...    Name=${NODE_ROLE_1}
                       ...    Description=${NODE_ROLE_DESC_1}
                       ...    templateIDs=[${template_id}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Clear Existing Node Role Description 
###################################################################################################################################

        [Documentation]    *Clear Existing Node Role Description* test
                           ...  keywords:
                           ...  PCC.Modify Node Role
                           ...  PCC.Validate Node Role

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id}    PCC.Get Template Id    Name=${APP_1} 
        
        ${node_role_id}    PCC.Get Node Role Id    Name=${NODE_ROLE_5}
                            
        
        ${response}    PCC.Modify Node Role
                       ...    Id=${node_role_id}
                       ...    Name=${NODE_ROLE_5}
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
                     ...    Name=${NODE_ROLE_5}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists
                       
###################################################################################################################################
PCC Node Role Creation With Space Only
###################################################################################################################################

        [Documentation]    *PCC Node Role Creation With Space Only* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                          

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id}    PCC.Get Template Id    Name=${APP_2}
                             
        ${response}    PCC.Add Node Role
                       ...    Name=${NODE_ROLE_7}
                       ...    Description=${NODE_ROLE_DESC_7}
                       ...    templateIDs=[${template_id}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       

###################################################################################################################################
PCC Node Role Creation With name Containing Special Characters Only
###################################################################################################################################

        [Documentation]    *PCC Node Role Creation With name Containing Special Characters Only* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id}    PCC.Get Template Id    Name=${APP_2}
                             
        ${response}    PCC.Add Node Role
                       ...    Name=${NODE_ROLE_6}
                       ...    Description=${NODE_ROLE_DESC_6}
                       ...    templateIDs=[${template_id}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
PCC Node Role Creation With Name Containing Numbers Only
###################################################################################################################################

        [Documentation]    *PCC Node Role Creation With Name Containing Numbers Only* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id}    PCC.Get Template Id    Name=${APP_1}
                             
        ${response}    PCC.Add Node Role
                       ...    Name=${NODE_ROLE_8}
                       ...    Description=${NODE_ROLE_DESC_8}
                       ...    templateIDs=[${template_id}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200                                          

###################################################################################################################################
PCC Node Role Creation with More Than One App
###################################################################################################################################

        [Documentation]    *PCC Node Role Creation with More Than One App* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id_1}    PCC.Get Template Id    Name=${APP_1}
        ${template_id_2}    PCC.Get Template Id    Name=${APP_2}
                             
        ${response}    PCC.Add Node Role
                       ...    Name=${NODE_ROLE_9}
                       ...    Description=${NODE_ROLE_DESC_9}
                       ...    templateIDs=[${template_id_1},${template_id_2}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
                       Sleep    2s
                       
        ${status}    PCC.Validate Node Role
                     ...    Name=${NODE_ROLE_9}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists
                     
###################################################################################################################################
PCC Node role deletion
###################################################################################################################################

        [Documentation]    *PCC Node role deletion* test
                           ...  keywords:
                           ...  PCC.Delete Node Role
                           ...  PCC.Get Node Group Id
                           ...  PCC.Validate Node Group 
        
        #[Tags]    Delete
                           
        ${response}    PCC.Delete Node Role
                       ...    Name=${NODE_ROLE_9}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
                       Sleep    2s
                       
        ${status}    PCC.Validate Node Role
                     ...    Name=${NODE_ROLE_9}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    Node role not available    Node role not deleted 
                     
###################################################################################################################################
Create 100 node roles
###################################################################################################################################

        [Documentation]    *Create 100 node roles* test
                           ...  keywords:
                           ...  PCC.Add Multiple Node Roles
        #[Tags]    Test                   

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id_1}    PCC.Get Template Id    Name=${APP_1}
        
        ${status}    PCC.Add Multiple Node Roles
                     ...    Name=${MULTIPLE_NODE_ROLE} 
                     ...    Description=${MULTIPLE_NODE_ROLE_DESC}
                     ...    number_of_node_roles=100
                     ...    templateIDs=[${template_id_1}]
                     ...    owners=[${owner}]
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    All Node roles not added to PCC
                     
###################################################################################################################################
Delete 100 node roles
###################################################################################################################################

        [Documentation]    *Delete 100 node roles* test
                           ...  keywords:
                           ...  PCC.Delete Multiple Node Roles
        [Tags]    Test                   
        
        ${status}    PCC.Delete Multiple Node Roles
                     ...    Name=${MULTIPLE_NODE_ROLE}
                     ...    number_of_node_roles=100
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    All Node roles not deleted from PCC                                                            
###################################################################################################################################
Delete All Node Roles
###################################################################################################################################

        [Documentation]    *Delete All Node Roles* test
                           ...  keywords:
                           ...  PCC.Delete all Node roles
        [Tags]    Delete

        ${status}    PCC.Delete all Node roles
                       
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node group still exists                          
        