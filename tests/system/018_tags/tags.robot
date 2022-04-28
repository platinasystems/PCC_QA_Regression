*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC
###################################################################################################################################


        [Documentation]    *Login to PCC* test

                         Load Server 1 Test Data     ${pcc_setup}

        ${status}        Login To PCC    ${pcc_setup}


###################################################################################################################################
Create Tags
###################################################################################################################################

        [Documentation]    *Create Tag*


        ${response}      PCC.Create Tag
                    ...  Name=tag-1
                    ...  Description=tag-1

                        ${result}    Get Result    ${response}
                        ${status}    Get From Dictionary    ${result}    status
                        ${message}    Get From Dictionary    ${result}    message
                        Should Be Equal As Strings    ${status}    200

        ${response}      PCC.Create Tag
                    ...  Name=tag-2
                    ...  Description=tag-2

                        ${result}    Get Result    ${response}
                        ${status}    Get From Dictionary    ${result}    status
                        ${message}    Get From Dictionary    ${result}    message
                        Should Be Equal As Strings    ${status}    200


###################################################################################################################################
Create And Apply Policies To Tags
###################################################################################################################################

        [Documentation]    *Create And Apply Policies To Tags*

        ${response}                  PCC.Add Certificate
                                ...  Alias=cert-tag-1
                                ...  Description=cert-tag-1
                                ...  Private_key=domain.key
                                ...  Certificate_upload=domain.crt

                                     Log To Console    ${response}
        ${result}                    Get Result    ${response}
        ${status}                    Get From Dictionary    ${result}    statusCodeValue
                                     Should Be Equal As Strings    ${status}    200

        ${response}                  PCC.Add Certificate
                                ...  Alias=cert-tag-2
                                ...  Description=cert-tag-2
                                ...  Private_key=domain-lb.key
                                ...  Certificate_upload=domain-lb.crt

                                     Log To Console    ${response}
        ${result}                    Get Result    ${response}
        ${status}                    Get From Dictionary    ${result}    statusCodeValue
                                     Should Be Equal As Strings    ${status}    200

        ${response}                  PCC.Add Certificate
                                ...  Alias=cert-scope
                                ...  Description=cert-scope
                                ...  Private_key=domain-lb.key
                                ...  Certificate_upload=domain-lb.crt

                                     Log To Console    ${response}
        ${result}                    Get Result    ${response}
        ${status}                    Get From Dictionary    ${result}    statusCodeValue
                                     Should Be Equal As Strings    ${status}    200


        ${cert_tag_1}               PCC.Get Certificate Id
                               ...  Alias=cert-tag-1
                                    Log To Console    ${cert_tag_1}

        ${cert_tag_2}               PCC.Get Certificate Id
                               ...  Alias=cert-tag-2
                                    Log To Console    ${cert_tag_2}

        ${cert_scope}               PCC.Get Certificate Id
                               ...  Alias=cert-scope
                                    Log To Console    ${cert_scope}


        ${app_id}                   PCC.Get App Id from Policies
                               ...  Name=TRUSTED-CA-CERTIFICATE
                                    Log To Console    ${app_id}

        ${response}                  PCC.Create Policy
                                ...  appId=${app_id}
                                ...  description=policy-tag-1
                                ...  inputs=[{"name": "ca_certificate_list","value": "${cert_tag_1}"}]

                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    ${data}      Get From Dictionary    ${result}    Data
                                    ${policy_tag_1_id}      Get From Dictionary    ${data}     id
                                    Should Be Equal As Strings    ${status}    200

        ${response}                  PCC.Create Policy
                                ...  appId=${app_id}
                                ...  description=policy-tag-2
                                ...  inputs=[{"name": "ca_certificate_list","value": "${cert_tag_2}"}]

                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    ${data}      Get From Dictionary    ${result}    Data
                                    ${policy_tag_2_id}      Get From Dictionary    ${data}     id
                                    Should Be Equal As Strings    ${status}    200


        ${parent1_id}                PCC.Get Scope Id
                                     ...  scope_name=Default region

        ${scope1_id}                 PCC.Get Scope Id
                                     ...  scope_name=Default zone
                                     ...  parentID=${parent1_id}

        ${parent2_id}                PCC.Get Scope Id
                                     ...  scope_name=Default site
                                     ...  parentID=${scope1_id}

        ${scope2_id}                 PCC.Get Scope Id
                                     ...  scope_name=Default rack
                                     ...  parentID=${parent2_id}

