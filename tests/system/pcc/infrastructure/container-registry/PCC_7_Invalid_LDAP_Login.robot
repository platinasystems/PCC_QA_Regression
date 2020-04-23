*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_215

*** Test Cases ***
###################################################################################################################################
Login to PCC
###################################################################################################################################
       
        [Documentation]    *Login to PCC* test
        
        ${status}        Login To PCC    ${pcc_setup}
                         Should Be Equal    ${status}  OK
                         
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         
                         Load Container Registry Data    ${pcc_setup}
                         Load Auth Profile Data    ${pcc_setup}
                         

        ${server2_id}    PCC.Get Node Id    Name=${SERVER_2_NAME}
                         Log To Console    ${server2_id}
                         Set Global Variable    ${server2_id}
                         
        ${invader1_id}    PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
                         Log To Console    ${invader1_id}
                         Set Global Variable    ${invader1_id}
                         
                         
###################################################################################################################################
Get Host IP used by CR
###################################################################################################################################
                
        [Documentation]    *Get Host IP used by CR* test
                           ...  keywords:
                           ...  PCC.Get Host IP
        
        ${host_ip}    PCC.Get Host IP
                      ...  Name=${CR_NAME} 
                      Log To Console    ${host_ip}
                      Set Global Variable    ${host_ip}
                      
###################################################################################################################################
Invalid LDAP Username While Login to C-Registry 
###################################################################################################################################

        [Documentation]    *Login to C-Registry* test
                           ...  keywords:
                           ...  PCC.CR login using docker
                          
                           
        
        ${result}    PCC.CR login using docker
                             
                     ...    registryPort=${CR_REGISTRYPORT}
                     ...    portus_password=${AUTH_PROFILE_BIND_PWD}  
                     ...    fullyQualifiedDomainName=${CR_FQDN}
                     ...    portus_uname=${INVALID_AUTH_PROFILE_UNAME}
                     ...    hostip=${host_ip}
                                     
                     Log To Console    ${result}
                     Should Not Be Equal    "${result}"    "True"
                     
###################################################################################################################################
Invalid LDAP Password While Login to C-Registry 
###################################################################################################################################

        [Documentation]    *Login to C-Registry* test
                           ...  keywords:
                           ...  PCC.CR login using docker
        
        ${result}    PCC.CR login using docker
                             
                     ...    registryPort=${CR_REGISTRYPORT}
                     ...    portus_password=${INVALID_AUTH_PROFILE_BIND_PWD}  
                     ...    fullyQualifiedDomainName=${CR_FQDN}
                     ...    portus_uname=${AUTH_PROFILE_UNAME}
                     ...    hostip=${host_ip}
                                     
                     Log To Console    ${result}
                     Should Not Be Equal    "${result}"    "True"
