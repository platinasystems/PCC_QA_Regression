*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
	[Tags]	cluster_head
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
                                                
        ${status}                               Login To PCC        testdata_key=${pcc_setup}
                                                Should be equal as strings    ${status}    OK
                    
        ${server1_id}                           PCC.Get Node Id    Name=${SERVER_1_NAME}
                                                Log To Console    ${server1_id}
                                                Set Global Variable    ${server1_id}                 
                                
        ${server2_id}                           PCC.Get Node Id    Name=${SERVER_2_NAME}
                                                Log To Console    ${server2_id}
                                                Set Global Variable    ${server2_id}
                                                
        ${server3_id}                           PCC.Get Node Id    Name=${SERVER_3_NAME}
                                                Log To Console    ${server3_id}
                                                Set Global Variable    ${server3_id}
                                                
        ${invader1_id}                          PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
                                                Log To Console    ${invader1_id}
                                                Set Global Variable    ${invader1_id}
                                                
        ${invader2_id}                          PCC.Get Node Id    Name=${CLUSTERHEAD_2_NAME}
                                                Log To Console    ${invader2_id}
                                                Set Global Variable    ${invader2_id}

###################################################################################################################################
Check internet reachability from nodes
###################################################################################################################################

        ${status}                   PCC.Verify Default IgwPolicy BE
                               ...  nodes=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Adding Maas To Invaders : TCP-1140
###################################################################################################################################
    [Documentation]                 *Adding Maas To Invaders*
                               ...  Keywords:
                               ...  PCC.Add and Verify Roles On Nodes
                               ...  PCC.Wait Until Roles Ready On Nodes
        ${response}                 PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${CLUSTERHEAD_2_NAME}"]
                               ...  roles=["Baremetal Management Node", "Default"]
                                    Should Be Equal As Strings      ${response}  OK
        ${status_code}              PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${CLUSTERHEAD_2_NAME}
                                    Should Be Equal As Strings      ${status_code}  OK
        ${response}                 PCC.Maas Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}"]
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                                    Should Be Equal As Strings      ${response}  OK


