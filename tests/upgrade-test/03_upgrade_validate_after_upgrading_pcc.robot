*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
	[Tags]	check
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
	[Documentation]                 *Upgrade PCC*
                               ...  keywords:
                               ...  CLI.Pcc Down
	[Tags]  Only_this
#	###  Making CLI Down  ####
#	${status}		CLI.Pcc Down
#					...    host_ip=${PCC_HOST_IP}
#					...    pcc_password=${PCC_SETUP_PWD}
#					...    linux_user=${PCC_LINUX_USER}
#					...    linux_password=${PCC_LINUX_PASSWORD}
#					
#					Should Be Equal As Strings    ${status}    OK
	
	### Taking PCC to stable version   ###
	${status}       CLI.PCC Pull Code
					...  host_ip=${PCC_HOST_IP}
					...  linux_user=${PCC_LINUX_USER}
					...  linux_password=${PCC_LINUX_PASSWORD}
					...  pcc_version_cmd=sudo /home/pcc/platina-cli-ws/platina-cli upgrade -p ${PCC_SETUP_PWD} --release v1.7.0-rc2

                                        #...  pcc_version_cmd=sudo /home/pcc/platina-cli-ws/platina-cli run -u ${PCC_SETUP_USERNAME} -p ${PCC_SETUP_PWD} --url https://cust-dev.lab.platinasystems.com --insecure --registryUrl https://cust-dev.lab.platinasystems.com:5000 --ru ${PCC_SETUP_USERNAME} --rp ${PCC_SETUP_PWD} --insecureRegistry --prtKey /home/pcc/i28-keys/i28-id_rsa --pblKey /home/pcc/i28-keys/i28-authorized_keys --release stable --configRepo master

                                        Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Login to PCC
###################################################################################################################################
	[Documentation]                 *Login to PCC and load data*
	[Tags]  check
		${status}                               Login To PCC        testdata_key=${pcc_setup}
                                                Should be equal as strings    ${status}    OK

