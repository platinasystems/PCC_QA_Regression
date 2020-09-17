*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load K8s Data    ${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Network Manager Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    Load Ipam Data    ${pcc_setup} 

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Monitor Data Availability Verify BE For CPU
################################################################################################################################### 
    [Documentation]                 *Monitor Data Availability Verify BE*
                               ...  keywords:
                               ...  PCC.Monitor Verify Data Availability BE
                                   
        ${status}                   PCC.Monitor Verify Data Availability BE
                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
                               ...  category=["cpu"]
                                    Should Be Equal As Strings      ${status}    OK   

###################################################################################################################################
Monitor Data Availability Verify BE For Memory
################################################################################################################################### 
    [Documentation]                 *Monitor Data Availability Verify BE*
                               ...  keywords:
                               ...  PCC.Monitor Verify Data Availability BE
                                   
        ${status}                   PCC.Monitor Verify Data Availability BE
                               ...  nodes_ip=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
                               ...  category=["memory"]
                                    Should Be Equal As Strings      ${status}    OK  
                                    
##################################################################################################################################
Monitor Verify Nodes Health
###################################################################################################################################   
    [Documentation]                 *Monitor Verify Nodes Health*
                               ...  keywords:
                               ...  PCC.Monitor Verify Node Health
                               
        ${status}                   PCC.Monitor Verify Node Health
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                                    Should Be Equal As Strings      ${status}    OK  
                                    
###################################################################################################################################
Monitor Data Availability Verify PCC for CPU
###################################################################################################################################    
    [Documentation]                 *Monitor Data Availability Verify PCC*
                               ...  keywords:
                               ...  PCC.Monitor Data Availability Verify PCC
                               
        ${status}                   PCC.Monitor Verify Data Availability
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  category=["cpu"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Monitor Data Availability Verify PCC for Memory
###################################################################################################################################    
    [Documentation]                 *Monitor Data Availability Verify PCC*
                               ...  keywords:
                               ...  PCC.Monitor Data Availability Verify PCC
                               
        ${status}                   PCC.Monitor Verify Data Availability
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  category=["memory"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Monitor Data Availability Verify PCC for System
###################################################################################################################################    
    [Documentation]                 *Monitor Data Availability Verify PCC*
                               ...  keywords:
                               ...  PCC.Monitor Data Availability Verify PCC
                               
        ${status}                   PCC.Monitor Verify Data Availability
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  category=["system"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Monitor Data Availability Verify PCC for Storage
###################################################################################################################################    
    [Documentation]                 *Monitor Data Availability Verify PCC*
                               ...  keywords:
                               ...  PCC.Monitor Data Availability Verify PCC
                               
        ${status}                   PCC.Monitor Verify Data Availability
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  category=["storage"]
                                    Should Be Equal As Strings      ${status}    OK     

###################################################################################################################################
Monitor Data Availability Verify PCC for Sensor
###################################################################################################################################    
    [Documentation]                 *Monitor Data Availability Verify PCC*
                               ...  keywords:
                               ...  PCC.Monitor Data Availability Verify PCC
                               
        ${status}                   PCC.Monitor Verify Data Availability
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  category=["sensor"]
                                    Should Be Equal As Strings      ${status}    OK       

###################################################################################################################################
Monitor Data Availability Verify PCC for Network
###################################################################################################################################    
    [Documentation]                 *Monitor Data Availability Verify PCC*
                               ...  keywords:
                               ...  PCC.Monitor Data Availability Verify PCC
                               
        ${status}                   PCC.Monitor Verify Data Availability
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  category=["network"]
                                    Should Be Equal As Strings      ${status}    OK      
                                    
###################################################################################################################################
Monitor Verify Services Back End (pccagent, systemCollector, frr)
###################################################################################################################################                                    
    [Documentation]                 *Monitor Verify Services Back End (pccagent, systemCollector, frr)*
                               ...  keywords:
                               ...  PCC.Node Verify Back End

        ${status}                   PCC.Node Verify Back End
                               ...  host_ips=["${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Monitor Verify Interface Counts
###################################################################################################################################                                    
    [Documentation]                 *Monitor Verify Interface Counts*
                               ...  keywords:
                               ...  PCC.Monitor Verify Interface Counts

        ${status}                   PCC.Monitor Verify Interface Counts
                               ...  nodes_ip=["${SERVER_2_HOST_IP}"]
                               ...  category=["network"]
                               ...  nodes=["${SERVER_2_NAME}"]
                                    Should Be Equal As Strings      ${status}    OK 

####################################################################################################################################
Monitor Verify Model And Serial Number
##################################################################################################################################                                    
    [Documentation]                 *Monitor Verify Model And Serial Number*
                               ...  keywords:
                               ...  PCC.Monitor Verify Model And Serial Number

        ${status}                   PCC.Node Verify Model And Serial Number
                               ...  Names=["${SERVER_2_NAME}","${SERVER_1_NAME}"]
                                    Should Be Equal As Strings      ${status}    OK
                                    
####################################################################################################################################
Monitor Verify OS And Its Version Backend
###################################################################################################################################                                    
    [Documentation]                 *Monitor Verify OS And Its Version Backend*
                               ...  keywords:
                               ...  PCC.Verify OS And Its Version Back End

        ${status}                   PCC.Verify OS And Its Version Back End
                               ...  Name=CentOS
                               ...  host_ip=${SERVER_2_HOST_IP}
                               ...  version=7
                               ...  username=pcc
                               ...  password=cals0ft
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Monitor Data Availability Verify BE For File System
################################################################################################################################### 
    [Documentation]                 *Monitor Data Availability Verify BE*
                               ...  keywords:
                               ...  PCC.Monitor Verify Data Availability BE
                                   
        ${status}                   PCC.Monitor Verify Data Availability BE
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  category=["file system"]
                                    Should Be Equal As Strings      ${status}    OK 

###################################################################################################################################
Monitor Data Availability Verify PCC for File System
###################################################################################################################################    
    [Documentation]                 *Monitor Data Availability Verify PCC*
                               ...  keywords:
                               ...  PCC.Monitor Data Availability Verify PCC
                               
        ${status}                   PCC.Monitor Verify Data Availability
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  category=["file system"]
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Monitor Node Verify Via Kafka Container
###################################################################################################################################

    [Documentation]                 *Monitor Node Verify Via Kafka Container*
                               ...  keywords:
                               ...  PCC.Node Verify Kafka Container

        ${status}                   PCC.Node Verify Kafka Container
                               ...  Names=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  Host=${PCC_HOST_IP}

                                    Should Be Equal As Strings      ${status}    OK

