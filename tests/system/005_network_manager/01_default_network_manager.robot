########### Uncommenting network manager code for 242 nodes ##############

*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Ipam Data    ${pcc_setup}
                                    Load K8s Data    ${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Network Manager Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    Load Server 3 Test Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
#Create Kubernetes cluster without Network Manager (Negative)
####################################################################################################################################
#        [Documentation]             *Create Kubernetes cluster*
#                               ...  Keywords:
#                               ...  PCC.K8s Create Cluster
#
#        ${network_id}               PCC.Get Network Manager Id
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Pass Execution If    ${network_id} is not ${None}    Network is already there
#
#        ${cluster_id}               PCC.K8s Get Cluster Id
#                               ...  name=${K8s_NAME}
#                                    Pass Execution If    ${cluster_id} is not ${None}    Cluster is already there
#
#        ${response}                 PCC.K8s Create Cluster
#                               ...  id=${K8S_ID}
#                               ...  k8sVersion=${K8S_VERSION}
#                               ...  name=${K8S_NAME}
#                               ...  cniPlugin=${K8S_CNIPLUGIN}
#                               ...  nodes=${K8S_NODES}
#                               ...  pools=${K8S_POOL}
#                               ...  networkClusterName=${NETWORK_MANAGER_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
###################################################################################################################################
Ceph Cluster Creation without Network Manager (Negative)
###################################################################################################################################
    [Documentation]                 *Creating Ceph Cluster*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster

        ${network_id}               PCC.Get Network Manager Id
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Pass Execution If    ${network_id} is not ${None}    Network is already there

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Pass Execution If    ${id} is not ${None}    Ceph Cluster is already there

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Network Manager Creation with same ControlCIDR and DataCIDR
###################################################################################################################################
    [Documentation]                 *Network Manager Creation with same ControlCIDR and DataCIDR*
                               ...  keywords:
                               ...  PCC.Network Manager Create
                               ...  PCC.Wait Until Network Manager Ready
                               ...  PCC.Network Manager Verify BE

        ${response}                 PCC.Network Manager Create
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  controlCIDR=${NETWORK_MANAGER_DATACIDR}
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

###################################################################################################################################
Network Manager Delete and Verify PCC (Network Manager with same ControlCIDR and DataCIDR)
###################################################################################################################################
    [Documentation]                 *Network Manager Verification PCC*
                               ...  keywords:
                               ...  PCC.Network Manager Delete
                               ...  PCC.Wait Until Network Manager Ready

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
Set Interfaces For Server Falling in DataCIDR
###################################################################################################################################
    [Documentation]                 *Set Interfaces For Server Falling in DataCIDR*
                               ...  keywords:
                               ...  PCC.Interface Set 1D Link
                               ...  PCC.Interface Apply
                               ...  PCC.Interface Verify PCC

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0
                               ...  assign_ip=["192.168.150.10/31"]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${SERVER_1_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0
                               ...  assign_ip=["192.168.150.10/31"]
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0d1
                               ...  assign_ip=["192.168.150.12/31"]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${SERVER_1_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0d1
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0d1
                               ...  assign_ip=["192.168.150.12/31"]
                                    Should Be Equal As Strings      ${status}    OK

#################################################################################################################################

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                               ...  interface_name=xeth1-1
                               ...  assign_ip=["192.168.150.9/31"]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${CLUSTERHEAD_1_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                               ...  interface_name=xeth1-1
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                               ...  interface_name=xeth1-1
                               ...  assign_ip=["192.168.150.9/31"]
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${CLUSTERHEAD_2_NAME}
                               ...  interface_name=xeth1-1
                               ...  assign_ip=["192.168.150.11/31"]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${CLUSTERHEAD_2_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                               ...  interface_name=xeth1-1
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${CLUSTERHEAD_2_NAME}
                               ...  interface_name=xeth1-1
                               ...  assign_ip=["192.168.150.11/31"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Network Manager Creation (Interfaces For Server Falling in DataCIDR)
###################################################################################################################################
    [Documentation]                 *Network Manager Creation*
                               ...  keywords:
                               ...  PCC.Network Manager Create
                               ...  PCC.Wait Until Network Manager Ready
                               ...  PCC.Network Manager Verify BE

                                    Sleep    60s
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

        ${status}                   PCC.Network Manager Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

########################################################################################################################################
#Check if PCC assign the Network Resource node role to the nodes on successful deployment of Network Routing on a set of nodes (TCP-1590)
########################################################################################################################################
#
#        ${status}    PCC.Verify Node Role On Nodes
#                     ...    Name=Network Resource
#                     ...    nodes=["${SERVER_1_NAME}","${SERVER_2_NAME}","${CLUSTERHEAD_1_NAME}"]
#
#                     Log To Console    ${status}
#                     Should Be Equal As Strings    ${status}    OK
#
###################################################################################################################################
Interface Verification For Server Falling In DataCIDR
###################################################################################################################################
    [Documentation]                 *Interface Verification For Server Falling In DataCIDR*
                               ...  keywords:
                               ...  PCC.Interface Verify PCC

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0
                               ...  assign_ip=["192.168.150.10/31"]
                                    Should Not Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0d1
                               ...  assign_ip=["192.168.150.12/31"]
                                    Should Not Be Equal As Strings      ${status}    OK

###################################################################################################################################
Network Manager Update (Interfaces For Server Falling in DataCIDR)
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

###################################################################################################################################
Network Manager Refresh (Interfaces For Server Falling in DataCIDR)
###################################################################################################################################
    [Documentation]                 *Network Manager Refresh Interfaces For Server Falling in DataCIDR*
                               ...  keywords:
                               ...  PCC.Network Manager Refresh
                               ...  PCC.Wait Until Network Manager Ready
                               ...  PCC.Network Manager Verify BE

        ${response}                 PCC.Network Manager Refresh
                               ...  name=${NETWORK_MANAGER_NAME}

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

###################################################################################################################################
Network Manager Delete (Interfaces For Server Falling in DataCIDR)
###################################################################################################################################
    [Documentation]                 *Network Manager Delete Interfaces For Server Falling in DataCIDR*
                               ...  keywords:
                               ...  PCC.Network Manager Delete
                               ...  PCC.Wait Until Network Manager Deleted

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
Set Interfaces For Server Not Falling In DataCIDR
###################################################################################################################################
    [Documentation]                 *Set Interfaces For Server Not Falling In DataCIDR*
                               ...  keywords:
                               ...  PCC.Interface Set 1D Link
                               ...  PCC.Interface Apply
                               ...  PCC.Interface Verify PCC

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0
                               ...  assign_ip=["192.168.72.10/31"]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${SERVER_1_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0
                               ...  assign_ip=["192.168.72.10/31"]
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0d1
                               ...  assign_ip=["192.168.72.12/31"]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${SERVER_1_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0d1
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0d1
                               ...  assign_ip=["192.168.72.12/31"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                               ...  interface_name=xeth1-1
                               ...  assign_ip=["192.168.72.9/31"]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${CLUSTERHEAD_1_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                               ...  interface_name=xeth1-1
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                               ...  interface_name=xeth1-1
                               ...  assign_ip=["192.168.72.9/31"]
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${CLUSTERHEAD_2_NAME}
                               ...  interface_name=xeth1-1
                               ...  assign_ip=["192.168.72.11/31"]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${CLUSTERHEAD_2_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                               ...  interface_name=xeth1-1
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${CLUSTERHEAD_2_NAME}
                               ...  interface_name=xeth1-1
                               ...  assign_ip=["192.168.72.11/31"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Network Manager Creation (Interfaces For Server Not Falling In DataCIDR)
###################################################################################################################################
    [Documentation]                 *Network Manager Creation Interfaces For Server Not Falling In DataCIDR*
                               ...  keywords:
                               ...  PCC.Network Manager Create
                               ...  PCC.Wait Until Network Manager Ready
                               ...  PCC.Network Manager Verify BE

                                    Sleep    60s
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

        ${status}                   PCC.Network Manager Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Interface Verification For Server Not Falling In DataCIDR
###################################################################################################################################
    [Documentation]                 *Interface Verification Interfaces For Server Not Falling In DataCIDR*
                               ...  keywords:
                               ...  PCC.Interface Verify PCC

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0
                               ...  assign_ip=["192.168.72.10/31"]
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0d1
                               ...  assign_ip=["192.168.72.12/31"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Network Manager Update (Interfaces For Server Not Falling In DataCIDR)
###################################################################################################################################
    [Documentation]                 *Network Manager Update Interfaces For Server Not Falling In DataCIDR*
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

###################################################################################################################################
Network Manager Refresh (Interfaces For Server Not Falling In DataCIDR)
###################################################################################################################################
    [Documentation]                 *Network Manager Refresh Interfaces For Server Not Falling In DataCIDR*
                               ...  keywords:
                               ...  PCC.Network Manager Refresh
                               ...  PCC.Wait Until Network Manager Ready
                               ...  PCC.Network Manager Verify BE

        ${response}                 PCC.Network Manager Refresh
                               ...  name=${NETWORK_MANAGER_NAME}

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

###################################################################################################################################
Network Manager Delete (Interfaces For Server Not Falling In DataCIDR)
###################################################################################################################################
    [Documentation]                 *Network Manager Delete Interfaces For Server Not Falling In DataCIDR*
                               ...  keywords:
                               ...  PCC.Network Manager Delete
                               ...  PCC.Wait Until Network Manager Deleted

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
Set Interfaces For Server Partially Falling In DataCIDR
###################################################################################################################################
    [Documentation]                 *Set Interfaces For Server Partially Falling In DataCIDR*
                               ...  keywords:
                               ...  PCC.Interface Set 1D Link
                               ...  PCC.Interface Apply
                               ...  PCC.Interface Verify PCC

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0
                               ...  assign_ip=["192.168.72.10/31"]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${SERVER_1_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0
                               ...  assign_ip=["192.168.72.10/31"]
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0d1
                               ...  assign_ip=["192.168.150.12/31"]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${SERVER_1_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0d1
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0d1
                               ...  assign_ip=["192.168.150.12/31"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                               ...  interface_name=xeth1-1
                               ...  assign_ip=["192.168.72.9/31"]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${CLUSTERHEAD_1_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                               ...  interface_name=xeth1-1
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                               ...  interface_name=xeth1-1
                               ...  assign_ip=["192.168.72.9/31"]
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${CLUSTERHEAD_2_NAME}
                               ...  interface_name=xeth1-1
                               ...  assign_ip=["192.168.150.11/31"]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${CLUSTERHEAD_2_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                               ...  interface_name=xeth1-1
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${CLUSTERHEAD_2_NAME}
                               ...  interface_name=xeth1-1
                               ...  assign_ip=["192.168.150.11/31"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Network Manager Creation (Interfaces For Server Partially Falling In DataCIDR)
###################################################################################################################################
    [Documentation]                 *Network Manager Creation (Interfaces For Server Partially Falling In DataCIDR)*
                               ...  keywords:
                               ...  PCC.Network Manager Create
                               ...  PCC.Wait Until Network Manager Ready
                               ...  PCC.Network Manager Verify BE

        ${response}                 PCC.Network Manager Create
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Network Manager Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Interface Verification For Server Partially Falling in DataCIDR
###################################################################################################################################
    [Documentation]                 *Interface Verification For Server Partially Falling in DataCIDR*
                               ...  keywords:
                               ...  PCC.Interface Verify PCC

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0
                               ...  assign_ip=["192.168.72.10/31"]
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0d1
                               ...  assign_ip=["192.168.150.12/31"]
                                    Should Not Be Equal As Strings      ${status}    OK

###################################################################################################################################
Network Manager Refresh (Interfaces For Server Partially Falling In DataCIDR)
###################################################################################################################################
    [Documentation]                 *Network Manager Refresh (Interfaces For Server Partially Falling In DataCIDR)*
                               ...  keywords:
                               ...  PCC.Network Manager Refresh
                               ...  PCC.Wait Until Network Manager Ready
                               ...  PCC.Network Manager Verify BE

        ${response}                 PCC.Network Manager Refresh
                               ...  name=${NETWORK_MANAGER_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

         ${status}                  PCC.Network Manager Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                                    Should Be Equal As Strings      ${status}  OK

         ${status}                  PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
#Network Manager Update (Interfaces For Server Partially Falling In DataCIDR) (Add and Remove node simultaneously)
####################################################################################################################################
#    [Documentation]                 *Network Manager Update (Interfaces For Server Partially Falling In DataCIDR)*
#                               ...  keywords:
#                               ...  PCC.Get Network Manager Id
#                               ...  PCC.Network Manager Update
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#
#        ${network_id}               PCC.Get Network Manager Id
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${response}                 PCC.Network Manager Update
#                               ...  id=${network_id}
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               ...  nodes=["${SERVER_2_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
#                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
#                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify BE
#                               ...  nodes_ip=["${SERVER_2_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
###################################################################################################################################
Network Manager Update (Interfaces For Server Partially Falling In DataCIDR) (Add Node)
###################################################################################################################################
    [Documentation]                 *Network Manager Update (Interfaces For Server Partially Falling In DataCIDR)*
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
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}","${SERVER_3_NAME}"]
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Network Manager Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}"]
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Network Manager Try To Remove 2 Invaders (Negative)
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
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}"]
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Fetching Network Manager ID before backup
###################################################################################################################################
        ${network_id_before_backup}    PCC.Get Network Manager Id
                                       ...  name=${NETWORK_MANAGER_NAME}
                                       Log To Console    ${network_id_before_backup}
                                       Set Global Variable    ${network_id_before_backup}





############# Commenting code for pcc 212 nodes network manager #######################
##
####################################################################################################################################
#Ceph Cluster Creation without Network Manager (Negative)
####################################################################################################################################
#    [Documentation]                 *Creating Ceph Cluster*
#                               ...  keywords:
#                               ...  PCC.Ceph Create Cluster
#
#        ${network_id}               PCC.Get Network Manager Id
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Pass Execution If    ${network_id} is not ${None}    Network is already there
#
#        ${id}                       PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Pass Execution If    ${id} is not ${None}    Ceph Cluster is already there
#
#        ${response}                 PCC.Ceph Create Cluster
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  nodes=${CEPH_CLUSTER_NODES}
#                               ...  tags=${CEPH_CLUSTER_TAGS}
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
####################################################################################################################################
#Network Manager Creation with same ControlCIDR and DataCIDR
####################################################################################################################################
#    [Documentation]                 *Network Manager Creation with same ControlCIDR and DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Network Manager Create
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#        ${response}                 PCC.Network Manager Create
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
#                               ...  controlCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Network Manager Delete and Verify PCC (Network Manager with same ControlCIDR and DataCIDR)
####################################################################################################################################
#    [Documentation]                 *Network Manager Verification PCC*
#                               ...  keywords:
#                               ...  PCC.Network Manager Delete
#                               ...  PCC.Wait Until Network Manager Ready
#
#        ${response}                 PCC.Network Manager Delete
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Deleted
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Not Be Equal As Strings      ${status}  OK
#
####################################################################################################################################
#Set Interfaces For Server Falling in DataCIDR
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For Server Falling in DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=["192.168.150.10/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=["192.168.150.10/31"]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=["192.168.150.12/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=["192.168.150.12/31"]
#                                    Should Be Equal As Strings      ${status}    OK
#
##################################################################################################################################
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=["192.168.150.9/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=["192.168.150.9/31"]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=["192.168.150.11/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=["192.168.150.11/31"]
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Network Manager Creation (Interfaces For Server Falling in DataCIDR)
####################################################################################################################################
#    [Documentation]                 *Network Manager Creation*
#                               ...  keywords:
#                               ...  PCC.Network Manager Create
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#                                    Sleep    60s
#
########## Uncommenting 212 nodes ########
#*** Settings ***
#Resource    pcc_resources.robot
#
#*** Variables ***
#${pcc_setup}                 pcc_212
#
#*** Test Cases ***
####################################################################################################################################
#Login
####################################################################################################################################
#
#                                    Load Ipam Data    ${pcc_setup}
#                                    Load K8s Data    ${pcc_setup}
#                                    Load Ceph Cluster Data    ${pcc_setup}
#                                    Load Network Manager Data    ${pcc_setup}
#                                    Load Clusterhead 1 Test Data    ${pcc_setup}
#                                    Load Clusterhead 2 Test Data    ${pcc_setup}
#                                    Load Server 1 Test Data    ${pcc_setup}
#                                    Load Server 2 Test Data    ${pcc_setup}
#                                    Load Server 3 Test Data    ${pcc_setup}
#
#        ${status}                   Login To PCC        testdata_key=${pcc_setup}
#                                    Should Be Equal     ${status}  OK
#
####################################################################################################################################
##Create Kubernetes cluster without Network Manager (Negative)
#####################################################################################################################################
##        [Documentation]             *Create Kubernetes cluster*
##                               ...  Keywords:
##                               ...  PCC.K8s Create Cluster
##
##        ${network_id}               PCC.Get Network Manager Id
##                               ...  name=${NETWORK_MANAGER_NAME}
##                                    Pass Execution If    ${network_id} is not ${None}    Network is already there
##
##        ${cluster_id}               PCC.K8s Get Cluster Id
##                               ...  name=${K8s_NAME}
##                                    Pass Execution If    ${cluster_id} is not ${None}    Cluster is already there
##
##        ${response}                 PCC.K8s Create Cluster
##                               ...  id=${K8S_ID}
##                               ...  k8sVersion=${K8S_VERSION}
##                               ...  name=${K8S_NAME}
##                               ...  cniPlugin=${K8S_CNIPLUGIN}
##                               ...  nodes=${K8S_NODES}
##                               ...  pools=${K8S_POOL}
##                               ...  networkClusterName=${NETWORK_MANAGER_NAME}
##
##        ${status_code}              Get Response Status Code        ${response}
##                                    Should Not Be Equal As Strings      ${status_code}  200
#        ${response}                 PCC.Network Manager Create
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               ...  nodes=${NETWORK_MANAGER_NODES}
#                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
#                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Interface Verification For Server Falling In DataCIDR
####################################################################################################################################
#    [Documentation]                 *Interface Verification For Server Falling In DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Interface Verify PCC
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=["192.168.150.10/31"]
#                                    Should Not Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=["192.168.150.12/31"]
#                                    Should Not Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Network Manager Update (Interfaces For Server Falling in DataCIDR)
####################################################################################################################################
#    [Documentation]                 *Network Manager Update*
#                               ...  keywords:
#                               ...  PCC.Get Network Manager Id
#                               ...  PCC.Network Manager Update
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#        ${network_id}               PCC.Get Network Manager Id
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${response}                 PCC.Network Manager Update
#                               ...  id=${network_id}
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
#                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
#                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Network Manager Refresh (Interfaces For Server Falling in DataCIDR)
####################################################################################################################################
#    [Documentation]                 *Network Manager Refresh Interfaces For Server Falling in DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Network Manager Refresh
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#
#        ${response}                 PCC.Network Manager Refresh
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Network Manager Delete (Interfaces For Server Falling in DataCIDR)
####################################################################################################################################
#    [Documentation]                 *Network Manager Delete Interfaces For Server Falling in DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Network Manager Delete
#                               ...  PCC.Wait Until Network Manager Deleted
#        ${response}                 PCC.Network Manager Delete
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Deleted
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Not Be Equal As Strings      ${status}  OK
#
####################################################################################################################################
#Set Interfaces For Server Not Falling In DataCIDR
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For Server Not Falling In DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=["192.168.72.10/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=["192.168.72.10/31"]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=["192.168.72.12/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=["192.168.72.12/31"]
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=["192.168.72.9/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=["192.168.72.9/31"]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=["192.168.72.11/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=["192.168.72.11/31"]
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Network Manager Creation (Interfaces For Server Not Falling In DataCIDR)
####################################################################################################################################
#    [Documentation]                 *Network Manager Creation Interfaces For Server Not Falling In DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Network Manager Create
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#                                    Sleep    60s
#        ${response}                 PCC.Network Manager Create
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               ...  nodes=${NETWORK_MANAGER_NODES}
#                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
#                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Interface Verification For Server Not Falling In DataCIDR
####################################################################################################################################
#    [Documentation]                 *Interface Verification Interfaces For Server Not Falling In DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Interface Verify PCC
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=["192.168.72.10/31"]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=["192.168.72.12/31"]
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Network Manager Update (Interfaces For Server Not Falling In DataCIDR)
####################################################################################################################################
#    [Documentation]                 *Network Manager Update Interfaces For Server Not Falling In DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Get Network Manager Id
#                               ...  PCC.Network Manager Update
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#        ${network_id}               PCC.Get Network Manager Id
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${response}                 PCC.Network Manager Update
#                               ...  id=${network_id}
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
#                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
#                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Network Manager Refresh (Interfaces For Server Not Falling In DataCIDR)
####################################################################################################################################
#    [Documentation]                 *Network Manager Refresh Interfaces For Server Not Falling In DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Network Manager Refresh
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#
#        ${response}                 PCC.Network Manager Refresh
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Network Manager Delete (Interfaces For Server Not Falling In DataCIDR)
####################################################################################################################################
#    [Documentation]                 *Network Manager Delete Interfaces For Server Not Falling In DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Network Manager Delete
#                               ...  PCC.Wait Until Network Manager Deleted
#        ${response}                 PCC.Network Manager Delete
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Deleted
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Not Be Equal As Strings      ${status}  OK
#
####################################################################################################################################
#Set Interfaces For Server Partially Falling In DataCIDR
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For Server Partially Falling In DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=["192.168.72.10/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=["192.168.72.10/31"]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=["192.168.150.12/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=["192.168.150.12/31"]
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=["192.168.72.9/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=["192.168.72.9/31"]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=["192.168.150.11/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=["192.168.150.11/31"]
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Network Manager Creation (Interfaces For Server Partially Falling In DataCIDR)
####################################################################################################################################
#    [Documentation]                 *Network Manager Creation (Interfaces For Server Partially Falling In DataCIDR)*
#                               ...  keywords:
#                               ...  PCC.Network Manager Create
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#        ${response}                 PCC.Network Manager Create
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
#                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
#                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Interface Verification For Server Partially Falling in DataCIDR
####################################################################################################################################
#    [Documentation]                 *Interface Verification For Server Partially Falling in DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Interface Verify PCC
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=["192.168.72.10/31"]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=["192.168.150.12/31"]
#                                    Should Not Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Network Manager Refresh (Interfaces For Server Partially Falling In DataCIDR)
####################################################################################################################################
#    [Documentation]                 *Network Manager Refresh (Interfaces For Server Partially Falling In DataCIDR)*
#                               ...  keywords:
#                               ...  PCC.Network Manager Refresh
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#
#        ${response}                 PCC.Network Manager Refresh
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#         ${status}                  PCC.Network Manager Verify BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
#
#         ${status}                  PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#
####################################################################################################################################
##Network Manager Update (Interfaces For Server Partially Falling In DataCIDR) (Add and Remove node simultaneously)
#####################################################################################################################################
##    [Documentation]                 *Network Manager Update (Interfaces For Server Partially Falling In DataCIDR)*
##                               ...  keywords:
##                               ...  PCC.Get Network Manager Id
##                               ...  PCC.Network Manager Update
##                               ...  PCC.Wait Until Network Manager Ready
##                               ...  PCC.Network Manager Verify BE
##
##        ${network_id}               PCC.Get Network Manager Id
##                               ...  name=${NETWORK_MANAGER_NAME}
##
##        ${response}                 PCC.Network Manager Update
##                               ...  id=${network_id}
##                               ...  name=${NETWORK_MANAGER_NAME}
##                               ...  nodes=["${SERVER_2_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
##                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
##                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
##                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
##
##        ${status_code}              Get Response Status Code        ${response}
##                                    Should Be Equal As Strings      ${status_code}  200
##
##        ${status}                   PCC.Wait Until Network Manager Ready
##                               ...  name=${NETWORK_MANAGER_NAME}
##                                    Should Be Equal As Strings      ${status}    OK
##
##        ${status}                   PCC.Network Manager Verify BE
##                               ...  nodes_ip=["${SERVER_2_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
##                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
##                                    Should Be Equal As Strings      ${status}  OK
##
##        ${status}                   PCC.Health Check Network Manager
##                               ...  name=${NETWORK_MANAGER_NAME}
##                                    Should Be Equal As Strings      ${status}    OK
##
####################################################################################################################################
#Network Manager Update (Interfaces For Server Partially Falling In DataCIDR) (Add Node)
####################################################################################################################################
#    [Documentation]                 *Network Manager Update (Interfaces For Server Partially Falling In DataCIDR)*
#                               ...  keywords:
#                               ...  PCC.Get Network Manager Id
#                               ...  PCC.Network Manager Update
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#        ${network_id}               PCC.Get Network Manager Id
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${response}                 PCC.Network Manager Update
#                               ...  id=${network_id}
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}","${SERVER_3_NAME}"]
#                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
#                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Network Manager Try To Remove 2 Invaders (Negative)
####################################################################################################################################
#    [Documentation]                 *Network Manager Update*
#                               ...  keywords:
#                               ...  PCC.Network Manager Update
#                               ...  PCC.Wait Until Network Manager Ready
#
#        ${network_id}               PCC.Get Network Manager Id
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${response}                 PCC.Network Manager Update
#                               ...  id=${network_id}
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}"]
#                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
#                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
####################################################################################################################################
#Fetching Network Manager ID before backup
####################################################################################################################################
#        ${network_id_before_backup}    PCC.Get Network Manager Id
#                                       ...  name=${NETWORK_MANAGER_NAME}
#                                       Log To Console    ${network_id_before_backup}
#                                       Set Global Variable    ${network_id_before_backup}
#
