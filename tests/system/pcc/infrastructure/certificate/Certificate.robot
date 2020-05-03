*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_242

*** Test Cases ***
###################################################################################################################################
Login to PCC 
###################################################################################################################################
                
        
        [Documentation]    *Login to PCC* test
        
        
        ${status}        Login To PCC    ${pcc_setup}
                         
                         Load Server2 Details    ${pcc_setup}
                         Load Container Registry Data    ${pcc_setup}
                         Load Invader1 Details    ${pcc_setup}
                         Load Certificate Data    ${pcc_setup}
                         
        ${server2_id}    PCC.Get Node Id    Name=${SERVER_2_NAME}
                         Log To Console    ${server2_id}
                         Set Global Variable    ${server2_id}
                         
        ${invader1_id}    PCC.Get Node Id    Name=${INVADER_1_NAME}
                         Log To Console    ${invader1_id}
                         Set Global Variable    ${invader1_id}
                         
###################################################################################################################################
Add Certificate
###################################################################################################################################
                
        
        [Documentation]    *Add Certificate* test
        
        ${response}    PCC.Add Certificate
                       ...  Alias=${ALIAS}
                       ...  Description=${DESCRIPTION}
                       ...  Filename=${FILENAME} 
  
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    statusCodeValue
                       Should Be Equal As Strings    ${status}    200
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        