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
                         Load Certificate Data    ${pcc_setup}
                         
        
                         
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
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
