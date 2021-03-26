*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Clusterhead 1 Test Data        ${pcc_setup}
                                    Load Clusterhead 2 Test Data        ${pcc_setup}
                                    
                                    Load Server 1 Test Data        ${pcc_setup}
                                    Load Server 2 Test Data        ${pcc_setup}
                                    Load Server 3 Test Data        ${pcc_setup}
                                    
        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK
                                    
#####################################################################################################################################
Install s3cmd utility on nodes
#####################################################################################################################################

    [Documentation]    *Install s3cmd on nodes* test                 
    [Tags]    add
    
    ${status}    Install s3cmd command
                 
                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK
