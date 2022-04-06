*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
        [Tags]    This
                                            Load Ceph Rgw Data    ${pcc_setup}
                                            Load Ipam Data    ${pcc_setup}
					                        Load Ceph Pool Data    ${pcc_setup}
                                            Load Ceph Cluster Data    ${pcc_setup}
                                            Load Clusterhead 1 Test Data    ${pcc_setup}
                                            Load Clusterhead 2 Test Data    ${pcc_setup}
                                            Load Server 1 Test Data    ${pcc_setup}
                                            Load Server 2 Test Data    ${pcc_setup}
                                            Load Server 3 Test Data    ${pcc_setup}


        ${status}                           Login To PCC        testdata_key=${pcc_setup}
                                            Should Be Equal     ${status}  OK


###################################################################################################################################
Ceph Pool For Rgws
###################################################################################################################################

    [Documentation]                        *Ceph Ceph Pool For Rgws*
                                      ...  keywords:
                                      ...  PCC.Ceph Get Cluster Id
                                      ...  PCC.Ceph Create Pool
                                      ...  PCC.Ceph Wait Until Pool Ready
	#[Tags]    This
        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${cluster_id}                      PCC.Ceph Get Cluster Id
                                      ...  name=${CEPH_CLUSTER_NAME}

        ${response}                        PCC.Ceph Create Pool
                                      ...  name=${CEPH_RGW_POOLNAME}
                                      ...  ceph_cluster_id=${cluster_id}
                                      ...  size=${CEPH_POOL_SIZE}
                                      ...  tags=${CEPH_POOL_TAGS}
                                      ...  pool_type=${CEPH_POOL_TYPE}
                                      ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                                      ...  quota=1
                                      ...  quota_unit=GiB

        ${status_code}                     Get Response Status Code        ${response}
        ${message}                         Get Response Message        ${response}
                                           Should Be Equal As Strings      ${status_code}  200

        ${status}                          PCC.Ceph Wait Until Pool Ready
                                      ...  name=${CEPH_RGW_POOLNAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${response}                        PCC.Ceph Create Pool
                                      ...  name=rgw-pool-upd
                                      ...  ceph_cluster_id=${cluster_id}
                                      ...  size=${CEPH_POOL_SIZE}
                                      ...  tags=${CEPH_POOL_TAGS}
                                      ...  pool_type=${CEPH_POOL_TYPE}
                                      ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                                      ...  quota=1
                                      ...  quota_unit=GiB

        ${status_code}                     Get Response Status Code        ${response}
        ${message}                         Get Response Message        ${response}
                                           Should Be Equal As Strings      ${status_code}  200

        ${status}                          PCC.Ceph Wait Until Pool Ready
                                      ...  name=rgw-pool-upd
                                           Should Be Equal As Strings      ${status}    OK

        ${response}                        PCC.Ceph Create Pool
                                      ...  name=rgw-non-ceph
                                      ...  ceph_cluster_id=${cluster_id}
                                      ...  size=${CEPH_POOL_SIZE}
                                      ...  tags=${CEPH_POOL_TAGS}
                                      ...  pool_type=${CEPH_POOL_TYPE}
                                      ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
                                      ...  quota=1
                                      ...  quota_unit=GiB

        ${status_code}                     Get Response Status Code        ${response}
        ${message}                         Get Response Message        ${response}
                                           Should Be Equal As Strings      ${status_code}  200

        ${status}                          PCC.Ceph Wait Until Pool Ready
                                      ...  name=rgw-non-ceph
                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create Application credential profile without application For Rados
###################################################################################################################################

        [Documentation]               *Create Metadata Profile* test
                                      ...  keywords:
                                      ...  PCC.Add Metadata Profile
        #[Tags]    This
        ${response}                   PCC.Add Metadata Profile
                                      ...    Name=${CEPH_RGW_S3ACCOUNTS}
                                      ...    Type=ceph
                                      ...    Username=profile_without_app
                                      ...    Email=profile_without_app@gmail.com
                                      ...    Active=True

                                      Log To Console    ${response}
                                      ${result}    Get Result    ${response}
                                      ${status}    Get From Dictionary    ${result}    status
                                      ${message}    Get From Dictionary    ${result}    message
                                      Log to Console    ${message}
                                      Should Be Equal As Strings    ${status}    200

##################################################################################################################################
Ceph Ceph Certificate For Rgws
###################################################################################################################################

        [Documentation]              *Ceph Ceph Certificate For Rgws*
        #[Tags]    This
        ${cert_id}                   PCC.Get Certificate Id
                                ...  Alias=${CEPH_RGW_CERT_NAME}
                                     Pass Execution If    ${cert_id} is not ${None}    Certificate is already there

        ${response}                  PCC.Add Certificate
                                ...  Alias=${CEPH_RGW_CERT_NAME}
                                ...  Description=certificate-for-rgw
                                ...  Private_key=domain.key
                                ...  Certificate_upload=domain.crt

                                     Log To Console    ${response}
        ${result}                    Get Result    ${response}
        ${status}                    Get From Dictionary    ${result}    statusCodeValue
                                     Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Creating RGW using a pool that is used by other Ceph front-ends (Negative)
#####################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_POOL_TYPE}
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200


###################################################################################################################################
#Creating RGW without name (Negative)
######################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Creating RGW without pool name (Negative)
#####################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
#Creating RGW without port (Negative)
######################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=
                               ...  certificateName=${CEPH_RGW_CERT_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Creating RGW without certificate (Negative)
#####################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Creating RGW without hosts/nodes (Negative)
######################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=[]
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Creating RGW with non alphanumeric name (Negative)
######################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=@#$%^&
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Ceph Rados Gateway Creation With Replicated Pool Without S3 Accounts
#####################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*
	#[Tags]    This
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK

#####################################################################################################################################
Ceph Rados Add S3Account
#####################################################################################################################################
     [Documentation]                *Ceph Rados Gateway Update*
	#[Tags]    This
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt

        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}
                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK

#####################################################################################################################################
Ceph Rados Update Port
#####################################################################################################################################
     [Documentation]                 *Ceph Rados Gateway Update*
	[Tags]    This
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt

        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=446
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}
                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK

#####################################################################################################################################
Ceph Rados Update Nodes (Add Node)
#####################################################################################################################################
     [Documentation]                *Ceph Rados Gateway Update*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt
			                        Set Suite Variable   ${rgw_id}

        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=["${SERVER_2_NAME}","${SERVER_1_NAME}"]
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}
                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=["${SERVER_1_HOST_IP}"]
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=["${SERVER_2_HOST_IP}"]
                                    Should Be Equal As Strings      ${backend_status}    OK

#####################################################################################################################################
Ceph Load Balancer create on Rgw with 2 nodes
#####################################################################################################################################
     [Documentation]                *Ceph Load Balancer create on Rgw with 2 nodes*


        ${app_id}    PCC.Get App Id from Policies
                     ...  Name=loadbalancer-ceph
                     Log To Console    ${app_id}

        ${rgw_id}      PCC.Ceph Get Rgw Id
                       ...  name=${CEPH_RGW_NAME}
			           ...  ceph_cluster_name=ceph-pvt
			           Set Suite Variable   ${rgw_id}

        ${scope1_id}    PCC.Get Scope Id
                         ...  scope_name=Default region

        ${response}    PCC.Create Policy
                       ...  appId=${app_id}
                       ...  description=test-ceph-lb
                       ...  scopeIds=[${scope1_id}]
                       ...  inputs=[{"name": "lb_name","value": "testcephlb"},{"name": "lb_balance_method","value": "roundrobin"},{"name": "lb_frontend","value": "0.0.0.0:9898"},{"name": "lb_backends","value": "${rgw_id}"}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${response}            PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${SERVER_3_NAME}"]
                               ...  roles=["Ceph Load Balancer"]

                                    Should Be Equal As Strings      ${response}  OK

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_3_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

###################################################################################################################################
Create Rgw Configuration File On Load-Balancer Node
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${accessKey}                       PCC.Ceph Get Rgw Access Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_3_HOST_IP}
                                      ...  targetNodeIp=0.0.0.0
                                      ...  port=9898

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create Rgw Bucket (Load-Balancer Ip-port)
###################################################################################################################################
    [Documentation]                        *Create Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Make Bucket
                                      ...  pcc=${SERVER_3_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
List Rgw Bucket (Load-Balancer Ip-port)
###################################################################################################################################
    [Documentation]                        *List Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_3_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Try To ADD File (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Try To ADD File*

        ${status}                          PCC.Ceph Rgw Upload File To Bucket
                                      ...  pcc=${SERVER_3_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
List Rgw Objects inside Bucket
###################################################################################################################################
    [Documentation]                        *List Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Objects inside Buckets
                                      ...  pcc=${SERVER_3_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete A File From Rgw Bucket (ServiceIp As Default)
####################################################################################################################################
    [Documentation]                        *Delete a file from Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete File From Bucket
                                      ...  pcc=${SERVER_3_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete Rgw Bucket (ServiceIp As Default)
###################################################################################################################################
      [Documentation]                      *Delete Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete Bucket
                                      ...  pcc=${SERVER_3_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK



###################################################################################################################################
Removing Ceph Load balancer
###################################################################################################################################
    [Documentation]                 *Removing Ceph Load balancer*

        ${response}                 PCC.Delete and Verify Roles On Nodes
                               ...  nodes=["${SERVER_3_NAME}"]
                               ...  roles=["Ceph Load Balancer"]

                                    Should Be Equal As Strings      ${response}  OK


        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_3_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK


####################################################################################################################################
Ceph Rados Gateway Delete
####################################################################################################################################

    [Documentation]                 *Ceph Rados Gateway Delete*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Delete Rgw
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Deleted
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK
	                            Sleep    5 minutes

###################################################################################################################################
Ceph Rados Gateway Creation With Replicated Pool With S3 Accounts
#####################################################################################################################################

     [Documentation]                *Ceph Rados Gateway Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=${CEPH_RGW_NODES}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}
                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]


        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK

###################################################################################################################################
Create Rgw Configuration File (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

                                           Sleep    3 minutes
        ${accessKey}                       PCC.Ceph Get Rgw Access Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=0.0.0.0
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create Rgw Bucket (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Create Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Make Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
List Rgw Bucket (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *List Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Update Rgw Configuration File With Control IP And Try To ADD File (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*


        ${status}                          PCC.Ceph Rgw Update Configure
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  service_ip=yes
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Upload File To Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}
                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify File Is Upload on Pool (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Verify File Is Uploaded on Pool*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Verify File Upload To Pool
                                      ...  poolName=${CEPH_RGW_POOLNAME}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete A File From Rgw Bucket (ServiceIp As Default)
####################################################################################################################################
    [Documentation]                        *Delete a file from Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Update Rgw Configuration File With Data IP And Try To ADD File (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*


        ${status}                          PCC.Ceph Rgw Update Configure
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  service_ip=no
                                      ...  data_cidr=${IPAM_DATA_SUBNET_IP}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Upload File To Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}
                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify File Is Upload on Pool (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Verify File Is Uploaded on Pool*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Verify File Upload To Pool
                                      ...  poolName=${CEPH_RGW_POOLNAME}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Get A File From Rgw Bucket (ServiceIp As Default)
###################################################################################################################################
    [Documentation]                        *Get a file from Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Get File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete Rgw Bucket When Bucket Is Not Empty (ServiceIp As Default) (Negative)
###################################################################################################################################
      [Documentation]                      *Delete Rgw Bucket When Bucket Is Not Empty*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Not Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete A File From Rgw Bucket (ServiceIp As Default)
####################################################################################################################################
    [Documentation]                        *Delete a file from Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete Rgw Bucket (ServiceIp As Default)
###################################################################################################################################
      [Documentation]                      *Delete Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK


#####################################################################################################################################
Ceph Rados Remove S3Account (ServiceIp As Default)
#####################################################################################################################################
     [Documentation]                 *Ceph Rados Gateway Update*

         ${status}                   PCC.Ceph Get Pcc Status
                                ...  name=ceph-pvt
                                     Should Be Equal As Strings      ${status}    OK

         ${rgw_id}                   PCC.Ceph Get Rgw Id
                                ...  name=${CEPH_RGW_NAME}
 			       ...  ceph_cluster_name=ceph-pvt

         ${response}                 PCC.Ceph Update Rgw
                                ...  ID=${rgw_id}
                                ...  name=${CEPH_RGW_NAME}
                                ...  poolName=${CEPH_RGW_POOLNAME}
                                ...  targetNodes=${CEPH_RGW_NODES}
                                ...  port=${CEPH_RGW_PORT}
                                ...  certificateName=${CEPH_RGW_CERT_NAME}
                                ...  certificateUrl=${CEPH_RGW_CERT_URL}

         ${status_code}              Get Response Status Code        ${response}
         ${message}                  Get Response Message        ${response}
                                     Should Be Equal As Strings      ${status_code}  200

         ${status}                   PCC.Ceph Wait Until Rgw Ready
                                ...  name=${CEPH_RGW_NAME}
  			                    ...  ceph_cluster_name=ceph-pvt
                                     Should Be Equal As Strings      ${status}    OK

         ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                                ...  targetNodeIp=['${SERVER_1_HOST_IP}']
                                     Should Be Equal As Strings      ${backend_status}    OK

####################################################################################################################################
Ceph Rados Gateway Delete (ServiceIp As Default)
####################################################################################################################################

    [Documentation]                 *Ceph Rados Gateway Delete*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Delete Rgw
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Deleted
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK
				                    Sleep    5 minutes

#####################################################################################################################################
Ceph Rados Create with Multiple Nodes
#####################################################################################################################################
     [Documentation]                 *Ceph Rados Gateway Create*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=["${SERVER_2_NAME}","${SERVER_1_NAME}"]
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}
                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK

#####################################################################################################################################
Ceph Rados Remove One Node
#####################################################################################################################################
     [Documentation]                 *Ceph Rados Gateway Update*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt

        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  targetNodes=["${SERVER_2_NAME}"]
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}
                               ...  S3Accounts=["${CEPH_RGW_S3Accounts}"]

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${SERVER_2_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK

#####################################################################################################################################
Ceph Rados Gateway Delete
#####################################################################################################################################

    [Documentation]                 *Ceph Rados Gateway Delete*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Delete Rgw
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Deleted
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
                               ...  targetNodeIp=['${SERVER_2_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK
 				                    Sleep    5 minutes

###################################################################################################################################
Ceph Rados Gateway Creation With Replicated Pool Without S3 Accounts For Non Ceph Node
#####################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=rgw-non-ceph
                               ...  targetNodes=["${CLUSTERHEAD_1_NAME}"]
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  targetNodeIp=['${CLUSTERHEAD_1_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK

#####################################################################################################################################
Ceph Rados Gateway Delete
#####################################################################################################################################

    [Documentation]                 *Ceph Rados Gateway Delete*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Delete Rgw
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Deleted
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
                               ...  targetNodeIp=['${CLUSTERHEAD_1_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK
				                    Sleep    5 minutes

###################################################################################################################################
Delete Metadata Profile
###################################################################################################################################

        [Documentation]         *Create Metadata Profile* test
                                ...  keywords:
                                ...  PCC.Delete Profile By Id

        ${response}             PCC.Delete Profile By Id
                                ...    Name=${CEPH_RGW_S3ACCOUNTS}

                                Log To Console    ${response}

###################################################################################################################################
Login To PCC Secondary
###################################################################################################################################
        [Tags]    This
                                            Load Ceph Rgw Data Secondary    ${pcc_setup}
					                        Load Ceph Pool Data Secondary   ${pcc_setup}
                                            Load Ceph Cluster Data Secondary   ${pcc_setup}


        ${status}                           Login To PCC Secondary       testdata_key=${pcc_setup}
                                            Should Be Equal     ${status}  OK


###################################################################################################################################
Ceph Secondary Pool For Rgws
###################################################################################################################################

    [Documentation]                        *Ceph Ceph Secondary Pool For Rgws*
                                      ...  keywords:
                                      ...  PCC.Ceph Get Cluster Id
                                      ...  PCC.Ceph Create Pool
                                      ...  PCC.Ceph Wait Until Pool Ready
	#[Tags]    This
        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                           Should Be Equal As Strings      ${status}    OK

        ${cluster_id}                      PCC.Ceph Get Cluster Id
                                      ...  name=${CEPH_CLUSTER_NAME_SECONDARY}

        ${response}                        PCC.Ceph Create Pool
                                      ...  name=${CEPH_RGW_POOLNAME_SECONDARY}
                                      ...  ceph_cluster_id=${cluster_id}
                                      ...  size=${CEPH_POOL_SIZE_SECONDARY}
                                      ...  tags=${CEPH_POOL_TAGS_SECONDARY}
                                      ...  pool_type=${CEPH_POOL_TYPE_SECONDARY}
                                      ...  resilienceScheme=${POOL_RESILIENCE_SCHEME_SECONDARY}
                                      ...  quota=1
                                      ...  quota_unit=GiB

        ${status_code}                     Get Response Status Code        ${response}
        ${message}                         Get Response Message        ${response}
                                           Should Be Equal As Strings      ${status_code}  200

        ${status}                          PCC.Ceph Wait Until Pool Ready
                                      ...  name=${CEPH_RGW_POOLNAME_SECONDARY}
                                           Should Be Equal As Strings      ${status}    OK

##################################################################################################################################
Ceph Ceph Certificate For Rgws
###################################################################################################################################

        [Documentation]              *Ceph Ceph Certificate For Rgws*
        #[Tags]    This
        ${cert_id}                   PCC.Get Certificate Id
                                ...  Alias=${CEPH_RGW_CERT_NAME_SECONDARY}
                                     Pass Execution If    ${cert_id} is not ${None}    Certificate is already there

        ${response}                  PCC.Add Certificate
                                ...  Alias=${CEPH_RGW_CERT_NAME_SECONDARY}
                                ...  Description=certificate-for-rgw
                                ...  Private_key=domain.key
                                ...  Certificate_upload=domain.crt

                                     Log To Console    ${response}
        ${result}                    Get Result    ${response}
        ${status}                    Get From Dictionary    ${result}    statusCodeValue
                                     Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Ceph Rados Gateway Secondary Creation
#####################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Secondary Creation*
	#[Tags]    This
        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME_SECONDARY}
                               ...  poolName=${CEPH_RGW_POOLNAME_SECONDARY}
                               ...  targetNodes=${CEPH_RGW_NODES_SECONDARY}
                               ...  port=${CEPH_RGW_PORT_SECONDARY}
                               ...  certificateName=${CEPH_RGW_CERT_NAME_SECONDARY}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL_SECONDARY}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME_SECONDARY}
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK