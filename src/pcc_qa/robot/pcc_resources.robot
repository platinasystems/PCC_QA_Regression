*** Settings ***
Library                         pcc_qa.common.Utils
Library                         pcc_qa.common.Result
Library                         pcc_qa.common.TestData
Library                         pcc_qa.common.LinuxUtils
Library                         pcc_qa.common.DockerUtils
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
Library                         Collections


*** Keywords ***
###################################################################################################################################
Login To PCC
###################################################################################################################################
    [Arguments]                 ${testdata_key}=None

        [Documentation]         *Login to PCC* - obtain token
                                Log To Console          **** Login To PCC ****

                                # Load Test Data sets Suite Variables used by all tests
                                
                                Load PCC Test Data      ${testdata_key}
                                
                                #Load Clusterhead 1 Test Data    ${pcc_server_key}.json
                                # PCC.Login is defined in Login.py   it takes PCC_URL from defined Robot variable
        
        ${PCC_CONN}             PCC.Login               url=${PCC_URL}   username=${PCC_USERNAME}    password=${PCC_PASSWORD}
                                
                                # Log To Console          CH-NAME=${CLUSTERHEAD_1_NAME}
                                # Using SESSION and TOKEN for all subsequent REST API calls
                                
                                Set Suite Variable      ${PCC_CONN}
        ${login_success}        Set Variable If  "${PCC_CONN}" == "None"  ERROR  OK
    [Return]                    ${login_success}

###################################################################################################################################
Login To PCC Secondary
###################################################################################################################################
    [Arguments]                 ${testdata_key}=None

        [Documentation]         *Login to PCC* - obtain token
                                Log To Console          **** Login To PCC ****

                                # Load Test Data sets Suite Variables used by all tests

                                Load PCC Secondary Test Data      ${testdata_key}

                                #Load Clusterhead 1 Test Data    ${pcc_server_key}.json
                                # PCC.Login is defined in Login.py   it takes PCC_URL from defined Robot variable

        ${PCC_CONN}             PCC.Login               url=${PCC_URL_SECONDARY}   username=${PCC_USERNAME_SECONDARY}    password=${PCC_PASSWORD_SECONDARY}

                                # Log To Console          CH-NAME=${CLUSTERHEAD_1_NAME}
                                # Using SESSION and TOKEN for all subsequent REST API calls

                                Set Suite Variable      ${PCC_CONN}
        ${login_success}        Set Variable If  "${PCC_CONN}" == "None"  ERROR  OK
    [Return]                    ${login_success}


###################################################################################################################################
Load PCC Test Data
###################################################################################################################################
    [Arguments]                     ${testdata_key}    

        [Documentation]             *Load PCC Test Data* 
                                    Log To Console          **** Load PCC Test Data ****

            ${pcc_server_dict}      TESTDATA.Get            ${testdata_key}.json        pcc_server

                                    # PCC Info
            ${PCC_URL}              Evaluate                $pcc_server_dict.get("pcc_url", None)
                                    Set Suite Variable      ${PCC_URL}

            ${PCC_HOST_IP}          Evaluate                $pcc_server_dict.get("pcc_host_ip", None)
                                    Set Suite Variable      ${PCC_HOST_IP}

        ${PCC_LINUX_PASSWORD}       Evaluate                $pcc_server_dict.get("pcc_linux_password", None)
                                    Set Suite Variable      ${PCC_LINUX_PASSWORD}

        ${PCC_LINUX_USER}           Evaluate                $pcc_server_dict.get("pcc_linux_user", None)
                                    Set Suite Variable      ${PCC_LINUX_USER}

        ${PCC_USERNAME}             Evaluate                $pcc_server_dict.get("pcc_username", None)
                                    Set Suite Variable      ${PCC_USERNAME}
  
        ${PCC_PASSWORD}             Evaluate                $pcc_server_dict.get("pcc_password", None)
                                    Set Suite Variable      ${PCC_PASSWORD}
                                    
        ${TENANT_USER_PCC_USERNAME}    Evaluate    $pcc_server_dict.get("tenant_user_username", None)
                                       Set Suite Variable      ${TENANT_USER_PCC_USERNAME}
                                       
        ${TENANT_USER_PCC_PWD}    Evaluate    $pcc_server_dict.get("tenant_user_password", None)
                                  Set Suite Variable      ${TENANT_USER_PCC_PWD}
        
        ${READONLY_USER_PCC_USERNAME}    Evaluate    $pcc_server_dict.get("read_only_username", None)
                                       Set Suite Variable      ${READONLY_USER_PCC_USERNAME}
                                       
        ${READONLY_USER_PCC_PWD}    Evaluate    $pcc_server_dict.get("read_only_password", None)
                                  Set Suite Variable      ${READONLY_USER_PCC_PWD}
        
        ${PCC_SETUP_PWD}          Evaluate    $pcc_server_dict.get("setup_password", None)
                                  Set Suite Variable      ${PCC_SETUP_PWD}
        
        ${PCC_SETUP_USERNAME}          Evaluate    $pcc_server_dict.get("setup_username", None)
                                  Set Suite Variable      ${PCC_SETUP_USERNAME}

        ${PCC_SETUP_UPGRADE_CMD}          Evaluate    $pcc_server_dict.get("setup_upgrade_cmd", None)
                                  Set Suite Variable      ${PCC_SETUP_UPGRADE_CMD}
###################################################################################################################################
Load Clusterhead 1 Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key} 

        [Documentation]         *Load Clusterhead 1 Test Data* 
                                Log To Console          **** Load Clusterhead 1 Test Data ****

            ${pcc_server_dict}    TESTDATA.Get            ${testdata_key}.json        clusterhead-1
                                
                                # Clusterhead Info
                                
            ${CLUSTERHEAD_1_NAME}            Evaluate    $pcc_server_dict.get("invader_name", None)
                                        Set Suite Variable    ${CLUSTERHEAD_1_NAME}
        
        
            ${CLUSTERHEAD_1_URL}             Evaluate    $pcc_server_dict.get("pcc_url", None)
                                        Set Suite Variable    ${CLUSTERHEAD_1_URL}
    
            ${CLUSTERHEAD_1_HOST_IP}         Evaluate    $pcc_server_dict.get("pcc_host_ip", None)
                                        Set Suite Variable    ${CLUSTERHEAD_1_HOST_IP}
    
            ${CLUSTERHEAD_1_LINUX_PWD}       Evaluate    $pcc_server_dict.get("pcc_linux_password", None)
                                        Set Suite Variable    ${CLUSTERHEAD_1_LINUX_PWD}
    
            ${CLUSTERHEAD_1_UNAME}           Evaluate    $pcc_server_dict.get("pcc_username", None)
                                        Set Suite Variable    ${CLUSTERHEAD_1_UNAME}
    
            ${CLUSTERHEAD_1_PWD}             Evaluate    $pcc_server_dict.get("pcc_password", None)
                                        Set Suite Variable    ${CLUSTERHEAD_1_PWD}
            
            ${CLUSTERHEAD_1_BMC}             Evaluate    $pcc_server_dict.get("bmc", None)
                                        Set Suite Variable    ${CLUSTERHEAD_1_BMC}
                                        
            ${CLUSTERHEAD_1_BMCUSER}         Evaluate    $pcc_server_dict.get("bmc_user", None)
                                        Set Suite Variable    ${CLUSTERHEAD_1_BMCUSER}
                                        
            ${CLUSTERHEAD_1_BMCPWD}          Evaluate    $pcc_server_dict.get("bmc_pwd", None)
                                        Set Suite Variable    ${CLUSTERHEAD_1_BMCPWD}
                                        
            ${CLUSTERHEAD_1_CONSOLE}        Evaluate    $pcc_server_dict.get("console", None)
                                        Set Suite Variable    ${CLUSTERHEAD_1_CONSOLE}
            
            ${CLUSTERHEAD_1_MANAGED_BY_PCC}  Evaluate    $pcc_server_dict.get("managed_by_pcc", None)
                                         Set Suite Variable    ${CLUSTERHEAD_1_MANAGED_BY_PCC}
    
            ${CLUSTERHEAD_1_SSHKEYS}        Evaluate    $pcc_server_dict.get("ssh_keys", None)
                                        Set Suite Variable    ${CLUSTERHEAD_1_SSHKEYS}
                                        
                                        
###################################################################################################################################
Load Clusterhead 2 Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key} 

        [Documentation]         *Load Clusterhead 2 Test Data* 
                                Log To Console          **** Load Clusterhead 2 Test Data ****

            ${pcc_server_dict}    TESTDATA.Get            ${testdata_key}.json        clusterhead-2
                                
                                # Clusterhead Info
                                
            ${CLUSTERHEAD_2_NAME}            Evaluate    $pcc_server_dict.get("invader_name", None)
                                        Set Suite Variable    ${CLUSTERHEAD_2_NAME}
        
        
            ${CLUSTERHEAD_2_URL}             Evaluate    $pcc_server_dict.get("pcc_url", None)
                                        Set Suite Variable    ${CLUSTERHEAD_2_URL}
    
            ${CLUSTERHEAD_2_HOST_IP}         Evaluate    $pcc_server_dict.get("pcc_host_ip", None)
                                        Set Suite Variable    ${CLUSTERHEAD_2_HOST_IP}
    
            ${CLUSTERHEAD_2_LINUX_PWD}       Evaluate    $pcc_server_dict.get("pcc_linux_password", None)
                                        Set Suite Variable    ${CLUSTERHEAD_2_LINUX_PWD}
    
            ${CLUSTERHEAD_2_UNAME}           Evaluate    $pcc_server_dict.get("pcc_username", None)
                                        Set Suite Variable    ${CLUSTERHEAD_2_UNAME}
    
            ${CLUSTERHEAD_2_PWD}             Evaluate    $pcc_server_dict.get("pcc_password", None)
                                        Set Suite Variable    ${CLUSTERHEAD_2_PWD}
            
            ${CLUSTERHEAD_2_BMC}             Evaluate    $pcc_server_dict.get("bmc", None)
                                        Set Suite Variable    ${CLUSTERHEAD_2_BMC}
                                        
            ${CLUSTERHEAD_2_BMCUSER}         Evaluate    $pcc_server_dict.get("bmc_user", None)
                                        Set Suite Variable    ${CLUSTERHEAD_2_BMCUSER}
                                        
            ${CLUSTERHEAD_2_BMCPWD}          Evaluate    $pcc_server_dict.get("bmc_pwd", None)
                                        Set Suite Variable    ${CLUSTERHEAD_2_BMCPWD}
                                        
            ${CLUSTERHEAD_2_CONSOLE}        Evaluate    $pcc_server_dict.get("console", None)
                                        Set Suite Variable    ${CLUSTERHEAD_2_CONSOLE}
            
            ${CLUSTERHEAD_2_MANAGED_BY_PCC}  Evaluate    $pcc_server_dict.get("managed_by_pcc", None)
                                         Set Suite Variable    ${CLUSTERHEAD_2_MANAGED_BY_PCC}
    
            ${CLUSTERHEAD_2_SSHKEYS}        Evaluate    $pcc_server_dict.get("ssh_keys", None)
                                        Set Suite Variable    ${CLUSTERHEAD_2_SSHKEYS}


###################################################################################################################################
Load Server 1 Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key} 

        [Documentation]         *Load Server 1 Test Data* 
                                Log To Console          **** Load Server 1 Test Data ****

            ${pcc_server_dict}    TESTDATA.Get            ${testdata_key}.json        server-1
                                
                                # Server Info
                                
            ${SERVER_1_NAME}            Evaluate    $pcc_server_dict.get("server_name", None)
                                        Set Suite Variable    ${SERVER_1_NAME}
        
            ${SERVER_1_URL}             Evaluate    $pcc_server_dict.get("pcc_url", None)
                                        Set Suite Variable    ${SERVER_1_URL}
    
            ${SERVER_1_HOST_IP}         Evaluate    $pcc_server_dict.get("pcc_host_ip", None)
                                        Set Suite Variable    ${SERVER_1_HOST_IP}
    
            ${SERVER_1_LINUX_PWD}       Evaluate    $pcc_server_dict.get("pcc_linux_password", None)
                                        Set Suite Variable    ${SERVER_1_LINUX_PWD}
    
            ${SERVER_1_UNAME}           Evaluate    $pcc_server_dict.get("pcc_username", None)
                                        Set Suite Variable    ${SERVER_1_UNAME}
    
            ${SERVER_1_PWD}             Evaluate    $pcc_server_dict.get("pcc_password", None)
                                        Set Suite Variable    ${SERVER_1_PWD}
            
            ${SERVER_1_BMC}             Evaluate    $pcc_server_dict.get("bmc", None)
                                        Set Suite Variable    ${SERVER_1_BMC}
            
            ${SERVER_1_MGMT_IP}         Evaluate    $pcc_server_dict.get("mgmt_ip", None)
                                        Set Suite Variable    ${SERVER_1_MGMT_IP}
                                        
            ${SERVER_1_BMCUSER}         Evaluate    $pcc_server_dict.get("bmc_user", None)
                                        Set Suite Variable    ${SERVER_1_BMCUSER}
                                        
            ${SERVER_1_BMCPWD}          Evaluate    $pcc_server_dict.get("bmc_pwd", None)
                                        Set Suite Variable    ${SERVER_1_BMCPWD}
                                        
            ${SERVER_1_CONSOLE}        Evaluate    $pcc_server_dict.get("console", None)
                                        Set Suite Variable    ${SERVER_1_CONSOLE}
            
            ${SERVER_1_MANAGED_BY_PCC}  Evaluate    $pcc_server_dict.get("managed_by_pcc", None)
                                         Set Suite Variable    ${SERVER_1_MANAGED_BY_PCC}
    
            ${SERVER_1_SSHKEYS}        Evaluate    $pcc_server_dict.get("ssh_keys", None)
                                        Set Suite Variable    ${SERVER_1_SSHKEYS}


                                        
                                        
###################################################################################################################################
Load Server 2 Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key} 

        [Documentation]         *Load Server 2 Test Data* 
                                Log To Console          **** Load Server 2 Test Data ****

            ${pcc_server_dict}    TESTDATA.Get            ${testdata_key}.json        server-2
                                
                                # Server Info
                                
            ${SERVER_2_NAME}            Evaluate    $pcc_server_dict.get("server_name", None)
                                        Set Suite Variable    ${SERVER_2_NAME}
        
        
            ${SERVER_2_URL}             Evaluate    $pcc_server_dict.get("pcc_url", None)
                                        Set Suite Variable    ${SERVER_2_URL}
    
            ${SERVER_2_HOST_IP}         Evaluate    $pcc_server_dict.get("pcc_host_ip", None)
                                        Set Suite Variable    ${SERVER_2_HOST_IP}
    
            ${SERVER_2_LINUX_PWD}       Evaluate    $pcc_server_dict.get("pcc_linux_password", None)
                                        Set Suite Variable    ${SERVER_2_LINUX_PWD}
    
            ${SERVER_2_UNAME}           Evaluate    $pcc_server_dict.get("pcc_username", None)
                                        Set Suite Variable    ${SERVER_2_UNAME}
    
            ${SERVER_2_PWD}             Evaluate    $pcc_server_dict.get("pcc_password", None)
                                        Set Suite Variable    ${SERVER_2_PWD}
            
            ${SERVER_2_BMC}             Evaluate    $pcc_server_dict.get("bmc", None)
                                        Set Suite Variable    ${SERVER_2_BMC}
            
            ${SERVER_2_MGMT_IP}         Evaluate    $pcc_server_dict.get("mgmt_ip", None)
                                        Set Suite Variable    ${SERVER_2_MGMT_IP}
                                        
            ${SERVER_2_BMCUSER}         Evaluate    $pcc_server_dict.get("bmc_user", None)
                                        Set Suite Variable    ${SERVER_2_BMCUSER}
                                        
            ${SERVER_2_BMCPWD}          Evaluate    $pcc_server_dict.get("bmc_pwd", None)
                                        Set Suite Variable    ${SERVER_2_BMCPWD}
                                        
            ${SERVER_2_CONSOLE}        Evaluate    $pcc_server_dict.get("console", None)
                                        Set Suite Variable    ${SERVER_2_CONSOLE}
            
            ${SERVER_2_MANAGED_BY_PCC}  Evaluate    $pcc_server_dict.get("managed_by_pcc", None)
                                         Set Suite Variable    ${SERVER_2_MANAGED_BY_PCC}
    
            ${SERVER_2_SSHKEYS}        Evaluate    $pcc_server_dict.get("ssh_keys", None)
                                        Set Suite Variable    ${SERVER_2_SSHKEYS}
                                        

###################################################################################################################################
Load Server 3 Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key} 

        [Documentation]         *Load Server 3 Test Data* 
                                Log To Console          **** Load Server 3 Test Data ****

            ${pcc_server_dict}    TESTDATA.Get            ${testdata_key}.json        server-3
                                
                                # Server Info
                                
            ${SERVER_3_NAME}            Evaluate    $pcc_server_dict.get("server_name", None)
                                        Set Suite Variable    ${SERVER_3_NAME}
        
        
            ${SERVER_3_URL}             Evaluate    $pcc_server_dict.get("pcc_url", None)
                                        Set Suite Variable    ${SERVER_3_URL}
    
            ${SERVER_3_HOST_IP}         Evaluate    $pcc_server_dict.get("pcc_host_ip", None)
                                        Set Suite Variable    ${SERVER_3_HOST_IP}
    
            ${SERVER_3_LINUX_PWD}       Evaluate    $pcc_server_dict.get("pcc_linux_password", None)
                                        Set Suite Variable    ${SERVER_3_LINUX_PWD}
    
            ${SERVER_3_UNAME}           Evaluate    $pcc_server_dict.get("pcc_username", None)
                                        Set Suite Variable    ${SERVER_3_UNAME}
    
            ${SERVER_3_PWD}             Evaluate    $pcc_server_dict.get("pcc_password", None)
                                        Set Suite Variable    ${SERVER_3_PWD}
            
            ${SERVER_3_BMC}             Evaluate    $pcc_server_dict.get("bmc", None)
                                        Set Suite Variable    ${SERVER_3_BMC}
            
            ${SERVER_3_MGMT_IP}         Evaluate    $pcc_server_dict.get("mgmt_ip", None)
                                        Set Suite Variable    ${SERVER_3_MGMT_IP}
                                        
            ${SERVER_3_BMCUSER}         Evaluate    $pcc_server_dict.get("bmc_user", None)
                                        Set Suite Variable    ${SERVER_3_BMCUSER}
                                        
            ${SERVER_3_BMCPWD}          Evaluate    $pcc_server_dict.get("bmc_pwd", None)
                                        Set Suite Variable    ${SERVER_3_BMCPWD}
                                        
            ${SERVER_3_CONSOLE}         Evaluate    $pcc_server_dict.get("console", None)
                                        Set Suite Variable    ${SERVER_3_CONSOLE}
            
            ${SERVER_3_MANAGED_BY_PCC}  Evaluate    $pcc_server_dict.get("managed_by_pcc", None)
                                        Set Suite Variable    ${SERVER_3_MANAGED_BY_PCC}
    
            ${SERVER_3_SSHKEYS}         Evaluate    $pcc_server_dict.get("ssh_keys", None)
                                        Set Suite Variable    ${SERVER_3_SSHKEYS}                                        
                                                                        
                                  
###################################################################################################################################
Verify List of Nodes
###################################################################################################################################
            [Arguments]         ${expected_node_list}
        [Documentation]         *Verify all expected nodes are present* - Initial setup must contain only specified set of nodes
                                # Get All Nodes for the given PCC
        ${response}             PCC.Get Node
        ${data}                 Get Response Data       ${response}

                                # Check if each node name is listed in the 'expected_node_list'
                                :FOR  ${node}  IN  @{data}
                                \  ${name}              Evaluate                        ${node}.get("Name", None)
                                \                       Log To Console                  Verify node: ${name}
                                                        # Fail test case if 'name' 
                                                        # is not in 'expected_node_list' 
                                \                       List Should Contain Value       ${expected_node_list}   ${name}
        [Return]                OK
        

###################################################################################################################################
Load Ceph Cluster Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Ceph Cluster Data*
                                    Log To Console      **** Load Ceph Cluster Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json   ceph_cluster

                                    # Ceph
        ${CEPH_CLUSTER_NAME}        Evaluate    $pcc_server_dict.get("name", None)
                                    Set Suite Variable    ${CEPH_CLUSTER_NAME}

        ${CEPH_CLUSTER_NODES}       Evaluate    $pcc_server_dict.get("nodes", None)
                                    Set Suite Variable    ${CEPH_CLUSTER_NODES}

        ${CEPH_CLUSTER_NODES_IP}    Evaluate    $pcc_server_dict.get("nodes_ip", None)
                                    Set Suite Variable    ${CEPH_CLUSTER_NODES_IP}

        ${CEPH_CLUSTER_TAGS}        Evaluate    $pcc_server_dict.get("tags", None)
                                    Set Suite Variable    ${CEPH_CLUSTER_TAGS}

        ${CEPH_CLUSTER_NETWORK}     Evaluate    $pcc_server_dict.get("networkClusterName", None)
                                    Set Suite Variable    ${CEPH_CLUSTER_NETWORK}

