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
                         Should Be Equal    ${status}  OK
                         
                         Load Container Registry Data    ${pcc_setup}
                                                  
###################################################################################################################################
Invalid Username While Login to C-Registry : TCP-846
###################################################################################################################################

        [Documentation]    *Login to C-Registry* test
                           ...  keywords:
                           ...  PCC.CR login using docker
                           
        
        ${result}    PCC.CR login using docker
                             
                     ...    registryPort=${CR_REGISTRYPORT}
                     ...    portus_password=${CR_PASSWORD}  
                     ...    fullyQualifiedDomainName=${CR_FQDN}
                     ...    portus_uname=${CR_PORTUS_INVALID_UNAME}
                                     
                     Log To Console    ${result}
                     Should Not Be Equal    "${result}"    "OK"
                     
###################################################################################################################################
Invalid Password While Login to C-Registry : TCP-845
###################################################################################################################################

        [Documentation]    *Login to C-Registry* test
                           ...  keywords:
                           ...  PCC.CR login using docker
        
        ${result}    PCC.CR login using docker
                             
                     ...    registryPort=${CR_REGISTRYPORT}
                     ...    portus_password=${CR_INVALID_PASSWORD}  
                     ...    fullyQualifiedDomainName=${CR_FQDN}
                     ...    portus_uname=${CR_PORTUS_UNAME}
                                     
                     Log To Console    ${result}
                     Should Not Be Equal    "${result}"    "OK"
