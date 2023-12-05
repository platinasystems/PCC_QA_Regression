*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Clusterhead 1 Test Data        ${pcc_setup}
                                    Load Server 1 Test Data        ${pcc_setup}
                                    Load Server 2 Test Data        ${pcc_setup}
                                    Load Server 3 Test Data        ${pcc_setup}
                                    
        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK
                                    
#####################################################################################################################################
Install net-tools on nodes
#####################################################################################################################################

    [Documentation]    *Install net-tools on nodes* test                 
    [Tags]    add
    
    ${status}    Install net-tools command
                 

                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK
