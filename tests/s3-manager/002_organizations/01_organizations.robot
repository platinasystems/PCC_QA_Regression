*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***
###################################################################################################################################
Login To S3-Manager
###################################################################################################################################

                                    Load Organization Data      ${s3_setup}

        ${status}                   Login To S3-Manager     testdata_key=${s3_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Create Organization
###################################################################################################################################

        ${response}                 S3.Create Organization
                                    ...  name=${ORG_NAME}
                                    ...  description=${ORG_DESC}
                                    ...  username=${ORG_USERNAME}
                                    ...  email=${ORG_EMAIL}
                                    ...  password=${ORG_PASSWORD}
                                    ...  firstName=${ORG_FIRSTNAME}
                                    ...  lastName=${ORG_LASTNAME}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Get All Organizations
###################################################################################################################################

        ${response}                 S3.Get Organizations

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Get Organization
###################################################################################################################################

        ${org_id}                   S3.Get Organization Id By Name
                                    ...  name=${ORG_NAME}

                                    Set Suite Variable      ${org_id}

###################################################################################################################################
Update Organization
###################################################################################################################################

        ${response}                 S3.Update Organization
                                    ...  id=${org_id}
                                    ...  name=test-org-rename
                                    ...  description=test org update
                                    ...  username=${ORG_USERNAME}
                                    ...  email=${ORG_EMAIL}
                                    ...  password=${ORG_PASSWORD}
                                    ...  firstName=${ORG_FIRSTNAME}
                                    ...  lastName=${ORG_LASTNAME}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Delete Organization With User (Negative)
###################################################################################################################################

        ${response}                 S3.Delete Organization
                                    ...  id=${org_id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Delete Organization
###################################################################################################################################

        ${response}                 S3.Delete User By Username
                                    ...  username=${ORG_USERNAME}

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Be Equal As Strings    ${status}    200

        ${response}                 S3.Delete Organization
                                    ...  id=${org_id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200