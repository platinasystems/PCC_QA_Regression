*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC 
###################################################################################################################################
                
        
        [Documentation]    *Login to PCC* test
        
        
        ${status}        Login To PCC    ${pcc_setup}
                         
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         
                         
                   
###################################################################################################################################
Check LLDP Show Neighbors
###################################################################################################################################

        [Documentation]    *Check LLDP Show Neighbors* test
                           ...  keywords:
                           ...  PCC.Verify LLDP Neighbors

        ${status}    PCC.Verify LLDP Neighbors
                     ...    servers_hostip=['${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}']
                     ...    invaders_hostip=['${CLUSTERHEAD_1_HOST_IP}']
                       
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK
                     