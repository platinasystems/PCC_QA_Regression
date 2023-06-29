*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

        ${status}                   Login To S3-Manager
                                    Should Be Equal     ${status}  OK

                                    #create user root org and admin role
        ${response}                 S3.Create User
                                    ...  username=platina-user-1@test.com
                                    ...  email=platina-user-1@test.com
                                    ...  password=platina
                                    ...  firstName=platina-user
                                    ...  lastName=platina-user

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Be Equal As Strings    ${status}    200

        ${response}                 S3.Get Users

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Be Equal As Strings    ${status}    200

        ${usr_id}                   S3.Get User Id By Username
                                    ...  username=platina-user-1@test.com

        ${response}                 S3.Update User
                                    ...  id=${usr_id}
                                    ...  username=platina-user-update@test.com
                                    ...  email=platina-user-update@test.com
                                    ...  password=platina
                                    ...  firstName=platina
                                    ...  lastName=platina

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Be Equal As Strings    ${status}    200

        ${response}                 S3.Delete User By Username
                                    ...  username=platina-user-update@test.com

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Be Equal As Strings    ${status}    200