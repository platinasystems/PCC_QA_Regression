*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***
###################################################################################################################################
Login To S3-Manager
###################################################################################################################################
                                    Load Endpoint Test Data    ${s3_setup}
                                    Load S3 Credential Test Data        ${s3_setup}


        ${status}                   Login To S3-Manager     testdata_key=${s3_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Create S3 Credetial Without Name (NEGATIVE)
###################################################################################################################################

        ${endpoint_id}              S3.Get Endpoint Id By Name
                                    ...  name=${ATTACHED_ENDPOINT_NAME}
                                    Set Suite Variable      ${endpoint_id}

        ${response}                 S3.Create S3 Credential
                                    ...  endpointId=${endpoint_id}
                                    ...  description=test-app-cred

                                    log to console      ${response}
        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create S3 Credetial Without Endpoint (NEGATIVE)
###################################################################################################################################

        ${endpoint_id}              S3.Get Endpoint Id By Name
                                    ...  name=${ATTACHED_ENDPOINT_NAME}
                                    Set Suite Variable      ${endpoint_id}

        ${response}                 S3.Create S3 Credential
                                    ...  name=${CREDENTIAL_NAME}
                                    ...  description=test-app-cred

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create S3 Credetial
###################################################################################################################################

        ${endpoint_id}              S3.Get Endpoint Id By Name
                                    ...  name=${ATTACHED_ENDPOINT_NAME}
                                    Set Suite Variable      ${endpoint_id}

        ${response}                 S3.Create S3 Credential
                                    ...  endpointId=${endpoint_id}
                                    ...  name=${CREDENTIAL_NAME}
                                    ...  description=test-app-cred

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   S3.Wait Until Credential Ready
                                    ...  endpointId=${endpoint_id}
                                    ...  name=${CREDENTIAL_NAME}
                                    Should Be Equal As Strings      ${status}  OK


###################################################################################################################################
Get All S3 Credetials
###################################################################################################################################

        ${response}                 S3.Get S3 Credentials
                                    ...  endpointId=${endpoint_id}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Get S3 Credetial Id
###################################################################################################################################

        ${credential_id}            S3.Get S3 Credential Id By Name
                                    ...  endpointId=${endpoint_id}
                                    ...  name=${CREDENTIAL_NAME}

                                    Set Suite Variable      ${credential_id}

###################################################################################################################################
Update S3 Credetial Without Endpoint (NEGATIVE)
###################################################################################################################################

        ${response}                 S3.Update S3 Credential
                                    ...  id=${credential_id}
                                    ...  name=${CREDENTIAL_NAME}
                                    ...  description=test-app-cred update

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Update S3 Credetial
###################################################################################################################################

        ${response}                 S3.Update S3 Credential
                                    ...  id=${credential_id}
                                    ...  endpointId=${endpoint_id}
                                    ...  name=test-app-cred-updt
                                    ...  description=test-app-cred update

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   S3.Wait Until Credential Ready
                                    ...  endpointId=${endpoint_id}
                                    ...  name=${CREDENTIAL_NAME}
                                    Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Delete S3 Credetial
###################################################################################################################################

        ${response}                 S3.Delete S3 Credential
                                    ...  id=${credential_id}
                                    ...  endpointId=${endpoint_id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   S3.Wait Until Credential Deleted
                                    ...  endpointId=${endpoint_id}
                                    ...  name=${CREDENTIAL_NAME}
                                    Should Be Equal As Strings      ${status}  OK