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
#                                    Load Clusterhead 1 Test Data    ${pcc_setup}
#                                    Load Clusterhead 2 Test Data    ${pcc_setup}
#                                    Load Server 1 Test Data    ${pcc_setup}
#                                    Load Server 2 Test Data    ${pcc_setup}
#                                    Load Server 3 Test Data    ${pcc_setup}
#
#        ${status}                   Login To PCC        testdata_key=${pcc_setup}
#                                    Should Be Equal     ${status}  OK
#
####### Commenting interface cleanup code for pcc242 nodes ######
#
####################################################################################################################################
#Set Interfaces For ${CLUSTERHEAD_1_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${CLUSTERHEAD_1_NAME}(i43)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth5
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=40000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth5
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth5
#                               ...  assign_ip=[]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth1-1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth1-1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth1-1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth1-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth1-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth1-2
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${CLUSTERHEAD_2_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${CLUSTERHEAD_2_NAME} (i42)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth5
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=40000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth5
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth5
#                               ...  assign_ip=[]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth1-1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth1-1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth1-1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth1-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth1-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth1-2
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${SERVER_1_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${SERVER_1_NAME}*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp129s0
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_1_NAME}
#                               ...  interface_name=enp129s0
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp129s0
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp129s0d1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_1_NAME}
#                               ...  interface_name=enp129s0d1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp129s0d1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${SERVER_2_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${SERVER_2_NAME} (sv125)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp129s0
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_2_NAME}
#                               ...  interface_name=enp129s0
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp129s0
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp129s0d1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_2_NAME}
#                               ...  interface_name=enp129s0d1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp129s0d1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${SERVER_3_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${SERVER_3_NAME} (sv110)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=p3p1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=40000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_3_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_3_NAME}
#                               ...  interface_name=p3p1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=p3p1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=p3p2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=40000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_3_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_3_NAME}
#                               ...  interface_name=p3p2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=p3p2
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK

#
######### Uncommenting cleanup script for 212 nodes ###########
#
####################################################################################################################################
#Set Interfaces For ${CLUSTERHEAD_1_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${CLUSTERHEAD_1_NAME}(i43)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth6-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth6-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth6-2
#                               ...  assign_ip=[]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-2
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${CLUSTERHEAD_2_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${CLUSTERHEAD_2_NAME} (i42)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth6-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth6-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth6-2
#                               ...  assign_ip=[]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-2
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${SERVER_1_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${SERVER_1_NAME}*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${SERVER_2_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${SERVER_2_NAME} (sv125)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_2_NAME}
#                               ...  interface_name=enp130s0
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_2_NAME}
#                               ...  interface_name=enp130s0d1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${SERVER_3_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${SERVER_3_NAME} (sv110)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=ens2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_3_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_3_NAME}
#                               ...  interface_name=ens2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=ens2
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=ens2d1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_3_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_3_NAME}
#                               ...  interface_name=ens2d1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=ens2d1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
