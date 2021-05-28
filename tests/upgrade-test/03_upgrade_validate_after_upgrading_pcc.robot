*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                                Load Clusterhead 1 Test Data        ${pcc_setup}
                                                Load Clusterhead 2 Test Data        ${pcc_setup}
                                                Load Server 2 Test Data        ${pcc_setup}
                                                Load Server 1 Test Data        ${pcc_setup}
                                                Load Server 3 Test Data        ${pcc_setup}
                                                Load Network Manager Data    ${pcc_setup}
                                                Load Container Registry Data    ${pcc_setup}
                                                Load Auth Profile Data    ${pcc_setup}
                                                Load OpenSSH_Keys Data    ${pcc_setup}
                                                Load Ceph Cluster Data    ${pcc_setup}
                                                Load Ceph Pool Data    ${pcc_setup}
                                                Load Ceph Rbd Data    ${pcc_setup}
                                                Load Ceph Fs Data    ${pcc_setup}
                                                Load Ceph Rgw Data    ${pcc_setup}
                                                Load Tunneling Data    ${pcc_setup}
                                                Load K8s Data    ${pcc_setup}
                                                Load PXE-Boot Data    ${pcc_setup}
                                                Load Alert Data    ${pcc_setup}
                                                Load SAS Enclosure Data    ${pcc_setup}
                                                Load Ipam Data    ${pcc_setup}
                                                Load Certificate Data    ${pcc_setup}
                                                Load i28 Data    ${pcc_setup}
                                                Load OS-Deployment Data    ${pcc_setup}
                                                Load Tenant Data    ${pcc_setup}
                                                Load Node Roles Data    ${pcc_setup}
                                                Load Node Groups Data    ${pcc_setup}
						                        Load PCC Test Data    ${pcc_setup}

###################################################################################################################################
Upgrade PCC
###################################################################################################################################
	[Documentation]                *Upgrade PCC*
                                   ...  keywords:
                                   ...  CLI.Pcc Down

#	###  Making CLI Down  ####
#	${status}		CLI.Pcc Down
#					...    host_ip=${PCC_HOST_IP}
#					...    pcc_password=${PCC_SETUP_PWD}
#					...    linux_user=${PCC_LINUX_USER}
#					...    linux_password=${PCC_LINUX_PASSWORD}
#
#					Should Be Equal As Strings    ${status}    OK

	### Taking PCC to stable version   ###
	${status}                CLI.PCC Pull Code
					         ...  host_ip=${PCC_HOST_IP}
					         ...  linux_user=${PCC_LINUX_USER}
					         ...  linux_password=${PCC_LINUX_PASSWORD}
					         ...  pcc_version_cmd=sudo /home/pcc/platina-cli-ws/platina-cli upgrade -p ${PCC_SETUP_PWD} --release v1.7.1-rc1

                             #...  pcc_version_cmd=sudo /home/pcc/platina-cli-ws/platina-cli run -u ${PCC_SETUP_USERNAME} -p ${PCC_SETUP_PWD} --url https://cust-dev.lab.platinasystems.com --insecure --registryUrl https://cust-dev.lab.platinasystems.com:5000 --ru ${PCC_SETUP_USERNAME} --rp ${PCC_SETUP_PWD} --insecureRegistry --prtKey /home/pcc/i28-keys/i28-id_rsa --pblKey /home/pcc/i28-keys/i28-authorized_keys --release stable --configRepo master

                             Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Login to PCC
###################################################################################################################################
	[Documentation]                *Login to PCC and load data*

    ${status}                Login To PCC        testdata_key=${pcc_setup}
                             Should be equal as strings    ${status}    OK

###################################################################################################################################
Validation scoping object
###################################################################################################################################

    ${status}                PCC.Check Scope Creation From PCC
                             ...  scope_name=region-1

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

    ${status}                PCC.Check Scope Creation From PCC
                             ...  scope_name=zone-1

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

    ${status}                PCC.Check Scope Creation From PCC
                             ...  scope_name=site-1

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

    ${status}                PCC.Check Scope Creation From PCC
                             ...  scope_name=rack-1

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK


###################################################################################################################################
Nodes Verification after upgrading PCC
###################################################################################################################################
    [Documentation]                *Nodes Verification Back End*
                                   ...  keywords:
                                   ...  PCC.Node Verify Back End

	${status}                PCC.Add mutliple nodes and check online
                             ...  host_ips=['${CLUSTERHEAD_1_HOST_IP}', '${CLUSTERHEAD_2_HOST_IP}', '${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}','${SERVER_3_HOST_IP}']
                             ...  Names=['${CLUSTERHEAD_1_NAME}', '${CLUSTERHEAD_2_NAME}', '${SERVER_1_NAME}','${SERVER_2_NAME}','${SERVER_3_NAME}']

                             Log To Console    ${status}
                             Should be equal as strings    ${status}    OK

    ${status}                PCC.Node Verify Back End
                             ...  host_ips=["${SERVER_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                             Should Be Equal As Strings      ${status}    OK

#################################################################################################################################################################
Verify Default node role is installed and all the apps persist from backend
#################################################################################################################################################################

    [Documentation]                *Verify Default node role is installed* test

        #### Checking if PCC assign the Default node role to the node when a node is added to PCC #####
    ${status}                PCC.Verify Node Role On Nodes
                             ...    Name=Default
                             ...    nodes=["${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}","${SERVER_1_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK


    ${status}                PCC.Verify LLDP Neighbors
                             ...    servers_hostip=['${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}','${SERVER_3_HOST_IP}']
                             ...    invaders_hostip=['${CLUSTERHEAD_1_HOST_IP}','${CLUSTERHEAD_2_HOST_IP}']

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

    ${status}                CLI.OS Package repository
                             ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

    ${status}                CLI.OS Package repository
                             ...    host_ip=${CLUSTERHEAD_2_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

    ${status}                CLI.OS Package repository
                             ...    host_ip=${SERVER_1_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

    ${status}                CLI.OS Package repository
                             ...    host_ip=${SERVER_2_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

    ${status}                CLI.OS Package repository
                             ...    host_ip=${SERVER_3_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK


    ${status}                CLI.Validate Node Self Healing
                             ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

    ${status}                CLI.Validate Node Self Healing
                             ...    host_ip=${CLUSTERHEAD_2_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK


    ${status}                CLI.Validate Node Self Healing
                             ...    host_ip=${SERVER_1_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

    ${status}                CLI.Validate Node Self Healing
                             ...    host_ip=${SERVER_2_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

    ${status}                CLI.Validate Node Self Healing
                             ...    host_ip=${SERVER_3_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

    ${status}                CLI.Automatic Upgrades Validation
                             ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    Automatic upgrades set to Yes from backend

    ${status}                CLI.Automatic Upgrades Validation
                             ...    host_ip=${CLUSTERHEAD_2_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    Automatic upgrades set to Yes from backend

    ${status}                PCC.Check NTP services from backend
                             ...   targetNodeIp=['${SERVER_2_HOST_IP}','${SERVER_1_HOST_IP}','${SERVER_3_HOST_IP}','${CLUSTERHEAD_1_HOST_IP}','${CLUSTERHEAD_2_HOST_IP}']

                             Log To Console    ${status}
                             Should Be Equal As Strings      ${status}  OK


    ${status}                CLI.Validate Ethtool
                             ...    host_ips=['${CLUSTERHEAD_1_HOST_IP}','${CLUSTERHEAD_2_HOST_IP}','${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}','${SERVER_3_HOST_IP}']
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Verify Maas on Invader
###################################################################################################################################
    [Documentation]                *Verify Maas on Invader*
                                   ...  Keywords:
                                   ...  PCC.Maas Verify BE

    ${response}                PCC.Maas Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}"]
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               Should Be Equal As Strings      ${response}  OK


###################################################################################################################################
Check App catalog for all the existing apps
###################################################################################################################################


        ${status}                   PCC.Validate Applications Present on PCC
                               ...  app_list=['LLDP', 'Baremetal Services', 'ETHTOOL', 'DNS client', 'NTP client', 'RSYSLOG client', 'SNMP agent', 'OS Package Repository', 'Docker Community Package Repository', 'Ceph Community Package Repository', 'FRRouting Community Package Repository', 'Platina Systems Package Repository', 'Automatic Upgrades', 'Node Self Healing']

                               Log To Console   ${status}
                               Should Be Equal As Strings    ${status}    OK


###################################################################################################################################
PCC-Tenant-Validation For Upgrade and restore
###################################################################################################################################

    [Documentation]                *Create Tenant* test
                                   ...    keywords:
                                   ...    PCC.Validate Tenant


    ${status}                PCC.Validate Tenant
                             ...    Name=${CR_TENANT_USER}

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
PCC-Validate Read Only User login
###################################################################################################################################

    [Documentation]                *Create Password* test
                                   ...  keywords:
                                   ...  Login To User
                                   ...  Login To PCC


    ${status}                Login To User
						     ...  ${pcc_setup}
						     ...  ${READONLY_USER_PCC_USERNAME}
						     ...  ${READONLY_USER_PCC_PWD}

						     Should Be Equal As Strings      ${status}    OK

    ${status}                Login To PCC    ${pcc_setup}
                             Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
PCC-Validate Tenant User (Admin) login
###################################################################################################################################

    [Documentation]                *Create Password* test
                                   ...  keywords:
                                   ...  Login To User
                                   ...  Login To PCC

    ${status}                Login To User
						     ...  ${pcc_setup}
						     ...  ${TENANT_USER_PCC_USERNAME}
						     ...  ${TENANT_USER_PCC_PWD}

						     Should Be Equal As Strings      ${status}    OK

    ${status}                Login To PCC    ${pcc_setup}
                             Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Pcc Verification for Tenant Assignment(SERVER_2_NAME)
###################################################################################################################################

    [Documentation]                *Pcc-Tenant-Assignment* test
                                   ...  keywords:
                                   ...  PCC.Validate Tenant Assigned to Node


    ${status}                PCC.Validate Tenant Assigned to Node
                             ...    Name=${SERVER_2_NAME}
                             ...    Tenant_Name=${CR_TENANT_USER}

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
PCC Node Group Verification For Upgrade and restore
###################################################################################################################################

    [Documentation]                *PCC Node Group - Verify if user can access node group* test
                                   ...  keywords:
                                   ...  PCC.Validate Node Group

    ${status}                PCC.Validate Node Group
                             ...    Name=${NODE_GROUP1}

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK    Node group doesnot exists



###################################################################################################################################
Alert Verify Raw Rule
###################################################################################################################################
    [Documentation]                 *Alert Verify Raw Rule*
                               ...  Keywords:
                               ...  PCC.Alert Verify Rule

        ${status}                   PCC.Alert Verify Raw Rule
                               ...  name=FreeSwap
                               ...  auth_data=${PCC_CONN}
                               ...  setup_ip=${PCC_HOST_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}

                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Validate DNS client node role
###################################################################################################################################

        [Documentation]    *Validate node role with DNS client application* test
                           ...  keywords:
                           ...  PCC.Validate Node Role


        ${status}    PCC.Validate Node Role
                     ...    Name=DNS_NODE_ROLE

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists

###################################################################################################################################
Validate NTP client node role
###################################################################################################################################

        [Documentation]    *Validate node role with NTP client application* test
                           ...  keywords:
                           ...  PCC.Validate Node Role


        ${status}    PCC.Validate Node Role
                     ...    Name=NTP_NODE_ROLE

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists

###################################################################################################################################
Validate SNMP agent node role
###################################################################################################################################

        [Documentation]    *Validate node role with SNMPv2 client application* test
                           ...  keywords:
                           ...  PCC.Validate Node Role


        ${status}    PCC.Validate Node Role
                     ...    Name=SNMPv2_NODE_ROLE

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists



###################################################################################################################################
Validate RSYSLOG client node role
###################################################################################################################################

        [Documentation]    *Validate RSYSLOG client node role* test
                           ...  keywords:
                           ...  PCC.Validate Node Role


        ${status}    PCC.Validate Node Role
                     ...    Name=Rsyslog-NR

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists


###################################################################################################################################
Verifying DNS client Policy assignment from backend
###################################################################################################################################

		##### Validate RSOP on Node ##########

        ${dns_rack_policy_id}                PCC.Get Policy Id
                                             ...  Name=dns
                                             ...  description=dns-policy-description
                                             Log To Console    ${dns_rack_policy_id}
                                             Set Global Variable    ${dns_rack_policy_id}

		${status}                            PCC.Validate RSOP of a node
                                             ...  node_name=${CLUSTERHEAD_1_NAME}
                                             ...  policyIDs=[${dns_rack_policy_id}]

                                             Log To Console    ${status}
                                             Should Be Equal As Strings      ${status}  OK

		##### Validate DNS from backend #########

        ${node_wait_status}                  PCC.Wait Until Node Ready
                                             ...  Name=${CLUSTERHEAD_1_NAME}

                                             Log To Console    ${node_wait_status}
                                             Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}                            PCC.Validate DNS From Backend
                                             ...  host_ip=${CLUSTERHEAD_1_HOST_IP}
                                             ...  search_list=['8.8.8.8']

                                             Log To Console    ${status}
                                             Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Verifying NTP client Policy assignment from backend
###################################################################################################################################

		##### Validate RSOP on Node ##########

        ${ntp_rack_policy_id}                PCC.Get Policy Id
                                             ...  Name=ntp
                                             ...  description=ntp-policy-description
                                             Log To Console    ${ntp_rack_policy_id}
                                             Set Global Variable    ${ntp_rack_policy_id}

		${status}                            PCC.Validate RSOP of a node
                                             ...  node_name=${CLUSTERHEAD_1_NAME}
                                             ...  policyIDs=[${ntp_rack_policy_id}]

                                             Log To Console    ${status}
                                             Should Be Equal As Strings      ${status}  OK



		##### Check NTP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${CLUSTERHEAD_1_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}                PCC.Check NTP services from backend
                                 ...  targetNodeIp=['${CLUSTERHEAD_1_HOST_IP}']

                                 Log To Console    ${status}
                                 Should Be Equal As Strings      ${status}  OK

		##### Validate NTP from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${CLUSTERHEAD_1_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate NTP From Backend
                      ...  host_ip=${CLUSTERHEAD_1_HOST_IP}
                      ...  time_zone=America/Chicago

                      Should Be Equal As Strings      ${status}  OK



###################################################################################################################################
Verifying SNMP client Policy assignment from backend
###################################################################################################################################

		##### Validate RSOP on Node ##########

        ${snmp_rack_policy_id}                PCC.Get Policy Id
                                             ...  Name=snmp
                                             ...  description=SNMP_v2
                                             Log To Console    ${snmp_rack_policy_id}
                                             Set Global Variable    ${snmp_rack_policy_id}

		${status}                            PCC.Validate RSOP of a node
                                             ...  node_name=${CLUSTERHEAD_1_NAME}
                                             ...  policyIDs=[${snmp_rack_policy_id}]

                                             Log To Console    ${status}
                                             Should Be Equal As Strings      ${status}  OK


		##### Validate SNMPv2 from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${CLUSTERHEAD_1_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate SNMP from backend
                      ...  snmp_version=snmpv2
                      ...  community_string=snmpv2_community_string
                      ...  host_ip=${CLUSTERHEAD_1_HOST_IP}
                      ...  node_name=${CLUSTERHEAD_1_NAME}

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK



###################################################################################################################################
Verifying Rsyslog Policy assignment from backend
###################################################################################################################################
	[Documentation]                      *Verifying Policy assignment from backend* test
                                          ...  keywords:
                                          ...  PCC.Create Policy



		##### Validate RSOP on Node ##########

        ${rsyslog_policy_id}                PCC.Get Policy Id
                                             ...  Name=rsyslogd
                                             ...  description=rsyslog-policy
                                             Log To Console    ${rsyslog_policy_id}
                                             Set Global Variable    ${rsyslog_policy_id}

		${status}                            PCC.Validate RSOP of a node
                                             ...  node_name=${CLUSTERHEAD_1_NAME}
                                             ...  policyIDs=[${rsyslog_policy_id}]

                                             Log To Console    ${status}
                                             Should Be Equal As Strings      ${status}  OK

		##### Validate Rsyslog from backend #########

        ${status}                           CLI.Check package installed
                                            ...    package_name=rsyslog
                                            ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                                            ...    linux_user=${PCC_LINUX_USER}
                                            ...    linux_password=${PCC_LINUX_PASSWORD}

                                            Log To Console    ${status}
                                            Should Be Equal As Strings    ${status}    rsyslog Package installed

###################################################################################################################################
Verifying Automatic Upgrade Policy assignment from backend
###################################################################################################################################

	   ### Validation after setting automatic-upgrades to No ####

       ${status}            CLI.Automatic Upgrades Validation
                            ...     host_ip=${CLUSTERHEAD_1_HOST_IP}
                            ...     linux_user=pcc
                            ...     linux_password=cals0ft

                            Should Be Equal As Strings    ${status}    Automatic upgrades set to No from backend

###################################################################################################################################
Check internet reachability from nodes
###################################################################################################################################

        ${status}                   PCC.Verify Default IgwPolicy BE
                                    ...  nodes=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify Network Manager
###################################################################################################################################
    [Documentation]                 *Verify Network Manager *
                                    ...  keywords:
                                    ...  PCC.Network Manager Create


		####  Verify Network Manager from Backend ####
		${status}              PCC.Network Manager Verify BE
                               ...  nodes_ip=${NETWORK_MANAGER_NODES_IP}
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                               ...  controlCIDR=${IPAM_CONTROL_SUBNET_IP}
                               Should Be Equal As Strings      ${status}  OK

		${status}              PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                               Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify Certificate Authority Public Certificate
###################################################################################################################################

        [Documentation]    *Verify Certificate* test


        ${response}    PCC.Get Certificates
                       ...  Alias=Cert_without_pvt_cert
                       Log To Console    ${response}
                       Should Be Equal As Strings    ${response}    OK

###################################################################################################################################
Verify Private/Public Cert keypair for RGW
###################################################################################################################################

        [Documentation]    *Verify Certificate* test

        ${response}    PCC.Get Certificates
                       ...  Alias=${CEPH_RGW_CERT_NAME}
                       Log To Console    ${response}
                       Should Be Equal As Strings    ${response}    OK


###################################################################################################################################
Verify OpenSSH Public Key
###################################################################################################################################

        [Documentation]    *Verify Public Key* test


        ${response}    PCC.Get Open SSH Key
                       ...  Alias=${PUBLIC_KEY_ALIAS}
                       Log To Console    ${response}
                       Should Be Equal As Strings    ${response}    OK


###################################################################################################################################
Verify Application credential profile without application
###################################################################################################################################

        [Documentation]               *Verify Metadata Profile* test
                                      ...  keywords:
                                      ...  PCC.Add Metadata Profile


        ${response}   PCC.Describe Profile By Id
                      ...  Name=${CEPH_RGW_S3ACCOUNTS}
                      Log To Console    $response}
                      ${result}    Get Result    ${response}
                      ${status}    Get From Dictionary    ${result}    status
                      Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Verify Ceph Cluster
###################################################################################################################################
    [Documentation]                 *Verify Ceph Cluster*
                                    ...  keywords:
                                    ...  PCC.Ceph Verify BE

        ${status}                   PCC.Ceph Verify BE
                                    ...  user=${PCC_LINUX_USER}
                                    ...  password=${PCC_LINUX_PASSWORD}
                                    ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_3_HOST_IP}","${SERVER_1_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Ceph Crush Map Validation
###################################################################################################################################
    [Documentation]                 *Ceph Crush Map Validation*
                               ...  keywords:
                               ...  CLI.Validate CEPH Crush Map From Backend


        ${status}                   CLI.Validate CEPH Crush Map From Backend
                               ...  node_location={"${SERVER_3_NAME}":["default-region","default-zone","default-site","default-rack"],"${SERVER_1_NAME}":["default-region","default-zone","default-site","default-rack"]}
                               ...  hostip=${SERVER_3_HOST_IP}

                                    Should Be Equal As Strings      ${status}    OK    Validation unsuccessful


	    ${status}                   CLI.Validate CEPH Crush Map From Backend
                               ...  node_location={"${SERVER_3_NAME}":["default-region","default-zone","default-site","default-rack"],"${SERVER_1_NAME}":["default-region","default-zone","default-site","default-rack"]}
		                       ...  hostip=${SERVER_1_HOST_IP}

                                    Should Be Equal As Strings      ${status}    OK    Validation unsuccessful


###################################################################################################################################
Ceph Storage Type Validation
###################################################################################################################################
    [Documentation]                 *Ceph Storage Type Validation*
                                    ...  keywords:
                                    ...  CLI.Validate CEPH Storage Type

        ${status}    CLI.Validate CEPH Storage Type
                     ...  storage_types=['bluestore']
                     ...  hostip=${SERVER_3_HOST_IP}

                     Should Be Equal As Strings      ${status}    OK

	    ${status}    CLI.Validate CEPH Storage Type
                     ...  storage_types=['bluestore']
                     ...  hostip=${SERVER_1_HOST_IP}

                     Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Verify Ceph Architecture- Nodes and OSDs
###################################################################################################################################
    [Documentation]                 *Verify Ceph Architecture Node OSDs*
                                    ...  keywords:
                                    ...  PCC.Ceph Nodes OSDs Architecture Validation


        ${status}    PCC.Ceph Nodes OSDs Architecture Validation
                     ...  name=${CEPH_CLUSTER_NAME}
                     ...  hostip=${SERVER_1_HOST_IP}

                     Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify Ceph Pools After Upgrade
###################################################################################################################################

    [Documentation]                             *Verify Ceph Pools After Upgrade*
                                                ...  keywords:
                                                ...  PCC.Ceph Get Cluster Id
                                                ...  PCC.Ceph Create Pool
                                                ...  PCC.Ceph Wait Until Pool Ready


        ${status}                               PCC.Ceph Pool Verify BE
                                                ...  name=rbd
                                                ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                                                log to console                  ${status}
                                                Should Be Equal As Strings      ${status}    OK



        ${status}                               PCC.Ceph Pool Verify BE
                                                ...  name=rgw
                                                ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                                                log to console                  ${status}
                                                Should Be Equal As Strings      ${status}    OK



        ${status}                               PCC.Ceph Pool Verify BE
                                                ...  name=fs1
                                                ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                                                log to console                  ${status}
                                                Should Be Equal As Strings      ${status}    OK




        ${status}                               PCC.Ceph Pool Verify BE
                                                ...  name=fs2
                                                ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                                                log to console                  ${status}
                                                Should Be Equal As Strings      ${status}    OK



        ${status}                               PCC.Ceph Pool Verify BE
                                                ...  name=fs3
                                                ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                                                log to console                  ${status}
                                                Should Be Equal As Strings      ${status}    OK


        ${status}                               PCC.Ceph Pool Verify BE
                                                ...  name=k8s-pool
                                                ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                                                log to console                  ${status}
                                                Should Be Equal As Strings      ${status}    OK


        ${status}              PCC.Ceph Pool Verify BE
                               ...  name=rgw-erasure-pool
                               ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                               log to console                  ${status}
                               Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify Ceph Rados Gateway With EC Pool Without S3 Accounts After Upgrade
#####################################################################################################################################
	[Documentation]                             *Verify Ceph Rados Gateway  With EC Pool Without S3 Accounts After Upgrade*




        ${backend_status}                       PCC.Ceph Rgw Verify BE Creation
                                                ...  targetNodeIp=['${SERVER_3_HOST_IP}']
                                                Should Be Equal As Strings      ${backend_status}    OK

###################################################################################################################################
Verify Ceph Rados Gateway With Replicated Pool With S3 Accounts
#####################################################################################################################################

     [Documentation]                *Verify Ceph Rados Gateway *


        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                                    ...  targetNodeIp=['${SERVER_2_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK


###################################################################################################################################
Verify Rgw Bucket List (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Verify Rgw Bucket List*

        ${status}                          PCC.Ceph Get Pcc Status
                                           ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                           ...  pcc=${SERVER_2_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Verify File Is Upload on Pool (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Verify File Is Uploaded on Pool*

        ${status}                          PCC.Ceph Get Pcc Status
                                           ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Verify File Upload To Pool
                                           ...  poolName=${CEPH_RGW_POOLNAME}
                                           ...  targetNodeIp=${SERVER_2_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK
###################################################################################################################################
Verify RBD From Backend
###################################################################################################################################
        [Documentation]                 *Verify RBD From Backend*
                                       ...  keywords:
                                       ...  PCC.Ceph Verify RBD From Backend



        ${status}            PCC.Ceph Verify RBD From Backend
                              ...  pool_name=rbd
                              ...  rbd=["${CEPH_RBD_NAME}"]
                              ...  targetNodeIp=${CLUSTERHEAD_2_HOST_IP}
                             Log To Console    ${status}
                             Should be equal as strings    ${status}    OK

###################################################################################################################################
Verify Ceph Fs from backend
###################################################################################################################################
    [Documentation]                 *Verify Ceph Fs from backend*
                                    ...  keywords:
                                    ...  PCC.Ceph Fs Verify BE


        ${status}                    PCC.Ceph Fs Verify BE
                                     ...  name=${CEPH_FS_NAME}
                                     ...  user=${PCC_LINUX_USER}
                                     ...  password=${PCC_LINUX_PASSWORD}
                                     ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_3_HOST_IP}","${SERVER_1_HOST_IP}"}]

                                     Should Be Equal As Strings      ${status}    OK


        ${size_replicated_pool_after_mount}     PCC.Get Stored Size for Replicated Pool
                                                ...    hostip=${SERVER_3_HOST_IP}
                                                ...    pool_name=fs3
                                                Log To Console    ${size_replicated_pool_after_mount}
                                                Set Suite Variable    ${size_replicated_pool_after_mount}
                                                Should Be True    ${size_replicated_pool_after_mount} > ${size_replicated_pool_before_mount}

###################################################################################################################################
K8s Cluster Verification Back End
###################################################################################################################################
    [Documentation]                 *Verifying K8s cluster BE*
                                    ...  keywords:
                                    ...  PCC.K8s Verify BE

        ${status}                   PCC.K8s Verify BE
                                    ...  user=${PCC_LINUX_USER}
                                    ...  password=${PCC_LINUX_PASSWORD}
                                    ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify CR from frontend and backend
###################################################################################################################################

        [Documentation]                       *Verify CR from frontend and backend* test
                                              ...  keywords:
                                              ...  PCC.CR Verify Creation from PCC
                                              ...  Is Docker Container Up
                                              ...  motorframework.common.LinuxUtils.Is FQDN reachable
                                              ...  Is Port Used

        ${result}                             PCC.CR Verify Creation from PCC
                                              ...    Name=${CR_NAME}
                                              Log to console    "${result}"
                                              Should Be Equal As Strings    ${result}    OK

        ${host_ip}    PCC.Get Host IP
                      ...  Name=${CR_NAME}
                      Log To Console    ${host_ip}
                      Set Global Variable    ${host_ip}


        ${container_up_result1}               Is Docker Container Up
                                              ...    container_name=portus_nginx_1
                                              ...    hostip=${host_ip}

        ${container_up_result2}               Is Docker Container Up
                                              ...    container_name=portus_background_1
                                              ...    hostip=${host_ip}

        ${container_up_result3}               Is Docker Container Up
                                              ...    container_name=portus_registry_1
                                              ...    hostip=${host_ip}

        ${container_up_result4}               Is Docker Container Up
                                              ...    container_name=portus_portus_1
                                              ...    hostip=${host_ip}

        ${container_up_result5}               Is Docker Container Up
                                              ...    container_name=portus_db_1
                                              ...    hostip=${host_ip}

                                              Log to Console    ${container_up_result1}
                                              Should Be Equal As Strings    ${container_up_result1}    OK

                                              Log to Console    ${container_up_result2}
                                              Should Be Equal As Strings    ${container_up_result2}    OK

                                              Log to Console    ${container_up_result3}
                                              Should Be Equal As Strings    ${container_up_result3}    OK

                                              Log to Console    ${container_up_result4}
                                              Should Be Equal As Strings    ${container_up_result4}    OK

                                              Log to Console    ${container_up_result5}
                                              Should Be Equal As Strings    ${container_up_result5}    OK

        ${FQDN_reachability_result}           pcc_qa.common.LinuxUtils.Is FQDN reachable
                                              ...    FQDN_name=${CR_FQDN}
                                              ...    hostip=${host_ip}

                                              Log to Console    ${FQDN_reachability_result}
                                              Should Be Equal As Strings    ${FQDN_reachability_result}    OK

        ${Port_used_result}                   Is Port Used
                                              ...    port_number=${CR_REGISTRYPORT}
                                              ...    hostip=${host_ip}

                                              Log to Console    ${Port_used_result}
                                              Should Be Equal As Strings    ${Port_used_result}    OK
