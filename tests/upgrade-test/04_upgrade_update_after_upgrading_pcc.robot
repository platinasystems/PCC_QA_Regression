*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
    [Tags]        assign
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
Login to PCC
###################################################################################################################################
        [Documentation]                 *Login to PCC and load data*
        [Tags]        assign

                ${status}                               Login To PCC        testdata_key=${pcc_setup}
                                                Should be equal as strings    ${status}    OK

###################################################################################################################################
Create scoping object - Region:TCP-1362
###################################################################################################################################

        [Documentation]    *Create scoping object - Region* test
                           ...  keywords:
                           ...  PCC.Create Scope

        #Create scoping object - Region

        ${response}    PCC.Create Scope
                       ...  type=region
                       ...  scope_name=region-2
                       ...  description=region-description

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


###################################################################################################################################
Create scoping object - Zone:TCP-1363
###################################################################################################################################

        [Documentation]    *Create scoping object - Zone* test
                           ...  keywords:
                           ...  PCC.Create Scope

        #Create scoping object - Zone


        ${parent_Id}    PCC.Get Scope Id
                        ...  scope_name=region-2
                        Log To Console    ${parent_Id}

        ${response}    PCC.Create Scope
                       ...  type=zone
                       ...  scope_name=zone-2
                       ...  description=zone-description
                       ...  parentID=${parent_Id}

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


###################################################################################################################################
Create scoping object - Site:TCP-1364
###################################################################################################################################

        [Documentation]    *Create scoping object - Site* test
                           ...  keywords:
                           ...  PCC.Create Scope

        #Create scoping object - Site

        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-2

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${parent1_Id}

                        Log To Console    ${parent2_Id}

        ${response}    PCC.Create Scope
                       ...  type=site
                       ...  scope_name=site-2
                       ...  description=site-description
                       ...  parentID=${parent2_Id}

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


###################################################################################################################################
Create scoping object - Rack:TCP-1365
###################################################################################################################################

        [Documentation]    *Create scoping object - Rack* test
                           ...  keywords:
                           ...  PCC.Create Scope


        #Create scoping object - Rack

        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-2

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-2
                        ...  parentID=${parent1_Id}

        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=site-2
                        ...  parentID=${parent2_Id}

                        Log To Console    ${parent3_Id}

        ${response}    PCC.Create Scope
                       ...  type=rack
                       ...  scope_name=rack-2
                       ...  description=rack-description
                       ...  parentID=${parent3_Id}

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
Alert Delete Raw Rule:TCP-1088
###################################################################################################################################
    [Documentation]                 *Alert Delete Raw Rule *
                               ...  Keywords:
                               ...  PCC.Alert Delete Rule
                               ...  PCC.Alert Verify Rule

        ${status}                   PCC.Alert Delete All Rule
                                    Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Alert Verify Raw Rule after Deletion
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

                                    Should Not Be Equal As Strings      ${status}    OK

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
Alert Verify Raw Rule after creation
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
PCC Node Group Creation and Verification After Upgrade and restore : TCP-357
###################################################################################################################################

        [Documentation]                       *PCC Node Group - Verify if user can access node group* test
                                              ...  keywords:
                                              ...  PCC.Add Node Group
                                              ...  PCC.Validate Node Group

        ${owner}                              PCC.Get Tenant Id       Name=ROOT

        ${response}                           PCC.Add Node Group
                                              ...    Name=${NODE_GROUP2}
                                              ...    owner=${owner}
                                              ...    Description=${NODE_GROUP_DESC2}

                                              Log To Console    ${response}
                                              ${result}    Get Result    ${response}
                                              ${status}    Get From Dictionary    ${result}    status
                                              ${message}    Get From Dictionary    ${result}    message
                                              Log to Console    ${message}
                                              Should Be Equal As Strings    ${status}    200


        ${status}                             PCC.Validate Node Group
                                              ...    Name=${NODE_GROUP2}

                                              Log To Console    ${status}
                                              Should Be Equal As Strings    ${status}    OK    Node group doesnot exists

