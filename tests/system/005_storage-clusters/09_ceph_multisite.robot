#*** Settings ***
#
#Resource    pcc_resources.robot
#
#*** Variables ***
#${pcc_setup}    pcc_212
#
#
#*** Test Cases ***
####################################################################################################################################
#Load Test Variable
####################################################################################################################################
#                        Load Ceph Pool Data    ${pcc_setup}
#                        Load Ceph Rgw Data    ${pcc_setup}
#                        Load Ceph Cluster Data  ${pcc_setup}
#                        Load Ceph Pool Data Secondary   ${pcc_setup}
#                        Load Ceph Rgw Data Secondary   ${pcc_setup}
#                        Load Ceph Cluster Data Secondary  ${pcc_setup}
#                        Load Server 1 Test Data    ${pcc_setup}
#                        Load Server 1 Secondary Test Data    ${pcc_setup}
#                        Load Server 2 Secondary Test Data    ${pcc_setup}
#
#
####################################################################################################################################
#Ceph Delete Unused Pools
####################################################################################################################################
#
#        ${status}                   Login To PCC   ${pcc_setup}
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
###################################################################################################################################
#Ceph Ceph Certificate For Rgws Secondary
####################################################################################################################################
#
#        ${status}                         Login To PCC Secondary   ${pcc_setup}
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
####################################################################################################################################
#Ceph Rados Gateway Secondary Creation
######################################################################################################################################
#
#        ${status}                         Login To PCC Secondary   ${pcc_setup}
#
#     [Documentation]                 *Ceph Rados Gateway Secondary Creation*
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME_SECONDARY}
#		                       ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
#		                            Pass Execution If    ${rgw_id} is not ${None}    There is already a radosgw
#
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
#        ${response}                 PCC.Ceph Create Rgw
#                               ...  name=${CEPH_RGW_NAME_SECONDARY}
#                               ...  poolName=${CEPH_RGW_POOLNAME_SECONDARY}
#                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP_SECONDARY}
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
#			                   ...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
#                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP_SECONDARY}
#                                    Should Be Equal As Strings      ${backend_status}    OK
#
####################################################################################################################################
#Primary - Ceph Rados Gateway Creation
######################################################################################################################################
#
#     [Documentation]                 *Primary - Ceph Rados Gateway Creation*
#
#        ${status}                   Login To PCC    ${pcc_setup}
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME}
#		                       ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
#		                            Pass Execution If    ${rgw_id} is not ${None}    There is already a radosgw
#
#        ${response}                  PCC.Add Metadata Profile
#                              ...    Name=${CEPH_RGW_S3ACCOUNTS}
#                              ...    Type=ceph
#
#                                      Log To Console    ${response}
#                                      ${result}    Get Result    ${response}
#                                      ${status}    Get From Dictionary    ${result}    status
#                                      ${message}    Get From Dictionary    ${result}    message
#                                      Log to Console    ${message}
#                                      Should Be Equal As Strings    ${status}    200
#
#		${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME}
#
#		${response}                 PCC.Ceph Create Pool
#                               ...  name=${CEPH_RGW_POOLNAME}
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=1
#                               ...  quota_unit=GiB
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                    PCC.Ceph Wait Until Pool Ready
#                                ...  name=${CEPH_RGW_POOLNAME}
#                                     Should Be Equal As Strings      ${status}    OK
#
#
#        ${response}                 PCC.Ceph Create Rgw
#                               ...  name=${CEPH_RGW_NAME}
#                               ...  poolName=${CEPH_RGW_POOLNAME}
#                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP}
#                               ...  port=${CEPH_RGW_PORT}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME}
#                               ...  certificateUrl=${CEPH_RGW_CERT_URL}
#                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rgw Ready
#                               ...  name=${CEPH_RGW_NAME}
#			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#
######################################################################################################################################
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
#                               ...  name=${CEPH_RGW_NAME}
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
#                               ...  name=${CEPH_RGW_NAME_SECONDARY}
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
#Primary Started Trust Creation
####################################################################################################################################
#        [Documentation]                *Primary Started Trust Creation*
#
#        ${status}                   Login To PCC    ${pcc_setup}
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME}
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
#        ${status_code}              PCC.Ceph Download Trust File
#                               ...  id=${primary_trust_id}
#                                    Should Be Equal As Strings      ${status_code}  200
#
####################################################################################################################################
#Create Trust With Rgw Already Used As Primary (Negative)
####################################################################################################################################
#        [Documentation]                *Create Trust With Rgw Already Used As Primary (Negative)*
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME}
#			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
#
#		${response}	                PCC.Ceph Primary Start Trust
#			                   ...  masterAppID=${rgw_id}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
####################################################################################################################################
#Create Remote Replica Using The Same PCC (Negative)
####################################################################################################################################
#        [Documentation]                *Create Remote Replica Using The Same PCC (Negative)*
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME}
#
#		${response}	                PCC.Ceph Secondary End Trust
#			                   ...  clusterID=${cluster_id}
#			                   ...  id=${primary_trust_id}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
####################################################################################################################################
#Create Trust Using Bad App Side Trust File (Negative)
####################################################################################################################################
#        [Documentation]                *Create Trust Using Bad App Side Trust File (Negative)*
#
#        ${status}                   Login To PCC Secondary  ${pcc_setup}
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME_SECONDARY}
#			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
#
#		${response}	                PCC.Ceph Primary End Trust
#			                   ...  masterAppID=${rgw_id}
#			                   ...  id=${primary_trust_id}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
####################################################################################################################################
#Secondary End Trust Creation
####################################################################################################################################
#        [Documentation]                *Secondary End Trust Creation*
#
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
#Secondary Edit Trust
####################################################################################################################################
#        [Documentation]                *Secondary Edit Trust*
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME_SECONDARY}
#			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
#
#		${response}	                PCC.Ceph Edit Trust
#			                   ...  id=${secondary_trust_id}
#			                   ...  slaveAppID=${rgw_id}
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
#Wait Until Trust Established - Primary
####################################################################################################################################
#
#        ${status}                   Login To PCC    ${pcc_setup}
#
#        ${result}                   PCC.Ceph Wait Until Trust Established
#                               ...  id=${primary_trust_id}
#                                    Should Be Equal As Strings      ${result}  OK
#
#
####################################################################################################################################
#Change location on primary side with replica established (Negative)
####################################################################################################################################
#
#        [Documentation]    *Change location on primary side with replica established (Negative)*
#
#        ${response}    PCC.Create Scope
#                       ...  type=region
#                       ...  scope_name=region-1
#                       ...  description=region-description
#
#        ${node_id}    PCC.Get Node Id
#                      ...  Name=${SERVER_1_NAME}
#                      Log To Console    ${node_id}
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Be Equal As Strings    ${status}    200
#
#        ${status}      PCC.Check Scope Creation From PCC
#                       ...  scope_name=region-1
#
#                       Log To Console    ${status}
#                       Should Be Equal As Strings    ${status}    OK
#
#        ${region_id}    PCC.Get Scope Id
#                        ...  scope_name=region-1
#                        Log To Console    ${region_id}
#
#        ${zone_id}    PCC.Get Scope Id
#                        ...  scope_name=Default zone
#                        ...  parentID=${region_id}
#                        Log To Console    ${zone_id}
#
#        ${site_id}    PCC.Get Scope Id
#                        ...  scope_name=Default site
#                        ...  parentID=${zone_id}
#                        Log To Console    ${site_id}
#
#        ${rack_id}    PCC.Get Scope Id
#                        ...  scope_name=Default rack
#                        ...  parentID=${site_id}
#                        Log To Console    ${rack_id}
#
#        ${response}    PCC.Update Node
#                       ...  Id=${node_id}
#                       ...  Name=${SERVER_1_NAME}
#                       ...  Host=${SERVER_1_HOST_IP}
#                       ...  scopeId=${rack_id}
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Not Be Equal As Strings    ${status}    200
#
#        ${response}    PCC.Delete Scope By id
#                       ...  scopeId=${region_id}
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Be Equal As Strings    ${status}    200
#
####################################################################################################################################
#Change location on secondary side with replica established (Negative)
####################################################################################################################################
#
#        [Documentation]    *Change location on secondary side with replica established (Negative)*
#
#        ${status}      Login To PCC Secondary   ${pcc_setup}
#
#        ${response}    PCC.Create Scope
#                       ...  type=region
#                       ...  scope_name=region-1
#                       ...  description=region-description
#
#        ${node_id}    PCC.Get Node Id
#                      ...  Name=${SERVER_1_NAME_SECONDARY}
#                      Log To Console    ${node_id}
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Be Equal As Strings    ${status}    200
#
#        ${status}      PCC.Check Scope Creation From PCC
#                       ...  scope_name=region-1
#
#                       Log To Console    ${status}
#                       Should Be Equal As Strings    ${status}    OK
#
#        ${region_id}    PCC.Get Scope Id
#                        ...  scope_name=region-1
#                        Log To Console    ${region_id}
#
#        ${zone_id}    PCC.Get Scope Id
#                        ...  scope_name=Default zone
#                        ...  parentID=${region_id}
#                        Log To Console    ${zone_id}
#
#        ${site_id}    PCC.Get Scope Id
#                        ...  scope_name=Default site
#                        ...  parentID=${zone_id}
#                        Log To Console    ${site_id}
#
#        ${rack_id}    PCC.Get Scope Id
#                        ...  scope_name=Default rack
#                        ...  parentID=${site_id}
#                        Log To Console    ${rack_id}
#
#        ${response}    PCC.Update Node
#                       ...  Id=${node_id}
#                       ...  Name=${SERVER_1_NAME_SECONDARY}
#                       ...  Host=${SERVER_1_HOST_IP_SECONDARY}
#                       ...  scopeId=${rack_id}
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Not Be Equal As Strings    ${status}    200
#
#        ${response}    PCC.Delete Scope By id
#                       ...  scopeId=${region_id}
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Be Equal As Strings    ${status}    200
#
#
####################################################################################################################################
#Change port on RGW secondary with replica established (Negative)
####################################################################################################################################
#
#        ${response}                 PCC.Ceph Update Rgw
#                               ...  name=${CEPH_RGW_NAME_SECONDARY}
#                               ...  poolName=${CEPH_RGW_POOLNAME_SECONDARY}
#                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP_SECONDARY}
#                               ...  port=4433
#                               ...  certificateName=${CEPH_RGW_CERT_NAME_SECONDARY}
#                               ...  certificateUrl=${CEPH_RGW_CERT_URL_SECONDARY}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
####################################################################################################################################
#Change certificate on RGW secondary with replica established (Negative)
####################################################################################################################################
#
#        ${response}                 PCC.Ceph Update Rgw
#                               ...  name=${CEPH_RGW_NAME_SECONDARY}
#                               ...  poolName=${CEPH_RGW_POOLNAME_SECONDARY}
#                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP_SECONDARY}
#                               ...  port=${CEPH_RGW_PORT_SECONDARY}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME_LB_SECONDARY}
#                               ...  certificateUrl=${CEPH_RGW_CERT_URL_LB_SECONDARY}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
####################################################################################################################################
#Change target nodes on RGW secondary with replica established (Negative)
####################################################################################################################################
#
#        ${num_daemons_map}          Create Dictionary      ${SERVER_2_NAME_SECONDARY}=${1}
#
#        ${response}                 PCC.Ceph Update Rgw
#                               ...  name=${CEPH_RGW_NAME_SECONDARY}
#                               ...  poolName=${CEPH_RGW_POOLNAME_SECONDARY}
#                               ...  num_daemons_map=${num_daemons_map}
#                               ...  port=${CEPH_RGW_PORT_SECONDARY}
#                               ...  certificateName=${CEPH_RGW_CERT_NAME_SECONDARY}
#                               ...  certificateUrl=${CEPH_RGW_CERT_URL_SECONDARY}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
####################################################################################################################################
#Create Primary Rgw Configuration File
####################################################################################################################################
#    [Documentation]                        *Create Rgw Configuration File*
#
#        ${status}                          Login To PCC    ${pcc_setup}
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=${CEPH_CLUSTER_NAME}
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${accessKey}                       PCC.Ceph Get Rgw Access Key
#                                      ...  name=${CEPH_RGW_NAME}
#				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
#				                           Set Suite Variable  ${accessKey}
#
#        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
#                                      ...  name=${CEPH_RGW_NAME}
#				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
#				                           Set Suite Variable  ${secretKey}
#
#        ${server1_id}                      PCC.Get Node Id    Name=${SERVER_1_NAME}
#                                           Log To Console    ${server1_id}
#
#        ${server1_id_str}                  Convert To String    ${server1_id}
#
#        ${interfaces}                      PCC.Ceph Get RGW Interfaces Map
#                                      ...  name=${CEPH_RGW_NAME}
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
#Create Rgw Bucket - Primary
####################################################################################################################################
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
#List Rgw Bucket - Primary
####################################################################################################################################
#    [Documentation]                        *List Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=${CEPH_CLUSTER_NAME}
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw List Buckets
#                                      ...  pcc=${SERVER_1_HOST_IP}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
#
####################################################################################################################################
#ADD File - Primary
####################################################################################################################################
#    [Documentation]                        *ADD File - Primary*
#
#        ${status}                          PCC.Ceph Rgw Upload File To Bucket
#                                      ...  pcc=${SERVER_1_HOST_IP}
#                                           Should Be Equal As Strings      ${status}    OK
#
#                                           Sleep  1m
#
####################################################################################################################################
#Wait Until Secondary Replica Status: Caught up
####################################################################################################################################
#
#        ${status}                   Login To PCC Secondary    ${pcc_setup}
#
#
#        ${result}                   PCC.Ceph Wait Until Replica Status Caught Up
#                               ...  id=${secondary_trust_id}
#                                    Should Be Equal As Strings      ${result}  OK
#
####################################################################################################################################
#Create Secondary Rgw Configuration File
####################################################################################################################################
#    [Documentation]                        *Create Rgw Configuration File*
#
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
#                                      ...  name=${CEPH_RGW_NAME_SECONDARY}
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
#List Rgw Bucket - Secondary
####################################################################################################################################
#    [Documentation]                        *List Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw List Buckets
#                                      ...  pcc=${SERVER_1_HOST_IP_SECONDARY}
#
#                                           Should Be Equal As Strings      ${status}    OK
####################################################################################################################################
#List Rgw Objects inside Bucket - Secondary
####################################################################################################################################
#    [Documentation]                        *List Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw List Objects inside Buckets
#                                      ...  pcc=${SERVER_1_HOST_IP_SECONDARY}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Delete A File From Rgw Bucket - Primary
#####################################################################################################################################
#    [Documentation]                        *Delete a file from Rgw Bucket*
#
#        ${status}                          Login To PCC   ${pcc_setup}
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=${CEPH_CLUSTER_NAME}
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Delete File From Bucket
#                                      ...  pcc=${SERVER_1_HOST_IP}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Delete Rgw Bucket - Primary
####################################################################################################################################
#      [Documentation]                      *Delete Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=${CEPH_CLUSTER_NAME}
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Delete Bucket
#                                      ...  pcc=${SERVER_1_HOST_IP}
#
#                                           Should Be Equal As Strings      ${status}    OK
######################################################################################################################################
#Ceph Primary Rados Gateway Delete While Using it As Replica (Negative)
######################################################################################################################################
#
#    [Documentation]                 *Ceph Primary Rados Gateway Delete While Using it As Replica (Negative)*
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Ceph Delete Rgw
#                               ...  name=${CEPH_RGW_NAME}
#			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
######################################################################################################################################
#Ceph Secondary Rados Gateway Delete While Using it As Replica (Negative)
######################################################################################################################################
#
#    [Documentation]                 *Ceph Secondary Rados Gateway Delete While Using it As Replica (Negative)*
#
#        ${status}                   Login To PCC Secondary   ${pcc_setup}
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Ceph Delete Rgw
#                               ...  name=${CEPH_RGW_NAME_SECONDARY}
#			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
#
####################################################################################################################################
#Primary tear-down
####################################################################################################################################
#
#        ${status}                   Login To PCC    ${pcc_setup}
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
####################################################################################################################################
#Secondary Delete Trust
####################################################################################################################################
#
#        ${status}                   Login To PCC Secondary   ${pcc_setup}
#
#        ${response}                 PCC.Ceph Trust Delete
#                               ...  id=${secondary_trust_id}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#                                    sleep  3m
####################################################################################################################################
#Secondary Started Trust Creation
####################################################################################################################################
#        [Documentation]                *Secondary Started Trust Creation*
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${secondary_cluster_id}     PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
#
#        ${rgw_id_secondary}         PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME_SECONDARY}
#			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
#			                        Set Suite Variable   ${rgw_id_secondary}
#
#		${response}	                PCC.Ceph Secondary Start Trust
#			                   ...  clusterID=${secondary_cluster_id}
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
#        ${status_code}              PCC.Ceph Download Trust File
#                               ...  id=${secondary_trust_id}
#
#                                    Should Be Equal As Strings      ${status_code}  200
#
####################################################################################################################################
#Primary End Trust Creation
####################################################################################################################################
#        [Documentation]                *Primary End Trust Creation*
#
#        ${status}                   Login To PCC    ${pcc_setup}
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME}
#			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
#
#		${response}	                PCC.Ceph Primary End Trust
#			                   ...  masterAppID=${rgw_id}
#			                   ...  id=${secondary_trust_id}
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
#Primary Edit Trust
####################################################################################################################################
#        [Documentation]                *Primary Edit Trust*
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#		${response}	                PCC.Ceph Edit Trust
#			                   ...  id=${primary_trust_id}
#			                   ...  slaveAppID=${rgw_id_secondary}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${result}                   PCC.Ceph Wait Until Trust Established
#                               ...  id=${primary_trust_id}
#                                    Should Be Equal As Strings      ${result}  OK
#
####################################################################################################################################
#Wait Until Trust Established - Secondary
####################################################################################################################################
#
#        ${status}                   Login To PCC Secondary  ${pcc_setup}
#
#        ${result}                   PCC.Ceph Wait Until Trust Established
#                               ...  id=${secondary_trust_id}
#                                    Should Be Equal As Strings      ${result}  OK
#
####################################################################################################################################
#Primary tear-down
####################################################################################################################################
#
#        ${status}                   Login To PCC    ${pcc_setup}
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
####################################################################################################################################
#Secondary Delete Trust
####################################################################################################################################
#
#        ${status}                   Login To PCC Secondary   ${pcc_setup}
#
#        ${response}                 PCC.Ceph Trust Delete
#                               ...  id=${secondary_trust_id}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
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
####################################################################################################################################
#Removing Ceph Load balancer Policy Primary
####################################################################################################################################
#    [Documentation]                 *Removing Ceph Load balancer Policy Primary*
#
#
#        ${status}                   Login To PCC   ${pcc_setup}
#
#        ${policy_id}                PCC.Get Policy Id
#                               ...  Name=loadbalancer-ceph
#                               ...  description=test-ceph-lb
#
#        ${policy_id_str}            Convert To String    ${policy_id}
#
#        ${response}                 PCC.Unassign Locations Assigned from Policy
#                               ...  Id=${policy_id_str}
#
#                                    Should Be Equal As Strings      ${response}  OK
#
#        ${response}                 PCC.Delete Policy
#                               ...  Name=loadbalancer-ceph
#                               ...  description=test-ceph-lb
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
####################################################################################################################################
#Removing Ceph Load balancer Policy Secondary
####################################################################################################################################
#    [Documentation]                 *Removing Ceph Load balancer Policy Primary*
#
#
#        ${status}                   Login To PCC Secondary   ${pcc_setup}
#
#        ${policy_id}                PCC.Get Policy Id
#                               ...  Name=loadbalancer-ceph
#                               ...  description=test-ceph-lb
#
#        ${policy_id_str}            Convert To String    ${policy_id}
#
#        ${response}                 PCC.Unassign Locations Assigned from Policy
#                               ...  Id=${policy_id_str}
#
#                                    Should Be Equal As Strings      ${response}  OK
#
#        ${response}                 PCC.Delete Policy
#                               ...  Name=loadbalancer-ceph
#                               ...  description=test-ceph-lb
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
######################################################################################################################################
#Delete Primary Ceph Rados Gateway Delete
######################################################################################################################################
#
#    [Documentation]                 *Ceph Rados Gateway Delete*
#
#        ${status}                   Login To PCC    ${pcc_setup}
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME}
#		                       ...  ceph_cluster_name=ceph-pvt
#		                            Pass Execution If    ${rgw_id} is ${None}    There is no RGW for deletion
#
#        ${response}                 PCC.Ceph Delete Rgw
#                               ...  name=${CEPH_RGW_NAME}
#			                   ...  ceph_cluster_name=ceph-pvt
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rgw Deleted
#                               ...  name=${CEPH_RGW_NAME}
#			                   ...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
#                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP}
#                                    Should Be Equal As Strings      ${backend_status}    OK
#
#####################################################################################################################################
#Delete Seondary Ceph Rados Gateway
######################################################################################################################################
#
#    [Documentation]                 *Ceph Rados Gateway Delete*
#
#	    ${status}                   Login To PCC Secondary  ${pcc_setup}
#
#        ${status}                   PCC.Ceph Get Pcc Status
#                               ...  name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${rgw_id}                   PCC.Ceph Get Rgw Id
#                               ...  name=${CEPH_RGW_NAME_SECONDARY}
#		                       ...  ceph_cluster_name=ceph-pvt
#		                            Pass Execution If    ${rgw_id} is ${None}    There is no RGW for deletion
#
#        ${response}                 PCC.Ceph Delete Rgw
#                               ...  name=${CEPH_RGW_NAME_SECONDARY}
#			                   ...  ceph_cluster_name=ceph-pvt
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${message}                  Get Response Message        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Rgw Deleted
#                               ...  name=${CEPH_RGW_NAME_SECONDARY}
#			                   ...  ceph_cluster_name=ceph-pvt
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
#                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP_SECONDARY}
#                                    Should Be Equal As Strings      ${backend_status}    OK
