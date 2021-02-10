*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load K8s Data    ${pcc_setup}
                                    Load Network Manager Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    
        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK
                                                                                                    
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

###################################################################################################################################
Kubernetes Cluster Verification PCC
###################################################################################################################################
        [Documentation]             *Kubernetes Cluster Verification PCC*
                               ...  Keywords:
                               ...  PCC.K8s Wait Until Cluster is Ready
        
        ${status}                   PCC.K8s Wait Until Cluster is Ready
                               ...  name=${K8S_NAME}
                                    Should Be Equal As Strings      ${status}    OK

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
Add App To K8 Cluster
###################################################################################################################################
        [Documentation]             *Add App Kubernetes cluster*
                               ...  Keywords:
                               ...  PCC.K8s Get Cluster Id
                               ...  PCC.K8s Add App 
                               ...  PCC.K8s Wait Until Cluster is Ready

        ${cluster_id}               PCC.K8s Get Cluster Id
                               ...  name=${K8S_NAME}
                                    
        ${response}                 PCC.K8s Add App                    
                               ...  cluster_id=${cluster_id}
                               ...  appName=${K8S_APPNAME}
                               ...  appNamespace=${K8S_APPNAMESPACE}
                               ...  gitUrl=${K8S_GITURL}
                               ...  gitRepoPath=${K8S_GITREPOPATH}
                               ...  gitBranch=${K8S_GITBRANCH}
                               ...  label=${K8S_LABEL}
                               
        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                
        ${status}                   PCC.K8s Wait Until Cluster is Ready
                               ...  name=${K8S_NAME}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete App To K8 Cluster
###################################################################################################################################
        [Documentation]             *Delete App Kubernetes cluster*
                               ...  Keywords:
                               ...  PCC.K8s Get Cluster Id
                               ...  PCC.K8s Delete App 
                               ...  PCC.K8s Wait Until Cluster is Ready

        ${cluster_id}               PCC.K8s Get Cluster Id
                               ...  name=${K8S_NAME}
   
        ${app_id}                   PCC.K8s Get App Id
                               ...  appName=${K8S_APPNAME}
                                    
        ${response}                 PCC.K8s Delete App
                               ...  cluster_id=${cluster_id}
                               ...  appIds=${app_id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.K8s Wait Until Cluster is Ready
                               ...  name=${K8S_NAME}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Add Node to Kubernetes cluster
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

##################################################################################################################################
Reboot Node And Verify K8s Is Intact
##################################################################################################################################
    [Documentation]                 *Verifying K8s cluster BE*
                               ...  keywords:
                               ...  PCC.K8s Verify BE
                               ...  Restart node
                               
    ${restart_status}               Restart node
                               ...  hostip=${CLUSTERHEAD_1_HOST_IP}
                               ...  time_to_wait=240
                                    Log to console    ${restart_status}
                                    Should Be Equal As Strings    ${restart_status}    OK

        ${status}                   PCC.K8s Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Down And Up The Interface And Check For K8s
###################################################################################################################################
        [Documentation]             *Down And Up The Interface And Check For Ceph*
                               ...  Keywords:
                               ...  PCC.Set Interface Down
                               ...  PCC.Set Interface Up
                               ...  PCC.Ceph Verify BE
                               
        ${status}                   PCC.Set Interface Down
                               ...  host_ip=${SERVER_1_HOST_IP}
                               ...  interface_name="enp129s0"
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Set Interface Up
                               ...  host_ip=${SERVER_1_HOST_IP}
                               ...  interface_name="enp129s0"
                                    Should Be Equal As Strings      ${status}  OK
                                    
        ${status}                   PCC.K8s Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]

                                    Should Be Equal As Strings      ${status}    OK    
                                    
##################################################################################################################################
#Remove Node to Kubernetes cluster
####################################################################################################################################
#
#        [Documentation]             *Remove Node to Kubernetes cluster*
#                               ...  Keywords:
#                               ...  PCC.K8s Update Cluster Nodes
#                               ...  PCC.K8s Get Cluster Id
#                               ...  PCC.K8s Wait Until Cluster is Ready
#
#        ${cluster_id}               PCC.K8s Get Cluster Id
#                               ...  name=${K8S_NAME}
#
#        ${response}                 PCC.K8s Update Cluster Nodes
#                               ...  cluster_id=${cluster_id}
#                               ...  name=${K8S_NAME}
#                               ...  toRemove=["${CLUSTERHEAD_2_NAME}"]
#                               ...  rolePolicy=auto
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.K8s Wait Until Cluster is Ready
#                               ...  name=${K8S_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
##################################################################################################################################
#Upgrade K8 Cluster Version
####################################################################################################################################     
#        [Documentation]             *Upgrade K8 Cluster Version* 
#                               ...  Keywords:
#                               ...  PCC.K8s Upgrade Cluster
#                               ...  PCC.K8s Get Cluster Id
#                               ...  PCC.K8s Wait Until Cluster is Ready
#        
#        ${cluster_id}               PCC.K8s Get Cluster Id
#                               ...  name=${K8S_NAME}
#
#        ${response}                 PCC.K8s Upgrade Cluster
#                               ...  cluster_id=${cluster_id}
#                               ...  k8sVersion=v1.13.5
#                               ...  pools=${K8S_POOL}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.K8s Wait Until Cluster is Ready
#                               ...  name=${K8S_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
 
   
###################################################################################################################################
Fetching K8s ID before backup
###################################################################################################################################   

         ${K8s_cluster_id_before_backup}        PCC.K8s Get Cluster Id
                                                ...  name=${K8S_NAME}                            
                                                Log To Console    ${K8s_cluster_id_before_backup}
                                                Set Global Variable    ${K8s_cluster_id_before_backup}      
