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

        ${response}                 S3.Create Ticket
                                    ...  endpointId=${endpoint_id}
                                    ...  object=bug-1
                                    ...  message=bug-1

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${response}                 S3.Get Tickets

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200


        ${ticket_id}                S3.Get Tickets Id By Object
                                    ...  object=bug-1

                                    Log To Console      ${ticket_id}


        ${response}                 S3.Update Ticket
                                    ...  id=${ticket_id}
                                    ...  endpointId=${endpoint_id}
                                    ...  object=bug-1
                                    ...  message=bug-1
                                    ...  status=closed

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200
