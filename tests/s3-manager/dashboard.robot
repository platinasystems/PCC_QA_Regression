*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

        ${status}                   Login To S3-Manager
                                    Should Be Equal     ${status}  OK

        ${response}                 S3.Get Organization Statistics
                                    ...  organizationId=1

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200


        ${response}                 S3.Get Endpoint Statistics
                                    ...  endpointId=4

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}

         ${response}                 S3.Get Endpoint Prometheus Statistics
                                    ...  endpointId=4
                                    ...  rgwId=13
                                    ...  stat_name=radosgw_usage_total_objects

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${response}                 S3.Get Organization Billings
                                    ...  organizationId=1

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200


        ${response}                 S3.Get Endpoint Billings
                                    ...  endpointId=4

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}