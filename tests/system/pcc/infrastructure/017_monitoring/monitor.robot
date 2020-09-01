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
Monitor Data Availability Verify BE
###################################################################################################################################                                    
        ${status}                   PCC.Monitor Verify Data Availability BE
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
                               ...  category=["cpu","memory"]
                                    Should Be Equal As Strings      ${status}    OK   

##################################################################################################################################
Monitor Verify Nodes Health
###################################################################################################################################                                    
        ${status}                   PCC.Monitor Verify Node Health
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                                    Should Be Equal As Strings      ${status}    OK  
###################################################################################################################################
Monitor Data Availability Verify PCC
###################################################################################################################################                                    
        ${status}                   PCC.Monitor Verify Data Availability
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  category=["cpu","memory","system","sensor","network","storage"]
                                    Should Be Equal As Strings      ${status}    OK 
###################################################################################################################################
Monitor Verify Services Back End (pccagent, systemCollector, frr)
###################################################################################################################################                                    
        ${status}                   PCC.Node Verify Back End
                               ...  host_ips=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK

####################################################################################################################################
Monitor Verify Model And Serial Number
##################################################################################################################################                                    
        ${status}                   PCC.Node Verify Model And Serial Number
                               ...  Names=["${SERVER_2_NAME}","${SERVER_1_NAME}"]
                                    Should Be Equal As Strings      ${status}    OK
                                    
####################################################################################################################################
Monitor Verify OS And Its Version Backend
###################################################################################################################################                                    
        ${status}                   PCC.Verify OS And Its Version Back End
                               ...  Name=CentOS
                               ...  host_ip=${SERVER_2_HOST_IP}
                               ...  version=7
                               ...  username=pcc
                               ...  password=cals0ft
                                    Should Be Equal As Strings      ${status}    OK