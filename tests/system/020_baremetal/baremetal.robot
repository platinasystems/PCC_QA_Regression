*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC
###################################################################################################################################


        [Documentation]    *Login to PCC* test

                        Load Clusterhead 1 Test Data        ${pcc_setup}
                        Load Server 1 Test Data        ${pcc_setup}
                        Load Server 2 Test Data        ${pcc_setup}
                        Load Server 3 Test Data        ${pcc_setup}

        ${status}       Login To PCC    ${pcc_setup}


###################################################################################################################################
Add Baremetal Provisioner To Node
###################################################################################################################################
    [Documentation]                 *Add Baremetal Provisioner To Node*

        ${response}                 PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${SERVER_1_NAME}"]
                               ...  roles=["Baremetal Provisioner"]

                                    Should Be Equal As Strings      ${response}  OK

        ${node_wait_status}         PCC.Wait Until Node Ready
                               ...  Name=${SERVER_1_NAME}

                                    Log To Console    ${node_wait_status}
                                    Should Be Equal As Strings    ${node_wait_status}    OK

                                    sleep  10s

###################################################################################################################################
Verify Baremetal Provisioner
###################################################################################################################################
    [Documentation]                 *Verify Baremetal Provisioner*

        ${response}                 PCC.Verify Baremetal Provisioner Role
                               ...  Node=${SERVER_1_NAME}

                                    Should Be Equal As Strings      ${response}  OK

###################################################################################################################################
Add Bootstrap Services To Baremetal Provisioner Node (Negative)
###################################################################################################################################
    [Documentation]                 *Add Bootstrap Services To Baremetal Provisioner Node (Negative)*

        ${response}                 PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${SERVER_1_NAME}"]
                               ...  roles=["Bootstrap Services"]

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}


###################################################################################################################################
Add Bootstrap Services To Node
###################################################################################################################################
    [Documentation]                 *Add Bootstrap Services To Node*

        ${response}                 PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${SERVER_2_NAME}"]
                               ...  roles=["Bootstrap Services"]

                                    Should Be Equal As Strings      ${response}  OK

        ${node_wait_status}         PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME}

                                    Log To Console    ${node_wait_status}
                                    Should Be Equal As Strings    ${node_wait_status}    OK


###################################################################################################################################
Verify Bootstrap Services
###################################################################################################################################
    [Documentation]                 *Verify Bootstrap Services*

        ${response}                 PCC.Verify Bootstrap Services Role
                               ...  Node=${SERVER_2_NAME}

                                    Should Be Equal As Strings      ${response}  OK

###################################################################################################################################
Add Baremetal Provisioner To Bootstrap Service Node (Negative)
###################################################################################################################################
    [Documentation]                 *Add Baremetal Provisioner To Bootstrap Service Node (Negative)*

        ${response}                 PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${SERVER_2_NAME}"]
                               ...  roles=["Baremetal Provisioner"]

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

