*** Settings ***
Library                         pcc_qa.common.Utils
Library                         pcc_qa.common.Result
Library                         pcc_qa.common.TestData
Library                         pcc_qa.common.LinuxUtils
Library                         pcc_qa.common.DockerUtils
Library                         pcc_qa.s3.Login
Library                         pcc_qa.s3.PccInstance
Library                         pcc_qa.s3.Organization
Library                         pcc_qa.s3.User
Library                         pcc_qa.s3.Endpoint
Library                         pcc_qa.s3.S3Credential
Library                         pcc_qa.s3.Ticket
Library                         pcc_qa.s3.Dashboard
Library                         pcc_qa.s3.Billing
Library                         pcc_qa.pcc.Login
Library                         pcc_qa.pcc.Certificate
Library                         pcc_qa.pcc.Applications
Library                         pcc_qa.pcc.NodeGroups
Library                         pcc_qa.pcc.NodeRoles
Library                         pcc_qa.pcc.Tenants
Library                         pcc_qa.pcc.Nodes
Library                         pcc_qa.pcc.ContainerRegistry
Library                         pcc_qa.pcc.Auth_Profile
Library                         pcc_qa.pcc.Tunneling
Library                         pcc_qa.pcc.OS_Deployment
Library                         pcc_qa.pcc.CephCluster
Library                         pcc_qa.pcc.CephPool
Library                         pcc_qa.pcc.CephRbd
Library                         pcc_qa.pcc.CephFs
Library                         pcc_qa.pcc.CephRgw
Library                         pcc_qa.pcc.CephMultisite
Library                         pcc_qa.pcc.Cli
Library                         pcc_qa.pcc.Kubernetes
Library                         pcc_qa.pcc.OpenSSHKeys
Library                         pcc_qa.pcc.RoleOperations
Library                         pcc_qa.pcc.Interfaces
Library                         pcc_qa.pcc.Alerting
Library                         pcc_qa.pcc.Topology
Library                         pcc_qa.pcc.SAS_Enclosure
Library                         pcc_qa.pcc.NetworkManager
Library                         pcc_qa.pcc.ErasureCoded
Library                         pcc_qa.pcc.ErasureCodedPool
Library                         pcc_qa.pcc.ApplicationCredentialManager
Library                         pcc_qa.pcc.Ipam
Library                         pcc_qa.pcc.PolicyDrivenMgmt
Library                         pcc_qa.pcc.Monitor
Library                         pcc_qa.pcc.SystemPackageUpdates
Library				            pcc_qa.pcc.Rsyslog
Library                         pcc_qa.pcc.Dashboard
Library                         pcc_qa.pcc.PhoneHome
Library                         pcc_qa.pcc.Users
Library				            pcc_qa.pcc.Gmail
Library                         pcc_qa.pcc.Roles
Library                         pcc_qa.pcc.Pcc
Library                         pcc_qa.pcc.Notifications
Library                         pcc_qa.pcc.Tags
Library                         pcc_qa.pcc.Search
Library                         pcc_qa.pcc.Prometheus
Library                         Collections

*** Keywords ***
###################################################################################################################################
Login To S3-Manager
###################################################################################################################################
    [Arguments]                 ${testdata_key}=None

        [Documentation]         *Login to S3-Manager* - obtain token
                                Log To Console          **** Login To S3-Manager ****

                                # Load Test Data sets Suite Variables used by all tests

                                Load S3 Test Data      ${testdata_key}

        ${S3_CONN}              S3.Login               url=${S3_URL}   username=${S3_USERNAME}    password=${S3_PASSWORD}

                                # Using SESSION and TOKEN for all subsequent REST API calls

                                Set Suite Variable      ${S3_CONN}
        ${login_success}        Set Variable If  "${S3_CONN}" == "None"  ERROR  OK
    [Return]                    ${login_success}


###################################################################################################################################
Login To PCC
###################################################################################################################################
    [Arguments]                 ${testdata_key}=None

        [Documentation]         *Login to PCC* - obtain token
                                Log To Console          **** Login To PCC ****

                                # Load Test Data sets Suite Variables used by all tests

                                Load PCC Test Data      ${testdata_key}

                                # PCC.Login is defined in Login.py   it takes PCC_URL from defined Robot variable

        ${PCC_CONN}             PCC.Login               url=${PCC_URL}   username=${PCC_USERNAME}    password=${PCC_PASSWORD}

                                # Log To Console          CH-NAME=${CLUSTERHEAD_1_NAME}
                                # Using SESSION and TOKEN for all subsequent REST API calls

                                Set Suite Variable      ${PCC_CONN}
        ${login_success}        Set Variable If  "${PCC_CONN}" == "None"  ERROR  OK
    [Return]                    ${login_success}

