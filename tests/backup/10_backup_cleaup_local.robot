*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

        ## aa_infra
                                    Load Clusterhead 1 Test Data        ${pcc_setup}
                                    Load Clusterhead 2 Test Data        ${pcc_setup}
                                    Load Server 2 Test Data        ${pcc_setup}
                                    Load Server 1 Test Data        ${pcc_setup}
                                    Load Server 3 Test Data        ${pcc_setup}
                                    Load PCC Test Data      ${pcc_setup}

#        ${status}                   Login To PCC        testdata_key=${pcc_setup}
#                                    Should Be Equal     ${status}  OK


##################################################################################################################################
Prune Volumes And Perform Fresh Install
###################################################################################################################################

        [Documentation]    *Prune Volumes And Perform Fresh Install* test

        ${result}                  CLI.Pcc Down
                              ...  host_ip=${PCC_HOST_IP}
                              ...  linux_user=${PCC_LINUX_USER}
                              ...  linux_password=${PCC_LINUX_PASSWORD}
                              ...  pcc_password=${PCC_SETUP_PWD}

                                   Should Be Equal     ${result}       OK

        ${result}                  CLI.Pcc Cleanup
                              ...  host_ip=${PCC_HOST_IP}
                              ...  linux_user=${PCC_LINUX_USER}
                              ...  linux_password=${PCC_LINUX_PASSWORD}
                                   Should Be Equal     ${result}       OK

        ${result}                  CLI.PCC Pull Code
                              ...  host_ip=${PCC_HOST_IP}
                              ...  linux_user=${PCC_LINUX_USER}
                              ...  linux_password=${PCC_LINUX_PASSWORD}
                              ...  pcc_version_cmd=${PCC_SETUP_UPGRADE_CMD}
                                   Should Be Equal     ${result}       OK

        ${result}                  CLI.Pcc Set Keys
                              ...  host_ip=${PCC_HOST_IP}
                              ...  linux_user=${PCC_LINUX_USER}
                              ...  linux_password=${PCC_LINUX_PASSWORD}
                              ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_2_HOST_IP}"]

                                   Should Be Equal     ${result}       OK