###################################################################################################################################
Load Ceph Pool Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Ceph Pool Data*
                                    Log To Console      **** Load Ceph Pool Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json   ceph_pool

                                    # Ceph
        ${CEPH_POOL_NAME}           Evaluate    $pcc_server_dict.get("name", None)
                                    Set Suite Variable    ${CEPH_POOL_NAME}

        ${CEPH_POOL_SIZE}           Evaluate    $pcc_server_dict.get("size", None)
                                    Set Suite Variable    ${CEPH_POOL_SIZE}

        ${CEPH_POOL_TYPE}           Evaluate    $pcc_server_dict.get("pool_type", None)
                                    Set Suite Variable    ${CEPH_POOL_TYPE}

	${POOL_RESILIENCE_SCHEME}   Evaluate    $pcc_server_dict.get("resilienceScheme", None)
                                    Set Suite Variable    ${POOL_RESILIENCE_SCHEME}

        ${CEPH_POOL_TAGS}           Evaluate    $pcc_server_dict.get("tags", None)
                                    Set Suite Variable    ${CEPH_POOL_TAGS}

        ${CEPH_POOL_QUOTA}          Evaluate    $pcc_server_dict.get("quota", None)
                                    Set Suite Variable    ${CEPH_POOL_QUOTA}

        ${CEPH_POOL_QUOTA_UNIT}     Evaluate    $pcc_server_dict.get("quota_unit", None)
                                    Set Suite Variable    ${CEPH_POOL_QUOTA_UNIT}



###################################################################################################################################
Load Ceph Rbd Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Ceph Rbd Data*
                                    Log To Console      **** Load Ceph Rbd Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json   ceph_rbd

        ${CEPH_RBD_NAME}            Evaluate    $pcc_server_dict.get("name", None)
                                    Set Suite Variable    ${CEPH_RBD_NAME}

        ${CEPH_RBD_SIZE}            Evaluate    $pcc_server_dict.get("size", None)
                                    Set Suite Variable    ${CEPH_RBD_SIZE}

        ${CEPH_RBD_IMG}             Evaluate    $pcc_server_dict.get("image_feature", None)
                                    Set Suite Variable    ${CEPH_RBD_IMG}

        ${CEPH_RBD_TAGS}            Evaluate    $pcc_server_dict.get("tags", None)
                                    Set Suite Variable    ${CEPH_RBD_TAGS}

        ${CEPH_RBD_SIZE_UNIT}       Evaluate    $pcc_server_dict.get("size_units", None)
                                    Set Suite Variable    ${CEPH_RBD_SIZE_UNIT}
                                    
                                    
###################################################################################################################################
Load Container Registry Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Container Registry Data*
                                    Log To Console      **** Load Container Registry Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json   container-registry

                                    # Container_Registry
        ${CR_NAME}                  Evaluate    $pcc_server_dict.get("name", None)
                                    Set Suite Variable    ${CR_NAME}
        
        ${STATIC_MODE_CR_NAME}      Evaluate    $pcc_server_dict.get("static_mode_name", None)
                                    Set Suite Variable    ${STATIC_MODE_CR_NAME}
        
        ${INVALID_CR_NAME}          Evaluate    $pcc_server_dict.get("invalid_name", None)
                                    Set Suite Variable    ${INVALID_CR_NAME}

        ${CR_FQDN}                  Evaluate    $pcc_server_dict.get("fullyQualifiedDomainName", None)
                                    Set Suite Variable    ${CR_FQDN}
                                    
        ${STATIC_MODE_CR_FQDN}      Evaluate    $pcc_server_dict.get("static_mode_fullyQualifiedDomainName", None)
                                    Set Suite Variable    ${STATIC_MODE_CR_FQDN}

                                    
        ${CR_INVALID_FQDN}          Evaluate    $pcc_server_dict.get("invalid_FQDN", None)
                                    Set Suite Variable    ${CR_INVALID_FQDN}

        ${CR_PASSWORD}              Evaluate    $pcc_server_dict.get("password", None)
                                    Set Suite Variable    ${CR_PASSWORD}
                                    
        ${STATIC_MODE_CR_PASSWORD}    Evaluate    $pcc_server_dict.get("static_mode_password", None)
                                    Set Suite Variable    ${STATIC_MODE_CR_PASSWORD}
                                    
        ${CR_INVALID_PASSWORD}      Evaluate    $pcc_server_dict.get("invalid_password", None)
                                    Set Suite Variable    ${CR_INVALID_PASSWORD}

        ${CR_SECRETKEYBASE}         Evaluate    $pcc_server_dict.get("secretKeyBase", None)
                                    Set Suite Variable    ${CR_SECRETKEYBASE}

        ${CR_DATABASENAME}          Evaluate    $pcc_server_dict.get("databaseName", None)
                                    Set Suite Variable    ${CR_DATABASENAME}
        
        ${CR_DB_PWD}                Evaluate    $pcc_server_dict.get("databasePassword", None)
                                    Set Suite Variable    ${CR_DB_PWD}
                                    
        ${CR_PORT}                  Evaluate    $pcc_server_dict.get("port", None)
                                    Set Suite Variable    ${CR_PORT}
                                    
        ${CR_REGISTRYPORT}          Evaluate    $pcc_server_dict.get("registryPort", None)
                                    Set Suite Variable    ${CR_REGISTRYPORT}
                                    
        ${CR_ADMIN_STATE}           Evaluate    $pcc_server_dict.get("adminState", None)
                                    Set Suite Variable    ${CR_ADMIN_STATE}
                                    
        ${CR_IMAGE_NAME}            Evaluate    $pcc_server_dict.get("image_name", None)
                                    Set Suite Variable    ${CR_IMAGE_NAME}
        
        ${CR_CUSTOM_IMAGE_NAME}     Evaluate    $pcc_server_dict.get("custom_image_name", None)
                                    Set Suite Variable    ${CR_CUSTOM_IMAGE_NAME}
                                    
        ${CR_PORTUS_UNAME}          Evaluate    $pcc_server_dict.get("portus_uname", None)
                                    Set Suite Variable    ${CR_PORTUS_UNAME}
                                    
        ${CR_PORTUS_INVALID_UNAME}        Evaluate    $pcc_server_dict.get("invalid_portus_uname", None)
                                    Set Suite Variable    ${CR_PORTUS_INVALID_UNAME}
                                    
        ${CR_MODIFIED_NAME}         Evaluate    $pcc_server_dict.get("modified_name", None)
                                    Set Suite Variable    ${CR_MODIFIED_NAME}
        
        ${CR_MODIFIED_FQDN}         Evaluate    $pcc_server_dict.get("modified_fullyQualifiedDomainName", None)
                                    Set Suite Variable    ${CR_MODIFIED_FQDN}
                                    
        ${CR_MODIFIED_SECRETKEYBASE}    Evaluate    $pcc_server_dict.get("modified_secretKeyBase", None)
                                    Set Suite Variable    ${CR_MODIFIED_SECRETKEYBASE}
                                    
        ${CR_MODIFIED_PASSWORD}    Evaluate    $pcc_server_dict.get("modified_password", None)
                                    Set Suite Variable    ${CR_MODIFIED_PASSWORD}
                                    
        ${CR_TENANT_USER}    Evaluate    $pcc_server_dict.get("tenant_user", None)
                                    Set Suite Variable    ${CR_TENANT_USER}
                                    
        ${CR_INVALID_STORAGE_LOCATION}      Evaluate    $pcc_server_dict.get("invalid_storage_location", None)
                                    Set Suite Variable    ${CR_INVALID_STORAGE_LOCATION}
                                    

###################################################################################################################################
Load Ceph Fs Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Ceph Fs Data*
                                    Log To Console      **** Load Ceph Fs Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json   ceph_fs

        ${CEPH_FS_NAME}             Evaluate    $pcc_server_dict.get("name", None)
                                    Set Suite Variable    ${CEPH_FS_NAME}

        ${CEPH_FS_META}             Evaluate    $pcc_server_dict.get("meta_pool", None)
                                    Set Suite Variable    ${CEPH_FS_META}

        ${CEPH_FS_DATA}             Evaluate    $pcc_server_dict.get("data_pool", None)
                                    Set Suite Variable    ${CEPH_FS_DATA}

        ${CEPH_FS_DEFAULT}          Evaluate    $pcc_server_dict.get("default_pool", None)
                                    Set Suite Variable    ${CEPH_FS_DEFAULT}
                                    
###################################################################################################################################
Load Ceph Rgw Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Ceph Rgw Data*
                                    Log To Console      **** Load Ceph Rgw Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json   ceph_rgw

        ${CEPH_RGW_NAME}             Evaluate    $pcc_server_dict.get("name", None)
                                     Set Suite Variable    ${CEPH_RGW_NAME}

        ${CEPH_RGW_POOLNAME}         Evaluate    $pcc_server_dict.get("poolName", None)
                                     Set Suite Variable    ${CEPH_RGW_POOLNAME}

        ${CEPH_RGW_NUMDAEMONSMAP}    Evaluate    $pcc_server_dict.get("numDaemonsMap", None)
                                     Set Suite Variable    ${CEPH_RGW_NUMDAEMONSMAP}

        ${CEPH_RGW_PORT}             Evaluate    $pcc_server_dict.get("port", None)
                                     Set Suite Variable    ${CEPH_RGW_PORT}
                                   
        ${CEPH_RGW_CERT_NAME}        Evaluate    $pcc_server_dict.get("certificateName", None)
                                     Set Suite Variable    ${CEPH_RGW_CERT_NAME}

        ${CEPH_RGW_CERT_URL}        Evaluate    $pcc_server_dict.get("certificateUrl", None)
                                     Set Suite Variable    ${CEPH_RGW_CERT_URL}
                                    
        ${CEPH_RGW_S3ACCOUNTS}       Evaluate    $pcc_server_dict.get("S3Accounts", None)
                                     Set Suite Variable    ${CEPH_RGW_S3ACCOUNTS}
        ${CEPH_RGW_NAME_EC}             Evaluate    $pcc_server_dict.get("name-ec", None)
                                     Set Suite Variable    ${CEPH_RGW_NAME_EC}

        ${CEPH_RGW_POOLNAME_EC}         Evaluate    $pcc_server_dict.get("poolName-ec", None)
                                     Set Suite Variable    ${CEPH_RGW_POOLNAME_EC}

