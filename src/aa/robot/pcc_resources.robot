*** Settings ***
Library                         aa.common.Utils
Library                         aa.common.Result
Library                         aa.common.TestData
Library                         aa.common.LinuxUtils
Library                         aa.common.DockerUtils
Library                         aa.common.AaBase

Library                         aa.pcc.Login
Library                         aa.pcc.NodeGroups
Library                         aa.pcc.Tenants
Library                         aa.pcc.Nodes
Library                         aa.pcc.ContainerRegistry
Library                         aa.pcc.Auth_Profile
Library                         aa.pcc.CephCluster
Library                         aa.pcc.CephPool
Library                         aa.pcc.CephRbd
Library                         aa.pcc.CephFs

#Library                         motorframework.pcc_keywords.NodeRoles
#Library                         motorframework.pcc_keywords.OpenSSHKeys
#Library                         motorframework.pcc_keywords.Roles
#Library                         motorframework.pcc_keywords.Sites
#Library                         motorframework.pcc_keywords.Applications
#Library                         motorframework.pcc_keywords.Kubernetes
#Library                         motorframework.pcc_keywords.Cli
#Library                         motorframework.pcc_keywords.ContainerRegistry
#Library                         motorframework.pcc_keywords.Ceph
#Library                         motorframework.pcc_keywords.CephPool
#Library                         motorframework.pcc_keywords.CephRbd
#Library                         motorframework.pcc_keywords.CephFs
#Library                         motorframework.pcc_keywords.Certificate


#Library                         motorframework.common.DockerUtils
#Library                         motorframework.common.FabricBase
#Library                         motorframework.pcc_keywords.Auth_profile
#Library                         motorframework.pcc_keywords.Tunneling
#Library                         motorframework.common.LinuxUtils

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

            ${PCC_USERNAME}         Evaluate                $pcc_server_dict.get("pcc_username", None)
                                    Set Suite Variable      ${PCC_USERNAME}

            ${PCC_PASSWORD}         Evaluate                $pcc_server_dict.get("pcc_password", None)
                                    Set Suite Variable      ${PCC_PASSWORD}
                                    
        ${TENANT_USER_PCC_USERNAME}    Evaluate    $pcc_server_dict.get("tenant_user_username", None)
                                       Set Suite Variable      ${TENANT_USER_PCC_USERNAME}
                                       
        ${TENANT_USER_PCC_PWD}    Evaluate    $pcc_server_dict.get("tenant_user_password", None)
                                  Set Suite Variable      ${TENANT_USER_PCC_PWD}

###################################################################################################################################
Load Clusterhead 1 Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key} 

        [Documentation]         *Load Clusterhead 1 Test Data* 
                                Log To Console          **** Load Clusterhead 1 Test Data ****

            ${pcc_server_dict}  TESTDATA.Get            ${testdata_key}.json        clusterhead_1

                                # Clusterhead Info
    ${CLUSTERHEAD_1_CLUSTER_ID}  Evaluate               $pcc_server_dict.get("cluster_id", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_CLUSTER_ID}

    ${CLUSTERHEAD_1_HOST}       Evaluate                $pcc_server_dict.get("host", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_HOST}

    ${CLUSTERHEAD_1_MODEL}      Evaluate                $pcc_server_dict.get("model", "")
                                Set Suite Variable      ${CLUSTERHEAD_1_MODEL}

    ${CLUSTERHEAD_1_NAME}       Evaluate                $pcc_server_dict.get("name", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_NAME}
                                Log To Console          CLUSTERHEAD_1_NAME=${CLUSTERHEAD_1_NAME}

    ${CLUSTERHEAD_1_SN}         Evaluate                $pcc_server_dict.get("sn", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_SN}

    ${CLUSTERHEAD_1_SITE_ID}    Evaluate                $pcc_server_dict.get("site_id", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_SITE_ID}

    ${CLUSTERHEAD_1_ADMIN_USER}  Evaluate               $pcc_server_dict.get("admin_user", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_ADMIN_USER}

    ${CLUSTERHEAD_1_BMC}        Evaluate                $pcc_server_dict.get("bmc", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_BMC}

    ${CLUSTERHEAD_1_BMC_PASSWORD}  Evaluate             $pcc_server_dict.get("bmc_password", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_BMC_PASSWORD}
    
    ${CLUSTERHEAD_1_BMC_USER}   Evaluate                $pcc_server_dict.get("bmc_user", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_BMC_USER}
    
    ${CLUSTERHEAD_1_CONSOLE}    Evaluate                $pcc_server_dict.get("console", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_CONSOLE}
    
    ${CLUSTERHEAD_1_MANAGED}    Evaluate                $pcc_server_dict.get("managed", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_MANAGED}

    ${CLUSTERHEAD_1_OWNER}      Evaluate                $pcc_server_dict.get("owner", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_OWNER}

    ${CLUSTERHEAD_1_ROLES}      Evaluate                $pcc_server_dict.get("roles", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_ROLES}

    ${CLUSTERHEAD_1_SSH_KEYS}   Evaluate                $pcc_server_dict.get("ssh_keys", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_SSH_KEYS}

    ${CLUSTERHEAD_1_STANDBY}    Evaluate                $pcc_server_dict.get("standby", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_STANDBY}

    ${CLUSTERHEAD_1_TAGS}       Evaluate                $pcc_server_dict.get("tags", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_TAGS}

    ${CLUSTERHEAD_1_INTERFACES}  Evaluate               $pcc_server_dict.get("interfaces", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_INTERFACES}



