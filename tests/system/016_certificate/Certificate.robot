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
Fetching Certificate ID before backup
###################################################################################################################################                       
        
        ${certificate_id_before_backup}    PCC.Get Certificate Id
                                           ...    Alias=Cert_with_pvt_cert
                                           
                                           Log To Console    ${certificate_id_before_backup}
                                           Set Global Variable    ${certificate_id_before_backup}
                       
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
                       

