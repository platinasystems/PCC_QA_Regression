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
Create Kubernetes cluster without Network Manager (Negative)
###################################################################################################################################
        [Documentation]             *Create Kubernetes cluster*
                               ...  Keywords:
                               ...  PCC.K8s Create Cluster
                               
        ${network_id}               PCC.Get Network Manager Id
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Pass Execution If    ${network_id} is not ${None}    Network is already there

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
                                    Should Not Be Equal As Strings      ${status_code}  200

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
Network Manager Creation
###################################################################################################################################
    [Documentation]                 *Network Manager Creation*
                               ...  keywords:
                               ...  PCC.Network Manager Create
                               
        ${network_id}               PCC.Get Network Manager Id
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Pass Execution If    ${network_id} is not ${None}    Network is already there

        ${response}                 PCC.Network Manager Create
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=${NETWORK_MANAGER_NODES}
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create Kubernetes cluster with nodes which are not part of Network Manager (Negative)
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
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  pools=${K8S_POOL}
                               ...  networkClusterName=${NETWORK_MANAGER_NAME}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Cluster Creation with nodes which are not part of Network Manager (Negative)
###################################################################################################################################
    [Documentation]                 *Creating Ceph Cluster*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               
        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Pass Execution If    ${id} is not ${None}    Ceph Cluster is already there
                                    
        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
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
Delete Network Manager When Ceph And K8s Are Present (Negative)
###################################################################################################################################
    [Documentation]                 *Network Manager Verification PCC*
                               ...  keywords:
                               ...  PCC.Network Manager Delete

        ${response}                 PCC.Network Manager Delete
                               ...  name=${NETWORK_MANAGER_NAME}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
##################################################################################################################################
#Reboot Node And Verify K8s Is Intact
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
#                                    
###################################################################################################################################
#Reboot Node And Verify Ceph Is Intact
###################################################################################################################################
#    [Documentation]                 *Verifying Ceph cluster BE*
#                               ...  keywords:
#                               ...  Ceph Verify BE
#                               ...  Restart node
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
#                                    
####################################################################################################################################
#Down And Up The Interface And Check For Ceph
####################################################################################################################################
#        [Documentation]             *Down And Up The Interface And Check For Ceph*
#                               ...  Keywords:
#                               ...  PCC.Set Interface Down
#                               ...  PCC.Set Interface Up
#                               ...  PCC.Ceph Verify BE
#                               
#        ${status}                   PCC.Set Interface Down
#                               ...  host_ip=${SERVER_1_HOST_IP}
#                               ...  interface_name="enp130s0"
#                                    Should Be Equal As Strings      ${status}  OK
#
#        ${status}                   PCC.Set Interface Up
#                               ...  host_ip=${SERVER_1_HOST_IP}
#                               ...  interface_name="enp130s0"
#                                    Should Be Equal As Strings      ${status}  OK
#                                    
#        ${status}                   PCC.Ceph Verify BE
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
#
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Down And Up The Interface And Check For K8s
####################################################################################################################################
#        [Documentation]             *Down And Up The Interface And Check For Ceph*
#                               ...  Keywords:
#                               ...  PCC.Set Interface Down
#                               ...  PCC.Set Interface Up
#                               ...  PCC.Ceph Verify BE
#                               
#        ${status}                   PCC.Set Interface Down
#                               ...  host_ip=${SERVER_1_HOST_IP}
#                               ...  interface_name="enp130s0"
#                                    Should Be Equal As Strings      ${status}  OK
#
#        ${status}                   PCC.Set Interface Up
#                               ...  host_ip=${SERVER_1_HOST_IP}
#                               ...  interface_name="enp130s0"
#                                    Should Be Equal As Strings      ${status}  OK
#                                    
#        ${status}                   PCC.K8s Verify BE
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}"]
#
#                                    Should Be Equal As Strings      ${status}    OK
###################################################################################################################################
Network Manager Add Node For Ceph And K8s Update
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
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}

                                    Should Be Equal As Strings      ${status}    OK 

###################################################################################################################################
Add Node to Ceph Cluster
###################################################################################################################################
    [Documentation]                 *Ceph Cluster Update - Add Invade*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready

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

###################################################################################################################################
Add Node to Kubernetes Cluster
###################################################################################################################################
       [Documentation]             *Add Node to Kubernetes cluster*
                               ...  Keywords:
                              ...  PCC.K8s Update Cluster Nodes
                              ...  PCC.K8s Get Cluster Id
                              ...  PCC.K8s Wait Until Cluster is Ready  
                              
       ${cluster_id}               PCC.K8s Get Cluster Id
                              ...  name=${K8S_NAME}

       ${response}                 PCC.K8s Update Cluster Nodes
                              ...  cluster_id=${cluster_id}
                              ...  name=${K8S_NAME}
                              ...  toAdd=["${CLUSTERHEAD_2_NAME}"]
                              ...  rolePolicy=auto

       ${status_code}              Get Response Status Code        ${response}
                                   Should Be Equal As Strings      ${status_code}  200

       ${status}                   PCC.K8s Wait Until Cluster is Ready
                              ...  name=${K8S_NAME}
                                   Should Be Equal As Strings      ${status}    OK        

