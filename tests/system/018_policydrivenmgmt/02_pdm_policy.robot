*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC 
###################################################################################################################################
                
        ## abinashp
        [Documentation]    *Login to PCC* test
        [Tags]    This
        
       
        ${status}        Login To PCC    ${pcc_setup}
                         
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         
###################################################################################################################################
Check if user can view the applications
###################################################################################################################################

        [Documentation]    *Check if user can view the applications* test
                           ...  keywords:
                           ...  PCC.Get App Details
        [Tags]    Only
        ${response}    PCC.Get App Details
                       ...  app_name=dns
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Create a policy with default inputs (using DNS app)
###################################################################################################################################

        [Documentation]    *Create a policy* test
                           ...  keywords:
                           ...  PCC.Create Policy
        
        [Tags]    Only
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=dns
                     Log To Console    ${app_id}
        
        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1             
        
        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}
                         
        ${parent2_id}    PCC.Get Scope Id
                         ...  scope_name=zone-2
                         ...  parentID=${parent1_id}
                         
        ${scope2_id}     PCC.Get Scope Id
                         ...  scope_name=site-1  
                         ...  parentID=${parent2_id}          
                      
        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=dns-policy-description
                       ...  scopeIds=[${scope1_id},${scope2_id}]                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Create a policy with user-defined inputs
###################################################################################################################################

        [Documentation]    *Create a policy* test
                           ...  keywords:
                           ...  PCC.Create Policy
        
        [Tags]    Only
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=snmp
                     Log To Console    ${app_id}
        
        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1             
        
        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}
                             
                      
        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=user-defined-policy-description
                       ...  scopeIds=[${scope1_id}]
                       ...  inputs=[{"name": "parameter1","value": "value1"},{"name": "parameter2","value": "value2"}]
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
                       
###################################################################################################################################
Create policy without mandatory parameters - Application
###################################################################################################################################

        [Documentation]    *Create policy without mandatory parameters - Application* test
                           ...  keywords:
                           ...  PCC.Create Policy
        
        
        
        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1             
        
        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}
                             
                      
        ${response}    PCC.Create Policy
                       ...  description=without-application
                       ...  scopeIds=[${scope1_id}]
                       ...  inputs=[{"name": "parameter1","value": "value1"},{"name": "parameter2","value": "value2"}]
                       
                       
                       Log To Console    ${response}
                       

###################################################################################################################################
Create policy without name of Description
###################################################################################################################################

        [Documentation]    *Create policy without name of Description* test
                           ...  keywords:
                           ...  PCC.Create Policy

        [Tags]    Only_update
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=snmp
                     Log To Console    ${app_id}

        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1             

        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}


        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  scopeIds=[${scope1_id}]
                       ...  inputs=[{"name": "parameter1","value": "value1"},{"name": "parameter2","value": "value2"}]


                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Create a policy with default inputs (using NTP app)
###################################################################################################################################

        [Documentation]    *Create a policy* test
                           ...  keywords:
                           ...  PCC.Create Policy
        
        [Tags]    Only
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=ntp
                     Log To Console    ${app_id}
        
        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1             
        
        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}
                         
        ${parent2_id}    PCC.Get Scope Id
                         ...  scope_name=zone-2
                         ...  parentID=${parent1_id}
                         
        ${scope2_id}     PCC.Get Scope Id
                         ...  scope_name=site-1  
                         ...  parentID=${parent2_id}          
                      
        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=ntp-policy-description
                       ...  scopeIds=[${scope1_id},${scope2_id}]                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Get Policy