###################################################################################################################################
Load S3 Test Data
###################################################################################################################################
    [Arguments]                     ${testdata_key}

        [Documentation]             *Load PCC Test Data*
                                    Log To Console          **** Load S3 Test Data ****

        ${s3_manager_dict}      TESTDATA.Get            ${testdata_key}.json        s3-manager


        ${S3_URL}               Evaluate                $s3_manager_dict.get("url", None)
                                Set Suite Variable      ${S3_URL}


        ${S3_USERNAME}          Evaluate                $s3_manager_dict.get("username", None)
                                Set Suite Variable      ${S3_USERNAME}

        ${S3_PASSWORD}          Evaluate                $s3_manager_dict.get("password", None)
                                Set Suite Variable      ${S3_PASSWORD}

###################################################################################################################################
Load Organization Data
###################################################################################################################################
    [Arguments]                     ${testdata_key}

        [Documentation]             *Load Organization Data*

        ${organization_dict}    TESTDATA.Get            ${testdata_key}.json        organization


        ${ORG_NAME}             Evaluate                $organization_dict.get("name", None)
                                Set Suite Variable      ${ORG_NAME}

        ${ORG_DESC}             Evaluate                $organization_dict.get("description", None)
                                Set Suite Variable      ${ORG_DESC}

        ${ORG_EMAIL}            Evaluate                $organization_dict.get("email", None)
                                Set Suite Variable      ${ORG_EMAIL}

        ${ORG_USERNAME}         Evaluate                $organization_dict.get("username", None)
                                Set Suite Variable      ${ORG_USERNAME}

        ${ORG_PASSWORD}          Evaluate                $organization_dict.get("password", None)
                                Set Suite Variable      ${ORG_PASSWORD}

        ${ORG_FIRSTNAME}        Evaluate                $organization_dict.get("firstname", None)
                                Set Suite Variable      ${ORG_FIRSTNAME}

        ${ORG_LASTNAME}         Evaluate                $organization_dict.get("lastname", None)
                                Set Suite Variable      ${ORG_LASTNAME}

###################################################################################################################################
Load PCC Test Data
###################################################################################################################################
    [Arguments]                     ${testdata_key}

        [Documentation]             *Load PCC Test Data*

        Log To Console          **** Load PCC Test Data ****

        ${pcc_instance_dict}            TESTDATA.Get            ${testdata_key}.json        pcc_instance

        ${PCC_SERVER}          Evaluate                $pcc_instance_dict.get("pcc_server", None)
                               Set Suite Variable      ${PCC_SERVER}

        ${PCC_URL}             Evaluate                $PCC_SERVER.get("pcc_url", None)
                               Set Suite Variable      ${PCC_URL}

        ${PCC_HOST_IP}         Evaluate                $PCC_SERVER.get("pcc_host_ip", None)
                               Set Suite Variable      ${PCC_HOST_IP}

        ${PCC_USERNAME}         Evaluate                $PCC_SERVER.get("pcc_username", None)
                                Set Suite Variable      ${PCC_USERNAME}

        ${PCC_PASSWORD}         Evaluate                $PCC_SERVER.get("pcc_password", None)
                                Set Suite Variable      ${PCC_PASSWORD}

        ${PCC_LINUX_USER}       Evaluate                $PCC_SERVER.get("pcc_linux_user", None)
                                Set Suite Variable      ${PCC_LINUX_USER}

        ${PCC_LINUX_PASSWORD}   Evaluate                $PCC_SERVER.get("pcc_linux_password", None)
                                Set Suite Variable      ${PCC_LINUX_PASSWORD}

        ${PCC_NAME}             Evaluate                $PCC_SERVER.get("pcc_name", None)
                                Set Suite Variable      ${PCC_NAME}

        ${PCC_PORT}             Evaluate                $PCC_SERVER.get("pcc_port", None)
                                Set Suite Variable      ${PCC_PORT}

        ${PCC_ADDRESS}          Evaluate                $PCC_SERVER.get("pcc_address", None)
                                Set Suite Variable      ${PCC_ADDRESS}
