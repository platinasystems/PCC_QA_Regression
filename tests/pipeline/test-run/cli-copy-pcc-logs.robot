*** Settings ***
Resource                        pcc_resources.robot

*** Variables ***
${testdata_key}                 pcc_242


*** Test Cases ***
###################################################################################################################################
Truncate PCC Logs
###################################################################################################################################
        [Documentation]         *Truncate PCC Logs*

                                Load PCC Test Data          testdata_key=${testdata_key}

            ${result}           CLI.Copy PCC Logs
                            ...  host_ip=${PCC_HOST_IP}
                            ...  linux_user=${PCC_LINUX_USER}
                            ...  linux_password=${PCC_LINUX_PASSWORD}

                                Should Be Equal     ${result}       OK
