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
                       ...    Name=${TENANT1}
                       ...    Description=${TENANT1_DESC}
                       ...    Parent_id=${parent_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200

        ${status}    PCC.Validate Tenant
                     ...    Name=${TENANT1}

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
                    ...    Name=${TENANT1}


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
                    ...    Name=${TENANT1}

        ${roleID}    PCC.Get Role Id
                     ...    Name=readonly
                     ...    Owner=${tenant}

        ${response}    PCC.Add User
                       ...     FirstName=calsoft
                       ...     LastName=platina
                       ...     Username=calsoftplatina@gmail.com
                       ...     Tenant=${tenant}
                       ...     Role_ID=${roleID}

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
                              ...   Email=calsoftplatina@gmail.com

                              Log To Console    ${password_token}
                              Set Suite Variable    ${password_token}



###################################################################################################################################
PCC-Create Read Only Password
###################################################################################################################################

        [Documentation]    *Create Password* test
                           ...  keywords:
                           ...  PCC.Create User Password

        ${response}     PCC.Create User Password
                        ...     Password=readonly@123

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
                    ...    Name=${TENANT1}

        ${roleID}    PCC.Get Role Id
                     ...    Name=ADMIN
                     ...    Owner=${tenant}

        ${response}    PCC.Add User
                       ...     FirstName=platina
                       ...     LastName=systems
                       ...     Username=platinasystems@gmail.com
                       ...     Tenant=${tenant}
                       ...     Role_ID=${roleID}

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
                              ...   Email=platinasystems@gmail.com

                              Log To Console    ${password_token}
                              Set Suite Variable    ${password_token}



###################################################################################################################################
PCC-Create Admin User Password
###################################################################################################################################

        [Documentation]    *Create Password* test
                           ...  keywords:
                           ...  PCC.Create User Password

        ${response}     PCC.Create User Password
                        ...     Password=calsoft@123

                        Log To Console    ${response}
                        ${result}    Get Result    ${response}
                        ${status}    Get From Dictionary    ${response}    StatusCode
                        Should Be Equal As Strings    ${status}    200

		${status}        Login To PCC    ${pcc_setup}





###################################################################################################################################
PCC-Users Deletion
###################################################################################################################################

        [Documentation]    *Delete Admin User* test
                           ...  keywords:
                           ...  PCC.Delete User

        ${response}    PCC.Delete User
                       ...     Username=calsoftplatina@gmail.com

                        Log To Console    ${response}
                        ${result}    Get Result    ${response}
                        ${status}    Get From Dictionary    ${response}    StatusCode
                        Should Be Equal As Strings    ${status}    200

        ${response}    PCC.Delete User
                       ...     Username=platinasystems@gmail.com

                        Log To Console    ${response}
                        ${result}    Get Result    ${response}
                        ${status}    Get From Dictionary    ${response}    StatusCode
                        Should Be Equal As Strings    ${status}    200


###################################################################################################################################
PCC-Tenant Deletion
###################################################################################################################################

        [Documentation]    *Create Tenant* test
                           ...    keywords:
                           ...    PCC.Get Tenant Id
                           ...    PCC.Add Tenant

        ${tenant_id}    PCC.Get Tenant Id
                        ...    Name=${TENANT1}

        ${response}    PCC.Delete Tenant
                       ...    Id=${tenant_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200

        ${status}    PCC.Validate Tenant
                     ...    Name=${TENANT1}

                     Log To Console    ${status}
                     Should Not Be Equal As Strings    ${status}    OK