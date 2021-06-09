*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC
###################################################################################################################################


        [Documentation]    *Login to PCC* test
        [Tags]    Jenkins

        ${status}        Login To PCC    ${pcc_setup}

                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         Load Network Manager Data    ${pcc_setup}
                         Load Tenant Data    ${pcc_setup}
                         Load Node Roles Data    ${pcc_setup}

#####################################################################################################################################
Install net-tools on nodes
#####################################################################################################################################

    [Documentation]    *Install net-tools on nodes* test                 
    [Tags]    Jenkins
    
    ${status}    Install net-tools command

                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK
				 
###################################################################################################################################
Create scoping objects:TCP-1362, TCP-1363, TCP-1364, TCP-1365
###################################################################################################################################

        [Documentation]    *Create scoping objects* test
                           ...  keywords:
                           ...  PCC.Create Scope
		
		[Tags]    Jenkins
        

        #### Creating Regions ####
        ${response}    PCC.Create Scope
                       ...  type=region
                       ...  scope_name=region-1
                       ...  description=region1-description


                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=region-1

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

        ${response}    PCC.Create Scope
                       ...  type=region
                       ...  scope_name=region-2
                       ...  description=region2-description

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=region-2

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

        #### Getting Ids of Default locations and regions ####

        ${region-1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${region-1_Id}
                        Set Global Variable    ${region-1_Id}

        ${region-2_Id}    PCC.Get Scope Id
                          ...  scope_name=region-2
                          Log To Console    ${region-2_Id}
                          Set Global Variable    ${region-2_Id}

        #### Creating Zones ####

        ${response}    PCC.Create Scope
                       ...  type=zone
                       ...  scope_name=zone-1
                       ...  description=zone1-description
                       ...  parentID=${region-1_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=zone-1

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

        ${response}    PCC.Create Scope
                       ...  type=zone
                       ...  scope_name=zone-2
                       ...  description=zone2-description
                       ...  parentID=${region-2_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=zone-2

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

        #### Creating Sites ####

        ${zone-1_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${region-1_Id}

                        Log To Console    ${zone-1_Id}
                        Set Global Variable    ${zone-1_Id}

        ${zone-2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${region-2_Id}

                        Log To Console    ${zone-2_Id}
                        Set Global Variable    ${zone-2_Id}

        ${response}    PCC.Create Scope
                       ...  type=site
                       ...  scope_name=site-1
                       ...  description=site1-description
                       ...  parentID=${zone-1_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=site-1

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

        ${response}    PCC.Create Scope
                       ...  type=site
                       ...  scope_name=site-2
                       ...  description=site2-description
                       ...  parentID=${zone-2_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=site-2

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK



        #### Creating Racks ####

        ${site-1_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${zone-1_Id}

                        Log To Console    ${site-1_Id}
                        Set Global Variable    ${site-1_Id}

        ${site-2_Id}    PCC.Get Scope Id
                        ...  scope_name=site-2
                        ...  parentID=${zone-2_Id}

                        Log To Console    ${site-2_Id}
                        Set Global Variable    ${site-2_Id}

        ${response}    PCC.Create Scope
                       ...  type=rack
                       ...  scope_name=rack-1
                       ...  description=rack1-description
                       ...  parentID=${site-1_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=rack-1

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

        ${response}    PCC.Create Scope
                       ...  type=rack
                       ...  scope_name=rack-2
                       ...  description=rack2-description
                       ...  parentID=${site-2_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=rack-2

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK


###################################################################################################################################
Getting Ids of Default locations and user-created locations:TCP-1753
###################################################################################################################################

        [Documentation]    *Get Scope Ids* test
                           ...  keywords:
                           ...  PCC.Get Scope Id
		
		[Tags]    Jenkins
        #### Getting Ids of Default locations and regions ####


        ${region-1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${region-1_Id}
                        Set Global Variable    ${region-1_Id}

        ${region-2_Id}    PCC.Get Scope Id
                          ...  scope_name=region-2
                          Log To Console    ${region-2_Id}
                          Set Global Variable    ${region-2_Id}

        ${default_region_Id}    PCC.Get Scope Id
                                ...  scope_name=Default region
                                Log To Console    ${default_region_Id}
                                Set Global Variable    ${default_region_Id}

        ${default_zone_Id}    PCC.Get Scope Id
                              ...  scope_name=Default zone
                              ...  parentID=${default_region_Id}

                              Log To Console    ${default_zone_Id}
                              Set Global Variable    ${default_zone_Id}

        ${default_site_Id}    PCC.Get Scope Id
                              ...  scope_name=Default site
                              ...  parentID=${default_zone_Id}
                              Log To Console    ${default_site_Id}
                              Set Global Variable    ${default_site_Id}

        ${default_rack_Id}    PCC.Get Scope Id
                              ...  scope_name=Default rack
                              ...  parentID=${default_site_Id}
                              Log To Console    ${default_rack_Id}
                              Set Global Variable    ${default_rack_Id}

        ${zone-1_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${region-1_Id}

                        Log To Console    ${zone-1_Id}
                        Set Global Variable    ${zone-1_Id}

        ${zone-2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${region-2_Id}

                        Log To Console    ${zone-2_Id}
                        Set Global Variable    ${zone-2_Id}

        ${site-1_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${zone-1_Id}

                        Log To Console    ${site-1_Id}
                        Set Global Variable    ${site-1_Id}

        ${site-2_Id}    PCC.Get Scope Id
                        ...  scope_name=site-2
                        ...  parentID=${zone-2_Id}

                        Log To Console    ${site-2_Id}
                        Set Global Variable    ${site-2_Id}

        ${rack-1_Id}    PCC.Get Scope Id
                        ...  scope_name=rack-1
                        ...  parentID=${site-1_Id}

                        Log To Console    ${rack-1_Id}
                        Set Global Variable    ${rack-1_Id}

        ${rack-2_Id}    PCC.Get Scope Id
                        ...  scope_name=rack-2
                        ...  parentID=${site-2_Id}

                        Log To Console    ${rack-2_Id}
                        Set Global Variable    ${rack-2_Id}

###################################################################################################################################
Create Node roles:TCP-1428, TCP-1429, TCP-1430
###################################################################################################################################

        [Documentation]    *Create Node Roles* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role

        [Tags]    Jenkins
        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}

        #### Creating dns node role ####

        ${template_id}    PCC.Get Template Id    Name=DNS
                          Log To Console    ${template_id}

        ${response}    PCC.Add Node Role
                       ...    Name=DNS
                       ...    Description=DNS_DESC
                       ...    templateIDs=[${template_id}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                       Sleep    2s

        ${status}    PCC.Validate Node Role
                     ...    Name=DNS

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists

        #### Creating ntp node role ####

        ${template_id}    PCC.Get Template Id    Name=NTP
                          Log To Console    ${template_id}

        ${response}    PCC.Add Node Role
                       ...    Name=NTP
                       ...    Description=NTP_DESC
                       ...    templateIDs=[${template_id}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                       Sleep    2s

        ${status}    PCC.Validate Node Role
                     ...    Name=NTP

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists

        #### Creating snmp node role ####

        ${template_id}    PCC.Get Template Id    Name=SNMP
                          Log To Console    ${template_id}

        ${response}    PCC.Add Node Role
                       ...    Name=SNMP
                       ...    Description=SNMP_DESC
                       ...    templateIDs=[${template_id}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                       Sleep    2s

        ${status}    PCC.Validate Node Role
                     ...    Name=SNMP

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists

        #### Creating Mixed node role (Contains NTP, DNS and SNMP together) ####

        ${template1_id}    PCC.Get Template Id    Name=SNMP
                          Log To Console    ${template1_id}

        ${template2_id}    PCC.Get Template Id    Name=DNS
                          Log To Console    ${template2_id}

        ${template3_id}    PCC.Get Template Id    Name=NTP
                          Log To Console    ${template3_id}

        ${response}    PCC.Add Node Role
                       ...    Name=MIXED
                       ...    Description=MIXED_DESC
                       ...    templateIDs=[${template_id},${template2_id},${template3_id}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                       Sleep    2s

        ${status}    PCC.Validate Node Role
                     ...    Name=MIXED

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists

###################################################################################################################################
Create Policies:TCP-1409, TCP-1410, TCP-1411
###################################################################################################################################

        [Documentation]    *Create Policies* test
                           ...  keywords:
                           ...  PCC.Create Policy
		
		[Tags]    Jenkins
		
        #### Creating NTP policies ####
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=ntp
                     Log To Console    ${app_id}

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=NTP_REGION
                       ...  inputs=[{"name":"ntp_timezone","value":"Australia/Currie"},{"name":"ntp_server_0","value":"0.pool.ntp.org"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=NTP_ZONE
                       ...  inputs=[{"name":"ntp_timezone","value":"Asia/Gaza"},{"name":"ntp_SERVER_2","value":"1.pool.ntp.org new"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=NTP_SITE
                       ...  inputs=[]
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200


        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=NTP_RACK
                       ...  inputs=[{"name":"ntp_timezone","value":"Pacific/Midway"},{"name":"ntp_server_2","value":"2.pool.ntp.org latest"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200



        #### Creating DNS policies ####
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=dns
                     Log To Console    ${app_id}

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=DNS_REGION
                       ...  inputs=[{"name":"domain","value":"www.region.com"},{"name":"search_0","value":"dns_region1.com"},{"name":"search_1","value":"dns_region2.com"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=DNS_ZONE
                       ...  inputs=[{"name":"domain","value":"www.zone.com"},{"name":"search_0","value":"dns_zone1.com"},{"name":"search_1","value":"dns_zone2.com"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=DNS_SITE
                       ...  inputs=[{"name":"domain","value":"www.site.com"},{"name":"nameserver_0","value":"172.17.2.253"},{"name":"nameserver_1","value":"8.8.8.8"},{"name":"search_0","value":"dns_site1.com"},{"name":"search_1","value":"dns_site2.com"}]
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200


        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=DNS_RACK
                       ...  inputs=[{"name":"domain","value":"www.rack.com"},{"name":"search_0","value":"dns_rack1.com"},{"name":"search_1","value":"dns_rack2.com"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200


        #### Creating SNMP policies ####
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=snmp
                     Log To Console    ${app_id}

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=SNMP_v2
                       ...  inputs=[{"name":"community_string","value":"snmpv2_community_string"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=SNMP_v3
                       ...  inputs=[{"name":"community_string","value":""},{"name":"snmp_user","value":"testuser"},{"name":"snmp_password","value":"testuserpwd"},{"name":"snmp_encryption","value":"testuser"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Getting Ids of All Node Roles:TCP-1754
###################################################################################################################################

      [Documentation]    *Getting Ids of All Node Roles* test
                           ...  keywords:
                           ...  PCC.Get Node Role Id
		
		[Tags]    Jenkins

        ${dns_node_role_id}     PCC.Get Node Role Id
                                ...  Name=DNS
                                Log To Console    ${dns_node_role_id}
                                Set Global Variable    ${dns_node_role_id}

        ${ntp_node_role_id}     PCC.Get Node Role Id
                                ...  Name=NTP
                                Log To Console    ${ntp_node_role_id}
                                Set Global Variable    ${ntp_node_role_id}

        ${snmp_node_role_id}    PCC.Get Node Role Id
                                ...  Name=SNMP
                                Log To Console    ${snmp_node_role_id}
                                Set Global Variable    ${snmp_node_role_id}

        ${mixed_node_role_id}   PCC.Get Node Role Id
                                ...  Name=MIXED
                                Log To Console    ${mixed_node_role_id}
                                Set Global Variable    ${mixed_node_role_id}





###################################################################################################################################
Getting Ids of All Policies:TCP-1755
###################################################################################################################################

      [Documentation]    *Getting Ids of All Policies* test
                           ...  keywords:
                           ...  PCC.Get Policy Id

		[Tags]    Jenkins

        ${ntp_region_policy_id}     PCC.Get Policy Id
                                    ...  Name=ntp
                                    ...  description=NTP_REGION
                                    Log To Console    ${ntp_region_policy_id}
                                    Set Global Variable    ${ntp_region_policy_id}

        ${ntp_zone_policy_id}     PCC.Get Policy Id
                                  ...  Name=ntp
                                  ...  description=NTP_ZONE
                                  Log To Console    ${ntp_zone_policy_id}
                                  Set Global Variable    ${ntp_zone_policy_id}

        ${ntp_site_policy_id}     PCC.Get Policy Id
                                  ...  Name=ntp
                                  ...  description=NTP_SITE
                                  Log To Console    ${ntp_site_policy_id}
                                  Set Global Variable    ${ntp_site_policy_id}

        ${ntp_rack_policy_id}     PCC.Get Policy Id
                                  ...  Name=ntp
                                  ...  description=NTP_RACK
                                  Log To Console    ${ntp_rack_policy_id}
                                  Set Global Variable    ${ntp_rack_policy_id}


        ${dns_region_policy_id}     PCC.Get Policy Id
                                    ...  Name=dns
                                    ...  description=DNS_REGION
                                    Log To Console    ${dns_region_policy_id}
                                    Set Global Variable    ${dns_region_policy_id}

        ${dns_zone_policy_id}     PCC.Get Policy Id
                                  ...  Name=dns
                                  ...  description=DNS_ZONE
                                  Log To Console    ${dns_zone_policy_id}
                                  Set Global Variable    ${dns_zone_policy_id}

        ${dns_site_policy_id}     PCC.Get Policy Id
                                  ...  Name=dns
                                  ...  description=DNS_SITE
                                  Log To Console    ${dns_site_policy_id}
                                  Set Global Variable    ${dns_site_policy_id}

        ${dns_rack_policy_id}     PCC.Get Policy Id
                                  ...  Name=dns
                                  ...  description=DNS_RACK
                                  Log To Console    ${dns_rack_policy_id}
                                  Set Global Variable    ${dns_rack_policy_id}

        ${snmpv2_policy_id}     PCC.Get Policy Id
                                ...  Name=snmp
                                ...  description=SNMP_v2
                                Log To Console    ${snmpv2_policy_id}
                                Set Global Variable    ${snmpv2_policy_id}

        ${snmpv3_policy_id}     PCC.Get Policy Id
                                ...  Name=snmp
                                ...  description=SNMP_v3
                                Log To Console    ${snmpv3_policy_id}
                                Set Global Variable    ${snmpv3_policy_id}

#####################################################################################################################################
Delete Node
#####################################################################################################################################

        [Documentation]    *Delete Nodes* test

		[Tags]    Jenkins
        ${network_id}              PCC.Get Network Manager Id
                              ...  name=${NETWORK_MANAGER_NAME}
                                   Pass Execution If    ${network_id} is not ${None}    Network Cluster is Present Deleting Aborted

        ${status}                  PCC.Delete mutliple nodes and wait until deletion
                              ...  Names=['${SERVER_2_NAME}']

                                   Log To Console    ${status}
                                   Should be equal as strings    ${status}    OK

########################################################################################################################################
Add nodes to PCC and check if node is assigned to a scoping object (Rack/Site) and policies, node roles are applied on the node:TCP-1445
########################################################################################################################################
## Checked ###

		
        [Documentation]    *Add nodes to PCC and check if node is assigned to a scoping object (Rack/Site) and policies are applied on the node* test
                           ...  keywords:
                           ...  PCC.Add Node

		[Tags]    Jenkins

        ######  Adding Node  ######
        ${add_node_response}    PCC.Add Node
                                ...    Host=${SERVER_2_HOST_IP}

                                Log To Console    ${add_node_response}
                                ${result}    Get Result    ${add_node_response}
                                ${status}    Get From Dictionary    ${result}    status
                                ${message}    Get From Dictionary    ${result}    message
                                Log to Console    ${message}
                                Should Be Equal As Strings    ${status}    200

                                Sleep    2s

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ##### Adding Node Role on Node  #####

        ${response}            PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${SERVER_2_NAME}"]
                               ...  roles=["DNS", "SNMP","NTP"]

                               Should Be Equal As Strings      ${response}  OK

        ${status_code}         PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${SERVER_2_NAME}

                               Should Be Equal As Strings      ${status_code}  OK


        ######  Updating Region with Policy  ######

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=ntp
                        ...  description=NTP_REGION

                        Log To Console    ${policy_id}

        ${update_scope_response}    PCC.Update Scope
                                    ...  Id=${default_region_Id}
                                    ...  type=region
                                    ...  scope_name=Default region
                                    ...  description=Default region scope
                                    ...  policyIDs=[${policy_id}]

                                    Log To Console    ${update_scope_response}
                                    ${result}    Get Result    ${update_scope_response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    ${message}    Get From Dictionary    ${result}    message
                                    Log to Console    ${message}
                                    Should Be Equal As Strings    ${status}    200


        ######  Updating Zone with Policy  ######

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=dns
                        ...  description=DNS_ZONE

                        Log To Console    ${policy_id}

        ${update_scope_response}    PCC.Update Scope
                                    ...  Id=${default_zone_Id}
                                    ...  type=zone
                                    ...  scope_name=Default zone
                                    ...  description=Default zone scope
                                    ...  policyIDs=[${policy_id}]

                                    Log To Console    ${update_scope_response}
                                    ${result}    Get Result    ${update_scope_response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    ${message}    Get From Dictionary    ${result}    message
                                    Log to Console    ${message}
                                    Should Be Equal As Strings    ${status}    200



        ######  Updating Site with Policy  ######

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=snmp
                        ...  description=SNMP_v2

                        Log To Console    ${policy_id}

        ${update_scope_response}    PCC.Update Scope
                                    ...  Id=${default_site_Id}
                                    ...  type=site
                                    ...  scope_name=Default site
                                    ...  description=Default site scope
                                    ...  policyIDs=[${policy_id}]

                                    Log To Console    ${update_scope_response}
                                    ${result}    Get Result    ${update_scope_response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    ${message}    Get From Dictionary    ${result}    message
                                    Log to Console    ${message}
                                    Should Be Equal As Strings    ${status}    200



        ######  Updating Rack with Policy  ######

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=dns
                        ...  description=DNS_RACK

                        Log To Console    ${policy_id}

        ${update_scope_response}    PCC.Update Scope
                                    ...  Id=${default_rack_Id}
                                    ...  type=rack
                                    ...  scope_name=Default rack
                                    ...  description=Default rack scope
                                    ...  policyIDs=[${policy_id}]

                                    Log To Console    ${update_scope_response}
                                    ${result}    Get Result    ${update_scope_response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    ${message}    Get From Dictionary    ${result}    message
                                    Log to Console    ${message}
                                    Should Be Equal As Strings    ${status}    200

                ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ##### Validate Scope Assignment on Node ##########

        ${status}    PCC.Check scope assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scopeId=${default_rack_Id}
                     ...  parentID=${default_site_Id}
                     ...  scope_name=Default rack

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Scope Hierarchy on Node ##########

        ${status}    PCC.Check scope hierarchy on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scope_from_user=[${default_rack_Id},${default_site_Id},${default_zone_Id},${default_region_Id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Node Role Assignment on Node ##########

        ${status}    PCC.Check roles assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  roles_id=[${dns_node_role_id},${ntp_node_role_id},${snmp_node_role_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate RSOP on Node ##########

        ${status}    PCC.Validate RSOP of a node
                     ...  node_name=${SERVER_2_NAME}
                     ...  policyIDs=[${dns_rack_policy_id},${ntp_region_policy_id},${snmpv2_policy_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK
		
		##### Validate DNS from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate DNS From Backend
                     ...  host_ip=${SERVER_2_HOST_IP}
                     ...  search_list=['www.rack.com','dns_rack1.com', 'dns_rack2.com']
                     ...  dns_server_ip=8.8.8.8

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Check NTP services from backend #####
        
        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Check NTP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
					  
		##### Validate NTP from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate NTP From Backend
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  time_zone=Australia/Currie

                      Should Be Equal As Strings      ${status}  OK

        ##### Check SNMP services from backend #####
        
        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Check SNMP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
					  
		##### Validate SNMPv2 from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate SNMP from backend
                      ...  snmp_version=snmpv2
                      ...  community_string=snmpv2_community_string
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  node_name=${SERVER_2_NAME}

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK

        ######  Updating Site with SNMPv3 Policy  ######

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=snmp
                        ...  description=SNMP_v3

                        Log To Console    ${policy_id}

        ${update_scope_response}    PCC.Update Scope
                                    ...  Id=${default_site_Id}
                                    ...  type=site
                                    ...  scope_name=Default site
                                    ...  description=Default site scope
                                    ...  policyIDs=[${policy_id}]

                                    Log To Console    ${update_scope_response}
                                    ${result}    Get Result    ${update_scope_response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    ${message}    Get From Dictionary    ${result}    message
                                    Log to Console    ${message}
                                    Should Be Equal As Strings    ${status}    200



        ##### Validate RSOP on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate RSOP of a node
                     ...  node_name=${SERVER_2_NAME}
                     ...  policyIDs=[${dns_rack_policy_id},${ntp_region_policy_id},${snmpv3_policy_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate SNMPv3 from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
							   
		${status}     PCC.Validate SNMP from backend
                      ...  snmp_version=snmpv3
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  node_name=${SERVER_2_NAME}
                      ...  snmp_username=testuser
                      ...  snmp_password=testuserpwd
                      ...  snmp_encryption=testuser

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK



###################################################################################################################################
Check if the node inherit its relationship with the parents object and policies to maintain backward compatibility when a node is associated with a rack:TCP-1447
###################################################################################################################################

#### Checked #######

        ${node_id}    PCC.Get Node Id
                      ...  Name=${SERVER_2_NAME}
                      Log To Console    ${node_id}

        ${response}    PCC.Update Node
                       ...  Id=${node_id}
                       ...  Name=${SERVER_2_NAME}
                       ...  scopeId=${rack-1_Id}
                       ...  roles=[${dns_node_role_id},${ntp_node_role_id},${snmp_node_role_id}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                       Sleep    20s

        ######  Updating Region with Policy  ######

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=dns
                        ...  description=DNS_REGION

                        Log To Console    ${policy_id}

        ${update_scope_response}    PCC.Update Scope
                                    ...  Id=${region-1_Id}
                                    ...  type=region
                                    ...  scope_name=region-1
                                    ...  description=region1-description
                                    ...  policyIDs=[${policy_id}]

                                    Log To Console    ${update_scope_response}
                                    ${result}    Get Result    ${update_scope_response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    ${message}    Get From Dictionary    ${result}    message
                                    Log to Console    ${message}
                                    Should Be Equal As Strings    ${status}    200



        ######  Updating Zone with Policy  ######

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=ntp
                        ...  description=NTP_ZONE

                        Log To Console    ${policy_id}

        ${update_scope_response}    PCC.Update Scope
                                    ...  Id=${zone-1_Id}
                                    ...  type=zone
                                    ...  scope_name=zone-1
                                    ...  description=zone1-description
                                    ...  policyIDs=[${policy_id}]
                                    ...  parentID=${region-1_Id}

                                    Log To Console    ${update_scope_response}
                                    ${result}    Get Result    ${update_scope_response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    ${message}    Get From Dictionary    ${result}    message
                                    Log to Console    ${message}
                                    Should Be Equal As Strings    ${status}    200



        ######  Updating Site with Policy  ######

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=dns
                        ...  description=DNS_SITE

                        Log To Console    ${policy_id}

        ${update_scope_response}    PCC.Update Scope
                                    ...  Id=${site-1_Id}
                                    ...  type=site
                                    ...  scope_name=site-1
                                    ...  description=site1-description
                                    ...  policyIDs=[${policy_id}]
                                    ...  parentID=${zone-1_Id}

                                    Log To Console    ${update_scope_response}
                                    ${result}    Get Result    ${update_scope_response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    ${message}    Get From Dictionary    ${result}    message
                                    Log to Console    ${message}
                                    Should Be Equal As Strings    ${status}    200



        ######  Updating Rack with Policy  ######

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=snmp
                        ...  description=SNMP_v3

                        Log To Console    ${policy_id}

        ${update_scope_response}    PCC.Update Scope
                                    ...  Id=${rack-1_Id}
                                    ...  type=rack
                                    ...  scope_name=rack-1
                                    ...  description=rack1-description
                                    ...  policyIDs=[${policy_id}]
                                    ...  parentID=${site-1_Id}

                                    Log To Console    ${update_scope_response}
                                    ${result}    Get Result    ${update_scope_response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    ${message}    Get From Dictionary    ${result}    message
                                    Log to Console    ${message}
                                    Should Be Equal As Strings    ${status}    200

                ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ##### Validate Scope Assignment on Node ##########

        ${status}    PCC.Check scope assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scopeId=${rack-1_Id}
                     ...  parentID=${site-1_Id}
                     ...  scope_name=rack-1

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Scope Hierarchy on Node ##########

        ${status}    PCC.Check scope hierarchy on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scope_from_user=[${rack-1_Id},${site-1_Id},${zone-1_Id},${region-1_Id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Node Role Assignment on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Check roles assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  roles_id=[${dns_node_role_id},${ntp_node_role_id},${snmp_node_role_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate RSOP on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate RSOP of a node
                     ...  node_name=${SERVER_2_NAME}
                     ...  policyIDs=[${dns_site_policy_id},${ntp_zone_policy_id},${snmpv3_policy_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Check SNMP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check SNMP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
		
		##### Validate SNMPv3 from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate SNMP from backend
                      ...  snmp_version=snmpv3
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  node_name=${SERVER_2_NAME}
                      ...  snmp_username=testuser
                      ...  snmp_password=testuserpwd
                      ...  snmp_encryption=testuser

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK

        ##### Validate DNS from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate DNS From Backend
                     ...  host_ip=${SERVER_2_HOST_IP}
                     ...  search_list=['www.site.com','dns_site1.com', 'dns_site2.com']
                     ...  dns_server_ip=8.8.8.8

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Check NTP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check NTP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
					  
		##### Validate NTP from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate NTP From Backend
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  time_zone=Asia/Gaza

                      Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Check if the node inherit its relationship with the parents object and policies to maintain backward compatibility when a node is associated with a site:TCP-1448
###################################################################################################################################

##### Checked ####


        ${node_id}    PCC.Get Node Id
                      ...  Name=${SERVER_2_NAME}
                      Log To Console    ${node_id}

        ${response}    PCC.Update Node
                       ...  Id=${node_id}
                       ...  Name=${SERVER_2_NAME}
                       ...  scopeId=${site-1_Id}
                       ...  roles=[${dns_node_role_id},${ntp_node_role_id},${snmp_node_role_id}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK


        ${scope_id}    PCC.Get Scope Id
                       ...  scope_name=Default rack
                       ...  parentID=${site-1_Id}
                       Log To Console    ${scope_id}
                       Set Global Variable    ${scope_id}

        ##### Validate Scope Assignment on Node ##########

        ${status}    PCC.Check scope assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scopeId=${scope_id}
                     ...  parentID=${site-1_Id}
                     ...  scope_name=Default rack

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Scope Hierarchy on Node ##########

        ${status}    PCC.Check scope hierarchy on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scope_from_user=[${scope_id},${site-1_Id},${zone-1_Id},${region-1_Id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Node Role Assignment on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Check roles assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  roles_id=[${dns_node_role_id},${ntp_node_role_id},${snmp_node_role_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate RSOP on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate RSOP of a node
                     ...  node_name=${SERVER_2_NAME}
                     ...  policyIDs=[${dns_site_policy_id},${ntp_zone_policy_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        #### Negative test of keeping previous policy and verify if it still exists ######

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate RSOP of a node
                     ...  node_name=${SERVER_2_NAME}
                     ...  policyIDs=[${dns_site_policy_id},${ntp_zone_policy_id},${snmpv3_policy_id}]

                     Log To Console    ${status}
                     Should Not Be Equal As Strings      ${status}  OK

        ##### Check SNMP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check SNMP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
		
		##### Validate SNMPv3 from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate SNMP from backend
                      ...  snmp_version=snmpv3
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  node_name=${SERVER_2_NAME}
                      ...  snmp_username=testuser
                      ...  snmp_password=testuserpwd
                      ...  snmp_encryption=testuser

                      Log To Console    ${status}
                      Should Not Be Equal As Strings      ${status}  OK

        ##### Validate DNS from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate DNS From Backend
                     ...  host_ip=${SERVER_2_HOST_IP}
                     ...  search_list=['www.site.com','dns_site1.com', 'dns_site2.com']
                     ...  dns_server_ip=8.8.8.8

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Check NTP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check NTP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
					  
		##### Validate NTP from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate NTP From Backend
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  time_zone=Asia/Gaza

                      Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Update parent of a zone:TCP-1449
###################################################################################################################################


        #### Updating parent ID of zone ####

        ${response}    PCC.Update Scope
                       ...  Id=${zone-1_Id}
                       ...  type=zone
                       ...  scope_name=zone-1
                       ...  description=zone1-description
                       ...  policyIDs=[${ntp_zone_policy_id}]
                       ...  parentID=${region-2_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK


        ######  Updating Region with Policy  ######

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=snmp
                        ...  description=SNMP_v2

                        Log To Console    ${policy_id}

        ${update_scope_response}    PCC.Update Scope
                                    ...  Id=${region-2_Id}
                                    ...  type=region
                                    ...  scope_name=region-2
                                    ...  description=region2-description
                                    ...  policyIDs=[${policy_id}]
                                    ...  parentID=

                                    Log To Console    ${update_scope_response}
                                    ${result}    Get Result    ${update_scope_response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    ${message}    Get From Dictionary    ${result}    message
                                    Log to Console    ${message}
                                    Should Be Equal As Strings    ${status}    200

                ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${scope_id}    PCC.Get Scope Id
                       ...  scope_name=Default rack
                       ...  parentID=${site-1_Id}
                       Log To Console    ${scope_id}

        ${zone-1_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${region-2_Id}

                        Log To Console    ${zone-1_Id}
                        Set Global Variable    ${zone-1_Id}

        ##### Validate Scope Assignment on Node ##########

        ${status}    PCC.Check scope assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scopeId=${scope_id}
                     ...  parentID=${site-1_Id}
                     ...  scope_name=Default rack

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Scope Hierarchy on Node ##########

        ${status}    PCC.Check scope hierarchy on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scope_from_user=[${scope_id},${site-1_Id},${zone-1_Id},${region-2_Id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Node Role Assignment on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Check roles assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  roles_id=[${dns_node_role_id},${ntp_node_role_id},${snmp_node_role_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate RSOP on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate RSOP of a node
                     ...  node_name=${SERVER_2_NAME}
                     ...  policyIDs=[${dns_site_policy_id},${ntp_zone_policy_id},${snmpv2_policy_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Check SNMP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check SNMP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
					  
		##### Validate SNMPv2 from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate SNMP from backend
                      ...  snmp_version=snmpv2
                      ...  community_string=snmpv2_community_string
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  node_name=${SERVER_2_NAME}

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK

        ##### Validate DNS from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate DNS From Backend
                     ...  host_ip=${SERVER_2_HOST_IP}
                     ...  search_list=['www.site.com','dns_site1.com', 'dns_site2.com']
                     ...  dns_server_ip=8.8.8.8

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Check NTP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check NTP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
					  
		##### Validate NTP from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate NTP From Backend
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  time_zone=Asia/Gaza

                      Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Update parent of a site:TCP-1450
###################################################################################################################################


        #### Updating parent ID of site ####

        ${zone-1_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${region-2_Id}

                        Log To Console    ${zone-1_Id}
                        Set Global Variable    ${zone-1_Id}

        ${site-1_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${zone-1_Id}

                        Log To Console    ${site-1_Id}
                        Set Global Variable    ${site-1_Id}

        ${response}    PCC.Update Scope
                       ...  Id=${site-1_Id}
                       ...  type=site
                       ...  scope_name=site-1
                       ...  description=site1-description
                       ...  parentID=${zone-2_Id}
                       ...  policyIDs=[${dns_site_policy_id}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ######  Updating Zone with Policy  ######

        ${policy_id}    PCC.Get Policy Id
                        ...  Name=ntp
                        ...  description=NTP_ZONE

                        Log To Console    ${policy_id}

        ${update_scope_response}    PCC.Update Scope
                                    ...  Id=${zone-2_Id}
                                    ...  type=zone
                                    ...  scope_name=zone-2
                                    ...  description=zone2-description
                                    ...  policyIDs=[${policy_id}]
                                    ...  parentID=${region-2_Id}

                                    Log To Console    ${update_scope_response}
                                    ${result}    Get Result    ${update_scope_response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    ${message}    Get From Dictionary    ${result}    message
                                    Log to Console    ${message}
                                    Should Be Equal As Strings    ${status}    200

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${scope_id}    PCC.Get Scope Id
                       ...  scope_name=Default rack
                       ...  parentID=${site-1_Id}
                       Log To Console    ${scope_id}
                       Set Global Variable    ${scope_id}

        ##### Validate Scope Assignment on Node ##########

        ${status}    PCC.Check scope assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scopeId=${scope_id}
                     ...  parentID=${site-1_Id}
                     ...  scope_name=Default rack

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Scope Hierarchy on Node ##########

        ${status}    PCC.Check scope hierarchy on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scope_from_user=[${scope_id},${site-1_Id},${zone-2_Id},${region-2_Id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Node Role Assignment on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Check roles assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  roles_id=[${dns_node_role_id},${ntp_node_role_id},${snmp_node_role_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate RSOP on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate RSOP of a node
                     ...  node_name=${SERVER_2_NAME}
                     ...  policyIDs=[${dns_site_policy_id},${ntp_zone_policy_id},${snmpv2_policy_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Check SNMP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check SNMP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
			
		##### Validate SNMPv2 from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate SNMP from backend
                      ...  snmp_version=snmpv2
                      ...  community_string=snmpv2_community_string
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  node_name=${SERVER_2_NAME}

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK

        ##### Validate DNS from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate DNS From Backend
                     ...  host_ip=${SERVER_2_HOST_IP}
                     ...  search_list=['www.site.com','dns_site1.com', 'dns_site2.com']
                     ...  dns_server_ip=8.8.8.8

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Check NTP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check NTP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
		
		##### Validate NTP from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate NTP From Backend
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  time_zone=Asia/Gaza

                      Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Update parent of a rack:TCP-1451
###################################################################################################################################


        ${node_id}    PCC.Get Node Id
                      ...  Name=${SERVER_2_NAME}
                      Log To Console    ${node_id}

        #### Updating parent ID of rack ####

        ${zone-2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${region-2_Id}

                        Log To Console    ${zone-2_Id}
                        Set Global Variable    ${zone-2_Id}

        ${site-1_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${zone-2_Id}

                        Log To Console    ${site-1_Id}
                        Set Global Variable    ${site-1_Id}


        ${rack-1_Id}    PCC.Get Scope Id
                        ...  scope_name=rack-1
                        ...  parentID=${site-1_Id}

                        Log To Console    ${rack-1_Id}
                        Set Global Variable    ${rack-1_Id}

        ${response}    PCC.Update Scope
                       ...  Id=${rack-1_Id}
                       ...  type=rack
                       ...  scope_name=rack-1
                       ...  description=rack1-description
                       ...  parentID=${site-2_Id}
                       ...  policyIDs=[${snmpv3_policy_id}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ##### Update node to rack-1 #######

        ${response}    PCC.Update Node
                       ...  Id=${node_id}
                       ...  Name=${SERVER_2_NAME}
                       ...  scopeId=${rack-1_Id}
                       ...  roles=[${dns_node_role_id},${ntp_node_role_id},${snmp_node_role_id}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK


        ${scope_Id}    PCC.Get Scope Id
                       ...  scope_name=rack-1
                       ...  parentID=${site-2_Id}
                       Log To Console    ${scope_id}
                       Set Global Variable    ${scope_id}

        ##### Validate Scope Assignment on Node ##########

        ${status}    PCC.Check scope assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scopeId=${scope_id}
                     ...  parentID=${site-2_Id}
                     ...  scope_name=rack-1

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Scope Hierarchy on Node ##########

        ${status}    PCC.Check scope hierarchy on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scope_from_user=[${scope_id},${site-2_Id},${zone-2_Id},${region-2_Id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Node Role Assignment on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Check roles assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  roles_id=[${dns_node_role_id},${ntp_node_role_id},${snmp_node_role_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate RSOP on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate RSOP of a node
                     ...  node_name=${SERVER_2_NAME}
                     ...  policyIDs=[${ntp_zone_policy_id},${snmpv3_policy_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate DNS from backend (Negative Testing) #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate DNS From Backend
                     ...  host_ip=${SERVER_2_HOST_IP}
                     ...  search_list=['www.site.com','dns_site1.com', 'dns_site2.com']
                     ...  dns_server_ip=8.8.8.8

                     Log To Console    ${status}
                     Should Not Be Equal As Strings      ${status}  OK

        ##### Check NTP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check NTP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
		
		##### Validate NTP from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate NTP From Backend
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  time_zone=Asia/Gaza

                      Should Be Equal As Strings      ${status}  OK
		
		##### Check SNMP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check SNMP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
		
		##### Validate SNMPv3 from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate SNMP from backend
                      ...  snmp_version=snmpv3
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  node_name=${SERVER_2_NAME}
                      ...  snmp_username=testuser
                      ...  snmp_password=testuserpwd
                      ...  snmp_encryption=testuser

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Update rack of a node:TCP-1469
###################################################################################################################################




        ${node_id}    PCC.Get Node Id
                      ...  Name=${SERVER_2_NAME}
                      Log To Console    ${node_id}

        ${site-2_Id}    PCC.Get Scope Id
                        ...  scope_name=site-2
                        ...  parentID=${zone-2_Id}

                        Log To Console    ${site-2_Id}
                        Set Global Variable    ${site-2_Id}

        ${rack-2_Id}    PCC.Get Scope Id
                        ...  scope_name=rack-2
                        ...  parentID=${site-2_Id}

                        Log To Console    ${rack-2_Id}
                        Set Global Variable    ${rack-2_Id}

        ##### Update node to rack-1 #######

        ${response}    PCC.Update Node
                       ...  Id=${node_id}
                       ...  Name=${SERVER_2_NAME}
                       ...  scopeId=${rack-2_Id}
                       ...  roles=[${dns_node_role_id},${ntp_node_role_id},${snmp_node_role_id}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK


        ${scope_Id}    PCC.Get Scope Id
                       ...  scope_name=rack-2
                       ...  parentID=${site-2_Id}
                       Log To Console    ${scope_id}
                       Set Global Variable    ${scope_id}

        ##### Validate Scope Assignment on Node ##########

        ${status}    PCC.Check scope assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scopeId=${scope_id}
                     ...  parentID=${site-2_Id}
                     ...  scope_name=rack-2

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Scope Hierarchy on Node ##########

        ${status}    PCC.Check scope hierarchy on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scope_from_user=[${scope_id},${site-2_Id},${zone-2_Id},${region-2_Id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Node Role Assignment on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Check roles assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  roles_id=[${dns_node_role_id},${ntp_node_role_id},${snmp_node_role_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate RSOP on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate RSOP of a node
                     ...  node_name=${SERVER_2_NAME}
                     ...  policyIDs=[${ntp_zone_policy_id},${snmpv2_policy_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Check SNMP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check SNMP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
					  
		##### Validate SNMPv2 from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate SNMP from backend
                      ...  snmp_version=snmpv2
                      ...  community_string=snmpv2_community_string
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  node_name=${SERVER_2_NAME}

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK

        ##### Validate DNS from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate DNS From Backend
                     ...  host_ip=${SERVER_2_HOST_IP}
                     ...  search_list=['www.site.com','dns_site1.com', 'dns_site2.com']
                     ...  dns_server_ip=8.8.8.8

                     Log To Console    ${status}
                     Should Not Be Equal As Strings      ${status}  OK

        ##### Check NTP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check NTP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
		
		##### Validate NTP from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate NTP From Backend
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  time_zone=Asia/Gaza

                      Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Update site of a node:TCP-1469
###################################################################################################################################



        ${node_id}    PCC.Get Node Id
                      ...  Name=${SERVER_2_NAME}
                      Log To Console    ${node_id}

        ${site-1_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${zone-2_Id}

                        Log To Console    ${site-1_Id}
                        Set Global Variable    ${site-1_Id}

        ##### Update node to rack-1 #######

        ${response}    PCC.Update Node
                       ...  Id=${node_id}
                       ...  Name=${SERVER_2_NAME}
                       ...  scopeId=${site-1_Id}
                       ...  roles=[${dns_node_role_id},${ntp_node_role_id},${snmp_node_role_id}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK


        ${scope_Id}    PCC.Get Scope Id
                       ...  scope_name=Default rack
                       ...  parentID=${site-1_Id}
                       Log To Console    ${scope_id}
                       Set Global Variable    ${scope_id}

        ##### Validate Scope Assignment on Node ##########

        ${status}    PCC.Check scope assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scopeId=${scope_id}
                     ...  parentID=${site-1_Id}
                     ...  scope_name=Default rack

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Scope Hierarchy on Node ##########

        ${status}    PCC.Check scope hierarchy on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scope_from_user=[${scope_id},${site-1_Id},${zone-2_Id},${region-2_Id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Node Role Assignment on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Check roles assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  roles_id=[${dns_node_role_id},${ntp_node_role_id},${snmp_node_role_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate RSOP on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate RSOP of a node
                     ...  node_name=${SERVER_2_NAME}
                     ...  policyIDs=[${ntp_zone_policy_id},${dns_site_policy_id},${snmpv2_policy_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Check SNMP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check SNMP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
		
		##### Validate SNMPv2 from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate SNMP from backend
                      ...  snmp_version=snmpv2
                      ...  community_string=snmpv2_community_string
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  node_name=${SERVER_2_NAME}

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK

        ##### Validate DNS from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate DNS From Backend
                     ...  host_ip=${SERVER_2_HOST_IP}
                     ...  search_list=['www.site.com','dns_site1.com', 'dns_site2.com']
                     ...  dns_server_ip=8.8.8.8

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Check NTP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check NTP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
		
		##### Validate NTP from backend #########
        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate NTP From Backend
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  time_zone=Asia/Gaza

                      Should Be Equal As Strings      ${status}  OK

#####################################################################################################################################
Delete an existing node from the PCC and add it back:TCP-1456
#####################################################################################################################################

        [Documentation]    *Delete Nodes* test

        ###### Deleting the node #####
        ${network_id}              PCC.Get Network Manager Id
                              ...  name=${NETWORK_MANAGER_NAME}
                                   Pass Execution If    ${network_id} is not ${None}    Network Cluster is Present Deleting Aborted

        ${status}                  PCC.Delete mutliple nodes and wait until deletion
                              ...  Names=['${SERVER_2_NAME}']

                                   Log To Console    ${status}
                                   Should be equal as strings    ${status}    OK

        ######  Adding Node  ######
        ${add_node_response}    PCC.Add Node
                                ...    Host=${SERVER_2_HOST_IP}

                                Log To Console    ${add_node_response}
                                ${result}    Get Result    ${add_node_response}
                                ${status}    Get From Dictionary    ${result}    status
                                ${message}    Get From Dictionary    ${result}    message
                                Log to Console    ${message}
                                Should Be Equal As Strings    ${status}    200

                                Sleep    2s

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ##############################################
        ####### Validations after adding node ########
        ##############################################

        ${scope_Id}    PCC.Get Scope Id
                       ...  scope_name=Default rack
                       ...  parentID=${default_site_Id}
                       Log To Console    ${scope_id}
                       Set Global Variable    ${scope_id}

        ##### Validate Scope Assignment on Node ##########

        ${status}    PCC.Check scope assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scopeId=${scope_id}
                     ...  parentID=${default_site_Id}
                     ...  scope_name=Default rack

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate Scope Hierarchy on Node ##########

        ${status}    PCC.Check scope hierarchy on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  scope_from_user=[${scope_id},${default_site_Id},${default_zone_Id},${default_region_Id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Adding Node Role on Node  #####

        ${response}            PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${SERVER_2_NAME}"]
                               ...  roles=["MIXED"]

                               Should Be Equal As Strings      ${response}  OK

        ##### Validate Node Role Assignment on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Check roles assignment on node
                     ...  node_name=${SERVER_2_NAME}
                     ...  roles_id=[${mixed_node_role_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Validate RSOP on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate RSOP of a node
                     ...  node_name=${SERVER_2_NAME}
                     ...  policyIDs=[${ntp_region_policy_id},${dns_rack_policy_id},${snmpv3_policy_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Check SNMP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check SNMP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
		
		##### Validate SNMPv3 from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate SNMP from backend
                      ...  snmp_version=snmpv3
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  node_name=${SERVER_2_NAME}
                      ...  snmp_username=testuser
                      ...  snmp_password=testuserpwd
                      ...  snmp_encryption=testuser

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK

        ##### Validate DNS from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate DNS From Backend
                     ...  host_ip=${SERVER_2_HOST_IP}
                     ...  search_list=['www.rack.com','dns_rack1.com', 'dns_rack2.com']
                     ...  dns_server_ip=8.8.8.8

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Check NTP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check NTP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
		
		##### Validate NTP from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate NTP From Backend
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  time_zone=Australia/Currie

                      Should Be Equal As Strings      ${status}  OK

#####################################################################################################################################
Check if policies can be applied by policy update:TCP-1458
#####################################################################################################################################


        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=snmp

        ${response}    PCC.Update Policy
                       ...  Id=${snmpv2_policy_id}
                       ...  appId=${app_id}
                       ...  scopeIds=[${region-2_Id},${default_rack_Id}]
                       ...  description=SNMP_v2
                       ...  inputs=[{"name":"community_string","value":"snmpv2_community_string"}]


                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${scope_Id}    PCC.Get Scope Id
                       ...  scope_name=Default rack
                       ...  parentID=${default_site_Id}
                       Log To Console    ${scope_id}
                       Set Global Variable    ${scope_id}

        ##### Validate RSOP on Node ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate RSOP of a node
                     ...  node_name=${SERVER_2_NAME}
                     ...  policyIDs=[${ntp_region_policy_id},${dns_rack_policy_id},${snmpv2_policy_id}]

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Check SNMP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check SNMP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
		
		##### Validate SNMPv2 from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate SNMP from backend
                      ...  snmp_version=snmpv2
                      ...  community_string=snmpv2_community_string
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  node_name=${SERVER_2_NAME}

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK

        ##### Validate DNS from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate DNS From Backend
                     ...  host_ip=${SERVER_2_HOST_IP}
                     ...  search_list=['www.rack.com','dns_rack1.com', 'dns_rack2.com']
                     ...  dns_server_ip=8.8.8.8

                     Log To Console    ${status}
                     Should Be Equal As Strings      ${status}  OK

        ##### Check NTP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check NTP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK
		
		##### Validate NTP from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate NTP From Backend
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  time_zone=Australia/Currie

                      Should Be Equal As Strings      ${status}  OK


###################################################################################################################################
Check if policies can be applied by node Role delete:TCP-1463
###################################################################################################################################



        ####### Removing node role #######
        ${response}                 PCC.Delete and Verify Roles On Nodes
                               ...  nodes=["${SERVER_2_NAME}"]
                               ...  roles=["MIXED"]

                                    Should Be Equal As Strings      ${response}  OK


        ${status_code}              PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${SERVER_2_NAME}

                                    Should Be Equal As Strings      ${status_code}  OK

        ${scope_Id}    PCC.Get Scope Id
                       ...  scope_name=Default rack
                       ...  parentID=${default_site_Id}
                       Log To Console    ${scope_id}
                       Set Global Variable    ${scope_id}

        ##### Validate RSOP on Node(Should not be present - Negative) ##########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate RSOP of a node
                     ...  node_name=${SERVER_2_NAME}
                     ...  policyIDs=[${ntp_region_policy_id},${dns_rack_policy_id},${snmpv2_policy_id}]

                     Log To Console    ${status}
                     Should Not Be Equal As Strings      ${status}  OK

        ##### Check SNMP services from backend (Negative) #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check SNMP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Not Be Equal As Strings      ${status}  OK
		
		##### Validate SNMPv2 from backend (Negative) #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate SNMP from backend
                      ...  snmp_version=snmpv2
                      ...  community_string=snmpv2_community_string
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  node_name=${SERVER_2_NAME}

                      Log To Console    ${status}
                      Should Not Be Equal As Strings      ${status}  OK

        ##### Validate DNS from backend (Negative)#########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}    PCC.Validate DNS From Backend
                     ...  host_ip=${SERVER_2_HOST_IP}
                     ...  search_list=['www.rack.com','dns_rack1.com', 'dns_rack2.com']
                     ...  dns_server_ip=8.8.8.8

                     Log To Console    ${status}
                     Should Not Be Equal As Strings      ${status}  OK

        ##### Check NTP services from backend (Negative) #####

        ${node_wait_status}    PCC.Wait Until Node Ready
			       ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
                               
        ${status}     PCC.Check NTP services from backend
                      ...  targetNodeIp=['${SERVER_2_HOST_IP}']

                      Log To Console    ${status}
                      Should Not Be Equal As Strings      ${status}  OK
		
		##### Validate NTP from backend (Negative) #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate NTP From Backend
                      ...  host_ip=${SERVER_2_HOST_IP}
                      ...  time_zone=Australia/Currie

                      Should Not Be Equal As Strings      ${status}  OK

###################################################################################################################################
Policy driven management cleanup:TCP-1442
###################################################################################################################################

        [Documentation]    *Delete All Things related to Policy driven management feature* test
                           ...  keywords:
                           ...  PCC.Delete all Node roles
                           ...  PCC.Delete All Policies
                           ...  PCC.Delete Scope

        #### Deleting all node roles ####
        ${status}    PCC.Delete all Node roles

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role still exists

        #### Unassigning policies from default scopes ####

        ${response}    PCC.Update Scope
                       ...  Id=${default_region_Id}
                       ...  type=region
                       ...  scope_name=Default region
                       ...  description=Default region scope
                       ...  parentID=
                       ...  policyIDs=[]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${response}    PCC.Update Scope
                       ...  Id=${default_zone_Id}
                       ...  type=zone
                       ...  scope_name=Default zone
                       ...  description=Default zone scope
                       ...  parentID=${default_region_Id}
                       ...  policyIDs=[]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${response}    PCC.Update Scope
                       ...  Id=${default_site_Id}
                       ...  type=site
                       ...  scope_name=Default site
                       ...  description=Default site scope
                       ...  parentID=${default_zone_Id}
                       ...  policyIDs=[]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${response}    PCC.Update Scope
                       ...  Id=${default_rack_Id}
                       ...  type=rack
                       ...  scope_name=Default rack
                       ...  description=Default rack scope
                       ...  parentID=${default_site_Id}
                       ...  policyIDs=[]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ####  Delete scopes  ####
        ${response}    PCC.Delete Scope
                       ...  scope_name=region-1

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${response}    PCC.Delete Scope
                       ...  scope_name=region-2

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200


        #### Deleting all Policies ####
        ${status}    PCC.Delete All Policies

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK
