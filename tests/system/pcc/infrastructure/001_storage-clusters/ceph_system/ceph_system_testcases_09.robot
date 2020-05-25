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

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Update CephFS - add_metadata_pool (Negative)
###################################################################################################################################
    [Documentation]                 *Update CephFS - add_metadata_pool*
                               ...  keywords:
                               ...  PCC.Ceph Get Fs Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Update Fs
                               ...  PCC.Ceph Wait Until Fs Ready

        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${meta1}                    PCC.Ceph Get Pool Details For FS
                               ...  name=pool8

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}


        ${response}                 PCC.Ceph Update Fs
                               ...  id=${id}
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=[${meta},${meta1}]
                               ...  data_pool=${data}
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Update CephFS - remove_default_pool (Negative)
###################################################################################################################################
    [Documentation]                 *Update CephFS - remove_default_pool*
                               ...  keywords:
                               ...  PCC.Ceph Get Fs Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Update Fs
                               ...  PCC.Ceph Wait Until Fs Ready

        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${response}                 PCC.Ceph Update Fs
                               ...  id=${id}
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=${data}
                               ...  default_pool=

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Update CephFS - remove_data_pools 
###################################################################################################################################
    [Documentation]                 *Update CephFS - remove_default_pool*
                               ...  keywords:
                               ...  PCC.Ceph Get Fs Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Update Fs
                               ...  PCC.Ceph Wait Until Fs Ready

        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Update Fs
                               ...  id=${id}
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Fs Ready
                               ...  name=${CEPH_FS_NAME}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Update CephFS - remove_data_pool_along_with_default_data_pool 
