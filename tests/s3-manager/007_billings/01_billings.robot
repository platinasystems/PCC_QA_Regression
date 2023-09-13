*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***
###################################################################################################################################
Login To S3-Manager
###################################################################################################################################
                                    Load Endpoint Test Data    ${s3_setup}
                                    Load Organization Data      ${s3_setup}

        ${status}                   Login To S3-Manager     testdata_key=${s3_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Get Organization
###################################################################################################################################

        ${org_id}                   S3.Get Organization Id By Name
                                    ...  name=${ORG_NAME}

                                    Set Suite Variable      ${org_id}

###################################################################################################################################
Get Organization Billings
###################################################################################################################################
        ${response}                 S3.Get Organization Billings
                                    ...  organizationId=${org_id}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Get Endpoint Billings
###################################################################################################################################
        ${endpoint_id}              S3.Get Endpoint Id By Name
                                    ...  name=${ATTACHED_ENDPOINT_NAME}

        ${response}                 S3.Get Endpoint Billings
                                    ...  endpointId=${endpoint_id}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200