###################################################################################################################################
PCC-Tenant-Creation For Backup and restore :TCP-477
###################################################################################################################################

        [Documentation]    *Create Tenant* test
                           ...    keywords:
                           ...    PCC.Get Tenant Id
                           ...    PCC.Add Tenant

        ${parent_id}    PCC.Get Tenant Id
                        ...    Name=${ROOT_TENANT}

        ${response}    PCC.Add Tenant
                       ...    Name=${CR_TENANT_USER}
                       ...    Description=CR_TENANT_DESC
                       ...    Parent_id=${parent_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200

        ${status}    PCC.Validate Tenant
                     ...    Name=${CR_TENANT_USER}

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK

        ${response}    PCC.Add Tenant
                       ...    Name=${TENANT5}
                       ...    Description=CR_TENANT_DESC
                       ...    Parent_id=${parent_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200

        ${status}    PCC.Validate Tenant
                     ...    Name=${TENANT5}

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK


        ${response}                            PCC.Add Tenant
                                              ...    Name=${TENANT1}
                                              ...    Description=${TENANT1_DESC}
                                              ...    Parent_id=${parent_id}

                                              Log To Console    ${response}
                                              ${result}    Get Result    ${response}
                                              ${status}    Get From Dictionary    ${response}    StatusCode
                                              Should Be Equal As Strings    ${status}    200

        ${status}                              PCC.Validate Tenant
                                              ...    Name=${TENANT1}

                                              Log To Console    ${status}
                                              Should Be Equal As Strings    ${status}    OK


###################################################################################################################################
PCC Read Only Role Creation :TCP-499
###################################################################################################################################

        [Documentation]    *Create Read Only Role* test
                           ...    keywords:
                           ...    PCC.Get Tenant Id
                           ...    PCC.Add Read Only Role

        ${owner}    PCC.Get Tenant Id
                    ...    Name=${CR_TENANT_USER}


        ${response}    PCC.Add Read Only Role
                       ...    Name=readonly
                       ...    Description=readonlyroles
                       ...    owner=${owner}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200

        ${status}    PCC.Validate Role
                       ...    Name=readonly
                       Log To Console    ${response}
                       Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
PCC-Read Only User Creation : TCP-1763
###################################################################################################################################

        [Documentation]    *Create Read Only User* test
                           ...  keywords:
                           ...  PCC.Get Role Id
                           ...  PCC.Add Read Only User

        ${tenant}    PCC.Get Tenant Id
                    ...    Name=${CR_TENANT_USER}

        ${roleID}    PCC.Get Role Id
                     ...    Name=readonly
                     ...    Owner=${tenant}

        ${response}    PCC.Add User
                       ...     FirstName=calsoft
                       ...     LastName=platina
                       ...     Username=${READONLY_USER_PCC_USERNAME}
                       ...     Tenant=${tenant}
                       ...     Role_ID=${roleID}
                       ...     Source=${PCC_URL}

                        Log To Console    ${response}
                        ${result}    Get Result    ${response}
                        ${status}    Get From Dictionary    ${response}    StatusCode
                        Should Be Equal As Strings    ${status}    200

                        Sleep  10s


        #PCC-Get Link From Gmail Read Only User

        ${password_token}     PCC.Get Link From Gmail
                              ...   Email=${READONLY_USER_PCC_USERNAME}

                              Log To Console    ${password_token}
                              Set Suite Variable    ${password_token}

        #PCC-Set Read Only user Password


        ${response}     PCC.Create User Password
                        ...     Password=${READONLY_USER_PCC_PWD}

                        Log To Console    ${response}
                        ${result}    Get Result    ${response}
                        ${status}    Get From Dictionary    ${response}    StatusCode
                        Should Be Equal As Strings    ${status}    200

        ${status}        Login To User
						 ...  ${pcc_setup}
						 ...  ${READONLY_USER_PCC_USERNAME}
						 ...  ${READONLY_USER_PCC_PWD}
						 Should be equal as strings    ${status}    OK

###################################################################################################################################
Login
###################################################################################################################################

        ${status}                               Login To PCC        testdata_key=${pcc_setup}
                                                Should be equal as strings    ${status}    OK


###################################################################################################################################
PCC-Tenant User (Admin) Creation : TCP-313
###################################################################################################################################

        [Documentation]    *Create User* test
                           ...  keywords:
                           ...  PCC.Get Role Id
                           ...  PCC.Add Read Only User

        ${tenant}    PCC.Get Tenant Id
                     ...    Name=${CR_TENANT_USER}

        ${roleID}    PCC.Get Role Id
                     ...    Name=ADMIN
                     ...    Owner=${tenant}

        ${response}    PCC.Add User
                       ...     FirstName=platina
                       ...     LastName=systems
                       ...     Username=${TENANT_USER_PCC_USERNAME}
                       ...     Tenant=${tenant}
                       ...     Role_ID=${roleID}
                       ...     Source=${PCC_URL}

                        Log To Console    ${response}
                        ${result}    Get Result    ${response}
                        ${status}    Get From Dictionary    ${response}    StatusCode
                        Should Be Equal As Strings    ${status}    200

                        Sleep  10s

        #PCC-Get Link From Gmail Tenant User (Admin)

        ${password_token}     PCC.Get Link From Gmail
                              ...   Email=${TENANT_USER_PCC_USERNAME}

                              Log To Console    ${password_token}
                              Set Suite Variable    ${password_token}

        #PCC-Set Tenant User (Admin) Password

        ${response}     PCC.Create User Password
                        ...     Password=${TENANT_USER_PCC_PWD}

                        Log To Console    ${response}
                        ${result}    Get Result    ${response}
                        ${status}    Get From Dictionary    ${response}    StatusCode
                        Should Be Equal As Strings    ${status}    200

        ${status}        Login To User
						 ...  ${pcc_setup}
						 ...  ${TENANT_USER_PCC_USERNAME}
						 ...  ${TENANT_USER_PCC_PWD}
						 Should be equal as strings    ${status}    OK

###################################################################################################################################
Login
###################################################################################################################################

        ${status}                               Login To PCC        testdata_key=${pcc_setup}
                                                Should be equal as strings    ${status}    OK

###################################################################################################################################
Pcc Tenant Assignment : TCP-242
###################################################################################################################################

        [Documentation]    *Pcc-Tenant-Assignment* test
                           ...  keywords:
                           ...  PCC.Get Tenant Id
                           ...  PCC.Assign Tenant to Node
                           ...  PCC.Validate Tenant Assigned to Node

        ${tenant_id}    PCC.Get Tenant Id
                        ...    Name=${CR_TENANT_USER}

        ${response}    PCC.Assign Tenant to Node
                       ...    tenant_id=${tenant_id}
                       ...    ids=${server2_id}

                       Log To Console    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200


        ${status}    PCC.Validate Tenant Assigned to Node
                     ...    Name=${SERVER_2_NAME}
                     ...    Tenant_Name=${CR_TENANT_USER}

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK


##########################################################################################################################################
Assign and validate Cluster Head node role to the cluster heads :TCP-1591
###########################################################################################################################################

    [Documentation]                 *Assign and validate Cluster Head node role to the cluster heads*
                               ...  Keywords:
                               ...  PCC.Add and Verify Roles On Nodes
                               ...  PCC.Wait Until Roles Ready On Nodes
                               ...  PCC.Verify Node Role On Nodes
                               ...  CLI.Validate Platina Systems Package repository

        ${response}                 PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  roles=["Cluster Head","Default"]

                                    Should Be Equal As Strings      ${response}  OK

        ${status_code}              PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${CLUSTERHEAD_1_NAME}

                                    Should Be Equal As Strings      ${status_code}  OK

        ${status_code}              PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${CLUSTERHEAD_2_NAME}

                                    Should Be Equal As Strings      ${status_code}  OK

        ${status}                   PCC.Verify Node Role On Nodes
                             ...    Name=Cluster Head
                             ...    nodes=["${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.Validate Platina Systems Package repository
                              ...   host_ip=${CLUSTERHEAD_1_NAME}
                              ...   linux_user=pcc
                              ...   linux_password=cals0ft

                                    Should Not Be Equal As Strings    ${status}    OK

        ${status}                   CLI.Validate Platina Systems Package repository
                              ...   host_ip=${CLUSTERHEAD_2_NAME}
                              ...   linux_user=pcc
                              ...   linux_password=cals0ft

                                    Should Not Be Equal As Strings    ${status}    OK

        ${status}                   PCC.Node Verify Back End
                             ...    host_ips=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                                    Log To Console    ${status}
                                    Run Keyword If  "${status}" != "OK"  Fatal Error
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Verify LLDP Neighbors
                             ...    servers_hostip=['${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}']
                             ...    invaders_hostip=['${CLUSTERHEAD_1_HOST_IP}','${CLUSTERHEAD_2_HOST_IP}']

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.OS Package repository
                             ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Should Be Equal As Strings    ${status}    OK
        
        ${status}                   CLI.OS Package repository
                             ...    host_ip=${CLUSTERHEAD_2_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Should Be Equal As Strings    ${status}    OK                            

        ${status}                   CLI.Validate Node Self Healing
                             ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.Validate Node Self Healing
                             ...    host_ip=${CLUSTERHEAD_2_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.Automatic Upgrades Validation
                             ...    host_ip=${CLUSTERHEAD_1_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Should Be Equal As Strings    ${status}    Automatic upgrades set to Yes from backend

        ${status}                   PCC.Check NTP services from backend
                              ...   targetNodeIp=['${CLUSTERHEAD_1_HOST_IP}','${CLUSTERHEAD_2_HOST_IP}']

                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK


        ${status}                   CLI.Validate Ethtool
                             ...    host_ips=['${CLUSTERHEAD_1_HOST_IP}','${CLUSTERHEAD_2_HOST_IP}']
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                                    Should Be Equal As Strings    ${status}    OK
                    

###################################################################################################################################
Create Subnets For Network Manager :TCP-1773,TCP-1774
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready

        ${response}                 PCC.Ipam Subnet Create
                               ...  name=${IPAM_CONTROL_SUBNET_NAME}
                               ...  subnet=${IPAM_CONTROL_SUBNET_IP}
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=${IPAM_CONTROL_SUBNET_NAME}

                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ipam Subnet Create
                               ...  name=${IPAM_DATA_SUBNET_NAME}
                               ...  subnet=${IPAM_DATA_SUBNET_IP}
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=${IPAM_DATA_SUBNET_NAME}

                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Network Manager Creation:TCP-1752,TCP-1590
###################################################################################################################################
    [Documentation]                 *Network Manager Creation with ControlCIDR and DataCIDR*
                               ...  keywords:
                               ...  PCC.Network Manager Create
                               ...  PCC.Wait Until Network Manager Ready
                               ...  PCC.Network Manager Verify BE 


        ${response}                 PCC.Network Manager Create
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_3_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                  
        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Network Manager Verify BE
                               ...  nodes_ip=${NETWORK_MANAGER_NODES_IP}
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                               ...  controlCIDR=${IPAM_CONTROL_SUBNET_IP}
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK 


        ${status}                   PCC.Verify Node Role On Nodes
                               ...  Name=Network Resource
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_3_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
            
                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK
                                

        ${status}                   CLI.Validate Network Resource
                               ...  host_ip=${CLUSTERHEAD_1_HOST_IP}
                               ...  linux_user=pcc
                               ...  linux_password=cals0ft
        
                                    Should Be Equal As Strings    ${status}    OK                            

        ${status}                   CLI.Validate Network Resource
                               ...  host_ip=${CLUSTERHEAD_2_HOST_IP}
                               ...  linux_user=pcc
                               ...  linux_password=cals0ft
                
                                    Should Be Equal As Strings    ${status}    OK 
                                    
        ${status}                   CLI.Validate Network Resource
                               ...  host_ip=${SERVER_1_HOST_IP}
                               ...  linux_user=pcc
                               ...  linux_password=cals0ft
                
                                    Should Be Equal As Strings    ${status}    OK 
                                    
        ${status}                   CLI.Validate Network Resource
                               ...  host_ip=${SERVER_2_HOST_IP}
                               ...  linux_user=pcc
                               ...  linux_password=cals0ft
                
                                    Should Be Equal As Strings    ${status}    OK  
        
        ${status}                   CLI.Validate Network Resource
                               ...  host_ip=${SERVER_3_HOST_IP}
                               ...  linux_user=pcc
                               ...  linux_password=cals0ft
                
                                    Should Be Equal As Strings    ${status}    OK                              
                                                      



###################################################################################################################################
Ceph Cluster Create : TCP-564,TCP-1588
###################################################################################################################################
    [Documentation]                 *Creating Ceph Cluster*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready


        ${id}                       PCC.Ceph Get Cluster Id
                              ...   name=${CEPH_CLUSTER_NAME}
                                    Pass Execution If    ${id} is not ${None}    Cluster is alredy there

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
                                    Should Be Equal As Strings      ${status}    OK


        ${status_code}              PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${CLUSTERHEAD_1_NAME}
        
                                    Should Be Equal As Strings      ${status_code}  OK
        
        ${status_code}              PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${SERVER_1_NAME}
                
                                    Should Be Equal As Strings      ${status_code}  OK   
                                                     
        ${status_code}              PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${SERVER_2_NAME}
                        
                                    Should Be Equal As Strings      ${status_code}  OK                    


        ${status}                   PCC.Verify Node Role On Nodes
                               ...  Name=Ceph Resource
                               ...  nodes=["${CLUSTERHEAD_1_NAME}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.Validate CEPH Resource
                               ...  host_ip=${CLUSTERHEAD_1_HOST_IP}
                               ...  linux_user=pcc
                               ...  linux_password=cals0ft

                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.Validate CEPH Resource
                               ...  host_ip=${SERVER_1_HOST_IP}
                               ...  linux_user=pcc
                               ...  linux_password=cals0ft

                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.Validate CEPH Resource
                               ...  host_ip=${SERVER_2_HOST_IP}
                               ...  linux_user=pcc
                               ...  linux_password=cals0ft

                                    Should Be Equal As Strings    ${status}    OK



###################################################################################################################################
Ceph Crush Map Validation:TCP-1743
###################################################################################################################################
    [Documentation]                 *Ceph Crush Map Validation*
                               ...  keywords:
                               ...  CLI.Validate CEPH Crush Map From Backend


        ${status}                   CLI.Validate CEPH Crush Map From Backend
                               ...  node_location={"${SERVER_2_NAME}":["default-region","default-zone","default-site","default-rack"],"${SERVER_1_NAME}":["default-region","default-zone","default-site","default-rack"]}
                               ...  hostip=${SERVER_2_HOST_IP}

                                    Should Be Equal As Strings      ${status}    OK    Validation unsuccessful


	    ${status}                   CLI.Validate CEPH Crush Map From Backend
                               ...  node_location={"${SERVER_2_NAME}":["default-region","default-zone","default-site","default-rack"],"${SERVER_1_NAME}":["default-region","default-zone","default-site","default-rack"]}
		                       ...  hostip=${SERVER_1_HOST_IP}

                                    Should Be Equal As Strings      ${status}    OK    Validation unsuccessful

###################################################################################################################################
Ceph Storage Type Validation:TCP-1737,TCP-1740
###################################################################################################################################
    [Documentation]                 *Ceph Storage Type Validation*
                               ...  keywords:
                               ...  CLI.Validate CEPH Storage Type

        ${status}    CLI.Validate CEPH Storage Type
                     ...  storage_types=['bluestore']
                     ...  hostip=${SERVER_2_HOST_IP}

                     Should Be Equal As Strings      ${status}    OK

	    ${status}    CLI.Validate CEPH Storage Type
                     ...  storage_types=['bluestore']
                     ...  hostip=${SERVER_1_HOST_IP}

                     Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Ceph Architecture- Nodes and OSDs
###################################################################################################################################
    [Documentation]                 *Ceph Architecture Node OSDs*
                               ...  keywords:
                               ...  PCC.Ceph Nodes OSDs Architecture Validation


        ${status}    PCC.Ceph Nodes OSDs Architecture Validation
                     ...  name=${CEPH_CLUSTER_NAME}
                     ...  hostip=${SERVER_1_HOST_IP}

                     Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Pools For Backup : TCP-566, TCP-567
###################################################################################################################################

    [Documentation]                             *Ceph Pool Creation for Fs*
                                           ...  keywords:
                                           ...  PCC.Ceph Get Cluster Id
                                           ...  PCC.Ceph Create Pool
                                           ...  PCC.Ceph Wait Until Pool Ready

        ${status}                               PCC.Ceph Get Pcc Status
                                           ...  name=ceph-pvt
                                                Should Be Equal As Strings      ${status}    OK

        ${cluster_id}                           PCC.Ceph Get Cluster Id
                                           ...  name=${CEPH_Cluster_NAME}

        ${response}                             PCC.Ceph Create Pool
                                           ...  name=rbd
                                           ...  ceph_cluster_id=${cluster_id}
                                           ...  size=${CEPH_POOL_SIZE}
                                           ...  tags=${CEPH_POOL_TAGS}
                                           ...  pool_type=${CEPH_POOL_TYPE}
                                           ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                                           ...  quota=1
                                           ...  quota_unit=TiB

        ${status_code}                          Get Response Status Code        ${response}
                                                Should Be Equal As Strings      ${status_code}  200

        ${status}                               PCC.Ceph Wait Until Pool Ready
                                           ...  name=rbd
                                                Should Be Equal As Strings      ${status}    OK

        ${status}                               PCC.Ceph Pool Verify BE
                                           ...  name=rbd
                                           ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}"]
                                                log to console                  ${status}
                                                Should Be Equal As Strings      ${status}    OK


        ${response}                             PCC.Ceph Create Pool
                                           ...  name=rgw
                                           ...  ceph_cluster_id=${cluster_id}
                                           ...  size=${CEPH_POOL_SIZE}
                                           ...  tags=${CEPH_POOL_TAGS}
                                           ...  pool_type=${CEPH_POOL_TYPE}
                                           ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                                           ...  quota=1
                                           ...  quota_unit=TiB

        ${status_code}                          Get Response Status Code        ${response}
                                                Should Be Equal As Strings      ${status_code}  200

        ${status}                               PCC.Ceph Wait Until Pool Ready
                                           ...  name=rgw
                                                Should Be Equal As Strings      ${status}    OK

        ${status}                               PCC.Ceph Pool Verify BE
                                           ...  name=rgw
                                           ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}"]
                                                log to console                  ${status}
                                                Should Be Equal As Strings      ${status}    OK

        ${response}                             PCC.Ceph Create Pool
                                           ...  name=fs1
                                           ...  ceph_cluster_id=${cluster_id}
                                           ...  size=${CEPH_POOL_SIZE}
                                           ...  tags=${CEPH_POOL_TAGS}
                                           ...  pool_type=${CEPH_POOL_TYPE}
                                           ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                                           ...  quota=1
                                           ...  quota_unit=TiB

        ${status_code}                          Get Response Status Code        ${response}
                                                Should Be Equal As Strings      ${status_code}  200

        ${status}                               PCC.Ceph Wait Until Pool Ready
                                           ...  name=fs1
                                                Should Be Equal As Strings      ${status}    OK

        ${status}                               PCC.Ceph Pool Verify BE
                                           ...  name=fs1
                                           ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}"]
                                                log to console                  ${status}
                                                Should Be Equal As Strings      ${status}    OK


        ${response}                             PCC.Ceph Create Pool
                                           ...  name=fs2
                                           ...  ceph_cluster_id=${cluster_id}
                                           ...  size=${CEPH_POOL_SIZE}
                                           ...  tags=${CEPH_POOL_TAGS}
                                           ...  pool_type=${CEPH_POOL_TYPE}
                                           ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                                           ...  quota=1
                                           ...  quota_unit=TiB

        ${status_code}                          Get Response Status Code        ${response}
                                                Should Be Equal As Strings      ${status_code}  200

        ${status}                               PCC.Ceph Wait Until Pool Ready
                                           ...  name=fs2
                                                Should Be Equal As Strings      ${status}    OK

        ${status}                               PCC.Ceph Pool Verify BE
                                           ...  name=fs2
                                           ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}"]
                                                log to console                  ${status}
                                                Should Be Equal As Strings      ${status}    OK

        ${response}                             PCC.Ceph Create Pool
                                           ...  name=fs3
                                           ...  ceph_cluster_id=${cluster_id}
                                           ...  size=${CEPH_POOL_SIZE}
                                           ...  tags=${CEPH_POOL_TAGS}
                                           ...  pool_type=${CEPH_POOL_TYPE}
                                           ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                                           ...  quota=1
                                           ...  quota_unit=TiB

        ${status_code}                          Get Response Status Code        ${response}
                                                Should Be Equal As Strings      ${status_code}  200

        ${status}                               PCC.Ceph Wait Until Pool Ready
                                           ...  name=fs3
                                                Should Be Equal As Strings      ${status}    OK

        ${status}                               PCC.Ceph Pool Verify BE
                                           ...  name=fs3
                                           ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}"]
                                                log to console                  ${status}
                                                Should Be Equal As Strings      ${status}    OK


        ${response}                             PCC.Ceph Create Pool
                                           ...  name=k8s-pool
                                           ...  ceph_cluster_id=${cluster_id}
                                           ...  size=${CEPH_POOL_SIZE}
                                           ...  tags=${CEPH_POOL_TAGS}
                                           ...  pool_type=${CEPH_POOL_TYPE}
                                           ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                                           ...  quota=1
                                           ...  quota_unit=TiB

        ${status_code}                          Get Response Status Code        ${response}
                                                Should Be Equal As Strings      ${status_code}  200

        ${status}                               PCC.Ceph Wait Until Pool Ready
                                           ...  name=k8s-pool
                                                Should Be Equal As Strings      ${status}    OK

        ${status}                               PCC.Ceph Pool Verify BE
                                           ...  name=k8s-pool
                                           ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}"]
                                                log to console                  ${status}
                                                Should Be Equal As Strings      ${status}    OK

        ${response}            PCC.Ceph Create Erasure Pool
                               ...  name=rgw-erasure-pool
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  pool_type=data
                               ...  resilienceScheme=erasure
                               ...  quota=3
                               ...  quota_unit=GiB
                               ...  Datachunks=2
                               ...  Codingchunks=1

        ${status_code}          Get Response Status Code        ${response}
                                Should Be Equal As Strings      ${status_code}  200

        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
                               ...  name=rgw-erasure-pool
                               Should Be Equal As Strings      ${status}    OK

        ${status}              PCC.Ceph Pool Verify BE
                               ...  name=rgw-erasure-pool
                               ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}"]
                               log to console                  ${status}
                               Should Be Equal As Strings      ${status}    OK


        ${response}                             PCC.Ceph Create Pool
                                           ...  name=${CEPH_RGW_POOLNAME}
                                           ...  ceph_cluster_id=${cluster_id}
                                           ...  size=${CEPH_POOL_SIZE}
                                           ...  tags=${CEPH_POOL_TAGS}
                                           ...  pool_type=${CEPH_POOL_TYPE}
                                           ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                                           ...  quota=1
                                           ...  quota_unit=TiB

        ${status_code}                          Get Response Status Code        ${response}
                                                Should Be Equal As Strings      ${status_code}  200

        ${status}                               PCC.Ceph Wait Until Pool Ready
                                           ...  name=${CEPH_RGW_POOLNAME}
                                                Should Be Equal As Strings      ${status}    OK

        ${status}                               PCC.Ceph Pool Verify BE
                                           ...  name=${CEPH_RGW_POOLNAME}
                                           ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}"]
                                                log to console                  ${status}
                                                Should Be Equal As Strings      ${status}    OK

