*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Network Manager Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    Load Server 3 Test Data    ${pcc_setup}
                                    Load Ipam Data    ${pcc_setup} 

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Test Ceph Health Metric
###################################################################################################################################
    [Documentation]                 *Test Ceph Health Metrics*

        ${status}                   PCC.Prometheus Ceph Health Metrics
                               ...  pcc_prometheus_objects=["healthLevel"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Test Fetch Admin Carrier Metrics
###################################################################################################################################
    [Documentation]                 *Test Fetch Admin Carrier Metrics*

        ${status}                   PCC.Prometheus Admin Carrier Metrics
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Test Fetch Interface Carrier Metrics
###################################################################################################################################
    [Documentation]                 *Test Fetch Interface Carrier Metrics*

        ${status}                   PCC.Prometheus Interface Carrier Metrics
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Test Fetch Admin Status Metrics
###################################################################################################################################
    [Documentation]                 *Test Fetch Admin Status Metrics*

        ${status}                   PCC.Prometheus Admin Status Metrics
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Test Fetch Connection Status Metrics
###################################################################################################################################
    [Documentation]                 *Test Fetch Connection Status Metrics*

        ${status}                   PCC.Prometheus Connection Status Metrics
                                    Should Be Equal As Strings      ${status}    OK