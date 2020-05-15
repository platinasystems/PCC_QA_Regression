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
Ceph Rbd Delete Multiple
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Delete Multiple*
                               ...  keywords:
                               ...  PCC.Ceph Delete All Rbds


        ${status}                   PCC.Ceph Delete All Rbds
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
BE Ceph Cleanup
###################################################################################################################################

        ${response}                 PCC.Ceph Cleanup BE
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
