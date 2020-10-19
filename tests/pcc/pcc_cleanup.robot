*** Settings ***
Resource                        pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

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
Cli PCC Stop
###################################################################################################################################
        [Documentation]         *Cli PCC Stop*
                   
            ${result}            CLI.Pcc Down
                            ...  host_ip=${PCC_HOST_IP}
                            ...  linux_user=${PCC_LINUX_USER}
                            ...  linux_password=${PCC_LINUX_PASSWORD}
                            ...  pcc_password=${PCC_SETUP_PWD}

                                 Should Be Equal     ${result}       OK

##################################################################################################################################
Cli PCC Cleanup
###################################################################################################################################
        [Documentation]         *Cli PCC Cleanup*

                                 Load PCC Test Data        testdata_key=${pcc_setup}
            ${result}            CLI.Pcc Cleanup
                            ...  host_ip=${PCC_HOST_IP}
                            ...  linux_user=${PCC_LINUX_USER}
                            ...  linux_password=${PCC_LINUX_PASSWORD}

                                 Should Be Equal     ${result}       OK
                                 
##################################################################################################################################
Cli PCC Platina Cli Version
###################################################################################################################################
        [Documentation]         *Cli PCC Platina Cli Version*

                                 Load PCC Test Data        testdata_key=${pcc_setup}
            ${result}            CLI.Pcc Platina Cli Version
                            ...  host_ip=${PCC_HOST_IP}
                            ...  linux_user=${PCC_LINUX_USER}
                            ...  linux_password=${PCC_LINUX_PASSWORD}
                            ...  platia_cli_version_cmd=curl https://platinadownload.auctacognitio.com/files/platina-cli/platina-cli-1.3.0.tar.gz --output platina-cli.tar.gz

                                 Should Be Equal     ${result}       OK
##################################################################################################################################
Cli PCC Pull Code
###################################################################################################################################
        [Documentation]         *Cli PCC Platina Cli Version*

                                 Load PCC Test Data        testdata_key=${pcc_setup}
            ${result}            CLI.PCC Pull Code
                            ...  host_ip=${PCC_HOST_IP}
                            ...  linux_user=${PCC_LINUX_USER}
                            ...  linux_password=${PCC_LINUX_PASSWORD}
                            ...  pcc_version_cmd=sudo /home/pcc/platina-cli-ws/platina-cli run -u ${PCC_SETUP_USERNAME} -p ${PCC_SETUP_PWD} --url https://cust-dev.lab.platinasystems.com --insecure --registryUrl https://cust-dev.lab.platinasystems.com:5000 --ru ${PCC_SETUP_USERNAME} --rp ${PCC_SETUP_PWD} --insecureRegistry --prtKey /home/pcc/i28-keys/i28-id_rsa --pblKey /home/pcc/i28-keys/i28-authorized_keys --release stable --configRepo master --pruneVolumes

                                 Should Be Equal     ${result}       OK
###################################################################################################################################
Cli PCC Set Keys
###################################################################################################################################
        [Documentation]         *Cli PCC Platina Cli Version*

                                 Load PCC Test Data        testdata_key=${pcc_setup}
            ${result}            CLI.Pcc Set Keys
                            ...  host_ip=${PCC_HOST_IP}
                            ...  linux_user=${PCC_LINUX_USER}
                            ...  linux_password=${PCC_LINUX_PASSWORD}
                            ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_2_HOST_IP}"]

                                 Should Be Equal     ${result}       OK
