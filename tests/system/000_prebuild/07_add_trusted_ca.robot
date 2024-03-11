*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212


*** Test Cases ***
###################################################################################################################################
Login to PCC
###################################################################################################################################
                        Load Ceph Rgw Data    ${pcc_setup}
                        Load Ceph Rgw Data Secondary    ${pcc_setup}
                        Load Clusterhead 1 Test Data    ${pcc_setup}
                        Load Server 1 Test Data     ${pcc_setup}
                        Load Server 2 Test Data     ${pcc_setup}
                        Load Server 3 Test Data     ${pcc_setup}


        ${status}        Login To PCC    ${pcc_setup}

##################################################################################################################################
Ceph Certificate For Rgws
###################################################################################################################################

        [Documentation]              *Ceph Ceph Certificate For Rgws*
        #[Tags]    This
        ${cert_id}                   PCC.Get Certificate Id
                                ...  Alias=${CEPH_RGW_CERT_NAME}
                                     Pass Execution If    ${cert_id} is not ${None}    Certificate is already there

        ${response}                  PCC.Add Certificate
                                ...  Alias=${CEPH_RGW_CERT_NAME}
                                ...  Description=certificate-for-rgw
                                ...  Private_key=domain.key
                                ...  Certificate_upload=domain.crt

                                     Log To Console    ${response}
        ${result}                    Get Result    ${response}
        ${status}                    Get From Dictionary    ${result}    statusCodeValue
                                     Should Be Equal As Strings    ${status}    200

##################################################################################################################################
Ceph Certificate For Rgws (LOAD BALANCER)
###################################################################################################################################

        [Documentation]              *Ceph Ceph Certificate For Rgws (LOAD BALANCER)*
        #[Tags]    This
        ${cert_id}                   PCC.Get Certificate Id
                                ...  Alias=${CEPH_RGW_CERT_NAME_LB_SECONDARY}
                                     Pass Execution If    ${cert_id} is not ${None}    Certificate is already there

        ${response}                  PCC.Add Certificate
                                ...  Alias=${CEPH_RGW_CERT_NAME_LB_SECONDARY}
                                ...  Description=certificate-for-rgw-lb
                                ...  Private_key=domain-lb.key
                                ...  Certificate_upload=domain-lb.crt

                                     Log To Console    ${response}
        ${result}                    Get Result    ${response}
        ${status}                    Get From Dictionary    ${result}    statusCodeValue
                                     Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Create a trusted ca policy
