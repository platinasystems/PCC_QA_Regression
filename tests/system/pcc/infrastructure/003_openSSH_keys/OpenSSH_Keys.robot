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
                         
                         Load OpenSSH_Keys Data    ${pcc_setup}
                         
###################################################################################################################################
Add Public Key
###################################################################################################################################
                
        
        [Documentation]    *Add Public Key* test
        
        ${response}    PCC.Add OpenSSH Key
                       ...  Alias=${PUBLIC_KEY_ALIAS}
                       ...  Description=${PUBLIC_KEY_DESCRIPTION}
                       ...  Filename=${PUBLIC_KEY}
  
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    statusCodeValue
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Delete Key
###################################################################################################################################
                
        
        [Documentation]    *Delete Key* test
        
                       
        ${response}    PCC.Delete OpenSSH Key
                       ...  Alias=${PUBLIC_KEY_ALIAS}
                       
                       Log To Console    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
