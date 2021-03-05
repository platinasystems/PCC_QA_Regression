*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_215

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
                         Load Server 3 Test Data    ${pcc_setup}
                         
                         Load Tenant Data    ${pcc_setup}
        
        ${server1_id}    PCC.Get Node Id    Name=${SERVER_1_NAME}
                         Log To Console    ${server1_id}
                         Set Global Variable    ${server1_id}
                         
        ${server2_id}    PCC.Get Node Id    Name=${SERVER_2_NAME}
                         Log To Console    ${server2_id}
                         Set Global Variable    ${server2_id}
                         
        ${server3_id}    PCC.Get Node Id    Name=${SERVER_3_NAME}
                         Log To Console    ${server3_id}
                         Set Global Variable    ${server3_id}
                         
        ${invader1_id}    PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
                         Log To Console    ${invader1_id}
                         Set Global Variable    ${invader1_id}
                         
                         
###################################################################################################################################
PCC-Tenant-Creation
###################################################################################################################################

        [Documentation]    *Create Tenant* test
                           ...  keywords:
                           ...  PCC.Add Tenant

        ${parent_id}    PCC.Get Tenant Id
                        ...    Name=${ROOT_TENANT}

        ${response}    PCC.Add Tenant
                       ...    Name=${TENANT1}
                       ...    Description=${TENANT1_DESC}
                       ...    Parent_id=${parent_id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}    PCC.Validate Tenant
                     ...    Name=${TENANT1}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK 
                       
###################################################################################################################################
PCC Tenant creation without description
###################################################################################################################################

        [Documentation]    *PCC Tenant creation without description* test
                           ...  keywords:
                           ...  PCC.Get Tenant Id
                           ...  PCC.Add Tenant
                           

        ${parent_id}    PCC.Get Tenant Id
                        ...    Name=${ROOT_TENANT}
        
        ${response}    PCC.Add Tenant
                       ...    Name=${TENANT2} 
                       ...    Parent_id=${parent_id}
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}    PCC.Validate Tenant
                     ...    Name=${TENANT2}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK        

###################################################################################################################################
PCC Tenant creation without name
###################################################################################################################################

        [Documentation]    *PCC Tenant creation without description* test
                           ...  keywords:
                           ...  PCC.Add Tenant
                           ...  PCC.Get Tenant Id 
                             
        ${parent_id}    PCC.Get Tenant Id
                        ...    Name=${ROOT_TENANT}
        
        
        ${response}    PCC.Add Tenant
                       ...    Name=
                       ...    Parent_id=${parent_id}
                       ...    Description=${TENANT2_DESC}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
PCC Tenant deletion
###################################################################################################################################

        [Documentation]    *PCC Tenant Deletion* test
                           ...  keywords:
                           ...  PCC.Delete Tenant
                           ...  PCC.Get Tenant Id
                           ...  PCC.Validate Tenant 
                           
        ${tenant_id}    PCC.Get Tenant Id                                  
                        ...    Name=${TENANT2}
                           
        ${response}    PCC.Delete Tenant
                       ...    Id=${tenant_id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       
                       Sleep    2s
                       
        ${status}    PCC.Validate Tenant
                     ...    Name=${TENANT2}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    Tenant not available    Tenant not deleted
                     
###################################################################################################################################
PCC Tenant Edit
###################################################################################################################################

        [Documentation]    *PCC Tenant Edit* test
                           ...  keywords:
                           ...  Get Tenant Id
                           ...  PCC.Get Tenant Id
                           ...  PCC.Modify Tenant
                           ...  PCC.Validate Tenant
                           
                           
        ${tenant_id}    PCC.Get Tenant Id                                  
                        ...    Name=${TENANT1}
        
        ${parent_id}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        
        ${response}    PCC.Modify Tenant
                       ...    Id=${tenant_id}
                       ...    Name=${TENANT3} 
                       ...    Parent_id=${parent_id}
                       ...    Description=${TENANT3_DESC}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}    PCC.Validate Tenant
                     ...    Name=${TENANT3}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Tenant doesnot exists
                     
###################################################################################################################################
PCC Duplicate Tenant Creation
###################################################################################################################################

        [Documentation]    *PCC Duplicate Tenant Creation* test
                           ...  keywords:
                           ...  PCC.Add Tenant
                           
        ${parent_id}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${response}    PCC.Add Tenant
                       ...    Name=${TENANT3} 
                       ...    Parent_id=${parent_id}
                       ...    Description=${TENANT3_DESC}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Not Be Equal As Strings    ${status}    200

###################################################################################################################################
Clear existing tenant description
###################################################################################################################################

        [Documentation]    *PCC Tenant Edit* test
                           ...  keywords:
                           ...  Get Tenant Id
                           ...  PCC.Get Tenant Id
                           ...  PCC.Modify Tenant
                           ...  PCC.Validate Tenant
                           
        ${tenant_id}    PCC.Get Tenant Id                                  
                        ...    Name=${TENANT3}
        
        ${parent_id}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${response}    PCC.Modify Tenant
                       ...    Id=${tenant_id}
                       ...    Name=${TENANT3} 
                       ...    Parent_id=${parent_id}
                       ...    Description=''
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}    PCC.Validate Tenant
                     ...    Name=${TENANT3}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Tenant doesnot exists
                     
###################################################################################################################################
Tenant Name Change
###################################################################################################################################

        [Documentation]    *Tenant Name Change* test
                           ...  keywords:
                           ...  Get Tenant Id
                           ...  PCC.Get Tenant Id
                           ...  PCC.Modify Tenant
                           ...  PCC.Validate Tenant
                           
        ${tenant_id}    PCC.Get Tenant Id                                  
                        ...    Name=${TENANT3}
        
        ${parent_id}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${response}    PCC.Modify Tenant
                       ...    Id=${tenant_id}
                       ...    Name=${TENANT4} 
                       ...    Parent_id=${parent_id}
                       ...    Description=${TENANT3_DESC}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}    PCC.Validate Tenant
                     ...    Name=${TENANT4}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Tenant doesnot exists                     
                                                               
###################################################################################################################################
Tenant Description Change
###################################################################################################################################

        [Documentation]    *Tenant Description Change* test
                           ...  keywords:
                           ...  Get Tenant Id
                           ...  PCC.Get Tenant Id
                           ...  PCC.Modify Tenant
                           ...  PCC.Validate Tenant
                           
        ${tenant_id}    PCC.Get Tenant Id                                  
                        ...    Name=${TENANT4}
        
        ${parent_id}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${response}    PCC.Modify Tenant
                       ...    Id=${tenant_id}
                       ...    Name=${TENANT4} 
                       ...    Parent_id=${parent_id}
                       ...    Description=${TENANT4_DESC}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}    PCC.Validate Tenant Description
                     ...    Name=${TENANT4}
                     ...    Description=${TENANT4_DESC}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Tenant doesnot exists
                     
###################################################################################################################################
Creation of Tenant with Special Characters Only is not Allowed(Negative)
###################################################################################################################################

        [Documentation]    *Creation of Tenant with Special Characters Only is not Allowed* test
                           ...  keywords:
                           ...  PCC.Add Tenant
                           ...  PCC.Validate Tenant

        ${parent_id}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${response}    PCC.Add Tenant
                       ...    Name=${TENANT6} 
                       ...    Parent_id=${parent_id}
                       ...    Description=${TENANT6_DESC}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Not Be Equal As Strings    ${status}    200
                       
              
        ${status}    PCC.Validate Tenant
                     ...    Name=${TENANT6}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    Tenant not available    msg=Tenant with ${TENANT5} created                       
                       
                      
###################################################################################################################################
Tenant name contain only space are not allowed(Negative)
###################################################################################################################################

        [Documentation]    *Creation of Tenant with Spaces Only not Allowed* test
                           ...  keywords:
                           ...  PCC.Add Tenant
                           ...  PCC.Validate Tenant

        ${parent_id}       PCC.Get Tenant Id    Name=${ROOT_TENANT}
        
        ${response}    PCC.Add Tenant
                       ...    Name=${TENANT7} 
                       ...    Parent_id=${parent_id}
                       ...    Description=${TENANT7_DESC}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Not Be Equal As Strings    ${status}    200
                       
              
        ${status}    PCC.Validate Tenant
                     ...    Name=${TENANT7}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    Tenant not available    msg=Tenant with ${TENANT7} created
                     
###################################################################################################################################
Update PCC Tenant Name with Existing Tenant Name(Negative)
###################################################################################################################################

        [Documentation]    *Update PCC Tenant Name with Existing Tenant Name* test
                           ...  keywords:
                           ...  PCC.Get Tenant Id
                           ...  PCC.Add Tenant
                           ...  PCC.Validate Tenant

        ${parent_id}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${response}    PCC.Add Tenant
                       ...    Name=${TENANT5} 
                       ...    Parent_id=${parent_id}
                       ...    Description=${TENANT5_DESC}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}    PCC.Validate Tenant
                     ...    Name=${TENANT5}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK
                     
        ${tenant_id}    PCC.Get Tenant Id                                  
                        ...    Name=${TENANT5}
        
        ${parent_id}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${response}    PCC.Modify Tenant
                       ...    Id=${tenant_id}
                       ...    Name=${TENANT4} 
                       ...    Parent_id=${parent_id}
                       ...    Description=${TENANT4_DESC}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Not Be Equal As Strings    ${status}    200
                      
###################################################################################################################################
Clearing existing node group name and verify it is not allowed
###################################################################################################################################

        [Documentation]    *Clearing existing node group name and verify it is not allowed* test
                           ...  keywords:
                           ...  PCC.Get Tenant Id
                           ...  PCC.Modify Tenant
                           

        
                     
        ${tenant_id}    PCC.Get Tenant Id                                  
                           ...    Name=${TENANT5}
        
        ${parent_id}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${response}    PCC.Modify Tenant
                       ...    Id=${tenant_id}
                       ...    Name=''
                       ...    Parent_id=${parent_id}
                       ...    Description=${TENANT5_DESC}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Pcc Tenant Assignment
###################################################################################################################################

        [Documentation]    *Pcc-Tenant-Assignment* test
                           ...  keywords:
                           ...  PCC.Get Tenant Id
                           ...  PCC.Assign Tenant to Node
                           ...  PCC.Validate Tenant Assigned to Node

        ${tenant_id}    PCC.Get Tenant Id                                  
                        ...    Name=${TENANT5}
                     
        ${response}    PCC.Assign Tenant to Node
                       ...    tenant_id=${tenant_id}
                       ...    ids=${server3_id}
                      
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    StatusCode
                       Should Be Equal As Strings    ${status}    200
        
                     
        ${status}    PCC.Validate Tenant Assigned to Node
                     ...    Name=${SERVER_3_NAME}
                     ...    Tenant_Name=${TENANT5}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK
                     
                    
###################################################################################################################################
Delete Tenant in the PCC when Tenant is associated with the Node
###################################################################################################################################

        [Documentation]    *Delete Tenant in the PCC when Tenant is associated with the Node* test
                           ...  keywords:
                           ...  PCC.Delete Tenant
                           ...  PCC.Get Tenant Id
                           ...  PCC.Validate Tenant 
                           
        ${tenant_id}    PCC.Get Tenant Id                                  
                        ...    Name=${TENANT5}
                           
        ${response}    PCC.Delete Tenant
                       ...    Id=${tenant_id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Not Be Equal As Strings    ${status}    200
                       
                       
        ${status}    PCC.Validate Tenant
                     ...    Name=${TENANT5}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Tenant doesnot exists

###################################################################################################################################
Pcc Tenant Un-Assignment
###################################################################################################################################

        [Documentation]    *Pcc-Tenant-UnAssignment* test
                           ...  keywords:
                           ...  PCC.Get Tenant Id
                           ...  PCC.Assign Tenant to Node
        
        ${parent_id}       PCC.Get Tenant Id       Name=${ROOT_TENANT}

        ${response}    PCC.Assign Tenant to Node
                       ...    tenant_id=${parent_id}
                       ...    ids=${server3_id}
                      
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
PCC Sub-Tenant Creation
###################################################################################################################################

        [Documentation]    *Create Sub-Tenant* test
                           ...  keywords:
                           ...  PCC.Add Tenant

        ${parent_id}    PCC.Get Tenant Id
                        ...    Name=${TENANT5}

        ${response}    PCC.Add Tenant
                       ...    Name=${SUB_TENANT}
                       ...    Description=${SUB_TENANT_DESC}
                       ...    Parent_id=${parent_id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}    PCC.Validate Tenant
                     ...    Name=${SUB_TENANT}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK  
                     
                     
###################################################################################################################################
PCC Sub-Tenant deletion
###################################################################################################################################

        [Documentation]    *PCC Sub-Tenant Deletion* test
                           ...  keywords:
                           ...  PCC.Delete Tenant
                           ...  PCC.Get Tenant Id
                           ...  PCC.Validate Tenant 
                           
        ${tenant_id}    PCC.Get Tenant Id                                  
                        ...    Name=${SUB_TENANT}
                           
        ${response}    PCC.Delete Tenant
                       ...    Id=${tenant_id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       
                       Sleep    2s
                       
        ${status}    PCC.Validate Tenant
                     ...    Name=${SUB_TENANT}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    Tenant not available    Tenant not deleted


###################################################################################################################################
Fetching Tenant ID before backup
###################################################################################################################################   

         ${tenant_id_before_backup}    PCC.Get Tenant Id
                                       ...    Name=${TENANT4}
                                       Log To Console    ${tenant_id_before_backup}
                                       Set Global Variable    ${tenant_id_before_backup}  



