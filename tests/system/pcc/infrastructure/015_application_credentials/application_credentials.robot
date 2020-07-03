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
                         
###################################################################################################################################
Create Application credential profile without application
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile
        
        
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_without_app
                       ...    Type=ceph
                       ...    Username=profile_without_app
                       ...    Email=profile_without_app@gmail.com
                       ...    Active=True
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
####################################################################################################################################
#Create Application credential profile with application
####################################################################################################################################
#
#        [Documentation]    *Create Metadata Profile* test
#                           ...  keywords:
#                           ...  PCC.Add Metadata Profile
#        
#        
#        
#        ${response}    PCC.Add Metadata Profile
#                       ...    Name=profile_with_app
#                       ...    Type=ceph
#                       ...    Username=profile_with_app
#                       ...    Email=profile_with_app@gmail.com
#                       ...    Active=True
#                       ...    ApplicationId= ##to be done
#                       
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Be Equal As Strings    ${status}    200
                       
##To Do
###################################################################################################################################
#Update application in already existing metadata profile
###################################################################################################################################

##To Do
###################################################################################################################################
#Profile name should not be modified (Negative)
###################################################################################################################################
                       

###################################################################################################################################
Get Profile by Id 
###################################################################################################################################

        [Documentation]    *Get Profile by Id* test
                           ...  keywords:
                           ...  PCC.Get Profile by Id
        
        
        
        ${response}    PCC.Get Profile by Id
                       ...    Name=profile_without_app
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Get Profile By Type
###################################################################################################################################

        [Documentation]    *Get Profile By Type* test
                           ...  keywords:
                           ...  PCC.Get Profile By Type
        
        
        
        ${response}    PCC.Get Profile By Type
                       ...    Type=ceph
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200                       
                       
                       

###################################################################################################################################
Get Metadata Profile By Type
###################################################################################################################################

        [Documentation]    *Get Metadata Profile By Type* test
                           ...  keywords:
                           ...  PCC.Get Metadata Profile By Type
        
        
        
        ${response}    PCC.Get Metadata Profile By Type
                       ...    Type=ceph
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Get Profiles
###################################################################################################################################

        [Documentation]    *Get Profiles* test
                           ...  keywords:
                           ...  PCC.Get Profiles
        
        
        
        ${response}    PCC.Get Profiles
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200                        
 
####################################################################################################################################
#Get the profiles with additional data for a specific application
####################################################################################################################################
#
#        [Documentation]    *Get the profiles with additional data for a specific application* test
#                           ...  keywords:
#                           ...  PCC.Get Profiles with additional data for specific application
#        
#        
#        
#        ${response}    PCC.Get Profiles with additional data for specific application
#                       ...    Type=ceph
#                       ...    ApplicationId= ##To Do
#                       
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Be Equal As Strings    ${status}    200 


###################################################################################################################################
Get Metadata Profiles 
###################################################################################################################################

        [Documentation]    *Get Metadata Profiles * test
                           ...  keywords:
                           ...  PCC.Get Metadata Profiles 
        
        
        
        ${response}    PCC.Get Metadata Profiles 
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200 
                       
###################################################################################################################################
Describe Profile By Id
###################################################################################################################################

        [Documentation]    *Describe Profile By Id* test
                           ...  keywords:
                           ...  PCC.Describe Profile By Id
        
        
        
        ${response}    PCC.Describe Profile By Id
                       ...    Name=profile_without_app 
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200 
                       

###################################################################################################################################
Describe Profile per Type
###################################################################################################################################

        [Documentation]    *Describe Profile per Type* test
                           ...  keywords:
                           ...  PCC.Describe Profile per Type
        
        
        
        ${response}    PCC.Describe Profile per Type
                       ...    Type=ceph
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200           
                       
                       
####################################################################################################################################
#Describe Profiles per type and application
####################################################################################################################################
#
#        [Documentation]    *Describe Profiles per type and application* test
#                           ...  keywords:
#                           ...  PCC.Describe Profiles per type and application
#        
#        ${response}    PCC.Describe Profiles per type and application
#                       ...    Type=ceph
#                       ...    ApplicationId= ## To Do
#                       
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Be Equal As Strings    ${status}    200


###################################################################################################################################
Describe Metadata Profile per Type
###################################################################################################################################

        [Documentation]    *Describe Metadata Profile per Type* test
                           ...  keywords:
                           ...  PCC.Describe Metadata Profile per Type
        
        
        
        ${response}    PCC.Describe Metadata Profile per Type
                       ...    Type=ceph
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200



###################################################################################################################################
Describe Profiles
###################################################################################################################################

        [Documentation]    *Describe Profiles* test
                           ...  keywords:
                           ...  PCC.Describe Profiles
        
        
        
        ${response}    PCC.Describe Profiles
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Describe Metadata Profiles
###################################################################################################################################

        [Documentation]    *Describe Metadata Profiles* test
                           ...  keywords:
                           ...  PCC.Describe Metadata Profiles
        
        
        
        ${response}    PCC.Describe Metadata Profiles
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Get Profile Types
###################################################################################################################################

        [Documentation]    *Get Profile Types* test
                           ...  keywords:
                           ...  PCC.Get Profile Types
        
        
        
        ${response}    PCC.Get Profile Types
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Get Profile Template Per Type
###################################################################################################################################

        [Documentation]    *Get Profile Template Per Type* test
                           ...  keywords:
                           ...  PCC.Get Profile Template Per Type
        
        
        
        ${response}    PCC.Get Profile Template Per Type
                       ...    Type=ceph   
        
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Create Application credential profile without active state
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile
        
        
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_without_active
                       ...    Type=ceph
                       ...    Username=profile_without_active
                       ...    Email=profile_without_active@gmail.com
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Creating App-credential profile with invalid type (Negative)
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile
        
        
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_invalid_type
                       ...    Type=k8s
                       ...    Username=profile_with_invalid_type
                       ...    Email=profile_with_invalid_type@gmail.com
                       ...    Active=True
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       

###################################################################################################################################
Creating App-credential profile without name (Negative)
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile
        
        
        
        ${response}    PCC.Add Metadata Profile
                       ...    Type=ceph
                       ...    Username=profile_without_name
                       ...    Email=profile_without_name@gmail.com
                       ...    Active=True
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Creating App-credential profile without type (Negative)
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile
        
        
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_without_type
                       ...    Username=profile_without_type
                       ...    Email=profile_without_type@gmail.com
                       ...    Active=True
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Creating App-credential profile without user-name(Negative)
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile
        
        
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_without_username
                       ...    Type=ceph
                       ...    Email=profile_without_username@gmail.com
                       ...    Active=True
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200




###################################################################################################################################
Delete Metadata Profile
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Delete Profile By Id
        
        
        
        ${response}    PCC.Delete Profile By Id
                       ...    Name=profile_without_app 
                       
                       Log To Console    ${response}
                       
###################################################################################################################################
Delete All Profiles
###################################################################################################################################

        [Documentation]    *PCC.Delete All Profiles* test
                           ...  keywords:
                           ...  PCC.Delete All Profiles
        
        
        
        ${response}    PCC.Delete All Profiles
                       
                       Log To Console    ${response}
                       
                       

