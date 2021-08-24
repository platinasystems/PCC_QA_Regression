*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Ipam Data    ${pcc_setup}
                                    Load Ceph Rbd Data    ${pcc_setup}
                                    Load Ceph Pool Data    ${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    Load Server 3 Test Data    ${pcc_setup}
                                    Load Network Manager Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Ceph Cluster Creation with 2 nodes both servers (Negative)
###################################################################################################################################
    [Documentation]                *Creating a cluster - Creation with 2 nodes*
                              ...  keywords:
                              ...  PCC.Ceph Create Cluster

        ${id}                      PCC.Ceph Get Cluster Id
                              ...  name=${CEPH_CLUSTER_NAME}
                                   Pass Execution If    ${id} is not ${None}    Cluster is alredy there

        ${response}                PCC.Ceph Create Cluster
                              ...  name=${CEPH_CLUSTER_NAME}
                              ...  nodes=["${SERVER_1_NAME}", "${SERVER_2_NAME}"]
                              ...  tags=${CEPH_CLUSTER_TAGS}
                              ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}             Get Response Status Code  ${response}
                                   Should Not Be Equal As Strings  ${status_code}  200
        ${message}                 Get Response Message        ${response}
###################################################################################################################################
Ceph Cluster Creation without name (Negative)
###################################################################################################################################
    [Documentation]                *Creating a cluster - without name*
                              ...  keywords:
                              ...  PCC.Ceph Create Cluster

        ${response}                 PCC.Ceph Create Cluster
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

###################################################################################################################################
Ceph Cluster Creation with invalid name (Negative)
###################################################################################################################################
    [Documentation]                *Creating a cluster - with invalid name*
                              ...  keywords:
                              ...  PCC.Ceph Create Cluster

        ${response}                PCC.Ceph Create Cluster
                              ...  name=!@#$%^
                              ...  nodes=${CEPH_CLUSTER_NODES}
                              ...  tags=${CEPH_CLUSTER_TAGS}
                              ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}             Get Response Status Code  ${response}
                                   Should Not Be Equal As Strings  ${status_code}  200
        ${message}                 Get Response Message        ${response}
###################################################################################################################################
Ceph Cluster Creation without selecting any nodes (Negative)
###################################################################################################################################
    [Documentation]                *Creating a cluster - without selecting any nodes*
                              ...  keywords:
                              ...  PCC.Ceph Create Cluster

        ${id}                      PCC.Ceph Get Cluster Id
                              ...  name=${CEPH_CLUSTER_NAME}
                                   Pass Execution If    ${id} is not ${None}    Cluster is alredy there

        ${response}                PCC.Ceph Create Cluster
                              ...  name=${CEPH_CLUSTER_NAME}
                              ...  nodes=[]
                              ...  tags=${CEPH_CLUSTER_TAGS}
                              ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}             Get Response Status Code  ${response}
                                   Should Not Be Equal As Strings  ${status_code}  200
        ${message}                 Get Response Message        ${response}