###################################################################################################################################
    [Documentation]                 *Update CephFS - remove_data_pool_along_with_default_data_pool*
                               ...  keywords:
                               ...  PCC.Ceph Get Fs Id
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Get Pool Details For FS
                               ...  PCC.Ceph Update Fs
                               ...  PCC.Ceph Wait Until Fs Ready

        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_META}

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DATA}

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=${CEPH_FS_DEFAULT}

        ${response}                 PCC.Ceph Update Fs
                               ...  id=${id}
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=
                               ...  default_pool=

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Ceph Cluster Delete when Ceph FS is present (Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster Delete when Ceph FS is present*
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
                                    Should Not Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Ceph Fs Delete
###################################################################################################################################
    [Documentation]                 *Delete Fs if it exist*   
                               ...  keywords:
                               ...  PCC.Ceph Get Fs Id
                               ...  PCC.Ceph Delete Fs
                               ...  PCC.Ceph Wait Until Fs Deleted

        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}
                                    Pass Execution If    ${id} is ${None}    Fs is alredy Deleted

        ${response}                 PCC.Ceph Delete Fs
                               ...  id=${id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Fs Deleted
                               ...  id=${id}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Pool released from RBD is used for creating/updating CephFS
###################################################################################################################################
    [Documentation]                 *Pool released from RBD is used for creating/updating CephFS*   
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool Multiple
                               ...  PCC.Ceph Wait Until Pool Ready
                               ...  PCC.Ceph Create Rbd
                               ...  PCC.Ceph Wait Until Rbd Ready
                               ...  PCC.Ceph Get Rbd Id
                               ...  PCC.Ceph Delete Rbd
                               ...  PCC.Ceph Wait Until Rbd Deleted
                               ...  PCC.Ceph Get Fs Id
                               ...  PCC.Ceph Wait Until Fs Ready
                               ...  PCC.Ceph Create Fs
                               ...  PCC.Ceph Wait Until Fs Ready

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool Multiple
                               ...  count=3
                               ...  name=fs
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=1
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=fs-3

                                    Should Be Equal As Strings      ${status}    OK


        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=fs-1

        ${response}                 PCC.Ceph Create Rbd
                               ...  name=fs-rbd
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=${CEPH_RBD_SIZE}
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=fs-rbd

                                    Should Be Equal As Strings      ${status}    OK

        ${id}                       PCC.Ceph Get Rbd Id
                               ...  name=fs-rbd
                                    Pass Execution If    ${id} is ${None}    Rbd is alredy Deleted

        ${response}                 PCC.Ceph Delete Rbd
                               ...  id=${id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rbd Deleted
                               ...  id=${id}
                                    Should Be Equal     ${status}  OK

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=fs-1

        ${data}                     PCC.Ceph Get Pool Details For FS
                               ...  name=fs-2

        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=fs-3
        ${response}                 PCC.Ceph Create Fs
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=${data}
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Fs Ready
                               ...  name=${CEPH_FS_NAME}

                                    Should Be Equal As Strings      ${status}    OK

        ${id}                       PCC.Ceph Get Fs Id
                               ...  name=${CEPH_FS_NAME}
                                    Pass Execution If    ${id} is ${None}    Fs is alredy Deleted

        ${response}                 PCC.Ceph Delete Fs
                               ...  id=${id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Fs Deleted
                               ...  id=${id}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Ceph Create 10 Pools
###################################################################################################################################
    [Documentation]                 *Ceph Create 20 Pools*  
                               ...  keywords:    
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool Multiple
                               ...  PCC.Ceph Wait Until Pool Ready

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool Multiple
                               ...  count=10
                               ...  name=xyz
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=1
                               ...  quota_unit=MiB

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=xyz-20

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Create 10 Rbd
###################################################################################################################################
    [Documentation]                 *Ceph Create 20 Rbd*  
                               ...  keywords:    
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd Multiple
                               ...  PCC.Ceph Wait Until Rbd Ready

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}                  PCC.Ceph Get Pool Id
                               ...  name=xyz-2

        ${response}                 PCC.Ceph Create Rbd Multiple
                               ...  count=10
                               ...  name=abc
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=1
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=${CEPH_RBD_SIZE_UNIT}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rbd Ready
                               ...  name=abc-20

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Rbd Delete
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Delete*
                               ...  keywords:
                               ...  PCC.Ceph Get Rbd Id
                               ...  PCC.Ceph Delete Rbd
                               ...  PCC.Ceph Wait Until Rbd Deleted

        ${id}                       PCC.Ceph Get Rbd Id
                               ...  name=${CEPH_RBD_NAME}
                                    Pass Execution If    ${id} is ${None}    Rbd is alredy Deleted

        ${response}                 PCC.Ceph Delete Rbd
                               ...  id=${id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rbd Deleted
                               ...  id=${id}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Ceph Rbd Delete Multiple
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Delete Multiple*
                               ...  keywords:
                               ...  PCC.Ceph Delete All Rbds


        ${status}                   PCC.Ceph Delete All Rbds
                                    Should Be Equal     ${status}  OK

                                    
###################################################################################################################################
Ceph Pool Single Delete
###################################################################################################################################
    [Documentation]                 *Deleting single pool*
                               ...  keywords:
                               ...  PCC.Ceph Get Pool Id
                               ...  PCC.Ceph Delete Pool
                               ...  PCC.Ceph Wait Until Pool Deleted


       ${id}                        PCC.Ceph Get Pool Id
                               ...  name=${CEPH_POOL_NAME}
                                    Pass Execution If    ${id} is ${None}    Pool is alredy Deleted

        ${response}                 PCC.Ceph Delete Pool
                               ...  id=${id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Deleted
                               ...  id=${id}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Ceph Pool Multiple Delete
###################################################################################################################################
    [Documentation]                 *Deleting all Pools*
                               ...  keywords:
                               ...  CC.Ceph Delete All Pools
                               
        ${status}                   PCC.Ceph Delete All Pools
                                    Should Be Equal     ${status}  OK
                                    
###################################################################################################################################
Ceph Cluster Update - Add Invader
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
                               ...  config=${CEPH_CLUSTER_CONFIG}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK
							   
###################################################################################################################################
TCP-1012 Update Cluster(2 Invader setup) - Remove - Remove TWO OSD nodes from cluster [4 nodes (3 MONs + 2 OSDs)] (Negative)
###################################################################################################################################
    [Documentation]                 *Update Cluster(2 Invader setup) - Remove - Remove TWO OSD nodes from cluster [4 nodes (3 MONs + 2 OSDs)]*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  nodes=["${CLUSTERHEAD_2_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  config=${CEPH_CLUSTER_CONFIG}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

####################################################################################################################################
#TCP-1016 Ceph Cluster Update - Remove Invader
####################################################################################################################################
#    [Documentation]                 *Ceph Cluster Update - Remove Invader*
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
#                               ...  nodes=[${SERVER_2_NAME},${SERVER_1_NAME},${CLUSTERHEAD_1_NAME}]
#                               ...  config=${CEPH_CLUSTER_CONFIG}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#							   
####################################################################################################################################
TCP-983 Ceph Cluster Update - Network - Public CIDR (Negative)
###################################################################################################################################
    [Documentation]                 *TCP-983 Ceph Cluster Update - Network - Public CIDR (Negative)*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  config={"cluster_network":"192.0.2.96/27","public_network":"192.0.2.964/27"}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
TCP-984 Ceph Cluster Update - Network - Cluster CIDR (Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster Update - Network - Cluster CIDR (Negative)*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  config={"cluster_network":"192.0.2.963/27","public_network":"192.0.2.96/27"}
							   

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
																		
###################################################################################################################################	
TCP-981 Update Cluster - Try to rename cluster Name (Negative)
###################################################################################################################################
    [Documentation]                 *Update Cluster - Try to rename cluster Name*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  config=${CEPH_CLUSTER_CONFIG}
							   

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
													
###################################################################################################################################	
#TCP-985 Update Cluster - Try to add Tags
####################################################################################################################################
#    [Documentation]                 *Update Cluster - Try to add Tags*
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
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
#                               ...  tags=["ROTATIONAL","SOLID_STATE","SATA/SAS"]
#                               ...  config=${CEPH_CLUSTER_CONFIG}
#							   
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#													
#	${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#							  
####################################################################################################################################	
TCP-985 Update Cluster - Try to remove Tags (Negative)
###################################################################################################################################
    [Documentation]                 *Update Cluster - Try to remove Tags*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  tags=["ROTATIONAL","SOLID_STATE"]
                               ...  config=${CEPH_CLUSTER_CONFIG}
							   

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Add 30 pools to Kubernetes Cluster which are part of Fs with 30 data pools
###################################################################################################################################      
        [Documentation]             *Add 30 pools to Kubernetes Cluster which are part of Fs with 30 data pools*
                               ...  Keywords:
                               ...  PCC.K8s Create Cluster
                               ...  PCC.K8s Wait Until Cluster is Ready
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Pool Multiple
                               ...  PCC.Ceph Wait Until Pool Ready
                               ...  PCC.Ceph Create Fs
                               ...  PCC.Ceph Wait Until Fs Ready
                               ...  PCC.K8s Upgrade Cluster
                               

        ${response}                 PCC.K8s Create Cluster
                               ...  id=${K8S_ID}
                               ...  k8sVersion=${K8S_VERSION}
                               ...  name=${K8S_NAME}
                               ...  cniPlugin=${K8S_CNIPLUGIN}
                               ...  nodes=${K8S_NODES}
                               ...  pools=${K8S_POOL}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
        
        ${status}                   PCC.K8s Wait Until Cluster is Ready
                               ...  name=${K8S_NAME}

                                    Should Be Equal As Strings      ${status}    OK

                                    
        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${response}                 PCC.Ceph Create Pool Multiple
                               ...  count=32
                               ...  name=k8s
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  tags=${CEPH_POOL_TAGS}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  quota=1
                               ...  quota_unit=MiB

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Pool Ready
                               ...  name=k8s-32

                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${meta}                     PCC.Ceph Get Pool Details For FS
                               ...  name=k8s-32
                               
        ${data}                     PCC.Ceph Get Multiple Pool Details For FS
                               ...  name=['k8s-1','k8s-2','k8s-3','k8s-4','k8s-5','k8s-6','k8s-7','k8s-8','k8s-9','k8s-10','k8s-11','k8s-12','k8s-13','k8s-14','k8s-15','k8s-16','k8s-17','k8s-18','k8s-19','k8s-20','k8s-21','k8s-22','k8s-23','k8s-24','k8s-25','k8s-26','k8s-27','k8s-28','k8s-29','k8s-30']                             
        ${default}                  PCC.Ceph Get Pool Details For FS
                               ...  name=k8s-31

        ${response}                 PCC.Ceph Create Fs
                               ...  name=${CEPH_FS_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  metadata_pool=${meta}
                               ...  data_pool=${data}
                               ...  default_pool=${default}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        
        ${cluster_id}               PCC.K8s Get Cluster Id
                               ...  name=${K8S_NAME}

        ${response}                 PCC.K8s Upgrade Cluster
                               ...  cluster_id=${cluster_id}
                               ...  k8sVersion=${K8S_VERSION}
                               ...  pools=[ 'k8s-1', 'k8s-2', 'k8s-3', 'k8s-4', 'k8s-5', 'k8s-6', 'k8s-7', 'k8s-8', 'k8s-9', 'k8s-10','k8s-11', 'k8s-12', 'k8s-13', 'k8s-14', 'k8s-15', 'k8s-16', 'k8s-17', 'k8s-18', 'k8s-19', 'k8s-20','k8s-21', 'k8s-22', 'k8s-23', 'k8s-24', 'k8s-25', 'k8s-26', 'k8s-27', 'k8s-28', 'k8s-29', 'k8s-30']

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

                                    Sleep  240s
        ${status}                   PCC.K8s Wait Until Cluster is Ready
                               ...  name=${K8S_NAME}
                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Add 15 pools to Kubernetes Cluster which are part of Fs with 30 data pools
###################################################################################################################################      
        [Documentation]             *Add 15 pools to Kubernetes Cluster which are part of Fs with 30 data pools*
                               ...  Keywords:
                               ...  PCC.K8s Upgrade Cluster
                               ...  PCC.K8s Wait Until Cluster is Ready
                               ...  PCC.K8s Get Cluster Id
                                   
        
        ${cluster_id}               PCC.K8s Get Cluster Id
                               ...  name=${K8S_NAME}

        ${response}                 PCC.K8s Upgrade Cluster
                               ...  cluster_id=${cluster_id}
                               ...  k8sVersion=${K8S_VERSION}
                               ...  pools=[ 'k8s-1', 'k8s-2', 'k8s-3', 'k8s-4', 'k8s-5', 'k8s-6', 'k8s-7', 'k8s-8', 'k8s-9', 'k8s-10','k8s-11', 'k8s-12', 'k8s-13', 'k8s-14', 'k8s-15']

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

                                    Sleep  240s
        ${status}                   PCC.K8s Wait Until Cluster is Ready
                               ...  name=${K8S_NAME}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Remove pools from Kubernetes Cluster
###################################################################################################################################
        [Documentation]             *Remove pools from Kubernetes Cluster*
                               ...  Keywords:
                               ...  PCC.K8s Upgrade Cluster
                               ...  PCC.K8s Wait Until Cluster is Ready
                               ...  PCC.K8s Get Cluster Id

        ${cluster_id}               PCC.K8s Get Cluster Id
                               ...  name=${K8S_NAME}

        ${response}                 PCC.K8s Upgrade Cluster
                               ...  cluster_id=${cluster_id}
                               ...  k8sVersion=${K8S_VERSION}
                               ...  pools=[]

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

                                    Sleep  240s
        ${status}                   PCC.K8s Wait Until Cluster is Ready
                               ...  name=${K8S_NAME}
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