##################################################################################################################################
Ceph Certificate For Rgws : TCP-1231
###################################################################################################################################

        [Documentation]              *Ceph Ceph Certificate For Rgws*

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


###################################################################################################################################
Ceph Rados Gateway Creation With Replicated Pool Without S3 Accounts For Backup : TCP-1272
#####################################################################################################################################

     [Documentation]                             *Ceph Rados Gateway Creation With Replicated Pool Without S3 Accounts For Backup*
               
        ${status}                               PCC.Ceph Get Pcc Status
                                           ...  name=ceph-pvt
                                                Should Be Equal As Strings      ${status}    OK
               
        ${response}                             PCC.Ceph Create Rgw
                                           ...  name=${CEPH_RGW_NAME}
                                           ...  poolName=rgw
                                           ...  targetNodes=${CEPH_RGW_NODES}
                                           ...  port=${CEPH_RGW_PORT}
                                           ...  certificateName=${CEPH_RGW_CERT_NAME}
               
        ${status_code}                          Get Response Status Code        ${response}
                                                Should Be Equal As Strings      ${status_code}  200
               
        ${status}                               PCC.Ceph Wait Until Rgw Ready
                                           ...  name=${CEPH_RGW_NAME}
                                           ...  ceph_cluster_name=ceph-pvt

                                                Should Be Equal As Strings      ${status}    OK
               
        ${backend_status}                       PCC.Ceph Rgw Verify BE Creation
                                           ...  targetNodeIp=${CEPH_RGW_NODES}

                                                Should Be Equal As Strings      ${backend_status}    OK

