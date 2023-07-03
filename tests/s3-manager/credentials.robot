*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

        ${status}                   Login To S3-Manager
                                    Should Be Equal     ${status}  OK

        ${endpoint_id}              S3.Get Endpoint Id By Name
                                    ...  name=test-endpoint

        ${response}                 S3.Create S3 Credential
                                    ...  endpointId=${endpoint_id}
                                    ...  name=test-app-cred
                                    ...  description=test-app-cred

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${response}                 S3.Get S3 Credentials
                                    ...  endpointId=${endpoint_id}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200


        ${credential_id}            S3.Get S3 Credential Id By Name
                                    ...  endpointId=${endpoint_id}
                                    ...  name=test-app-cred

                                    Log To Console      ${credential_id}

                                    sleep  1m

        ${response}                 S3.Update S3 Credential
                                    ...  id=${credential_id}
                                    ...  endpointId=${endpoint_id}
                                    ...  name=test-app-cred-updt
                                    ...  description=test-app-cred update


        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${response}                 S3.Delete S3 Credential
                                    ...  id=${credential_id}
                                    ...  endpointId=${endpoint_id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200