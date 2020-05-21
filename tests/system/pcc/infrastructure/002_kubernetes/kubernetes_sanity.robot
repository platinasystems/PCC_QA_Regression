*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load K8s Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Create Kubernetes cluster
###################################################################################################################################
        [Documentation]             *Create Kubernetes cluster*
                               ...  Keywords:
                               ...  PCC.K8s Create Cluster

        ${response}                 PCC.K8s Create Cluster
                               ...  id=${K8S_ID}
                               ...  k8sVersion=${K8S_VERSION}
                               ...  name=${K8S_NAME}
                               ...  cniPlugin=${K8S_CNIPLUGIN}
                               ...  nodes=${K8S_NODES}
                               ...  pools=${K8S_POOL}

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
#Add Node to Kubernetes cluster
###################################################################################################################################
#        [Documentation]             *Add Node to Kubernetes cluster*
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
#                              ...  toAdd=["i-42"]
#                              ...  rolePolicy=auto
#
#       ${status_code}              Get Response Status Code        ${response}
#                                   Should Be Equal As Strings      ${status_code}  200
#
#       ${status}                   PCC.K8s Wait Until Cluster is Ready
#                              ...  name=${K8S_NAME}
#                                   Should Be Equal As Strings      ${status}    OK
#
###################################################################################################################################
#Remove Node to Kubernetes cluster
####################################################################################################################################
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
#                               ...  toRemove=["i-42"]
#                               ...  rolePolicy=auto
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.K8s Wait Until Cluster is Ready
#                               ...  name=${K8S_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
###################################################################################################################################
Upgrade K8 Cluster Version
###################################################################################################################################     
        [Documentation]             *Upgrade K8 Cluster Version* 
                               ...  Keywords:
                               ...  PCC.K8s Upgrade Cluster
                               ...  PCC.K8s Get Cluster Id
                               ...  PCC.K8s Wait Until Cluster is Ready
        
        ${cluster_id}               PCC.K8s Get Cluster Id
                               ...  name=${K8S_NAME}

        ${response}                 PCC.K8s Upgrade Cluster
                               ...  cluster_id=${cluster_id}
                               ...  k8sVersion=v1.13.5
                               ...  pools=${K8S_POOL}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.K8s Wait Until Cluster is Ready
                               ...  name=${K8S_NAME}
                                    Should Be Equal As Strings      ${status}    OK

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
