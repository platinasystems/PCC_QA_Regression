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
Create Application credential profile with invalid application (Negative)
###################################################################################################################################

        [Documentation]    *Create Metadata Profile* test
                           ...  keywords:
                           ...  PCC.Add Metadata Profile
        
        
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_invalid_application
                       ...    Type=ceph
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
                       ...    maxBuckets=123
                       
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
        
        ${response}    PCC.Add Metadata Profile
                       ...    Name=profile_with_invalid_type
                       ...    Type=ceph
                       ...    maxBuckets=abc
                       
                       
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

                       
                       
                       

