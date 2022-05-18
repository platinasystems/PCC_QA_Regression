*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_218

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
      [Tags]    kc

                                    Load Ceph Rbd Data    ${pcc_setup}
                                    Load Ceph Pool Data    ${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    Load Network Manager Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Check if PCC have a new entry under the applications list to represent the packages:TCP-1576,TCP-1577,TCP-1578,TCP-1580,TCP-1581,TCP-1609
###################################################################################################################################


        ${status}                   PCC.Validate Applications Present on PCC
                               ...  app_list=["OS Package Repository","Docker Community Package Repository","Ceph Community Package Repository","FRRouting Community Package Repository","Platina Systems Package Repository","Automatic Upgrades", "Node Self Healing"]

                               Log To Console   ${status}
                               Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Check if PCC define default node role for the following to include Platina Systems Package Repository:TCP-1582,TCP-1583,TCP-1584,TCP-1585
###################################################################################################################################

#        ## Check for Cluster Head node role
#        ${status}          PCC.Validate Node Role
#                           ...    Name=Cluster Head

#                           Log To Console   ${status}
#                           Should Be Equal As Strings    ${status}    OK

        ## Check for Ceph Resource node role
        ${status}          PCC.Validate Node Role
                           ...    Name=Ceph Resource

                           Log To Console   ${status}
                           Should Be Equal As Strings    ${status}    OK

        ## Check for Kubernetes Resource node role
        ${status}          PCC.Validate Node Role
                           ...    Name=Kubernetes Resource

                           Log To Console   ${status}
                           Should Be Equal As Strings    ${status}    OK

        ## Check for Network Resource node role
        ${status}          PCC.Validate Node Role
                           ...    Name=Network Resource

                           Log To Console   ${status}
                           Should Be Equal As Strings    ${status}    OK


#################################################################################################################################################################
Check if PCC assign the Default node role to the node when a node is added to PCC and Cluster Head node role when clusterhead is added to PCC:TCP-1586,TCP-1587,TCP-1591
#################################################################################################################################################################

        [Documentation]    *Check if PCC assign the Default node role to the node when a node is added to PCC* test

        ###### Deleting the node #####
        ${network_id}              PCC.Get Network Manager Id
                              ...  name=${NETWORK_MANAGER_NAME}
                                   Pass Execution If    ${network_id} is not ${None}    Network Cluster is Present Deleting Aborted

        ${status}                  PCC.Delete mutliple nodes and wait until deletion
                              ...  Names=['${SERVER_1_NAME}','${CLUSTERHEAD_1_NAME}']

                                   Log To Console    ${status}
                                   Should be equal as strings    ${status}    OK

        ${status}    PCC.Add multiple nodes and check online
                     ...  host_ips=['${CLUSTERHEAD_1_HOST_IP}', '${SERVER_1_HOST_IP}']
                     ...  Names=['${CLUSTERHEAD_1_NAME}','${SERVER_1_NAME}']

                     Log To Console    ${status}
                     Should be equal as strings    ${status}    OK

        #### Checking if PCC assign the Default node role to the node when a node is added to PCC #####
        ${status}    PCC.Verify Node Role On Nodes
                     ...    Name=Default
                     ...    nodes=["${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK
	
	#### Check Node Self Healing ####
	${status}    CLI.Validate Node Self Healing
		     ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
		     ...    linux_user=pcc
		     ...    linux_password=cals0ft
		     Log To Console    ${status}
                     Should be equal as strings    ${status}    OK

	${status}    CLI.Validate Node Self Healing
                     ...    host_ip=${SERVER_1_HOST_IP}
                     ...    linux_user=pcc
                     ...    linux_password=cals0ft
                     Log To Console    ${status}
                     Should be equal as strings    ${status}    OK

################################################################################################################################################################
Check if user is able to assign the CEPH resource, Kubernetes resource, Network resource node role to the cluster head:TCP-1587,TCP-1660,TCP-1661,TCP-1662
################################################################################################################################################################
    [Documentation]                 *Check if user is able to assign the Cluster Head node role to the cluster head*
                               ...  Keywords:
                               ...  PCC.Add and Verify Roles On Nodes
                               ...  PCC.Wait Until Roles Ready On Nodes


        ${response}                 PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${CLUSTERHEAD_1_NAME}"]
                               ...  roles=["Default", "Ceph Resource", "Kubernetes Resource", "Network Resource"]

                                    Should Be Equal As Strings      ${response}  OK

                ${response}                 PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${SERVER_1_NAME}"]
                               ...  roles=["Default", "Ceph Resource", "Kubernetes Resource", "Network Resource"]

                                    Should Be Equal As Strings      ${response}  OK

                ${status_code}              PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${SERVER_1_NAME}

                                    Should Be Equal As Strings      ${status_code}  OK

        ${status_code}              PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${CLUSTERHEAD_1_NAME}

                                    Should Be Equal As Strings      ${status_code}  OK

        ${status}    PCC.Verify Node Role On Nodes
                     ...    Name=Default
                     ...    nodes=["${CLUSTERHEAD_1_NAME}"]

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK

        ${status}    PCC.Verify Node Role On Nodes
                     ...    Name=Ceph Resource
                     ...    nodes=["${CLUSTERHEAD_1_NAME}"]

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK

        ${status}    PCC.Verify Node Role On Nodes
                     ...    Name=Kubernetes Resource
                     ...    nodes=["${CLUSTERHEAD_1_NAME}"]

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK

        ${status}    PCC.Verify Node Role On Nodes
                     ...    Name=Network Resource
                     ...    nodes=["${CLUSTERHEAD_1_NAME}"]

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK

###############################################################################################################################################
Backend Validations after node roles addition :TCP-1610
###############################################################################################################################################
        [Documentation]                 *Backend validations*
                               ...  Keywords:

                [Tags]    Only
                ${status}    CLI.Validate Kubernetes Resource
                                         ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                                         ...    linux_user=pcc
                     ...    linux_password=cals0ft

                                         Should Be Equal As Strings    ${status}    OK

                ${status}    CLI.Validate CEPH Resource
                                         ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                                         ...    linux_user=pcc
                     ...    linux_password=cals0ft

                                         Should Be Equal As Strings    ${status}    OK

                ${status}    CLI.Validate Network Resource
                                         ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                                         ...    linux_user=pcc
                     ...    linux_password=cals0ft

                                         Should Be Equal As Strings    ${status}    OK

                ${status}    CLI.OS Package repository
                                         ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                                         ...    linux_user=pcc
                     ...    linux_password=cals0ft

                                         Should Be Equal As Strings    ${status}    OK

                ${status}    CLI.Validate Node Self Healing
                                         ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                                         ...    linux_user=pcc
                     ...    linux_password=cals0ft

                                         Should Be Equal As Strings    ${status}    OK

                ${status}    CLI.Validate Node Self Healing
                                         ...    host_ip=${SERVER_1_HOST_IP}
                                         ...    linux_user=pcc
                     ...    linux_password=cals0ft

                                         Should Be Equal As Strings    ${status}    OK

                ${status}    CLI.Validate Node Self Healing
                                         ...    host_ip=${SERVER_2_HOST_IP}
                                         ...    linux_user=pcc
                     ...    linux_password=cals0ft

                                         Should Be Equal As Strings    ${status}    OK

################################################################################################################################################
#Reboot Node and check Backend Validations after node is up (TCP-1684)
################################################################################################################################################
#        [Documentation]                 *Backend validations*
#                               ...  Keywords:
#
#                [Tags]    Only
#                ${status}        Restart node
#                                         ...    hostip=${CLUSTERHEAD_1_HOST_IP}
#                                         ...    username=pcc
#			                 ...    password=cals0ft
#                                         ...    time_to_wait=240
#
#                                         Should Be Equal As Strings    ${status}    OK
#		
#		${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${CLUSTERHEAD_1_NAME}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK
#
#                ${status}    CLI.Validate Kubernetes Resource
#                                         ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
#                                         ...    linux_user=pcc
#                     ...    linux_password=cals0ft
#
#                                         Should Be Equal As Strings    ${status}    OK
#
#                ${status}    CLI.Validate CEPH Resource
#                                         ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
#                                         ...    linux_user=pcc
#                     ...    linux_password=cals0ft
#
#                                         Should Be Equal As Strings    ${status}    OK
#
#                ${status}    CLI.Validate Network Resource
#                                         ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
#                                         ...    linux_user=pcc
#                     ...    linux_password=cals0ft
#
#                                         Should Be Equal As Strings    ${status}    OK
#
#                ${status}    CLI.Validate Platina Systems Package repository
#                                         ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
#                                         ...    linux_user=pcc
#                     ...    linux_password=cals0ft
#
#                                         Should Be Equal As Strings    ${status}    OK
#
#                ${status}    CLI.OS Package repository
#                                         ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
#                                         ...    linux_user=pcc
#                     ...    linux_password=cals0ft
#
#                                         Should Be Equal As Strings    ${status}    OK
#
#                ${status}    CLI.Validate Node Self Healing
#                                         ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
#                                         ...    linux_user=pcc
#                     ...    linux_password=cals0ft
#
#                                         Should Be Equal As Strings    ${status}    OK
#

###############################################################################################################################################
Check if an user is able to define a policy to disable Automatic Daily Updates: TCP-1603,TCP-1604
###############################################################################################################################################

    [Documentation]                 *Check if an user is able to define a policy to disable Automatic Daily Updates*
                                                                        ...  keywords:
                                                                        ...  PCC.Create Policy
        [Tags]    Last
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

           ${app_id}    PCC.Get App Id from Policies
                                        ...  Name=automatic-upgrades
                                        Log To Console    ${app_id}

           ${response}    PCC.Create Policy
                                          ...  appId=${app_id}
                                          ...  description=Automatic-upgrade-policy
                                          ...  scopeIds=[${default_rack_Id}]
                                          ...  inputs=[{"name": "enabled","value": "true"}]

                                          Log To Console    ${response}
                                          ${result}    Get Result    ${response}
                                          ${status}    Get From Dictionary    ${result}    status
                                          ${message}    Get From Dictionary    ${result}    message
                                          Log to Console    ${message}
                                          Should Be Equal As Strings    ${status}    200

                ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${CLUSTERHEAD_1_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

                ### Validation after setting automatic-upgrades to Yes ####

                ${status}               CLI.Automatic Upgrades Validation
                                                ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                                                ...    linux_user=pcc
                                                ...    linux_password=cals0ft

                                                Should Be Equal As Strings    ${status}    Automatic upgrades set to Yes from backend



                ### Setting automatic-upgrades policy to No

                ${policy_id}    PCC.Get Policy Id
                        ...  Name=automatic-upgrades
                        ...  description=Automatic-upgrade-policy
                                                Log To Console    ${policy_id}

        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=automatic-upgrades
                                         Log To Console    ${app_id}



        ${response}    PCC.Update Policy
                       ...  Id=${policy_id}
                       ...  appId=${app_id}
                       ...  scopeIds=[${default_rack_Id}]
                       ...  description=Automatic-upgrade-policy
                       ...  inputs=[{"name": "enabled","value": "false"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${CLUSTERHEAD_1_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

                ### Validation after setting automatic-upgrades to No ####

                ${status}               CLI.Automatic Upgrades Validation
                                                ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                                                ...    linux_user=pcc
                                                ...    linux_password=cals0ft

                                                Should Be Equal As Strings    ${status}    Automatic upgrades set to No from backend

#################################################################################################################################################################
Remove a node from PCC on which node roles are installed and check backend repo exists after deletion: TCP-1686
#################################################################################################################################################################

        [Documentation]    *Remove a node from PCC on which node roles are installed and check backend repo exists after deletion* test

        ###### Deleting the node #####
        ${network_id}              PCC.Get Network Manager Id
                              ...  name=${NETWORK_MANAGER_NAME}
                                   Pass Execution If    ${network_id} is not ${None}    Network Cluster is Present Deleting Aborted

        ${status}                  PCC.Delete mutliple nodes and wait until deletion
                              ...  Names=['${SERVER_1_NAME}']

                                   Log To Console    ${status}
                                   Should be equal as strings    ${status}    OK

                ${status}    CLI.Validate Kubernetes Resource
                                         ...    host_ip=${SERVER_1_HOST_IP}
                                         ...    linux_user=pcc
                     ...    linux_password=cals0ft

                                         Should Not Be Equal As Strings    ${status}    OK

                ${status}    CLI.Validate CEPH Resource
                                         ...    host_ip=${SERVER_1_HOST_IP}
                                         ...    linux_user=pcc
                     ...    linux_password=cals0ft

                                         Should Not Be Equal As Strings    ${status}    OK

                ${status}    CLI.Validate Network Resource
                                         ...    host_ip=${SERVER_1_HOST_IP}
                                         ...    linux_user=pcc
                     ...    linux_password=cals0ft

                                         Should Not Be Equal As Strings    ${status}    OK

                ${status}    CLI.OS Package repository
                                         ...    host_ip=${SERVER_1_HOST_IP}
                                         ...    linux_user=pcc
                     ...    linux_password=cals0ft

                                         Should Not Be Equal As Strings    ${status}    OK



###############################################################################################################################################
Check Automatic Upgrades policy accept invalid value for Enable/disable automatic upgrades field:TCP-1606
###############################################################################################################################################

    [Documentation]                 *Check if an user is able to define a policy to disable Automatic Daily Updates*
                                                                        ...  keywords:
                                                                        ...  PCC.Create Policy

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

           ${app_id}    PCC.Get App Id from Policies
                                        ...  Name=automatic-upgrades
                                        Log To Console    ${app_id}

           ${response}    PCC.Create Policy
                                          ...  appId=${app_id}
                                          ...  description=Automatic-upgrade-policy
                                          ...  scopeIds=[${default_rack_Id}]
                                          ...  inputs=[{"name": "enabled","value": "bjkjad"}]

                                          Log To Console    ${response}
                                          ${result}    Get Result    ${response}
                                          ${status}    Get From Dictionary    ${result}    status
                                          ${message}    Get From Dictionary    ${result}    message
                                          Log to Console    ${message}
                                          Should Not Be Equal As Strings    ${status}    200

# ###############################################################################################################################################
# Check if user is able to remove CEPH resource, Kubernetes resource, Network resource node role to the clusterhead:TCP-1598,TCP-1599,TCP-1600,TCP-1601
# ###############################################################################################################################################
#     [Documentation]                 *Check if user is able to remove the Cluster Head node role to the cluster head*
#                                ...  Keywords:
#                                ...  PCC.Add and Verify Roles On Nodes
#                                ...  PCC.Wait Until Roles Ready On Nodes


#                 ${response}                 PCC.Delete and Verify Roles On Nodes
#                                ...  nodes=["${CLUSTERHEAD_1_NAME}"]
#                                ...  roles=["Ceph Resource", "Kubernetes Resource", "Network Resource"]

#                                     Should Be Equal As Strings      ${response}  OK

#         ${status_code}              PCC.Wait Until Roles Ready On Nodes
#                                ...  node_name=${CLUSTERHEAD_1_NAME}

#                                     Should Be Equal As Strings      ${status_code}  OK

#         ${status}    PCC.Verify Node Role On Nodes
#                      ...    Name=Ceph Resource
#                      ...    nodes=["${CLUSTERHEAD_1_NAME}"]

#                      Log To Console    ${status}
#                      Should Not Be Equal As Strings    ${status}    OK

#         ${status}    PCC.Verify Node Role On Nodes
#                      ...    Name=Kubernetes Resource
#                      ...    nodes=["${CLUSTERHEAD_1_NAME}"]

#                      Log To Console    ${status}
#                      Should Not Be Equal As Strings    ${status}    OK

#         ${status}    PCC.Verify Node Role On Nodes
#                      ...    Name=Network Resource
#                      ...    nodes=["${CLUSTERHEAD_1_NAME}"]

#                      Log To Console    ${status}
#                      Should Not Be Equal As Strings    ${status}    OK

# ###############################################################################################################################################
# Backend Validations after node roles deletion
# ###############################################################################################################################################
#         [Documentation]                 *Backend validations*
#                                ...  Keywords:


#                 ${status}    CLI.Validate Kubernetes Resource
#                                          ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
#                                          ...    linux_user=pcc
#                      ...    linux_password=cals0ft

#                                          Should Be Equal As Strings    ${status}    OK

#                 ${status}    CLI.Validate CEPH Resource
#                                          ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
#                                          ...    linux_user=pcc
#                      ...    linux_password=cals0ft

#                                          Should Be Equal As Strings    ${status}    OK

#                 ${status}    CLI.Validate Network Resource
#                                          ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
#                                          ...    linux_user=pcc
#                      ...    linux_password=cals0ft

#                                          Should Be Equal As Strings    ${status}    OK

#                 ${status}    CLI.OS Package repository
#                                          ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
#                                          ...    linux_user=pcc
#                      ...    linux_password=cals0ft

#                                          Should Be Equal As Strings    ${status}    OK

###############################################################################################################################################
System Package Updates cleanup
###############################################################################################################################################
            #### Unassign loactions from policies ####

                ${status}    PCC.Unassign Locations Assigned from All Policies

                           Log To Console    ${status}
                           Should Be Equal As Strings    ${status}    OK

            #### Wait until all nodes are ready ####

                ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

		${status}     PCC.Delete All Policies

                      Log To Console    ${status}
                      Should Be Equal As Strings    ${status}    OK

###############################################################################################################################################
Ethtool Backend Validation
###############################################################################################################################################
        [Documentation]                 *Backend validations*
                               ...  Keywords: CLI.Validate Ethtool

        [Tags]        kc

        ${status}                   CLI.Validate Ethtool
                             ...    host_ips=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Should Be Equal As Strings    ${status}    OK

