*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
									Load PCC Test Data      ${pcc_setup}
									Load Clusterhead 1 Test Data    ${pcc_setup}
									Load Server 1 Test Data    ${pcc_setup}
									Load Ceph Cluster Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
PCC Version
###################################################################################################################################
    [Documentation]             *PCC Version*
                               ...  keywords:
                               ...  PCC.Get PCC Version


	${pcc_ver}                  PCC.Get PCC Version
                                ...  user=${PCC_LINUX_USER}
                                ...  password=${PCC_LINUX_PASSWORD}
                                ...  hostip=${PCC_HOST_IP}

                                Log To Console    ${pcc_ver}

###################################################################################################################################
Login Secondary
###################################################################################################################################
									Load PCC Secondary Test Data      ${pcc_setup}


        ${status}                   Login To PCC Secondary  testdata_key=${pcc_setup}
                                    Should Be Equal         ${status}  OK

###################################################################################################################################
PCC Version Secondary
###################################################################################################################################
    [Documentation]             *PCC Version*
                               ...  keywords:
                               ...  PCC.Get PCC Version


	${pcc_ver}                  PCC.Get PCC Version
                                ...  user=${PCC_LINUX_USER_SECONDARY}
                                ...  password=${PCC_LINUX_PASSWORD_SECONDARY}
                                ...  hostip=${PCC_HOST_IP_SECONDARY}

                                Log To Console    ${pcc_ver}
