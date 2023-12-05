########### commenting network manager code for 242 nodes ##############

*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Ipam Data    ${pcc_setup}
                                    Load K8s Data    ${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Network Manager Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    Load Server 3 Test Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK


###################################################################################################################################
Check LLDP Show Neighbors
###################################################################################################################################

        [Documentation]    *Check LLDP Show Neighbors* test
                           ...  keywords:
                           ...  PCC.Verify LLDP Neighbors

        ${status}    PCC.Verify LLDP Neighbors
                     ...    servers_hostip=['${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}']
                     ...    invaders_hostip=['${CLUSTERHEAD_1_HOST_IP}']

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Network Manager Creation: L2Static
###################################################################################################################################
    [Documentation]                 *Network Manager Creation: L2Static*


        ${response}                 PCC.Network Manager Create
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${SERVER_3_NAME}"]
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=lab-pvt
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
                               ...  type=4

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

                                    sleep  1m

        ${status}                   PCC.Wait Until All Nodes Are Ready

                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Network Manager verify From Event log
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

                                    PCC.FRR status on nodes
                               ...  Names=["${SERVER_2_NAME}","${SERVER_1_NAME}","${SERVER_3_NAME}"]

###################################################################################################################################
Network Manager Delete: L2Static
###################################################################################################################################
    [Documentation]                 *Network Manager Delete: L2Static*

        ${response}                 PCC.Network Manager Delete
                               ...  name=${NETWORK_MANAGER_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Deleted
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

                                    sleep  1m

        ${status}                   PCC.Wait Until All Nodes Are Ready

                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Network Manager Creation: L2BGP
###################################################################################################################################
    [Documentation]                 *Network Manager Creation: L2BGP*


        ${response}                 PCC.Network Manager Create
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${SERVER_3_NAME}"]
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=lab-pvt
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
                               ...  type=7

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

                                    sleep  1m

        ${status}                   PCC.Wait Until All Nodes Are Ready

                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Network Manager verify From Event log
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

                                    PCC.FRR status on nodes
                               ...  Names=["${SERVER_2_NAME}","${SERVER_1_NAME}","${SERVER_3_NAME}"]

###################################################################################################################################
Network Manager Creation: L2Addon
###################################################################################################################################
    [Documentation]                 *Network Manager Creation: L2Addon*

        ${response}                 PCC.Network Manager Create
                               ...  name=network-addon
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${SERVER_3_NAME}"]
                               ...  dataCIDR=lab-pvt
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
                               ...  type=8

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=network-addon
                                    Should Be Equal As Strings      ${status}    OK

                                    sleep  1m

        ${status}                   PCC.Wait Until All Nodes Are Ready

                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=network-addon
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Network Manager verify From Event log
                               ...  name=network-addon
                                    Should Be Equal As Strings      ${status}    OK

                                    PCC.FRR status on nodes
                               ...  Names=["${SERVER_2_NAME}","${SERVER_1_NAME}","${SERVER_3_NAME}"]

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Wait Until All Nodes Are Ready

                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Ceph Cluster Creation with L2Addon (Negative)
###################################################################################################################################

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  networkClusterName=network-addon

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200


###################################################################################################################################
K8s Cluster Creation with L2Addon (Negative)
###################################################################################################################################

        ${response}                 PCC.K8s Create Cluster
                               ...  id=${K8S_ID}
                               ...  k8sVersion=${K8S_VERSION}
                               ...  name=${K8S_NAME}
                               ...  cniPlugin=${K8S_CNIPLUGIN}
                               ...  nodes=${K8S_NODES}
                               ...  pools=${K8S_POOL}
                               ...  networkClusterName=network-addon

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200



###################################################################################################################################
Network Manager Delete: L2Addon
###################################################################################################################################
    [Documentation]                 *Network Manager Delete: L2BGP*

        ${response}                 PCC.Network Manager Delete
                               ...  name=network-addon

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Deleted
                               ...  name=network-addon
                                    Should Be Equal As Strings      ${status}    OK

                                    sleep  1m

        ${status}                   PCC.Wait Until All Nodes Are Ready

                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

                                    sleep  1m

        ${status}                   PCC.Wait Until All Nodes Are Ready

                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK


###################################################################################################################################
Network Manager Delete: L2BGP
###################################################################################################################################
    [Documentation]                 *Network Manager Delete: L2BGP*

        ${response}                 PCC.Network Manager Delete
                               ...  name=${NETWORK_MANAGER_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Deleted
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

                                    sleep  1m

        ${status}                   PCC.Wait Until All Nodes Are Ready

                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK

###################################################################################################################################
Network Manager Creation: Unmanaged
###################################################################################################################################
    [Documentation]                 *Network Manager Creation: Unmanaged*


        ${response}                 PCC.Network Manager Create
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${SERVER_3_NAME}"]
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=lab-pvt
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
                               ...  type=3

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

                                    sleep  1m

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Wait Until All Nodes Are Ready

                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Network Manager verify From Event log
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

                                    PCC.FRR status on nodes
                               ...  Names=["${SERVER_2_NAME}","${SERVER_1_NAME}","${SERVER_3_NAME}"]

###################################################################################################################################
Network Manager Delete: Unmanaged
###################################################################################################################################
    [Documentation]                 *Network Manager Delete: Unmanaged*

        ${response}                 PCC.Network Manager Delete
                               ...  name=${NETWORK_MANAGER_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Deleted
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

                                    sleep  1m

        ${status}                   PCC.Wait Until All Nodes Are Ready

                                    Log To Console    ${status}
                                    Should Be Equal As Strings      ${status}  OK


###################################################################################################################################
Network Manager Creation
###################################################################################################################################
    [Documentation]                 *Network Manager Creation*
                               ...  keywords:
                               ...  PCC.Network Manager Create
                               ...  PCC.Wait Until Network Manager Ready
                               ...  PCC.Network Manager Verify BE

        ${response}                 PCC.Network Manager Create
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${SERVER_3_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
                               ...  bgp_neighbors=${NETWORK_MANAGER_BGP_NEIGHBORS}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Network Manager Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}","${SERVER_3_HOST_IP}"]
                               ...  controlCIDR=${IPAM_CONTROL_SUBNET_IP}
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Network Manager verify From Event log
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

                                    PCC.FRR status on nodes
                               ...  Names=["${SERVER_2_NAME}","${SERVER_1_NAME}","${SERVER_3_NAME}","${CLUSTERHEAD_1_NAME}"]

###################################################################################################################################
Login To PCC Secondary
###################################################################################################################################

                                    Load Network Manager Data Secondary   ${pcc_setup}


        ${status}                   Login To PCC Secondary  testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK


###################################################################################################################################
Network Manager Creation Secondary
###################################################################################################################################
    [Documentation]                 *Network Manager Creation Secondary*
                               ...  keywords:
                               ...  PCC.Network Manager Create
                               ...  PCC.Wait Until Network Manager Ready
                               ...  PCC.Network Manager Verify BE

        ${response}                 PCC.Network Manager Create
                               ...  name=${NETWORK_MANAGER_NAME_SECONDARY}
                               ...  nodes=${NETWORK_MANAGER_NODES_SECONDARY}
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR_SECONDARY}
                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR_SECONDARY}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY_SECONDARY}
                               ...  bgp_neighbors=${NETWORK_MANAGER_BGP_NEIGHBORS_SECONDARY}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK


