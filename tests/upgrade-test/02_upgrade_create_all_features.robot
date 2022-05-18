*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
	[Tags]    ceph
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
Downgrade PCC
###################################################################################################################################
	[Documentation]                 *Downgrade PCC*
                               ...  keywords:
                               ...  CLI.Pcc Down
	[Tags]    Exclude	
	###  Making CLI Down  ####
	${status}		CLI.Pcc Down
					...    host_ip=${PCC_HOST_IP}
					...    pcc_password=${PCC_SETUP_PWD}
					...    linux_user=${PCC_LINUX_USER}
					...    linux_password=${PCC_LINUX_PASSWORD}
					
					Should Be Equal As Strings    ${status}    OK
	
	### Taking PCC to lower version   ###
	${status}       CLI.PCC Pull Code
					...  host_ip=${PCC_HOST_IP}
					...  linux_user=${PCC_LINUX_USER}
					...  linux_password=${PCC_LINUX_PASSWORD}
					...  pcc_version_cmd=sudo /home/pcc/platina-cli-ws/platina-cli run -u ${PCC_SETUP_USERNAME} -p ${PCC_SETUP_PWD} --url https://cust-dev.lab.platinasystems.com --insecure --registryUrl https://cust-dev.lab.platinasystems.com:5000 --ru ${PCC_SETUP_USERNAME} --rp ${PCC_SETUP_PWD} --insecureRegistry --prtKey /home/pcc/i28-keys/i28-id_rsa --pblKey /home/pcc/i28-keys/i28-authorized_keys --release v1.6.2 --pruneVolumes

                    Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Login to PCC
###################################################################################################################################
	[Documentation]                 *Login to PCC and load data*
	[Tags]    ceph  
		${status}                               Login To PCC        testdata_key=${pcc_setup}
                                                Should be equal as strings    ${status}    OK


#####################################################################################################################################
Add Nodes
#####################################################################################################################################

    [Documentation]                 *Add Nodes Test*                 
    [Tags]    Exclude
    ${status}       PCC.Add multiple nodes and check online
					...  host_ips=['${CLUSTERHEAD_1_HOST_IP}', '${CLUSTERHEAD_2_HOST_IP}', '${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}','${SERVER_3_HOST_IP}']
					...  Names=['${CLUSTERHEAD_1_NAME}', '${CLUSTERHEAD_2_NAME}', '${SERVER_1_NAME}','${SERVER_2_NAME}','${SERVER_3_NAME}']

					Log To Console    ${status}
					Run Keyword If  "${status}" != "OK"  Fatal Error
					Should be equal as strings    ${status}    OK

