*** Settings ***
Resource                        pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Copy PCC Logs
###################################################################################################################################
        [Documentation]         *Truncate PCC Logs*

                                 Load PCC Test Data        testdata_key=${pcc_setup}
            ${result}            CLI.Copy PCC Logs
                            ...  host_ip=${PCC_HOST_IP}
                            ...  linux_user=${PCC_LINUX_USER}
                            ...  linux_password=${PCC_LINUX_PASSWORD}

                                 Should Be Equal     ${result}       OK
