*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
                                    Load Ceph Cluster Data    ${s3_setup}


        ${status}                   Login To PCC       testdata_key=${s3_setup}
                                    Should be equal as strings    ${status}    OK

###################################################################################################################################
Unassign All Tags From Policy
###################################################################################################################################
    [Documentation]                 *Unassign All Tags From Policy*

        ${status}        PCC.Unassign All Tags From Policy

                         Log To Console    ${status}
                         Should Be Equal As Strings      ${status}  OK


        ${status}        PCC.Wait Until All Nodes Are Ready
                         Log To Console    ${status}
                         Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Policy driven management cleanup
###################################################################################################################################

                [Documentation]    *Policy driven management cleanup* test


                ${status}    PCC.Unassign Locations Assigned from All Policies

                             Log to Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

                ${status}    PCC.Wait Until All Nodes Are Ready
                             Log To Console    ${status}
                             Should Be Equal As Strings      ${status}  OK

                ${status}    PCC.Delete All Policies

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Ceph Delete All Rgw
###################################################################################################################################
    [Documentation]                 *Ceph Delete All Rgw*

        ${status}                   PCC.Ceph Delete All Rgw
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should be equal as strings    ${status}    OK

###################################################################################################################################
Ceph Delete All Fs
###################################################################################################################################
    [Documentation]                 *Ceph Delete All Fs*

        ${status}                   PCC.Ceph Delete All Fs
                                    Should be equal as strings    ${status}    OK

###################################################################################################################################
Ceph Delete All Rbds
###################################################################################################################################
    [Documentation]                 *Ceph Delete All Rbds*

        ${status}                   PCC.Ceph Delete All Rbds
                                    Should be equal as strings    ${status}    OK

###################################################################################################################################
Deleting all Pools
###################################################################################################################################
    [Documentation]                 *Deleting all Pools*

                                    sleep       1m

        ${status}                   PCC.Ceph Delete All Pools
                                    Should be equal as strings    ${status}    OK

###################################################################################################################################
PCC.Ceph Delete All Cluster
###################################################################################################################################
    [Documentation]                 *PCC.Ceph Delete All Cluster*

        ${status}                   PCC.Ceph Delete All Cluster
                                    Should be equal as strings    ${status}    OK

                                    sleep  1m

        ${status}                   PCC.Wait Until All Nodes Are Ready

                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Ceph Cluster Force Delete (if cluster not deleted)
###################################################################################################################################
    [Documentation]                 *Delete cluster if it exist*
                               ...  keywords:
                               ...  PCC.Ceph Force Delete All Cluster

        ${ceph_cluster_id}           PCC.Ceph Get Cluster Id
                              ...    name=${CEPH_CLUSTER_NAME}
                                     Log To Console    ${ceph_cluster_id}
                                     Pass Execution If    ${ceph_cluster_id} is ${None}    ${ceph_cluster_id} ceph cluster already present

        ${response}                  PCC.Ceph Delete Cluster
                              ...    forceRemove=True
                              ...    id=${ceph_cluster_id}
                                     Log To Console    ${response}
                                     ${result}    Get Result    ${response}
                                     ${status}    Get From Dictionary    ${result}    status
                                     ${message}    Get From Dictionary    ${result}    message
                                     Log to Console    ${message}
                                     Should Be Equal As Strings    ${status}    200

        ${status}                    PCC.Ceph Wait Until Cluster Deleted
                              ...    id=${ceph_cluster_id}
                                     Log To Console    ${status}
                                     Should be equal as strings    ${status}    OK

                                     sleep  1m

        ${status}                    PCC.Wait Until All Nodes Are Ready

                                     Log To Console    ${status}
                                     Should Be Equal As Strings      ${status}  OK


###################################################################################################################################
BE Ceph Cleanup
###################################################################################################################################
    [Documentation]                 *BE Ceph Cleanup*
        ${status}                   PCC.Ceph Cleanup BE
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}

                                    Should be equal as strings    ${status}    OK

###################################################################################################################################
Delete All Profiles
###################################################################################################################################

        [Documentation]    *PCC.Delete All Profiles*

        ${status}          PCC.Delete All Profiles

                           Should be equal as strings    ${status}    OK

###################################################################################################################################
Network Manager Delete All
###################################################################################################################################
    [Documentation]                 *Network Manager Delete All*

        ${status}                   PCC.Network Manager Delete All
                                    Should be equal as strings    ${status}    OK

                                    sleep  2m

        ${status}                   PCC.Wait Until All Nodes Are Ready

                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK
###################################################################################################################################
Network Manager Delete All
###################################################################################################################################
    [Documentation]                 *Network Manager Delete All*

        ${status}                   PCC.Network Manager Delete All
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ipam Subnet Delete All
###################################################################################################################################
    [Documentation]                 *Ipam Subnet Delete All*

        ${status}                   PCC.Ipam Subnet Delete All
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Cleanup features associated to Node
###################################################################################################################################
    [Documentation]                 *Cleanup features associated to Node*

        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=Default region
                        Log To Console    ${parent1_Id}

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=Default zone
                        ...  parentID=${parent1_Id}
                        Log To Console    ${parent2_Id}

        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=Default site
                        ...  parentID=${parent2_Id}

                        Log To Console    ${parent3_Id}

        ${scope_id}    PCC.Get Scope Id
                       ...  scope_name=Default rack
                       ...  parentID=${parent3_Id}

                       Log To Console    ${scope_id}

        ${status}       PCC.Cleanup features associated to Node
                        ...    scopeId=${scope_id}
                        Log To Console    ${status}
                        Should Be Equal As Strings      ${status}  OK

        ${status}       PCC.Wait Until All Nodes Are Ready

                        Log To Console    ${status}
                        Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Delete All Tags
###################################################################################################################################

        [Documentation]    *Delete All Tags*

        ${response}     PCC.Delete All Tag

                        Should Be Equal As Strings    ${response}    OK

####################################################################################################################################
Cleanup all certificates from PCC
####################################################################################################################################
    [Documentation]                 *Cleanup all certificates*

        ${status}                   PCC.Delete All Certificates

                                    Log To Console    ${status}
                                    Should be equal as strings    ${status}    OK