###################################################################################################################################
Create Rgw Configuration File (ServiceIp As Default):TCP-1294
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

                                           Sleep    3 minutes
        ${accessKey}                       PCC.Ceph Get Rgw Access Key
                                      ...  name=${CEPH_RGW_NAME}
				      ...  ceph_cluster_name=ceph-pvt

        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
                                      ...  name=${CEPH_RGW_NAME}
				      ...  ceph_cluster_name=ceph-pvt

        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=0.0.0.0
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create Rgw Bucket (ServiceIp As Default):TCP-1294
###################################################################################################################################
    [Documentation]                        *Create Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Make Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
List Rgw Bucket (ServiceIp As Default):TCP-1294
###################################################################################################################################
    [Documentation]                        *List Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Update Rgw Configuration File With Control IP And Try To ADD File (ServiceIp As Default):TCP-1294
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*


        ${status}                          PCC.Ceph Rgw Update Configure
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  service_ip=yes
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Upload File To Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}
                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify File Is Upload on Pool (ServiceIp As Default):TCP-1294
###################################################################################################################################
    [Documentation]                        *Verify File Is Uploaded on Pool*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Verify File Upload To Pool
                                      ...  poolName=${CEPH_RGW_POOLNAME}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Update Rgw Configuration File With Data IP And Try To ADD File (ServiceIp As Default):TCP-1294
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*


        ${status}                          PCC.Ceph Rgw Update Configure
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  service_ip=no
                                      ...  data_cidr=${IPAM_DATA_SUBNET_IP}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Upload File To Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}
                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify File Is Upload on Pool (ServiceIp As Default):TCP-1294
###################################################################################################################################
    [Documentation]                        *Verify File Is Uploaded on Pool*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Verify File Upload To Pool
                                      ...  poolName=${CEPH_RGW_POOLNAME}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Get A File From Rgw Bucket (ServiceIp As Default) : TCP-1573,TCP-1294
###################################################################################################################################
    [Documentation]                        *Get a file from Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Get File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Rbd Creation For Backup : TCP-569
###################################################################################################################################
    [Documentation]                             *Ceph Rbd where size unit is in MiB*
                                           ...  keywords:
                                           ...  PCC.Ceph Get Pool Id
                                           ...  PCC.Ceph Get Cluster Id
                                           ...  PCC.Ceph Create Rbd
                                           ...  PCC.Ceph Wait Until Rbd Ready
               
        ${status}                               PCC.Ceph Get Pcc Status
                                           ...  name=ceph-pvt
                                                Should Be Equal As Strings      ${status}    OK
               
        ${cluster_id}                           PCC.Ceph Get Cluster Id
                                           ...  name=${CEPH_Cluster_NAME}
               
        ${pool_id}                              PCC.Ceph Get Pool Id
                                           ...  name=rbd
               
        ${response}                             PCC.Ceph Create Rbd
                                           ...  pool_type=replicated
                                           ...  name=${CEPH_RBD_NAME}
                                           ...  ceph_cluster_id=${cluster_id}
                                           ...  ceph_pool_id=${pool_id}
                                           ...  size=${CEPH_RBD_SIZE}
                                           ...  tags=${CEPH_RBD_TAGS}
                                           ...  image_feature=${CEPH_RBD_IMG}
                                           ...  size_units=MiB
               
        ${status_code}                          Get Response Status Code        ${response}
                                                Should Be Equal As Strings      ${status_code}  200
               
               
        ${status}                               PCC.Ceph Wait Until Rbd Ready
                                           ...  name=${CEPH_RBD_NAME}
                                                Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Rbd Mount Test : TCP-1272
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Mount Test*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool
                               ...  PCC.Ceph Wait Until Pool Ready
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready
                               ...  PCC.Ceph Rbd Update




        ###  Get INET IP  ###
        ${inet_ip}     PCC.Get CEPH Inet IP
                       ...    hostip=${CLUSTERHEAD_1_HOST_IP}

                       Log To Console    ${inet_ip}
                       Set Global Variable    ${inet_ip}

        ###  Get Stored size before mount  ###
        ${size_replicated_pool_before_mount}      PCC.Get Stored Size for Replicated Pool
                                                  ...    hostip=${SERVER_2_HOST_IP}
                                                  ...    pool_name=rbd

                                                  Log To Console    ${size_replicated_pool_before_mount}
                                                  Set Suite Variable    ${size_replicated_pool_before_mount}


        ###  Mount RBD to Mount Point  ###


        ${status}    Create mount folder
                     ...    mount_folder_name=test_rbd_mnt
                     ...    hostip=${SERVER_2_HOST_IP}
                     ...    user=${PCC_LINUX_USER}
                     ...    password=${PCC_LINUX_PASSWORD}

                     Log To Console    ${status}
                     Should be equal as strings    ${status}    OK

        ${status}    PCC.Map RBD
		     ...    name=${CEPH_RBD_NAME}
		     ...    pool_name=rbd
		     ...    inet_ip=${inet_ip}
		     ...    hostip=${SERVER_2_HOST_IP}
                     ...    username=${PCC_LINUX_USER}
                     ...    password=${PCC_LINUX_PASSWORD}
		     Log To Console    ${status}
                     Should be equal as strings    ${status}    OK


		${status}      PCC.Mount RBD to Mount Point
                       ...    mount_folder_name=test_rbd_mnt
                       ...    hostip=${SERVER_2_HOST_IP}
                       ...    username=${PCC_LINUX_USER}
                       ...    password=${PCC_LINUX_PASSWORD}

                       Log To Console    ${status}
                       Should be equal as strings    ${status}    OK

                       Sleep    1 minutes

        ${status}      Create dummy file and copy to mount path
                       ...    dummy_file_name=test_rbd_mnt_4mb.bin
                       ...    dummy_file_size=4MiB
                       ...    mount_folder_name=test_rbd_mnt
                       ...    hostip=${SERVER_2_HOST_IP}
                       ...    user=${PCC_LINUX_USER}
                       ...    password=${PCC_LINUX_PASSWORD}

                       Log To Console    ${status}
                       Should be equal as strings    ${status}    OK

                       Sleep    2 minutes


        ###  Get Stored size after mount  ###
        ${size_replicated_pool_after_mount}     PCC.Get Stored Size for Replicated Pool
                                                ...    hostip=${SERVER_2_HOST_IP}
                                                ...    pool_name=rbd

                                                Log To Console    ${size_replicated_pool_after_mount}
                                                Set Suite Variable    ${size_replicated_pool_after_mount}
                                                Should Be True    ${size_replicated_pool_after_mount} > ${size_replicated_pool_before_mount}