###################################################################################################################################
Remove Node From Network Manager Which Are Part Of Ceph and K8s (Negative)
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
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
#Remove Node From Ceph Cluster
####################################################################################################################################
#    [Documentation]                 *Ceph Cluster Update - Add Invade*
#                               ...  keyword:
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Cluster Update
#                               ...  PCC.Ceph Wait Until Cluster Ready
#
#        ${id}                       PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME}
#
#        ${response}                 PCC.Ceph Cluster Update
#                               ...  id=${id}
#                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}","${CLUSTERHEAD_1_NAME}"]
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Remove Node From Kubernetes Cluster
####################################################################################################################################
#       [Documentation]             *Add Node to Kubernetes cluster*
#                               ...  Keywords:
#                              ...  PCC.K8s Update Cluster Nodes
#                              ...  PCC.K8s Get Cluster Id
#                              ...  PCC.K8s Wait Until Cluster is Ready    
#                              
#       ${cluster_id}               PCC.K8s Get Cluster Id
#                              ...  name=${K8S_NAME}
#
#       ${response}                 PCC.K8s Update Cluster Nodes
#                              ...  cluster_id=${cluster_id}
#                              ...  name=${K8S_NAME}
#                              ...  toAdd=["${CLUSTERHEAD_2_NAME}"]
#                              ...  rolePolicy=auto
#
#       ${status_code}              Get Response Status Code        ${response}
#                                   Should Be Equal As Strings      ${status_code}  200
#
#       ${status}                   PCC.K8s Wait Until Cluster is Ready
#                              ...  name=${K8S_NAME}
#                                   Should Be Equal As Strings      ${status}    OK   
#
####################################################################################################################################
#Ceph Cluster Delete
####################################################################################################################################
#    [Documentation]                 *Delete cluster if it exist*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Delete Cluster
#                               ...  PCC.Ceph Wait Until Cluster Deleted
#                               ...  PCC.Ceph Cleanup BE
#
#        ${id}                       PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Pass Execution If    ${id} is ${None}    Cluster is alredy Deleted
#
#        ${response}                 PCC.Ceph Delete Cluster
#                               ...  id=${id}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Cluster Deleted
#                               ...  id=${id}
#                                    Should Be Equal As Strings     ${status}  OK
#                                    
#        ${response}                 PCC.Ceph Cleanup BE
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}    
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#
####################################################################################################################################
#Delete K8 Cluster
####################################################################################################################################     
#        [Documentation]             *Delete K8 Cluster*  
#                               ...  Keywords:
#                               ...  PCC.K8s Upgrade Cluster
#                               ...  PCC.K8s Delete Cluster
#                               ...  PCC.K8s Wait Until Cluster Deleted
#                               
#        ${cluster_id}               PCC.K8s Get Cluster Id
#                               ...  name=${K8s_NAME}
#                                    Pass Execution If    ${cluster_id} is ${None}    Cluster is alredy Deleted
#
#        ${response}                 PCC.K8s Delete Cluster
#                               ...  cluster_id=${cluster_id}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.K8s Wait Until Cluster Deleted
#                               ...  cluster_id=${cluster_id}
#                                    Should Be Equal As Strings    ${status}  OK                  
#
###################################################################################################################################
#Try To Create Ceph Cluster Once Again 
####################################################################################################################################
#    [Documentation]                 *Creating Ceph Cluster*
#                               ...  keywords:
#                               ...  PCC.Ceph Create Cluster
#                               ...  PCC.Ceph Wait Until Cluster Ready
#                               
#        ${response}                 PCC.Ceph Create Cluster
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  nodes=${CEPH_CLUSTER_NODES}
#                               ...  tags=${CEPH_CLUSTER_TAGS}
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_CLUSTER_NAME}
#
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
####################################################################################################################################
#Try To Create K8s Cluster Once Again 
####################################################################################################################################
#        [Documentation]             *Create Kubernetes cluster*
#                               ...  Keywords:
#                               ...  PCC.K8s Create Cluster
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
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.K8s Wait Until Cluster is Ready
#                               ...  name=${K8S_NAME}
#                                    Should Be Equal As Strings      ${status}    OK    
#  
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
                                    
###################################################################################################################################
Network Manager Delete and Verify PCC
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
