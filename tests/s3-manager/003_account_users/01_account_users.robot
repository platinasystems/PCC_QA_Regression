*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***
###################################################################################################################################
Login To S3-Manager
###################################################################################################################################

                                    Load User Data      ${s3_setup}

        ${status}                   Login To S3-Manager     testdata_key=${s3_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Create User Without Username (NEGATIVE)
###################################################################################################################################
        ${response}                 S3.Create User
                                    ...  email=${USER_EMAIL}
                                    ...  password=${USER_PASSWORD}
                                    ...  firstName=${USER_FIRSTNAME}
                                    ...  lastName=${USER_LASTNAME}
                                    ...  roleID=${1}

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Not Be Equal As Strings    ${status}    200

###################################################################################################################################
Create User Without FirstName (NEGATIVE)
###################################################################################################################################
                                    #create user root org and admin role
        ${response}                 S3.Create User
                                    ...  username=${USER_USERNAME}
                                    ...  email=${USER_EMAIL}
                                    ...  password=${USER_PASSWORD}
                                    ...  lastName=${USER_LASTNAME}
                                    ...  roleID=${1}

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Not Be Equal As Strings    ${status}    200

###################################################################################################################################
Create User Without LastName (NEGATIVE)
###################################################################################################################################
                                    #create user root org and admin role
        ${response}                 S3.Create User
                                    ...  username=${USER_USERNAME}
                                    ...  email=${USER_EMAIL}
                                    ...  password=${USER_PASSWORD}
                                    ...  firstName=${USER_FIRSTNAME}
                                    ...  roleID=${1}

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Not Be Equal As Strings    ${status}    200

###################################################################################################################################
Create User Without Role (NEGATIVE)
###################################################################################################################################
                                    #create user root org and admin role
        ${response}                 S3.Create User
                                    ...  username=${USER_USERNAME}
                                    ...  email=${USER_EMAIL}
                                    ...  password=${USER_PASSWORD}
                                    ...  firstName=${USER_FIRSTNAME}
                                    ...  lastName=${USER_LASTNAME}

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Not Be Equal As Strings    ${status}    200

###################################################################################################################################
Create User With Root Organization and Admin Role
###################################################################################################################################
                                    #create user root org and admin role
        ${response}                 S3.Create User
                                    ...  username=${USER_USERNAME}
                                    ...  email=${USER_EMAIL}
                                    ...  password=${USER_PASSWORD}
                                    ...  firstName=${USER_FIRSTNAME}
                                    ...  lastName=${USER_LASTNAME}
                                    ...  roleID=${1}

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Get All Users
###################################################################################################################################

        ${response}                 S3.Get Users

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Be Equal As Strings    ${status}    200


###################################################################################################################################
Get User Id
###################################################################################################################################

        ${usr_id}                   S3.Get User Id By Username
                                    ...  username=${USER_USERNAME}

                                    Set Suite Variable      ${usr_id}

###################################################################################################################################
Update User Without Username (NEGATIVE)
###################################################################################################################################
        ${response}                 S3.Update User
                                    ...  id=${usr_id}
                                    ...  email=${USER_EMAIL}
                                    ...  password=${USER_PASSWORD}
                                    ...  firstName=${USER_FIRSTNAME}
                                    ...  lastName=${USER_LASTNAME}
                                    ...  roleID=${1}

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Not Be Equal As Strings    ${status}    200

###################################################################################################################################
Update User Without FirstName (NEGATIVE)
###################################################################################################################################
        ${response}                 S3.Update User
                                    ...  id=${usr_id}
                                    ...  username=${USER_USERNAME}
                                    ...  email=${USER_EMAIL}
                                    ...  password=${USER_PASSWORD}
                                    ...  lastName=${USER_LASTNAME}
                                    ...  roleID=${1}

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Not Be Equal As Strings    ${status}    200

###################################################################################################################################
Update User Without LastName (NEGATIVE)
###################################################################################################################################
        ${response}                 S3.Update User
                                    ...  id=${usr_id}
                                    ...  username=${USER_USERNAME}
                                    ...  email=${USER_EMAIL}
                                    ...  password=${USER_PASSWORD}
                                    ...  firstName=${USER_FIRSTNAME}
                                    ...  roleID=${1}

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Not Be Equal As Strings    ${status}    200

###################################################################################################################################
Update User
###################################################################################################################################
        ${response}                 S3.Update User
                                    ...  id=${usr_id}
                                    ...  username=platina-user-update@test.com
                                    ...  email=platina-user-update@test.com
                                    ...  password=${USER_PASSWORD}
                                    ...  firstName=${USER_FIRSTNAME}
                                    ...  lastName=${USER_LASTNAME}
                                    ...  roleID=${1}

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Be Equal As Strings    ${status}    200


###################################################################################################################################
Delete User
###################################################################################################################################
        ${response}                 S3.Delete User By Username
                                    ...  username=platina-user-update@test.com

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Be Equal As Strings    ${status}    200