*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***

###################################################################################################################################
Login To PCC
###################################################################################################################################

                                    Load Clusterhead 1 Test Data        ${s3_setup}
                                    Load Clusterhead 2 Test Data        ${s3_setup}
                                    Load Server 1 Test Data        ${s3_setup}
                                    Load Server 2 Test Data        ${s3_setup}
                                    Load Server 3 Test Data        ${s3_setup}
                                    Load Server 4 Test Data        ${s3_setup}
                                    Load Server 5 Test Data        ${s3_setup}
                                    Load Server 6 Test Data        ${s3_setup}
                                    Load Ipam Data    ${s3_setup}
                                    Load Network Manager Data    ${s3_setup}
                                    Load Ceph Cluster Data    ${s3_setup}

        ${status}                   Login To PCC        testdata_key=${s3_setup}
                                    Should Be Equal     ${status}  OK

#####################################################################################################################################
Add Nodes
#####################################################################################################################################

    [Documentation]                 *Add Nodes Test*

    ${status}                       PCC.Add multiple nodes and check online
                                    ...  host_ips=['${CLUSTERHEAD_1_HOST_IP}', '${CLUSTERHEAD_2_HOST_IP}', '${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}','${SERVER_3_HOST_IP}','${SERVER_4_HOST_IP}','${SERVER_5_HOST_IP}','${SERVER_6_HOST_IP}']
                                    ...  Names=['${CLUSTERHEAD_1_NAME}', '${CLUSTERHEAD_2_NAME}', '${SERVER_1_NAME}','${SERVER_2_NAME}','${SERVER_3_NAME}','${SERVER_4_NAME}','${SERVER_5_NAME}','${SERVER_6_NAME}']

                                    Log To Console    ${status}
                                    Should be equal as strings    ${status}    OK

###################################################################################################################################
Nodes Verification Back End (Services should be running and active)
###################################################################################################################################
    [Documentation]                      *Nodes Verification Back End*
                                    ...  keywords:
                                    ...  PCC.Node Verify Back End

        ${status}                   PCC.Node Verify Back End
                                    ...  host_ips=['${CLUSTERHEAD_1_HOST_IP}', '${CLUSTERHEAD_2_HOST_IP}', '${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}','${SERVER_3_HOST_IP}','${SERVER_4_HOST_IP}','${SERVER_5_HOST_IP}','${SERVER_6_HOST_IP}']
                                    Log To Console    ${status}
                                    Run Keyword If  "${status}" != "OK"  Fatal Error
				                    Should Be Equal As Strings      ${status}    OK
				                    
###################################################################################################################################
Create IPAM ControlCIDR Subnet
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*

        ${response}                 PCC.Ipam Subnet Create
                               ...  name=${IPAM_CONTROL_SUBNET_NAME}
                               ...  subnet=${IPAM_CONTROL_SUBNET_IP}
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create IPAM DataCIDR Subnet
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*

        ${response}                 PCC.Ipam Subnet Create
                               ...  name=${IPAM_DATA_SUBNET_NAME}
                               ...  subnet=${IPAM_DATA_SUBNET_IP}
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
		                  
###################################################################################################################################
Network Manager Creation
###################################################################################################################################
    [Documentation]                 *Network Manager Creation*

        ${response}                 PCC.Network Manager Create
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=${NETWORK_MANAGER_NODES}
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
                               ...  bgp_neighbors=${NETWORK_MANAGER_BGP_NEIGHBORS}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK		                    
	
###################################################################################################################################
Ceph Cluster Create
###################################################################################################################################
    [Documentation]                 *Ceph Cluster Create*

        ${id}                       PCC.Ceph Get Cluster Id
                              ...   name=${CEPH_CLUSTER_NAME}
                                    Pass Execution If    ${id} is not ${None}    Cluster is alredy there

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK
		                    