###################################################################################################################################
Load Clusterhead 1 Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Clusterhead 1  Test Data*

        Log To Console          **** Load Clusterhead 1  Test Data ****

        ${pcc_instance_dict}            TESTDATA.Get            ${testdata_key}.json        pcc_instance

        ${CLUSTERHEAD_1}          Evaluate                $pcc_instance_dict.get("clusterhead-1", None)
                                  Set Suite Variable      ${CLUSTERHEAD_1}

        ${CLUSTERHEAD_1_NAME}     Evaluate                $CLUSTERHEAD_1.get("invader_name", None)
                                  Set Suite Variable      ${CLUSTERHEAD_1_NAME}

        ${CLUSTERHEAD_1_HOST_IP}  Evaluate                $CLUSTERHEAD_1.get("pcc_host_ip", None)
                                  Set Suite Variable      ${CLUSTERHEAD_1_HOST_IP}

        ${CLUSTERHEAD_1_UNAME}    Evaluate                $CLUSTERHEAD_1.get("pcc_username", None)
                                  Set Suite Variable      ${CLUSTERHEAD_1_UNAME}

        ${CLUSTERHEAD_1_PWD}      Evaluate                $CLUSTERHEAD_1.get("pcc_password", None)
                                  Set Suite Variable      ${CLUSTERHEAD_1_PWD}

###################################################################################################################################
Load Clusterhead 2 Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Clusterhead 2  Test Data*

        Log To Console          **** Load Clusterhead 2  Test Data ****

        ${pcc_instance_dict}            TESTDATA.Get            ${testdata_key}.json        pcc_instance

        ${CLUSTERHEAD_2}          Evaluate                $pcc_instance_dict.get("clusterhead-2", None)
                                  Set Suite Variable      ${CLUSTERHEAD_2}

        ${CLUSTERHEAD_2_NAME}     Evaluate                $CLUSTERHEAD_2.get("invader_name", None)
                                  Set Suite Variable      ${CLUSTERHEAD_2_NAME}

        ${CLUSTERHEAD_2_HOST_IP}  Evaluate                $CLUSTERHEAD_2.get("pcc_host_ip", None)
                                  Set Suite Variable      ${CLUSTERHEAD_2_HOST_IP}

        ${CLUSTERHEAD_2_UNAME}    Evaluate                $CLUSTERHEAD_2.get("pcc_username", None)
                                  Set Suite Variable      ${CLUSTERHEAD_2_UNAME}

        ${CLUSTERHEAD_2_PWD}      Evaluate                $CLUSTERHEAD_2.get("pcc_password", None)
                                  Set Suite Variable      ${CLUSTERHEAD_2_PWD}

###################################################################################################################################
Load Server 1 Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Server 1  Test Data*

        Log To Console          **** Load Server 1  Test Data ****

        ${pcc_instance_dict}            TESTDATA.Get            ${testdata_key}.json        pcc_instance

        ${SERVER_1}          Evaluate                $pcc_instance_dict.get("server-1", None)
                             Set Suite Variable      ${SERVER_1}

        ${SERVER_1_NAME}      Evaluate    $SERVER_1.get("server_name", None)
                              Set Suite Variable    ${SERVER_1_NAME}

        ${SERVER_1_HOST_IP}   Evaluate    $SERVER_1.get("pcc_host_ip", None)
                              Set Suite Variable    ${SERVER_1_HOST_IP}

        ${SERVER_1_UNAME}     Evaluate    $SERVER_1.get("pcc_username", None)
                              Set Suite Variable    ${SERVER_1_UNAME}

        ${SERVER_1_PWD}       Evaluate    $SERVER_1.get("pcc_password", None)
                              Set Suite Variable    ${SERVER_1_PWD}

###################################################################################################################################
Load Server 2 Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Server 2  Test Data*

        Log To Console          **** Load Server 2  Test Data ****

        ${pcc_instance_dict}            TESTDATA.Get            ${testdata_key}.json        pcc_instance

        ${SERVER_2}          Evaluate                $pcc_instance_dict.get("server-2", None)
                             Set Suite Variable      ${SERVER_2}


        ${SERVER_2_NAME}      Evaluate    $SERVER_2.get("server_name", None)
                              Set Suite Variable    ${SERVER_2_NAME}

        ${SERVER_2_HOST_IP}   Evaluate    $SERVER_2.get("pcc_host_ip", None)
                              Set Suite Variable    ${SERVER_2_HOST_IP}

        ${SERVER_2_UNAME}     Evaluate    $SERVER_2.get("pcc_username", None)
                              Set Suite Variable    ${SERVER_2_UNAME}

        ${SERVER_2_PWD}       Evaluate    $SERVER_2.get("pcc_password", None)
                              Set Suite Variable    ${SERVER_2_PWD}

