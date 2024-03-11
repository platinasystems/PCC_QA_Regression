#*** Settings ***
#
#Resource    pcc_resources.robot
#
#*** Variables ***
#${pcc_setup}    pcc_212
#
#*** Keywords ***
#
#*** Test Cases ***
####################################################################################################################################
#Load Test Variable
################################################################################################################
#         [Tags]  p1
#                        Load Ceph Rgw Data    ${pcc_setup}
#                        Load Ceph Cluster Data  ${pcc_setup}
#                        Load Ceph Rgw Data Secondary   ${pcc_setup}
#                        Load Ceph Cluster Data Secondary  ${pcc_setup}
#                        Load Ceph Pool Data    ${pcc_setup}
#                        Load Server 1 Test Data    ${pcc_setup}
#                        Load Server 1 Secondary Test Data    ${pcc_setup}
#                        Load Server 2 Test Data    ${pcc_setup}
#                        Load Server 2 Secondary Test Data    ${pcc_setup}
#                        Load Ceph Rgw Data Secondary    ${pcc_setup}
#					    Load Ceph Pool Data Secondary   ${pcc_setup}
#                        Load Ceph Cluster Data Secondary   ${pcc_setup}
#
####################################################################################################################################
#Ceph Delete Unused Pools
####################################################################################################################################
#        ${status}                   Login To PCC    ${pcc_setup}
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME}
#
#        ${status}                   PCC.Ceph Delete Unused Pools
#                               ...  ceph_cluster_id=${cluster_id}
#                                    Should be equal as strings    ${status}    OK
#
#                                    sleep  1m
#
#        ${status}                   Login To PCC Secondary   ${pcc_setup}
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
####################################################################################################################################
#Login to PCC Primary -Ceph Rados Gateway Delete Primary
####################################################################################################################################
#
#    [Documentation]                 *Ceph Rados Gateway Delete*
#        ${status}                   Login To PCC    ${pcc_setup}
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...    name=${CEPH_RGW_NAME_EC}
#		                       ...  ceph_cluster_name=ceph-pvt
#		                            Pass Execution If    ${rgw_id} is ${None}    There is no RGW for deletion
##
#        ${response}                 PCC.Ceph Delete Rgw
#                               ...  name=${CEPH_RGW_NAME_EC}
#			                   ...  ceph_cluster_name=ceph-pvt
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rgw Deleted
#                               ...  name=${CEPH_RGW_NAME_EC}
#			                   ...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
#                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
#                                    Should Be Equal As Strings      ${backend_status}    OK
#				                    Sleep    1 minutes
#####################################################################################################################################
#Login To PCC Secondary -Delete Seondary Ceph Rados Gateway
####################################################################################################################################
#
#    [Documentation]                 *Ceph Rados Gateway Delete*
#        ${status}                   Login To PCC Secondary   ${pcc_setup}
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...    name=${CEPH_RGW_NAME_EC_SECONDARY}
#		                       ...  ceph_cluster_name=ceph-pvt
#		                            Pass Execution If    ${rgw_id} is ${None}    There is no RGW for deletion
##
#        ${response}                 PCC.Ceph Delete Rgw
#                               ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
#			                   ...  ceph_cluster_name=ceph-pvt
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rgw Deleted
#                               ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
#			                   ...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
#                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
#                                    Should Be Equal As Strings      ${backend_status}    OK
#				                    Sleep    1 minutes
####################################################################################################################################
#Login to PCC Primary and Create Erasure coded pool
#################################################Login to PCC Primar###################################################################################
#        [Tags]  p1
#        [Documentation]    *Get Erasure Code Profile Id* test
#                           ...  keywords:
#                           ...  PCC.Get Erasure Code Profile Id
#                           ...  PCC.Ceph Get Cluster Id
#                           ...  PCC.Ceph Create Erasure Pool
#
#        ${status}              Login To PCC    ${pcc_setup}
#
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME}
#
#        ######### Quota Size in MiB (2:1 ratio) #########
#                               Log To Console  pool name is ${CEPH_RGW_POOLNAME_EC}
#
#
#        ${response}            PCC.Ceph Create Erasure Pool
#                               ...  name=${CEPH_RGW_POOLNAME_EC}
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=data
#                               ...  resilienceScheme=erasure
#                               ...  quota=3
#                               ...  quota_unit=GiB
#                               ...  Datachunks=2
#                               ...  Codingchunks=1
#                               ...  pg_num=1
#
#
#
#        ${status_code}          Get Response Status Code        ${response}
#                                Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=${CEPH_RGW_POOLNAME_EC}
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
#       ${status}               PCC.Ceph Erasure Pool Verify BE
#                               ...  name=${CEPH_RGW_POOLNAME_EC}
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
#
#                               Should Be Equal As Strings      ${status}    OK
#                               Sleep    5s
#
#
#
####################################################################################################################################
#EC-Ceph Rados Gateway Creation With Erasure Coded Pool Without S3 Accounts
######################################################################################################################################
#       [Tags]    Today
#
#     [Documentation]                 *Ceph Rados Gateway Creation*
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Ceph Create Rgw
#                               ...  name=${CEPH_RGW_NAME_EC}
#                               ...  poolName=${CEPH_RGW_POOLNAME_EC}
#					           ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP}
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                               ...  certificateUrl=${CEPH_RGW_CERT_URL}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#	${status}                   PCC.Ceph Wait Until Rgw Ready
#                               ...  name=${CEPH_RGW_NAME_EC}
#                               ...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#
###################################################################################################################################
#EC-Create Application credential profile with application
####################################################################################################################################
#
#        [Documentation]    *Create Metadata Profile* test
#                           ...  keywords:
#                           ...  PCC.Add Metadata Profile
#
#
#        ${status}      PCC.Ceph Get Pcc Status
#                       ...  name=ceph-pvt
#                       Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}      PCC.Ceph Get Rgw Id
#                       ...    name=${CEPH_RGW_NAME_EC}
#		               ...  ceph_cluster_name=ceph-pvt
#
#        ${response}    PCC.Add Metadata Profile
#                       ...    Name=appcred_ec
#                       ...    Type=ceph
#                       ...    ApplicationId=${rgw_id}
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Be Equal As Strings    ${status}    200
####################################################################################################################################
#Login To PCC Secondary and Create Erasure Coded Pool
###############################################Login To PCC Secondary-2#############################################################
#
#    [Documentation]                        *Ceph Ceph Secondary Pool For Rgws*
#                                      ...  keywords:
#                                      ...  PCC.Ceph Get Cluster Id
#                                      ...  PCC.Ceph Create Pool
#                                      ...  PCC.Ceph Wait Until Pool Ready
#	    [Tags]    EC2
#
#	     ${status}                          Login To PCC Secondary       testdata_key=${pcc_setup}
#                                            Should Be Equal     ${status}  OK
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${cluster_id}                      PCC.Ceph Get Cluster Id
#                                      ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#
#        ${response}                     PCC.Ceph Create Erasure Pool
#                                       ...  name=${CEPH_RGW_POOLNAME_EC_SECONDARY}
#                                       ...  ceph_cluster_id=${cluster_id}
#                                       ...  size=${CEPH_POOL_SIZE_SECONDARY}
#                                       ...  tags=${CEPH_POOL_TAGS_SECONDARY}
#                                       ...  pool_type=${CEPH_POOL_TYPE_SECONDARY}
#                                       ...  resilienceScheme=erasure
#                                       ...  quota=3
#                                       ...  quota_unit=GiB
#                                       ...  Datachunks=2
#                                       ...  Codingchunks=1
#                                       ...  pg_num=1
#
#        ${status_code}                     Get Response Status Code        ${response}
#        ${message}                         Get Response Message        ${response}
#                                           Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                          PCC.Ceph Wait Until Pool Ready
#                                      ...  name=${CEPH_RGW_POOLNAME_EC_SECONDARY}
#                                           Should Be Equal As Strings      ${status}    OK
#                                     Sleep    5s
#
###################################################################################################################################
#EC-Ceph Ceph Certificate For Rgws
####################################################################################################################################
#
#        [Documentation]              *Ceph Ceph Certificate For Rgws*
#        [Tags]    Today
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
####################################################################################################################################
#Ceph Rados Gateway Secondary Creation
######################################################################################################################################
#
#     [Documentation]                 *Ceph Rados Gateway Secondary Creation*
#	[Tags]    EC2
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Ceph Create Rgw
#                               ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
#                               ...  poolName=${CEPH_RGW_POOLNAME_EC_SECONDARY}
#					           ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP_SECONDARY}
#                               ...  port=${CEPH_RGW_PORT_SECONDARY}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME_SECONDARY}
#                               ...  certificateUrl=${CEPH_RGW_CERT_URL_SECONDARY}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rgw Ready
#                               ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
#			                   ...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
# #####################################################################################################################################
#Ceph Local Load Balancer create on Rgw (primary)
######################################################################################################################################
#     [Documentation]                *Ceph Local Load Balancer create on Rgw (primary)*
#
#        ${status}              Login To PCC    ${pcc_setup}
#
#
#        ${app_id}              PCC.Get App Id from Policies
#                               ...  Name=loadbalancer-ceph
#                               Log To Console    ${app_id}
#
#        ${rgw_id}              PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME_EC}
#                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
#                               Set Suite Variable   ${rgw_id}
#
#        ${scope1_id}           PCC.Get Scope Id
#                               ...  scope_name=Default region
#
#        ${response}            PCC.Create Policy
#                               ...  appId=${app_id}
#                               ...  description=test-ceph-lb
#                               ...  scopeIds=[${scope1_id}]
#                               ...  inputs=[{"name": "lb_name","value": "testcephlb"},{"name": "lb_balance_method","value": "roundrobin"},{"name": "lb_mode","value": "local"},{"name": "lb_frontend","value": "0.0.0.0:9898"},{"name": "lb_backends","value": "${rgw_id}"}]
#
#                               ${result}    Get Result    ${response}
#                               ${status}    Get From Dictionary    ${result}    status
#                               ${message}    Get From Dictionary    ${result}    message
#                               ${data}      Get From Dictionary    ${result}    Data
#                               ${policy_tag_1_id}      Get From Dictionary    ${data}     id
#                               Should Be Equal As Strings    ${status}    200
#
#        ${response}            PCC.Add and Verify Roles On Nodes
#                               ...  nodes=["${SERVER_1_NAME}"]
#                               ...  roles=["Ceph Load Balancer"]
#
#                               Should Be Equal As Strings      ${response}  OK
#
#        ${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${SERVER_1_NAME}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK
#
#        ${status}               PCC.Verify HAProxy BE
# 			                    ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
#                                ...  name=${SERVER_1_NAME}
#                                ...  policy_id=${policy_tag_1_id}
#
#                                Should Be Equal As Strings    ${status}    OK
#
#
######################################################################################################################################
#Ceph Local Load Balancer create on Rgw (secondary)
######################################################################################################################################
#     [Documentation]                *Ceph Local Load Balancer create on Rgw (secondary)*
#
#        ${status}              Login To PCC Secondary   ${pcc_setup}
#
#
#        ${app_id}              PCC.Get App Id from Policies
#                               ...  Name=loadbalancer-ceph
#                               Log To Console    ${app_id}
#
#        ${rgw_id_secondary}    PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
#                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
#                               Set Suite Variable   ${rgw_id_secondary}
#
#        ${scope1_id}           PCC.Get Scope Id
#                               ...  scope_name=Default region
#
#        ${response}            PCC.Create Policy
#                               ...  appId=${app_id}
#                               ...  description=test-ceph-lb
#                               ...  scopeIds=[${scope1_id}]
#                               ...  inputs=[{"name": "lb_name","value": "testcephlb"},{"name": "lb_balance_method","value": "roundrobin"},{"name": "lb_mode","value": "local"},{"name": "lb_frontend","value": "0.0.0.0:9898"},{"name": "lb_backends","value": "${rgw_id_secondary}"}]
#
#                               ${result}    Get Result    ${response}
#                               ${status}    Get From Dictionary    ${result}    status
#                               ${message}    Get From Dictionary    ${result}    message
#                               ${data}      Get From Dictionary    ${result}    Data
#                               ${policy_tag_1_id}      Get From Dictionary    ${data}     id
#                               Should Be Equal As Strings    ${status}    200
#
#        ${response}            PCC.Add and Verify Roles On Nodes
#                               ...  nodes=["${SERVER_1_NAME_SECONDARY}"]
#                               ...  roles=["Ceph Load Balancer"]
#
#                               Should Be Equal As Strings      ${response}  OK
#
#        ${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${SERVER_1_NAME_SECONDARY}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK
#
#        ${status}               PCC.Verify HAProxy BE
# 			                    ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                ...  name=${SERVER_1_NAME_SECONDARY}
#                                ...  policy_id=${policy_tag_1_id}
#
#                                Should Be Equal As Strings    ${status}    OK
#
####################################################################################################################################
#EC-Login to PCC Primary and Create Trust
########################################EC-Login to PCC Primary1############################################################################################
#      [Tags]  EC1
#        [Documentation]                *Primary Started Trust Creation*
#        ${status}                   Login To PCC    ${pcc_setup}
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME_EC}
#			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
#
#		${response}	                PCC.Ceph Primary Start Trust
#			                   ...  masterAppID=${rgw_id}
#
#        ${result}                   Get Result    ${response}
#        ${data}                     Get From Dictionary     ${result}   Data
#        ${primary_trust_id}         Get From Dictionary     ${data}     id
#                                    Set Suite Variable   ${primary_trust_id}
#                                    Log To Console      ${primary_trust_id}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
####################################################################################################################################
#EC-Primary Download Trust File
####################################################################################################################################
#        [Tags]  EC1
#        [Documentation]                *Primary Download Trust File*
#
#        ${status_code}              PCC.Ceph Download Trust File
#                               ...  id=${primary_trust_id}
#
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
####################################################################################################################################
#EC-Login To PCC Secondary and Create Trust
#############################################EC-Login To PCC Secondary1#######################################################################################
#        [Tags]  EC1
#        [Documentation]                *Secondary End Trust Creation*
#        ${status}                   Login To PCC Secondary  ${pcc_setup}
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#
#		${response}	                PCC.Ceph Secondary End Trust
#			                   ...  clusterID=${cluster_id}
#			                   ...  id=${primary_trust_id}
#
#        ${result}                   Get Result    ${response}
#        ${data}                     Get From Dictionary     ${result}   Data
#        ${secondary_trust_id}       Get From Dictionary     ${data}     id
#                                    Set Suite Variable   ${secondary_trust_id}
#                                    Log To Console      ${secondary_trust_id}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
####################################################################################################################################
#EC-Secondary Edit Trust
####################################################################################################################################
#        [Tags]  EC1
#        [Documentation]                *Secondary Edit Trust*
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
#			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Log To Console      ${rgw_id}
#		${response}	                PCC.Ceph Edit Trust
#			                   ...  id=${secondary_trust_id}
#			                   ...  slaveAppID=${rgw_id}
#
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${result}                   PCC.Ceph Wait Until Trust Established
#                               ...  id=${secondary_trust_id}
#                                    Should Be Equal As Strings      ${result}  OK
#
####################################################################################################################################
#EC-Login to PCC Primary to check trust establishment
####################################################################################################################################
#    [Tags]  EC1
#        ${status}        Login To PCC    ${pcc_setup}
#
####################################################################################################################################
#EC-Wait Until Trust Established - Primary
####################################################################################################################################
#    [Tags]  EC1
#        ${result}                   PCC.Ceph Wait Until Trust Established
#                               ...  id=${primary_trust_id}
#                                    Should Be Equal As Strings      ${result}  OK
#
####################################################################################################################################
#EC-Create Primary Rgw Configuration File
####################################################################################################################################
#    [Documentation]                        *EC-Create Primary Rgw Configuration File*
#
#        ${status}                          Login To PCC    ${pcc_setup}
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=${CEPH_CLUSTER_NAME}
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${accessKey}                       PCC.Ceph Get Rgw Access Key
#                                      ...  name=${CEPH_RGW_NAME_EC}
#				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
#				                           Set Suite Variable  ${accessKey}
#
#        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
#                                      ...  name=${CEPH_RGW_NAME_EC}
#				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
#				                           Set Suite Variable  ${secretKey}
#
#        ${server1_id}                      PCC.Get Node Id    Name=${SERVER_1_NAME}
#                                           Log To Console    ${server1_id}
#
#        ${server1_id_str}                  Convert To String    ${server1_id}
#
#        ${interfaces}                      PCC.Ceph Get RGW Interfaces Map
#                                      ...  name=${CEPH_RGW_NAME_EC}
#				                      ...  ceph_cluster_name=ceph-pvt
#
#		${rgw_server1_interfaces}		   Get From Dictionary  ${interfaces}  ${server1_id_str}
#                                           Log To Console    ${rgw_server1_interfaces}
#		${rgw_server1_interface0}		   Get From List  ${rgw_server1_interfaces}  0
#                                           Log To Console    ${rgw_server1_interface0}
#        ${status}                          PCC.Ceph Rgw Configure
#                                      ...  accessKey=${accessKey}
#                                      ...  secretKey=${secretKey}
#                                      ...  pcc=${SERVER_1_HOST_IP}
#                                      ...  targetNodeIp=${rgw_server1_interface0}
#                                      ...  port=${CEPH_RGW_PORT}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
#
####################################################################################################################################
#EC-Create Rgw Bucket - Primary
####################################################################################################################################
#    [Tags]  EC1
#    [Documentation]                        *Create Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=${CEPH_CLUSTER_NAME}
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Make Bucket
#                                      ...  pcc=${SERVER_1_HOST_IP}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#EC-List Rgw Bucket - Primary
####################################################################################################################################
#    [Tags]  EC1
#    [Documentation]                        *List Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=${CEPH_CLUSTER_NAME}
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw List Buckets
#                                     ...  pcc=${SERVER_1_HOST_IP}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
#
####################################################################################################################################
#EC-ADD File - Primary
####################################################################################################################################
#    [Tags]  EC1
#    [Documentation]                        *ADD File - Primary*
#
#        ${status}                          PCC.Ceph Rgw Upload File To Bucket
#                                      ...  pcc=${SERVER_1_HOST_IP}
#                                           Should Be Equal As Strings      ${status}    OK
#
#                                           Sleep  1m
#
####################################################################################################################################
#EC-Login to PCC Secondary -Wait Until Secondary Replica Status: Caught up
####################################################################################################################################
#             ${status}              Login To PCC Secondary    ${pcc_setup}
#
#             ${result}              PCC.Ceph Wait Until Replica Status Caught Up
#                               ...  id=${secondary_trust_id}
#                                    Should Be Equal As Strings      ${result}  OK
#
####################################################################################################################################
#EC-Create Secondary Rgw Configuration File
####################################################################################################################################
#    [Tags]  EC1
#        ${status}                          Login To PCC Secondary   ${pcc_setup}
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${server1_id}                      PCC.Get Node Id    Name=${SERVER_1_NAME_SECONDARY}
#                                           Log To Console    ${server1_id}
#
#        ${server1_id_str}                  Convert To String    ${server1_id}
#
#        ${interfaces}                      PCC.Ceph Get RGW Interfaces Map
#                                      ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
#				                      ...  ceph_cluster_name=ceph-pvt
#
#		${rgw_server1_interfaces}		   Get From Dictionary  ${interfaces}  ${server1_id_str}
#                                           Log To Console    ${rgw_server1_interfaces}
#		${rgw_server1_interface0}		   Get From List  ${rgw_server1_interfaces}  0
#                                           Log To Console    ${rgw_server1_interface0}
#
#        ${status}                          PCC.Ceph Rgw Configure
#                                      ...  accessKey=${accessKey}
#                                      ...  secretKey=${secretKey}
#                                      ...  pcc=${SERVER_1_HOST_IP_SECONDARY}
#                                      ...  targetNodeIp=${rgw_server1_interface0}
#                                      ...  port=${CEPH_RGW_PORT_SECONDARY}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#EC-List Rgw Bucket - Secondary
####################################################################################################################################
#    [Tags]  EC1
#    [Documentation]                        *List Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=${CEPH_CLUSTER_NAME}
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw List Buckets
#                                      ...  pcc=${SERVER_1_HOST_IP_SECONDARY}
#
#                                           Should Be Equal As Strings      ${status}    OK
####################################################################################################################################
#EC-List Rgw Objects inside Bucket - Secondary
####################################################################################################################################
#    [Tags]  EC1
#    [Documentation]                        *List Rgw Bucket*
#                                           Log To Console  ${SERVER_1_HOST_IP}
#                                           Log To Console  ${CEPH_CLUSTER_NAME}
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=${CEPH_CLUSTER_NAME}
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw List Objects inside Buckets
#                                      ...  pcc=${SERVER_1_HOST_IP_SECONDARY}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#EC-Delete A File From Rgw Bucket - Primary
#####################################################################################################################################
#    [Tags]  EC1
#    [Documentation]                        *Delete a file from Rgw Bucket*
#
#        ${status}                          Login To PCC   ${pcc_setup}
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Delete File From Bucket
#                                      ...  pcc=${SERVER_1_HOST_IP}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#EC-Delete Rgw Bucket - Primary
####################################################################################################################################
#      [Tags]  EC1
#      [Documentation]                      *Delete Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Delete Bucket
#                                      ...  pcc=${SERVER_1_HOST_IP}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#EC-Primary tear-down
####################################################################################################################################
#        [Tags]  EC1
#        ${response}                 PCC.Ceph Trust Delete
#                               ...  id=${primary_trust_id}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${result}                   PCC.Ceph Wait Until Trust Deleted
#                               ...  id=${primary_trust_id}
#                                    Should Be Equal As Strings      ${result}  OK
#
#
####################################################################################################################################
#EC-Login To PCC Secondary -Delete Trust
####################################################################################################################################
#        ${status}                   Login To PCC Secondary   ${pcc_setup}
#        ${response}                 PCC.Ceph Trust Delete
#                               ...  id=${secondary_trust_id}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#
####################################################################################################################################
#EC-Login to PCC Primary-Create Trust and DownLoad Trust file
####################################################################################################################################
#
#      [Tags]  EC3
#        [Documentation]                *Primary Started Trust Creation*
#        ${status}        Login To PCC    ${pcc_setup}
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME_EC}
#			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
#
#		${response}	                PCC.Ceph Primary Start Trust
#			                   ...  masterAppID=${rgw_id}
#
#        ${result}                   Get Result    ${response}
#        ${data}                     Get From Dictionary     ${result}   Data
#        ${primary_trust_id}         Get From Dictionary     ${data}     id
#                                    Set Suite Variable   ${primary_trust_id}
#                                    Log To Console      ${primary_trust_id}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
###################################Primary Download Trust File#######################################################################
#
#        ${status_code}              PCC.Ceph Download Trust File
#                               ...  id=${primary_trust_id}
#
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
####################################################################################################################################
#EC- Login To PCC Secondary - Get secondary RGW id
####################################################################################################################################
#        [Tags]  EC3
#        ${status}                   Login To PCC Secondary  ${pcc_setup}
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
#			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
#
#			                   Log To Console      ${rgw_id}
#
#			                   Set Suite Variable     ${secondary_rgw_ec_id}   ${rgw_id}
#
####################################################################################################################################
#EC-Secondary End Trust Creation -
####################################################################################################################################
#        [Tags]  EC3
#        [Documentation]                *Secondary End Trust Creation*
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#                                    Log To Console      ${status}
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Log To Console      ${cluster_id}
#
#		${response}	                PCC.Ceph Secondary End Trust
#			                   ...  clusterID=${cluster_id}
#			                   ...  id=${primary_trust_id}
#
#        ${result}                   Get Result    ${response}
#        ${data}                     Get From Dictionary     ${result}   Data
#        ${secondary_trust_id}       Get From Dictionary     ${data}     id
#                                    Set Suite Variable   ${secondary_trust_id}
#                                    Log To Console      ${secondary_trust_id}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#
#        Sleep  1m
#####################################################################################################################################
#EC-Login to PCC Primary -toEditTrustFromPrimary
#####################################################################################################################################
#    [Tags]  EC3
#        ${status}                   Login To PCC    ${pcc_setup}
#
####################################################################################################################################
#EC-Primary Edit Trust - toEditTrustFromPrimary
####################################################################################################################################
#        [Tags]  EC3
#        [Documentation]                *Secondary Edit Trust*
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#
#                                    Log To Console      ${secondary_rgw_ec_id}
#		${response}	                PCC.Ceph Edit Trust
#			                   ...  id=${primary_trust_id}
#			                   ...  slaveAppID=${secondary_rgw_ec_id}
#
#                                    Log To Console      ${response}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Log To Console      ${status_code}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Log To Console      ${message}
#        ${result}                   PCC.Ceph Wait Until Trust Established
#                               ...  id=${primary_trust_id}
#                                    Should Be Equal As Strings      ${result}  OK
#
####################################################################################################################################
#EC-Login to PCC Secondary4 - Wait Until Secondary Replica Status: Caught up
####################################################################################################################################
#    [Tags]  EC3
#
#        #${result}                   #PCC.Ceph Wait Until Replica Status Caught Up
#
#         ${status}                  Login To PCC Secondary    ${pcc_setup}
#         ${result}                  PCC.Ceph Wait Until Trust Established
#                               ...  id=${secondary_trust_id}
#                                    Should Be Equal As Strings      ${result}  OK
#####################################################################################################################################
#EC-Login to PCC Primary- Teardown
#####################################################################################################################################
#        [Tags]  EC3
#        ${status}                  Login To PCC    ${pcc_setup}
#
#        ${response}                 PCC.Ceph Trust Delete
#                               ...  id=${primary_trust_id}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${result}                   PCC.Ceph Wait Until Trust Deleted
#                               ...  id=${primary_trust_id}
#                                    Should Be Equal As Strings      ${result}  OK
#
#
####################################################################################################################################
#EC-Login To PCC Secondary -Teardown
####################################################################################################################################
#        [Tags]  EC3
#        ${status}                   Login To PCC Secondary   ${pcc_setup}
#
####################################################################################################################################
#EC-Secondary Delete Trust -Teardown
####################################################################################################################################
#        [Tags]  EC3
#        ${response}                 PCC.Ceph Trust Delete
#                               ...  id=${secondary_trust_id}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#
#
####################################################################################################################################
#Removing Ceph Load balancer Primary
####################################################################################################################################
#    [Documentation]                 *Removing Ceph Load balancer*
#
#
#        ${status}                   Login To PCC   ${pcc_setup}
#
#        ${response}                 PCC.Delete and Verify Roles On Nodes
#                               ...  nodes=["${SERVER_1_NAME}"]
#                               ...  roles=["Ceph Load Balancer"]
#
#                                    Should Be Equal As Strings      ${response}  OK
#
#
#        ${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${SERVER_1_NAME}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK
#
####################################################################################################################################
#Removing Ceph Load balancer Secondary
####################################################################################################################################
#    [Documentation]                 *Removing Ceph Load balancer*
#
#
#        ${status}                   Login To PCC Secondary   ${pcc_setup}
#
#        ${response}                 PCC.Delete and Verify Roles On Nodes
#                               ...  nodes=["${SERVER_1_NAME_SECONDARY}"]
#                               ...  roles=["Ceph Load Balancer"]
#
#                                    Should Be Equal As Strings      ${response}  OK
#
#
#        ${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${SERVER_1_NAME_SECONDARY}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK
#
#####################################################################################################################################
#EC-Ceph Rados Gateway Delete Secondary
#####################################################################################################################################
#
#    [Documentation]                 *Ceph Rados Gateway Delete*
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...    name=${CEPH_RGW_NAME_EC_SECONDARY}
#		                       ...  ceph_cluster_name=ceph-pvt
#		                            Pass Execution If    ${rgw_id} is ${None}    There is no RGW for deletion
##
#        ${response}                 PCC.Ceph Delete Rgw
#                               ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
#			                   ...  ceph_cluster_name=ceph-pvt
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rgw Deleted
#                               ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
#			                   ...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
#                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP_SECONDARY}
#                                    Should Be Equal As Strings      ${backend_status}    OK
#
