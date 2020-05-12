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
                         
                         Load OpenSSH_Keys Data    ${pcc_setup}
                         
###################################################################################################################################
Add Private Key
###################################################################################################################################
                
        
        [Documentation]    *Add Private Key* test
        
        ${response}    PCC.Add OpenSSH Key
                       ...  Alias=${PRIVATE_KEY_ALIAS}
                       ...  Description=${PRIVATE_KEY_DESCRIPTION}
                       ...  Filename=${PRIVATE_KEY}
                       ...  Type=${PRIVATE_TYPE} 
  
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    statusCodeValue
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Add Public Key
###################################################################################################################################
                
        
        [Documentation]    *Add Public Key* test
        
        ${response}    PCC.Add OpenSSH Key
                       ...  Alias=${PUBLIC_KEY_ALIAS}
                       ...  Description=${PUBLIC_KEY_DESCRIPTION}
                       ...  Filename=${PUBLIC_KEY}
                       ...  Type=${PUBLIC_TYPE} 
  
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    statusCodeValue
                       Should Be Equal As Strings    ${status}    200
