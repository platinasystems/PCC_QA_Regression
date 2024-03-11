#*** Settings ***
#Resource    pcc_resources.robot
#
#*** Variables ***
#${pcc_setup}                 pcc_212
#
#*** Test Cases ***
####################################################################################################################################
#Login
####################################################################################################################################
#                                    Load Ceph Cluster Data Secondary    ${pcc_setup}
#
#
#        ${status}                   Login To PCC Secondary       testdata_key=${pcc_setup}
#                                    Should be equal as strings    ${status}    OK
#
####################################################################################################################################
#Ceph Rgw Delete Multiple
####################################################################################################################################
#    [Documentation]                 *Ceph Rbd Delete Multiple*
#                               ...  keywords:
#                               ...  PCC.Ceph Delete All Rgw
#
#        ${status}                   PCC.Ceph Delete All Rgw
#                                ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should be equal as strings    ${status}    OK
#
####################################################################################################################################
#Ceph Fs Delete
####################################################################################################################################
#    [Documentation]                 *Delete Fs if it exist*
#                               ...  keywords:
#                               ...  PCC.Ceph Delete All Fs
#        ${status}                   PCC.Ceph Delete All Fs
#                                    Should be equal as strings    ${status}    OK
#
####################################################################################################################################
#Ceph Rbd Delete Multiple
####################################################################################################################################
#    [Documentation]                 *Ceph Rbd Delete Multiple*
#                               ...  keywords:
#                               ...  PCC.Ceph Delete All Rbds
#
#        ${status}                   PCC.Ceph Delete All Rbds
#                                    Should be equal as strings    ${status}    OK
#
####################################################################################################################################
#Ceph Pool Multiple Delete
####################################################################################################################################
#    [Documentation]                 *Deleting all Pools*
#                               ...  keywords:
#                               ...  CC.Ceph Delete All Pools
#
#        ${status}                   PCC.Ceph Delete All Pools
#                                    Should be equal as strings    ${status}    OK
#
####################################################################################################################################
#Ceph Cluster Delete
####################################################################################################################################
#    [Documentation]                 *Delete cluster if it exist*
#                               ...  keywords:
#                               ...  PCC.Ceph Delete All Cluster
#
#        ${ceph_cluster_deletion_status}    PCC.Ceph Delete All Cluster
#                                           Should be equal as strings    ${ceph_cluster_deletion_status}    OK
#
#                                           sleep  1m
#
#        ${status}                          PCC.Wait Until All Nodes Are Ready
#
#                                           Log To Console    ${status}
#                                           Should Be Equal As Strings      ${status}  OK
#
####################################################################################################################################
#Ceph Cluster Force Delete (if cluster not deleted)
####################################################################################################################################
#    [Documentation]                 *Delete cluster if it exist*
#                               ...  keywords:
#                               ...  PCC.Ceph Force Delete All Cluster
#
#        ${ceph_cluster_id}           PCC.Ceph Get Cluster Id
#                              ...    name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                     Log To Console    ${ceph_cluster_id}
#                                     Pass Execution If    ${ceph_cluster_id} is ${None}    ${ceph_cluster_id} ceph cluster already present
#
#        ${response}                  PCC.Ceph Delete Cluster
#                              ...    forceRemove=True
#                              ...    id=${ceph_cluster_id}
#                                     Log To Console    ${response}
#                                     ${result}    Get Result    ${response}
#                                     ${status}    Get From Dictionary    ${result}    status
#                                     ${message}    Get From Dictionary    ${result}    message
#                                     Log to Console    ${message}
#                                     Should Be Equal As Strings    ${status}    200
#
#        ${cluster_deletion_wait_status}    PCC.Ceph Wait Until Cluster Deleted
#                                           ...    id=${ceph_cluster_id}
#                                           Log To Console    ${cluster_deletion_wait_status}
#                                           Should be equal as strings    ${cluster_deletion_wait_status}    OK
#
#                                           sleep  1m
#
#        ${status}                      PCC.Wait Until All Nodes Are Ready
#
#                                       Log To Console    ${status}
#                                       Should Be Equal As Strings      ${status}  OK
#
#
####################################################################################################################################
#BE Ceph Cleanup
####################################################################################################################################
#    [Documentation]                 *BE Ceph Cleanup*
#        ${status}                   PCC.Ceph Cleanup BE
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP_SECONDARY}
#
#                                    Should be equal as strings    ${status}    OK
#
####################################################################################################################################
#Delete All Profiles
####################################################################################################################################
#
#        [Documentation]    *PCC.Delete All Profiles* test
#                           ...  keywords:
#                           ...  PCC.Delete All Profiles
#
#
#        ${response}    PCC.Delete All Profiles
#
#                       Log To Console    ${response}
#
####################################################################################################################################
#Network Manager Delete
####################################################################################################################################
#    [Documentation]                 *Delete Network Manager if it exist*
#                               ...  keywords:
#                               ...  PCC.Network Manager Delete All
#
#        ${status}                   PCC.Network Manager Delete All
#                                    Should be equal as strings    ${status}    OK
#
#                                    sleep  2m
#
#        ${status}                   PCC.Wait Until All Nodes Are Ready
#
#                                    Log To Console    ${status}
#                                    Should Be Equal As Strings      ${status}  OK
####################################################################################################################################
#Delete Multiple Subnet
####################################################################################################################################
#    [Documentation]                 *Delete IPAM Subnet*
#                               ...  keywords:
#                               ...  PCC.Ipam Subnet Delete All
#
#        ${status}                   PCC.Ipam Subnet Delete All
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Cleanup features associated to Node
####################################################################################################################################
#    [Documentation]                 *Deleting all Pools*
#                               ...  keywords:
#                               ...  PCC.Cleanup features associated to Node
#
#        ${parent1_Id}    PCC.Get Scope Id
#                        ...  scope_name=Default region
#                        Log To Console    ${parent1_Id}
#
#        ${parent2_Id}    PCC.Get Scope Id
#                        ...  scope_name=Default zone
#                        ...  parentID=${parent1_Id}
#                        Log To Console    ${parent2_Id}
#
#        ${parent3_Id}    PCC.Get Scope Id
#                        ...  scope_name=Default site
#                        ...  parentID=${parent2_Id}
#
#                        Log To Console    ${parent3_Id}
#
#        ${scope_id}    PCC.Get Scope Id
#                       ...  scope_name=Default rack
#                       ...  parentID=${parent3_Id}
#
#                       Log To Console    ${scope_id}
#
#                ${status}       PCC.Cleanup features associated to Node
#                                                ...    scopeId=${scope_id}
#                                                Log To Console    ${status}
#                                                Should Be Equal As Strings      ${status}  OK
#
#####################################################################################################################################
#Wait Until All Nodes Are Ready
#####################################################################################################################################
#    [Documentation]                 *Cleanup all keys*
#                               ...  keywords:
#                               ...  PCC.Wait Until All Nodes Are Ready
#        ${status}                   PCC.Wait Until All Nodes Are Ready
#
#                                    Log To Console    ${status}
#                                    Should Be Equal As Strings      ${status}  OK
#
####################################################################################################################################
#Delete All Node Roles
####################################################################################################################################
#
#        [Documentation]    *Delete All Node Roles* test
#                           ...  keywords:
#                           ...  PCC.Delete all Node roles
#
#        ${status}    PCC.Delete all Node roles
#
#                     Log To Console    ${status}
#                     Should Be Equal As Strings    ${status}    OK    Node roles still exists
#
#
####################################################################################################################################
#Policy driven management cleanup
####################################################################################################################################
#
#                [Documentation]    *Policy driven management cleanup* test
#                           ...  keywords:
#                           ...  PCC.Delete Multiple Tenants
#                ###  Unassign locations from policies  ###
#                ${status}    PCC.Unassign Locations Assigned from All Policies
#
#                             Log to Console    ${status}
#                             Should Be Equal As Strings    ${status}    OK
#
#                                ####  Delete All Policies  ####
#                ${status}    PCC.Delete All Policies
#
#                             Log To Console    ${status}
#                             Should Be Equal As Strings    ${status}    OK
#
#####################################################################################################################################
#Cleanup all certificates from PCC
#####################################################################################################################################
#    [Documentation]                 *Cleanup all certificates*
#                               ...  keywords:
#                               ...  PCC.Delete All Certificates
#
#        ${status}                   PCC.Delete All Certificates
#
#                                    Log To Console    ${status}
#                                    Should be equal as strings    ${status}    OK
#
