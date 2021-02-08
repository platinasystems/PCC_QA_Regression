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
#                                    Load Ipam Data    ${pcc_setup}
#                                    Load K8s Data    ${pcc_setup}
#                                    Load Ceph Cluster Data    ${pcc_setup}
#                                    Load Network Manager Data    ${pcc_setup}
#                                    Load Clusterhead 1 Test Data    ${pcc_setup}
#                                    Load Clusterhead 2 Test Data    ${pcc_setup}
#                                    Load Server 1 Test Data    ${pcc_setup}
#                                    Load Server 2 Test Data    ${pcc_setup}
#                                    Load Server 3 Test Data    ${pcc_setup}
#                                    
#        ${status}                   Login To PCC        testdata_key=${pcc_setup}
#                                    Should Be Equal     ${status}  OK
#                                    
####################################################################################################################################
#Set Interfaces For Upstrean Route
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For Server Falling in DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth28
#                               ...  assign_ip=["10.0.10.15/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=100000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#                               
#        ${status_code}              Get Response Status Code        ${response} 
#        ${message}                  Get Response Message        ${response}          
#                                    Should Be Equal As Strings      ${status_code}  200
#                               
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response} 
#        ${message}                  Get Response Message        ${response}        
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth28
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth28
#                               ...  assign_ip=["10.0.10.15/31"]
#                                    Should Be Equal As Strings      ${status}    OK 
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth30
#                               ...  assign_ip=["10.0.10.11/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=100000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}     
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth30
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth30
#                               ...  assign_ip=["10.0.10.11/31"]
#                                    Should Be Equal As Strings      ${status}    OK 
#
#############################################################
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth28
#                               ...  assign_ip=["10.0.10.13/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=100000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#                               
#        ${status_code}              Get Response Status Code        ${response}   
#        ${message}                  Get Response Message        ${response}        
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}   
#        ${message}                  Get Response Message        ${response}           
#                                    Should Be Equal As Strings      ${status_code}  200
#                                 
#                                    
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth28
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth28
#                               ...  assign_ip=["10.0.10.13/31"]
#                                    Should Be Equal As Strings      ${status}    OK 
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth30
#                               ...  assign_ip=["10.0.10.9/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=100000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}    
#        ${message}                  Get Response Message        ${response}          
#                                    Should Be Equal As Strings      ${status_code}  200
#                                                                   
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth30
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth30
#                               ...  assign_ip=["10.0.10.9/31"]
#                                    Should Be Equal As Strings      ${status}    OK 
#                                    
####################################################################################################################################
#Network Manager Creation Upstream 
####################################################################################################################################
#    [Documentation]                 *Network Manager Creation*
#                               ...  keywords:
#                               ...  PCC.Network Manager Create
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE   
#
#                                    Sleep    60s
#        ${response}                 PCC.Network Manager Create
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${SERVER_3_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
#                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
#                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  igwPolicy=upstream
#                               ...  bgp_neighbors=${NETWORK_MANAGER_BGP_NEIGHBORS}
#                                                      
#        ${status_code}              Get Response Status Code        ${response}    
#        ${message}                  Get Response Message        ${response}        
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                  
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify Upstream BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
#                                    Should Be Equal As Strings      ${status}  OK      
#
#        ${status}                   Ping Check
#                               ...  node_names=["${SERVER_2_NAME}","${SERVER_3_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
#                                    Should Be Equal As Strings      ${status}  OK
#                                    
#        ${status}                   PCC.Network Manager Verify BE      
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP} 
#                                    Should Be Equal As Strings      ${status}  OK
#                                    
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set One Interfaces For Upstrean Route As Down
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For Server Falling in DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth28
#                               ...  assign_ip=["10.0.10.15/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=100000
#                               ...  adminstatus=DOWN
#                               ...  cleanUp=yes
#                               
#        ${status_code}              Get Response Status Code        ${response}   
#        ${message}                  Get Response Message        ${response}        
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response} 
#        ${message}                  Get Response Message        ${response}        
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth28
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth28
#                               ...  assign_ip=["10.0.10.15/31"]
#                                    Should Be Equal As Strings      ${status}    OK 
#
####################################################################################################################################
#Network Manager Upstream Verification After One Interface Down
####################################################################################################################################
#        ${status}                   PCC.Network Manager Verify Upstream BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
#                                    Should Be Equal As Strings      ${status}  OK      
#
#        ${status}                   Ping Check
#                               ...  node_names=["${SERVER_2_NAME}","${SERVER_3_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
#                                    Should Be Equal As Strings      ${status}  OK 
# 
####################################################################################################################################
#Set All Interfaces For Upstrean Route As Down
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For Server Falling in DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth28
#                               ...  assign_ip=["10.0.10.15/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=100000
#                               ...  adminstatus=DOWN
#                               ...  cleanUp=yes
#                               
#        ${status_code}              Get Response Status Code        ${response} 
#        ${message}                  Get Response Message        ${response}          
#                                    Should Be Equal As Strings      ${status_code}  200
#                               
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response} 
#        ${message}                  Get Response Message        ${response}        
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth28
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth28
#                               ...  assign_ip=["10.0.10.15/31"]
#                                    Should Be Equal As Strings      ${status}    OK 
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth30
#                               ...  assign_ip=["10.0.10.11/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=100000
#                               ...  adminstatus=DOWN
#                               ...  cleanUp=yes
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}     
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth30
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth30
#                               ...  assign_ip=["10.0.10.11/31"]
#                                    Should Be Equal As Strings      ${status}    OK 
#
#############################################################
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth28
#                               ...  assign_ip=["10.0.10.13/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=100000
#                               ...  adminstatus=DOWN
#                               ...  cleanUp=yes
#                               
#        ${status_code}              Get Response Status Code        ${response}   
#        ${message}                  Get Response Message        ${response}        
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}   
#        ${message}                  Get Response Message        ${response}           
#                                    Should Be Equal As Strings      ${status_code}  200
#                                 
#                                    
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth28
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth28
#                               ...  assign_ip=["10.0.10.13/31"]
#                                    Should Be Equal As Strings      ${status}    OK 
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth30
#                               ...  assign_ip=["10.0.10.9/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=100000
#                               ...  adminstatus=DOWN
#                               ...  cleanUp=yes
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}    
#        ${message}                  Get Response Message        ${response}          
#                                    Should Be Equal As Strings      ${status_code}  200
#                                                                   
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth30
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth30
#                               ...  assign_ip=["10.0.10.9/31"]
#                                    Should Be Equal As Strings      ${status}    OK 
#
####################################################################################################################################
#Network Manager Upstream Verification After All Interface Down (Negative)
####################################################################################################################################
#        ${status}                   PCC.Network Manager Verify Upstream BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
#                                    Should Not Be Equal As Strings      ${status}  OK      
#
#        ${status}                   Ping Check
#                               ...  node_names=["${SERVER_2_NAME}","${SERVER_3_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
#                                    Should Not Be Equal As Strings      ${status}  OK 
#                                    
####################################################################################################################################
#Set All Interfaces For Upstrean Route As Up
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For Server Falling in DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth28
#                               ...  assign_ip=["10.0.10.15/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=100000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#                               
#        ${status_code}              Get Response Status Code        ${response} 
#        ${message}                  Get Response Message        ${response}          
#                                    Should Be Equal As Strings      ${status_code}  200
#                               
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response} 
#        ${message}                  Get Response Message        ${response}        
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth28
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth28
#                               ...  assign_ip=["10.0.10.15/31"]
#                                    Should Be Equal As Strings      ${status}    OK 
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth30
#                               ...  assign_ip=["10.0.10.11/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=100000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}     
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth30
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth30
#                               ...  assign_ip=["10.0.10.11/31"]
#                                    Should Be Equal As Strings      ${status}    OK 
#
#############################################################
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth28
#                               ...  assign_ip=["10.0.10.13/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=100000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#                               
#        ${status_code}              Get Response Status Code        ${response}   
#        ${message}                  Get Response Message        ${response}        
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}   
#        ${message}                  Get Response Message        ${response}           
#                                    Should Be Equal As Strings      ${status_code}  200
#                                 
#                                    
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth28
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth28
#                               ...  assign_ip=["10.0.10.13/31"]
#                                    Should Be Equal As Strings      ${status}    OK 
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth30
#                               ...  assign_ip=["10.0.10.9/31"]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=100000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#                               
#        ${status_code}              Get Response Status Code        ${response}     
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}    
#        ${message}                  Get Response Message        ${response}          
#                                    Should Be Equal As Strings      ${status_code}  200
#                                                                   
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth30
#                                    Should Be Equal As Strings      ${status}    OK  
#
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth30
#                               ...  assign_ip=["10.0.10.9/31"]
#                                    Should Be Equal As Strings      ${status}    OK 
#                                    
####################################################################################################################################
#Network Manager Refresh After All Interfaces Are UP 
####################################################################################################################################
#    [Documentation]                 *Network Manager Refresh Interfaces For Server Falling in DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Network Manager Refresh
#                               ...  PCC.Wait Until Network Manager Ready
#                               ...  PCC.Network Manager Verify BE
#                               
#        ${response}                 PCC.Network Manager Refresh
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK 
#
#        ${status}                   PCC.Network Manager Verify BE      
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Be Equal As Strings      ${status}  OK
#
#        ${status}                   Ping Check
#                               ...  node_names=["${SERVER_2_NAME}","${SERVER_3_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
#                                    Should Be Equal As Strings      ${status}  OK
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK 
#
####################################################################################################################################
#Network Manager Upstream Verification After All Interface Up
####################################################################################################################################
#        ${status}                   PCC.Network Manager Verify Upstream BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
#                                    Should Be Equal As Strings      ${status}  OK   
# 
#        ${status}                   Ping Check
#                               ...  node_names=["${SERVER_2_NAME}","${SERVER_3_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
#                                    Should Be Equal As Strings      ${status}  OK
#                                    
####################################################################################################################################
#Network Manager Update Upstream (Delete one invader)
####################################################################################################################################
#    [Documentation]                 *Network Manager Update*
#                               ...  keywords:
#                               ...  PCC.Network Manager Update
#                               ...  PCC.Wait Until Network Manager Ready
#
#        ${network_id}               PCC.Get Network Manager Id
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${response}                 PCC.Network Manager Update
#                               ...  id=${network_id}
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               ...  nodes=["${SERVER_2_NAME}","${SERVER_3_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
#                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
#                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  igwPolicy=upstream
#                               ...  bgp_neighbors=${NETWORK_MANAGER_BGP_NEIGHBORS}
#                                                      
#        ${status_code}              Get Response Status Code        ${response}  
#        ${message}                  Get Response Message        ${response}         
#                                    Should Be Equal As Strings      ${status_code}  200
#
# 
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify Upstream BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]
#                                    Should Be Equal As Strings      ${status}  OK      
#
#        ${status}                   Ping Check
#                               ...  node_names=["${SERVER_2_NAME}","${SERVER_3_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
#                                    Should Be Equal As Strings      ${status}  OK
#                                    
#        ${status}                   PCC.Network Manager Verify BE      
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP} 
#                                    Should Be Equal As Strings      ${status}  OK
#                                    
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#                                    
####################################################################################################################################
#Network Manager Update Upstream (Delete one server)
####################################################################################################################################
#    [Documentation]                 *Network Manager Update*
#                               ...  keywords:
#                               ...  PCC.Network Manager Update
#                               ...  PCC.Wait Until Network Manager Ready
#
#        ${network_id}               PCC.Get Network Manager Id
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${response}                 PCC.Network Manager Update
#                               ...  id=${network_id}
#                               ...  name=${NETWORK_MANAGER_NAME}
#                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
#                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
#                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
#                               ...  igwPolicy=upstream
#                               ...  bgp_neighbors=${NETWORK_MANAGER_BGP_NEIGHBORS}
#                                                      
#        ${status_code}              Get Response Status Code        ${response}     
#        ${message}                  Get Response Message        ${response}
#
#                                    Should Be Equal As Strings      ${status_code}  200
#                                  
#        ${status}                   PCC.Wait Until Network Manager Ready
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify Upstream BE
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]
#                                    Should Be Equal As Strings      ${status}  OK      
#
#        ${status}                   Ping Check
#                               ...  node_names=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
#                                    Should Be Equal As Strings      ${status}  OK
#
#        ${status}                   PCC.Network Manager Verify BE      
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP} 
#                                    Should Be Equal As Strings      ${status}  OK
#                                    
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK      
#
####################################################################################################################################
#Network Manager Delete Upstream
####################################################################################################################################
#    [Documentation]                 *Network Manager Delete Interjfaces For Server Falling in DataCIDR*
#                               ...  keywords:
#                               ...  PCC.Network Manager Delete
#                               ...  PCC.Wait Until Network Manager Deleted
#
#        ${response}                 PCC.Network Manager Delete
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}   
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    
#        ${status}                   PCC.Wait Until Network Manager Deleted
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Network Manager Verify BE      
#                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
#                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
#                                    Should Not Be Equal As Strings      ${status}  OK
#                                    
#
