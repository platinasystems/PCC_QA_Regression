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
                                    Load Ipam Data      ${s3_setup}
                                    Load Network Manager Data       ${s3_setup}
                                    Load Ceph Cluster Data      ${s3_setup}
                                    Load Ceph Pool Data     ${s3_setup}
                                    Load Ceph Rgw Data      ${s3_setup}

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

###################################################################################################################################
Create Ceph Pool
###################################################################################################################################
    [Documentation]                 *Create Ceph Pool*

        ${cluster_id}          PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}            PCC.Ceph Create Erasure Pool
                               ...  name=${CEPH_POOL_NAME}
                               ...  ceph_cluster_id=${cluster_id}
                               ...  pool_type=${CEPH_POOL_TYPE}
                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
                               ...  Datachunks=2
                               ...  Codingchunks=1
                               ...  pg_num=32



        ${status_code}          Get Response Status Code        ${response}
                                Should Be Equal As Strings      ${status_code}  200


        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
                               ...  name=${CEPH_POOL_NAME}

                               Should Be Equal As Strings      ${status}    OK

##################################################################################################################################
Ceph Certificate For Rgws
###################################################################################################################################

        [Documentation]              *Ceph Certificate For Rgws*

        ${response}                  PCC.Add Certificate
                                ...  Alias=${CEPH_RGW_CERT_NAME}
                                ...  Description=certificate-for-rgw
                                ...  Private_key=domain.key
                                ...  Certificate_upload=domain.crt

                                     Log To Console    ${response}
        ${result}                    Get Result    ${response}
        ${status}                    Get From Dictionary    ${result}    statusCodeValue
                                     Should Be Equal As Strings    ${status}    200

        ${response}                  PCC.Ceph Create Rgw
                                ...  name=${CEPH_RGW_NAME}
                                ...  poolName=${CEPH_RGW_POOLNAME}
					            ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP}
                                ...  port=${CEPH_RGW_PORT}
                                ...  certificateName=${CEPH_RGW_CERT_NAME}
                                ...  certificateUrl=${CEPH_RGW_CERT_URL}

        ${status_code}               Get Response Status Code        ${response}
                                     Should Be Equal As Strings      ${status_code}  200

	${status}                        PCC.Ceph Wait Until Rgw Ready
                                ...  name=${CEPH_RGW_NAME}
                                ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                     Should Be Equal As Strings      ${status}    OK

#####################################################################################################################################
Ceph Local Load Balancer create on Rgw
#####################################################################################################################################
     [Documentation]                *Ceph Local Load Balancer create on Rgw*

        ${app_id}              PCC.Get App Id from Policies
                               ...  Name=loadbalancer-ceph
                               Log To Console    ${app_id}

        ${rgw_id}              PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}

        ${response}            PCC.Create Tag
                               ...  Name=lb-attach
                               ...  Description=lb-attach

                               ${result}    Get Result    ${response}
                               ${status}    Get From Dictionary    ${result}    status
                               Should Be Equal As Strings    ${status}    200

        ${tag_1}                    PCC.Get Tag By Name
                              ...   Name=lb-attach
        ${tag_1_id}                 Get From Dictionary    ${tag_1}    id


        ${response}            PCC.Create Policy
                               ...  appId=${app_id}
                               ...  description=test-ceph-lb
                               ...  inputs=[{"name": "lb_name","value": "testcephlb"},{"name": "lb_balance_method","value": "roundrobin"},{"name": "lb_mode","value": "local"},{"name": "lb_frontend","value": "0.0.0.0:9898"},{"name": "lb_backends","value": "${rgw_id}"}]

                               ${result}    Get Result    ${response}
                               ${status}    Get From Dictionary    ${result}    status
                               ${message}    Get From Dictionary    ${result}    message
                               ${data}      Get From Dictionary    ${result}    Data
                               ${policy_tag_1_id}      Get From Dictionary    ${data}     id
                               Should Be Equal As Strings    ${status}    200


        ${response}             PCC.Edit Tag
                                ...  Id=${tag_1_id}
                                ...  Name=lb-attach
                                ...  PolicyIDs=[${policy_tag_1_id}]

                                ${result}    Get Result    ${response}
                                ${status}    Get From Dictionary    ${result}    status
                                Should Be Equal As Strings    ${status}    200

        ${result}               PCC.Add and Verify Tags On Nodes
                                ...  nodes=["${SERVER_1_NAME}"]
                                ...  tags=["lb-attach"]

                                Should Be Equal As Strings    ${result}    OK

    ${node_wait_status}         PCC.Wait Until Node Ready
                                ...  Name=${SERVER_1_NAME}

                                Should Be Equal As Strings    ${node_wait_status}    OK


        ${response}             PCC.Add and Verify Roles On Nodes
                                ...  nodes=["${SERVER_1_NAME}"]
                                ...  roles=["Ceph Load Balancer"]

                                Should Be Equal As Strings      ${response}  OK

        ${node_wait_status}     PCC.Wait Until Node Ready
                                ...  Name=${SERVER_1_NAME}

                                Log To Console    ${node_wait_status}
                                Should Be Equal As Strings    ${node_wait_status}    OK

