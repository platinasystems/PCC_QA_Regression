*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***
###################################################################################################################################
Login To S3-Manager
###################################################################################################################################
                                    Load Endpoint Test Data    ${s3_setup}

        ${status}                   Login To S3-Manager     testdata_key=${s3_setup}
                                    Should Be Equal     ${status}  OK


###################################################################################################################################
Create Ticket Without Endpoint (NEGATIVE)
###################################################################################################################################

        ${endpoint_id}              S3.Get Endpoint Id By Name
                                    ...  name=${ATTACHED_ENDPOINT_NAME}

                                    Set Suite Variable      ${endpoint_id}

        ${response}                 S3.Create Ticket
                                    ...  object=bug-1
                                    ...  message=test bug-1
                                    ...  priority=low

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create Ticket Without Subject (NEGATIVE)
###################################################################################################################################

        ${endpoint_id}              S3.Get Endpoint Id By Name
                                    ...  name=${ATTACHED_ENDPOINT_NAME}

                                    Set Suite Variable      ${endpoint_id}

        ${response}                 S3.Create Ticket
                                    ...  endpointId=${endpoint_id}
                                    ...  message=test bug-1
                                    ...  priority=low

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create Ticket Without Message (NEGATIVE)
###################################################################################################################################

        ${endpoint_id}              S3.Get Endpoint Id By Name
                                    ...  name=${ATTACHED_ENDPOINT_NAME}

                                    Set Suite Variable      ${endpoint_id}

        ${response}                 S3.Create Ticket
                                    ...  endpointId=${endpoint_id}
                                    ...  object=bug-1
                                    ...  priority=low

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create Ticket
###################################################################################################################################

        ${endpoint_id}              S3.Get Endpoint Id By Name
                                    ...  name=${ATTACHED_ENDPOINT_NAME}

                                    Set Suite Variable      ${endpoint_id}

        ${response}                 S3.Create Ticket
                                    ...  endpointId=${endpoint_id}
                                    ...  object=bug-1
                                    ...  message=test bug-1
                                    ...  priority=low

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Get All Tickets
###################################################################################################################################

        ${response}                 S3.Get Tickets

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Get Ticket Id
###################################################################################################################################

        ${ticket_id}                S3.Get Tickets Id By Object
                                    ...  object=bug-1

                                    Set Suite Variable      ${ticket_id}

###################################################################################################################################
Update Ticket Without Subject (NEGATIVE)
###################################################################################################################################

        ${endpoint_id}              S3.Get Endpoint Id By Name
                                    ...  name=${ATTACHED_ENDPOINT_NAME}

                                    Set Suite Variable      ${endpoint_id}

        ${response}                 S3.Update Ticket
                                    ...  id=${ticket_id}
                                    ...  endpointId=${endpoint_id}
                                    ...  message=test bug-1
                                    ...  priority=low
                                    ...  status=assigned

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Update Ticket Without Message (NEGATIVE)
###################################################################################################################################

        ${endpoint_id}              S3.Get Endpoint Id By Name
                                    ...  name=${ATTACHED_ENDPOINT_NAME}

                                    Set Suite Variable      ${endpoint_id}

        ${response}                 S3.Update Ticket
                                    ...  id=${ticket_id}
                                    ...  endpointId=${endpoint_id}
                                    ...  object=bug-1
                                    ...  priority=low
                                    ...  status=assigned

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

####################################################################################################################################
#Update Ticket Without Status (NEGATIVE)
####################################################################################################################################
#
#        ${endpoint_id}              S3.Get Endpoint Id By Name
#                                    ...  name=${ATTACHED_ENDPOINT_NAME}
#
#                                    Set Suite Variable      ${endpoint_id}
#
#        ${response}                 S3.Update Ticket
#                                    ...  id=${ticket_id}
#                                    ...  endpointId=${endpoint_id}
#                                    ...  object=bug-1
#                                    ...  message=test bug-1
#                                    ...  priority=low
#
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${data}                     Get Response Data        ${response}
#                                    Log To Console      ${data}
#                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Update Ticket
###################################################################################################################################
        ${response}                 S3.Update Ticket
                                    ...  id=${ticket_id}
                                    ...  endpointId=${endpoint_id}
                                    ...  object=bug-1
                                    ...  message=bug-1
                                    ...  status=closed
                                    ...  priority=low

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200