###################################################################################################################################
Load Server 3 Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Server 3  Test Data*

        Log To Console          **** Load Server 3  Test Data ****

        ${pcc_instance_dict}            TESTDATA.Get            ${testdata_key}.json        pcc_instance

        ${SERVER_3}          Evaluate                $pcc_instance_dict.get("server-3", None)
                             Set Suite Variable      ${SERVER_3}


        ${SERVER_3_NAME}      Evaluate    $SERVER_3.get("server_name", None)
                              Set Suite Variable    ${SERVER_3_NAME}

        ${SERVER_3_HOST_IP}   Evaluate    $SERVER_3.get("pcc_host_ip", None)
                              Set Suite Variable    ${SERVER_3_HOST_IP}

        ${SERVER_3_UNAME}     Evaluate    $SERVER_3.get("pcc_username", None)
                              Set Suite Variable    ${SERVER_3_UNAME}

        ${SERVER_3_PWD}       Evaluate    $SERVER_3.get("pcc_password", None)
                              Set Suite Variable    ${SERVER_3_PWD}

###################################################################################################################################
Load Server 4 Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Server 4  Test Data*

        Log To Console          **** Load Server 4  Test Data ****

        ${pcc_instance_dict}            TESTDATA.Get            ${testdata_key}.json        pcc_instance

        ${SERVER_4}          Evaluate                $pcc_instance_dict.get("server-4", None)
                             Set Suite Variable      ${SERVER_4}


        ${SERVER_4_NAME}      Evaluate    $SERVER_4.get("server_name", None)
                              Set Suite Variable    ${SERVER_4_NAME}

        ${SERVER_4_HOST_IP}   Evaluate    $SERVER_4.get("pcc_host_ip", None)
                              Set Suite Variable    ${SERVER_4_HOST_IP}

        ${SERVER_4_UNAME}     Evaluate    $SERVER_4.get("pcc_username", None)
                              Set Suite Variable    ${SERVER_4_UNAME}

        ${SERVER_4_PWD}       Evaluate    $SERVER_4.get("pcc_password", None)
                              Set Suite Variable    ${SERVER_4_PWD}

###################################################################################################################################
Load Server 5 Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Server 5  Test Data*

            Log To Console          **** Load Server 5  Test Data ****

            ${pcc_instance_dict}            TESTDATA.Get            ${testdata_key}.json        pcc_instance

            ${SERVER_5}          Evaluate                $pcc_instance_dict.get("server-5", None)
                                 Set Suite Variable      ${SERVER_5}


            ${SERVER_5_NAME}      Evaluate    $SERVER_5.get("server_name", None)
                                  Set Suite Variable    ${SERVER_5_NAME}

            ${SERVER_5_HOST_IP}   Evaluate    $SERVER_5.get("pcc_host_ip", None)
                                  Set Suite Variable    ${SERVER_5_HOST_IP}

            ${SERVER_5_UNAME}     Evaluate    $SERVER_5.get("pcc_username", None)
                                  Set Suite Variable    ${SERVER_5_UNAME}

            ${SERVER_5_PWD}       Evaluate    $SERVER_5.get("pcc_password", None)
                                  Set Suite Variable    ${SERVER_5_PWD}


###################################################################################################################################
Load Server 6 Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Server 6  Test Data*

            Log To Console          **** Load Server 6  Test Data ****

            ${pcc_instance_dict}            TESTDATA.Get            ${testdata_key}.json        pcc_instance

            ${SERVER_6}          Evaluate                $pcc_instance_dict.get("server-6", None)
                                 Set Suite Variable      ${SERVER_6}


            ${SERVER_6_NAME}      Evaluate    $SERVER_6.get("server_name", None)
                                  Set Suite Variable    ${SERVER_6_NAME}

            ${SERVER_6_HOST_IP}   Evaluate    $SERVER_6.get("pcc_host_ip", None)
                                  Set Suite Variable    ${SERVER_6_HOST_IP}

            ${SERVER_6_UNAME}     Evaluate    $SERVER_6.get("pcc_username", None)
                                  Set Suite Variable    ${SERVER_6_UNAME}

            ${SERVER_6_PWD}       Evaluate    $SERVER_6.get("pcc_password", None)
                                  Set Suite Variable    ${SERVER_6_PWD}
