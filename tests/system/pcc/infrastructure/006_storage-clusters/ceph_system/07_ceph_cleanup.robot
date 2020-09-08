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
#
#                                    Load Ceph Rbd Data    ${pcc_setup}
#                                    Load Ceph Pool Data    ${pcc_setup}
#                                    Load Ceph Cluster Data    ${pcc_setup}
#                                    Load Ceph Fs Data    ${pcc_setup}
#                                    Load Clusterhead 1 Test Data    ${pcc_setup}
#                                    Load Clusterhead 2 Test Data    ${pcc_setup}
#                                    Load Server 1 Test Data    ${pcc_setup}
#                                    Load Server 2 Test Data    ${pcc_setup}
#                                    Load K8s Data    ${pcc_setup}
#                                    Load Network Manager Data    ${pcc_setup}
#
#        ${status}                   Login To PCC        testdata_key=${pcc_setup}
#                                    Should Be Equal     ${status}  OK
#                                    
####################################################################################################################################
#Ceph Fs Delete
####################################################################################################################################
#    [Documentation]                 *Delete Fs if it exist*   
#                               ...  keywords:
#                               ...  PCC.Ceph Get Fs Id
#                               ...  PCC.Ceph Delete Fs
#                               ...  PCC.Ceph Wait Until Fs Deleted
#
#        ${id}                       PCC.Ceph Get Fs Id
#                               ...  name=${CEPH_FS_NAME}
#                                    Pass Execution If    ${id} is ${None}    Fs is alredy Deleted
#
#        ${response}                 PCC.Ceph Delete Fs
#                               ...  id=${id}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Fs Deleted
#                               ...  id=${id}
#                                    Should Be Equal     ${status}  OK
#                                    
####################################################################################################################################
#Ceph Rbd Delete
####################################################################################################################################
#    [Documentation]                 *Ceph Rbd Delete*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Rbd Id
#                               ...  PCC.Ceph Delete Rbd
#                               ...  PCC.Ceph Wait Until Rbd Deleted
#
#        ${id}                       PCC.Ceph Get Rbd Id
#                               ...  name=${CEPH_RBD_NAME}
#                                    Pass Execution If    ${id} is ${None}    Rbd is alredy Deleted
#
#        ${response}                 PCC.Ceph Delete Rbd
#                               ...  id=${id}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rbd Deleted
#                               ...  id=${id}
#                                    Should Be Equal     ${status}  OK
#
####################################################################################################################################
#Ceph Rbd Delete Multiple
####################################################################################################################################
#    [Documentation]                 *Ceph Rbd Delete Multiple*
#                               ...  keywords:
#                               ...  PCC.Ceph Delete All Rbds
#
#
#        ${status}                   PCC.Ceph Delete All Rbds
#                                    Should Be Equal     ${status}  OK
#                               
####################################################################################################################################
#Ceph Pool Single Delete
####################################################################################################################################
#    [Documentation]                 *Deleting single pool*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Pool Id
#                               ...  PCC.Ceph Delete Pool
#                               ...  PCC.Ceph Wait Until Pool Deleted
#
#
#       ${id}                        PCC.Ceph Get Pool Id
#                               ...  name=${CEPH_POOL_NAME}
#                                    Pass Execution If    ${id} is ${None}    Pool is alredy Deleted
#
#        ${response}                 PCC.Ceph Delete Pool
#                               ...  id=${id}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Deleted
#                               ...  id=${id}
#                                    Should Be Equal     ${status}  OK
#
####################################################################################################################################
#Ceph Pool Multiple Delete
####################################################################################################################################
#    [Documentation]                 *Deleting all Pools*
#                               ...  keywords:
#                               ...  CC.Ceph Delete All Pools
#                               
#        ${status}                   PCC.Ceph Delete All Pools
#                                    Should Be Equal     ${status}  OK
#                                 
