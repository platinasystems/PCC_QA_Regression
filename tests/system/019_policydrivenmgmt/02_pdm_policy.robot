*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC 
###################################################################################################################################
                
        ## abinashp
        [Documentation]    *Login to PCC* test
        [Tags]    This
        
       
        ${status}        Login To PCC    ${pcc_setup}
                         
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         
###################################################################################################################################
Check if user can view the applications:TCP-1407
###################################################################################################################################

        [Documentation]    *Check if user can view the applications* test
                           ...  keywords:
                           ...  PCC.Get App Details
        [Tags]    Only
        ${response}    PCC.Get App Details
                       ...  app_name=dns

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Create a policy with default inputs (using DNS app):TCP-1760
###################################################################################################################################

        [Documentation]    *Create a policy* test
                           ...  keywords:
                           ...  PCC.Create Policy

        [Tags]    Only
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=dns
                     Log To Console    ${app_id}

        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1

        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}

        ${parent2_id}    PCC.Get Scope Id
                         ...  scope_name=zone-2
                         ...  parentID=${parent1_id}

        ${scope2_id}     PCC.Get Scope Id
                         ...  scope_name=site-1
                         ...  parentID=${parent2_id}

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=dns-policy-description
                       ...  scopeIds=[${scope1_id},${scope2_id}]
                       ...  inputs=[{"name":"nameserver_0","value":"172.17.2.253"},{"name":"nameserver_1","value":"8.8.8.8"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200


###################################################################################################################################
Create policy without mandatory parameters - Application:TCP-1415
###################################################################################################################################

        [Documentation]    *Create policy without mandatory parameters - Application* test
                           ...  keywords:
                           ...  PCC.Create Policy



        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1

        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}


        ${response}    PCC.Create Policy
                       ...  description=without-application
                       ...  scopeIds=[${scope1_id}]
                       ...  inputs=[{"name": "parameter1","value": "value1"},{"name": "parameter2","value": "value2"}]


                       Log To Console    ${response}


###################################################################################################################################
Create policy without name of Description:TCP-1416
###################################################################################################################################

        [Documentation]    *Create policy without name of Description* test
                           ...  keywords:
                           ...  PCC.Create Policy

        [Tags]    Only_update
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=snmp
                     Log To Console    ${app_id}

        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1

        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}


        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  scopeIds=[${scope1_id}]
                       ...  inputs=[{"name": "parameter1","value": "value1"},{"name": "parameter2","value": "value2"}]


                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200

###################################################################################################################################
Create a policy with default inputs (using NTP app):TCP-1761
###################################################################################################################################

        [Documentation]    *Create a policy* test
                           ...  keywords:
                           ...  PCC.Create Policy

        [Tags]    Only
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=ntp
                     Log To Console    ${app_id}

        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1

        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}

        ${parent2_id}    PCC.Get Scope Id
                         ...  scope_name=zone-2
                         ...  parentID=${parent1_id}

        ${scope2_id}     PCC.Get Scope Id
                         ...  scope_name=site-1
                         ...  parentID=${parent2_id}

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=ntp-policy-description
                       ...  scopeIds=[${scope1_id},${scope2_id}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Create a policy with default inputs (using SNMP app)
###################################################################################################################################

        [Documentation]    *Create a policy* test
                           ...  keywords:
                           ...  PCC.Create Policy

        [Tags]    Only
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=snmp
                     Log To Console    ${app_id}

        ${scope1_id}    PCC.Get Scope Id
                         ...  scope_name=Default region

        # ${scope1_id}     PCC.Get Scope Id
        #                  ...  scope_name=zone-updated
        #                  ...  parentID=${parent1_id}

        # ${parent2_id}    PCC.Get Scope Id
        #                  ...  scope_name=zone-2
        #                  ...  parentID=${parent1_id}

        # ${scope2_id}     PCC.Get Scope Id
        #                  ...  scope_name=site-1
        #                  ...  parentID=${parent2_id}

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=snmp-policy-description
                       ...  scopeIds=[${scope1_id}]
                       ...  inputs=[{"name": "community_string","value": "thecommunitystring"},{"name": "snmp_user","value": "platina"},{"name": "snmp_password","value": "snmpplatina"},{"name": "snmp_encryption","value": "snmpencr"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Get Policy:TCP-1412
###################################################################################################################################

        [Documentation]    *Get Policy* test
                           ...  keywords:
                           ...  PCC.Get Policy Details
        [Tags]    Only
        ${response}    PCC.Get Policy Details
                       ...  Name=dns
                       ...  description=dns-policy-description

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Get All Policies:TCP-1413
###################################################################################################################################

        [Documentation]    *Get All Policies* test
                           ...  keywords:
                           ...  PCC.Get All Policies

        [Tags]    Only
        ${response}    PCC.Get All Policies

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200


####################################################################################################################################
#Create policy with invalid/non existing appID (Negative):TCP-1417
####################################################################################################################################
#
#        [Documentation]    *Create policy with invalid/non existing appID* test
#                           ...  keywords:
#                           ...  PCC.Create Policy
#
#        ${parent1_id}    PCC.Get Scope Id
#                         ...  scope_name=region-1
#
#        ${scope1_id}     PCC.Get Scope Id
#                         ...  scope_name=zone-updated
#                         ...  parentID=${parent1_id}
#
#        ${parent2_id}    PCC.Get Scope Id
#                         ...  scope_name=zone-2
#                         ...  parentID=${parent1_id}
#
#        ${scope2_id}     PCC.Get Scope Id
#                         ...  scope_name=site-1
#                         ...  parentID=${parent2_id}
#
#        ${response}    PCC.Create Policy
#                       ...  appId=99999
#                       ...  description=invalid-policy-description
#                       ...  scopeIds=[${scope1_id},${scope2_id}]
#                       ...  inputs=[{"name": "parameter1","value": "value1"},{"name": "parameter2","value": "value2"}]
#
#
#                       Log To Console    ${response}


###################################################################################################################################
Create policy with invalid/non existing scopeIDs (Negative):TCP-1418
###################################################################################################################################

        [Documentation]    *Create policy with invalid/non existing scopeIDs* test
                           ...  keywords:
                           ...  PCC.Create Policy

        [Tags]    Only
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=ntp

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  scopeIds=[13245,24356]
                       ...  description=invalid-policy-description
                       ...  inputs=[{"name": "parameter1","value": "value1"}]


                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200

####################################################################################################################################
#Check if appID of a policy must be integer (Negative):TCP-1419
####################################################################################################################################
#
#        [Documentation]    *Check if appID of a policy must be integer* test
#                           ...  keywords:
#                           ...  PCC.Create Policy
#
#        [Tags]    This
#        ${parent1_id}    PCC.Get Scope Id
#                         ...  scope_name=region-1
#
#        ${scope1_id}     PCC.Get Scope Id
#                         ...  scope_name=zone-updated
#                         ...  parentID=${parent1_id}
#
#        ${parent2_id}    PCC.Get Scope Id
#                         ...  scope_name=zone-2
#                         ...  parentID=${parent1_id}
#
#        ${scope2_id}     PCC.Get Scope Id
#                         ...  scope_name=site-1
#                         ...  parentID=${parent2_id}
#
#        ## Giving string in app id ##
#        ${response}    PCC.Create Policy
#                       ...  appId=xyz
#                       ...  scopeIds=[${scope1_id},${scope2_id}]
#                       ...  description=policy-description
#                       ...  inputs=[{"name": "parameter1","value": "value1"},{"name": "parameter2","value": "value2"}]
#
#
#                       Log To Console    ${response}
#
#
#        ## Giving junk characters in app id ##
#        ${response}    PCC.Create Policy
#                       ...  appId=@%^&*&!
#                       ...  scopeIds=[${scope1_id},${scope2_id}]
#                       ...  description=policy-description
#                       ...  inputs=[{"name": "parameter1","value": "value1"},{"name": "parameter2","value": "value2"}]
#
#
#                       Log To Console    ${response}


###################################################################################################################################
Check if scopeID must be integer (Negative):TCP-1420
###################################################################################################################################

        [Documentation]    *Check if scopeID must be integer* test
                           ...  keywords:
                           ...  PCC.Create Policy
        [Tags]    Only
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=ntp

        ## Giving string in scope id ##
        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  scopeIds=['xyz','abc']
                       ...  description=policy-description
                       ...  inputs=[{"name": "parameter1","value": "value1"}]


                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200

        ## Giving junk characters in scope id ##
        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  scopeIds=['@$%^&^^','$%#^&@!']
                       ...  description=policy-description
                       ...  inputs=[{"name": "parameter1","value": "value1"}]


                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200

###################################################################################################################################
Update appID of policy must not be allowed (Negative):TCP-1424
###################################################################################################################################

        [Documentation]    *Update appID of policy must not be allowed* test
                           ...  keywords:
                           ...  PCC.Update Policy

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=snmp
                        ...  description=user-defined-policy-description
                        Log To Console    ${policy_id}

        ${updated_app_id}    PCC.Get App Id from Policies
                             ...  Name=ntp
                             Log To Console    ${updated_app_id}

        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1

        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}

        ## Updating app id here ##
        ${response}    PCC.Update Policy
                       ...  Id=${policy_id}
                       ...  appId=${updated_app_id}
                       ...  scopeIds=[${scope1_id}]
                       ...  description=user-defined-policy-description
                       ...  inputs=[{"name": "parameter1","value": "value1"},{"name": "parameter2","value": "value2"}]


                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200

###################################################################################################################################
Update description of an existing policy:TCP-1425
###################################################################################################################################

        [Documentation]    *Update description of an existing policy* test
                           ...  keywords:
                           ...  PCC.Update Policy

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=dns
                        ...  description=dns-policy-description
                        Log To Console    ${policy_id}


        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=dns
                     Log To Console    ${app_id}

        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1
                         Log To Console    ${parent1_id}

        ${scope1_id}     PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}
                         Log To Console    ${scope1_id}

        ${parent2_id}    PCC.Get Scope Id
                         ...  scope_name=zone-2
                         ...  parentID=${parent1_id}
                         Log To Console    ${parent2_id}

        ${scope2_id}     PCC.Get Scope Id
                         ...  scope_name=site-1
                         ...  parentID=${parent2_id}
                         Log To Console    ${scope2_id}

        ${response}    PCC.Update Policy
                       ...  Id=${policy_id}
                       ...  appId=${app_id}
                       ...  scopeIds=[${scope1_id},${scope2_id}]
                       ...  description=updated-policy-description


                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200


###################################################################################################################################
Update scopeIDs of an existing policy:TCP-1426
###################################################################################################################################

        [Documentation]    *Update scopeIDs of an existing policy* test
                           ...  keywords:
                           ...  PCC.Update Policy
        [Tags]    Policy
        ${policy_id}    PCC.Get Policy Id
                        ...  Name=dns
                        ...  description=updated-policy-description

        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=dns

        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1
                         Log To Console    ${parent1_id}

        ${scope1_id}    PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}
                         Log To Console    ${scope1_id}

        ${response}    PCC.Update Policy
                       ...  Id=${policy_id}
                       ...  appId=${app_id}
                       ...  scopeIds=[${scope1_id}]
                       ...  description=updated-policy-description

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

##################################################################################################################################
Update inputs name and value of policy must not be allowed (Negative):TCP-1427
###################################################################################################################################

        [Documentation]    *Update inputs name and value of policy must not be allowed* test
                           ...  keywords:
                           ...  PCC.Update Policy

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=dns
                        ...  description=updated-policy-description

        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=dns

        ${parent1_id}    PCC.Get Scope Id
                         ...  scope_name=region-1
                         Log To Console    ${parent1_id}

        ${scope1_id}    PCC.Get Scope Id
                         ...  scope_name=zone-updated
                         ...  parentID=${parent1_id}
                         Log To Console    ${scope1_id}

        ${response}    PCC.Update Policy
                       ...  Id=${policy_id}
                       ...  appId=${app_id}
                       ...  scopeIds=[${scope1_id}]
                       ...  description=updated-policy-description
                       ...  inputs=[{"name": "parameter1_updated","value": "value1_updated"},{"name": "parameter2_updated","value": "value2_updated"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200


###################################################################################################################################
Create a policy Iptables policy
###################################################################################################################################

        [Documentation]    *Create a policy Iptables policy*


        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=iptables
                     Log To Console    ${app_id}

        ${scope_id}    PCC.Get Scope Id
                         ...  scope_name=Default region


        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=iptables-policy
                       ...  scopeIds=[${scope_id}]
#                       ...  inputs=[{"name":"nat","value":""},{"name":"filter","value":""},{"name":"mangle","value":""}]
                       ...  inputs=[{"name":"filter","value":"-N PCC_ACCEPT\\n-I INPUT 1 -j PCC_ACCEPT\\n-I PCC_ACCEPT 1 -p tcp -m tcp --dport 6789 -j ACCEPT"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                       sleep  10s

        ${status}      PCC.Wait Until All Nodes Are Ready

                       Log To Console    ${status}
                       Should Be Equal As Strings      ${status}  OK

        ${status}      PCC.Validate iptables From Backend
                    ...  host_ip=${SERVER_1_HOST_IP}
                    ...  iptables_chain=PCC_ACCEPT
                    ...  iptables_port=6789

                       Log To Console    ${status}
                       Should Be Equal As Strings      ${status}  OK

        ${status}      PCC.Validate iptables From Backend
                    ...  host_ip=${CLUSTERHEAD_1_HOST_IP}
                    ...  iptables_chain=PCC_ACCEPT
                    ...  iptables_port=6789

                       Log To Console    ${status}
                       Should Be Equal As Strings      ${status}  OK