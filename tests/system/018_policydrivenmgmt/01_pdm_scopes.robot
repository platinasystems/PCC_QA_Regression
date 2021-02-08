*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC 
###################################################################################################################################
                
        
        [Documentation]    *Login to PCC* test
        
        [Tags]    Run
        ${status}        Login To PCC    ${pcc_setup}
                         
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}                         

###################################################################################################################################
GET scoping object types
###################################################################################################################################

        [Documentation]    *GET scoping object types* test
                           ...  keywords:
                           ...  PCC.Get Scope Types
        
        [Tags]    Running
        ${response}    PCC.Get Scope Types
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200 
                        
###################################################################################################################################
Create scoping object - Region
###################################################################################################################################

        [Documentation]    *Create scoping object - Region* test
                           ...  keywords:
                           ...  PCC.Create Scope
        
        [Tags]    Running
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
Create scoping object - Zone
###################################################################################################################################

        [Documentation]    *Create scoping object - Region* test
                           ...  keywords:
                           ...  PCC.Create Scope
        
        [Tags]    Running
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
Create scoping object - Site
###################################################################################################################################

        [Documentation]    *Create scoping object - Site* test
                           ...  keywords:
                           ...  PCC.Create Scope
        [Tags]    Running
        
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
Create scoping object - Rack
###################################################################################################################################

        [Documentation]    *Create scoping object - Rack* test
                           ...  keywords:
                           ...  PCC.Create Scope
        [Tags]    Running
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
Create scoping object (Zone) under Default region
###################################################################################################################################

        [Documentation]    *Create scoping object - Region* test
                           ...  keywords:
                           ...  PCC.Create Scope


        ${parent_Id}    PCC.Get Scope Id
                        ...  scope_name=Default region
                        Log To Console    ${parent_Id}

        ${response}    PCC.Create Scope
                       ...  type=zone
                       ...  scope_name=zone-un-default-region
                       ...  description=zone-un-default-region-desc
                       ...  parentID=${parent_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=zone-un-default-region

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK
                       
###################################################################################################################################
Create scoping object (Site) under Default zone
###################################################################################################################################

        [Documentation]    *Create scoping object - Site* test
                           ...  keywords:
                           ...  PCC.Create Scope
        
        
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent1_Id}
        
        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=Default zone
                        ...  parentID=${parent1_Id}
                        
                        Log To Console    ${parent2_Id}
        
        ${response}    PCC.Create Scope
                       ...  type=site
                       ...  scope_name=site-und-default-zone
                       ...  description=site-und-default-zone-desc
                       ...  parentID=${parent2_Id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=site-und-default-zone
                       
                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Create scoping object (Rack) under Default Site
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
                        ...  scope_name=Default site
                        ...  parentID=${parent2_Id}
                        
                        Log To Console    ${parent3_Id}
        
        ${response}    PCC.Create Scope
                       ...  type=rack
                       ...  scope_name=rack-default-site
                       ...  description=rack-default-site-desc
                       ...  parentID=${parent3_Id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=rack-default-site
                       
                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK
                       
###################################################################################################################################
Get Scoping Object by ID
###################################################################################################################################

        [Documentation]    *Get Scoping Object by ID* test
                           ...  keywords:
                           ...  PCC.Get Scope Details
        
        
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
        
        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${parent1_Id}
        
        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${parent2_Id}
                        
                        Log To Console    ${parent3_Id}
        
        ${response}    PCC.Get Scope Details
                       ...  scope_name=rack-1
                       ...  parentID=${parent3_Id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Get all Scoping Object
###################################################################################################################################

        [Documentation]    *Get all Scoping Object* test
                           ...  keywords:
                           ...  PCC.Get All Scopes
        
        
        ${response}    PCC.Get All Scopes
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Create scoping object without mandatory parameters (type, name) (Negative)
###################################################################################################################################

        [Documentation]    *Create scoping object without mandatory parameters (type, name)* test
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
        
        ### Without type ###
        ${response}    PCC.Create Scope
                       ...  scope_name=rack-negative
                       ...  description=rack-negative-description
                       ...  parentID=${parent3_Id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=rack-negative
                       
                       Log To Console    ${status}
                       Should Not Be Equal As Strings    ${status}    OK  
        
        ### Without name ###               
        ${response}    PCC.Create Scope
                       ...  scope_name= 
                       ...  type=rack
                       ...  description=rack-negative-description
                       ...  parentID=${parent3_Id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Check if a duplicate named scoping object can created for same parent(Negative)
###################################################################################################################################

        [Documentation]    *Check if a duplicate named scoping object can created for same parent* test
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
                       ...  description=duplicate-rack-description
                       ...  parentID=${parent3_Id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Create scope with invalid type should throw proper error [supported: Region,Zone,Site,Rack] (Negative)
###################################################################################################################################

        [Documentation]    *Create scope with invalid type should throw proper error* test
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
                       ...  type=xyz
                       ...  scope_name=invalid-rack-1
                       ...  description=invalid-rack-description
                       ...  parentID=${parent3_Id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=invalid-rack-1
                       
                       Log To Console    ${status}
                       Should Not Be Equal As Strings    ${status}    OK 
                       
###################################################################################################################################
Create scope with invalid/non existing parentID (Negative)
###################################################################################################################################

        [Documentation]    *Create scope with invalid/non existing parentID* test
                           ...  keywords:
                           ...  PCC.Create Scope
        
        
        ${response}    PCC.Create Scope
                       ...  type=rack
                       ...  scope_name=invalid-rack-1
                       ...  description=invalid-rack-description
                       ...  parentID=99999
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=invalid-rack-1
                       
                       Log To Console    ${status}
                       Should Not Be Equal As Strings    ${status}    OK
                       
                       
###################################################################################################################################
Check parentID must be integer (Negative)
###################################################################################################################################

        [Documentation]    *Check parentID must be integer (Negative)* test
                           ...  keywords:
                           ...  PCC.Create Scope
        
        ${response}    PCC.Create Scope
                       ...  type=rack
                       ...  scope_name=invalid-rack-1
                       ...  description=invalid-rack-description
                       ...  parentID=abcd
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=invalid-rack-1
                       
                       Log To Console    ${status}
                       Should Not Be Equal As Strings    ${status}    OK
                       
###################################################################################################################################
Check if parentID is null for a region
###################################################################################################################################

        [Documentation]    *Check if parentID is null for a region* test
                           ...  keywords:
                           ...  PCC.Get Scope Details
        
        ${response}    PCC.Get Scope Details
                       ...  scope_name=region-1
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200 
                       
                       ${data}    Get Response Data    ${response}
                       ${parentID}    Get From Dictionary    ${data}    parentID    
                       Should Be Equal As Strings    ${parentID}    None
                       
###################################################################################################################################
Check if parentID is never null for a zone (Negative)
###################################################################################################################################

        [Documentation]    *Check if parentID is never null for a zone* test
                           ...  keywords:
                           ...  PCC.Get Scope Details
        
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
        
        ${response}    PCC.Get Scope Details
                       ...  scope_name=zone-1
                       ...  parentID=${parent1_Id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200 
                       
                       ${data}    Get Response Data    ${response}
                       ${parentID}    Get From Dictionary    ${data}    parentID    
                       Should Not Be Equal As Strings    ${parentID}    None 
                      
###################################################################################################################################
Check if parentID is never null for a site (Negative)
###################################################################################################################################

        [Documentation]    *Check if parentID is never null for a site* test
                           ...  keywords:
                           ...  PCC.Get Scope Details
        
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
        
        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${parent1_Id}
                        
                        Log To Console    ${parent2_Id}  
                       
        ${response}    PCC.Get Scope Details
                       ...  scope_name=site-1
                       ...  parentID=${parent2_Id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200 
                       
                       ${data}    Get Response Data    ${response}
                       ${parentID}    Get From Dictionary    ${data}    parentID    
                       Should Not Be Equal As Strings    ${parentID}    None
                       
###################################################################################################################################
Check if parentID is never null for a rack (Negative)
###################################################################################################################################

        [Documentation]    *Check if parentID is never null for a rack* test
                           ...  keywords:
                           ...  PCC.Get Scope Details
        
        
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
        
        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${parent1_Id}
        
        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${parent2_Id}
                        
                        Log To Console    ${parent3_Id}
        
        ${response}    PCC.Get Scope Details
                       ...  scope_name=rack-1
                       ...  parentID=${parent3_Id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200 
                       
                       ${data}    Get Response Data    ${response}
                       ${parentID}    Get From Dictionary    ${data}    parentID    
                       Should Not Be Equal As Strings    ${parentID}    None

###################################################################################################################################
A policyID must be integer (Negative)
###################################################################################################################################

        [Documentation]    *Check if parentID is never null for a rack* test
                           ...  keywords:
                           ...  PCC.Create Policy
                           
        ${parent_Id}    PCC.Get Scope Id
                        ...  scope_name=Default region
                        Log To Console    ${parent_Id}
                        
        ${scope_id}     PCC.Get Scope Id
                        ...  scope_name=zone-under-default-region
                        ...  parentID=${parent_Id}
                           
        ${response}    PCC.Update Scope
                       ...  Id=${scope_id}
                       ...  type=zone
                       ...  scope_name=zone-under-default-region
                       ...  description=zone-under-default-region-desc
                       ...  parentID=${parent_Id}
                       ...  policyIDs=['xyz']
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
                       
###################################################################################################################################
Associate policies with scope
###################################################################################################################################

        [Documentation]    *Check if parentID is never null for a rack* test
                           ...  keywords:
                           ...  PCC.Create Policy
        [Tags]    Run                   
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=dns
                     Log To Console    ${app_id}


        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=policy-for-scope

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=dns
                        ...  description=policy-for-scope

                        Log To Console    ${policy_id}


        ${parent_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent_Id}

        ${scope_id}     PCC.Get Scope Id
                        ...  scope_name=Default zone
                        ...  parentID=${parent_Id}

        ${response}    PCC.Update Scope
                       ...  Id=${scope_id}
                       ...  type=zone
                       ...  scope_name=Default zone
                       ...  description=Default zone scope
                       ...  parentID=${parent_Id}
                       ...  policyIDs=[${policy_id}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=Default zone

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK
                       
                   
###################################################################################################################################
Update Name of a scoping object (considered Zone)
###################################################################################################################################

        [Documentation]    *Update Name of a scoping object (considered Zone)* test
                           ...  keywords:
                           ...  PCC.Update Scope
        
        
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
        
        ${scope_id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${parent1_Id}             
                           
        ${response}    PCC.Update Scope
                       ...  Id=${scope_id}
                       ...  type=zone
                       ...  scope_name=zone-updated
                       ...  description=zone-description
                       ...  parentID=${parent1_Id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=zone-updated
                       
                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK
                       
###################################################################################################################################
Update Description of a scoping object (considered Zone)
###################################################################################################################################

        [Documentation]    *Update Description of a scoping object (considered Zone)* test
                           ...  keywords:
                           ...  PCC.Update Scope
        
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
        
        ${scope_id}    PCC.Get Scope Id
                        ...  scope_name=zone-updated
                        ...  parentID=${parent1_Id}             
                           
        ${response}    PCC.Update Scope
                       ...  Id=${scope_id}
                       ...  type=zone
                       ...  scope_name=zone-updated
                       ...  description=zone-description-updated
                       ...  parentID=${parent1_Id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=zone-updated
                       
                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK
                       
###################################################################################################################################
Update parentID of a scoping object (considered Site)
###################################################################################################################################

        [Documentation]    *Update Description of a scoping object (considered Zone)* test
                           ...  keywords:
                           ...  PCC.Update Scope
        
        
        ## Creating another zone for updating parentID of Site ##
        
        ${parent_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent_Id}
                        
        ${response}    PCC.Create Scope
                       ...  type=zone
                       ...  scope_name=zone-2
                       ...  description=zone-2-description
                       ...  parentID=${parent_Id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=zone-2
                       
                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK
        
        
        ## Updating site with new parentID ##
        
        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${parent_Id}
                        
        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-updated
                        ...  parentID=${parent_Id} 
        
        
        ${scope_id}    PCC.Get Scope Id
                       ...  scope_name=site-1
                       ...  parentID=${parent3_Id}
                           
        ${response}    PCC.Update Scope
                       ...  Id=${scope_id}
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
                       
####################################################################################################################################
#Update parentID of a default scoping object must not be supported (considered Default Site) - Bug ID -2730
####################################################################################################################################
#
#        [Documentation]    *Update parentID of a default scoping object must not be supported (considered Default Site)* test
#                           ...  keywords:
#                           ...  PCC.Update Scope
#                           
#        ## Updating default site with new parentID ##
#        ${parent1_Id}    PCC.Get Scope Id
#                        ...  scope_name=region-1
#        
#        ${parent2_Id}    PCC.Get Scope Id
#                        ...  scope_name=zone-2
#                        ...  parentID=${parent1_Id}
#                        
#        ${parent3_Id}    PCC.Get Scope Id
#                        ...  scope_name=zone-updated
#                        ...  parentID=${parent1_Id} 
#        
#        
#        ${scope_id}    PCC.Get Scope Id
#                       ...  scope_name=Default site
#                       ...  parentID=${parent2_Id}
#                           
#        ${response}    PCC.Update Scope
#                       ...  Id=${scope_id}
#                       ...  type=site
#                       ...  scope_name=Default site
#                       ...  description=Default description
#                       ...  parentID=${parent3_Id}
#                       
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Check if a default region can be deleted
###################################################################################################################################

        [Documentation]    *Check if a default zone can be deleted* test
                           ...  keywords:
                           ...  PCC.Delete Scope             
        [Tags]    delete                   
        ${response}    PCC.Delete Scope
                       ...  scope_name=Default region
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Check if a default zone can be deleted
###################################################################################################################################

        [Documentation]    *Check if a default zone can be deleted* test
                           ...  keywords:
                           ...  PCC.Delete Scope             
         
        [Tags]    delete                  
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        
        ${response}    PCC.Delete Scope
                       ...  scope_name=Default zone
                       ...  parentID=${parent1_Id}
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Check if a default site can be deleted
###################################################################################################################################

        [Documentation]    *Check if a default site can be deleted* test
                           ...  keywords:
                           ...  PCC.Delete Scope             
        [Tags]    delete                
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${parent1_Id}

        ${response}    PCC.Delete Scope
                       ...  scope_name=Default site
                       ...  parentID=${parent2_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200


                       
###################################################################################################################################
Check if a default rack can be deleted
###################################################################################################################################

        [Documentation]    *Check if a default rack can be deleted* test
                           ...  keywords:
                           ...  PCC.Delete Scope             
        [Tags]    delete                
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
        
        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${parent1_Id}
        
        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${parent2_Id}
        
        ${response}    PCC.Delete Scope
                       ...  scope_name=Default rack
                       ...  parentID=${parent3_Id}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
