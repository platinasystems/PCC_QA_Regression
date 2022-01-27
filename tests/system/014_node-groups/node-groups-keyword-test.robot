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
                       ...    Description=''
                       
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
                       ...    Name='' 
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
                     
###################################################################################################################################
Create 100 node groups
###################################################################################################################################

        [Documentation]    *Create 100 node groups* test
                           ...  keywords:
                           ...  PCC.Add Multiple Node Groups
        #[Tags]    Test                   

        ${owner}       PCC.Get Tenant Id    Name=ROOT
        
        ${status}    PCC.Add Multiple Node Groups
                     ...    Name=${NODE_GROUP8} 
                     ...    owner=${owner}
                     ...    Description=${NODE_GROUP_DESC8}
                     ...    number_of_node_groups=10
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    All Node groups not added to PCC
                     
###################################################################################################################################
Delete 100 node groups
###################################################################################################################################

        [Documentation]    *Delete 100 node groups* test
                           ...  keywords:
                           ...  PCC.Delete Multiple Node Groups
        [Tags]    Test                   
        
        ${status}    PCC.Delete Multiple Node Groups
                     ...    Name=${NODE_GROUP8}
                     ...    number_of_node_groups=10
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    All Node groups not deleted from PCC
                     
###################################################################################################################################
Update PCC Node Group Name with Existing Group Name(Negative)
###################################################################################################################################

        [Documentation]    *PCC Node group creation without description* test
                           ...  keywords:
                           ...  PCC.Get Tenant Id
                           ...  PCC.Add Node Group
                           ...  PCC.Validate Node Group

        ${owner}       PCC.Get Tenant Id       Name=ROOT
        
        ${response}    PCC.Add Node Group
                       ...    Name=${NODE_GROUP9} 
                       ...    owner=${owner}
                       ...    Description=${NODE_GROUP_DESC9}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}    PCC.Validate Node Group
                     ...    Name=${NODE_GROUP9}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK
                     
        ${nodegroup_id}    PCC.Get Node Group Id                                  
                           ...    Name=${NODE_GROUP9}
        
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
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Clearing existing node group name and verify it is not allowed
###################################################################################################################################

        [Documentation]    *PCC Node group creation without description* test
                           ...  keywords:
                           ...  PCC.Get Tenant Id
                           ...  PCC.Add Node Group
                           ...  PCC.Validate Node Group

        
                     
        ${nodegroup_id}    PCC.Get Node Group Id                                  
                           ...    Name=${NODE_GROUP9}
        
        ${owner}       PCC.Get Tenant Id       Name=ROOT
        
        ${response}    PCC.Modify Node Group
                       ...    Id=${nodegroup_id}
                       ...    Name=''
                       ...    owner=${owner}
                       ...    Description=${NODE_GROUP_DESC9}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Pcc Node Group Assignment
###################################################################################################################################

        [Documentation]    *Pcc-Node-Group-Assignment* test
                           ...  keywords:
                           ...  PCC.Get Tenant Id
                           ...  PCC.Add Node Group
                           ...  PCC.Validate Node Group

        ${nodegroup_id}    PCC.Get Node Group Id                                  
                           ...    Name=${NODE_GROUP9}
                     
        ${response}    PCC.Assign Node Group to Node                                  
                       ...    Id=${nodegroup_id}
                       ...    node_id=${invader1_id}
                       ...    Host=${CLUSTERHEAD_1_HOST_IP}
                       ...    Hostname=${CLUSTERHEAD_1_NAME}
                     
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                     
                     Sleep    1m

        ${status}    PCC.Validate Node Group Assigned to Node
                     ...    Name=${CLUSTERHEAD_1_NAME}
                     ...    Id=${nodegroup_id}

                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK
                     
                     
###################################################################################################################################
Delete Group in the PCC when group is associated with the Node
###################################################################################################################################

        [Documentation]    *Delete Group in the PCC when group is associated with the Node* test
                           ...  keywords:
                           ...  PCC.Delete Node Group
                           ...  PCC.Get Node Group Id
                           ...  PCC.Validate Node Group 
                           
        ${nodegroup_id}    PCC.Get Node Group Id                                  
                           ...    Name=${NODE_GROUP9}
                           
        ${response}    PCC.Delete Node Group
                       ...    Id=${nodegroup_id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
                       Sleep    2s
                       
        ${status}    PCC.Validate Node Group
                     ...    Name=${NODE_GROUP9}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node group doesnot exists

###################################################################################################################################
Pcc Node Group Un-Assignment
###################################################################################################################################

        [Documentation]    *Pcc-Node-Group-UnAssignment* test
                           ...  keywords:
                           ...  PCC.Get Tenant Id
                           ...  PCC.Add Node Group
                           ...  PCC.Validate Node Group


        ${response}    PCC.Assign Node Group to Node
                       ...    Id=0
                       ...    node_id=${invader1_id}
                       ...    Host=${CLUSTERHEAD_1_HOST_IP}
                       ...    Hostname=${CLUSTERHEAD_1_NAME}


                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Fetching Node group ID before backup
###################################################################################################################################   

         ${nodegroup_id_before_backup}    PCC.Get Node Group Id                                  
                                         ...    Name=${NODE_GROUP9}
                                         Log To Console    ${nodegroup_id_before_backup}
                                         Set Global Variable    ${nodegroup_id_before_backup}      

        