###################################################################################################################################
Load Clusterhead 2 Test Data
###################################################################################################################################
    [Arguments]                 ${testdata_key} 

        [Documentation]         *Load Clusterhead 2 Test Data* 
                                Log To Console          **** Load Clusterhead 2 Test Data ****

            ${pcc_server_dict}  TESTDATA.Get            ${testdata_key}.json        clusterhead_2

                                # Clusterhead Info
    ${CLUSTERHEAD_2_CLUSTER_ID}  Evaluate               $pcc_server_dict.get("cluster_id", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_CLUSTER_ID}

    ${CLUSTERHEAD_2_HOST}       Evaluate                $pcc_server_dict.get("host", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_HOST}

    ${CLUSTERHEAD_2_MODEL}      Evaluate                $pcc_server_dict.get("model", "")
                                Set Suite Variable      ${CLUSTERHEAD_2_MODEL}

    ${CLUSTERHEAD_2_NAME}       Evaluate                $pcc_server_dict.get("name", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_NAME}
                                Log To Console          CLUSTERHEAD_2_NAME=${CLUSTERHEAD_2_NAME}

    ${CLUSTERHEAD_2_SN}         Evaluate                $pcc_server_dict.get("sn", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_SN}

    ${CLUSTERHEAD_2_SITE_ID}    Evaluate                $pcc_server_dict.get("site_id", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_SITE_ID}

    ${CLUSTERHEAD_2_ADMIN_USER}  Evaluate               $pcc_server_dict.get("admin_user", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_ADMIN_USER}

    ${CLUSTERHEAD_2_BMC}        Evaluate                $pcc_server_dict.get("bmc", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_BMC}

    ${CLUSTERHEAD_2_BMC_PASSWORD}  Evaluate             $pcc_server_dict.get("bmc_password", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_BMC_PASSWORD}
    
    ${CLUSTERHEAD_2_BMC_USER}   Evaluate                $pcc_server_dict.get("bmc_user", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_BMC_USER}
    
    ${CLUSTERHEAD_2_CONSOLE}    Evaluate                $pcc_server_dict.get("console", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_CONSOLE}
    
    ${CLUSTERHEAD_2_MANAGED}    Evaluate                $pcc_server_dict.get("managed", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_MANAGED}

    ${CLUSTERHEAD_2_OWNER}      Evaluate                $pcc_server_dict.get("owner", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_OWNER}

    ${CLUSTERHEAD_2_ROLES}      Evaluate                $pcc_server_dict.get("roles", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_ROLES}

    ${CLUSTERHEAD_2_SSH_KEYS}   Evaluate                $pcc_server_dict.get("ssh_keys", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_SSH_KEYS}

    ${CLUSTERHEAD_2_STANDBY}    Evaluate                $pcc_server_dict.get("standby", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_STANDBY}

    ${CLUSTERHEAD_2_TAGS}       Evaluate                $pcc_server_dict.get("tags", None)
                                Set Suite Variable      ${CLUSTERHEAD_2_TAGS}

    ${CLUSTERHEAD_2_INTERFACES}  Evaluate               $pcc_server_dict.get("interfaces", None)
                                Set Suite Variable      ${CLUSTERHEAD_1_INTERFACES}



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

        ${CEPH_CLUSTER_CONFIG}      Evaluate    $pcc_server_dict.get("config", None)
                                    Set Suite Variable    ${CEPH_CLUSTER_CONFIG}

        ${CEPH_CLUSTER_CNTLCIDR}    Evaluate    $pcc_server_dict.get("controlCIDR", None)
                                    Set Suite Variable    ${CEPH_CLUSTER_CNTLCIDR}

        ${CEPH_CLUSTER_IGWPOLICY}      Evaluate    $pcc_server_dict.get("igwPolicy", None)
                                    Set Suite Variable    ${CEPH_CLUSTER_IGWPOLICY}

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
                                    
###################################################################################################################################
Load Invader1 Details
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Invader1 details*

                                    Log To Console      **** Load Invader Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json    qa-clusterhead-11

                                    # Container_Registry
        ${INVADER_1_NAME}            Evaluate    $pcc_server_dict.get("invader_name", None)
                                    Set Suite Variable    ${INVADER_1_NAME}
        
        ${INVADER_1_URL}            Evaluate    $pcc_server_dict.get("pcc_url", None)
                                    Set Suite Variable    ${INVADER_1_URL}

        ${INVADER_1_HOST_IP}        Evaluate    $pcc_server_dict.get("pcc_host_ip", None)
                                    Set Suite Variable    ${INVADER_1_HOST_IP}

        ${INVADER_1_LINUX_PWD}      Evaluate    $pcc_server_dict.get("pcc_linux_password", None)
                                    Set Suite Variable    ${INVADER_1_LINUX_PWD}

        ${INVADER_1_UNAME}          Evaluate    $pcc_server_dict.get("pcc_username", None)
                                    Set Suite Variable    ${INVADER_1_UNAME}

        ${INVADER_1_PWD}            Evaluate    $pcc_server_dict.get("pcc_password", None)
                                    Set Suite Variable    ${INVADER_1_PWD}

###################################################################################################################################
Load Server1 Details
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Server details*

                                    Log To Console      **** Load Invader Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json   sjc01-pd1-sv02

                                    # Container_Registry
        
        ${SERVER_1_NAME}            Evaluate    $pcc_server_dict.get("server1_name", None)
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
Load Server2 Details
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Server2 details*

                                    Log To Console      **** Load Invader Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json    qa-server-100

                                    # Container_Registry
        ${SERVER_2_NAME}            Evaluate    $pcc_server_dict.get("server2_name", None)
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
Load Tunneling Data
###################################################################################################################################
    [Arguments]                     ${testdata_filename}
    [Documentation]                 *Load Tunneling Data*

                                    Log To Console      **** Load Tunneling Data ****
        ${pcc_server_dict}          TESTDATA.Get        ${testdata_filename}.json    certificate

                                    # Certificate
        ${INVADER_1_IP}             Evaluate    $pcc_server_dict.get("invader1_ip", None)
                                    Set Suite Variable    ${INVADER_1_IP}
                                    
        ${INVADER_1_NAME}           Evaluate    $pcc_server_dict.get("invader1_name", None)
                                    Set Suite Variable    ${INVADER_1_NAME}
                                    
        ${INVADER_2_IP}             Evaluate    $pcc_server_dict.get("invader2_ip", None)
                                    Set Suite Variable    ${INVADER_2_IP}
                                    
        ${INVADER_2_NAME}           Evaluate    $pcc_server_dict.get("invader2_name", None)
                                    Set Suite Variable    ${INVADER_2_NAME}  
                                    
        ${SERVER_1_IP}              Evaluate    $pcc_server_dict.get("server1_ip", None)
                                    Set Suite Variable    ${SERVER_1_IP}
                                    
        ${SERVER_1_NAME}            Evaluate    $pcc_server_dict.get("server1_name", None)
                                    Set Suite Variable    ${SERVER_1_NAME} 
                                    
        ${SETUP_IP}                 Evaluate    $pcc_server_dict.get("setup_ip", None)
                                    Set Suite Variable    ${SETUP_IP}
                                    
        ${CIDR_VAL}                 Evaluate    $pcc_server_dict.get("cidr", None)
                                    Set Suite Variable    ${CIDR_VAL}
                                    
        ${SETUP_PWD}                Evaluate    $pcc_server_dict.get("setup_password", None)
                                    Set Suite Variable    ${SETUP_PWD}
