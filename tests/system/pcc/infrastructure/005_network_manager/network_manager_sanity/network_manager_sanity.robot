*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_242

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    
                                    Load Network Manager Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    
        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Create IPAM Subnet
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready


        ${response}                 PCC.Ipam Subnet Create
                               ...  name=subnet-pvt
                               ...  subnet=10.0.130.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=subnet-pvt

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify Default IgwPolicy
###################################################################################################################################

        ${status}                   PCC.Verify Default IgwPolicy BE
                               ...  nodes=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}"]
                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Network Manager Creation
###################################################################################################################################
    [Documentation]                 *Network Manager Creation*
                               ...  keywords:
                               ...  PCC.Network Manager Create


        ${response}                 PCC.Network Manager Create
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=${NETWORK_MANAGER_NODES}
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                  
                                  
###################################################################################################################################
Network Manager Create Verification PCC
###################################################################################################################################
    [Documentation]                 *Network Manager Verification PCC*
                               ...  keywords:
                               ...  PCC.Wait Until Network Manager Ready


        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Network Manager Update
###################################################################################################################################
    [Documentation]                 *Network Manager Update*
                               ...  keywords:
                               ...  PCC.Network Manager Update
                               ...  PCC.Wait Until Network Manager Ready

        ${network_id}               PCC.Get Network Manager Id
                               ...  name=${NETWORK_MANAGER_NAME}
                               
        ${response}                 PCC.Network Manager Update
                               ...  id=${network_id}
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}","${CLUSTERHEAD_2_NAME}"]
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Network Manager Delete
###################################################################################################################################
    [Documentation]                 *Network Manager Verification PCC*
                               ...  keywords:
                               ...  PCC.Network Manager Delete


        ${response}                 PCC.Network Manager Delete
                               ...  name=${NETWORK_MANAGER_NAME}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Network Manager Delete Verification PCC
###################################################################################################################################
    [Documentation]                 *Network Manager Verification PCC*
                               ...  keywords:
                               ...  PCC.Wait Until Network Manager Ready


        ${status}                   PCC.Wait Until Network Manager Deleted
                               ...  name=${NETWORK_MANAGER_NAME}

                                    Should Be Equal As Strings      ${status}    OK