###################################################################################################################################
Load Auth Profile Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Auth Profile Data*
                                    Log To Console      **** Load Auth Profile Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json    auth-profile

                                    # Container_Registry
        ${AUTH_PROFILE_NAME}        Evaluate    $pcc_server_dict.get("name", None)
                                    Set Suite Variable    ${AUTH_PROFILE_NAME}
                                    
        ${AUTH_PROFILE_INVALID_NAME}        Evaluate    $pcc_server_dict.get("invalid_name", None)
                                    Set Suite Variable    ${AUTH_PROFILE_INVALID_NAME}
                                    
        ${AUTH_PROFILE_INVALID_DOMAIN}        Evaluate    $pcc_server_dict.get("invalid_domain", None)
                                    Set Suite Variable    ${AUTH_PROFILE_INVALID_DOMAIN}
                                    
        ${AUTH_PROFILE_INVALID_BIND_DN}        Evaluate    $pcc_server_dict.get("invalid_bindDN", None)
                                    Set Suite Variable    ${AUTH_PROFILE_INVALID_BIND_DN}
                                    
        ${AUTH_PROFILE_INVALID_BIND_PWD}        Evaluate    $pcc_server_dict.get("invalid_bindPassword", None)
                                    Set Suite Variable    ${AUTH_PROFILE_INVALID_BIND_PWD}
                                                                
        ${AUTH_PROFILE_INVALID_LOGIN_UNAME}        Evaluate    $pcc_server_dict.get("invalid_login_uname", None)
                                    Set Suite Variable    ${AUTH_PROFILE_INVALID_LOGIN_UNAME}
        
        ${AUTH_PROFILE_INVALID_PORT}        Evaluate    $pcc_server_dict.get("invalid_port", None)
                                    Set Suite Variable    ${AUTH_PROFILE_INVALID_PORT}
                                    
        ${AUTH_PROFILE_INVALID_UBDN}        Evaluate    $pcc_server_dict.get("invalid_userBaseDN", None)
                                    Set Suite Variable    ${AUTH_PROFILE_INVALID_UBDN}                            
                                    
                                                                       
        ${AUTH_PROFILE_INVALID_GBDN}        Evaluate    $pcc_server_dict.get("invalid_groupBaseDN", None)
                                    Set Suite Variable    ${AUTH_PROFILE_INVALID_GBDN}
                                                                
        ${AUTH_PROFILE_UNAME}        Evaluate    $pcc_server_dict.get("login_uname", None)
                                    Set Suite Variable    ${AUTH_PROFILE_UNAME}
                                    
        ${INVALID_AUTH_PROFILE_UNAME}        Evaluate    $pcc_server_dict.get("invalid_login_uname", None)
                                    Set Suite Variable    ${INVALID_AUTH_PROFILE_UNAME}

        ${AUTH_PROFILE_TYPE}        Evaluate    $pcc_server_dict.get("type_auth", None)
                                    Set Suite Variable    ${AUTH_PROFILE_TYPE}

        ${AUTH_PROFILE_DOMAIN}      Evaluate    $pcc_server_dict.get("domain", None)
                                    Set Suite Variable    ${AUTH_PROFILE_DOMAIN}

        ${AUTH_PROFILE_PORT}        Evaluate    $pcc_server_dict.get("port", None)
                                    Set Suite Variable    ${AUTH_PROFILE_PORT}

        ${AUTH_PROFILE_UID_ATTRIBUTE}        Evaluate    $pcc_server_dict.get("userIDAttribute", None)
                                             Set Suite Variable    ${AUTH_PROFILE_UID_ATTRIBUTE}
        
        ${AUTH_PROFILE_UBDN}        Evaluate    $pcc_server_dict.get("userBaseDN", None)
                                    Set Suite Variable    ${AUTH_PROFILE_UBDN}
                                    
        ${AUTH_PROFILE_GBDN}        Evaluate    $pcc_server_dict.get("groupBaseDN", None)
                                    Set Suite Variable    ${AUTH_PROFILE_GBDN}
                                    
        ${AUTH_PROFILE_ANONYMOUSBIND}        Evaluate    $pcc_server_dict.get("anonymousBind", None)
                                    Set Suite Variable    ${AUTH_PROFILE_ANONYMOUSBIND}
                                    
        ${AUTH_PROFILE_BIND_DN}        Evaluate    $pcc_server_dict.get("bindDN", None)
                                    Set Suite Variable    ${AUTH_PROFILE_BIND_DN}
        
        ${AUTH_PROFILE_BIND_PWD}        Evaluate    $pcc_server_dict.get("bindPassword", None)
                                        Set Suite Variable    ${AUTH_PROFILE_BIND_PWD}
                                        
        ${INVALID_AUTH_PROFILE_BIND_PWD}        Evaluate    $pcc_server_dict.get("invalid_bindPassword", None)
                                        Set Suite Variable    ${INVALID_AUTH_PROFILE_BIND_PWD}
        
        ${AUTH_PROFILE_ENCRYPTION}        Evaluate    $pcc_server_dict.get("encryptionPolicy", None)
                                          Set Suite Variable    ${AUTH_PROFILE_ENCRYPTION}
                                          

###################################################################################################################################
Load Certificate Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Certificate Data*
                                    Log To Console      **** Load Certificate Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json    certificate

                                    # Certificate
        ${ALIAS}                    Evaluate    $pcc_server_dict.get("Alias", None)
                                    Set Suite Variable    ${ALIAS}
                                    
        ${FILENAME}                 Evaluate    $pcc_server_dict.get("Filename", None)
                                    Set Suite Variable    ${FILENAME}
                                    
        ${DESCRIPTION}              Evaluate    $pcc_server_dict.get("Description", None)
                                    Set Suite Variable    ${DESCRIPTION}
                                    

###################################################################################################################################
Load Tunneling Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Tunneling Data*
                                    Log To Console      **** Load Tunneling Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json    tunneling

                                    # Certificate
                                    
        ${CIDR_VAL}                 Evaluate    $pcc_server_dict.get("cidr", None)
                                    Set Suite Variable    ${CIDR_VAL}
                                    
                                    
###################################################################################################################################
Load K8s Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load K8s Data*
                                    Log To Console      **** Load Ceph Rbd Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json   k8s

        ${K8S_ID}                   Evaluate    $pcc_server_dict.get("id", None)
                                    Set Suite Variable    ${K8S_ID}
                                    
        ${K8S_VERSION}              Evaluate    $pcc_server_dict.get("k8sVersion", None)
                                    Set Suite Variable    ${K8S_VERSION}
                                    
        ${K8S_NAME}                 Evaluate    $pcc_server_dict.get("name", None)
                                    Set Suite Variable    ${K8S_NAME}

        ${K8S_CNIPLUGIN}            Evaluate    $pcc_server_dict.get("cniPlugin", None)
                                    Set Suite Variable    ${K8S_CNIPLUGIN}
    
        ${K8S_NODES}                Evaluate    $pcc_server_dict.get("nodes", None)
                                    Set Suite Variable    ${K8S_NODES}
                                    
        ${K8S_POOL}                 Evaluate    $pcc_server_dict.get("pools", None)
                                    Set Suite Variable    ${K8S_POOL}
                                    
        ${K8S_APPNAME}              Evaluate    $pcc_server_dict.get("appName", None)
                                    Set Suite Variable    ${K8S_APPNAME}

        ${K8S_APPNAMESPACE}         Evaluate    $pcc_server_dict.get("appNamespace", None)
                                    Set Suite Variable    ${K8S_APPNAMESPACE}

        ${K8S_GITURL}               Evaluate    $pcc_server_dict.get("gitUrl", None)
                                    Set Suite Variable    ${K8S_GITURL}

        ${K8S_GITREPOPATH}          Evaluate    $pcc_server_dict.get("gitRepoPath", None)
                                    Set Suite Variable    ${K8S_GITREPOPATH}
                                    
        ${K8S_GITBRANCH}            Evaluate    $pcc_server_dict.get("gitBranch", None)
                                    Set Suite Variable    ${K8S_GITBRANCH}

        ${K8S_LABEL}                Evaluate    $pcc_server_dict.get("label", None)
                                    Set Suite Variable    ${K8S_LABEL}

        ${K8S_CLUSTER_NETWORK}      Evaluate    $pcc_server_dict.get("networkClusterName", None)
                                    Set Suite Variable    ${K8S_CLUSTER_NETWORK}
                                    
###################################################################################################################################
Load OS-Deployment Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load OS-Deployment Data*
                                    Log To Console      **** Load OS-Deployment Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json    os_deployment

                                    # OS-Deployment
                                    
        ${IMAGE_1_NAME}             Evaluate    $pcc_server_dict.get("image1_name", None)
                                    Set Suite Variable    ${IMAGE_1_NAME}
                                    
        ${IMAGE_2_NAME}             Evaluate    $pcc_server_dict.get("image2_name", None)
                                    Set Suite Variable    ${IMAGE_2_NAME}
                                    
        ${IMAGE_3_NAME}             Evaluate    $pcc_server_dict.get("image3_name", None)
                                    Set Suite Variable    ${IMAGE_3_NAME}
                                    
        ${LOCALE}                   Evaluate    $pcc_server_dict.get("locale", None)
                                    Set Suite Variable    ${LOCALE}
        
        ${TIME_ZONE}                Evaluate    $pcc_server_dict.get("time_zone", None)
                                    Set Suite Variable    ${TIME_ZONE}
                                    
        ${ADMIN_USER}               Evaluate    $pcc_server_dict.get("admin_user", None)
                                    Set Suite Variable    ${ADMIN_USER}
                                    
        ${SSH_KEYS}                 Evaluate    $pcc_server_dict.get("ssh_keys", None)
                                    Set Suite Variable    ${SSH_KEYS}
        
        ${KEY_NAME}                 Evaluate    $pcc_server_dict.get("key_name", None)
                                    Set Suite Variable    ${KEY_NAME}
                                    
###################################################################################################################################
Load PXE-Boot Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load PXE-Boot Data*
                                    Log To Console      **** Load OS-Deployment Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json    pxe-boot

                                    # Pxe-boot
                                    
        ${GATEWAY}                  Evaluate    $pcc_server_dict.get("gateway", None)
                                    Set Suite Variable    ${GATEWAY}
                                    
        ${PXE_BOOTED_SERVER}        Evaluate    $pcc_server_dict.get("pxe_booted_server", None)
                                    Set Suite Variable    ${PXE_BOOTED_SERVER}
                                  
        ${ADMINSTATUS_UP}           Evaluate    $pcc_server_dict.get("adminStatus_up", None)
                                    Set Suite Variable    ${ADMINSTATUS_UP}
                                    
        ${ADMINSTATUS_DOWN}         Evaluate    $pcc_server_dict.get("adminStatus_down", None)
                                    Set Suite Variable    ${ADMINSTATUS_DOWN}
                                    
                                    
