*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load K8s Data    ${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Network Manager Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    
        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK
                                    
###################################################################################################################################
Create Subnet
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready

        ${response}                 PCC.Ipam Subnet Create
                               ...  name=subnet-pvt
                               ...  subnet=10.0.130.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=subnet-pvt

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create another subnet with different name and same CIDR
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready

        ${response}                 PCC.Ipam Subnet Create
                               ...  name=subnet-pvt-1
                               ...  subnet=10.0.130.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=subnet-pvt-1

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Create another subnet with different name and different CIDR
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready

        ${response}                 PCC.Ipam Subnet Create
                               ...  name=subnet-pvt-2
                               ...  subnet=10.0.131.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=subnet-pvt-2

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Update subnet name
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready

        ${id}                       PCC.Ipam Subnet Get Id
                               ...  name=subnet-pvt-2

        ${response}                 PCC.Ipam Subnet Update
                               ...  id=${id}
                               ...  name=subnet-pvt-upd
                               ...  subnet=10.0.131.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=subnet-pvt-upd
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Verify Ipam Subnet Updated
                               ...  name=subnet-pvt-upd
                                    Should Be Equal As Strings      ${status}    OK                                    

###################################################################################################################################
Update subnet name to the name of already existing subnet
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready

        ${id}                       PCC.Ipam Subnet Get Id
                               ...  name=subnet-pvt-upd

        ${response}                 PCC.Ipam Subnet Update
                               ...  id=${id}
                               ...  name=subnet-pvt-1
                               ...  subnet=10.0.131.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=subnet-pvt-1
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Verify Ipam Subnet Updated
                               ...  name=subnet-pvt-1
                                    Should Be Equal As Strings      ${status}    OK  


###################################################################################################################################
Update subnet 
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready

        ${id}                       PCC.Ipam Subnet Get Id
                               ...  name=subnet-pvt

        ${response}                 PCC.Ipam Subnet Update
                               ...  id=${id}
                               ...  name=subnet-pvt
                               ...  subnet=10.0.141.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=subnet-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Verify Ipam Subnet Updated
                               ...  name=subnet-pvt
                               ...  subnet=10.0.141.0/24
                                    Should Be Equal As Strings      ${status}    OK  
 
###################################################################################################################################
Create IPAM Subnet For Network Manager
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready


        ${response}                 PCC.Ipam Subnet Create
                               ...  name=control-pvt
                               ...  subnet=10.0.130.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=control-pvt
                                    Should Be Equal As Strings      ${status}    OK 
                                    
        ${response}                 PCC.Ipam Subnet Create
                               ...  name=data-pvt
                               ...  subnet=10.0.131.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=data-pvt
                                    Should Be Equal As Strings      ${status}    OK 

###################################################################################################################################
Network Manager Creation
###################################################################################################################################
    [Documentation]                 *Network Manager Creation*
                               ...  keywords:
                               ...  PCC.Network Manager Create


        ${response}                 PCC.Network Manager Create
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=${NETWORK_MANAGER_NODES}
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK
 
###################################################################################################################################
Network Manager Update
###################################################################################################################################
    [Documentation]                 *Network Manager Update*
                               ...  keywords:
                               ...  PCC.Network Manager Update
                               ...  PCC.Wait Until Network Manager Ready

        ${network_id}               PCC.Get Network Manager Id
                               ...  name=${NETWORK_MANAGER_NAME}
                               
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

###################################################################################################################################
Ceph Cluster Create 
###################################################################################################################################
    [Documentation]                 *Creating Ceph Cluster*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready
                               
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
                                    
###################################################################################################################################
Create Kubernetes cluster
###################################################################################################################################
        [Documentation]             *Create Kubernetes cluster*
                               ...  Keywords:
                               ...  PCC.K8s Create Cluster
                               
        ${cluster_id}               PCC.K8s Get Cluster Id
                               ...  name=${K8s_NAME}
                                    Pass Execution If    ${cluster_id} is not ${None}    Cluster is already there

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
                                    
###################################################################################################################################
Delete Subnets Which Are Mapped To Nework Manager (Negative)
###################################################################################################################################
    [Documentation]                 *Delete IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Delete
                               ...  PCC.Wait Until Ipam Subnet Deleted


        ${response}                 PCC.Ipam Subnet Delete
                               ...  name=data-pvt

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Delete Subnet
###################################################################################################################################
    [Documentation]                 *Delete IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Delete
                               ...  PCC.Wait Until Ipam Subnet Deleted


        ${response}                 PCC.Ipam Subnet Delete
                               ...  name=subnet-pvt

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Deleted
                               ...  name=subnet-pvt

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Cluster Delete
###################################################################################################################################
    [Documentation]                 *Delete cluster if it exist*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Delete Cluster
                               ...  PCC.Ceph Wait Until Cluster Deleted
                               ...  PCC.Ceph Cleanup BE

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Pass Execution If    ${id} is ${None}    Cluster is alredy Deleted

        ${response}                 PCC.Ceph Delete Cluster
                               ...  id=${id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Cluster Deleted
                               ...  id=${id}
                                    Should Be Equal As Strings     ${status}  OK

        ${response}                 PCC.Ceph Cleanup BE
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}    
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               
        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
                                    Should Not Be Equal As Strings      ${status}    OK                               

###################################################################################################################################
Delete K8 Cluster
###################################################################################################################################     
        [Documentation]             *Delete K8 Cluster*  
                               ...  Keywords:
                               ...  PCC.K8s Upgrade Cluster
                               ...  PCC.K8s Delete Cluster
                               ...  PCC.K8s Wait Until Cluster Deleted
                               
        ${cluster_id}               PCC.K8s Get Cluster Id
                               ...  name=${K8s_NAME}
                                    Pass Execution If    ${cluster_id} is ${None}    Cluster is alredy Deleted

        ${response}                 PCC.K8s Delete Cluster
                               ...  cluster_id=${cluster_id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.K8s Wait Until Cluster Deleted
                               ...  cluster_id=${cluster_id}
                                    Should Be Equal As Strings    ${status}  OK     
                                    
        ${status}                   PCC.K8s Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]
                                    Should Not Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Network Manager Delete
###################################################################################################################################
    [Documentation]                 *Network Manager Verification PCC*
                               ...  keywords:
                               ...  PCC.Network Manager Delete

        ${response}                 PCC.Network Manager Delete
                               ...  name=${NETWORK_MANAGER_NAME}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Network Manager Deleted
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Network Manager Verify BE      
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                                    Should Not Be Equal As Strings      ${status}  OK  
 
###################################################################################################################################
Delete Multiple Subnet
###################################################################################################################################
    [Documentation]                 *Delete IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Delete All

        ${status}                   PCC.Ipam Subnet Delete All
                               ...  name=subnet-pvt                             
                                    Should Be Equal As Strings      ${status}    OK
