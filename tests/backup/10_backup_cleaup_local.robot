*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***

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

