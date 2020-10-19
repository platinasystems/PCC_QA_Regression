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
                         Load Certificate Data    ${pcc_setup}
                         
        
                         
###################################################################################################################################
Add Certificate with Private Keys
###################################################################################################################################
                
        
        [Documentation]    *Add Certificate* test
        
        
        ${response}    PCC.Add Certificate
                       ...  Alias=Cert_with_pvt_cert
                       ...  Description=Cert_with_pvt_cert_desc
                       ...  Private_key=Temp_private.ppk
                       ...  Certificate_upload=Certificate_to_be_uploaded.pem
  
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    statusCodeValue
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Add Certificate without Private Keys
###################################################################################################################################
                
        
        [Documentation]    *Add Certificate* test
        
        ${response}    PCC.Add Certificate
                       ...  Alias=Cert_without_pvt_cert
                       ...  Description=Cert_without_pvt_cert_desc
                       ...  Certificate_upload=Certificate_to_be_uploaded.pem
  
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    statusCodeValue
                       Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Delete Certificate
###################################################################################################################################
                
        
        [Documentation]    *Delete Certificate* test
        [Tags]    Cert
        ${response}    PCC.Delete Certificate
                       ...  Alias=Cert_without_pvt_cert
  
                       Log To Console    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       
        ${response}    PCC.Delete Certificate
                       ...  Alias=Cert_with_pvt_cert
  
                       Log To Console    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
