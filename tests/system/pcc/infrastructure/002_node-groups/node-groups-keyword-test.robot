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
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         
                         Load Node Groups Data    ${pcc_setup}
                         
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
PCC Node Group - Verify if user can access node group
###################################################################################################################################

        [Documentation]    *PCC Node Group - Verify if user can access node group* test
                           ...  keywords:
                           ...  PCC.Get Node Groups

        ${response}    PCC.Get Node Groups
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
PCC Node Group Creation and Verification
###################################################################################################################################

        [Documentation]    *PCC Node Group - Verify if user can access node group* test
                           ...  keywords:
                           ...  PCC.Add Node Group
                           ...  PCC.Validate Node Group

        ${owner}       PCC.Get Tenant Id       Name=ROOT
        
        ${response}    PCC.Add Node Group
                       ...    Name=${NODE_GROUP1} 
                       ...    owner=${owner}
                       ...    Description=${NODE_GROUP_DESC1}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
              
        ${status}    PCC.Validate Node Group
                     ...    Name=${NODE_GROUP1}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node group doesnot exists
                       
                           
###################################################################################################################################
PCC Node group creation without description
###################################################################################################################################

        [Documentation]    *PCC Node group creation without description* test
                           ...  keywords:
                           ...  PCC.Get Tenant Id
                           ...  PCC.Add Node Group
                           ...  PCC.Validate Node Group

        ${owner}       PCC.Get Tenant Id       Name=ROOT
        
        ${response}    PCC.Add Node Group
                       ...    Name=${NODE_GROUP2} 
                       ...    owner=${owner}
                       ...    Description=${NODE_GROUP_DESC2}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}    PCC.Validate Node Group
                     ...    Name=${NODE_GROUP2}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK        

###################################################################################################################################
PCC Node group creation without name
###################################################################################################################################

        [Documentation]    *PCC Node group creation without description* test
                           ...  keywords:
                           ...  PCC.Add Node Group
                           ...  PCC.Get Tenant Id 
                             

        ${owner}       PCC.Get Tenant Id       Name=ROOT
        
        ${response}    PCC.Add Node Group
                       ...    Name=${NODE_GROUP2} 
                       ...    owner=${owner}
                       ...    Description=${NODE_GROUP_DESC2}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
PCC Node group deletion
###################################################################################################################################

        [Documentation]    *PCC Node group creation without description* test
                           ...  keywords:
                           ...  PCC.Delete Node Group
                           ...  PCC.Get Node Group Id
                           ...  PCC.Validate Node Group 
                           
        ${nodegroup_id}    PCC.Get Node Group Id                                  
                           ...    Name=${NODE_GROUP2}
                           
        ${response}    PCC.Delete Node Group
                       ...    Id=${nodegroup_id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
                       Sleep    2s
                       
        ${status}    PCC.Validate Node Group
                     ...    Name=${NODE_GROUP2}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    Node group not available    Node group not deleted
                     
###################################################################################################################################
PCC Node group Edit
###################################################################################################################################

        [Documentation]    *PCC Node group Edit* test
                           ...  keywords:
                           ...  Get Node Group Id
                           ...  PCC.Get Tenant Id
                           ...  PCC.Modify Node Group
                           ...  PCC.Validate Node Group
                           
                           
        ${nodegroup_id}    PCC.Get Node Group Id                                  
                           ...    Name=${NODE_GROUP1}
        
        ${owner}       PCC.Get Tenant Id       Name=ROOT
        
        ${response}    PCC.Modify Node Group
                       ...    Id=${nodegroup_id}
                       ...    Name=${NODE_GROUP3} 
                       ...    owner=${owner}
                       ...    Description=${NODE_GROUP_DESC3}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}    PCC.Validate Node Group
                     ...    Name=${NODE_GROUP3}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node group doesnot exists
                     
###################################################################################################################################
PCC Duplicate Node Group Creation
###################################################################################################################################

        [Documentation]    *PCC Duplicate Node Group Creation* test
                           ...  keywords:
                           ...  PCC.Add Node Group
                           
        ${owner}       PCC.Get Tenant Id       Name=ROOT
        
        ${response}    PCC.Add Node Group
                       ...    Name=${NODE_GROUP3} 
                       ...    owner=${owner}
                       ...    Description=${NODE_GROUP_DESC3}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200

###################################################################################################################################
Clear existing node group description
###################################################################################################################################

        [Documentation]    *PCC Node group Edit* test
                           ...  keywords:
                           ...  Get Node Group Id
                           ...  PCC.Get Tenant Id
                           ...  PCC.Modify Node Group
                           ...  PCC.Validate Node Group
                           
        ${nodegroup_id}    PCC.Get Node Group Id                                  
                           ...    Name=${NODE_GROUP3}
        
        ${owner}       PCC.Get Tenant Id       Name=ROOT
        
        ${response}    PCC.Modify Node Group
                       ...    Id=${nodegroup_id}
                       ...    Name=${NODE_GROUP3} 
                       ...    owner=${owner}
                       ...    Description=''
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}    PCC.Validate Node Group
                     ...    Name=${NODE_GROUP3}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node group doesnot exists
                     
###################################################################################################################################
Node Group Name Change
###################################################################################################################################

        [Documentation]    *Node Group Name Change* test
                           ...  keywords:
                           ...  Get Node Group Id
                           ...  PCC.Get Tenant Id
                           ...  PCC.Modify Node Group
                           ...  PCC.Validate Node Group
                           
        ${nodegroup_id}    PCC.Get Node Group Id                                  
                           ...    Name=${NODE_GROUP3}
        
        ${owner}       PCC.Get Tenant Id       Name=ROOT
        
        ${response}    PCC.Modify Node Group
                       ...    Id=${nodegroup_id}
                       ...    Name=${NODE_GROUP4} 
                       ...    owner=${owner}
                       ...    Description=${NODE_GROUP_DESC3}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}    PCC.Validate Node Group
                     ...    Name=${NODE_GROUP4}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node group doesnot exists                     
                                                               
###################################################################################################################################
Node Group Description Change
###################################################################################################################################

        [Documentation]    *Node Group Description Change* test
                           ...  keywords:
                           ...  Get Node Group Id
                           ...  PCC.Get Tenant Id
                           ...  PCC.Modify Node Group
                           ...  PCC.Validate Node Group
                           
        ${nodegroup_id}    PCC.Get Node Group Id                                  
                           ...    Name=${NODE_GROUP4}
        
        ${owner}       PCC.Get Tenant Id       Name=ROOT
        
        ${response}    PCC.Modify Node Group
                       ...    Id=${nodegroup_id}
                       ...    Name=${NODE_GROUP4} 
                       ...    owner=${owner}
                       ...    Description=${NODE_GROUP_DESC4}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}    PCC.Validate Node Group Description
                     ...    Name=${NODE_GROUP4}
                     ...    Description=${NODE_GROUP_DESC4}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node group doesnot exists
                     
###################################################################################################################################
Creation of Node Group with Special Characters Only is not Allowed(Negative)
###################################################################################################################################

        [Documentation]    *Creation of Node Group with Special Characters Only is not Allowed* test
                           ...  keywords:
                           ...  PCC.Add Node Group
                           ...  PCC.Validate Node Group

        ${owner}       PCC.Get Tenant Id       Name=ROOT
        
        ${response}    PCC.Add Node Group
                       ...    Name=${NODE_GROUP5} 
                       ...    owner=${owner}
                       ...    Description=${NODE_GROUP_DESC5}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
              
        ${status}    PCC.Validate Node Group
                     ...    Name=${NODE_GROUP5}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    Node group not available    msg=Node group with ${NODE_GROUP5} created
                     
###################################################################################################################################
Creation of Node Group with Numerics Characters Only not Allowed(Negative)
###################################################################################################################################

        [Documentation]    *Creation of Node Group with Numerics Characters Only not Allowed* test
                           ...  keywords:
                           ...  PCC.Add Node Group
                           ...  PCC.Validate Node Group

        ${owner}       PCC.Get Tenant Id       Name=ROOT
        
        ${response}    PCC.Add Node Group
                       ...    Name=${NODE_GROUP6} 
                       ...    owner=${owner}
                       ...    Description=${NODE_GROUP_DESC6}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
              
        ${status}    PCC.Validate Node Group
                     ...    Name=${NODE_GROUP6}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    Node group not available    msg=Node group with ${NODE_GROUP6} created
                     
###################################################################################################################################
Node group name contain only space are not allowed(Negative)
###################################################################################################################################

        [Documentation]    *Creation of Node Group with Numerics Characters Only not Allowed* test
                           ...  keywords:
                           ...  PCC.Add Node Group
                           ...  PCC.Validate Node Group

        ${owner}       PCC.Get Tenant Id    Name=ROOT
        
        ${response}    PCC.Add Node Group
                       ...    Name=${NODE_GROUP7} 
                       ...    owner=${owner}
                       ...    Description=${NODE_GROUP_DESC7}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
              
        ${status}    PCC.Validate Node Group
                     ...    Name=${NODE_GROUP7}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    Node group not available    msg=Node group with ${NODE_GROUP7} created
                     

                       

                       
        
                     

                     

                       
        
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                      
                       
                                         
                           