####################################################################################################################################
#Ceph Cluster Creation without tags (Negative)
####################################################################################################################################
#    [Documentation]                *Creating a cluster - without tags*
#                              ...  keywords:
#                              ...  PCC.Ceph Create Cluster
#
#        ${id}                      PCC.Ceph Get Cluster Id
#                              ...  name=${CEPH_CLUSTER_NAME}
#                                   Pass Execution If    ${id} is not ${None}    Cluster is alredy there
#
#        ${response}                PCC.Ceph Create Cluster
#                              ...  name=${CEPH_CLUSTER_NAME}
#                              ...  nodes=${CEPH_CLUSTER_NODES}
#                              ...  tags=[]
#                              ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
#
#        ${status_code}             Get Response Status Code  ${response}
#                                   Should Not Be Equal As Strings  ${status_code}  200
#        ${message}                 Get Response Message        ${response}
#
###################################################################################################################################
Ceph Cluster with one node (Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster with one node*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${id}                       PCC.Ceph Get Cluster Id
                              ...   name=${CEPH_CLUSTER_NAME}
                                    Pass Execution If    ${id} is not ${None}    Cluster is alredy there

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=["${SERVER_2_NAME}"]
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

###################################################################################################################################
Ceph Cluster with two node one server one invader(Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster with two node*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${id}                       PCC.Ceph Get Cluster Id
                              ...   name=${CEPH_CLUSTER_NAME}
                                    Pass Execution If    ${id} is not ${None}    Cluster is alredy there

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=["${SERVER_2_NAME}", "${CLUSTERHEAD_1_NAME}"]
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

###################################################################################################################################
Ceph Cluster Create
###################################################################################################################################
    [Documentation]                 *Creating Ceph Cluster*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${id}                       PCC.Ceph Get Cluster Id
                              ...   name=${CEPH_CLUSTER_NAME}
                                    Pass Execution If    ${id} is not ${None}    Cluster is alredy there

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Ceph Cluster Creation With Nodes Which Are Part of Existing Cluster (Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster Creation With Nodes Which Are Part of Existing Cluster*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

###################################################################################################################################
Ceph Cluster Update - Add Invader
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
                               ...  nodes=["${SERVER_3_NAME}","${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
#Ceph Cluster Update - Add Server
####################################################################################################################################
#    [Documentation]                 *Ceph Cluster Update - Add Invade*
#                               ...  keyword:
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Cluster Update
#                               ...  PCC.Ceph Wait Until Cluster Ready
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${id}                       PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME}
#
#        ${response}                 PCC.Ceph Cluster Update
#                               ...  id=${id}
#                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}","${CLUSTERHEAD_1_NAME}","${SERVER_3_NAME}"]
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${message}                  Get Response Message        ${response}
#
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Ceph Verify BE
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}"]
#                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
#Ceph Cluster Update - Remove 2 Mons Nodes
####################################################################################################################################
#    [Documentation]                 *Ceph Cluster Update - Add Invade*
#                               ...  keyword:
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Cluster Update
#                               ...  PCC.Ceph Wait Until Cluster Ready
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${id}                       PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME}
#
#        ${response}                 PCC.Ceph Cluster Update
#                               ...  id=${id}
#                               ...  nodes=["${SERVER_3_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${message}                  Get Response Message        ${response}
#
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Ceph Verify BE
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}"]
#                                    Should Be Equal As Strings      ${status}    OK
#
#	#### Wiping the drives after node removal #######
#	#${status}                   PCC.Ceph Cleanup BE
#        #                       ...  nodes_ip=["${SERVER_2_HOST_IP}"]
#        #                       ...  user=${PCC_LINUX_USER}
#        #                       ...  password=${PCC_LINUX_PASSWORD}
#        #                            Should be equal as strings    ${status}    OK
#
###################################################################################################################################
#Reboot Node And Verify Ceph Is Intact
###################################################################################################################################
#    [Documentation]                 *Verifying Ceph cluster BE*
#                               ...  keywords:
#                               ...  Ceph Verify BE
#                               ...  Restart node
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
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
#Ceph Reboot Manager And Verify If Service Is Still Running
####################################################################################################################################
#    [Documentation]                 *Ceph Cluster Update - Add Invade*
#                               ...  keyword:
#                               ...  PCC.Ceph Reboot Manager And Verify
#
#            ${status}               PCC.Ceph Reboot Manager And Verify
#                               ...  hostip=${CLUSTERHEAD_1_HOST_IP}
#                                    Sleep    60s
#                                    Should Be Equal As Strings      ${status}    OK
#
#################################################################################################################################
Down And Up The Interface And Check For Ceph
###################################################################################################################################
        [Documentation]             *Down And Up The Interface And Check For Ceph*
                               ...  Keywords:
                               ...  PCC.Set Interface Down
                               ...  PCC.Set Interface Up
                               ...  PCC.Ceph Verify BE

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Set Interface Down
                               ...  host_ip=${SERVER_1_HOST_IP}
                               ...  interface_name="enp1s0f0"
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Set Interface Up
                               ...  host_ip=${SERVER_1_HOST_IP}
                               ...  interface_name="enp1s0f0"
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}"]

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete Network Manager When Ceph Is Present (Negative)
###################################################################################################################################
    [Documentation]                 *Network Manager Verification PCC*
                               ...  keywords:
                               ...  PCC.Network Manager Delete

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Network Manager Delete
                               ...  name=${NETWORK_MANAGER_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

###################################################################################################################################
TCP-1012 Update Cluster(2 Invader setup) - Remove - Remove TWO OSD nodes from cluster [4 nodes (3 MONs + 2 OSDs)] (Negative)
###################################################################################################################################
    [Documentation]                 *Update Cluster(2 Invader setup) - Remove - Remove TWO OSD nodes from cluster [4 nodes (3 MONs + 2 OSDs)]*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  nodes=["${CLUSTERHEAD_2_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

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
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
###################################################################################################################################
TCP-981 Update Cluster - Try to rename cluster Name (Negative)
###################################################################################################################################
    [Documentation]                 *Update Cluster - Try to rename cluster Name*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  name=ceph-rename
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}


        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

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
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#           ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
###################################################################################################################################
#TCP-985 Update Cluster - Try to remove Tags (Negative)
####################################################################################################################################
#    [Documentation]                 *Update Cluster - Try to remove Tags*
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
#                               ...  tags=["ROTATIONAL","SOLID_STATE"]
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
#
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Not Be Equal As Strings      ${status_code}  200
#

####################################################################################################################################
#Ceph Cluster Update - Assign all existing nodes to CEPH cluster
####################################################################################################################################
#    [Documentation]                 *Ceph Cluster Update - Add Invade*
#                               ...  keyword:
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Cluster Update
#                               ...  PCC.Ceph Wait Until Cluster Ready
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${id}                       PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME}
#
#        ${response}                 PCC.Ceph Cluster Update
#                               ...  id=${id}
#                               ...  nodes=["${SERVER_3_NAME}","${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}","${CLUSTERHEAD_1_NAME}"]
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${message}                  Get Response Message        ${response}
#
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Ceph Verify BE
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}"]
#                                    Should Be Equal As Strings      ${status}    OK
