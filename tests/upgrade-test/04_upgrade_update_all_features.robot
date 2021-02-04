*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
	[Tags]	This
                                                Load Clusterhead 1 Test Data    ${pcc_setup}
                                                Load Clusterhead 2 Test Data    ${pcc_setup}
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
		${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK
												
###################################################################################################################################
Network Manager Update after Upgrade
###################################################################################################################################
    [Documentation]                 *Network Manager Update*
                               ...  keywords:
                               ...  PCC.Get Network Manager Id
                               ...  PCC.Network Manager Update
                               ...  PCC.Wait Until Network Manager Ready
                               ...  PCC.Network Manager Verify BE

        ${network_id}               PCC.Get Network Manager Id
                               ...  name=${NETWORK_MANAGER_NAME}
        
		### Adding a node #####
        ${response}                 PCC.Network Manager Update
                               ...  id=${network_id}
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Network Manager Verify BE      
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK
		
		### Try to remove two invaders (Negative) ###
		
		${response}                 PCC.Network Manager Update
                               ...  id=${network_id}
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}"]
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

####################################################################################################################################
#Add App To K8 Cluster and delete after Upgrade
####################################################################################################################################
#        [Documentation]             *Add App Kubernetes cluster*
#                               ...  Keywords:
#                               ...  PCC.K8s Get Cluster Id
#                               ...  PCC.K8s Add App 
#                               ...  PCC.K8s Wait Until Cluster is Ready
#		
#		### Add App to K8s ###
#        ${cluster_id}               PCC.K8s Get Cluster Id
#                               ...  name=${K8S_NAME}
#                                    
#        ${response}                 PCC.K8s Add App                    
#                               ...  cluster_id=${cluster_id}
#                               ...  appName=${K8S_APPNAME}
#                               ...  appNamespace=${K8S_APPNAMESPACE}
#                               ...  gitUrl=${K8S_GITURL}
#                               ...  gitRepoPath=${K8S_GITREPOPATH}
#                               ...  gitBranch=${K8S_GITBRANCH}
#                               ...  label=${K8S_LABEL}
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                
#        ${status}                   PCC.K8s Wait Until Cluster is Ready
#                               ...  name=${K8S_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#		### Delete App from K8s ###
#
#        ${cluster_id}               PCC.K8s Get Cluster Id
#                               ...  name=${K8S_NAME}
#   
#        ${app_id}                   PCC.K8s Get App Id
#                               ...  appName=${K8S_APPNAME}
#                                    
#        ${response}                 PCC.K8s Delete App
#                               ...  cluster_id=${cluster_id}
#                               ...  appIds=${app_id}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.K8s Wait Until Cluster is Ready
#                               ...  name=${K8S_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#									
###################################################################################################################################
#Reboot Node And Verify K8s Is Intact After Upgrade
###################################################################################################################################
#    [Documentation]                 *Verifying K8s cluster BE*
#                               ...  keywords:
#                               ...  PCC.K8s Verify BE
#                               ...  Restart node
#                               
#    ${restart_status}               Restart node
#                               ...  hostip=${CLUSTERHEAD_1_HOST_IP}
#                               ...  time_to_wait=240
#                                    Log to console    ${restart_status}
#                                    Should Be Equal As Strings    ${restart_status}    OK
#
#        ${status}                   PCC.K8s Verify BE
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]
#
#                                    Should Be Equal As Strings      ${status}    OK
									
###################################################################################################################################
Ceph Cluster Update - Add Invader- After Upgrade
###################################################################################################################################
    [Documentation]                 *Ceph Cluster Update - Add Invade*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK 

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}","${CLUSTERHEAD_1_NAME}"]
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
                                    
###################################################################################################################################
#Reboot Node And Verify Ceph Is Intact - After Upgrade
###################################################################################################################################
#    [Documentation]                 *Verifying Ceph cluster BE*
#                               ...  keywords:
#                               ...  Ceph Verify BE
#                               ...  Restart node
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK 
# 
#    ${restart_status}               Restart node
#                               ...  hostip=${SERVER_1_HOST_IP}
#                               ...  time_to_wait=240
#                                    Log to console    ${restart_status}
#                                    Should Be Equal As Strings    ${restart_status}    OK
#
#        ${status}                   PCC.Ceph Verify BE
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]
#
#                                    Should Be Equal As Strings      ${status}    OK  
                                    
