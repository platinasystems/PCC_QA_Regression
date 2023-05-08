*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Keywords ***

*** Test Cases ***
###################################################################################################################################
Load Test Variable
###############################################################################################################

                        Load PCC Test Data        ${pcc_setup}
                        Load Ceph Rgw Data    ${pcc_setup}
                        Load Ceph Cluster Data  ${pcc_setup}
                        Load Ceph Pool Data    ${pcc_setup}
                        Load Server 1 Test Data    ${pcc_setup}
                        Load Server 1 Secondary Test Data    ${pcc_setup}
                        Load Server 2 Test Data    ${pcc_setup}
                        Load Server 4 Secondary Test Data    ${pcc_setup}
                        Load Server 5 Secondary Test Data    ${pcc_setup}
                        Load Ceph Rgw Data Secondary    ${pcc_setup}
					    Load Ceph Pool Data Secondary   ${pcc_setup}
                        Load Ceph Cluster Data Secondary   ${pcc_setup}
                        Load Ceph Fs Data    ${pcc_setup}


        ${status}                   Login To PCC Secondary   ${pcc_setup}

####################################################################################################################################
#Ceph Delete Unused Pools
####################################################################################################################################
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#
#        ${status}                   PCC.Ceph Delete Unused Pools
#                               ...  ceph_cluster_id=${cluster_id}
#                                    Should be equal as strings    ${status}    OK
#
#                                    sleep  1m
#
###################################################################################################################################
#Ceph Create Pool For CephFS
####################################################################################################################################
#    [Documentation]                 *Ceph Create For CephFS*
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#
#        ${response}                 PCC.Ceph Create Pool Multiple
#                               ...  count=3
#                               ...  name=pool
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=1
#                               ...  quota_unit=GiB
#
#                                    Should Be Equal As Strings      ${response}  OK
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=${CEPH_FS_META}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=${CEPH_FS_DATA}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=${CEPH_FS_DEFAULT}
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Ceph Fs Creation
####################################################################################################################################
#    [Documentation]                 *Creating Cepf FS*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Get Pool Details For FS
#                               ...  PCC.Ceph Create Fs
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#
#        ${meta}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=${CEPH_FS_META}
#
#        ${data}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=${CEPH_FS_DATA}
#
#        ${default}                  PCC.Ceph Get Pool Details For FS
#                               ...  name=${CEPH_FS_DEFAULT}
#
#        ${response}                 PCC.Ceph Create Fs
#                               ...  name=${CEPH_FS_NAME}
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  metadata_pool=${meta}
#                               ...  data_pool=[${data}]
#                               ...  default_pool=${default}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Fs Ready
#                               ...  name=${CEPH_FS_NAME}
#
#                                    Should Be Equal As Strings      ${status}    OK
#
#
#
###################################################################################################################################
#Ceph Ceph Certificate For Rgws Secondary
####################################################################################################################################
#
#
#        [Documentation]              *Ceph Ceph Certificate For Rgws Secondary*
#        #[Tags]    This
#        ${cert_id}                   PCC.Get Certificate Id
#                                ...  Alias=${CEPH_RGW_CERT_NAME_SECONDARY}
#                                     Pass Execution If    ${cert_id} is not ${None}    Certificate is already there
#
#        ${response}                  PCC.Add Certificate
#                                ...  Alias=${CEPH_RGW_CERT_NAME_SECONDARY}
#                                ...  Description=certificate-for-rgw
#                                ...  Private_key=domain.key
#                                ...  Certificate_upload=domain.crt
#
#                                     Log To Console    ${response}
#        ${result}                    Get Result    ${response}
#        ${status}                    Get From Dictionary    ${result}    statusCodeValue
#                                     Should Be Equal As Strings    ${status}    200
#
#
####################################################################################################################################
#Ceph Rados Gateway Secondary Creation
######################################################################################################################################
#
#
#     [Documentation]                 *Ceph Rados Gateway Secondary Creation*
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${cluster_id}                PCC.Ceph Get Cluster Id
#                               ...   name=${CEPH_CLUSTER_NAME_SECONDARY}
#
#        ${response}                  PCC.Ceph Create Pool
#                               ...  name=${CEPH_RGW_POOLNAME_SECONDARY}
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE_SECONDARY}
#                               ...  tags=${CEPH_POOL_TAGS_SECONDARY}
#                               ...  pool_type=${CEPH_POOL_TYPE_SECONDARY}
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME_SECONDARY}
#                               ...  quota=1
#                               ...  quota_unit=GiB
#
#        ${status_code}               Get Response Status Code        ${response}
#        ${message}                   Get Response Message        ${response}
#                                     Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                    PCC.Ceph Wait Until Pool Ready
#                                ...  name=${CEPH_RGW_POOLNAME_SECONDARY}
#                                     Should Be Equal As Strings      ${status}    OK
#
#
#        ${num_daemons_map}          Create Dictionary       ${SERVER_4_NAME_SECONDARY}=${1}
#
#        ${response}                 PCC.Ceph Create Rgw
#                               ...  name=${CEPH_RGW_NAME_SECONDARY}
#                               ...  poolName=${CEPH_RGW_POOLNAME_SECONDARY}
#                               ...  num_daemons_map=${num_daemons_map}
#                               ...  port=${CEPH_RGW_PORT_SECONDARY}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME_SECONDARY}
#                               ...  certificateUrl=${CEPH_RGW_CERT_URL_SECONDARY}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rgw Ready
#                               ...  name=${CEPH_RGW_NAME_SECONDARY}
#			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Dismiss Node With RGW Daemon (Negative)
###################################################################################################################################
    [Documentation]                 *Dismiss Node With RGW Daemon (Negative)*

    ${server_id}                  PCC.Get Node Id    Name=${SERVER_4_NAME_SECONDARY}


    ${response}                    PCC.Node Dismiss
                              ...  Id=${server_id}

                                   ${result}    Get Result    ${response}
                                   ${message}   Get Response Message        ${response}
                                   ${status}    Get From Dictionary    ${result}    status
                                   Should Not Be Equal As Strings    ${status}    200

