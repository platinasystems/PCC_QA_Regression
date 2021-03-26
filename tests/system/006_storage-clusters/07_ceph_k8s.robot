*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Ceph Rbd Data    ${pcc_setup}
                                    Load Ceph Pool Data    ${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Ceph Fs Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    Load K8s Data    ${pcc_setup}
                                    Load Network Manager Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK
                                    
###################################################################################################################################
#Add 30 pools to Kubernetes Cluster which are part of Fs with 30 data pools
####################################################################################################################################      
#        [Documentation]             *Add 30 pools to Kubernetes Cluster which are part of Fs with 30 data pools*
#                               ...  Keywords:
#                               ...  PCC.K8s Create Cluster
#                               ...  PCC.K8s Wait Until Cluster is Ready
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Create Pool Multiple
#                               ...  PCC.Ceph Wait Until Pool Ready
#                               ...  PCC.Ceph Create Fs
#                               ...  PCC.Ceph Wait Until Fs Ready
#                               ...  PCC.K8s Upgrade Cluster
#                               
#
#        ${response}                 PCC.K8s Create Cluster
#                               ...  id=${K8S_ID}
#                               ...  k8sVersion=${K8S_VERSION}
#                               ...  name=${K8S_NAME}
#                               ...  cniPlugin=${K8S_CNIPLUGIN}
#                               ...  nodes=${K8S_NODES}
#                               ...  pools=${K8S_POOL}
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#        
#        ${status}                   PCC.K8s Wait Until Cluster is Ready
#                               ...  name=${K8S_NAME}
#
#                                    Should Be Equal As Strings      ${status}    OK
#
#                                    
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${response}                 PCC.Ceph Create Pool Multiple
#                               ...  count=32
#                               ...  name=k8s
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=1
#                               ...  quota_unit=MiB
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=k8s-32
#
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${meta}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=k8s-32
#                               
#        ${data}                     PCC.Ceph Get Multiple Pool Details For FS
#                               ...  name=['k8s-1','k8s-2','k8s-3','k8s-4','k8s-5','k8s-6','k8s-7','k8s-8','k8s-9','k8s-10','k8s-11','k8s-12','k8s-13','k8s-14','k8s-15','k8s-16','k8s-17','k8s-18','k8s-19','k8s-20','k8s-21','k8s-22','k8s-23','k8s-24','k8s-25','k8s-26','k8s-27','k8s-28','k8s-29','k8s-30']                             
#        ${default}                  PCC.Ceph Get Pool Details For FS
#                               ...  name=k8s-31
#
#        ${response}                 PCC.Ceph Create Fs
#                               ...  name=${CEPH_FS_NAME}
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  metadata_pool=${meta}
#                               ...  data_pool=${data}
#                               ...  default_pool=${default}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    
#        
#        ${cluster_id}               PCC.K8s Get Cluster Id
#                               ...  name=${K8S_NAME}
#
#        ${response}                 PCC.K8s Upgrade Cluster
#                               ...  cluster_id=${cluster_id}
#                               ...  k8sVersion=${K8S_VERSION}
#                               ...  pools=[ 'k8s-1', 'k8s-2', 'k8s-3', 'k8s-4', 'k8s-5', 'k8s-6', 'k8s-7', 'k8s-8', 'k8s-9', 'k8s-10','k8s-11', 'k8s-12', 'k8s-13', 'k8s-14', 'k8s-15', 'k8s-16', 'k8s-17', 'k8s-18', 'k8s-19', 'k8s-20','k8s-21', 'k8s-22', 'k8s-23', 'k8s-24', 'k8s-25', 'k8s-26', 'k8s-27', 'k8s-28', 'k8s-29', 'k8s-30']
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep  240s
#        ${status}                   PCC.K8s Wait Until Cluster is Ready
#                               ...  name=${K8S_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#
####################################################################################################################################
#Add 15 pools to Kubernetes Cluster which are part of Fs with 30 data pools
####################################################################################################################################      
#        [Documentation]             *Add 15 pools to Kubernetes Cluster which are part of Fs with 30 data pools*
#                               ...  Keywords:
#                               ...  PCC.K8s Upgrade Cluster
#                               ...  PCC.K8s Wait Until Cluster is Ready
#                               ...  PCC.K8s Get Cluster Id
#                                   
#        
#        ${cluster_id}               PCC.K8s Get Cluster Id
#                               ...  name=${K8S_NAME}
#
#        ${response}                 PCC.K8s Upgrade Cluster
#                               ...  cluster_id=${cluster_id}
#                               ...  k8sVersion=${K8S_VERSION}
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
#                               ...  pools=[ 'k8s-1', 'k8s-2', 'k8s-3', 'k8s-4', 'k8s-5', 'k8s-6', 'k8s-7', 'k8s-8', 'k8s-9', 'k8s-10','k8s-11', 'k8s-12', 'k8s-13', 'k8s-14', 'k8s-15']
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep  240s
#        ${status}                   PCC.K8s Wait Until Cluster is Ready
#                               ...  name=${K8S_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Remove pools from Kubernetes Cluster
####################################################################################################################################
#        [Documentation]             *Remove pools from Kubernetes Cluster*
#                               ...  Keywords:
#                               ...  PCC.K8s Upgrade Cluster
#                               ...  PCC.K8s Wait Until Cluster is Ready
#                               ...  PCC.K8s Get Cluster Id
#
#        ${cluster_id}               PCC.K8s Get Cluster Id
#                               ...  name=${K8S_NAME}
#
#        ${response}                 PCC.K8s Upgrade Cluster
#                               ...  cluster_id=${cluster_id}
#                               ...  k8sVersion=${K8S_VERSION}
#                               ...  pools=[]
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep  240s
#        ${status}                   PCC.K8s Wait Until Cluster is Ready
#                               ...  name=${K8S_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
