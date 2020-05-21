*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_218

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
                         
        ${server1_id}    PCC.Get Node Id    Name=${SERVER_1_NAME}
                         Log To Console    ${server1_id}
                         Set Global Variable    ${server1_id}
                         
        ${server2_id}    PCC.Get Node Id    Name=${SERVER_2_NAME}
                         Log To Console    ${server2_id}
                         Set Global Variable    ${server2_id}
                         
        ${invader1_id}    PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
                         Log To Console    ${invader1_id}
                         Set Global Variable    ${invader1_id}
        
        ${server_id}     PCC.Get CR_Server Id    Name=${CR_NAME}
                         Log To Console    ${server_id}
                         Set Global Variable    ${server_id}
                         
###################################################################################################################################
Name validation on CR where name is null : TCP-841 
###################################################################################################################################
        
        [Documentation]    *Name validation on CR where name is null* test
                           ...  keywords:
                           ...  PCC.Update Container Registry
                           
                           
        ${response}    PCC.Update Container Registry 
                       
                       ...    nodeID=${server_id}
                       ...    Name=""
                       ...    fullyQualifiedDomainName=${CR_FQDN}
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
                       Should Not Be Equal    "${status}"    "200"

                       
###################################################################################################################################
Name validation on CR where name is invalid : TCP-827 
###################################################################################################################################
        
        [Documentation]    *Name validation on CR where name is invalid* test
                           ...  keywords:
                           ...  PCC.Update Container Registry                       
                       
        
        ${response}    PCC.Update Container Registry 
                       
                       ...    nodeID=${server_id}
                       ...    Name=${INVALID_CR_NAME}
                       ...    fullyQualifiedDomainName=${CR_FQDN}
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
                       Should Not Be Equal    "${status}"    "200"
                       
###################################################################################################################################
FQDN validation on CR where FQDN is null : TCP-840
###################################################################################################################################
        
        [Documentation]    *FQDN validation on CR where FQDN is null* test
                           ...  keywords:
                           ...  PCC.Update Container Registry 
        
        
        ${response}    PCC.Update Container Registry 
                       
                       ...    nodeID=${server_id}
                       ...    Name=${CR_NAME}
                       ...    fullyQualifiedDomainName=""
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
                       Should Not Be Equal    "${status}"    "200"

###################################################################################################################################
FQDN validation on CR where FQDN is invalid : TCP-828
###################################################################################################################################
        
        [Documentation]    *FQDN validation on CR where FQDN is invalid* test
                           ...  keywords:
                           ...  PCC.Update Container Registry                       
        
        
        ${response}    PCC.Update Container Registry 
                       
                       ...    nodeID=${server_id}
                       ...    Name=${CR_NAME}
                       ...    fullyQualifiedDomainName=${CR_INVALID_FQDN}
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
                       Should Not Be Equal    "${status}"    "200"
                       
                       
###################################################################################################################################
Portus Password validation on CR where Portus Password is null : TCP-842
###################################################################################################################################
        
        [Documentation]    *Name validation on CR where Portus Password is null* test
                           ...  keywords:
                           ...  PCC.Update Container Registry 
        
        
        ${response}    PCC.Update Container Registry 
                       
                       ...    nodeID=${server_id}
                       ...    Name=${CR_NAME}
                       ...    fullyQualifiedDomainName=${CR_FQDN}
                       ...    password=""
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
                       Should Not Be Equal    "${status}"    "200"
                       
                       
###################################################################################################################################
Secret key Base validation on CR where Secret key Base is null : TCP-831
###################################################################################################################################
        
        [Documentation]    *Name validation on CR* test
                           ...  keywords:
                           ...  PCC.Update Container Registry
        
        
        ########  Check if CR is getting updated if Secret key Base is null   #################################
        
        
        ${response}    PCC.Update Container Registry 
                       
                       ...    nodeID=${server_id}
                       ...    Name=${CR_NAME}
                       ...    fullyQualifiedDomainName=${CR_FQDN}
                       ...    password=${CR_PASSWORD}
                       ...    secretKeyBase=""
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
                       Should Not Be Equal    "${status}"    "200"
                       
###################################################################################################################################
StorageLocation validation on CR where Storage Location is invalid
###################################################################################################################################
        
        [Documentation]         *StorageLocation validation* test
                                ...  keywords:
                                ...  PCC.Create Container Registry

        ${response}    PCC.Update Container Registry 
                       
                       ...    nodeID=${server_id}
                       ...    storageLocation=${CR_INVALID_STORAGE_LOCATION}
                       ...    Name=${CR_NAME}
                       ...    fullyQualifiedDomainName=${CR_FQDN}
                       ...    password=${CR_PASSWORD}
                       ...    secretKeyBase=""
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
                       Should Not Be Equal    "${status}"    "200"


###################################################################################################################################
Creating two Container Registry on same server should be rejected
###################################################################################################################################
        
        [Documentation]         *Create CR* test
                                ...  keywords:
                                ...  PCC.Create Container Registry

        
                       
        ${response}    PCC.Create Container Registry 
                       ...    nodeID=${invader1_id}
                       ...    Name=invalidCR_name
                       ...    fullyQualifiedDomainName=${CR_FQDN}
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
                       Should Not Be Equal    "${status}"    "200"