##################################################################################################################################
Network Manager Update
###################################################################################################################################
    [Documentation]                 *Network Manager Update*
                               ...  keywords:
                               ...  PCC.Get Network Manager Id
                               ...  PCC.Network Manager Update
                               ...  PCC.Wait Until Network Manager Ready
                               ...  PCC.Network Manager Verify BE
        ${network_id}               PCC.Get Network Manager Id
                               ...  name=${NETWORK_MANAGER_NAME}

        ${response}                 PCC.Network Manager Update
                               ...  id=${network_id}
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=["${SERVER_3_NAME}","${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
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
                               ...  controlCIDR=${IPAM_CONTROL_SUBNET_IP}
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Ceph Cluster Update After Upgrade- Add Server
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
                               ...  nodes=["${SERVER_3_NAME}","${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK

####################################################################################################################################
Ceph Rados Gateway Delete (ServiceIp As Default)
####################################################################################################################################

    [Documentation]                 *Ceph Rados Gateway Delete*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Delete Rgw
                               ...  name=ceph-rgw
			                   ...  ceph_cluster_name=ceph-pvt

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Deleted
                               ...  name=ceph-rgw
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
                               ...  targetNodeIp=['${SERVER_3_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK
				    Sleep    5 minutes

###################################################################################################################################
Deleting Maas From Invader
###################################################################################################################################
    [Documentation]                 *Deleting Maas+LLDP From Nodes*
                               ...  Keywords:
                               ...  PCC.Delete and Verify Roles On Nodes
                               ...  PCC.Wait Until Roles Ready On Nodes
        ${response}                 PCC.Delete and Verify Roles On Nodes
                               ...  nodes=["${CLUSTERHEAD_2_NAME}"]
                               ...  roles=["Baremetal Management Node"]
                                    Should Be Equal As Strings      ${response}  OK

        ${status_code}              PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${CLUSTERHEAD_2_NAME}
                                    Should Be Equal As Strings      ${status_code}  OK

        ${response}                 PCC.Maas Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}"]
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                                    Should Not Be Equal As Strings      ${response}  OK

###################################################################################################################################
Adding Maas To Invader : TCP-1140
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
PCC-Tenant-Creation For Upgrade and restore :TCP-477
###################################################################################################################################

        [Documentation]    *Create Tenant* test
                           ...    keywords:
                           ...    PCC.Get Tenant Id
                           ...    PCC.Add Tenant

        ${parent_id}    PCC.Get Tenant Id
                        ...    Name=${ROOT_TENANT}

        ${response}    PCC.Add Tenant
                       ...    Name=Tenant_2
                       ...    Description=Tenant_2_DESC
                       ...    Parent_id=${parent_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200

        ${status}    PCC.Validate Tenant
                     ...    Name=Tenant_2

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Ceph Pools For Upgrade : TCP-566, TCP-567
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


        ${response}            PCC.Ceph Create Erasure Pool
                               ...  name=rgw-pool-2
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
                               ...  name=rgw-pool-2
                               Should Be Equal As Strings      ${status}    OK

        ${status}              PCC.Ceph Pool Verify BE
                               ...  name=rgw-pool-2
                               ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                               log to console                  ${status}
                               Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Ceph Rados Gateway Creation With EC Pool Without S3 Accounts For Upgrade :TCP-1273
#####################################################################################################################################
        [Documentation]                             *Ceph Rados Gateway Creation With EC Pool Without S3 Accounts For Upgrade*


        ${status}                               PCC.Ceph Get Pcc Status
                                           ...  name=ceph-pvt
                                                Should Be Equal As Strings      ${status}    OK

        ${response}                             PCC.Ceph Create Rgw
                                           ...  name=ceph-rgw
                                           ...  poolName=rgw-pool-2
                                           ...  targetNodes=["${SERVER_3_NAME}"]
                                           ...  port=${CEPH_RGW_PORT}
                                           ...  certificateName=${CEPH_RGW_CERT_NAME}

        ${status_code}                          Get Response Status Code        ${response}
                                                Should Be Equal As Strings      ${status_code}  200

        ${status}                               PCC.Ceph Wait Until Rgw Ready
                                           ...  name=ceph-rgw
                                           ...  ceph_cluster_name=ceph-pvt
                                                Should Be Equal As Strings      ${status}    OK

        ${backend_status}                       PCC.Ceph Rgw Verify BE Creation
                                           ...  targetNodeIp=['${SERVER_3_HOST_IP}']
                                                Should Be Equal As Strings      ${backend_status}    OK

###################################################################################################################################
Ceph Create RBD : TCP-569
###################################################################################################################################
    [Documentation]                 *Ceph Rbd where size unit is in MiB*
                               ...  keywords:
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=rbd

        ${response}                 PCC.Ceph Create Rbd
                               ...  pool_type=replicated
                               ...  name=rbd_after_upgrade
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=GiB

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=rbd_after_upgrade

                                    Should Be Equal As Strings      ${status}    OK

##################################################################################################################################
Add Node to Kubernetes cluster After Upgrade Restore :TCP-142
###################################################################################################################################


        [Documentation]               *Add Node to Kubernetes cluster*
                              ...  Keywords:
                              ...  PCC.K8s Update Cluster Nodes
                              ...  PCC.K8s Get Cluster Id
                              ...  PCC.K8s Wait Until Cluster is Ready

        [Tags]       k8s/scope

        ${cluster_id}               PCC.K8s Get Cluster Id
                              ...  name=${K8S_NAME}

       ${response}                PCC.K8s Update Cluster Nodes
                              ...  cluster_id=${cluster_id}
                              ...  name=${K8S_NAME}
                              ...  toAdd=["${SERVER_3_NAME}"]
                              ...  rolePolicy=auto

       ${status_code}              Get Response Status Code        ${response}
                                   Should Be Equal As Strings      ${status_code}  200

       ${status}                   PCC.K8s Wait Until Cluster is Ready
                              ...  name=${K8S_NAME}
                                   Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Ceph Cluster Update - Remove Server
###################################################################################################################################
    [Documentation]                 *Ceph Cluster Update - Remove Invader*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready

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
                               ...  nodes=["${SERVER_3_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK


#################################################################################################################################
Remove Node to Kubernetes cluster
###################################################################################################################################

        [Documentation]             *Remove Node to Kubernetes cluster*
                               ...  Keywords:
                               ...  PCC.K8s Update Cluster Nodes
                               ...  PCC.K8s Get Cluster Id
                               ...  PCC.K8s Wait Until Cluster is Ready

        ${cluster_id}               PCC.K8s Get Cluster Id
                               ...  name=${K8S_NAME}

        ${response}                 PCC.K8s Update Cluster Nodes
                               ...  cluster_id=${cluster_id}
                               ...  name=${K8S_NAME}
                               ...  toRemove=["${SERVER_3_NAME}"]
                               ...  rolePolicy=auto

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.K8s Wait Until Cluster is Ready
                               ...  name=${K8S_NAME}
                                    Should Be Equal As Strings      ${status}    OK
