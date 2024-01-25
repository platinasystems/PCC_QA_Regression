*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
									Load PCC Test Data      ${pcc_setup}

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
                                ...  keypath=${PCC_LINUX_KEY_PATH}
                                ...  hostip=${PCC_HOST_IP}

                                Log To Console    ${pcc_ver}


###################################################################################################################################
Enable MF Authentication
###################################################################################################################################
    [Documentation]             *Enable MF Authentication*

    ${status}                   PCC.Enable MF Authentication

                                Should be equal as strings    ${status}    OK



###################################################################################################################################
Login Without MF Authentication (Negative)
###################################################################################################################################
    [Documentation]             *Login Without MF Authentication (Negative)*

    ${response}                      PCC.Login
                                ...  url=${PCC_URL}
                                ...  username=${PCC_USERNAME}
                                ...  password=${PCC_PASSWORD}

    ${status}                   Get From Dictionary    ${response}    status_code
                                Should Not Be Equal As Strings    ${status}    200



###################################################################################################################################
Login With MF Authentication
###################################################################################################################################
    [Documentation]             *Login With MF Authentication*

    ${otp}                      PCC.Generate OTP

    ${PCC_CONN}                 PCC.Login
                                ...  url=${PCC_URL}
                                ...  username=${PCC_USERNAME}
                                ...  password=${PCC_PASSWORD}
                                ...  otp=${otp}

    ${status}                   Get From Dictionary    ${PCC_CONN}    status_code
                                Should Be Equal As Strings    ${status}    200

                                Set Suite Variable      ${PCC_CONN}


###################################################################################################################################
Disable MF Authentication
###################################################################################################################################
    [Documentation]             *Disable MF Authentication*

     ${otp}                      PCC.Generate OTP


     ${status}                   PCC.Disable MF Authentication
                                 ...  otp=${otp}

                                 Should be equal as strings    ${status}    OK


###################################################################################################################################
Login Without MF Authentication
###################################################################################################################################
    [Documentation]             *Login Without MF Authentication*


    ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                Should Be Equal     ${status}  OK