###################################################################################################################################
Load OpenSSH_Keys Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load OpenSSH_Keys Data*
                                    Log To Console      **** Load OpenSSH_Keys Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json    openSSH_keys

                                    # OpenSSH_Keys
                                    
        ${PUBLIC_KEY_ALIAS}         Evaluate    $pcc_server_dict.get("public_key_alias", None)
                                    Set Suite Variable    ${PUBLIC_KEY_ALIAS}
                                    
        ${PUBLIC_KEY_DESCRIPTION}    Evaluate    $pcc_server_dict.get("public_key_description", None)
                                     Set Suite Variable    ${PUBLIC_KEY_DESCRIPTION}
                                  
        ${PUBLIC_TYPE}           Evaluate    $pcc_server_dict.get("public_type", None)
                                    Set Suite Variable    ${PUBLIC_TYPE}
                                    
        ${PUBLIC_KEY}         Evaluate    $pcc_server_dict.get("public_key", None)
                                    Set Suite Variable    ${PUBLIC_KEY}
                                    
                                    
        ${PRIVATE_KEY_ALIAS}         Evaluate    $pcc_server_dict.get("private_key_alias", None)
                                    Set Suite Variable    ${PRIVATE_KEY_ALIAS}
                                    
        ${PRIVATE_KEY_DESCRIPTION}    Evaluate    $pcc_server_dict.get("private_key_description", None)
                                     Set Suite Variable    ${PRIVATE_KEY_DESCRIPTION}
                                  
        ${PRIVATE_TYPE}           Evaluate    $pcc_server_dict.get("private_type", None)
                                    Set Suite Variable    ${PRIVATE_TYPE}
                                    
        ${PRIVATE_KEY}         Evaluate    $pcc_server_dict.get("private_key", None)
                                    Set Suite Variable    ${PRIVATE_KEY}
###################################################################################################################################
Load i28 Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load i28 Data*
                                    Log To Console      **** Load OpenSSH_Keys Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json    i28

                                    # i28
                                    
        ${i28_NAME}           Evaluate    $pcc_server_dict.get("host_name", None)
                              Set Suite Variable    ${i28_NAME}
                                    
        ${i28_HOST_IP}        Evaluate    $pcc_server_dict.get("host_ip", None)
                              Set Suite Variable    ${i28_HOST_IP}
                                  
        ${i28_USERNAME}       Evaluate    $pcc_server_dict.get("username", None)
                              Set Suite Variable    ${i28_USERNAME}
                                    
        ${i28_PASSWORD}       Evaluate    $pcc_server_dict.get("password", None)
                              Set Suite Variable    ${i28_PASSWORD}                            
                                    
###################################################################################################################################
Load Alert Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Alert Data*
                                    Log To Console      **** Load Alert Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json    alerting
                            
        ${ALERT_NAME}               Evaluate    $pcc_server_dict.get("name", None)
                                    Set Suite Variable    ${ALERT_NAME}
                                        
        ${ALERT_PARAMETER}          Evaluate    $pcc_server_dict.get("parameter", None)
                                    Set Suite Variable    ${ALERT_PARAMETER}
                                      
        ${ALERT_OPERATOR}           Evaluate    $pcc_server_dict.get("operator", None)
                                    Set Suite Variable    ${ALERT_OPERATOR}
                                        
        ${ALERT_VALUE}              Evaluate    $pcc_server_dict.get("value", None)
                                    Set Suite Variable    ${ALERT_VALUE}                                          
                                    
        ${ALERT_TIME}               Evaluate    $pcc_server_dict.get("time", None)
                                    Set Suite Variable    ${ALERT_TIME}
                                      
        ${ALERT_TEMPLATE_ID}        Evaluate    $pcc_server_dict.get("templateId", None)
                                    Set Suite Variable    ${ALERT_TEMPLATE_ID}
                                        
        ${ALERT_RAW_FILE}           Evaluate    $pcc_server_dict.get("raw_file", None)
                                    Set Suite Variable    ${ALERT_RAW_FILE}   
                                    
        ${ALERT_RAW_NAME}           Evaluate    $pcc_server_dict.get("raw_name", None)
                                    Set Suite Variable    ${ALERT_RAW_NAME} 
                                    

###################################################################################################################################
Load Node Groups Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Node Groups Data*
                                    Log To Console      **** Load Node Groups Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json    node_groups
                            
        ${NODE_GROUP1}              Evaluate    $pcc_server_dict.get("group1_name", None)
                                    Set Suite Variable    ${NODE_GROUP1}
                                        
        ${NODE_GROUP2}              Evaluate    $pcc_server_dict.get("group2_name", None)
                                    Set Suite Variable    ${NODE_GROUP2}
                                      
        ${NODE_GROUP3}              Evaluate    $pcc_server_dict.get("group3_name", None)
                                    Set Suite Variable    ${NODE_GROUP3}
                                        
        ${NODE_GROUP4}              Evaluate    $pcc_server_dict.get("group4_name", None)
                                    Set Suite Variable    ${NODE_GROUP4}                                          
                                    
        ${NODE_GROUP5}              Evaluate    $pcc_server_dict.get("group5_name", None)
                                    Set Suite Variable    ${NODE_GROUP5}
                                      
        ${NODE_GROUP6}              Evaluate    $pcc_server_dict.get("group6_name", None)
                                    Set Suite Variable    ${NODE_GROUP6}
                                        
        ${NODE_GROUP7}              Evaluate    $pcc_server_dict.get("group7_name", None)
                                    Set Suite Variable    ${NODE_GROUP7}
                                    
        ${NODE_GROUP8}              Evaluate    $pcc_server_dict.get("group8_name", None)
                                    Set Suite Variable    ${NODE_GROUP8}
        
        ${NODE_GROUP9}              Evaluate    $pcc_server_dict.get("group9_name", None)
                                    Set Suite Variable    ${NODE_GROUP9}                                                         
                                    
        ${NODE_GROUP_DESC1}         Evaluate    $pcc_server_dict.get("group1_desc", None)
                                    Set Suite Variable    ${NODE_GROUP_DESC1}
                                    
        ${NODE_GROUP_DESC2}         Evaluate    $pcc_server_dict.get("group2_desc", None)
                                    Set Suite Variable    ${NODE_GROUP_DESC2}
                                    
        ${NODE_GROUP_DESC3}         Evaluate    $pcc_server_dict.get("group3_desc", None)
                                    Set Suite Variable    ${NODE_GROUP_DESC3}
                                    
        ${NODE_GROUP_DESC4}         Evaluate    $pcc_server_dict.get("group4_desc", None)
                                    Set Suite Variable    ${NODE_GROUP_DESC4}
                                    
        ${NODE_GROUP_DESC5}         Evaluate    $pcc_server_dict.get("group5_desc", None)
                                    Set Suite Variable    ${NODE_GROUP_DESC5}
                                    
        ${NODE_GROUP_DESC6}         Evaluate    $pcc_server_dict.get("group6_desc", None)
                                    Set Suite Variable    ${NODE_GROUP_DESC6}
                                    
        ${NODE_GROUP_DESC7}         Evaluate    $pcc_server_dict.get("group7_desc", None)
                                    Set Suite Variable    ${NODE_GROUP_DESC7}
        
        ${NODE_GROUP_DESC8}         Evaluate    $pcc_server_dict.get("group8_desc", None)
                                    Set Suite Variable    ${NODE_GROUP_DESC8}
        
        ${NODE_GROUP_DESC9}         Evaluate    $pcc_server_dict.get("group9_desc", None)
                                    Set Suite Variable    ${NODE_GROUP_DESC9}
                                
###################################################################################################################################
Load Tenant Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Tenant Data*
                                    Log To Console      **** Load Tenant Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json    tenant
                            
        ${ROOT_TENANT}              Evaluate    $pcc_server_dict.get("root_tenant", None)
                                    Set Suite Variable    ${ROOT_TENANT}
                                        
        ${TENANT1}              Evaluate    $pcc_server_dict.get("tenant_1", None)
                                Set Suite Variable    ${TENANT1}
                                      
        ${TENANT2}              Evaluate    $pcc_server_dict.get("tenant_2", None)
                                Set Suite Variable    ${TENANT2}
                                        
        ${TENANT3}              Evaluate    $pcc_server_dict.get("tenant_3", None)
                                Set Suite Variable    ${TENANT3}                                          
                                    
        ${TENANT4}              Evaluate    $pcc_server_dict.get("tenant_4", None)
                                Set Suite Variable    ${TENANT4}
                                      
        ${TENANT5}              Evaluate    $pcc_server_dict.get("tenant_5", None)
                                Set Suite Variable    ${TENANT5}
                                        
        ${TENANT6}              Evaluate    $pcc_server_dict.get("tenant_6", None)
                                Set Suite Variable    ${TENANT6}
                                    
        ${TENANT7}              Evaluate    $pcc_server_dict.get("tenant_7", None)
                                Set Suite Variable    ${TENANT7}
        
        ${ROOT_TENANT_DESC}     Evaluate    $pcc_server_dict.get("root_tenant_desc", None)
                                Set Suite Variable    ${ROOT_TENANT_DESC}                                                         
                                    
        ${TENANT1_DESC}         Evaluate    $pcc_server_dict.get("tenant_desc_1", None)
                                Set Suite Variable    ${TENANT1_DESC}
                                    
        ${TENANT2_DESC}         Evaluate    $pcc_server_dict.get("tenant_desc_2", None)
                                Set Suite Variable    ${TENANT2_DESC}
                                    
        ${TENANT3_DESC}         Evaluate    $pcc_server_dict.get("tenant_desc_3", None)
                                Set Suite Variable    ${TENANT3_DESC}
                                    
        ${TENANT4_DESC}         Evaluate    $pcc_server_dict.get("tenant_desc_4", None)
                                Set Suite Variable    ${TENANT4_DESC}
                                    
        ${TENANT5_DESC}         Evaluate    $pcc_server_dict.get("tenant_desc_5", None)
                                Set Suite Variable    ${TENANT5_DESC}
                                    
        ${TENANT6_DESC}         Evaluate    $pcc_server_dict.get("tenant_desc_6", None)
                                Set Suite Variable    ${TENANT6_DESC}
                                    
        ${TENANT7_DESC}         Evaluate    $pcc_server_dict.get("tenant_desc_7", None)
                                Set Suite Variable    ${TENANT7_DESC}
        
        ${SUB_TENANT}           Evaluate    $pcc_server_dict.get("sub_tenant", None)
                                Set Suite Variable    ${SUB_TENANT}
                                
        ${SUB_TENANT_DESC}      Evaluate    $pcc_server_dict.get("sub_tenant_desc", None)
                                Set Suite Variable    ${SUB_TENANT_DESC}        
                                
