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
Add Private Key
###################################################################################################################################
                
        
        [Documentation]    *Add Private Key* test
        
        ${response}    PCC.Add OpenSSH_keys
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
        
        ${response}    PCC.Add OpenSSH_keys
                       ...  Alias=${PUBLIC_KEY_ALIAS}
                       ...  Description=${PUBLIC_KEY_DESCRIPTION}
                       ...  Filename=${PUBLIC_KEY}
                       ...  Type=${PUBLIC_TYPE} 
  
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    statusCodeValue
                       Should Be Equal As Strings    ${status}    200