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
                       
                       
##To Do
###################################################################################################################################
#Update application in already existing metadata profile
###################################################################################################################################

##To Do
###################################################################################################################################
#Profile name should not be modified (Negative)
###################################################################################################################################
                       

                      
                       
                       

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
Create Application credential profile with invalid application (Negative)
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile
        
        
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_invalid_application
                       ...    Type=ceph
                       ...    Username=profile_with_invalid_application
                       ...    Email=profile_without_active@gmail.com
                       ...    Active=True
                       ...    ApplicationId=#$^
                       
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Creating App-credential profile with invalid type (Negative)
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile
        
        
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_invalid_type
                       ...    Type=invalid
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
Check if Maximum Bucket Number accepts only integers as input
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_max_buckets
                       ...    Type=ceph
                       ...    Username=profile_with_max_buckets
                       ...    Email=profile_with_max_buckets@gmail.com
                       ...    Active=True
                       ...    MaxBuckets=123
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_invalid_type
                       ...    Type=ceph
                       ...    Username=profile_with_invalid_type
                       ...    Email=profile_with_invalid_type@gmail.com
                       ...    Active=True
                       ...    MaxBuckets=abc
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Check if Maximum Bucket Objects accepts only integers as input
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_max_buckets_obj
                       ...    Type=ceph
                       ...    Username=profile_with_max_buckets
                       ...    Email=profile_with_max_buckets@gmail.com
                       ...    Active=True
                       ...    maxBucketObjects=123
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_invalid_max_buckets_obj
                       ...    Type=ceph
                       ...    Username=profile_with_max_buckets1
                       ...    Email=profile_with_max_buckets1@gmail.com
                       ...    Active=True
                       ...    maxBucketObjects=abc
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200


###################################################################################################################################
Check if Maximum Bucket Size accepts only integers as input
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_max_bucket_size
                       ...    Type=ceph
                       ...    Username=profile_with_max_bucket_size
                       ...    Email=profile_with_max_bucket_size@gmail.com
                       ...    Active=True
                       ...    maxBucketSize=123
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_max_bucket_size2
                       ...    Type=ceph
                       ...    Username=profile_with_max_bucket_size2
                       ...    Email=profile_with_max_bucket_size2@gmail.com
                       ...    Active=True
                       ...    maxBucketSize=abc
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                                              
###################################################################################################################################
Check if Maximum User Size accepts only integers as input
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_max_user_size
                       ...    Type=ceph
                       ...    Username=profile_with_max_user_size
                       ...    Email=profile_with_max_user_size@gmail.com
                       ...    Active=True
                       ...    maxUserSize=123
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_max_user_size2
                       ...    Type=ceph
                       ...    Username=profile_with_max_user_size2
                       ...    Email=profile_with_max_user_size2@gmail.com
                       ...    Active=True
                       ...    maxUserSize=abc
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200
                       
                       
###################################################################################################################################
Check if Maximum Users Objects accepts only integers as input
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_max_user_objects
                       ...    Type=ceph
                       ...    Username=profile_with_max_user_objects
                       ...    Email=profile_with_max_user_objects@gmail.com
                       ...    Active=True
                       ...    maxUserObjects=123
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_max_user_objects2
                       ...    Type=ceph
                       ...    Username=profile_with_max_user_objects2
                       ...    Email=profile_with_max_user_objects2@gmail.com
                       ...    Active=True
                       ...    maxUserObjects=abc
                       
                       
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
Fetching Profile ID before backup
###################################################################################################################################   

         
        ${profile_id_before_backup}    PCC.Get Profile Id                                  
                                       ...    Name=profile_without_active
                                       Log To Console    ${profile_id_before_backup}
                                       Set Global Variable    ${profile_id_before_backup}
                       
                       
                       

