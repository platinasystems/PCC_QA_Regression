*** Settings ***
Resource                        pcc_resources.robot

*** Variables ***
${testdata_key}                 pcc_242
${dummy_node_group}             Dummy Node Group
${dummy_node_group_desc}        Dummy Node Group Description


*** Test Cases ***
###################################################################################################################################
Node Groups Keyword Test
###################################################################################################################################
        [Documentation]         *Node Group Keyword* test
                            ...  Keywords:
                            ...     PCC.Get Node Group Id
                            ...     PCC.Delete Node Group
                            ...     PCC.Add Node Group

                                Login To PCC            testdata_key=${testdata_key}

                                # Delete the Node Group if is present in PCC
                ${Id}           PCC.Get Node Group Id   Name=${dummy_node_group}
                ${response}     PCC.Delete Node Group   Id=${Id}

                                # Add Node Group
                ${owner}        PCC.Get Tenant Id       Name=ROOT
                ${response}     PCC.Add Node Group      
                            ...  Name=${dummy_node_group}  
                            ...  owner=${owner}  
                            ...  Description=${dummy_node_group_desc}

                                # Assert if Status Code is not 200
                ${status}       Get Response Status Code        ${response}
                                Should Be Equal As Numbers      ${status}       200