###################################################################################################################################
Nodes Verification Back End (Services should be running and active)
###################################################################################################################################
    [Documentation]                      *Nodes Verification Back End*
                                    ...  keywords:
                                    ...  PCC.Node Verify Back End
        [Tags]    Exclude
		${status}       PCC.Node Verify Back End
						...  host_ips=["${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}","${SERVER_1_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
						Log To Console    ${status}
						Run Keyword If  "${status}" != "OK"  Fatal Error
						Should Be Equal As Strings      ${status}    OK

#####################################################################################################################################
Install net-tools on nodes
#####################################################################################################################################

    [Documentation]    *Install net-tools on nodes* test                 
    [Tags]    Exclude
    
    ${status}    Install net-tools command
                 

                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK

					
###################################################################################################################################
Get Node Ids
###################################################################################################################################                    
        

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
Create IPAM Subnets
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready
	[Tags]    Exclude	
		###  Control CIDR  ####
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

		###  Data CIDR  #####
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
Verify Default IgwPolicy
###################################################################################################################################
	[Tags]    Exclude
        ${status}                   PCC.Verify Default IgwPolicy BE
                               ...  nodes=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Network Manager Creation
###################################################################################################################################
    [Documentation]                 *Network Manager Creation*
                               ...  keywords:
                               ...  PCC.Network Manager Create
	[Tags]    Exclude
        ${response}                 PCC.Network Manager Create
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=${NETWORK_MANAGER_NODES}
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
        
		####  Wait Until Network Manager Ready ####
		${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

		####  Verify Network Manager from Backend ####
		${status}                   PCC.Network Manager Verify BE      
                               ...  nodes_ip=${NETWORK_MANAGER_NODES_IP}
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP} 
                                    Should Be Equal As Strings      ${status}  OK

		${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK
####################################################################################################################################
#Create Kubernetes cluster
####################################################################################################################################
#        [Documentation]             *Create Kubernetes cluster*
#                               ...  Keywords:
#                               ...  PCC.K8s Create Cluster
#        
#	[Tags]    Today
#	${cluster_id}               PCC.K8s Get Cluster Id
#                               ...  name=${K8s_NAME}
#                                    Pass Execution If    ${cluster_id} is not ${None}    Cluster is already there
#
#	${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK        
#
#	${response}                 PCC.K8s Create Cluster
#                               ...  id=${K8S_ID}
#                               ...  k8sVersion=${K8S_VERSION}
#                               ...  name=${K8S_NAME}
#                               ...  cniPlugin=${K8S_CNIPLUGIN}
#                               ...  nodes=${K8S_NODES}
#                               ...  pools=${K8S_POOL}
#                               ...  networkClusterName=${NETWORK_MANAGER_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#        
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
#
###################################################################################################################################
Ceph Cluster Create
###################################################################################################################################
    [Documentation]                 *Creating Ceph Cluster*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready
       
	[Tags]    Today

	${id}                       PCC.Ceph Get Cluster Id
                              ...   name=${CEPH_CLUSTER_NAME}
                                    Pass Execution If    ${id} is not ${None}    Cluster is already there

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_3_NAME}","${CLUSTERHEAD_2_NAME}"]
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
                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_3_HOST_IP}","${SERVER_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK
									
###################################################################################################################################
Ceph Crush Map Validation
###################################################################################################################################
    [Documentation]                 *Ceph Crush Map Validation*
                               ...  keywords:
                               ...  CLI.Validate CEPH Crush Map From Backend
    [Tags]    ceph

        ${status}    CLI.Validate CEPH Crush Map From Backend
                     ...  node_location={"${SERVER_3_NAME}":["default-region","default-zone","default-site","default-rack"],"${SERVER_2_NAME}":["default-region","default-zone","default-site","default-rack"]}
                     ...  hostip=${SERVER_3_HOST_IP}

                     Should Be Equal As Strings      ${status}    OK    Validation unsuccessful


	${status}    CLI.Validate CEPH Crush Map From Backend
                     ...  node_location={"${SERVER_3_NAME}":["default-region","default-zone","default-site","default-rack"],"${SERVER_2_NAME}":["default-region","default-zone","default-site","default-rack"]}
		     ...  hostip=${SERVER_2_HOST_IP}

                     Should Be Equal As Strings      ${status}    OK    Validation unsuccessful

###################################################################################################################################
Ceph Storage Type Validation
###################################################################################################################################
    [Documentation]                 *Ceph Storage Type Validation*
                               ...  keywords:
                               ...  CLI.Validate CEPH Storage Type
    [Tags]    ceph

        ${status}    CLI.Validate CEPH Storage Type
                     ...  storage_types=['filestore']
                     ...  hostip=${SERVER_3_HOST_IP}

                     Should Be Equal As Strings      ${status}    OK
	
	${status}    CLI.Validate CEPH Storage Type
                     ...  storage_types=['filestore']
                     ...  hostip=${SERVER_2_HOST_IP}

                     Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Architecture- Nodes and OSDs
###################################################################################################################################
    [Documentation]                 *Ceph Architecture Node OSDs*
                               ...  keywords:
                               ...  PCC.Ceph Nodes OSDs Architecture Validation
	[Tags]	  ceph

        ${status}    PCC.Ceph Nodes OSDs Architecture Validation
                     ...  name=${CEPH_CLUSTER_NAME}
                     ...  hostip=${SERVER_2_HOST_IP}

                     Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Pools For Upgrade
###################################################################################################################################

    [Documentation]                             *Ceph Pool Creation for Fs*
                                           ...  keywords:
                                           ...  PCC.Ceph Get Cluster Id
                                           ...  PCC.Ceph Create Pool
                                           ...  PCC.Ceph Wait Until Pool Ready
	[Tags]    Today                   
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


###################################################################################################################################
Create Certificate for RGW
#####################################################################################################################################

     [Documentation]                             *Ceph Rados Gateway Creation With Replicated Pool Without S3 Accounts For Upgrade*
     [Tags]    Today          

        ${cert_id}                   PCC.Get Certificate Id
                                ...  Alias=${CEPH_RGW_CERT_NAME}
                                     Pass Execution If    ${cert_id} is not ${None}    Certificate is already there
	
	${response}                  PCC.Add Certificate
                                ...  Alias=${CEPH_RGW_CERT_NAME}
                                ...  Description=certificate-for-rgw
                                ...  Private_key=domain.key
                                ...  Certificate_upload=domain.crt

                                     Log To Console    ${response}
        
###################################################################################################################################
Ceph Rados Gateway Creation With Replicated Pool Without S3 Accounts For Upgrade
#####################################################################################################################################
	[Tags]    This

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
                                                Should Be Equal As Strings      ${status}    OK
               
        ${backend_status}                       PCC.Ceph Rgw Verify BE Creation
                                           ...  targetNodeIp=['${SERVER_2_HOST_IP}']
                                                Should Be Equal As Strings      ${backend_status}    OK

###################################################################################################################################
Ceph Rbd Creation For Upgrade
###################################################################################################################################
    [Documentation]                             *Ceph Rbd where size unit is in MiB*
                                           ...  keywords:
                                           ...  PCC.Ceph Get Pool Id
                                           ...  PCC.Ceph Get Cluster Id
                                           ...  PCC.Ceph Create Rbd
                                           ...  PCC.Ceph Wait Until Rbd Ready
        [Tags]    Today       
        ${status}                               PCC.Ceph Get Pcc Status
                                           ...  name=ceph-pvt
                                                Should Be Equal As Strings      ${status}    OK
               
        ${cluster_id}                           PCC.Ceph Get Cluster Id
                                           ...  name=${CEPH_Cluster_NAME}
               
        ${pool_id}                              PCC.Ceph Get Pool Id
                                           ...  name=rbd
               
        ${response}                             PCC.Ceph Create Rbd
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
Ceph Fs Creation For Upgrade
###################################################################################################################################
    [Documentation]                             *Creating Cepf FS For Upgrade*
                                           ...  keywords:
                                           ...  PCC.Ceph Get Cluster Id
                                           ...  PCC.Ceph Get Pool Details For FS
                                           ...  PCC.Ceph Create Fs
        [Tags]    This       
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
                                           ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_3_HOST_IP}","${SERVER_2_HOST_IP}"]
                                                Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create a Container Registry(using Auto mode) For Upgrade and Restore
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
Verify CR creation successful from frontend and backend
###################################################################################################################################

        [Documentation]                       *Verify CR creation successful from frontend and backend* test
                                              ...  keywords:
                                              ...  PCC.CR Verify Creation from PCC
                                              ...  Is Docker Container Up
                                              ...  motorframework.common.LinuxUtils.Is FQDN reachable
                                              ...  Is Port Used
        [Tags]    This                        
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
PCC Node Role Creation For Upgrade and restore
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
PCC-Tenant-Creation For Upgrade and restore
###################################################################################################################################

        [Documentation]                       *Create Tenant* test
                                              ...  keywords:
                                              ...  PCC.Add Tenant
                   
        ${parent_id}                          PCC.Get Tenant Id
                                              ...    Name=${ROOT_TENANT}
                           
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
PCC Node Group Creation and Verification For Upgrade and restore
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
Add Certificate with Private Keys For Upgrade and restore
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
Create scoping object - Region For Upgrade and restore
###################################################################################################################################

        [Documentation]                      *Create scoping object - Region* test
                                             ...  keywords:
                                             ...  PCC.Create Scope
                           
        [Tags]    Running                  
        ${response}                          PCC.Create Scope
                                             ...  type=region
                                             ...  scope_name=region-1
                                             ...  description=region-description
                                             
                                             
                                             Log To Console    ${response}
                                             ${result}    Get Result    ${response}
                                             ${status}    Get From Dictionary    ${result}    status
                                             ${message}    Get From Dictionary    ${result}    message
                                             Log to Console    ${message}
                                             Should Be Equal As Strings    ${status}    200
                                             
        ${status}                             PCC.Check Scope Creation From PCC
                                             ...  scope_name=region-1
                                             
                                             Log To Console    ${status}
                                             Should Be Equal As Strings    ${status}    OK
					   