###################################################################################################################################
Nodes Verification after upgrading PCC
###################################################################################################################################
    [Documentation]                      *Nodes Verification Back End*
                               ...  keywords:
                               ...  PCC.Node Verify Back End
    	[Tags]    check
	${status}                       PCC.Add multiple nodes and check online
                               ...  host_ips=['${CLUSTERHEAD_1_HOST_IP}', '${CLUSTERHEAD_2_HOST_IP}', '${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}','${SERVER_3_HOST_IP}']
                               ...  Names=['${CLUSTERHEAD_1_NAME}', '${CLUSTERHEAD_2_NAME}', '${SERVER_1_NAME}','${SERVER_2_NAME}','${SERVER_3_NAME}']

                                    Log To Console    ${status}
                                    Should be equal as strings    ${status}    OK

        ${status}                   PCC.Node Verify Back End
                               ...  host_ips=["${SERVER_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Ceph Validation after upgrading PCC
###################################################################################################################################
    [Documentation]                 *Ceph Validation after restoring PCC*
                               ...  keywords:
                               ...  PCC.Ceph Verify BE
                               ...  PCC.Ceph Pool Verify BE
                               ...  PCC.Ceph Fs Verify BE
                               ...  PCC.Ceph Rgw Verify BE
                               ...  PCC.Ceph Wait Until Cluster Ready
                               ...  PCC.Ceph Wait Until Pool Ready
                               ...  PCC.Ceph Wait Until Rbd Ready
                               ...  PCC.Ceph Wait Until Rgw Ready
                               ...  PCC.Ceph Wait Until Fs Ready
        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_3_HOST_IP}","${SERVER_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=rgw
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Pool Verify BE
                               ...  name=rgw
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_3_HOST_IP}","${SERVER_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=rbd
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Pool Verify BE
                               ...  name=rbd
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_3_HOST_IP}","${SERVER_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=fs1
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Pool Verify BE
                               ...  name=fs1
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_3_HOST_IP}","${SERVER_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=fs2
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Pool Verify BE
                               ...  name=fs2
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_3_HOST_IP}","${SERVER_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=fs3
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Pool Verify BE
                               ...  name=fs3
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_3_HOST_IP}","${SERVER_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${SERVER_2_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=${CEPH_RBD_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Wait Until Fs Ready
                               ...  name=${CEPH_FS_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Fs Verify BE
                               ...  name=${CEPH_FS_NAME}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_3_HOST_IP}","${SERVER_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Subnet Validation after upgrading PCC
###################################################################################################################################
    [Documentation]                 *Subnet Validation after restoring PCC*
                               ...  keywords:
                               ...  PCC.Wait Until Ipam Subnet Ready
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=${IPAM_CONTROL_SUBNET_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=${IPAM_DATA_SUBNET_NAME}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Network Cluster Validation after upgrading PCC
###################################################################################################################################
    [Documentation]                 *Network Cluster Validation after restoring PCC*
                               ...  keywords:
                               ...  PCC.Wait Until Network Manager Ready
                               ...  PCC.Network Manager Verify BE
                               ...  PCC.Health Check Network Manager
        [Tags]  ceph

	${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Network Manager Verify BE
                               ...  nodes_ip=${NETWORK_MANAGER_NODES_IP}
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

####################################################################################################################################
#K8s Validation after upgrading PCC
####################################################################################################################################
#        [Documentation]             *K8s Validation after restoring PCC*
#                               ...  Keywords:
#                               ...  PCC.K8s Wait Until Cluster is Ready
#                               ...  PCC.K8s Verify BE
#        ${status}                   PCC.K8s Wait Until Cluster is Ready
#                               ...  name=${K8S_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.K8s Verify BE
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]
#
#                                    Should Be Equal As Strings      ${status}    OK                      
###################################################################################################################################
Verify CR creation successful from frontend and backend after upgrade
###################################################################################################################################

        [Documentation]             *Verify CR creation successful from frontend and backend* test
                                    ...  keywords:
                                    ...  PCC.CR Verify Creation from PCC
                                    ...  Is Docker Container Up
                                    ...  motorframework.common.LinuxUtils.Is FQDN reachable
                                    ...  Is Port Used
                            
        ${host_ip}                  PCC.Get Host IP
                                    ...  Name=calsoft1 
                                    Log To Console    ${host_ip}
                                    Set Global Variable    ${host_ip}
		
		${result}                   PCC.CR Verify Creation from PCC
                                    ...    Name=${CR_NAME}
                                    Log to console    "${result}"
                                    Should Be Equal As Strings    ${result}    OK
                     
        ${container_up_result1}     Is Docker Container Up 
                                    ...    container_name=portus_nginx_1
                                    ...    hostip=${host_ip}
                     
        ${container_up_result2}     Is Docker Container Up 
                                    ...    container_name=portus_background_1
                                    ...    hostip=${host_ip}
                     
        ${container_up_result3}     Is Docker Container Up 
                                    ...    container_name=portus_registry_1
                                    ...    hostip=${host_ip}
                     
        ${container_up_result4}     Is Docker Container Up 
                                    ...    container_name=portus_portus_1
                                    ...    hostip=${host_ip}
                     
        ${container_up_result5}     Is Docker Container Up 
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
                     
        ${FQDN_reachability_result}     pcc_qa.common.LinuxUtils.Is FQDN reachable
                                        ...    FQDN_name=${CR_FQDN}
                                        ...    hostip=${host_ip}
                     
                                    Log to Console    ${FQDN_reachability_result}
                                    Should Be Equal As Strings    ${FQDN_reachability_result}    OK
                     
        ${Port_used_result}         Is Port Used   
                                    ...    port_number=${CR_REGISTRYPORT}
                                    ...    hostip=${host_ip}
                     
                                    Log to Console    ${Port_used_result}
                                    Should Be Equal As Strings    ${Port_used_result}    OK
					 
###################################################################################################################################
PCC Node Role validation after upgrade
###################################################################################################################################

        [Documentation]             *PCC Node Role Validation after restore* test
                                    ...  keywords:
                                    ...  PCC.Add Node Role
                                    ...  PCC.Validate Node Role
        ${status}                   PCC.Validate Node Role
                                    ...    Name=${NODE_ROLE_1}
                                    
                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK    Node role doesnot exists
					 
###################################################################################################################################
PCC-Tenant-Validation after upgrade
###################################################################################################################################

        [Documentation]             *Tenant validation after restore* test
                                    ...  keywords:
                                    ...  PCC.Add Tenant
        ${status}                   PCC.Validate Tenant
                                    ...    Name=${TENANT1}
                                    
                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK
					 
###################################################################################################################################
PCC Node Group Validation after upgrade
###################################################################################################################################

        [Documentation]             *PCC Node Group Validation after restore* test
                                    ...  keywords:
                                    ...  PCC.Validate Node Group
              
        ${status}                   PCC.Validate Node Group
                                    ...    Name=${NODE_GROUP1}
                                    
                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK    Node group doesnot exists
					 
									   
###################################################################################################################################
Create scoping object - Region for upgrade testing
###################################################################################################################################

        [Documentation]             *Create scoping object - Region* test
                                    ...  keywords:
                                    ...  PCC.Create Scope
            
        ${status}                   PCC.Check Scope Creation From PCC
                                    ...  scope_name=region-1
                                    
                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK
					   
###################################################################################################################################
Validate Node role and its assignment on nodes after upgrade
###################################################################################################################################

        [Documentation]             *Create a policy* test
                                    ...  keywords:
                                    ...  PCC.Create Policy
        
        ${status}                   PCC.Validate Node Role
                                    ...    Name=DNS_NODE_ROLE
                                    
                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK    Node role doesnot exists
					 
		${status_code}              PCC.Wait Until Roles Ready On Nodes
                                    ...  node_name=${SERVER_2_NAME}
        
                                    Should Be Equal As Strings      ${status_code}  OK
		
		
							   
###################################################################################################################################
Verifying Policy assignment from backend
###################################################################################################################################
		
		##### Validate RSOP on Node ##########

        ${dns_rack_policy_id}       PCC.Get Policy Id
                                    ...  Name=dns
                                    ...  description=dns-policy-description
                                    Log To Console    ${dns_rack_policy_id}
                                    Set Global Variable    ${dns_rack_policy_id}
								  
		${status}                   PCC.Validate RSOP of a node
                                    ...  node_name=${SERVER_2_NAME}
                                    ...  policyIDs=[${dns_rack_policy_id}]
                
                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK
		
		##### Validate DNS from backend #########

        ${node_wait_status}         PCC.Wait Until Node Ready
                                    ...  Name=${SERVER_2_NAME}
        
                                    Log To Console    ${node_wait_status}
                                    Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}                   PCC.Validate DNS From Backend
                                    ...  host_ip=${SERVER_2_HOST_IP}
                                    ...  search_list=['8.8.8.8']
                                
                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK
