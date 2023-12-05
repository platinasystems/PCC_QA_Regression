*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    Load Server 3 Test Data    ${pcc_setup}
                                    Load Network Manager Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Enter Maintenance Mode
###################################################################################################################################
    [Documentation]                 *Enter in Maintenance Mode*

    ${server2_id}                  PCC.Get Node Id    Name=${SERVER_2_NAME}


    ${response}                    PCC.Set Maintenance Mode
                              ...  Id=${server2_id}
                              ...  maintenance=${true}
                              ...  force=${true}

                                   ${result}    Get Result    ${response}
                                   ${message}   Get Response Message        ${response}
                                   ${status}    Get From Dictionary    ${result}    status
                                   Should Be Equal As Strings    ${status}    200

                                   sleep  1m

###################################################################################################################################
Verify Enter Maintenance Mode
###################################################################################################################################
    [Documentation]                 *Enter in Maintenance Mode*

    ${response}                     PCC.Check Maintenance Mode Status
                               ...  Name=${SERVER_2_NAME}
                               ...  maintenance=${true}

                                    Should Be Equal As Strings    ${response}    OK


    ${response}                     PCC.Ceph Verify Osds State By Hostname
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  server=${SERVER_2_NAME}
                               ...  state_status=noout

                                    Should Be Equal As Strings    ${response}    OK


    @{osd_ids}                      PCC.Ceph get OSD Drives by Hostname
                              ...   name=${CEPH_CLUSTER_NAME}
                              ...   server_name=${SERVER_2_NAME}
                                    Log To Console       ${osd_ids}

    ${status}                       PCC.Verify OSD Status BE
                               ...  hostip=${SERVER_2_HOST_IP}
                               ...  osd_id=${osd_ids}[0]
                               ...  state=inactive

                                    Log To Console       ${status}
                                    Should Be Equal As Strings      ${status}    OK

    ${status}                       PCC.Verify OSD Status BE
                               ...  hostip=${SERVER_2_HOST_IP}
                               ...  osd_id=${osd_ids}[1]
                               ...  state=inactive

                                    Log To Console       ${status}
                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Enter Maintenance Mode: 2 Mon Required (Negative)
###################################################################################################################################
    [Documentation]                 *Enter in Maintenance Mode: 2 Mon Required (Negative)*

    ${server3_id}                  PCC.Get Node Id    Name=${SERVER_3_NAME}


    ${response}                    PCC.Set Maintenance Mode
                              ...  Id=${server3_id}
                              ...  maintenance=${true}

                                   ${result}    Get Result    ${response}
                                   ${message}   Get Response Message        ${response}
                                   ${status}    Get From Dictionary    ${result}    status
                                   Should Not Be Equal As Strings    ${status}    200


###################################################################################################################################
Exit Maintenance Mode
###################################################################################################################################
    [Documentation]                 *Exit in Maintenance Mode*

    ${server2_id}                  PCC.Get Node Id    Name=${SERVER_2_NAME}


    ${response}                    PCC.Set Maintenance Mode
                              ...  Id=${server2_id}
                              ...  maintenance=${false}

                                   ${result}    Get Result    ${response}
                                   ${status}    Get From Dictionary    ${result}    status
                                   Should Be Equal As Strings    ${status}    200

                                   sleep  1m

###################################################################################################################################
Verify Exit Maintenance Mode
###################################################################################################################################
    [Documentation]                 *Enter in Maintenance Mode*

    ${response}                     PCC.Check Maintenance Mode Status
                               ...  Name=${SERVER_2_NAME}
                               ...  maintenance=${false}

                                    Should Be Equal As Strings    ${response}    OK


    ${response}                     PCC.Ceph Verify Osds State By Hostname
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  server=${SERVER_2_NAME}
                               ...  state_status=up

                                    Should Be Equal As Strings    ${response}    OK


    @{osd_ids}                      PCC.Ceph get OSD Drives by Hostname
                              ...   name=${CEPH_CLUSTER_NAME}
                              ...   server_name=${SERVER_2_NAME}
                                    Log To Console       ${osd_ids}

    ${status}                       PCC.Verify OSD Status BE
                               ...  hostip=${SERVER_2_HOST_IP}
                               ...  osd_id=${osd_ids}[0]
                               ...  state=active

                                    Log To Console       ${status}
                                    Should Be Equal As Strings      ${status}    OK

    ${status}                       PCC.Verify OSD Status BE
                               ...  hostip=${SERVER_2_HOST_IP}
                               ...  osd_id=${osd_ids}[1]
                               ...  state=active

                                    Log To Console       ${status}
                                    Should Be Equal As Strings      ${status}    OK