###################################################################################################################################
Ceph Fs Creation For Backup : TCP-788
###################################################################################################################################
    [Documentation]                             *Creating Cepf FS For Backup*
                                           ...  keywords:
                                           ...  PCC.Ceph Get Cluster Id
                                           ...  PCC.Ceph Get Pool Details For FS
                                           ...  PCC.Ceph Create Fs
               
        ${status}                               PCC.Ceph Get Pcc Status
                                           ...  name=ceph-pvt
                                                Should Be Equal As Strings      ${status}    OK
               
        ${cluster_id}                           PCC.Ceph Get Cluster Id
                                           ...  name=${CEPH_Cluster_NAME}
               
        ${meta}                                 PCC.Ceph Get Pool Details For FS
                                           ...  name=fs1
               
        ${data}                                 PCC.Ceph Get Pool Details For FS
                                           ...  name=fs2
               
        ${default}                              PCC.Ceph Get Pool Details For FS
                                           ...  name=fs3
               
        ${response}                             PCC.Ceph Create Fs
                                           ...  name=${CEPH_FS_NAME}
                                           ...  ceph_cluster_id=${cluster_id}
                                           ...  metadata_pool=${meta}
                                           ...  data_pool=[${data}]
                                           ...  default_pool=${default}
               
        ${status_code}                          Get Response Status Code        ${response}
                                                Should Be Equal As Strings      ${status_code}  200
               
        ${status}                               PCC.Ceph Wait Until Fs Ready
                                           ...  name=${CEPH_FS_NAME}
                                                Should Be Equal As Strings      ${status}    OK
               
        ${status}                               PCC.Ceph Fs Verify BE
                                           ...  name=${CEPH_FS_NAME}
                                           ...  user=${PCC_LINUX_USER}
                                           ...  password=${PCC_LINUX_PASSWORD}
                                           ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
                                                Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Mount FS test case : TCP-1183
###################################################################################################################################
        ###  Get INET IP  ###
        ${inet_ip}     PCC.Get CEPH Inet IP
                       ...    hostip=${CLUSTERHEAD_1_HOST_IP}
                       Log To Console    ${inet_ip}
                       Set Global Variable    ${inet_ip}
        ###  Get Stored size before mount  ###
        ${size_replicated_pool_before_mount}      PCC.Get Stored Size for Replicated Pool
                                                  ...    hostip=${SERVER_2_HOST_IP}
                                                  ...    pool_name=fs3
                                                  Log To Console    ${size_replicated_pool_before_mount}
                                                  Set Suite Variable    ${size_replicated_pool_before_mount}
        ###  Mount FS to Mount Point  ###

        ${status}    Create mount folder
                     ...    mount_folder_name=test_fs_mnt
                     ...    hostip=${SERVER_2_HOST_IP}
                     ...    user=${PCC_LINUX_USER}
                     ...    password=${PCC_LINUX_PASSWORD}
                     Log To Console    ${status}
                     Should be equal as strings    ${status}    OK
        ${status}      PCC.Mount FS to Mount Point
                       ...    mount_folder_name=test_fs_mnt
                       ...    hostip=${SERVER_2_HOST_IP}
                       ...    user=${PCC_LINUX_USER}
                       ...    password=${PCC_LINUX_PASSWORD}
                       ...    inet_ip=${inet_ip}
                       Log To Console    ${status}
                       Should be equal as strings    ${status}    OK
                       Sleep    1 minutes
        ${status}      Create dummy file and copy to mount path
                       ...    dummy_file_name=test_fs_mnt_1mb.bin
                       ...    dummy_file_size=1MiB
                       ...    mount_folder_name=test_fs_mnt
                       ...    hostip=${SERVER_2_HOST_IP}
                       ...    user=${PCC_LINUX_USER}
                       ...    password=${PCC_LINUX_PASSWORD}
                       Log To Console    ${status}
                       Should be equal as strings    ${status}    OK
                       Sleep    2 minutes

        ###  Get Stored size after mount  ###
        ${size_replicated_pool_after_mount}     PCC.Get Stored Size for Replicated Pool
                                                ...    hostip=${SERVER_2_HOST_IP}
                                                ...    pool_name=fs3
                                                Log To Console    ${size_replicated_pool_after_mount}
                                                Set Suite Variable    ${size_replicated_pool_after_mount}
                                                Should Be True    ${size_replicated_pool_after_mount} > ${size_replicated_pool_before_mount}