###################################################################################################################################

        [Documentation]    *Create a policy* test
                           ...  keywords:
                           ...  PCC.Create Policy

        ${cert_id}       PCC.Get Certificate Id
                         ...  Alias=${CEPH_RGW_CERT_NAME}
                         Log To Console    ${cert_id}

        ${cert_lb_id}    PCC.Get Certificate Id
                         ...  Alias=${CEPH_RGW_CERT_NAME_LB_SECONDARY}
                         Log To Console    ${cert_lb_id}

        ${app_id}        PCC.Get App Id from Policies
                         ...  Name=TRUSTED-CA-CERTIFICATE
                         Log To Console    ${app_id}

        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=Default region

        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=Default zone
                         ...  parentID=${parent1_id}

        ${parent2_id}    PCC.Get Scope Id
                         ...  scope_name=Default site
                         ...  parentID=${scope1_id}

        ${scope2_id}     PCC.Get Scope Id
                         ...  scope_name=Default rack
                         ...  parentID=${parent2_id}

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=trust-ca-policy
                       ...  inputs=[{"name": "ca_certificate_list","value": "${cert_id},${cert_lb_id}"}]
                       ...  scopeIds=[${scope2_id}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Create trusted ca node role
###################################################################################################################################

        [Documentation]    *Create node role with DNS client application* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role

        ${owner}       PCC.Get Tenant Id       Name=ROOT

        ${template_id}    PCC.Get Template Id    Name=TRUSTED-CA-CERTIFICATE
                          Log To Console    ${template_id}

        ${response}    PCC.Add Node Role
                       ...    Name=trusted-ca-certificate
                       ...    Description=trusted-ca-certificate
                       ...    templateIDs=[${template_id}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Associate trusted ca certificate client node role to all ceph nodes
###################################################################################################################################
    [Documentation]                 *Associate trusted ca certificate client node role to all ceph nodes*
                               ...  Keywords:
                               ...  PCC.Add and Verify Roles On Nodes
                               ...  PCC.Wait Until Roles Ready On Nodes

        ${response}                 PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${CLUSTERHEAD_1_NAME}","${SERVER_1_NAME}","${SERVER_2_NAME}","${SERVER_3_NAME}"]
                               ...  roles=["trusted-ca-certificate"]

                                    Should Be Equal As Strings      ${response}  OK

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${CLUSTERHEAD_1_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_1_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_3_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

####################################################################################################################################
#Login To PCC Secondary
####################################################################################################################################
#                        Load Ceph Rgw Data Secondary   ${pcc_setup}
#                        Load Clusterhead 1 Secondary Test Data    ${pcc_setup}
#                        Load Clusterhead 2 Secondary Test Data    ${pcc_setup}
#                        Load Server 1 Secondary Test Data    ${pcc_setup}
#                        Load Server 2 Secondary Test Data    ${pcc_setup}
#                        Load Server 3 Secondary Test Data    ${pcc_setup}
#                        Load Server 4 Secondary Test Data    ${pcc_setup}
#                        Load Server 5 Secondary Test Data    ${pcc_setup}
#                        Load Server 6 Secondary Test Data    ${pcc_setup}
#
#
#        ${status}        Login To PCC Secondary   ${pcc_setup}
#
###################################################################################################################################
#Ceph Certificate For Rgws Secondary
####################################################################################################################################
#
#        [Documentation]              *Ceph Ceph Certificate For Rgws Secondary*
#        #[Tags]    This
#        ${cert_id}                   PCC.Get Certificate Id
#                                ...  Alias=${CEPH_RGW_CERT_NAME_SECONDARY}
#                                     Pass Execution If    ${cert_id} is not ${None}    Certificate is already there
#
#        ${response}                  PCC.Add Certificate
#                                ...  Alias=${CEPH_RGW_CERT_NAME_SECONDARY}
#                                ...  Description=certificate-for-rgw
#                                ...  Private_key=domain.key
#                                ...  Certificate_upload=domain.crt
#
#                                     Log To Console    ${response}
#        ${result}                    Get Result    ${response}
#        ${status}                    Get From Dictionary    ${result}    statusCodeValue
#                                     Should Be Equal As Strings    ${status}    200
#
#
###################################################################################################################################
#Ceph Certificate For Rgws (LOAD BALANCER)
####################################################################################################################################
#
#        [Documentation]              *Ceph Ceph Certificate For Rgws (LOAD BALANCER)*
#        #[Tags]    This
#        ${cert_id}                   PCC.Get Certificate Id
#                                ...  Alias=${CEPH_RGW_CERT_NAME_LB_SECONDARY}
#                                     Pass Execution If    ${cert_id} is not ${None}    Certificate is already there
#
#        ${response}                  PCC.Add Certificate
#                                ...  Alias=${CEPH_RGW_CERT_NAME_LB_SECONDARY}
#                                ...  Description=certificate-for-rgw-lb
#                                ...  Private_key=domain-lb.key
#                                ...  Certificate_upload=domain-lb.crt
#
#                                     Log To Console    ${response}
#        ${result}                    Get Result    ${response}
#        ${status}                    Get From Dictionary    ${result}    statusCodeValue
#                                     Should Be Equal As Strings    ${status}    200
#
####################################################################################################################################
#Create a trusted ca policy secondary
####################################################################################################################################
#
#        [Documentation]    *Create a policy secondary* test
#                           ...  keywords:
#                           ...  PCC.Create Policy
#
#        ${cert_id}       PCC.Get Certificate Id
#                         ...  Alias=${CEPH_RGW_CERT_NAME_SECONDARY}
#                         Log To Console    ${cert_id}
#
#        ${cert_lb_id}    PCC.Get Certificate Id
#                         ...  Alias=${CEPH_RGW_CERT_NAME_LB_SECONDARY}
#                         Log To Console    ${cert_lb_id}
#
#        ${app_id}        PCC.Get App Id from Policies
#                         ...  Name=TRUSTED-CA-CERTIFICATE
#                         Log To Console    ${app_id}
#
#        ${parent1_id}    PCC.Get Scope Id
#                         ...  scope_name=Default region
#
#        ${scope1_id}     PCC.Get Scope Id
#                         ...  scope_name=Default zone
#                         ...  parentID=${parent1_id}
#
#        ${parent2_id}    PCC.Get Scope Id
#                         ...  scope_name=Default site
#                         ...  parentID=${scope1_id}
#
#        ${scope2_id}     PCC.Get Scope Id
#                         ...  scope_name=Default rack
#                         ...  parentID=${parent2_id}
#
#        ${response}    PCC.Create Policy
#                       ...  appId=${app_id}
#                       ...  description=trust-ca-policy
#                       ...  inputs=[{"name": "ca_certificate_list","value": "${cert_id},${cert_lb_id}"}]
#                       ...  scopeIds=[${scope2_id}]
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Be Equal As Strings    ${status}    200
#
####################################################################################################################################
#Create trusted ca node role secondary
####################################################################################################################################
#
#        [Documentation]    *Create trusted ca node role secondary* test
#                           ...  keywords:
#                           ...  PCC.Add Node Role
#                           ...  PCC.Validate Node Role
#
#        ${owner}       PCC.Get Tenant Id       Name=ROOT
#
#        ${template_id}    PCC.Get Template Id    Name=TRUSTED-CA-CERTIFICATE
#                          Log To Console    ${template_id}
#
#        ${response}    PCC.Add Node Role
#                       ...    Name=trusted-ca-certificate
#                       ...    Description=trusted-ca-certificate
#                       ...    templateIDs=[${template_id}]
#                       ...    owners=[${owner}]
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Be Equal As Strings    ${status}    200
#
####################################################################################################################################
#Associate trusted ca certificate client node role to all ceph nodes
####################################################################################################################################
#    [Documentation]                 *Associate trusted ca certificate client node role to all ceph nodes*
#                               ...  Keywords:
#                               ...  PCC.Add and Verify Roles On Nodes
#                               ...  PCC.Wait Until Roles Ready On Nodes
#
#        ${response}                 PCC.Add and Verify Roles On Nodes
#                               ...  nodes=["${CLUSTERHEAD_1_NAME_SECONDARY}","${CLUSTERHEAD_2_NAME_SECONDARY}","${SERVER_1_NAME_SECONDARY}","${SERVER_2_NAME_SECONDARY}","${SERVER_3_NAME_SECONDARY}","${SERVER_4_NAME_SECONDARY}","${SERVER_5_NAME_SECONDARY}","${SERVER_6_NAME_SECONDARY}"]
#                               ...  roles=["trusted-ca-certificate"]
#
#                                    Should Be Equal As Strings      ${response}  OK
#
#        ${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${CLUSTERHEAD_1_NAME_SECONDARY}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK
#
#        ${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${CLUSTERHEAD_2_NAME_SECONDARY}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK
#
#        ${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${SERVER_1_NAME_SECONDARY}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK
#
#        ${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${SERVER_2_NAME_SECONDARY}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK
#
#        ${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${SERVER_3_NAME_SECONDARY}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK
#
#        ${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${SERVER_4_NAME_SECONDARY}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK
#
#        ${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${SERVER_5_NAME_SECONDARY}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK
#
#        ${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${SERVER_6_NAME_SECONDARY}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK