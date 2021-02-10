*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}


        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
PCC Dashboard - Verify object graph
###################################################################################################################################

        [Documentation]    *PCC Dashboard - Verify object graph * test
                           ...  keywords:
                           ...  PCC.Dashboard Verify object graph

        [Tags]             kc


        ${status}      PCC.Dashboard Verify object graph
                       ...  objects=["Node", "CephCluster", "K8sCluster","NetworkCluster"]

                       Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
PCC Dashboard - Verify object count
###################################################################################################################################

        [Documentation]    *PCC Dashboard - Verify object count* test
                                   ...  keywords:
                                   ...  PCC.Dashboard verify object count

        ${status}      PCC.Dashboard verify object count
                       ...  objects=["Node", "CephCluster", "K8sCluster", "NetworkCluster"]

                       Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
PCC Dashboard - Verify object health count
###################################################################################################################################
        [Documentation]    *PCC Dashboard - Verify object health count* test
                                   ...  keywords:
                                   ...  PCC.Dashboard Verify object health

        ${status}      PCC.Dashboard Verify object health
                       ...  objects=["Node", "CephCluster","K8sCluster", "NetworkCluster"]

                       Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
PCC Dashboard - Verify object metrics
###################################################################################################################################
        [Documentation]    *PCC Dashboard - Verify object metrics* test
                                   ...  keywords:
                                   ...  PCC.Dashboard Verify object metrics

        ${status}      PCC.Dashboard Verify object metrics
                       ...  objects=["Node","CephCluster","K8sCluster"]

                       Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
PCC Dashboard - Verify object location
###################################################################################################################################
        [Documentation]    *PCC Dashboard - Verify object location* test
                                   ...  keywords:
                                   ...  PCC.Dashboard Verify object location

        ${status}      PCC.Dashboard Verify object location
                       ...  objects=["Node"]

                       Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
PCC Dashboard - Verify Object Health/Kernel/OS Information
###################################################################################################################################
        [Documentation]    *PCC Dashboard - Verify Object Health/Kernel/OS Information* test
                                   ...  keywords:
                                   ...  PCC.Dashboard Verify Object Health/Kernel/OS Information
                                   ...  PCC.Ceph Active Manager And Verify

        ${node_ip}     PCC.Ceph Active Manager And Verify
                       ...  hostip=${CLUSTERHEAD_1_HOST_IP}
                       Log To Console    ${node_ip}
                       Set Global Variable    ${node_ip}


        ${status}      PCC.Dashboard Verify Object Health/Kernel/OS Information
                       ...  objects=["Node","K8sCluster","CephCluster","NetworkCluster"] 
                       ...  nodeip=${node_ip}

                       Should Be Equal As Strings      ${status}    OK

