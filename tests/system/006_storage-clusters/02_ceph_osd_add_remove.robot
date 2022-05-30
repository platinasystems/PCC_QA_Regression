*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
    [Tags]      add1
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
Ceph Cluster Get Used Drives
###################################################################################################################################
    [Tags]      add1
    [Documentation]                *Ceph Cluster Get Used Drives*
                              ...  keywords:
                              ...  PCC.Ceph Get Used drives


        &{used_drives}             PCC.Ceph Get Used Drives
                              ...  name=${CEPH_CLUSTER_NAME}

                                    FOR     ${key}    ${value}      IN       &{used_drives}
                                        Log To Console       key=${key}
                                        FOR   ${drive}     IN    @{value}
                                            Log To Console       drive=${drive}
                                        END
                                    END
        ${length}                   Get Length     ${used_drives}
                                    Should Be Equal As Integers     ${length}        3

        @{used_drives_id}           PCC.Ceph Get Used Drives by Hostname
                              ...   name=${CEPH_CLUSTER_NAME}
                              ...   server_name=${SERVER_2_NAME}
                                    Log To Console       ${used_drives_id}

        ${length}                   Get Length     ${used_drives_id}
                                    Should Be Equal As Integers     ${length}        2

###################################################################################################################################
Ceph Cluster Get Unused Drives
###################################################################################################################################
        [Tags]      add1
        [Documentation]            *Ceph Cluster Get Unused Drives*
                              ...  keywords:
                              ...  PCC.Ceph Get Used drives


        @{unused_drives}            PCC.Ceph Get Unused drives
                              ...   name=${CEPH_CLUSTER_NAME}

                                    Log To Console       ${unused_drives}

        @{unused_drives_id}         PCC.Ceph Get Unused Drives by Hostname
                              ...   name=${CEPH_CLUSTER_NAME}
                              ...   server_name=${SERVER_2_NAME}
                                    Log To Console       ${unused_drives_id}

        @{osd_ids}                  PCC.Ceph get OSD Drives by Hostname
                              ...   name=${CEPH_CLUSTER_NAME}
                              ...   server_name=${SERVER_2_NAME}
                                    Log To Console       ${osd_ids}


        ${drive_name}               PCC.Ceph get OSD drive names by osd id
                              ...   name=${CEPH_CLUSTER_NAME}
                              ...   osd_id=${osd_ids}[0]
                                    Log To Console       ${drive_name}

                                    Pass Execution If    ${unused_drives_id} is ${None}      PCC.Ceph Get Unused drives

###################################################################################################################################
Ceph Cluster Delete OSD Drives
###################################################################################################################################
        [Tags]  add1
        [Documentation]         *Ceph Cluster Delete OSD Drives*
                              ...  keywords:
                              ...  PCC.Ceph get OSD drives by Hostname
                              ...  PCC.Ceph get OSD drive names by osd id
                              ...  PCC.Ceph delete OSD drives

        @{osd_ids}                  PCC.Ceph get OSD Drives by Hostname
                              ...   name=${CEPH_CLUSTER_NAME}
                              ...   server_name=${SERVER_2_NAME}
                                    Log To Console       ${osd_ids}
                                 #  Log To Console       ${osd_ids}[0]

        ${drive_name}               PCC.Ceph get OSD drive names by osd id
                              ...   name=${CEPH_CLUSTER_NAME}
                              ...   osd_id=${osd_ids}[0]
                                    Log To Console       ${drive_name}

        ${response}                 PCC.Ceph Delete OSD drives
                               ...   name=${CEPH_CLUSTER_NAME}
                               ...   osd_id=${osd_ids}[0]
                               ...   wipe=True
                                    Log To Console       ${response}

        ${status_code}              Get Response Status Code        ${response}
                                    Log To Console       ${status_code}
                                   # Should Be Equal As Strings      ${status_code}    200
        #${message}                  Get Response Message        ${response}
                                    Sleep    1m

        ${status}                   PCC.Ceph Wait Until OSD Deleted
                               ...   name=${CEPH_CLUSTER_NAME}
                               ...   osd_id=${osd_ids}[0]

                                    Log To Console       ${status}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Cluster Add OSD Drive
###################################################################################################################################
        [Tags]      add1
        [Documentation]            *Ceph Cluster Add OSD Drive*
                              ...  keywords:
                              ...  PCC.Ceph Get Unused drives
                              ...  PCC.Ceph Add OSD drives
                                    Sleep   1m

        @{unused_drives_id}         PCC.Ceph Get Unused Drives by Hostname
                              ...   name=${CEPH_CLUSTER_NAME}
                              ...   server_name=${SERVER_2_NAME}
                                    Log To Console      ${unused_drives_id}
                                    Should Be True      ${unused_drives_id} is not ${None}     PCC.Ceph Get Unused Drives by Hostname

        ${response}                 PCC.Ceph Add OSD drives
                              ...   name=${CEPH_CLUSTER_NAME}
                              ...   osd_id=${unused_drives_id}[0]
                                    Log To Console       ${response}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
                                    Sleep   1m

        @{unused_drives_id}         PCC.Ceph Get Unused Drives by Hostname
                              ...   name=${CEPH_CLUSTER_NAME}
                              ...   server_name=${SERVER_2_NAME}
                                    Log To Console       ${unused_drives_id}
                                    Pass Execution If    ${unused_drives_id} is ${None}     PCC.Ceph Get Unused Drives by Hostname

####################################################################################################################################