####################################################################################################################################
#Node Dismiss
####################################################################################################################################
#    [Documentation]                 *Node Dismiss*
#
#    ${server_id}                  PCC.Get Node Id    Name=${SERVER_4_NAME_SECONDARY}
#
#
#    ${response}                    PCC.Node Dismiss
#                              ...  Id=${server_id}
#                              ...  force=${true}
#
#                                   ${result}    Get Result    ${response}
#                                   ${message}   Get Response Message        ${response}
#                                   ${status}    Get From Dictionary    ${result}    status
#                                   ${data}    Get From Dictionary    ${result}    Data
#                                   ${services}    Get From Dictionary    ${data}    details
#                                   Should Be Equal As Strings    ${status}    200
#
#                                   Log To Console    ${services}

                                   PCC.Verify Node Dismiss
                              ...  hostip=${SERVER_5_HOST_IP_SECONDARY}
#                              ...  services=${services}
#
#        ${status}                   PCC.Ceph Cleanup BE 2
#                               ...  nodes_ip=['${SERVER_4_HOST_IP_SECONDARY}']
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#
#                                    Should be equal as strings    ${status}    OK

####################################################################################################################################
#Ceph Cluster Update - Add Server
#####################################################################################################################################
#    [Documentation]                 *Ceph Cluster Update - Add Server*
#
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#
#        ${id}                       PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#
#        ${response}                 PCC.Ceph Cluster Update
#                               ...  id=${id}
#                               ...  nodes=${CEPH_CLUSTER_NODES_SECONDARY}
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK_SECONDARY}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${message}                  Get Response Message        ${response}
#
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Ceph Verify BE
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK