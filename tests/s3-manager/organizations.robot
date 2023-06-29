*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

        ${status}                   Login To S3-Manager
                                    Should Be Equal     ${status}  OK


        ${response}                 S3.Create Organization
                                    ...  name=platina
                                    ...  description=platina org
                                    ...  username=platina@test.com
                                    ...  email=platina@test.com
                                    ...  password=platina
                                    ...  firstName=platina
                                    ...  lastName=platina

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${response}                 S3.Get Organizations

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${org_id}                   S3.Get Organization Id By Name
                                    ...  name=platina

        ${response}                 S3.Update Organization
                                    ...  id=${org_id}
                                    ...  name=platina-rename
                                    ...  description=platina org update
                                    ...  username=platina@test.com
                                    ...  email=platina@test.com
                                    ...  password=platina
                                    ...  firstName=platina
                                    ...  lastName=platina

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${response}                 S3.Delete Organization
                                    ...  id=${org_id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200