###################################################################################################################################
Load Ipam Data 
###################################################################################################################################
    [Arguments]                        ${testdata_key}
    [Documentation]                    *Load Ipam Data *

         Log To Console      **** Load Ipam Data ****

         ${pcc_instance_dict}            TESTDATA.Get            ${testdata_key}.json        pcc_instance

         ${IPAM}                          Evaluate    $pcc_instance_dict.get("ipam", None)
                                          Set Suite Variable    ${IPAM}

         ${IPAM_CONTROL_SUBNET_NAME}       Evaluate    $IPAM.get("controlName", None)
                                           Set Suite Variable    ${IPAM_CONTROL_SUBNET_NAME}

         ${IPAM_DATA_SUBNET_NAME}          Evaluate    $IPAM.get("dataName", None)
                                           Set Suite Variable    ${IPAM_DATA_SUBNET_NAME}

         ${IPAM_CONTROL_SUBNET_IP}         Evaluate    $IPAM.get("controlSubnet", None)
                                           Set Suite Variable    ${IPAM_CONTROL_SUBNET_IP}

         ${IPAM_DATA_SUBNET_IP}            Evaluate    $IPAM.get("dataSubnet", None)
                                           Set Suite Variable    ${IPAM_DATA_SUBNET_IP}

###################################################################################################################################
Load Network Manager Data 
###################################################################################################################################
    [Arguments]                     ${testdata_key}
    [Documentation]                 *Load Network Manager Data *

         Log To Console      **** Load Network Manager Data  ****

         ${pcc_instance_dict}            TESTDATA.Get            ${testdata_key}.json        pcc_instance

         ${NETWORK_MANAGER}           Evaluate    $pcc_instance_dict.get("network_manager", None)
                                      Set Suite Variable      ${NETWORK_MANAGER}

        ${NETWORK_MANAGER_NAME}       Evaluate    $NETWORK_MANAGER.get("name", None)
                                      Set Suite Variable    ${NETWORK_MANAGER_NAME}

        ${NETWORK_MANAGER_NODES}      Evaluate    $NETWORK_MANAGER.get("nodes", None)
                                      Set Suite Variable    ${NETWORK_MANAGER_NODES}

        ${NETWORK_MANAGER_NODES_IP}   Evaluate    $NETWORK_MANAGER.get("nodes_ip", None)
                                      Set Suite Variable    ${NETWORK_MANAGER_NODES_IP}

        ${NETWORK_MANAGER_CNTLCIDR}   Evaluate    $NETWORK_MANAGER.get("controlCIDR", None)
                                      Set Suite Variable    ${NETWORK_MANAGER_CNTLCIDR}

        ${NETWORK_MANAGER_DATACIDR}   Evaluate    $NETWORK_MANAGER.get("dataCIDR", None)
                                      Set Suite Variable    ${NETWORK_MANAGER_DATACIDR}

        ${NETWORK_MANAGER_IGWPOLICY}  Evaluate    $NETWORK_MANAGER.get("igwPolicy", None)
                                      Set Suite Variable    ${NETWORK_MANAGER_IGWPOLICY}

        ${NETWORK_MANAGER_BGP_NEIGHBORS}        Evaluate    $NETWORK_MANAGER.get("bgp_neighbors", None)
                                                Set Suite Variable    ${NETWORK_MANAGER_BGP_NEIGHBORS}
###################################################################################################################################
Load Ceph Cluster Data 
###################################################################################################################################
    [Arguments]                     ${testdata_key}
    [Documentation]                 * Load Ceph Cluster Data   *

        Log To Console      **** Load Ceph Cluster Data ****

        ${pcc_instance_dict}            TESTDATA.Get            ${testdata_key}.json        pcc_instance

        ${CEPH_CLUSTER}           Evaluate    $pcc_instance_dict.get("ceph_cluster", None)
                                  Set Suite Variable      ${CEPH_CLUSTER}

        ${CEPH_CLUSTER_NAME}      Evaluate    $CEPH_CLUSTER.get("name", None)
                                  Set Suite Variable    ${CEPH_CLUSTER_NAME}

        ${CEPH_CLUSTER_NODES}     Evaluate    $CEPH_CLUSTER.get("nodes", None)
                                  Set Suite Variable    ${CEPH_CLUSTER_NODES}

        ${CEPH_CLUSTER_NODES_IP}  Evaluate    $CEPH_CLUSTER.get("nodes_ip", None)
                                  Set Suite Variable    ${CEPH_CLUSTER_NODES_IP}

        ${CEPH_CLUSTER_TAGS}      Evaluate    $CEPH_CLUSTER.get("tags", None)
                                  Set Suite Variable    ${CEPH_CLUSTER_TAGS}

        ${CEPH_CLUSTER_NETWORK}   Evaluate    $CEPH_CLUSTER.get("networkClusterName", None)
                                  Set Suite Variable    ${CEPH_CLUSTER_NETWORK}