###################################################################################################################################
Load Node Roles Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Node Roles Data*
                                    Log To Console      **** Load Node Roles Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json    node_roles
                            
        ${APP_1}                Evaluate    $pcc_server_dict.get("app_1", None)
                                Set Suite Variable    ${APP_1}
                                        
        ${APP_2}                Evaluate    $pcc_server_dict.get("app_2", None)
                                Set Suite Variable    ${APP_2}
                                      
        ${NODE_ROLE_1}          Evaluate    $pcc_server_dict.get("node_role1", None)
                                Set Suite Variable    ${NODE_ROLE_1}
                                        
        ${NODE_ROLE_2}          Evaluate    $pcc_server_dict.get("node_role2", None)
                                Set Suite Variable    ${NODE_ROLE_2}                                          
                                    
        ${NODE_ROLE_3}          Evaluate    $pcc_server_dict.get("node_role3", None)
                                Set Suite Variable    ${NODE_ROLE_3}
                                      
        ${NODE_ROLE_4}          Evaluate    $pcc_server_dict.get("node_role4", None)
                                Set Suite Variable    ${NODE_ROLE_4}
                                        
        ${NODE_ROLE_5}          Evaluate    $pcc_server_dict.get("node_role5", None)
                                Set Suite Variable    ${NODE_ROLE_5}
                                    
        ${NODE_ROLE_6}          Evaluate    $pcc_server_dict.get("node_role6", None)
                                Set Suite Variable    ${NODE_ROLE_6}
        
        ${NODE_ROLE_7}          Evaluate    $pcc_server_dict.get("node_role7", None)
                                Set Suite Variable    ${NODE_ROLE_7}
                                
        ${NODE_ROLE_8}          Evaluate    $pcc_server_dict.get("node_role8", None)
                                Set Suite Variable    ${NODE_ROLE_8}
                                
        ${NODE_ROLE_9}          Evaluate    $pcc_server_dict.get("node_role9", None)
                                Set Suite Variable    ${NODE_ROLE_9}
                                
        ${NODE_ROLE_10}         Evaluate    $pcc_server_dict.get("node_role10", None)
                                Set Suite Variable    ${NODE_ROLE_10}
                                
        ${NODE_ROLE_11}         Evaluate    $pcc_server_dict.get("node_role11", None)
                                Set Suite Variable    ${NODE_ROLE_11}
        
        ${MULTIPLE_NODE_ROLE}   Evaluate    $pcc_server_dict.get("multiple_noderole", None)
                                Set Suite Variable    ${MULTIPLE_NODE_ROLE}                                                                                                       
                                    
        ${NODE_ROLE_DESC_1}     Evaluate    $pcc_server_dict.get("node_role_desc1", None)
                                Set Suite Variable    ${NODE_ROLE_DESC_1}
                                    
        ${NODE_ROLE_DESC_2}     Evaluate    $pcc_server_dict.get("node_role_desc2", None)
                                Set Suite Variable    ${NODE_ROLE_DESC_2}
                                    
        ${NODE_ROLE_DESC_3}     Evaluate    $pcc_server_dict.get("node_role_desc3", None)
                                Set Suite Variable    ${NODE_ROLE_DESC_3}
                                    
        ${NODE_ROLE_DESC_4}     Evaluate    $pcc_server_dict.get("node_role_desc4", None)
                                Set Suite Variable    ${NODE_ROLE_DESC_4}
                                    
        ${NODE_ROLE_DESC_5}     Evaluate    $pcc_server_dict.get("node_role_desc5", None)
                                Set Suite Variable    ${NODE_ROLE_DESC_5}
                                    
        ${NODE_ROLE_DESC_6}     Evaluate    $pcc_server_dict.get("node_role_desc6", None)
                                Set Suite Variable    ${NODE_ROLE_DESC_6}
                                    
        ${NODE_ROLE_DESC_7}     Evaluate    $pcc_server_dict.get("node_role_desc7", None)
                                Set Suite Variable    ${NODE_ROLE_DESC_7}
                                
        ${NODE_ROLE_DESC_8}     Evaluate    $pcc_server_dict.get("node_role_desc8", None)
                                Set Suite Variable    ${NODE_ROLE_DESC_8}
        
        ${NODE_ROLE_DESC_9}     Evaluate    $pcc_server_dict.get("node_role_desc9", None)
                                Set Suite Variable    ${NODE_ROLE_DESC_9}
                                
        ${NODE_ROLE_DESC_10}    Evaluate    $pcc_server_dict.get("node_role_desc10", None)
                                Set Suite Variable    ${NODE_ROLE_DESC_10}
                                
        ${NODE_ROLE_DESC_11}    Evaluate    $pcc_server_dict.get("node_role_desc11", None)
                                Set Suite Variable    ${NODE_ROLE_DESC_11}
                                
        ${MULTIPLE_NODE_ROLE_DESC}    Evaluate    $pcc_server_dict.get("multiple_noderole_desc", None)
                                      Set Suite Variable    ${MULTIPLE_NODE_ROLE_DESC}
                                      
###################################################################################################################################
Load SAS Enclosure Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load SAS Enclosure Data*
                                    Log To Console      **** Load Node Roles Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json    SAS_Enclosure
                            
        ${SUB-ENCLOSURE_NAME}   Evaluate    $pcc_server_dict.get("sub-enclosure_name", None)
                                Set Suite Variable    ${SUB-ENCLOSURE_NAME}

###################################################################################################################################
Load Network Manager Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Network Manager Data*
                                    Log To Console      **** Load Network Manager Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json   network_manager


        ${NETWORK_MANAGER_NAME}    Evaluate    $pcc_server_dict.get("name", None)
                                   Set Suite Variable    ${NETWORK_MANAGER_NAME}

        ${NETWORK_MANAGER_NODES}    Evaluate    $pcc_server_dict.get("nodes", None)
                                    Set Suite Variable    ${NETWORK_MANAGER_NODES}

        ${NETWORK_MANAGER_NODES_IP}    Evaluate    $pcc_server_dict.get("nodes_ip", None)
                                       Set Suite Variable    ${NETWORK_MANAGER_NODES_IP}

        ${NETWORK_MANAGER_CNTLCIDR}    Evaluate    $pcc_server_dict.get("controlCIDR", None)
                                       Set Suite Variable    ${NETWORK_MANAGER_CNTLCIDR}

        ${NETWORK_MANAGER_DATACIDR}    Evaluate    $pcc_server_dict.get("dataCIDR", None)
                                       Set Suite Variable    ${NETWORK_MANAGER_DATACIDR}

        ${NETWORK_MANAGER_IGWPOLICY}    Evaluate    $pcc_server_dict.get("igwPolicy", None)
                                        Set Suite Variable    ${NETWORK_MANAGER_IGWPOLICY}

        ${NETWORK_MANAGER_BGP_NEIGHBORS}    Evaluate    $pcc_server_dict.get("bgp_neighbors", None)
                                        Set Suite Variable    ${NETWORK_MANAGER_BGP_NEIGHBORS}


###################################################################################################################################
Load Ipam Data
###################################################################################################################################
    [Arguments]                        ${testdata_filename}
    [Documentation]                    *Load Ipam Data*
                                       Log To Console      **** Load Ipam Data ****
        ${pcc_server_dict}             TESTDATA.Get        ${testdata_filename}.json   ipam


        ${IPAM_CONTROL_SUBNET_NAME}    Evaluate    $pcc_server_dict.get("controlName", None)
                                       Set Suite Variable    ${IPAM_CONTROL_SUBNET_NAME}

        ${IPAM_DATA_SUBNET_NAME}       Evaluate    $pcc_server_dict.get("dataName", None)
                                       Set Suite Variable    ${IPAM_DATA_SUBNET_NAME}

        ${IPAM_CONTROL_SUBNET_IP}      Evaluate    $pcc_server_dict.get("controlSubnet", None)
                                       Set Suite Variable    ${IPAM_CONTROL_SUBNET_IP}

        ${IPAM_DATA_SUBNET_IP}         Evaluate    $pcc_server_dict.get("dataSubnet", None)
                                       Set Suite Variable    ${IPAM_DATA_SUBNET_IP}

###################################################################################################################################
Load PCC Secondary Test Data
###################################################################################################################################
    [Arguments]                     ${testdata_key}

        [Documentation]             *Load PCC Test Data*
                                         Log To Console          **** Load PCC Test Data ****

        ${pcc_multisite_dict}            TESTDATA.Get            ${testdata_key}.json        ceph_multisite

        ${PCC_SERVER_SECONDARY}          Evaluate                $pcc_multisite_dict.get("pcc_server", None)
                                         Set Suite Variable      ${PCC_SERVER_SECONDARY}

        ${PCC_URL_SECONDARY}             Evaluate                $PCC_SERVER_SECONDARY.get("pcc_url", None)
                                         Set Suite Variable      ${PCC_URL_SECONDARY}

        ${PCC_HOST_IP_SECONDARY}         Evaluate                $PCC_SERVER_SECONDARY.get("pcc_host_ip", None)
                                         Set Suite Variable      ${PCC_HOST_IP_SECONDARY}

        ${PCC_USERNAME_SECONDARY}         Evaluate                $PCC_SERVER_SECONDARY.get("pcc_username", None)
                                          Set Suite Variable      ${PCC_USERNAME_SECONDARY}

        ${PCC_PASSWORD_SECONDARY}         Evaluate                $PCC_SERVER_SECONDARY.get("pcc_password", None)
                                          Set Suite Variable      ${PCC_PASSWORD_SECONDARY}

        ${PCC_LINUX_USER_SECONDARY}       Evaluate                $PCC_SERVER_SECONDARY.get("pcc_linux_user", None)
                                          Set Suite Variable      ${PCC_LINUX_USER_SECONDARY}

        ${PCC_LINUX_PASSWORD_SECONDARY}   Evaluate                $PCC_SERVER_SECONDARY.get("pcc_linux_password", None)
                                          Set Suite Variable      ${PCC_LINUX_PASSWORD_SECONDARY}

###################################################################################################################################
Load Clusterhead 1 Secondary Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Clusterhead 1 Secondary Test Data*
                                Log To Console          **** Load Clusterhead 1 Secondary Test Data ****
            ${pcc_multisite_dict}            TESTDATA.Get            ${testdata_key}.json        ceph_multisite

            ${CLUSTERHEAD_1_SECONDARY}          Evaluate                $pcc_multisite_dict.get("clusterhead-1", None)
                                                Set Suite Variable      ${CLUSTERHEAD_1_SECONDARY}

            ${CLUSTERHEAD_1_NAME_SECONDARY}     Evaluate                $CLUSTERHEAD_1_SECONDARY.get("invader_name", None)
                                                Set Suite Variable      ${CLUSTERHEAD_1_NAME_SECONDARY}

            ${CLUSTERHEAD_1_HOST_IP_SECONDARY}  Evaluate                $CLUSTERHEAD_1_SECONDARY.get("pcc_host_ip", None)
                                                Set Suite Variable      ${CLUSTERHEAD_1_HOST_IP_SECONDARY}

            ${CLUSTERHEAD_1_UNAME_SECONDARY}    Evaluate                $CLUSTERHEAD_1_SECONDARY.get("pcc_username", None)
                                                Set Suite Variable      ${CLUSTERHEAD_1_UNAME_SECONDARY}

            ${CLUSTERHEAD_1_PWD_SECONDARY}      Evaluate                $CLUSTERHEAD_1_SECONDARY.get("pcc_password", None)
                                                Set Suite Variable      ${CLUSTERHEAD_1_PWD_SECONDARY}

