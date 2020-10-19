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
Ceph Fs Delete
###################################################################################################################################
    [Documentation]                 *Delete Fs if it exist*   
                               ...  keywords:
                               ...  PCC.Ceph Delete All Fs

        ${status}                   PCC.Ceph Delete All Fs
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Ceph Rgw Delete Multiple
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Delete Multiple*
                               ...  keywords:
                               ...  PCC.Ceph Delete All Rgw

        ${status}                   PCC.Ceph Delete All Rgw
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
                               ...  PCC.Ceph Delete All Cluster

        ${status}                   PCC.Ceph Delete All Cluster
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
BE Ceph Cleanup
###################################################################################################################################

        ${response}                 PCC.Ceph Cleanup BE
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}

###################################################################################################################################
Ceph K8s Multiple
###################################################################################################################################
    [Documentation]                 *Deleting all Pools*
                               ...  keywords:
                               ...  PCC.K8s Delete All Cluster
                               
        ${status}                   PCC.K8s Delete All Cluster
                                    Should Be Equal     ${status}  OK 

###################################################################################################################################
Network Manager Delete
###################################################################################################################################
    [Documentation]                 *Delete Network Manager if it exist*
                               ...  keywords:
                               ...  PCC.Network Manager Delete All

        ${status}                   PCC.Network Manager Delete All
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Delete Multiple Subnet
###################################################################################################################################
    [Documentation]                 *Delete IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Delete All

        ${status}                   PCC.Ipam Subnet Delete All                          
                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Deleting Maas From Nodes
###################################################################################################################################
    [Documentation]                 *Deleting Maas+LLDP From Nodes*
                               ...  Keywords:
                               ...  PCC.Delete and Verify Roles On Nodes
                               ...  PCC.Wait Until Roles Ready On Nodes
                               
        ${response}                 PCC.Delete and Verify Roles On Nodes
                               ...  nodes=["${CLUSTERHEAD_1_NAME}"]
                               ...  roles=["Baremetal Management Node"]
                                    Should Be Equal As Strings      ${response}  OK

        ${status_code}              PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                                    Should Be Equal As Strings      ${status_code}  OK

        ${response}                 PCC.Maas Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                                    Should Not Be Equal As Strings      ${response}  OK
                                    