###################################################################################################################################
Load Ceph Pool Data 
###################################################################################################################################
    [Arguments]                     ${testdata_key}
    [Documentation]                 *Load Ceph Pool Data *

        Log To Console      **** Load Ceph Pool Data  ****

        ${pcc_instance_dict}            TESTDATA.Get            ${testdata_key}.json        pcc_instance

        ${CEPH_POOL}           Evaluate    $pcc_instance_dict.get("ceph_pool", None)
                               Set Suite Variable      ${CEPH_POOL}

        ${CEPH_POOL_NAME}      Evaluate    $CEPH_POOL.get("name", None)
                               Set Suite Variable    ${CEPH_POOL_NAME}

        ${CEPH_POOL_TYPE}       Evaluate    $CEPH_POOL.get("pool_type", None)
                                Set Suite Variable    ${CEPH_POOL_TYPE}

	    ${POOL_RESILIENCE_SCHEME}   Evaluate    $CEPH_POOL.get("resilienceScheme", None)
                                    Set Suite Variable    ${POOL_RESILIENCE_SCHEME}

        ${CEPH_POOL_TAGS}           Evaluate    $CEPH_POOL.get("tags", None)
                                    Set Suite Variable    ${CEPH_POOL_TAGS}

        ${CEPH_POOL_QUOTA}          Evaluate    $CEPH_POOL.get("quota", None)
                                    Set Suite Variable    ${CEPH_POOL_QUOTA}

        ${CEPH_POOL_QUOTA_UNIT}     Evaluate    $CEPH_POOL.get("quota_unit", None)
                                    Set Suite Variable    ${CEPH_POOL_QUOTA_UNIT}

###################################################################################################################################
Load Ceph Rgw Data 
###################################################################################################################################
    [Arguments]                     ${testdata_key}
    [Documentation]                 *Load Ceph Rgw Data*

        Log To Console      **** Load Ceph  Rgw Data ****

        ${pcc_instance_dict}            TESTDATA.Get            ${testdata_key}.json        pcc_instance

        ${CEPH_RGW}                  Evaluate    $pcc_instance_dict.get("ceph_rgw", None)
                                     Set Suite Variable      ${CEPH_RGW}

        ${CEPH_RGW_NAME}             Evaluate    $CEPH_RGW.get("name", None)
                                     Set Suite Variable    ${CEPH_RGW_NAME}

        ${CEPH_RGW_POOLNAME}         Evaluate    $CEPH_RGW.get("poolName", None)
                                     Set Suite Variable    ${CEPH_RGW_POOLNAME}

        ${CEPH_RGW_NUMDAEMONSMAP}    Evaluate    $CEPH_RGW.get("numDaemonsMap", None)
                                     Set Suite Variable    ${CEPH_RGW_NUMDAEMONSMAP}

        ${CEPH_RGW_PORT}             Evaluate    $CEPH_RGW.get("port", None)
                                     Set Suite Variable    ${CEPH_RGW_PORT}

        ${CEPH_RGW_CERT_NAME}        Evaluate    $CEPH_RGW.get("certificateName", None)
                                     Set Suite Variable    ${CEPH_RGW_CERT_NAME}

        ${CEPH_RGW_CERT_URL}         Evaluate    $CEPH_RGW.get("certificateUrl", None)
                                     Set Suite Variable    ${CEPH_RGW_CERT_URL}

        ${CEPH_RGW_CERT_NAME_LB}     Evaluate    $CEPH_RGW.get("certificateNameLB", None)
                                     Set Suite Variable    ${CEPH_RGW_CERT_NAME_LB}

        ${CEPH_RGW_CERT_URL_LB}       Evaluate    $CEPH_RGW.get("certificateUrlLB", None)
                                      Set Suite Variable    ${CEPH_RGW_CERT_URL_LB}

        ${CEPH_RGW_S3ACCOUNTS}       Evaluate    $CEPH_RGW.get("S3Accounts", None)
                                     Set Suite Variable    ${CEPH_RGW_S3ACCOUNTS}