###################################################################################################################################
Load Clusterhead 2 Secondary Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Clusterhead 2 Secondary Test Data*
                                Log To Console          **** Load Clusterhead 2 Secondary Test Data ****
            ${pcc_multisite_dict}            TESTDATA.Get            ${testdata_key}.json        ceph_multisite

            ${CLUSTERHEAD_2_SECONDARY}          Evaluate                $pcc_multisite_dict.get("clusterhead-2", None)
                                                Set Suite Variable      ${CLUSTERHEAD_2_SECONDARY}

            ${CLUSTERHEAD_2_NAME_SECONDARY}     Evaluate                $CLUSTERHEAD_2_SECONDARY.get("invader_name", None)
                                                Set Suite Variable      ${CLUSTERHEAD_2_NAME_SECONDARY}

            ${CLUSTERHEAD_2_HOST_IP_SECONDARY}  Evaluate                $CLUSTERHEAD_2_SECONDARY.get("pcc_host_ip", None)
                                                Set Suite Variable      ${CLUSTERHEAD_2_HOST_IP_SECONDARY}

            ${CLUSTERHEAD_2_UNAME_SECONDARY}    Evaluate                $CLUSTERHEAD_2_SECONDARY.get("pcc_username", None)
                                                Set Suite Variable      ${CLUSTERHEAD_2_UNAME_SECONDARY}

            ${CLUSTERHEAD_2_PWD_SECONDARY}      Evaluate                $CLUSTERHEAD_2_SECONDARY.get("pcc_password", None)
                                                Set Suite Variable      ${CLUSTERHEAD_2_PWD_SECONDARY}

###################################################################################################################################
Load Server 1 Secondary Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Server 1 Secondary Test Data*
                                Log To Console          **** Load Server 1 Secondary Test Data ****

            ${pcc_multisite_dict}            TESTDATA.Get            ${testdata_key}.json        ceph_multisite

            ${SERVER_1_SECONDARY}          Evaluate                $pcc_multisite_dict.get("server-1", None)
                                           Set Suite Variable      ${SERVER_1_SECONDARY}


            ${SERVER_1_NAME_SECONDARY}      Evaluate    $SERVER_1_SECONDARY.get("server_name", None)
                                            Set Suite Variable    ${SERVER_1_NAME_SECONDARY}

            ${SERVER_1_HOST_IP_SECONDARY}   Evaluate    $SERVER_1_SECONDARY.get("pcc_host_ip", None)
                                            Set Suite Variable    ${SERVER_1_HOST_IP_SECONDARY}

            ${SERVER_1_UNAME_SECONDARY}     Evaluate    $SERVER_1_SECONDARY.get("pcc_username", None)
                                            Set Suite Variable    ${SERVER_1_UNAME_SECONDARY}

            ${SERVER_1_PWD_SECONDARY}       Evaluate    $SERVER_1_SECONDARY.get("pcc_password", None)
                                            Set Suite Variable    ${SERVER_1_PWD_SECONDARY}

###################################################################################################################################
Load Server 2 Secondary Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Server 2 Secondary Test Data*
                                Log To Console          **** Load Server 2 Secondary Test Data ****

            ${pcc_multisite_dict}            TESTDATA.Get            ${testdata_key}.json        ceph_multisite

            ${SERVER_2_SECONDARY}          Evaluate                $pcc_multisite_dict.get("server-2", None)
                                           Set Suite Variable      ${SERVER_1_SECONDARY}


            ${SERVER_2_NAME_SECONDARY}      Evaluate    $SERVER_2_SECONDARY.get("server_name", None)
                                            Set Suite Variable    ${SERVER_2_NAME_SECONDARY}

            ${SERVER_2_HOST_IP_SECONDARY}   Evaluate    $SERVER_2_SECONDARY.get("pcc_host_ip", None)
                                            Set Suite Variable    ${SERVER_2_HOST_IP_SECONDARY}

            ${SERVER_2_UNAME_SECONDARY}     Evaluate    $SERVER_2_SECONDARY.get("pcc_username", None)
                                            Set Suite Variable    ${SERVER_2_UNAME_SECONDARY}

            ${SERVER_2_PWD_SECONDARY}       Evaluate    $SERVER_2_SECONDARY.get("pcc_password", None)
                                            Set Suite Variable    ${SERVER_2_PWD_SECONDARY}

###################################################################################################################################
Load Server 3 Secondary Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Server 3 Secondary Test Data*
                                Log To Console          **** Load Server 3 Secondary Test Data ****

            ${pcc_multisite_dict}            TESTDATA.Get            ${testdata_key}.json        ceph_multisite

            ${SERVER_3_SECONDARY}          Evaluate                $pcc_multisite_dict.get("server-3", None)
                                           Set Suite Variable      ${SERVER_3_SECONDARY}


            ${SERVER_3_NAME_SECONDARY}      Evaluate    $SERVER_3_SECONDARY.get("server_name", None)
                                            Set Suite Variable    ${SERVER_3_NAME_SECONDARY}

            ${SERVER_3_HOST_IP_SECONDARY}   Evaluate    $SERVER_3_SECONDARY.get("pcc_host_ip", None)
                                            Set Suite Variable    ${SERVER_3_HOST_IP_SECONDARY}

            ${SERVER_3_UNAME_SECONDARY}     Evaluate    $SERVER_3_SECONDARY.get("pcc_username", None)
                                            Set Suite Variable    ${SERVER_3_UNAME_SECONDARY}

            ${SERVER_3_PWD_SECONDARY}       Evaluate    $SERVER_3_SECONDARY.get("pcc_password", None)
                                            Set Suite Variable    ${SERVER_3_PWD_SECONDARY}

###################################################################################################################################
Load Server 4 Secondary Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Server 4 Secondary Test Data*
                                Log To Console          **** Load Server 4 Secondary Test Data ****

            ${pcc_multisite_dict}            TESTDATA.Get            ${testdata_key}.json        ceph_multisite

            ${SERVER_4_SECONDARY}          Evaluate                $pcc_multisite_dict.get("server-4", None)
                                           Set Suite Variable      ${SERVER_4_SECONDARY}


            ${SERVER_4_NAME_SECONDARY}      Evaluate    $SERVER_4_SECONDARY.get("server_name", None)
                                            Set Suite Variable    ${SERVER_4_NAME_SECONDARY}

            ${SERVER_4_HOST_IP_SECONDARY}   Evaluate    $SERVER_4_SECONDARY.get("pcc_host_ip", None)
                                            Set Suite Variable    ${SERVER_4_HOST_IP_SECONDARY}

            ${SERVER_4_UNAME_SECONDARY}     Evaluate    $SERVER_4_SECONDARY.get("pcc_username", None)
                                            Set Suite Variable    ${SERVER_4_UNAME_SECONDARY}

            ${SERVER_4_PWD_SECONDARY}       Evaluate    $SERVER_4_SECONDARY.get("pcc_password", None)
                                            Set Suite Variable    ${SERVER_4_PWD_SECONDARY}

###################################################################################################################################
Load Server 5 Secondary Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Server 5 Secondary Test Data*
                                Log To Console          **** Load Server 5 Secondary Test Data ****

            ${pcc_multisite_dict}            TESTDATA.Get            ${testdata_key}.json        ceph_multisite

            ${SERVER_5_SECONDARY}          Evaluate                $pcc_multisite_dict.get("server-5", None)
                                           Set Suite Variable      ${SERVER_5_SECONDARY}


            ${SERVER_5_NAME_SECONDARY}      Evaluate    $SERVER_5_SECONDARY.get("server_name", None)
                                            Set Suite Variable    ${SERVER_5_NAME_SECONDARY}

            ${SERVER_5_HOST_IP_SECONDARY}   Evaluate    $SERVER_5_SECONDARY.get("pcc_host_ip", None)
                                            Set Suite Variable    ${SERVER_5_HOST_IP_SECONDARY}

            ${SERVER_5_UNAME_SECONDARY}     Evaluate    $SERVER_5_SECONDARY.get("pcc_username", None)
                                            Set Suite Variable    ${SERVER_5_UNAME_SECONDARY}

            ${SERVER_5_PWD_SECONDARY}       Evaluate    $SERVER_5_SECONDARY.get("pcc_password", None)
                                            Set Suite Variable    ${SERVER_5_PWD_SECONDARY}


###################################################################################################################################
Load Server 6 Secondary Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key}

        [Documentation]         *Load Server 6 Secondary Test Data*
                                Log To Console          **** Load Server 6 Secondary Test Data ****

            ${pcc_multisite_dict}            TESTDATA.Get            ${testdata_key}.json        ceph_multisite

            ${SERVER_6_SECONDARY}          Evaluate                $pcc_multisite_dict.get("server-6", None)
                                           Set Suite Variable      ${SERVER_6_SECONDARY}


            ${SERVER_6_NAME_SECONDARY}      Evaluate    $SERVER_6_SECONDARY.get("server_name", None)
                                            Set Suite Variable    ${SERVER_6_NAME_SECONDARY}

            ${SERVER_6_HOST_IP_SECONDARY}   Evaluate    $SERVER_6_SECONDARY.get("pcc_host_ip", None)
                                            Set Suite Variable    ${SERVER_6_HOST_IP_SECONDARY}

            ${SERVER_6_UNAME_SECONDARY}     Evaluate    $SERVER_6_SECONDARY.get("pcc_username", None)
                                            Set Suite Variable    ${SERVER_6_UNAME_SECONDARY}

            ${SERVER_6_PWD_SECONDARY}       Evaluate    $SERVER_6_SECONDARY.get("pcc_password", None)
                                            Set Suite Variable    ${SERVER_6_PWD_SECONDARY}
