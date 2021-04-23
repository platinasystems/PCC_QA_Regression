*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212


*** Test Cases ***
###################################################################################################################################
Login to PCC
###################################################################################################################################


        [Documentation]    *Login to PCC* test


        ${status}        Login To PCC    ${pcc_setup}

                         Load Tenant Data    ${pcc_setup}
                         
                         Load Container Registry Data    ${pcc_setup}
                         
                         Load PCC Test Data    ${pcc_setup}
                         



###################################################################################################################################
PCC-Tenant Creation
###################################################################################################################################

        [Documentation]    *Create Tenant* test
                           ...    keywords:
                           ...    PCC.Get Tenant Id
                           ...    PCC.Add Tenant

        ${parent_id}    PCC.Get Tenant Id
                        ...    Name=${ROOT_TENANT}

        ${response}    PCC.Add Tenant
                       ...    Name=${CR_TENANT_USER}
                       ...    Description=CR_TENANT_DESC
                       ...    Parent_id=${parent_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200

        ${status}    PCC.Validate Tenant
                     ...    Name=${CR_TENANT_USER}

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK


###################################################################################################################################
PCC Read Only Role Creation
###################################################################################################################################

        [Documentation]    *Create Read Only Role* test
                           ...    keywords:
                           ...    PCC.Get Tenant Id
                           ...    PCC.Add Read Only Role

        ${owner}    PCC.Get Tenant Id
                    ...    Name=${CR_TENANT_USER}


        ${response}    PCC.Add Read Only Role
                       ...    Name=readonly
                       ...    Description=readonlyroles
                       ...    owner=${owner}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200


###################################################################################################################################
PCC-Read Only User Creation
###################################################################################################################################

        [Documentation]    *Create Read Only User* test
                           ...  keywords:
                           ...  PCC.Get Role Id
                           ...  PCC.Add Read Only User

        ${tenant}    PCC.Get Tenant Id
                    ...    Name=${CR_TENANT_USER}

        ${roleID}    PCC.Get Role Id
                     ...    Name=readonly
                     ...    Owner=${tenant}

        ${response}    PCC.Add User
                       ...     FirstName=calsoft
                       ...     LastName=platina
                       ...     Username=${READONLY_USER_PCC_USERNAME}
                       ...     Tenant=${tenant}
                       ...     Role_ID=${roleID}
                       ...     Source=${PCC_URL}

                        Log To Console    ${response}
                        ${result}    Get Result    ${response}
                        ${status}    Get From Dictionary    ${response}    StatusCode
                        Should Be Equal As Strings    ${status}    200

                        Sleep  10s



###################################################################################################################################
PCC-Get Link From Gmail Read Only User
###################################################################################################################################

        [Documentation]    *Get Link From Gmail* test
                           ...  keywords:
                           ...  PCC.Add Read Only User

        ${password_token}     PCC.Get Link From Gmail
                              ...   Email=${READONLY_USER_PCC_USERNAME}

                              Log To Console    ${password_token}
                              Set Suite Variable    ${password_token}



###################################################################################################################################
PCC-Create Read Only Password
###################################################################################################################################

        [Documentation]    *Create Password* test
                           ...  keywords:
                           ...  PCC.Create User Password

        ${response}     PCC.Create User Password
                        ...     Password=${READONLY_USER_PCC_PWD}

                        Log To Console    ${response}
                        ${result}    Get Result    ${response}
                        ${status}    Get From Dictionary    ${response}    StatusCode
                        Should Be Equal As Strings    ${status}    200

        ${status}        Login To PCC    ${pcc_setup}

###################################################################################################################################
PCC-Admin User Creation
###################################################################################################################################

        [Documentation]    *Create Read Only User* test
                           ...  keywords:
                           ...  PCC.Get Role Id
                           ...  PCC.Add Read Only User

        ${tenant}    PCC.Get Tenant Id
                    ...    Name=${CR_TENANT_USER}

        ${roleID}    PCC.Get Role Id
                     ...    Name=ADMIN
                     ...    Owner=${tenant}

        ${response}    PCC.Add User
                       ...     FirstName=platina
                       ...     LastName=systems
                       ...     Username=${TENANT_USER_PCC_USERNAME}
                       ...     Tenant=${tenant}
                       ...     Role_ID=${roleID}
                       ...     Source=${PCC_URL}

                        Log To Console    ${response}
                        ${result}    Get Result    ${response}
                        ${status}    Get From Dictionary    ${response}    StatusCode
                        Should Be Equal As Strings    ${status}    200

                        Sleep  10s



###################################################################################################################################
PCC-Get Link From Gmail Admin User
###################################################################################################################################

        [Documentation]    *Get Link From Gmail* test
                           ...  keywords:
                           ...  PCC.Add Read Only User

        ${password_token}     PCC.Get Link From Gmail
                              ...   Email=${TENANT_USER_PCC_USERNAME}

                              Log To Console    ${password_token}
                              Set Suite Variable    ${password_token}



###################################################################################################################################
PCC-Create Admin User Password
###################################################################################################################################

        [Documentation]    *Create Password* test
                           ...  keywords:
                           ...  PCC.Create User Password

        ${response}     PCC.Create User Password
                        ...     Password=${TENANT_USER_PCC_PWD}

                        Log To Console    ${response}
                        ${result}    Get Result    ${response}
                        ${status}    Get From Dictionary    ${response}    StatusCode
                        Should Be Equal As Strings    ${status}    200

		${status}        Login To PCC    ${pcc_setup}