#        ${response}                  PCC.Create Policy
#                                ...  appId=${app_id}
#                                ...  description=policy-scope
#                                ...  inputs=[{"name": "ca_certificate_list","value": "${cert_scope}"}]
#                                ...  scopeIds=[${scope2_id}]
#
#                                    ${result}    Get Result    ${response}
#                                    ${status}    Get From Dictionary    ${result}    status
#                                    Should Be Equal As Strings    ${status}    200

        ${tag_1}                       PCC.Get Tag By Name
                                ...    Name=tag-1
        ${tag_1_id}                    Get From Dictionary    ${tag_1}    id


        ${tag_2}                       PCC.Get Tag By Name
                                ...    Name=tag-2
        ${tag_2_id}                    Get From Dictionary    ${tag_2}    id


        ${response}                 PCC.Edit Tag
                                ...  Id=${tag_1_id}
                                ...  Name=tag-1
                                ...  PolicyIDs=[${policy_tag_1_id}]

                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    Should Be Equal As Strings    ${status}    200

        ${response}                 PCC.Edit Tag
                                ...  Id=${tag_2_id}
                                ...  Name=tag-2
                                ...  PolicyIDs=[${policy_tag_2_id}]

                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    Should Be Equal As Strings    ${status}    200


###################################################################################################################################
Verify Scope Policy Backend
###################################################################################################################################
    [Documentation]                 *Verify Scope Policy Backend*

    ${result}                PCC.Verify Certificate On Node
                        ...  ip=${SERVER_1_HOST_IP}
                        ...  Alias=rgw-crt

                             Should Be Equal As Strings    ${result}    OK

###################################################################################################################################
Add Tag-1 To Node
###################################################################################################################################
    [Documentation]                 *Add Tag-1 To Node*

    ${result}                PCC.Add and Verify Tags On Nodes
                        ...  nodes=["${SERVER_1_NAME}"]
                        ...  tags=["tag-1"]

                             Should Be Equal As Strings    ${result}    OK

    ${node_wait_status}      PCC.Wait Until Node Ready
                        ...  Name=${SERVER_1_NAME}

                             Should Be Equal As Strings    ${node_wait_status}    OK


###################################################################################################################################
Verify Tag Policy Priority Over Scope Backend
###################################################################################################################################
    [Documentation]                 *Verify Tag Policy Priority Over Scope Backend*

    ${result}                PCC.Verify Certificate On Node
                        ...  ip=${SERVER_1_HOST_IP}
                        ...  Alias=cert-tag-1

                             Should Be Equal As Strings    ${result}    OK


###################################################################################################################################
Add [tag-2,tag-1] To Node
###################################################################################################################################
    [Documentation]                 *Add Tag To Node*

    ${result}                PCC.Add and Verify Tags On Nodes
                        ...  nodes=["${SERVER_1_NAME}"]
                        ...  tags=["tag-2","tag-1"]

                             Should Be Equal As Strings    ${result}    OK

    ${node_wait_status}      PCC.Wait Until Node Ready
                        ...  Name=${SERVER_1_NAME}

                             Should Be Equal As Strings    ${node_wait_status}    OK

###################################################################################################################################
Verify Tag Policy Priority Over Tag List Backend
###################################################################################################################################
    [Documentation]                 *Verify Tag Policy Priority Over Tag List Backend*

    ${result}                PCC.Verify Certificate On Node
                        ...  ip=${SERVER_1_HOST_IP}
                        ...  Alias=cert-tag-2

                             Should Be Equal As Strings    ${result}    OK

###################################################################################################################################
Remove Tags From Node
###################################################################################################################################
    [Documentation]                 *Add Tag To Node*

    ${result}                PCC.Add and Verify Tags On Nodes
                        ...  nodes=["${SERVER_1_NAME}"]
                        ...  tags=[]

                             Should Be Equal As Strings    ${result}    OK

    ${node_wait_status}      PCC.Wait Until Node Ready
                        ...  Name=${SERVER_1_NAME}

                             Should Be Equal As Strings    ${node_wait_status}    OK



###################################################################################################################################
Unassign Tags From Policies
###################################################################################################################################
    [Documentation]          *Unassign Tags From Policies*

        ${tag_1}                     PCC.Get Tag By Name
                                ...  Name=tag-1
        ${tag_1_id}                  Get From Dictionary    ${tag_1}    id


        ${tag_2}                     PCC.Get Tag By Name
                                ...  Name=tag-2
        ${tag_2_id}                  Get From Dictionary    ${tag_2}    id


        ${response}                  PCC.Edit Tag
                                ...  Id=${tag_1_id}
                                ...  Name=tag-1

                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    Should Be Equal As Strings    ${status}    200

        ${response}                  PCC.Edit Tag
                                ...  Id=${tag_2_id}
                                ...  Name=tag-2

                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    Should Be Equal As Strings    ${status}    200