#################################################################################################################################
Down And Up The Interface And Check For Ceph - After Upgrade
###################################################################################################################################
        [Documentation]             *Down And Up The Interface And Check For Ceph*
                               ...  Keywords:
                               ...  PCC.Set Interface Down
                               ...  PCC.Set Interface Up
                               ...  PCC.Ceph Verify BE

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
                               
        ${status}                   PCC.Set Interface Down
                               ...  host_ip=${SERVER_1_HOST_IP}
                               ...  interface_name="enp130s0"
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Set Interface Up
                               ...  host_ip=${SERVER_1_HOST_IP}
                               ...  interface_name="enp130s0"
                                    Should Be Equal As Strings      ${status}  OK
                                    
        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete Network Manager When Ceph Is Present (Negative) - After Upgrade
###################################################################################################################################
    [Documentation]                 *Network Manager Verification PCC*
                               ...  keywords:
                               ...  PCC.Network Manager Delete
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Network Manager Delete
                               ...  name=${NETWORK_MANAGER_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

###################################################################################################################################
TCP-1012 Update Cluster(2 Invader setup) - Remove - Remove TWO OSD nodes from cluster [4 nodes (3 MONs + 2 OSDs)] (Negative)- After Upgrade
###################################################################################################################################
    [Documentation]                 *Update Cluster(2 Invader setup) - Remove - Remove TWO OSD nodes from cluster [4 nodes (3 MONs + 2 OSDs)]*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  nodes=["${CLUSTERHEAD_2_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
      

###################################################################################################################################
Ceph Pool Edit Name - After Upgrade
###################################################################################################################################
    [Documentation]                 *Ceph Pool Edit Name*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Pool Update
                               ...  PCC.Ceph Wait Until Pool Ready        
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=rbd

        ${response}                 PCC.Ceph Pool Update
                               ...  id=${pool_id}
                               ...  name=rbd-upgrade
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=1
                               ...  quota_unit=TiB
                               

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=rbd-upgrade

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Pool Ugrade Quota Unit - After Upgrade
###################################################################################################################################
    [Documentation]                 *Updating Ceph Pool Size*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Pool Update
                               ...  PCC.Ceph Wait Until Pool Ready
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK
                               
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=fs1

        ${response}                 PCC.Ceph Pool Update
                               ...  id=${pool_id}
                               ...  name=fs1
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=1
                               ...  quota_unit=PiB
                               
        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=fs1

                                    Should Be Equal As Strings      ${status}    OK
									
###################################################################################################################################
Create Application credential profile without application For Rados - After Upgrade
###################################################################################################################################

        [Documentation]               *Create Metadata Profile* test
                                      ...  keywords:
                                      ...  PCC.Add Metadata Profile
            
        ${response}                   PCC.Add Metadata Profile
                                      ...    Name=${CEPH_RGW_S3ACCOUNTS}
                                      ...    Type=ceph
                                      ...    Username=profile_without_app
                                      ...    Email=profile_without_app@gmail.com
                                      ...    Active=True
                                      
                                      Log To Console    ${response}
                                      ${result}    Get Result    ${response}
                                      ${status}    Get From Dictionary    ${result}    status
                                      ${message}    Get From Dictionary    ${result}    message
                                      Log to Console    ${message}
                                      Should Be Equal As Strings    ${status}    200
									  
######################################################################################################################################
#Ceph Rados Add S3Account - After Upgrade
######################################################################################################################################
#     [Documentation]                *Ceph Rados Gateway Update*
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME}
#     
#        ${response}                 PCC.Ceph Update Rgw
#                               ...  ID=${rgw_id}
#                               ...  name=${CEPH_RGW_NAME}
#                               ...  poolName=rgw
#                               ...  targetNodes=${CEPH_RGW_NODES}
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rgw Ready
#                               ...  name=${CEPH_RGW_NAME}
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
#                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
#                                    Should Be Equal As Strings      ${backend_status}    OK 
#
#####################################################################################################################################
Ceph Rados Update Port - After Upgrade
#####################################################################################################################################
     [Documentation]                 *Ceph Rados Gateway Update*
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
     
        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=rgw
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=446
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               #...  S3Accounts=["${CEPH_RGW_S3Accounts}"]
                               
        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${status}    OK   

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK 
                                    
#####################################################################################################################################
Ceph Rados Update Nodes (Add Node) - After Upgrade
#####################################################################################################################################
     [Documentation]                *Ceph Rados Gateway Update*
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
     
        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=rgw
                               ...  targetNodes=["${SERVER_2_NAME}","${SERVER_1_NAME}"]
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               #...  S3Accounts=["${CEPH_RGW_S3Accounts}"]
                               
        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${status}    OK  

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=["${SERVER_1_HOST_IP}"]
                                    Should Be Equal As Strings      ${backend_status}    OK 

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=["${SERVER_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${backend_status}    OK
									
###################################################################################################################################
Ceph Rbd Update Name - Rename
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Update Name - Rename*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Rbd Update
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Wait Until Rbd Ready
        
		${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=rbd-upgrade

        ${id}                       PCC.Ceph Get Rbd Id
                               ...  name=${CEPH_RBD_NAME}

        ${response}                 PCC.Ceph Rbd Update
                               ...  id=${id}
                               ...  name=rbd-rename
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=1
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=MiB

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd-rename

                                    Should Be Equal As Strings      ${status}    OK
									
###################################################################################################################################
Update CephFS - remove_data_pools - After upgrade
###################################################################################################################################
    [Documentation]                 *Update CephFS - remove_default_pool*
                               ...  keywords:
                               ...  PCC.Ceph Get Fs Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Update Fs
                               ...  PCC.Ceph Wait Until Fs Ready
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=fs1

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=fs3

        ${response}                 PCC.Ceph Update Fs
                               ...  id=${id}
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Fs Ready
                               ...  name=${CEPH_FS_NAME}

                                    Should Be Equal As Strings      ${status}    OK		

###################################################################################################################################
Ceph Crush Map Validation
###################################################################################################################################
    [Documentation]                 *Ceph Crush Map Validation*
                               ...  keywords:
                               ...  CLI.Validate CEPH Crush Map From Backend
    [Tags]    ceph

        ${status}    CLI.Validate CEPH Crush Map From Backend
                     ...  node_location={"${SERVER_1_NAME}":["default-region","default-zone","default-site","default-rack"],"${SERVER_2_NAME}":["region-1"]}
                     ...  hostip=${SERVER_1_HOST_IP}

                     Should Be Equal As Strings      ${status}    OK    Validation unsuccessful

       ${status}    CLI.Validate CEPH Crush Map From Backend
                    ...  node_location={"${SERVER_1_NAME}":["default-region","default-zone","default-site","default-rack"],"${SERVER_2_NAME}":["region-1"]}
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
                     ...  hostip=${SERVER_1_HOST_IP}

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
        [Tags]    ceph

        ${status}    PCC.Ceph Nodes OSDs Architecture Validation
                     ...  name=${CEPH_CLUSTER_NAME}
                     ...  hostip=${SERVER_1_HOST_IP}

                     Should Be Equal As Strings      ${status}    OK
							
###################################################################################################################################
Edit FQDN in Container Registry after upgrade
###################################################################################################################################
        
        [Documentation]    *Edit FQDN* test
                           ...  keywords:
                           ...  PCC.Update Container Registry
                                   
        ${server_id}     PCC.Get CR_Server Id    Name=${CR_NAME}
                         Log To Console    ${server_id}
                         Set Global Variable    ${server_id}

        ${response}    PCC.Update Container Registry 
                       
                       ...    nodeID=${server_id}
                       ...    Name=${CR_NAME}
                       ...    fullyQualifiedDomainName=${CR_MODIFIED_FQDN}
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
                       Should Be Equal As Strings    ${status}    200

                       PCC.CR Wait For CR updation
                       ...    Name=${CR_NAME}

									
###################################################################################################################################
PCC Edit Node Role after upgrade
###################################################################################################################################

        [Documentation]    *PCC Edit Node Role* test
                           ...  keywords:
                           ...  PCC.Modify Node Role
                           ...  PCC.Validate Node Role
        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}
        
        ${template_id}    PCC.Get Template Id    Name=${APP_1} 
        
        ${node_role_id}    PCC.Get Node Role Id    Name=${NODE_ROLE_1}
                            
        
        ${response}    PCC.Modify Node Role
                       ...    Id=${node_role_id}
                       ...    Name=${NODE_ROLE_5}
                       ...    Description=${NODE_ROLE_DESC_5}
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
                     ...    Name=${NODE_ROLE_5}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists

###################################################################################################################################
Node Group Name Change after upgrade
###################################################################################################################################

        [Documentation]    *Node Group Name Change* test
                           ...  keywords:
                           ...  Get Node Group Id
                           ...  PCC.Get Tenant Id
                           ...  PCC.Modify Node Group
                           ...  PCC.Validate Node Group
                           
        ${nodegroup_id}    PCC.Get Node Group Id                                  
                           ...    Name=${NODE_GROUP1}
        
        ${owner}       PCC.Get Tenant Id       Name=ROOT
        
        ${response}    PCC.Modify Node Group
                       ...    Id=${nodegroup_id}
                       ...    Name=${NODE_GROUP4} 
                       ...    owner=${owner}
                       ...    Description=${NODE_GROUP_DESC4}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
                       
        ${status}    PCC.Validate Node Group
                     ...    Name=${NODE_GROUP4}
                     
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node group doesnot exists   


