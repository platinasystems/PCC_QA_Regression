*** Settings ***
Resource                        pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Ipam Data    ${pcc_setup}
                                    Load Network Manager Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

##################################################################################################################################
Cli PCC Pull Code
###################################################################################################################################
        [Documentation]         *Cli PCC Pull Code*

            ${result}            CLI.PCC Pull Code
                            ...  host_ip=${PCC_HOST_IP}
                            ...  linux_user=${PCC_LINUX_USER}
                            ...  linux_password=${PCC_LINUX_PASSWORD}
                            ...  pcc_version_cmd=sudo /home/pcc/platina-cli-ws/platina-cli pull --configRepo master -p ${PCC_SETUP_PWD}

                                 Should Be Equal     ${result}       OK
                                 
###################################################################################################################################
Cli PCC Set Keys
###################################################################################################################################
        [Documentation]         *Cli PCC Set Keys*

                                 Load PCC Test Data        testdata_key=${pcc_setup}
            ${result}            CLI.Pcc Set Keys
                            ...  host_ip=${PCC_HOST_IP}
                            ...  linux_user=${PCC_LINUX_USER}
                            ...  linux_password=${PCC_LINUX_PASSWORD}
                            ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_2_HOST_IP}"]

                                 Should Be Equal     ${result}       OK