###################################################################################################################################
Create a policy using DNS app, assigning it to Node and Scope
###################################################################################################################################

        [Documentation]                      *Create a policy* test
                                             ...  keywords:
                                             ...  PCC.Create Policy
        
        [Tags]    Only
        ###  Creating Policy  ####
		${app_id}                    PCC.Get App Id from Policies
                                             ...  Name=dns
                                             Log To Console    ${app_id}
                       
        ${parent1_id}                         PCC.Get Scope Id
                                             ...  scope_name=region-1                       
                                   
        ${response}                          PCC.Create Policy
                                             ...  appId=${app_id}
                                             ...  description=dns-policy-description
                                             ...  scopeIds=[${parent1_id}]                       
                                             
                                             Log To Console    ${response}
                                             ${result}    Get Result    ${response}
                                             ${status}    Get From Dictionary    ${result}    status
                                             ${message}    Get From Dictionary    ${result}    message
                                             Log to Console    ${message}
                                             Should Be Equal As Strings    ${status}    200
		
		###  Creating Node Role  ####
		
		${owner}                             PCC.Get Tenant Id       Name=${ROOT_TENANT}
                                             
        ${template_id}                       PCC.Get Template Id    Name=DNS
                                             Log To Console    ${template_id}
                                             
        ${response}                          PCC.Add Node Role
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
                                             
        ${status}                            PCC.Validate Node Role
                                             ...    Name=DNS_NODE_ROLE
                                             
                                             Log To Console    ${status}
                                             Should Be Equal As Strings    ${status}    OK    Node role doesnot exists
					 
		###  Adding Node roles on Node  ####
		
		${response}                          PCC.Add and Verify Roles On Nodes
                                             ...  nodes=["${SERVER_2_NAME}"]
                                             ...  roles=["DNS_NODE_ROLE","Default"]
                   
                                             Should Be Equal As Strings      ${response}  OK
                   
        ${status_code}                       PCC.Wait Until Roles Ready On Nodes
                                             ...  node_name=${SERVER_2_NAME}
                   
                                             Should Be Equal As Strings      ${status_code}  OK
		
		###   Updating node with Region- scope ####
		${node_id}                           PCC.Get Node Id
                                             ...  Name=${SERVER_2_NAME}
                                             Log To Console    ${node_id}
                                 
        ${parent1_Id}                        PCC.Get Scope Id
                                             ...  scope_name=region-1
                                             Log To Console    ${parent1_Id}
                     
        ${parent2_Id}                        PCC.Get Scope Id
                                             ...  scope_name=Default zone
                                             ...  parentID=${parent1_Id}
                                             Log To Console    ${parent2_Id}
                     
        ${scope_id}                          PCC.Get Scope Id
                                             ...  scope_name=Default site
                                             ...  parentID=${parent2_Id}
                                     
                                             Log To Console    ${scope_id}
        
	### Updating node with Location ####

	${node_role_1_id}		     PCC.Get Node Role Id
					     ...  Name=DNS_NODE_ROLE
					     
					     Log To Console    ${node_role_1_id}
	
	${node_role_2_id}                    PCC.Get Node Role Id
                                             ...  Name=Default

                                             Log To Console    ${node_role_2_id}						
                             
        ${response}                          PCC.Update Node
                                             ...  Id=${node_id}
                                             ...  Name=${SERVER_2_NAME}
                                             ...  scopeId=${scope_id}
                                             ...  roles=[${node_role_1_id},${node_role_2_id}]	     
                                             Log To Console    ${response}
                                             ${result}    Get Result    ${response}
                                             ${status}    Get From Dictionary    ${result}    status
                                             ${message}    Get From Dictionary    ${result}    message
                                             Log to Console    ${message}
                                             Should Be Equal As Strings    ${status}    200
                                 
		${node_wait_status}                  PCC.Wait Until Node Ready
                                             ...  Name=${SERVER_2_NAME}
                 
                                             Log To Console    ${node_wait_status}
                                             Should Be Equal As Strings    ${node_wait_status}    OK
							   
###################################################################################################################################
Verifying Policy assignment from backend
###################################################################################################################################
	[Tags]	This		
		##### Validate RSOP on Node ##########

        ${dns_rack_policy_id}                PCC.Get Policy Id
                                             ...  Name=dns
                                             ...  description=dns-policy-description
                                             Log To Console    ${dns_rack_policy_id}
                                             Set Global Variable    ${dns_rack_policy_id}
                                             
		${status}                            PCC.Validate RSOP of a node
                                             ...  node_name=${SERVER_2_NAME}
                                             ...  policyIDs=[${dns_rack_policy_id}]
             
                                             Log To Console    ${status}
                                             Should Be Equal As Strings      ${status}  OK
		
		##### Validate DNS from backend #########

        ${node_wait_status}                  PCC.Wait Until Node Ready
                                             ...  Name=${SERVER_2_NAME}
                                             
                                             Log To Console    ${node_wait_status}
                                             Should Be Equal As Strings    ${node_wait_status}    OK
                                             
        ${status}                            PCC.Validate DNS From Backend
                                             ...  host_ip=${SERVER_2_HOST_IP}
                                             ...  search_list=['8.8.8.8']
                                             
                                             Log To Console    ${status}
                                             Should Be Equal As Strings      ${status}  OK
