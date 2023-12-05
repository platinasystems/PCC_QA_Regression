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
                         Should Be Equal    ${status}  OK
                         
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         
                         Load Container Registry Data    ${pcc_setup}
                         Load Auth Profile Data    ${pcc_setup}
                         
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
Check if Auth Profile is getting updated if Name is null
###################################################################################################################################
        
        [Documentation]    *Name validation on Auth Profile, if Name is null* test
                           ...  keywords:
                           ...  PCC.Update Auth Profile        

        
        ${response}    PCC.Update Auth Profile 
                       
                       ...    Name=""
                       ...    type_auth=${AUTH_PROFILE_TYPE}
                       ...    domain=${AUTH_PROFILE_DOMAIN}
                       ...    port=${AUTH_PROFILE_PORT}
                       ...    userIDAttribute=${AUTH_PROFILE_UID_ATTRIBUTE}
                       ...    userBaseDN=${AUTH_PROFILE_UBDN}
                       ...    groupBaseDN=${AUTH_PROFILE_GBDN}
                       ...    anonymousBind=${AUTH_PROFILE_ANONYMOUSBIND}
                       ...    bindDN=${AUTH_PROFILE_BIND_DN}
                       ...    bindPassword=${AUTH_PROFILE_BIND_PWD}
                       ...    encryptionPolicy=${AUTH_PROFILE_ENCRYPTION}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal    "${status}"    "200"
                       
        
###################################################################################################################################
Check if Auth Profile is getting updated if Name is invalid
###################################################################################################################################
        
        [Documentation]    *Name validation on Auth Profile, if Name is invalid* test
                           ...  keywords:
                           ...  PCC.Update Auth Profile  
                           
                                 
        ${response}    PCC.Update Auth Profile 
                       
                       ...    Name=${AUTH_PROFILE_INVALID_NAME}
                       ...    type_auth=${AUTH_PROFILE_TYPE}
                       ...    domain=${AUTH_PROFILE_DOMAIN}
                       ...    port=${AUTH_PROFILE_PORT}
                       ...    userIDAttribute=${AUTH_PROFILE_UID_ATTRIBUTE}
                       ...    userBaseDN=${AUTH_PROFILE_UBDN}
                       ...    groupBaseDN=${AUTH_PROFILE_GBDN}
                       ...    anonymousBind=${AUTH_PROFILE_ANONYMOUSBIND}
                       ...    bindDN=${AUTH_PROFILE_BIND_DN}
                       ...    bindPassword=${AUTH_PROFILE_BIND_PWD}
                       ...    encryptionPolicy=${AUTH_PROFILE_ENCRYPTION}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal    "${status}"    "200"
                       
###################################################################################################################################
Check if Auth Profile is getting updated if Domain is null
###################################################################################################################################
        
        [Documentation]    *Domain validation on Auth Profile, if Domain is null* test
                           ...  keywords:
                           ...  PCC.Update Auth Profile
                           
        
        ${response}    PCC.Update Auth Profile 
                       ...    Name=${AUTH_PROFILE_NAME}
                       ...    type_auth=${AUTH_PROFILE_TYPE}
                       ...    domain=""
                       ...    port=${AUTH_PROFILE_PORT}
                       ...    userIDAttribute=${AUTH_PROFILE_UID_ATTRIBUTE}
                       ...    userBaseDN=${AUTH_PROFILE_UBDN}
                       ...    groupBaseDN=${AUTH_PROFILE_GBDN}
                       ...    anonymousBind=${AUTH_PROFILE_ANONYMOUSBIND}
                       ...    bindDN=${AUTH_PROFILE_BIND_DN}
                       ...    bindPassword=${AUTH_PROFILE_BIND_PWD}
                       ...    encryptionPolicy=${AUTH_PROFILE_ENCRYPTION}
                

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal    "${status}"    "200"
                       
        
        
###################################################################################################################################
Check if Auth Profile is getting updated if Domain is invalid
###################################################################################################################################
        
        [Documentation]    *Domain validation on Auth Profile, if Domain is invalid* test
                           ...  keywords:
                           ...  PCC.Update Auth Profile
                                 
                       
        ${response}    PCC.Update Auth Profile 
                       ...    Name=${AUTH_PROFILE_NAME}
                       ...    type_auth=${AUTH_PROFILE_TYPE}
                       ...    domain=${AUTH_PROFILE_INVALID_DOMAIN}
                       ...    port=${AUTH_PROFILE_PORT}
                       ...    userIDAttribute=${AUTH_PROFILE_UID_ATTRIBUTE}
                       ...    userBaseDN=${AUTH_PROFILE_UBDN}
                       ...    groupBaseDN=${AUTH_PROFILE_GBDN}
                       ...    anonymousBind=${AUTH_PROFILE_ANONYMOUSBIND}
                       ...    bindDN=${AUTH_PROFILE_BIND_DN}
                       ...    bindPassword=${AUTH_PROFILE_BIND_PWD}
                       ...    encryptionPolicy=${AUTH_PROFILE_ENCRYPTION}
                

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal    "${status}"    "200"

###################################################################################################################################
Check if Auth Profile is getting updated if User Base DN is null
###################################################################################################################################
        
        [Documentation]    *User Base DN validation on Auth Profile, if User Base DN is null* test
                           ...  keywords:
                           ...  PCC.Update Auth Profile 
        
        
        ${response}    PCC.Update Auth Profile 
                       ...    Name=${AUTH_PROFILE_NAME}
                       ...    type_auth=${AUTH_PROFILE_TYPE}
                       ...    domain=${AUTH_PROFILE_DOMAIN}
                       ...    port=${AUTH_PROFILE_PORT}
                       ...    userIDAttribute=${AUTH_PROFILE_UID_ATTRIBUTE}
                       ...    userBaseDN=None
                       ...    groupBaseDN=${AUTH_PROFILE_GBDN}
                       ...    anonymousBind=${AUTH_PROFILE_ANONYMOUSBIND}
                       ...    bindDN=${AUTH_PROFILE_BIND_DN}
                       ...    bindPassword=${AUTH_PROFILE_BIND_PWD}
                       ...    encryptionPolicy=${AUTH_PROFILE_ENCRYPTION}
                

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal    "${status}"    "200"

####################################################################################################################################
Cleanup Container Registry
####################################################################################################################################

        [Documentation]    *Cleanup all CR* test
                           ...  keywords:
                           ...  PCC.Clean all CR
                           ...  PCC.Wait for deletion of CR

        ${result}    PCC.Clean all CR

                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK


        ${result}    PCC.Wait for deletion of CR

                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK

###################################################################################################################################
Cleanup Auth Profiles
###################################################################################################################################

        [Documentation]    *Clean-up Auth Profiles* test
                           ...  keywords:
                           ...  PCC.Delete All Auth Profile

        [Tags]    Login
        ########  Cleanup Auth Profile   ################################################################################

        ${result}    PCC.Delete All Auth Profile

                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK

                     Sleep    1 minutes