###################################################################################################################################
Create Kubernetes cluster : TCP-179,TCP-140
###################################################################################################################################
        [Documentation]             *Create Kubernetes cluster*
                               ...  Keywords:
                               ...  PCC.K8s Create Cluster

        ${cluster_id}               PCC.K8s Get Cluster Id
                               ...  name=${K8s_NAME}
                                    Pass Execution If    ${cluster_id} is not ${None}    Cluster is already there

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.K8s Create Cluster
                               ...  id=${K8S_ID}
                               ...  k8sVersion=${K8S_VERSION}
                               ...  name=${K8S_NAME}
                               ...  cniPlugin=${K8S_CNIPLUGIN}
                               ...  nodes=${K8S_NODES}
                               ...  pools=${K8S_POOL}
                               ...  networkClusterName=${NETWORK_MANAGER_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.K8s Wait Until Cluster is Ready
                               ...  name=${K8S_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.K8s Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]

                                    Should Be Equal As Strings      ${status}    OK


        ${status}                   PCC.Verify Node Role On Nodes
                             ...    Name=Kubernetes Resource
                             ...    nodes=["${CLUSTERHEAD_1_NAME}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]

                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.Validate Kubernetes Resource
                               ...  host_ip=${CLUSTERHEAD_1_HOST_IP}
                               ...  linux_user=pcc
                               ...  linux_password=cals0ft

                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.Validate Kubernetes Resource
                               ...  host_ip=${SERVER_1_HOST_IP}
                               ...  linux_user=pcc
                               ...  linux_password=cals0ft

                                    Should Be Equal As Strings    ${status}    OK

        ${status}                   CLI.Validate Kubernetes Resource
                               ...  host_ip=${SERVER_2_HOST_IP}
                               ...  linux_user=pcc
                               ...  linux_password=cals0ft

                                    Should Be Equal As Strings    ${status}    OK


##################################################################################################################################
Kubernetes Cluster Verification PCC:TCP-179,TCP-140
###################################################################################################################################
        [Documentation]             *Kubernetes Cluster Verification PCC*
                               ...  Keywords:
                               ...  PCC.K8s Wait Until Cluster is Ready

        ${status}                   PCC.K8s Wait Until Cluster is Ready
                               ...  name=${K8S_NAME}
                                    Should Be Equal As Strings      ${status}    OK
###################################################################################################################################
Kubernetes Cluster Verification Back End:TCP-179,TCP-140
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
Kubernetes - Add Wordpress App : TCP-141
###################################################################################################################################
        [Documentation]             *Add App Kubernetes cluster*
                               ...  Keywords:
                               ...  PCC.K8s Get Cluster Id
                               ...  PCC.K8s Add App
                               ...  PCC.K8s Wait Until Cluster is Ready

        ${cluster_id}               PCC.K8s Get Cluster Id
                               ...  name=${K8S_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=${K8S_POOL}

        ${sc_name}                  PCC.K8s Get Storage Class Name
                               ...  cluster_id=${cluster_id}
                               ...  pool_id=${pool_id}

        ${response}                 PCC.K8s Add App
                               ...  storage_class_name=${sc_name}
                               ...  replica=${k8s_wordpress_replica}
                               ...  external_ip=${k8s_wordpress_external_ip}
                               ...  access_mode=${k8s_wordpress_access_mode}
                               ...  cluster_id=${cluster_id}
                               ...  appName=${k8s_wordpress_appname}
                               ...  appNamespace=${k8s_wordpress_appname}
                               ...  gitUrl= ${K8S_GITURL}
                               ...  gitRepoPath=${K8S_GITREPOPATH}
                               ...  gitBranch=${K8S_GITBRANCH}
                               ...  label=${k8s_wordpress_appname}



        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200



        ${status}              PCC.K8s Wait Until Cluster is Ready
                               ...  name=${K8S_NAME}
                               Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Create a Container Registry(using Auto mode) for Backup and Restore :TCP-578,TCP-836
###################################################################################################################################
        [Documentation]                        *Create CR* test
                                               ...  keywords:
                                               ...  PCC.Create Container Registry
                    
                    
        ${response}                            PCC.Create Container Registry
                                               ...    Name=${CR_NAME}
                                               ...    fullyQualifiedDomainName=${CR_FQDN}
                                               ...    password=${CR_PASSWORD}
                                               ...    secretKeyBase=${CR_SECRETKEYBASE}
                                               ...    databaseName=${CR_DATABASENAME}
                                               ...    databasePassword=${CR_DB_PWD}
                                               ...    port=${CR_PORT}
                                               ...    registryPort=${CR_REGISTRYPORT}
                                               ...    adminState=${CR_ADMIN_STATE}
                                               ...    storageType=mount
                                               ...    storageLocation=testlocation
                            
                            
                                               Log To Console    ${response}
                                               ${result}    Get Result    ${response}
                                               ${status}    Get From Dictionary    ${result}    status
                                               ${message}    Get From Dictionary    ${result}    message
                                               Log to Console    ${message}
                                               Should Be Equal    "${status}"    "200"
                            
                            
        ${status}                              PCC.CR Wait For Creation
                                               ...    Name=${CR_NAME}
                                               Should Be Equal As Strings    ${status}    OK
                                                       
		${host_ip}                             PCC.Get Host IP
                                               ...  Name=calsoft1 
                                               Log To Console    ${host_ip}
                                               Set Global Variable    ${host_ip}
                       
###################################################################################################################################
Verify CR creation successful from frontend and backend:TCP-578,TCP-836
###################################################################################################################################

        [Documentation]                       *Verify CR creation successful from frontend and backend* test
                                              ...  keywords:
                                              ...  PCC.CR Verify Creation from PCC
                                              ...  Is Docker Container Up
                                              ...  motorframework.common.LinuxUtils.Is FQDN reachable
                                              ...  Is Port Used
                                              
        ${result}                             PCC.CR Verify Creation from PCC
                                              ...    Name=${CR_NAME}
                                              Log to console    "${result}"
                                              Should Be Equal As Strings    ${result}    OK
                                              
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
					 
###################################################################################################################################
PCC Node Role Creation for backup and restore : TCP-351
###################################################################################################################################

        [Documentation]                       *PCC Node Role Creation* test
                                              ...  keywords:
                                              ...  PCC.Add Node Role
                                              ...  PCC.Validate Node Role
                                              
        ${owner}                              PCC.Get Tenant Id       Name=${ROOT_TENANT}
                                              
        ${template_id}                        PCC.Get Template Id    Name=${APP_1}
                                                      
        ${response}                           PCC.Add Node Role
                                              ...    Name=${NODE_ROLE_1}
                                              ...    Description=${NODE_ROLE_DESC_1}
                                              ...    templateIDs=[${template_id}]
                                              ...    owners=[${owner}]
                                              
                                              Log To Console    ${response}
                                              ${result}    Get Result    ${response}
                                              ${status}    Get From Dictionary    ${result}    status
                                              ${message}    Get From Dictionary    ${result}    message
                                              Log to Console    ${message}
                                              Should Be Equal As Strings    ${status}    200
                                              
                                              Sleep    2s
                                              
        ${status}                             PCC.Validate Node Role
                                              ...    Name=${NODE_ROLE_1}
                                              
                                              Log To Console    ${status}
                                              Should Be Equal As Strings    ${status}    OK    Node role doesnot exists
					 

###################################################################################################################################
PCC Node Group Creation and Verification for backup and restore : TCP-357
###################################################################################################################################

        [Documentation]                       *PCC Node Group - Verify if user can access node group* test
                                              ...  keywords:
                                              ...  PCC.Add Node Group
                                              ...  PCC.Validate Node Group
        
        ${owner}                              PCC.Get Tenant Id       Name=ROOT
                                    
        ${response}                           PCC.Add Node Group
                                              ...    Name=${NODE_GROUP1} 
                                              ...    owner=${owner}
                                              ...    Description=${NODE_GROUP_DESC1}
                                              
                                              Log To Console    ${response}
                                              ${result}    Get Result    ${response}
                                              ${status}    Get From Dictionary    ${result}    status
                                              ${message}    Get From Dictionary    ${result}    message
                                              Log to Console    ${message}
                                              Should Be Equal As Strings    ${status}    200
                                              
                                        
        ${status}                             PCC.Validate Node Group
                                              ...    Name=${NODE_GROUP1}
                                              
                                              Log To Console    ${status}
                                              Should Be Equal As Strings    ${status}    OK    Node group doesnot exists


###################################################################################################################################
Alert Create Raw Rule :TCP-1082
###################################################################################################################################
    [Documentation]                 *Alert Create Raw Rule*
                               ...  Keywords:
                               ...  PCC.Alert Create Rule Raw

        ${status}                   PCC.Alert Create Rule Raw
                               ...  auth_data=${PCC_CONN}
                               ...  setup_ip=${PCC_HOST_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  filename=freeswap.yml

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Alert Verify Raw Rule:TCP-1082
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
Check App catalog for all the existing apps:TCP-1407
###################################################################################################################################


        ${status}                   PCC.Validate Applications Present on PCC
                               ...  app_list=['LLDP', 'Baremetal Services', 'ETHTOOL', 'DNS client', 'NTP client', 'RSYSLOG client', 'SNMP agent', 'OS Package Repository', 'Docker Community Package Repository', 'Ceph Community Package Repository', 'FRRouting Community Package Repository', 'Platina Systems Package Repository', 'Automatic Upgrades', 'Node Self Healing']

                               Log To Console   ${status}
                               Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Add Certificate with Private Keys for backup and restore : TCP-1231
###################################################################################################################################
                
        
        [Documentation]    *Add Certificate* test
        
        
        ${response}                          PCC.Add Certificate
                                             ...  Alias=Cert_with_pvt_cert
                                             ...  Description=Cert_with_pvt_cert_desc
                                             ...  Private_key=Temp_private.ppk
                                             ...  Certificate_upload=Certificate_to_be_uploaded.pem
                           
                                             Log To Console    ${response}
                                             ${result}    Get Result    ${response}
                                             ${status}    Get From Dictionary    ${result}    statusCodeValue
                                             Should Be Equal As Strings    ${status}    200

		${certificate_id_before_backup}      PCC.Get Certificate Id
                                             ...    Alias=Cert_with_pvt_cert
                                             
                                             Log To Console    ${certificate_id_before_backup}
                                             Set Global Variable    ${certificate_id_before_backup}


###################################################################################################################################
Create Certificate Authority Public Certificate : TCP-1231
###################################################################################################################################

        [Documentation]    *Add Certificate* test

        ${response}    PCC.Add Certificate
                       ...  Alias=Cert_without_pvt_cert
                       ...  Description=Cert_without_pvt_cert_desc
                       ...  Certificate_upload=Certificate_to_be_uploaded.pem

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    statusCodeValue
                       Should Be Equal As Strings    ${status}    200

        ${response}    PCC.Get Certificates
                       ...  Alias=Cert_without_pvt_cert
                       Log To Console    ${response}
                       Should Be Equal As Strings    ${response}    OK


###################################################################################################################################
Create OpenSSH Public Key :TCP-258
###################################################################################################################################

        [Documentation]    *Add Public Key* test

        ${response}    PCC.Add OpenSSH Key
                       ...  Alias=${PUBLIC_KEY_ALIAS}
                       ...  Description=${PUBLIC_KEY_DESCRIPTION}
                       ...  Filename=${PUBLIC_KEY}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    statusCodeValue
                       Should Be Equal As Strings    ${status}    200

        ${response}    PCC.Get Open SSH Key
                       ...  Alias=${PUBLIC_KEY_ALIAS}
                       Log To Console    ${response}
                       Should Be Equal As Strings    ${response}    OK




###################################################################################################################################
Create scoping object - Region:TCP-1362
###################################################################################################################################

        [Documentation]    *Create scoping object - Region* test
                           ...  keywords:
                           ...  PCC.Create Scope

        #Create scoping object - Region

        ${response}    PCC.Create Scope
                       ...  type=region
                       ...  scope_name=region-1
                       ...  description=region-description

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


###################################################################################################################################
Create scoping object - Zone:TCP-1363
###################################################################################################################################

        [Documentation]    *Create scoping object - Zone* test
                           ...  keywords:
                           ...  PCC.Create Scope

        #Create scoping object - Zone


        ${parent_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${parent_Id}

        ${response}    PCC.Create Scope
                       ...  type=zone
                       ...  scope_name=zone-1
                       ...  description=zone-description
                       ...  parentID=${parent_Id}

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


###################################################################################################################################
Create scoping object - Site:TCP-1364
###################################################################################################################################

        [Documentation]    *Create scoping object - Site* test
                           ...  keywords:
                           ...  PCC.Create Scope

        #Create scoping object - Site

        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${parent1_Id}

                        Log To Console    ${parent2_Id}

        ${response}    PCC.Create Scope
                       ...  type=site
                       ...  scope_name=site-1
                       ...  description=site-description
                       ...  parentID=${parent2_Id}

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


###################################################################################################################################
Create scoping object - Rack: TCP-1365
###################################################################################################################################

        [Documentation]    *Create scoping object - Rack* test
                           ...  keywords:
                           ...  PCC.Create Scope


        #Create scoping object - Rack

        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${parent1_Id}

        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${parent2_Id}

                        Log To Console    ${parent3_Id}

        ${response}    PCC.Create Scope
                       ...  type=rack
                       ...  scope_name=rack-1
                       ...  description=rack-description
                       ...  parentID=${parent3_Id}

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


###################################################################################################################################
Assign the node (CLUSTERHEAD_2_NAME) to a rack :TCP-1469,TCP-1403
#####################################################################################################################################
        [Tags]        assign

                ${node_id}    PCC.Get Node Id
                              ...  Name=${CLUSTERHEAD_2_NAME}
                              Log To Console    ${node_id}

        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${parent1_Id}

        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${parent2_Id}

                        Log To Console    ${parent3_Id}

        ${scope_id}     PCC.Get Scope Id
                         ...  scope_name=rack-1
                         ...  parentID=${parent3_Id}

        ${response}    PCC.Update Node
                       ...  Id=${node_id}
                       ...  Name=${CLUSTERHEAD_2_NAME}
                       ...  scopeId=${scope_id}


                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Create DNS client node role :TCP-1428
###################################################################################################################################

        [Documentation]    *Create node role with DNS client application* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}

        ${template_id}    PCC.Get Template Id    Name=DNS
                          Log To Console    ${template_id}

        ${response}    PCC.Add Node Role
                       ...    Name=DNS_NODE_ROLE
                       ...    Description=DNS_NR_DESC
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
                     ...    Name=DNS_NODE_ROLE

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists


###################################################################################################################################
Create NTP client node role :TCP-1429
###################################################################################################################################

        [Documentation]    *Create node role with NTP client application* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role

        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}

        ${template_id}    PCC.Get Template Id    Name=NTP
                          Log To Console    ${template_id}

        ${response}    PCC.Add Node Role
                       ...    Name=NTP_NODE_ROLE
                       ...    Description=NTP_NR_DESC
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
                     ...    Name=NTP_NODE_ROLE

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists

###################################################################################################################################
Create SNMP agent node role :TCP-1430
###################################################################################################################################

        [Documentation]    *Create node role with SNMPv2 client application* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role


        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}

        ${template_id}    PCC.Get Template Id    Name=SNMP
                          Log To Console    ${template_id}

        ${response}    PCC.Add Node Role
                       ...    Name=SNMPv2_NODE_ROLE
                       ...    Description=SNMPv2_NR_DESC
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
                     ...    Name=SNMPv2_NODE_ROLE

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists



###################################################################################################################################
Create RSYSLOG client node role :TCP-1616
###################################################################################################################################

        [Documentation]    *Create RSYSLOG client node role* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role


        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}

        #### Creating RSyslog node role ####

        ${template_id}    PCC.Get Template Id    Name=RSYSLOG
                          Log To Console    ${template_id}

        ${response}    PCC.Add Node Role
                       ...    Name=Rsyslog-NR
                       ...    Description=Rsyslog-NR-DESC
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
                     ...    Name=Rsyslog-NR

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists


###################################################################################################################################
Install DNS, NTP, SNMPv2, Rsyslog client node role on node and verify:TCP-1428,TCP-1429,TCP-1430,TCP-1616
###################################################################################################################################
    [Documentation]                 *Associate DNS, NTP, SNMPv2 client node role with a node*
                               ...  Keywords:
                               ...  PCC.Add and Verify Roles On Nodes
                               ...  PCC.Wait Until Roles Ready On Nodes

        [Tags]    Only
        ${response}                 PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${CLUSTERHEAD_2_NAME}"]
                               ...  roles=["DNS_NODE_ROLE", "SNMPv2_NODE_ROLE","NTP_NODE_ROLE","Rsyslog-NR","Default"]

                                    Should Be Equal As Strings      ${response}  OK

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${CLUSTERHEAD_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK


        ${status}              PCC.Verify Node Role On Nodes
                               ...    Name=DNS_NODE_ROLE
                               ...    nodes=["${CLUSTERHEAD_2_NAME}"]
                               Log To Console    ${status}
                               Should Be Equal As Strings    ${status}    OK

        ${status}              PCC.Verify Node Role On Nodes
                               ...    Name=SNMPv2_NODE_ROLE
                               ...    nodes=["${CLUSTERHEAD_2_NAME}"]
                               Log To Console    ${status}
                               Should Be Equal As Strings    ${status}    OK

        ${status}              PCC.Verify Node Role On Nodes
                               ...    Name=NTP_NODE_ROLE
                               ...    nodes=["${CLUSTERHEAD_2_NAME}"]
                               Log To Console    ${status}
                               Should Be Equal As Strings    ${status}    OK

        ${status}              PCC.Verify Node Role On Nodes
                               ...    Name=Rsyslog-NR
                               ...    nodes=["${CLUSTERHEAD_2_NAME}"]
                               Log To Console    ${status}
                               Should Be Equal As Strings    ${status}    OK

        ${status}              PCC.Verify Node Role On Nodes
                               ...    Name=Default
                               ...    nodes=["${CLUSTERHEAD_2_NAME}"]
                               Log To Console    ${status}
                               Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Create a policy using DNS client app, assigning it to the Location :TCP-1409
###################################################################################################################################

        [Documentation]    *Create a policy* test
                           ...  keywords:
                           ...  PCC.Create Policy

        [Tags]    Only
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=dns
                     Log To Console    ${app_id}

        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${parent1_Id}

        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${parent2_Id}

                        Log To Console    ${parent3_Id}

        ${scope_id}     PCC.Get Scope Id
                         ...  scope_name=rack-1
                         ...  parentID=${parent3_Id}

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=dns-policy-description
                       ...  scopeIds=[${scope_id}]
                       ...  inputs=[{"name":"nameserver_0","value":"172.17.2.253"},{"name":"nameserver_1","value":"8.8.8.8"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                ${status}     PCC.Wait Until All Nodes Are Ready

                      Log To Console    ${status}
                      Should Be Equal As Strings    ${status}    OK

        #verifying DNS policy in PCC UI
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
Verifying DNS client Policy assignment from backend:TCP-1445
###################################################################################################################################

                ##### Validate RSOP on Node ##########

        ${dns_rack_policy_id}                PCC.Get Policy Id
                                             ...  Name=dns
                                             ...  description=dns-policy-description
                                             Log To Console    ${dns_rack_policy_id}
                                             Set Global Variable    ${dns_rack_policy_id}

                ${status}                            PCC.Validate RSOP of a node
                                             ...  node_name=${CLUSTERHEAD_2_NAME}
                                             ...  policyIDs=[${dns_rack_policy_id}]

                                             Log To Console    ${status}
                                             Should Be Equal As Strings      ${status}  OK

                ##### Validate DNS from backend #########

        ${node_wait_status}                  PCC.Wait Until Node Ready
                                             ...  Name=${CLUSTERHEAD_2_NAME}

                                             Log To Console    ${node_wait_status}
                                             Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}                            PCC.Validate DNS From Backend
                                             ...  host_ip=${CLUSTERHEAD_2_HOST_IP}
                                             ...  search_list=['8.8.8.8']

                                             Log To Console    ${status}
                                             Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Create a policy using NTP client app, assigning it to the Location :TCP-1410
###################################################################################################################################

        [Documentation]    *Create a policy* test
                           ...  keywords:
                           ...  PCC.Create Policy

        [Tags]    Only
        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=ntp
                     Log To Console    ${app_id}

        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-1

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${parent1_Id}

        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${parent2_Id}

                        Log To Console    ${parent3_Id}

        ${scope_id}     PCC.Get Scope Id
                         ...  scope_name=rack-1
                         ...  parentID=${parent3_Id}

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=ntp-policy-description
                       ...  scopeIds=[${scope_id}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                ${status}     PCC.Wait Until All Nodes Are Ready

                      Log To Console    ${status}
                      Should Be Equal As Strings    ${status}    OK

                #verifying NTP policy in PCC UI
                ${response}    PCC.Get Policy Details
                       ...  Name=ntp
                       ...  description=ntp-policy-description

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200


###################################################################################################################################
Verifying NTP client Policy assignment from backend:TCP-1445
###################################################################################################################################

                ##### Validate RSOP on Node ##########

        ${ntp_rack_policy_id}                PCC.Get Policy Id
                                             ...  Name=ntp
                                             ...  description=ntp-policy-description
                                             Log To Console    ${ntp_rack_policy_id}
                                             Set Global Variable    ${ntp_rack_policy_id}

                ${status}                            PCC.Validate RSOP of a node
                                             ...  node_name=${CLUSTERHEAD_2_NAME}
                                             ...  policyIDs=[${ntp_rack_policy_id}]

                                             Log To Console    ${status}
                                             Should Be Equal As Strings      ${status}  OK



                ##### Check NTP services from backend #####

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${CLUSTERHEAD_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}                PCC.Check NTP services from backend
                                 ...  targetNodeIp=['${CLUSTERHEAD_2_HOST_IP}']

                                 Log To Console    ${status}
                                 Should Be Equal As Strings      ${status}  OK

                ##### Validate NTP from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${CLUSTERHEAD_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate NTP From Backend
                      ...  host_ip=${CLUSTERHEAD_2_HOST_IP}
                      ...  time_zone=America/Chicago

                      Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Create a policy using SNMP client app, assigning it to the Location :TCP-1464
###################################################################################################################################

        [Documentation]    *Create a policy* test
                           ...  keywords:
                           ...  PCC.Create Policy


        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=snmp
                     Log To Console    ${app_id}

        ${parent1_Id}   PCC.Get Scope Id
                        ...  scope_name=region-1

        ${parent2_Id}   PCC.Get Scope Id
                        ...  scope_name=zone-1
                        ...  parentID=${parent1_Id}

        ${parent3_Id}   PCC.Get Scope Id
                        ...  scope_name=site-1
                        ...  parentID=${parent2_Id}

                        Log To Console    ${parent3_Id}

        ${scope_id}     PCC.Get Scope Id
                        ...  scope_name=rack-1
                        ...  parentID=${parent3_Id}



        #### Creating SNMP_V2 policies ####

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=SNMP_v2
                       ...  inputs=[{"name":"community_string","value":"snmpv2_community_string"}]
                       ...  scopeIds=[${scope_id}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200


###################################################################################################################################
Verifying SNMP client Policy assignment from backend:TCP-1445
###################################################################################################################################

                ##### Validate RSOP on Node ##########

        ${snmp_rack_policy_id}                PCC.Get Policy Id
                                             ...  Name=snmp
                                             ...  description=SNMP_v2
                                             Log To Console    ${snmp_rack_policy_id}
                                             Set Global Variable    ${snmp_rack_policy_id}

                ${status}                            PCC.Validate RSOP of a node
                                             ...  node_name=${CLUSTERHEAD_2_NAME}
                                             ...  policyIDs=[${snmp_rack_policy_id}]

                                             Log To Console    ${status}
                                             Should Be Equal As Strings      ${status}  OK


                ##### Validate SNMPv2 from backend #########

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${CLUSTERHEAD_2_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}     PCC.Validate SNMP from backend
                      ...  snmp_version=snmpv2
                      ...  community_string=snmpv2_community_string
                      ...  host_ip=${CLUSTERHEAD_2_HOST_IP}
                      ...  node_name=${CLUSTERHEAD_2_NAME}

                      Log To Console    ${status}
                      Should Be Equal As Strings      ${status}  OK


###################################################################################################################################
Create a policy using RSYSLOG client app(without TLS), assigning it to the Location:TCP-1618
###################################################################################################################################

        [Documentation]                      *Create a policy* test
                                             ...  keywords:
                                             ...  PCC.Create Policy

        ###  Creating Rsyslog Policy  ####

                ${app_id}                   PCC.Get App Id from Policies
                                    ...  Name=rsyslogd
                                    Log To Console    ${app_id}

        ${parent1_Id}    PCC.Get Scope Id
                         ...  scope_name=region-1

        ${parent2_Id}    PCC.Get Scope Id
                         ...  scope_name=zone-1
                         ...  parentID=${parent1_Id}

        ${parent3_Id}    PCC.Get Scope Id
                         ...  scope_name=site-1
                         ...  parentID=${parent2_Id}
                         Log To Console    ${parent3_Id}

        ${scope_id}     PCC.Get Scope Id
                        ...  scope_name=rack-1
                        ...  parentID=${parent3_Id}

        ${response}                 PCC.Create Policy
                                    ...  appId=${app_id}
                                    ...  description=rsyslog-policy
                                    ...  scopeIds=[${scope_id}]
                                    ...  inputs=[{"name": "rsyslog_remote_address","value":"192.138.34.0"},{"name":"rsyslog_enable_tls","value":"false"},{"name":"rsyslog_tcp_port","value":"514"},{"name":"rsyslog_ca_certificate","value":""}]

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    ${message}    Get From Dictionary    ${result}    message
                                    Log to Console    ${message}
                                    Should Be Equal As Strings    ${status}    200

                ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

                #verifying RSYSLOG policy in PCC UI
                ${response}    PCC.Get Policy Details
                       ...  Name=rsyslogd
                       ...  description=rsyslog-policy

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200


###################################################################################################################################
Verifying Rsyslog Policy assignment from backend:TCP-1617
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
                                             ...  node_name=${CLUSTERHEAD_2_NAME}
                                             ...  policyIDs=[${rsyslog_policy_id}]

                                             Log To Console    ${status}
                                             Should Be Equal As Strings      ${status}  OK

                ##### Validate Rsyslog from backend #########

        ${status}                           CLI.Check package installed
                                            ...    package_name=rsyslog
                                            ...    host_ip=${CLUSTERHEAD_2_HOST_IP}
                                            ...    linux_user=${PCC_LINUX_USER}
                                            ...    linux_password=${PCC_LINUX_PASSWORD}

                                            Log To Console    ${status}
                                            Should Be Equal As Strings    ${status}    rsyslog Package installed

###################################################################################################################################
Create a policy using Automatic Upgrades client app, assigning it to the Location : TCP-1445
###################################################################################################################################


       ### Validation after setting automatic-upgrades to Yes ####

       ${status}             CLI.Automatic Upgrades Validation
                             ...    host_ip=${CLUSTERHEAD_2_HOST_IP}
                             ...    linux_user=pcc
                             ...    linux_password=cals0ft

                             Should Be Equal As Strings    ${status}    Automatic upgrades set to Yes from backend


           ### create automatic upgrade policy with false value

           ${app_id}                   PCC.Get App Id from Policies
                                   ...  Name=automatic-upgrades
                                   Log To Console    ${app_id}

        ${parent1_Id}    PCC.Get Scope Id
                         ...  scope_name=region-1

        ${parent2_Id}    PCC.Get Scope Id
                         ...  scope_name=zone-1
                         ...  parentID=${parent1_Id}

        ${parent3_Id}    PCC.Get Scope Id
                         ...  scope_name=site-1
                         ...  parentID=${parent2_Id}

                         Log To Console    ${parent3_Id}

        ${scope_id}     PCC.Get Scope Id
                        ...  scope_name=rack-1
                        ...  parentID=${parent3_Id}

                ${response}           PCC.Create Policy
                              ...  appId=${app_id}
                              ...  description=Automatic-upgrade-policy
                              ...  scopeIds=[${scope_id}]
                              ...  inputs=[{"name": "enabled","value": "false"}]

                              Log To Console    ${response}
                              ${result}    Get Result    ${response}
                              ${status}    Get From Dictionary    ${result}    status
                              ${message}    Get From Dictionary    ${result}    message
                              Log to Console    ${message}
                              Should Be Equal As Strings    ${status}    200

       ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

           ### Validation after setting automatic-upgrades to No ####

       ${status}            CLI.Automatic Upgrades Validation
                            ...    host_ip=${CLUSTERHEAD_2_HOST_IP}
                            ...    linux_user=pcc
                            ...    linux_password=cals0ft

                            Should Be Equal As Strings    ${status}    Automatic upgrades set to No from backend