###################################################################################################################################

        [Documentation]    *Get Policy* test
                           ...  keywords:
                           ...  PCC.Get Policy Details
        [Tags]    Only
        ${response}    PCC.Get Policy Details
                       ...  Name=dns
                       ...  description=dns-policy-description
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Get All Policies
###################################################################################################################################

        [Documentation]    *Get All Policies* test
                           ...  keywords:
                           ...  PCC.Get All Policies
        
        [Tags]    Only
        ${response}    PCC.Get All Policies
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Get current policy deploy status by scopes
###################################################################################################################################

        [Documentation]    *Get current policy deploy status by scopes* test
                           ...  keywords:
                           ...  PCC.Get Policy Deploy Status by Scopes
        [Tags]    Only

        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1             

        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}

        ${parent2_id}    PCC.Get Scope Id
                         ...  scope_name=zone-2
                         ...  parentID=${parent1_id}

        ${scope2_id}     PCC.Get Scope Id
                         ...  scope_name=site-1  
                         ...  parentID=${parent2_id}

        ${response}    PCC.Get Policy Deploy Status by Scopes
                       ...  scope_name=site-1
                       ...  parentID=${parent2_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200  

###################################################################################################################################
Get current policy deploy status by policies
###################################################################################################################################

        [Documentation]    *Get current policy deploy status by policies* test
                           ...  keywords:
                           ...  PCC.Get Policy Deploy Status by Policies

        [Tags]    Only
        ${response}    PCC.Get Policy Deploy Status by Policies
                       ...  Name=dns
                       ...  description=dns-policy-description

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200                     


####################################################################################################################################
#Create policy with invalid/non existing appID (Negative)
####################################################################################################################################
#
#        [Documentation]    *Create policy with invalid/non existing appID* test
#                           ...  keywords:
#                           ...  PCC.Create Policy
#        
#        ${parent1_id}    PCC.Get Scope Id
#                         ...  scope_name=region-1             
#        
#        ${scope1_id}     PCC.Get Scope Id
#                         ...  scope_name=zone-updated
#                         ...  parentID=${parent1_id}
#                         
#        ${parent2_id}    PCC.Get Scope Id
#                         ...  scope_name=zone-2
#                         ...  parentID=${parent1_id}
#                         
#        ${scope2_id}     PCC.Get Scope Id
#                         ...  scope_name=site-1  
#                         ...  parentID=${parent2_id}          
#                      
#        ${response}    PCC.Create Policy
#                       ...  appId=99999
#                       ...  description=invalid-policy-description
#                       ...  scopeIds=[${scope1_id},${scope2_id}]
#                       ...  inputs=[{"name": "parameter1","value": "value1"},{"name": "parameter2","value": "value2"}]
#                       
#                       
#                       Log To Console    ${response}
                       
                       
###################################################################################################################################
Create policy with invalid/non existing scopeIDs (Negative)
###################################################################################################################################

        [Documentation]    *Create policy with invalid/non existing scopeIDs* test
                           ...  keywords:
                           ...  PCC.Create Policy

        [Tags]    Only
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=ntp

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  scopeIds=[13245,24356]
                       ...  description=invalid-policy-description
                       ...  inputs=[{"name": "parameter1","value": "value1"}]


                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
####################################################################################################################################
#Check if appID of a policy must be integer (Negative)
####################################################################################################################################
#
#        [Documentation]    *Check if appID of a policy must be integer* test
#                           ...  keywords:
#                           ...  PCC.Create Policy
#        
#        [Tags]    This        
#        ${parent1_id}    PCC.Get Scope Id
#                         ...  scope_name=region-1             
#        
#        ${scope1_id}     PCC.Get Scope Id
#                         ...  scope_name=zone-updated
#                         ...  parentID=${parent1_id}
#                         
#        ${parent2_id}    PCC.Get Scope Id
#                         ...  scope_name=zone-2
#                         ...  parentID=${parent1_id}
#                         
#        ${scope2_id}     PCC.Get Scope Id
#                         ...  scope_name=site-1  
#                         ...  parentID=${parent2_id}             
#        
#        ## Giving string in app id ##              
#        ${response}    PCC.Create Policy
#                       ...  appId=xyz
#                       ...  scopeIds=[${scope1_id},${scope2_id}]
#                       ...  description=policy-description
#                       ...  inputs=[{"name": "parameter1","value": "value1"},{"name": "parameter2","value": "value2"}]
#                       
#                       
#                       Log To Console    ${response}
#                       
#        
#        ## Giving junk characters in app id ##                
#        ${response}    PCC.Create Policy
#                       ...  appId=@%^&*&!
#                       ...  scopeIds=[${scope1_id},${scope2_id}]
#                       ...  description=policy-description
#                       ...  inputs=[{"name": "parameter1","value": "value1"},{"name": "parameter2","value": "value2"}]
#                       
#                       
#                       Log To Console    ${response}
                       
                       
###################################################################################################################################
Check if scopeID must be integer (Negative)
###################################################################################################################################

        [Documentation]    *Check if scopeID must be integer* test
                           ...  keywords:
                           ...  PCC.Create Policy
        [Tags]    Only
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=ntp
        
        ## Giving string in scope id ##
        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  scopeIds=['xyz','abc']
                       ...  description=policy-description
                       ...  inputs=[{"name": "parameter1","value": "value1"}]
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
        
        ## Giving junk characters in scope id ##               
        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  scopeIds=['@$%^&^^','$%#^&@!']
                       ...  description=policy-description
                       ...  inputs=[{"name": "parameter1","value": "value1"}]
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Update appID of policy must not be allowed (Negative)
###################################################################################################################################

        [Documentation]    *Update appID of policy must not be allowed* test
                           ...  keywords:
                           ...  PCC.Update Policy
                       
        ${policy_id}    PCC.Get Policy Id
                        ...  Name=snmp
                        ...  description=user-defined-policy-description
                        Log To Console    ${policy_id}

        ${updated_app_id}    PCC.Get App Id from Policies
                             ...  Name=ntp
                             Log To Console    ${updated_app_id}

        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1             
        
        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}           

        ## Updating app id here ##              
        ${response}    PCC.Update Policy
                       ...  Id=${policy_id} 
                       ...  appId=${updated_app_id}
                       ...  scopeIds=[${scope1_id}]
                       ...  description=user-defined-policy-description
                       ...  inputs=[{"name": "parameter1","value": "value1"},{"name": "parameter2","value": "value2"}]


                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Update description of an existing policy
###################################################################################################################################

        [Documentation]    *Update description of an existing policy* test
                           ...  keywords:
                           ...  PCC.Update Policy
           
        ${policy_id}    PCC.Get Policy Id
                        ...  Name=dns
                        ...  description=dns-policy-description 
                        Log To Console    ${policy_id}
                           

        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=dns
                     Log To Console    ${app_id}
                     
        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1     
                         Log To Console    ${parent1_id}        
        
        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}
                         Log To Console    ${scope1_id}
                         
        ${parent2_id}    PCC.Get Scope Id
                         ...  scope_name=zone-2
                         ...  parentID=${parent1_id}
                         Log To Console    ${parent2_id}
                         
        ${scope2_id}     PCC.Get Scope Id
                         ...  scope_name=site-1  
                         ...  parentID=${parent2_id} 
                         Log To Console    ${scope2_id}            
                      
        ${response}    PCC.Update Policy
                       ...  Id=${policy_id} 
                       ...  appId=${app_id}
                       ...  scopeIds=[${scope1_id},${scope2_id}]
                       ...  description=updated-policy-description
                                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200                       


###################################################################################################################################
Update scopeIDs of an existing policy
###################################################################################################################################

        [Documentation]    *Update scopeIDs of an existing policy* test
                           ...  keywords:
                           ...  PCC.Update Policy
        [Tags]    Policy
        ${policy_id}    PCC.Get Policy Id
                        ...  Name=dns
                        ...  description=updated-policy-description   

        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=dns
                     
        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1     
                         Log To Console    ${parent1_id}
        
        ${scope1_id}    PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}
                         Log To Console    ${scope1_id}
        
        ${response}    PCC.Update Policy
                       ...  Id=${policy_id} 
                       ...  appId=${app_id}
                       ...  scopeIds=[${scope1_id}]
                       ...  description=updated-policy-description
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

##################################################################################################################################
Update inputs name and value of policy must not be allowed (Negative)
###################################################################################################################################

        [Documentation]    *Update inputs name and value of policy must not be allowed* test
                           ...  keywords:
                           ...  PCC.Update Policy

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=dns
                        ...  description=updated-policy-description    

        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=dns

        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1     
                         Log To Console    ${parent1_id}

        ${scope1_id}    PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}
                         Log To Console    ${scope1_id}

        ${response}    PCC.Update Policy
                       ...  Id=${policy_id} 
                       ...  appId=${app_id}
                       ...  scopeIds=[${scope1_id}]
                       ...  description=updated-policy-description
                       ...  inputs=[{"name": "parameter1_updated","value": "value1_updated"},{"name": "parameter2_updated","value": "value2_updated"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
