*** Settings ***
Resource                        pcc_resources.robot

*** Variables ***
${testdata_key}                 pcc_212
${dummy_node_name}              qa-server-100
${dummy_node_ip}                172.17.10.100


*** Test Cases ***
###################################################################################################################################
Nodes Keyword Test
###################################################################################################################################
        [Documentation]         *Nodes Keyword* test
                            ...  Keywords:
                            ...     PCC.Add Node
                            ...     PCC.Get Node Id
                            ...     PCC.Delete Node
                            ...     PCC.Wait Until Node Deleted


                                Login To PCC                    testdata_key=${testdata_key}


                ${response}     PCC.Add Node
                            ...  Host=${dummy_node_ip}

                                # Assert if Status Code is not 200
                ${status}       Get Response Status Code        ${response}
                                Should Be Equal As Numbers      ${status}       200

*** Keywords ***
aa

                ${id}           PCC.Get Node Id                 Name=${dummy_node_name}
                                Log To Console                  ${id}

                ${response}     PCC.Delete Node                 Id=${id}
                                Log To Console                  ${response}

                                PCC.Wait Until Node Deleted     Id=${id}