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

###################################################################################################################################
Ceph Cluster Creation without tags (Negative)
###################################################################################################################################
    [Documentation]                *Creating a cluster - without tags*
                              ...  keywords:
                              ...  PCC.Ceph Create Cluster

        ${id}                      PCC.Ceph Get Cluster Id
                              ...  name=${CEPH_CLUSTER_NAME}
                                   Pass Execution If    ${id} is not ${None}    Cluster is alredy there

        ${response}                PCC.Ceph Create Cluster
                              ...  name=${CEPH_CLUSTER_NAME}
                              ...  nodes=${CEPH_CLUSTER_NODES}
                              ...  tags=[]
                              ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}             Get Response Status Code  ${response}
                                   Should Not Be Equal As Strings  ${status_code}  200
        ${message}                 Get Response Message        ${response}

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
Ceph Cluster Update OSD Configurations
###################################################################################################################################
    [Documentation]                 *Ceph Cluster Update OSD Configurations*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK


        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
                               ...  osdScrubBeginHourDesired=${19}
                               ...  osdScrubEndHourDesired=${7}
                               ...  osdRecoverySleepHddDesired=${0.6}
                               ...  osdRecoverySleepSsdDesired=${0.1}
                               ...  osdRecoverySleepHybridDesired=${0.2}
                               ...  osdRecoveryPriorityDesired=${4}
                               ...  osdRecoveryOpPriorityDesired=${2}
                               ...  osdMaxBackfillsDesired=${2}
                               ...  osdScrubSleepDesired=${0.2}
                               ...  osdScrubPriorityDesired=${3}
                               ...  osdDeepScrubStrideDesired=${1048577}
                               ...  osdDeleteSleepHybridDesired=${4}
                               ...  osdSnapTrimPriorityDesired=${2}
                               ...  osdRecoveryMaxActiveHddDesired=${2}
                               ...  osdRecoveryMaxActiveSsdDesired=${6}
                               ...  osdMemoryTargetFlashDesired=${17179869186}
                               ...  osdMemoryTargetRotationalDesired=${8589934594}
                               ...  osdMemoryTargetFullRotationalDesired=${4294967298}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Verify Ceph Cluster OSDs Params
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK


         ${osd_ids}                 PCC.Ceph Get OSD IDs By Cluster Name
                               ...  name=${CEPH_CLUSTER_NAME}

         ${response}                PCC.Ceph Reconcile OSDs
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  osd_ids=${osd_ids}

                                    Should Be Equal As Strings      ${response}    OK

                                    sleep  1m

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
                               ...  interface_name="enp130s0f0"
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Set Interface Up
                               ...  host_ip=${SERVER_1_HOST_IP}
                               ...  interface_name="enp130s0f0"
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}"]
                               ...  osdScrubBeginHourDesired=${19}
                               ...  osdScrubEndHourDesired=${7}
                               ...  osdRecoverySleepHddDesired=${0.6}
                               ...  osdRecoverySleepSsdDesired=${0.1}
                               ...  osdRecoverySleepHybridDesired=${0.2}
                               ...  osdRecoveryPriorityDesired=${4}
                               ...  osdRecoveryOpPriorityDesired=${2}
                               ...  osdMaxBackfillsDesired=${2}
                               ...  osdScrubSleepDesired=${0.2}
                               ...  osdScrubPriorityDesired=${3}
                               ...  osdDeepScrubStrideDesired=${1048577}
                               ...  osdDeleteSleepHybridDesired=${4}
                               ...  osdSnapTrimPriorityDesired=${2}
                               ...  osdRecoveryMaxActiveHddDesired=${2}
                               ...  osdRecoveryMaxActiveSsdDesired=${6}
                               ...  osdMemoryTargetFlashDesired=${17179869186}
                               ...  osdMemoryTargetRotationalDesired=${8589934594}
                               ...  osdMemoryTargetFullRotationalDesired=${4294967298}


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

##################################################################################################################################
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
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=["ROTATIONAL","SOLID_STATE"]
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}


        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

##################################################################################################################################
Ceph Nodes State
###################################################################################################################################
    [Documentation]                 *Ceph Nodes State*


        ${response}                 PCC.Ceph Get Nodes State
                               ...  name=${CEPH_CLUSTER_NAME}

                                    Should Be Equal As Strings      ${response}  OK

##################################################################################################################################
Ceph Mons State
###################################################################################################################################
    [Documentation]                 *Ceph Mons State*


        ${response}                 PCC.Ceph Get Mons State
                               ...  name=${CEPH_CLUSTER_NAME}

                                    Should Be Equal As Strings      ${response}  OK


####################################################################################################################################
#Login To PCC Secondary
####################################################################################################################################
#
#
#                                    Load Server 1 Secondary Test Data   ${pcc_setup}
#                                    Load Server 2 Secondary Test Data   ${pcc_setup}
#                                    Load Server 3 Secondary Test Data   ${pcc_setup}
#                                    Load Server 4 Secondary Test Data   ${pcc_setup}
#                                    Load Server 5 Secondary Test Data   ${pcc_setup}
#                                    Load Server 6 Secondary Test Data   ${pcc_setup}
#                                    Load Ceph Cluster Data Secondary   ${pcc_setup}
#                                    Load Network Manager Data Secondary   ${pcc_setup}
#
#        ${status}                   Login To PCC Secondary       testdata_key=${pcc_setup}
#                                    Should Be Equal     ${status}  OK
#
####################################################################################################################################
#Ceph Secondary Cluster Create
####################################################################################################################################
#    [Documentation]                 *Creating Ceph Secondary Cluster*
#                               ...  keywords:
#                               ...  PCC.Ceph Create Cluster
#                               ...  PCC.Ceph Wait Until Cluster Ready
#
#        ${id}                       PCC.Ceph Get Cluster Id
#                              ...   name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Pass Execution If    ${id} is not ${None}    Cluster is alredy there
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Ceph Create Cluster
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                               ...  nodes=["${SERVER_1_NAME_SECONDARY}","${SERVER_2_NAME_SECONDARY}","${SERVER_3_NAME_SECONDARY}","${SERVER_4_NAME_SECONDARY}","${SERVER_5_NAME_SECONDARY}"]
#                               ...  tags=${CEPH_CLUSTER_TAGS_SECONDARY}
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK_SECONDARY}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${message}                  Get Response Message        ${response}
#
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Ceph Verify BE
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=["${SERVER_1_HOST_IP_SECONDARY}","${SERVER_2_HOST_IP_SECONDARY}","${SERVER_3_HOST_IP_SECONDARY}","${SERVER_4_HOST_IP_SECONDARY}","${SERVER_5_HOST_IP_SECONDARY}"]
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Ceph Cluster Update - Add Server
#####################################################################################################################################
#    [Documentation]                 *Ceph Cluster Update - Add Server*
#
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#
#        ${id}                       PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#
#        ${response}                 PCC.Ceph Cluster Update
#                               ...  id=${id}
#                               ...  nodes=${CEPH_CLUSTER_NODES_SECONDARY}
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK_SECONDARY}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${message}                  Get Response Message        ${response}
#
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Ceph Verify BE
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK