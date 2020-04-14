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
                         Should Be Equal    ${status}  OK
                         
                         
                         
                         Load Server2 Details    ${pcc_setup}
                         Load Container Registry Data    ${pcc_setup}
                         Load Invader1 Details    ${pcc_setup}
                         
        ${invader1_id}    PCC.Get Node Id    Name=${INVADER_1_NAME}
                         Log To Console    ${invader1_id}
                         Set Global Variable    ${invader1_id}
                         

        ${server2_id}    PCC.Get Node Id    Name=${SERVER_2_NAME}
                         Log To Console    ${server2_id}
                         Set Global Variable    ${server2_id}
                         
        ${server_id}     PCC.Get CR_Server Id    Name=${CR_NAME}
                         Log To Console    ${server_id}
                         Set Global Variable    ${server_id}
                         
###################################################################################################################################
Edit FQDN : TCP-584
###################################################################################################################################
        
        [Documentation]    *Edit FQDN* test
                           ...  keywords:
                           ...  PCC.Update Container Registry
                                   
        
        ${response}    PCC.Update Container Registry 
                       
                       ...    nodeID=${server_id}
                       ...    Name=${CR_NAME}
                       ...    fullyQualifiedDomainName=${CR_MODIFIED_FQDN}
                       ...    password=${CR_PASSWORD}
                       ...    secretKeyBase=${CR_SECRETKEYBASE}
                       ...    databaseName=${CR_DATABASENAME}
                       ...    databasePassword=${CR_DB_PWD}
                       ...    port=${CR_PORT}
                       ...    registryPort=${CR_REGISTRYPORT}
                       ...    adminState=${CR_ADMIN_STATE}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                       PCC.CR Wait For CR updation
                       ...    Name=${CR_NAME}
                       
                     
###################################################################################################################################
Edit Secret key base : TCP-584
###################################################################################################################################
        
        [Documentation]    *Edit Secret key base* test
                           ...  keywords:
                           ...  PCC.Update Container Registry
                              
        
        
        ${response}    PCC.Update Container Registry 
                       
                       ...    nodeID=${server_id}
                       ...    Name=${CR_NAME}
                       ...    fullyQualifiedDomainName=${CR_FQDN}
                       ...    password=${CR_PASSWORD}
                       ...    secretKeyBase=${CR_MODIFIED_SECRETKEYBASE}
                       ...    databaseName=${CR_DATABASENAME}
                       ...    databasePassword=${CR_DB_PWD}
                       ...    port=${CR_PORT}
                       ...    registryPort=${CR_REGISTRYPORT}
                       ...    adminState=${CR_ADMIN_STATE}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                       PCC.CR Wait For CR updation
                       ...    Name=${CR_NAME}
                       
###################################################################################################################################
Edit Portus Password : TCP-834
###################################################################################################################################
        
        [Documentation]    *Edit Portus Password* test
                           ...  keywords:
                           ...  PCC.Update Container Registry 
        
        
        ${response}    PCC.Update Container Registry 
                       
                       ...    nodeID=${server_id}
                       ...    Name=${CR_NAME}
                       ...    fullyQualifiedDomainName=${CR_FQDN}
                       ...    password=${CR_MODIFIED_PASSWORD}
                       ...    secretKeyBase=${CR_SECRETKEYBASE}
                       ...    databaseName=${CR_DATABASENAME}
                       ...    databasePassword=${CR_DB_PWD}
                       ...    port=${CR_PORT}
                       ...    registryPort=${CR_REGISTRYPORT}
                       ...    adminState=${CR_ADMIN_STATE}
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                       PCC.CR Wait For CR updation
                       ...    Name=${CR_NAME}
                       
###################################################################################################################################
Login to C-Registry using new Portus password : TCP-834
###################################################################################################################################

        [Documentation]    *Login to C-Registry using new Portus password* test
                           ...  keywords:
                           ...  PCC.CR login using docker
                            
        
        ${result}    PCC.CR login using docker
                             
                     ...    registryPort=${CR_REGISTRYPORT}
                     ...    portus_password=${CR_MODIFIED_PASSWORD}  
                     ...    fullyQualifiedDomainName=${CR_FQDN}
                     ...    portus_uname=${CR_PORTUS_UNAME}
                                     
                     Log To Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                     
####################################################################################################################################
Cleanup Container Registry
####################################################################################################################################
        
        [Documentation]    *Cleanup all CR* test
                           ...  keywords:
                           ...  PCC.Clean all CR
                           ...  PCC.Wait for deletion of CR 
        
        ${result}    PCC.Clean all CR
        
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                     
        
        ${result}    PCC.Wait for deletion of CR
                     
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK