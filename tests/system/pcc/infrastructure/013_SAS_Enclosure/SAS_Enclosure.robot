*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_218

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK
                                    
###################################################################################################################################
Get SAS Enclosures
###################################################################################################################################
    [Documentation]                 *Get SAS Enclosures*
                                     ...  Keywords:
                                     ...  PCC.Get SAS Enclosures
    

        ${status}                   PCC.Get SAS Enclosures
                               
                                    ...  auth_data=${PCC_CONN}
                                    ...  setup_ip=${PCC_HOST_IP}
                                    ...  user=${PCC_LINUX_USER}
                                    ...  password=${PCC_LINUX_PASSWORD}
                             
                                    Should Be Equal As Strings      ${status}    OK