###################################################################################################################################
Load Ipam Data Secondary
###################################################################################################################################
    [Arguments]                        ${testdata_filename}
    [Documentation]                    *Load Ipam Data Secondary*
                                       Log To Console      **** Load Ipam Data Secondary****

         ${pcc_multisite_dict}            TESTDATA.Get            ${testdata_filename}.json        ceph_multisite

         ${IPAM_SECONDARY}                          Evaluate    $pcc_multisite_dict.get("ipam", None)
                                                    Set Suite Variable    ${IPAM_SECONDARY}

        ${IPAM_CONTROL_SUBNET_NAME_SECONDARY}       Evaluate    $IPAM_SECONDARY.get("controlName", None)
                                                    Set Suite Variable    ${IPAM_CONTROL_SUBNET_NAME_SECONDARY}

        ${IPAM_DATA_SUBNET_NAME_SECONDARY}          Evaluate    $IPAM_SECONDARY.get("dataName", None)
                                                    Set Suite Variable    ${IPAM_DATA_SUBNET_NAME_SECONDARY}

        ${IPAM_CONTROL_SUBNET_IP_SECONDARY}         Evaluate    $IPAM_SECONDARY.get("controlSubnet", None)
                                                    Set Suite Variable    ${IPAM_CONTROL_SUBNET_IP_SECONDARY}

        ${IPAM_DATA_SUBNET_IP_SECONDARY}            Evaluate    $IPAM_SECONDARY.get("dataSubnet", None)
                                                    Set Suite Variable    ${IPAM_DATA_SUBNET_IP_SECONDARY}

###################################################################################################################################
Load Network Manager Data Secondary
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Network Manager Data Secondary*
                                    Log To Console      **** Load Network Manager Data Secondary ****

         ${pcc_multisite_dict}            TESTDATA.Get            ${testdata_filename}.json        ceph_multisite

         ${NETWORK_MANAGER_SECONDARY}           Evaluate    $pcc_multisite_dict.get("network_manager", None)
                                                Set Suite Variable      ${NETWORK_MANAGER_SECONDARY}

        ${NETWORK_MANAGER_NAME_SECONDARY}       Evaluate    $NETWORK_MANAGER_SECONDARY.get("name", None)
                                                Set Suite Variable    ${NETWORK_MANAGER_NAME_SECONDARY}

        ${NETWORK_MANAGER_NODES_SECONDARY}      Evaluate    $NETWORK_MANAGER_SECONDARY.get("nodes", None)
                                                Set Suite Variable    ${NETWORK_MANAGER_NODES_SECONDARY}

        ${NETWORK_MANAGER_NODES_IP_SECONDARY}   Evaluate    $NETWORK_MANAGER_SECONDARY.get("nodes_ip", None)
                                                Set Suite Variable    ${NETWORK_MANAGER_NODES_IP_SECONDARY}

        ${NETWORK_MANAGER_CNTLCIDR_SECONDARY}   Evaluate    $NETWORK_MANAGER_SECONDARY.get("controlCIDR", None)
                                                Set Suite Variable    ${NETWORK_MANAGER_CNTLCIDR_SECONDARY}

        ${NETWORK_MANAGER_DATACIDR_SECONDARY}   Evaluate    $NETWORK_MANAGER_SECONDARY.get("dataCIDR", None)
                                                Set Suite Variable    ${NETWORK_MANAGER_DATACIDR_SECONDARY}

        ${NETWORK_MANAGER_IGWPOLICY_SECONDARY}  Evaluate    $NETWORK_MANAGER_SECONDARY.get("igwPolicy", None)
                                                Set Suite Variable    ${NETWORK_MANAGER_IGWPOLICY_SECONDARY}

        ${NETWORK_MANAGER_BGP_NEIGHBORS_SECONDARY}        Evaluate    $NETWORK_MANAGER_SECONDARY.get("bgp_neighbors", None)
                                                Set Suite Variable    ${NETWORK_MANAGER_BGP_NEIGHBORS_SECONDARY}
###################################################################################################################################
Load Ceph Cluster Data Secondary
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 * Load Ceph Cluster Data Secondary  *
                                    Log To Console      **** Load Ceph Cluster Data Secondary****
        ${pcc_multisite_dict}            TESTDATA.Get            ${testdata_filename}.json        ceph_multisite

        ${CEPH_CLUSTER_SECONDARY}           Evaluate    $pcc_multisite_dict.get("ceph_cluster", None)
                                            Set Suite Variable      ${CEPH_CLUSTER_SECONDARY}

                                    # Ceph
        ${CEPH_CLUSTER_NAME_SECONDARY}        Evaluate    $CEPH_CLUSTER_SECONDARY.get("name", None)
                                    Set Suite Variable    ${CEPH_CLUSTER_NAME_SECONDARY}

        ${CEPH_CLUSTER_NODES_SECONDARY}       Evaluate    $CEPH_CLUSTER_SECONDARY.get("nodes", None)
                                    Set Suite Variable    ${CEPH_CLUSTER_NODES_SECONDARY}

        ${CEPH_CLUSTER_NODES_IP_SECONDARY}    Evaluate    $CEPH_CLUSTER_SECONDARY.get("nodes_ip", None)
                                    Set Suite Variable    ${CEPH_CLUSTER_NODES_IP_SECONDARY}

        ${CEPH_CLUSTER_TAGS_SECONDARY}        Evaluate    $CEPH_CLUSTER_SECONDARY.get("tags", None)
                                    Set Suite Variable    ${CEPH_CLUSTER_TAGS_SECONDARY}

        ${CEPH_CLUSTER_NETWORK_SECONDARY}     Evaluate    $CEPH_CLUSTER_SECONDARY.get("networkClusterName", None)
                                    Set Suite Variable    ${CEPH_CLUSTER_NETWORK_SECONDARY}

###################################################################################################################################
Load Ceph Pool Data Secondary
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Ceph Pool Data Secondary*
                                    Log To Console      **** Load Ceph Pool Data Secondary ****

        ${pcc_multisite_dict}            TESTDATA.Get            ${testdata_filename}.json        ceph_multisite

        ${CEPH_POOL_SECONDARY}           Evaluate    $pcc_multisite_dict.get("ceph_pool", None)
                                         Set Suite Variable      ${CEPH_POOL_SECONDARY}

                                    # Ceph
        ${CEPH_POOL_NAME_SECONDARY}           Evaluate    $CEPH_POOL_SECONDARY.get("name", None)
                                              Set Suite Variable    ${CEPH_POOL_NAME_SECONDARY}

        ${CEPH_POOL_SIZE_SECONDARY}           Evaluate    $CEPH_POOL_SECONDARY.get("size", None)
                                              Set Suite Variable    ${CEPH_POOL_SIZE_SECONDARY}

        ${CEPH_POOL_TYPE_SECONDARY}           Evaluate    $CEPH_POOL_SECONDARY.get("pool_type", None)
                                              Set Suite Variable    ${CEPH_POOL_TYPE_SECONDARY}

	    ${POOL_RESILIENCE_SCHEME_SECONDARY}   Evaluate    $CEPH_POOL_SECONDARY.get("resilienceScheme", None)
                                              Set Suite Variable    ${POOL_RESILIENCE_SCHEME_SECONDARY}

        ${CEPH_POOL_TAGS_SECONDARY}           Evaluate    $CEPH_POOL_SECONDARY.get("tags", None)
                                              Set Suite Variable    ${CEPH_POOL_TAGS_SECONDARY}

        ${CEPH_POOL_QUOTA_SECONDARY}          Evaluate    $CEPH_POOL_SECONDARY.get("quota", None)
                                              Set Suite Variable    ${CEPH_POOL_QUOTA_SECONDARY}

        ${CEPH_POOL_QUOTA_UNIT_SECONDARY}     Evaluate    $CEPH_POOL_SECONDARY.get("quota_unit", None)
                                              Set Suite Variable    ${CEPH_POOL_QUOTA_UNIT_SECONDARY}

###################################################################################################################################
Load Ceph Rgw Data Secondary
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Ceph Rgw Data*
                                    Log To Console      **** Load Ceph Secondary Rgw Data ****

        ${pcc_multisite_dict}            TESTDATA.Get            ${testdata_filename}.json        ceph_multisite

        ${CEPH_RGW_SECONDARY}           Evaluate    $pcc_multisite_dict.get("ceph_rgw", None)
                                         Set Suite Variable      ${CEPH_RGW_SECONDARY}

        ${CEPH_RGW_NAME_SECONDARY}             Evaluate    $CEPH_RGW_SECONDARY.get("name", None)
                                     Set Suite Variable    ${CEPH_RGW_NAME_SECONDARY}

        ${CEPH_RGW_POOLNAME_SECONDARY}         Evaluate    $CEPH_RGW_SECONDARY.get("poolName", None)
                                     Set Suite Variable    ${CEPH_RGW_POOLNAME_SECONDARY}

        ${CEPH_RGW_NUMDAEMONSMAP_SECONDARY}    Evaluate    $CEPH_RGW_SECONDARY.get("numDaemonsMap", None)
                                     Set Suite Variable    ${CEPH_RGW_NUMDAEMONSMAP_SECONDARY}

        ${CEPH_RGW_PORT_SECONDARY}             Evaluate    $CEPH_RGW_SECONDARY.get("port", None)
                                     Set Suite Variable    ${CEPH_RGW_PORT_SECONDARY}

        ${CEPH_RGW_CERT_NAME_SECONDARY}        Evaluate    $CEPH_RGW_SECONDARY.get("certificateName", None)
                                     Set Suite Variable    ${CEPH_RGW_CERT_NAME_SECONDARY}

        ${CEPH_RGW_CERT_URL_SECONDARY}        Evaluate    $CEPH_RGW_SECONDARY.get("certificateUrl", None)
                                     Set Suite Variable    ${CEPH_RGW_CERT_URL_SECONDARY}

        ${CEPH_RGW_CERT_NAME_LB_SECONDARY}     Evaluate    $CEPH_RGW_SECONDARY.get("certificateNameLB", None)
                                     Set Suite Variable    ${CEPH_RGW_CERT_NAME_LB_SECONDARY}

        ${CEPH_RGW_CERT_URL_LB_SECONDARY}       Evaluate    $CEPH_RGW_SECONDARY.get("certificateUrlLB", None)
                                     Set Suite Variable    ${CEPH_RGW_CERT_URL_LB_SECONDARY}

        ${CEPH_RGW_S3ACCOUNTS_SECONDARY}       Evaluate    $CEPH_RGW_SECONDARY.get("S3Accounts", None)
                                     Set Suite Variable    ${CEPH_RGW_S3ACCOUNTS_SECONDARY}

        ${CEPH_RGW_NAME_EC_SECONDARY}             Evaluate    $CEPH_RGW_SECONDARY.get("name-ec", None)
                                     Set Suite Variable    ${CEPH_RGW_NAME_EC_SECONDARY}

        ${CEPH_RGW_POOLNAME_EC_SECONDARY}         Evaluate    $CEPH_RGW_SECONDARY.get("poolName-ec", None)
                                     Set Suite Variable    ${CEPH_RGW_POOLNAME_EC_SECONDARY}
