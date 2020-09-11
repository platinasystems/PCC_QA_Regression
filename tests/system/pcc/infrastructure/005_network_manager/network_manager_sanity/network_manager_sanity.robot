*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Ipam Data    ${pcc_setup}
                                    Load Network Manager Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    
        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

##################################################################################################################################
Create scoping objects
###################################################################################################################################

        [Documentation]    *Create scoping object - Region* test
                           ...  keywords:
                           ...  PCC.Create Scope
        
        ##### Creating Region #####
        ${response}    PCC.Create Scope
                       ...  type=region
                       ...  scope_name=region-for-ceph
                       ...  description=region-for-ceph-description


                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=region-for-ceph

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK 

        ##### Creating Zone #####               
        ${parent_Id}    PCC.Get Scope Id
                        ...  scope_name=region-for-ceph
                        Log To Console    ${parent_Id}

        ${response}    PCC.Create Scope
                       ...  type=zone
                       ...  scope_name=zone-for-ceph
                       ...  description=zone-for-ceph-description
                       ...  parentID=${parent_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=zone-for-ceph

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

        #### Creating Site #####

        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-for-ceph
                        ...  parentID=${parent_Id}

                        Log To Console    ${parent1_Id}

        ${response}    PCC.Create Scope
                       ...  type=site
                       ...  scope_name=site-for-ceph
                       ...  description=site-for-ceph-description
                       ...  parentID=${parent1_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=site-for-ceph

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

        #### Creating Rack ####

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=site-for-ceph
                        ...  parentID=${parent1_Id}

        ${response}    PCC.Create Scope
                       ...  type=rack
                       ...  scope_name=rack-for-ceph
                       ...  description=rack-for-ceph-description
                       ...  parentID=${parent2_Id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=rack-for-ceph

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Apply rack on multiple nodes
###################################################################################################################################

        [Documentation]    *Apply location on multiple nodes - considered rack* test
                           ...  keywords:
                           ...  PCC.Update Node
        
        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=region-for-ceph
                        Log To Console    ${parent1_Id}

        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=zone-for-ceph
                        ...  parentID=${parent1_Id}
                        Log To Console    ${parent2_Id}

        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=site-for-ceph
                        ...  parentID=${parent2_Id}

                        Log To Console    ${parent3_Id}

        ${scope_id}    PCC.Get Scope Id
                        ...  scope_name=rack-for-ceph
                        ...  parentID=${parent3_Id}

                        Log To Console    ${scope_id}

        ${status}      PCC.Apply scope to multiple nodes
                       ...  node_names=['${CLUSTERHEAD_1_NAME}','${CLUSTERHEAD_2_NAME}','${SERVER_2_NAME}','${SERVER_1_NAME}']
                       ...  scopeId=${scope_id}

                       Log to Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Create IPAM ControlCIDR Subnet 
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready


        ${response}                 PCC.Ipam Subnet Create
                               ...  name=${IPAM_CONTROL_SUBNET_NAME}
                               ...  subnet=${IPAM_CONTROL_SUBNET_IP}
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=${IPAM_CONTROL_SUBNET_NAME}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create IPAM DataCIDR Subnet
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready


        ${response}                 PCC.Ipam Subnet Create
                               ...  name=${IPAM_DATA_SUBNET_NAME}
                               ...  subnet=${IPAM_DATA_SUBNET_IP}
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=${IPAM_DATA_SUBNET_NAME}

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
Network Manager Create Verification Backend
###################################################################################################################################

        ${status}                   PCC.Network Manager Verify BE      
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP} 
                                    Should Be Equal As Strings      ${status}  OK
                                    
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

        ${status}                   PCC.Network Manager Verify BE      
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                                    Should Be Equal As Strings      ${status}  OK

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
