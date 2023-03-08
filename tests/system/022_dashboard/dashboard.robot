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
        [Tags]             kc


        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
PCC Dashboard - Verify object graph:TCP-1776
###################################################################################################################################

        [Documentation]    *PCC Dashboard - Verify object graph * test
                           ...  keywords:
                           ...  PCC.Dashboard Verify object graph


        ${status}      PCC.Dashboard Verify object graph
                       ...  objects=["Node", "CephCluster", "K8sCluster","NetworkCluster"]

                       Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
PCC Dashboard - Verify object count:TCP-1777
###################################################################################################################################

        [Documentation]    *PCC Dashboard - Verify object count* test
                                   ...  keywords:
                                   ...  PCC.Dashboard verify object count

        ${status}      PCC.Dashboard verify object count
                       ...  objects=["Node", "CephCluster", "K8sCluster", "NetworkCluster"]

                       Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
PCC Dashboard - Verify object health count:TCP-1778
###################################################################################################################################
        [Documentation]    *PCC Dashboard - Verify object health count* test
                                   ...  keywords:
                                   ...  PCC.Dashboard Verify object health

        ${status}      PCC.Dashboard Verify object health
                       ...  objects=["Node", "CephCluster","K8sCluster", "NetworkCluster"]

                       Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
PCC Dashboard - Verify object metrics:TCP-1653,TCP-1652,TCP-1649
###################################################################################################################################
        [Documentation]    *PCC Dashboard - Verify object metrics* test
                                   ...  keywords:
                                   ...  PCC.Dashboard Verify object metrics

        ${status}      PCC.Dashboard Verify object metrics
                       ...  objects=["Node","CephCluster","K8sCluster"]

                       Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
PCC Dashboard - Verify object location:TCP-1649
###################################################################################################################################
        [Documentation]    *PCC Dashboard - Verify object location* test
                                   ...  keywords:
                                   ...  PCC.Dashboard Verify object location

        

      ${status}      PCC.Dashboard Verify object location
                       ...  objects=["Node"]

                       Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
PCC Dashboard - Verify Object Health/Kernel/OS Information:TCP-1653,TCP-1652,TCP-1650
###################################################################################################################################
        [Documentation]    *PCC Dashboard - Verify Object Health/Kernel/OS Information* test
                                   ...  keywords:
                                   ...  PCC.Dashboard Verify Object Health/Kernel/OS Information


        ${status}      PCC.Dashboard Verify Object Health/Kernel/OS Information
                       ...  objects=["Node","K8sCluster","CephCluster","NetworkCluster"] 
                       ...  nodeip=${SERVER_1_HOST_IP}

                       Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
PCC Dashboard - Storage Page Validation:TCP-1506
###################################################################################################################################
        [Documentation]    *PCC Dashboard - Storage Page Validation* test
                                   ...  keywords:
                                   ...  PCC.Dashboard Storage Page Validation


        

        ${status}      PCC.Dashboard Storage Page Validation

                       Should Be Equal As Strings      ${status}    OK




###################################################################################################################################
PCC Dashboard - Filesystem page validation:TCP-1507
###################################################################################################################################
        [Documentation]    *PCC Dashboard - Filesystem page validation* test
                                   ...  keywords:
                                   ...  PCC.Dashboard Filesystem Page Validation

       

        ${status}      PCC.Dashboard Filesystem Page Validation

                       Should Be Equal As Strings      ${status}    OK
###################################################################################################################################
PCC Dashboard - Monitor Page Storage Controller Validation:TCP-1780
###################################################################################################################################
        [Documentation]    *PCC Dashboard - Monitor Page Storage Controller Validation* test
                                   ...  keywords:
                                   ...  PCC.Dashboard Monitor Page Storage Controller Validation

       

        ${status}      PCC.Dashboard Monitor Page Storage Controller Validation
                       Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
PCC Dashboard - Monitor Page Partition Validation:TCP-1779
###################################################################################################################################
        [Documentation]    *PCC Dashboard - Monitor Page Partition Validation* test
                                   ...  keywords:
                                   ...  PCC.Dashboard Monitor Page Partitions Validation

       

        ${status}      PCC.Dashboard Monitor Page Partitions Validation
                       Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
PCC Dashboard - Monitor Page Filesystem Validation:TCP-1781
###################################################################################################################################
        [Documentation]    *PCC Dashboard - Monitor Page Filesystem Validation* test
                                   ...  keywords:
                                   ...  PCC.Dashboard Monitor Page Filesystem Validation

       

        ${status}      PCC.Dashboard Monitor Page Filesystem Validation
                       Should Be Equal As Strings      ${status}    OK
