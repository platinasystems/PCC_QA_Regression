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
                                            Load Ceph Cluster Data Secondary  ${pcc_setup}
                                            Load Ceph Pool Data Secondary  ${pcc_setup}
                                            Load Ceph Rgw Data Secondary  ${pcc_setup}
                                            Load Server 1 Secondary Test Data  ${pcc_setup}
                                            Load Server 2 Secondary Test Data  ${pcc_setup}
                                            Load Server 3 Secondary Test Data  ${pcc_setup}
                                            Load Server 4 Secondary Test Data        ${pcc_setup}
                                            Load Server 5 Secondary Test Data        ${pcc_setup}
                                            Load Server 6 Secondary Test Data        ${pcc_setup}


        ${status}                           Login To PCC        testdata_key=${pcc_setup}
                                            Should Be Equal     ${status}  OK

###################################################################################################################################
Ceph Delete Unused Pools
###################################################################################################################################

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${status}                   PCC.Ceph Delete Unused Pools
                               ...  ceph_cluster_id=${cluster_id}
                                    Should be equal as strings    ${status}    OK

                                    sleep  1m

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
                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Creating RGW without name (Negative)
######################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}

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
                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Creating RGW without port (Negative)
######################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP}
                               ...  port=
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}

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
                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Creating RGW without hosts/nodes (Negative)
######################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${num_daemons_map}          Create Dictionary

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  num_daemons_map=${num_daemons_map}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Creating RGW with non alphanumeric name (Negative)
######################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=@#$%^&
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}

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
                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL}
                               ...  zone_group=custom_zonegroup
                               ...  zone=custom_zone

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK
###################################################################################################################################
Check Pool Used By RGW
###################################################################################################################################
    [Documentation]                 *Check Pool Used By RGW*

    ${cluster_id}                   PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

    ${response}                     PCC.Ceph Pool Check Used By
                               ...  name=${CEPH_RGW_POOLNAME}
                               ...  used_by_type=rgw
                               ...  used_by_name=${CEPH_RGW_NAME}
                               ...  ceph_cluster_id=${cluster_id}

                                    Should Be Equal As Strings      ${response}    OK

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
                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP}
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
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Create Rgw Configuration File
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

        ${server1_id}                      PCC.Get Node Id    Name=${SERVER_1_NAME}
                                           Log To Console    ${server1_id}

        ${server1_id_str}                  Convert To String    ${server1_id}

        ${interfaces}                      PCC.Ceph Get RGW Interfaces Map
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

		${rgw_server1_interfaces}		   Get From Dictionary  ${interfaces}  ${server1_id_str}

		${rgw_server1_interface0}		   Get From List  ${rgw_server1_interfaces}  0



        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${rgw_server1_interface0}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create Rgw Bucket
###################################################################################################################################
    [Documentation]                        *Create Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Make Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
List Rgw Bucket
###################################################################################################################################
    [Documentation]                        *List Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Upload File To Bucket
###################################################################################################################################
    [Documentation]                        *Upload File To Bucket*

        ${status}                          PCC.Ceph Rgw Upload File To Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Get A File From Rgw Bucket
###################################################################################################################################
    [Documentation]                        *Get a file from Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Get File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

#####################################################################################################################################
Ceph Rados Increase Number Of Deamons
#####################################################################################################################################
     [Documentation]                 *Ceph Rados Increase Number Of Deamons*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt

	    ${num_daemons_map}          Create Dictionary       ${SERVER_1_NAME}=${4}

        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  num_daemons_map=${num_daemons_map}
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
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify Data Durability
###################################################################################################################################
    [Documentation]                        *Verify Data Durability*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Get File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK


#####################################################################################################################################
Ceph Rados Decrease Number Of Deamons
#####################################################################################################################################
     [Documentation]                 *Ceph Rados Increase Number Of Deamons*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt

	    ${num_daemons_map}          Create Dictionary       ${SERVER_1_NAME}=${2}

        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  num_daemons_map=${num_daemons_map}
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
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Verify Data Durability
###################################################################################################################################
    [Documentation]                        *Verify Data Durability*


        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Get File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK


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
                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP}
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
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Verify Data Durability
###################################################################################################################################
    [Documentation]                        *Verify Data Durability*


        ${accessKey}                       PCC.Ceph Get Rgw Access Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

        ${server1_id}                      PCC.Get Node Id    Name=${SERVER_1_NAME}
                                           Log To Console    ${server1_id}

        ${server1_id_str}                  Convert To String    ${server1_id}

        ${interfaces}                      PCC.Ceph Get RGW Interfaces Map
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

		${rgw_server1_interfaces}		   Get From Dictionary  ${interfaces}  ${server1_id_str}

		${rgw_server1_interface0}		   Get From List  ${rgw_server1_interfaces}  0



        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${rgw_server1_interface0}
                                      ...  port=446

                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Get File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

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

        ${num_daemons_map}          Create Dictionary       ${SERVER_1_NAME}=${2}      ${SERVER_2_NAME}=${2}

        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  num_daemons_map=${num_daemons_map}
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
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify Data Durability
###################################################################################################################################
    [Documentation]                        *Verify Data Durability*


        ${accessKey}                       PCC.Ceph Get Rgw Access Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

        ${server1_id}                      PCC.Get Node Id    Name=${SERVER_1_NAME}
                                           Log To Console    ${server1_id}

        ${server1_id_str}                  Convert To String    ${server1_id}

        ${interfaces}                      PCC.Ceph Get RGW Interfaces Map
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

		${rgw_server1_interfaces}		   Get From Dictionary  ${interfaces}  ${server1_id_str}

		${rgw_server1_interface0}		   Get From List  ${rgw_server1_interfaces}  0



        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${rgw_server1_interface0}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Get File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK



#####################################################################################################################################
Ceph Rados Update Disjoint Nodes
#####################################################################################################################################
     [Documentation]                *Ceph Rados Gateway Update*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt
			                        Set Suite Variable   ${rgw_id}

        ${num_daemons_map}          Create Dictionary       ${SERVER_3_NAME}=${1}

        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  num_daemons_map=${num_daemons_map}
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
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify Data Durability
###################################################################################################################################
    [Documentation]                        *Verify Data Durability*


        ${accessKey}                       PCC.Ceph Get Rgw Access Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

        ${server3_id}                      PCC.Get Node Id    Name=${SERVER_3_NAME}
                                           Log To Console    ${server3_id}

        ${server3_id_str}                  Convert To String    ${server3_id}

        ${interfaces}                      PCC.Ceph Get RGW Interfaces Map
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

		${rgw_server3_interfaces}		   Get From Dictionary  ${interfaces}  ${server3_id_str}

		${rgw_server3_interface0}		   Get From List  ${rgw_server3_interfaces}  0



        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_3_HOST_IP}
                                      ...  targetNodeIp=${rgw_server3_interface0}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_3_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Get File From Bucket
                                      ...  pcc=${SERVER_3_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK




######################################################################################################################################
#Ceph Load Balancer create on Rgw with 2 nodes
######################################################################################################################################
#     [Documentation]                *Ceph Load Balancer create on Rgw with 2 nodes*
#
#
#        ${app_id}    PCC.Get App Id from Policies
#                     ...  Name=loadbalancer-ceph
#                     Log To Console    ${app_id}
#
#        ${rgw_id}      PCC.Ceph Get Rgw Id
#                       ...  name=${CEPH_RGW_NAME}
#			           ...  ceph_cluster_name=ceph-pvt
#			           Set Suite Variable   ${rgw_id}
#
#        ${scope1_id}    PCC.Get Scope Id
#                         ...  scope_name=Default region
#
#        ${response}    PCC.Create Policy
#                       ...  appId=${app_id}
#                       ...  description=test-ceph-lb
#                       ...  scopeIds=[${scope1_id}]
#                       ...  inputs=[{"name": "lb_name","value": "testcephlb"},{"name": "lb_balance_method","value": "roundrobin"},{"name": "lb_frontend","value": "0.0.0.0:9898"},{"name": "lb_backends","value": "${rgw_id}"}]
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Be Equal As Strings    ${status}    200
#
#        ${response}            PCC.Add and Verify Roles On Nodes
#                               ...  nodes=["${SERVER_3_NAME}"]
#                               ...  roles=["Ceph Load Balancer"]
#
#                                    Should Be Equal As Strings      ${response}  OK
#
#        ${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${SERVER_3_NAME}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK
#
####################################################################################################################################
#Create Rgw Configuration File On Load-Balancer Node
####################################################################################################################################
#    [Documentation]                        *Create Rgw Configuration File*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${accessKey}                       PCC.Ceph Get Rgw Access Key
#                                      ...  name=${CEPH_RGW_NAME}
#				                      ...  ceph_cluster_name=ceph-pvt
#
#        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
#                                      ...  name=${CEPH_RGW_NAME}
#				                      ...  ceph_cluster_name=ceph-pvt
#
#        ${status}                          PCC.Ceph Rgw Configure
#                                      ...  accessKey=${accessKey}
#                                      ...  secretKey=${secretKey}
#                                      ...  pcc=${SERVER_3_HOST_IP}
#                                      ...  targetNodeIp=0.0.0.0
#                                      ...  port=9898
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Create Rgw Bucket (Load-Balancer Ip-port)
####################################################################################################################################
#    [Documentation]                        *Create Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Make Bucket
#                                      ...  pcc=${SERVER_3_HOST_IP}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#List Rgw Bucket (Load-Balancer Ip-port)
####################################################################################################################################
#    [Documentation]                        *List Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw List Buckets
#                                      ...  pcc=${SERVER_3_HOST_IP}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Try To ADD File (ServiceIp As Default)
####################################################################################################################################
#    [Documentation]                        *Try To ADD File*
#
#        ${status}                          PCC.Ceph Rgw Upload File To Bucket
#                                      ...  pcc=${SERVER_3_HOST_IP}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#List Rgw Objects inside Bucket
####################################################################################################################################
#    [Documentation]                        *List Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=${CEPH_CLUSTER_NAME}
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw List Objects inside Buckets
#                                      ...  pcc=${SERVER_3_HOST_IP}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Delete A File From Rgw Bucket (ServiceIp As Default)
#####################################################################################################################################
#    [Documentation]                        *Delete a file from Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Delete File From Bucket
#                                      ...  pcc=${SERVER_3_HOST_IP}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Delete Rgw Bucket (ServiceIp As Default)
####################################################################################################################################
#      [Documentation]                      *Delete Rgw Bucket*
#
#        ${status}                          PCC.Ceph Get Pcc Status
#                                      ...  name=ceph-pvt
#                                           Should Be Equal As Strings      ${status}    OK
#
#        ${status}                          PCC.Ceph Rgw Delete Bucket
#                                      ...  pcc=${SERVER_3_HOST_IP}
#
#                                           Should Be Equal As Strings      ${status}    OK
#
#
#
####################################################################################################################################
#Removing Ceph Load balancer
####################################################################################################################################
#    [Documentation]                 *Removing Ceph Load balancer*
#
#        ${response}                 PCC.Delete and Verify Roles On Nodes
#                               ...  nodes=["${SERVER_3_NAME}"]
#                               ...  roles=["Ceph Load Balancer"]
#
#                                    Should Be Equal As Strings      ${response}  OK
#
#
#        ${node_wait_status}    PCC.Wait Until Node Ready
#                               ...  Name=${SERVER_3_NAME}
#
#                               Log To Console    ${node_wait_status}
#                               Should Be Equal As Strings    ${node_wait_status}    OK


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

        ${num_daemons_map}          Create Dictionary       ${SERVER_3_NAME}=${1}

        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
                               ...  num_daemons_map=${num_daemons_map}
                                    Should Be Equal As Strings      ${backend_status}    OK

                                    sleep  1m

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Rados Gateway Creation Multiple Daemons With S3 Accounts
#####################################################################################################################################

     [Documentation]                *Ceph Rados Gateway Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${num_daemons_map}          Create Dictionary       ${SERVER_1_NAME}=${3}

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  num_daemons_map=${num_daemons_map}
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
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create Rgw Configuration File
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

        ${server1_id}                      PCC.Get Node Id    Name=${SERVER_1_NAME}
                                           Log To Console    ${server1_id}

        ${server1_id_str}                  Convert To String    ${server1_id}

        ${interfaces}                      PCC.Ceph Get RGW Interfaces Map
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

		${rgw_server1_interfaces}		   Get From Dictionary  ${interfaces}  ${server1_id_str}

		${rgw_server1_interface0}		   Get From List  ${rgw_server1_interfaces}  0



        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${rgw_server1_interface0}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create Rgw Bucket
###################################################################################################################################
    [Documentation]                        *Create Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Make Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
List Rgw Bucket
###################################################################################################################################
    [Documentation]                        *List Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Upload File To Bucket
###################################################################################################################################
    [Documentation]                        *Upload File To Bucket*

        ${status}                          PCC.Ceph Rgw Upload File To Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Get A File From Rgw Bucket
###################################################################################################################################
    [Documentation]                        *Get a file from Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Get File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete Rgw Bucket When Bucket Is Not Empty (Negative)
###################################################################################################################################
      [Documentation]                      *Delete Rgw Bucket When Bucket Is Not Empty*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Not Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete A File From Rgw Bucket
####################################################################################################################################
    [Documentation]                        *Delete a file from Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete Rgw Bucket
###################################################################################################################################
      [Documentation]                      *Delete Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK


#####################################################################################################################################
Ceph Local Load Balancer create on Rgw
#####################################################################################################################################
     [Documentation]                *Ceph Local Load Balancer create on Rgw (primary)*

        ${status}              Login To PCC    ${pcc_setup}


        ${app_id}              PCC.Get App Id from Policies
                               ...  Name=loadbalancer-ceph
                               Log To Console    ${app_id}

        ${rgw_id}              PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                               Set Suite Variable   ${rgw_id}

        ${scope1_id}           PCC.Get Scope Id
                               ...  scope_name=Default region

        ${response}            PCC.Create Policy
                               ...  appId=${app_id}
                               ...  description=test-ceph-lb
                               ...  scopeIds=[${scope1_id}]
                               ...  inputs=[{"name": "lb_name","value": "testcephlb"},{"name": "lb_balance_method","value": "roundrobin"},{"name": "lb_mode","value": "local"},{"name": "lb_frontend","value": "0.0.0.0:9898"},{"name": "lb_backends","value": "${rgw_id}"}]

                               Log To Console    ${response}
                               ${result}    Get Result    ${response}
                               ${status}    Get From Dictionary    ${result}    status
                               ${message}    Get From Dictionary    ${result}    message
                               ${data}      Get From Dictionary    ${result}    Data
                               ${policy_tag_1_id}      Get From Dictionary    ${data}     id
                               Set Suite Variable  ${policy_tag_1_id}
                               Log to Console    ${message}
                               Should Be Equal As Strings    ${status}    200

        ${response}            PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${SERVER_1_NAME}"]
                               ...  roles=["Ceph Load Balancer"]

                               Should Be Equal As Strings      ${response}  OK

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_1_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

        ${status}               PCC.Verify HAProxy BE
 			                    ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                ...  name=${SERVER_1_NAME}
                                ...  policy_id=${policy_tag_1_id}

                                Should Be Equal As Strings    ${status}    OK



###################################################################################################################################
Create Rgw Configuration File (Local Load Balacer)
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

        ${server1_id}                      PCC.Get Node Id    Name=${SERVER_1_NAME}
                                           Log To Console    ${server1_id}

        ${server1_id_str}                  Convert To String    ${server1_id}

        ${interfaces}                      PCC.Ceph Get RGW Interfaces Map
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=ceph-pvt

		${rgw_server1_interfaces}		   Get From Dictionary  ${interfaces}  ${server1_id_str}

		${rgw_server1_interface0}		   Get From List  ${rgw_server1_interfaces}  0



        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_2_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP}
                                      ...  port=9898

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create Rgw Bucket (Local Load Balacer)
###################################################################################################################################
    [Documentation]                        *Create Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Make Bucket
                                      ...  pcc=${SERVER_2_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
List Rgw Bucket (Local Load Balacer)
###################################################################################################################################
    [Documentation]                        *List Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_2_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Upload File To Bucket (Local Load Balacer)
###################################################################################################################################
    [Documentation]                        *Upload File To Bucket*

        ${status}                          PCC.Ceph Rgw Upload File To Bucket
                                      ...  pcc=${SERVER_2_HOST_IP}
                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Get A File From Rgw Bucket (Local Load Balacer)
###################################################################################################################################
    [Documentation]                        *Get a file from Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Get File From Bucket
                                      ...  pcc=${SERVER_2_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete Rgw Bucket When Bucket Is Not Empty (Local Load Balacer) (Negative)
###################################################################################################################################
      [Documentation]                      *Delete Rgw Bucket When Bucket Is Not Empty*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete Bucket
                                      ...  pcc=${SERVER_2_HOST_IP}

                                           Should Not Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete A File From Rgw Bucket (Local Load Balacer)
####################################################################################################################################
    [Documentation]                        *Delete a file from Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete File From Bucket
                                      ...  pcc=${SERVER_2_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete Rgw Bucket (Local Load Balacer)
###################################################################################################################################
      [Documentation]                      *Delete Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete Bucket
                                      ...  pcc=${SERVER_2_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Removing Ceph Load balancer
###################################################################################################################################
    [Documentation]                 *Removing Ceph Load balancer*


        ${status}                   Login To PCC   ${pcc_setup}

        ${response}                 PCC.Delete and Verify Roles On Nodes
                               ...  nodes=["${SERVER_1_NAME}"]
                               ...  roles=["Ceph Load Balancer"]

                                    Should Be Equal As Strings      ${response}  OK

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_1_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK


###################################################################################################################################
Removing Ceph Load balancer Policy Primary
###################################################################################################################################
    [Documentation]                 *Removing Ceph Load balancer Policy Primary*


        ${status}                   Login To PCC   ${pcc_setup}

        ${policy_id}                PCC.Get Policy Id
                               ...  Name=loadbalancer-ceph
                               ...  description=test-ceph-lb

        ${policy_id_str}            Convert To String    ${policy_id}

        ${response}                 PCC.Unassign Locations Assigned from Policy
                               ...  Id=${policy_id_str}

                                    Should Be Equal As Strings      ${response}  OK

        ${node_wait_status}         PCC.Wait Until Node Ready
                               ...  Name=${SERVER_1_NAME}

                                   Log To Console    ${node_wait_status}
                                   Should Be Equal As Strings    ${node_wait_status}    OK

        ${response}                 PCC.Delete Policy
                               ...  Name=loadbalancer-ceph
                               ...  description=test-ceph-lb

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

#####################################################################################################################################
Ceph Local Load Balancer with Control_IP on Rgw
#####################################################################################################################################
     [Tags]         lb
     [Documentation]                *Ceph Local Load Balancer with Control_IP on Rgw*

        ${status}                   Login To PCC    ${pcc_setup}
                                    Log To Console    ${status}

        ${app_id}                   PCC.Get App Id from Policies
                                   ...  Name=loadbalancer-ceph
                                    Log To Console    ${app_id}

        ${status}                   PCC.Ceph Get Pcc Status
                                    ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK
                                    Log To Console    ${CEPH_RGW_NAME}
                                    Log To Console    ${CEPH_CLUSTER_NAME}
        ${rgw_id}                   PCC.Ceph Get Rgw Id
                                    ...  name=${CEPH_RGW_NAME}
			                        ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Set Suite Variable   ${rgw_id}
                                    Log To Console    ${rgw_id}

        ${scope1_id}                PCC.Get Scope Id
                                    ...  scope_name=Default region
                                    Log To Console    ${scope1_id}
        ${response}                 PCC.Create Policy
                                    ...  appId=${app_id}
                                    ...  description=test-ceph-lb_ControlIP
                                    ...  scopeIds=[${scope1_id}]
                                    ...  inputs=[{"name": "lb_name","value": "testcephlbcontrolip"},{"name": "lb_balance_method","value": "roundrobin"},{"name": "lb_mode","value": "local"},{"name": "lb_frontend","value": "control_ip:443"},{"name": "lb_backends","value": "${rgw_id}"}]

                                    Log To Console    ${response}
                                    ${result}    Get Result    ${response}
                                    ${status}    Get From Dictionary    ${result}    status
                                    ${message}    Get From Dictionary    ${result}    message
                                    ${data}      Get From Dictionary    ${result}    Data
                                    ${policy_tag_1_id}      Get From Dictionary    ${data}     id
                                    Set Suite Variable  ${policy_tag_1_id}
                                    Log to Console    ${message}
                                    Should Be Equal As Strings    ${status}    200

        ${response}                 PCC.Add and Verify Roles On Nodes
                                    ...  nodes=["${SERVER_1_NAME}"]
                                    ...  roles=["Ceph Load Balancer"]
                                    Log To Console    ${response}
                                    Should Be Equal As Strings      ${response}  OK

        ${node_wait_status}         PCC.Wait Until Node Ready
                                    ...  Name=${SERVER_1_NAME}
                                    Log To Console    ${node_wait_status}
                                    Should Be Equal As Strings    ${node_wait_status}    OK

        ${response}                 PCC.Get CEPH RGW HAPROXY IP
                                    ...  hostip=${SERVER_1_HOST_IP}
                                    Log To Console    ${response}
                                    Should Be Equal As Strings      ${response}  OK

        ${status}                   PCC.Verify HAProxy BE
 			                        ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    ...  name=${SERVER_1_NAME}
                                    ...  policy_id=${policy_tag_1_id}

                                    Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Removing Ceph Load balancer Policy
###################################################################################################################################
    [Tags]      lb
    [Documentation]                 *Removing Ceph Load balancer Policy*


        ${status}                   Login To PCC   ${pcc_setup}

        ${policy_id}                PCC.Get Policy Id
                               ...  Name=loadbalancer-ceph
                               ...  description=test-ceph-lb_ControlIP

        ${policy_id_str}            Convert To String    ${policy_id}

        ${response}                 PCC.Unassign Locations Assigned from Policy
                               ...  Id=${policy_id_str}

                                    Should Be Equal As Strings      ${response}  OK

        ${node_wait_status}         PCC.Wait Until Node Ready
                               ...  Name=${SERVER_1_NAME}

                                   Log To Console    ${node_wait_status}
                                   Should Be Equal As Strings    ${node_wait_status}    OK

        ${response}                 PCC.Delete Policy
                               ...  Name=loadbalancer-ceph
                               ...  description=test-ceph-lb_ControlIP

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Ceph Multiple RGW Load Balancer
###################################################################################################################################

        [Documentation]    *Ceph Multiple RGW Load Balancer *


        ${response}             PCC.Create Tag
                                ...  Name=multiple-lb
                                ...  Description=multiple-lb

                                ${result}    Get Result    ${response}
                                ${status}    Get From Dictionary    ${result}    status
                                ${message}    Get From Dictionary    ${result}    message
                                Should Be Equal As Strings    ${status}    200


        ${app_id}              PCC.Get App Id from Policies
                               ...  Name=loadbalancer-ceph
                               Log To Console    ${app_id}

        ${rgw_id}              PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                               Set Suite Variable   ${rgw_id}


        ${response}            PCC.Create Policy
                               ...  appId=${app_id}
                               ...  description=test-ceph-lb-1
                               ...  inputs=[{"name": "lb_name","value": "testcephlb1"},{"name": "lb_balance_method","value": "roundrobin"},{"name": "lb_mode","value": "local"},{"name": "lb_frontend","value": "0.0.0.0:9898"},{"name": "lb_backends","value": "${rgw_id}"}]

                                ${result}    Get Result    ${response}
                                ${status}    Get From Dictionary    ${result}    status
                                ${data}      Get From Dictionary    ${result}    Data
                                ${policy_tag_1_id}      Get From Dictionary    ${data}     id
                                Set Suite Variable  ${policy_tag_1_id}
                                Should Be Equal As Strings    ${status}    200

        ${response}            PCC.Create Policy
                               ...  appId=${app_id}
                               ...  description=test-ceph-lb-2
                               ...  inputs=[{"name": "lb_name","value": "testcephlb2"},{"name": "lb_balance_method","value": "roundrobin"},{"name": "lb_mode","value": "local"},{"name": "lb_frontend","value": "control_ip:4444"},{"name": "lb_backends","value": "${rgw_id}"}]

                                ${result}    Get Result    ${response}
                                ${status}    Get From Dictionary    ${result}    status
                                ${data}      Get From Dictionary    ${result}    Data
                                ${policy_tag_2_id}      Get From Dictionary    ${data}     id
                                Set Suite Variable  ${policy_tag_2_id}
                                Should Be Equal As Strings    ${status}    200

        ${tag_1}                PCC.Get Tag By Name
                                ...    Name=multiple-lb
        ${tag_1_id}             Get From Dictionary    ${tag_1}    id


        ${response}             PCC.Edit Tag
                                ...  Id=${tag_1_id}
                                ...  Name=multiple-lb
                                ...  PolicyIDs=[${policy_tag_1_id},${policy_tag_2_id}]

                                ${result}    Get Result    ${response}
                                ${status}    Get From Dictionary    ${result}    status
                                Should Be Equal As Strings    ${status}    200

        ${result}               PCC.Add and Verify Tags On Nodes
                                ...  nodes=["${SERVER_1_NAME}"]
                                ...  tags=["multiple-lb"]

                                Should Be Equal As Strings    ${result}    OK

    ${node_wait_status}         PCC.Wait Until Node Ready
                                ...  Name=${SERVER_1_NAME}

                                Should Be Equal As Strings    ${node_wait_status}    OK


    ${status}                   PCC.Verify HAProxy BE
 			                    ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                ...  name=${SERVER_1_NAME}
                                ...  policy_id=${policy_tag_1_id}

                                Should Be Equal As Strings    ${status}    OK

    ${status}                   PCC.Verify HAProxy BE
 			                    ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                ...  name=${SERVER_1_NAME}
                                ...  policy_id=${policy_tag_2_id}

                                Should Be Equal As Strings    ${status}    OK

######################################################################################################################################
Delete Multiple RGW Load Balancer
######################################################################################################################################
       [Documentation]                 *Delete Multiple RGW Load Balancer*

    ${result}                PCC.Add and Verify Tags On Nodes
                        ...  nodes=["${SERVER_1_NAME}"]
                        ...  tags=[]

                             Should Be Equal As Strings    ${result}    OK

    ${node_wait_status}      PCC.Wait Until Node Ready
                        ...  Name=${SERVER_1_NAME}

                             Should Be Equal As Strings    ${node_wait_status}    OK


    ${tag_1}                     PCC.Get Tag By Name
                            ...  Name=multiple-lb
    ${tag_1_id}                  Get From Dictionary    ${tag_1}    id


    ${response}                  PCC.Edit Tag
                            ...  Id=${tag_1_id}
                            ...  Name=multiple-lb

                                ${result}    Get Result    ${response}
                                ${status}    Get From Dictionary    ${result}    status
                                Should Be Equal As Strings    ${status}    200

    ${node_wait_status}         PCC.Wait Until Node Ready
                           ...  Name=${SERVER_1_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK

    ${response}                 PCC.Delete Policy
                           ...  Name=loadbalancer-ceph
                           ...  description=test-ceph-lb-1

    ${status_code}              Get Response Status Code        ${response}
    ${message}                  Get Response Message        ${response}
                                Should Be Equal As Strings      ${status_code}  200

    ${response}                 PCC.Delete Policy
                           ...  Name=loadbalancer-ceph
                           ...  description=test-ceph-lb-2

    ${status_code}              Get Response Status Code        ${response}
    ${message}                  Get Response Message        ${response}
                                Should Be Equal As Strings      ${status_code}  200


    ${response}                 PCC.Delete and Verify Roles On Nodes
                           ...  nodes=["${SERVER_1_NAME}"]
                           ...  roles=["Ceph Load Balancer"]

                                Should Be Equal As Strings      ${response}  OK

    ${node_wait_status}         PCC.Wait Until Node Ready
                           ...  Name=${SERVER_1_NAME}

                                Log To Console    ${node_wait_status}
                                Should Be Equal As Strings    ${node_wait_status}    OK

#####################################################################################################################################
Ceph Rados Remove S3Account
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
                                ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP}
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
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

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
                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP}
                                    Should Be Equal As Strings      ${backend_status}    OK

                                    sleep  1m

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK
#####################################################################################################################################
Ceph Rados Create with Multiple Nodes
#####################################################################################################################################
     [Documentation]                 *Ceph Rados Gateway Create*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${num_daemons_map}          Create Dictionary       ${SERVER_1_NAME}=${1}      ${SERVER_2_NAME}=${1}

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  num_daemons_map=${num_daemons_map}
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
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

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

        ${num_daemons_map}          Create Dictionary      ${SERVER_2_NAME}=${1}

        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=${CEPH_RGW_POOLNAME}
                               ...  num_daemons_map=${num_daemons_map}
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
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

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

        ${num_daemons_map}          Create Dictionary      ${SERVER_2_NAME}=${1}

        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
                               ...  num_daemons_map=${num_daemons_map}
                                    Should Be Equal As Strings      ${backend_status}    OK

                                    sleep  1m

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Rados Gateway Creation With Replicated Pool Without S3 Accounts For Non Ceph Node
#####################################################################################################################################

     [Documentation]                 *Ceph Rados Gateway Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${num_daemons_map}          Create Dictionary      ${CLUSTERHEAD_1_NAME}=${1}

        ${response}                 PCC.Ceph Create Rgw
                               ...  name=${CEPH_RGW_NAME}
                               ...  poolName=rgw-non-ceph
                               ...  num_daemons_map=${num_daemons_map}
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
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                               ...  name=${CEPH_RGW_NAME}
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

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

        ${num_daemons_map}          Create Dictionary      ${CLUSTERHEAD_1_NAME}=${1}

        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
                               ...  num_daemons_map=${num_daemons_map}
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

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
Create RGW With EC-Pool
###################################################################################################################################

    [Documentation]                        *Ceph Ceph Secondary Pool For Rgws*


	     ${status}                          Login To PCC Secondary       testdata_key=${pcc_setup}
                                            Should Be Equal     ${status}  OK

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                           Should Be Equal As Strings      ${status}    OK

        ${cluster_id}                      PCC.Ceph Get Cluster Id
                                      ...  name=${CEPH_CLUSTER_NAME_SECONDARY}

        ${response}                        PCC.Ceph Create Erasure Pool
                                       ...  name=${CEPH_RGW_POOLNAME_EC_SECONDARY}
                                       ...  ceph_cluster_id=${cluster_id}
                                       ...  size=${CEPH_POOL_SIZE_SECONDARY}
                                       ...  tags=${CEPH_POOL_TAGS_SECONDARY}
                                       ...  pool_type=${CEPH_POOL_TYPE_SECONDARY}
                                       ...  resilienceScheme=erasure
                                       ...  quota=3
                                       ...  quota_unit=GiB
                                       ...  Datachunks=2
                                       ...  Codingchunks=1
                                       ...  pg_num=1

        ${status_code}                     Get Response Status Code        ${response}
        ${message}                         Get Response Message        ${response}
                                           Should Be Equal As Strings      ${status_code}  200

        ${status}                          PCC.Ceph Wait Until Pool Ready
                                      ...  name=${CEPH_RGW_POOLNAME_EC_SECONDARY}
                                           Should Be Equal As Strings      ${status}    OK

        ${response}                        PCC.Add Metadata Profile
                                      ...    Name=appcred_ec
                                      ...    Type=ceph

                                           Log To Console    ${response}
                                           ${result}    Get Result    ${response}
                                           ${status}    Get From Dictionary    ${result}    status
                                           ${message}    Get From Dictionary    ${result}    message
                                           Log to Console    ${message}
                                           Should Be Equal As Strings    ${status}    200


        ${response}                        PCC.Ceph Create Rgw
                                      ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
                                      ...  poolName=${CEPH_RGW_POOLNAME_EC_SECONDARY}
                                      ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP_SECONDARY}
                                      ...  port=${CEPH_RGW_PORT_SECONDARY}
                                      ...  certificateName=${CEPH_RGW_CERT_NAME_SECONDARY}
                                      ...  certificateUrl=${CEPH_RGW_CERT_URL_SECONDARY}
                                      ...  S3Accounts=["appcred_ec"]
                                      ...  zone_group=custom_zonegroup
                                      ...  zone=custom_zone

        ${status_code}                     Get Response Status Code        ${response}
        ${message}                         Get Response Message        ${response}
                                           Should Be Equal As Strings      ${status_code}  200

        ${status}                          PCC.Ceph Wait Until Rgw Ready
                                      ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
                                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
                                           Should Be Equal As Strings      ${status}    OK

        ${backend_status}                  PCC.Ceph Rgw Verify BE Creation
                                       ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
                                       ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
                                           Should Be Equal As Strings      ${backend_status}    OK

        ${status}                          PCC.Ceph Verify RGW Node role
                                       ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
                                           Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Create Rgw Configuration File
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                           Should Be Equal As Strings      ${status}    OK

        ${accessKey}                       PCC.Ceph Get Rgw Access Key
                                      ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
				                      ...  ceph_cluster_name=ceph-pvt

        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
                                      ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

        ${server1_id}                      PCC.Get Node Id    Name=${SERVER_1_NAME_SECONDARY}
                                           Log To Console    ${server1_id}

        ${server1_id_str}                  Convert To String    ${server1_id}

        ${interfaces}                      PCC.Ceph Get RGW Interfaces Map
                                      ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

		${rgw_server1_interfaces}		   Get From Dictionary  ${interfaces}  ${server1_id_str}

		${rgw_server1_interface0}		   Get From List  ${rgw_server1_interfaces}  0



        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_1_HOST_IP_SECONDARY}
                                      ...  targetNodeIp=${rgw_server1_interface0}
                                      ...  port=${CEPH_RGW_PORT_SECONDARY}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create Rgw Bucket
###################################################################################################################################
    [Documentation]                        *Create Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Make Bucket
                                      ...  pcc=${SERVER_1_HOST_IP_SECONDARY}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
List Rgw Bucket
###################################################################################################################################
    [Documentation]                        *List Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_1_HOST_IP_SECONDARY}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Upload File To Bucket
###################################################################################################################################
    [Documentation]                        *Upload File To Bucket*

        ${status}                          PCC.Ceph Rgw Upload File To Bucket
                                      ...  pcc=${SERVER_1_HOST_IP_SECONDARY}
                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Get A File From Rgw Bucket
###################################################################################################################################
    [Documentation]                        *Get a file from Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Get File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP_SECONDARY}

                                           Should Be Equal As Strings      ${status}    OK

#####################################################################################################################################
Ceph Rados Update Disjoint Nodes
#####################################################################################################################################
     [Documentation]                *Ceph Rados Gateway Update*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
			                        Set Suite Variable   ${rgw_id}

        ${num_daemons_map}          Create Dictionary       ${SERVER_2_NAME_SECONDARY}=${1}

        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
                               ...  poolName=${CEPH_RGW_POOLNAME_EC_SECONDARY}
                               ...  num_daemons_map=${num_daemons_map}
                               ...  port=${CEPH_RGW_PORT}
                               ...  certificateName=${CEPH_RGW_CERT_NAME_SECONDARY}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL_SECONDARY}
                               ...  S3Accounts=["appcred_ec"]

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Creation
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
                               ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify Data Durability
###################################################################################################################################
    [Documentation]                        *Verify Data Durability*


        ${accessKey}                       PCC.Ceph Get Rgw Access Key
                                      ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
                                      ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

        ${server2_id}                      PCC.Get Node Id    Name=${SERVER_2_NAME_SECONDARY}
                                           Log To Console    ${server2_id}

        ${server2_id_str}                  Convert To String    ${server2_id}

        ${interfaces}                      PCC.Ceph Get RGW Interfaces Map
                                      ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

		${rgw_server2_interfaces}		   Get From Dictionary  ${interfaces}  ${server2_id_str}

		${rgw_server2_interface0}		   Get From List  ${rgw_server2_interfaces}  0



        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_2_HOST_IP_SECONDARY}
                                      ...  targetNodeIp=${rgw_server2_interface0}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_2_HOST_IP_SECONDARY}

                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Get File From Bucket
                                      ...  pcc=${SERVER_2_HOST_IP_SECONDARY}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Ceph Cluster Update - Remove Server With RGW Deployed on it
####################################################################################################################################
    [Documentation]                 *Ceph Cluster Update - Remove Server With RGW Deployed on it*


        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK


        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  nodes=["${SERVER_1_NAME_SECONDARY}","${SERVER_3_NAME_SECONDARY}","${SERVER_4_NAME_SECONDARY}","${SERVER_5_NAME_SECONDARY}","${SERVER_6_NAME_SECONDARY}"]
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK_SECONDARY}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=['${SERVER_1_HOST_IP_SECONDARY}','${SERVER_3_HOST_IP_SECONDARY}','${SERVER_4_HOST_IP_SECONDARY}','${SERVER_5_HOST_IP_SECONDARY}','${SERVER_6_HOST_IP_SECONDARY}']

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
BE Ceph Cleanup
###################################################################################################################################

        ${node_ip}                  Create List  ${SERVER_2_HOST_IP_SECONDARY}

        ${status}                   PCC.Ceph Cleanup BE
                               ...  nodes_ip=${node_ip}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}

                                    Should be equal as strings    ${status}    OK

###################################################################################################################################
Verify Data Durability
###################################################################################################################################
    [Documentation]                        *Verify Data Durability*


        ${accessKey}                       PCC.Ceph Get Rgw Access Key
                                      ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
                                      ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

        ${server2_id}                      PCC.Get Node Id    Name=${SERVER_2_NAME_SECONDARY}
                                           Log To Console    ${server2_id}

        ${server2_id_str}                  Convert To String    ${server2_id}

        ${interfaces}                      PCC.Ceph Get RGW Interfaces Map
                                      ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

		${rgw_server2_interfaces}		   Get From Dictionary  ${interfaces}  ${server2_id_str}

		${rgw_server2_interface0}		   Get From List  ${rgw_server2_interfaces}  0



        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_2_HOST_IP_SECONDARY}
                                      ...  targetNodeIp=${rgw_server2_interface0}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_2_HOST_IP_SECONDARY}

                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Get File From Bucket
                                      ...  pcc=${SERVER_2_HOST_IP_SECONDARY}

                                           Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Ceph Cluster Update - Add Server With RGW Deployed on it
####################################################################################################################################
    [Documentation]                 *Ceph Cluster Update - Add Server*

                                    #Wait crush update
                                    Sleep  8m

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK


        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  nodes=${CEPH_CLUSTER_NODES_SECONDARY}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK_SECONDARY}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
        ${message}                  Get Response Message        ${response}

        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Verify Data Durability
###################################################################################################################################
    [Documentation]                        *Verify Data Durability*


        ${accessKey}                       PCC.Ceph Get Rgw Access Key
                                      ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
                                      ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

        ${server2_id}                      PCC.Get Node Id    Name=${SERVER_2_NAME_SECONDARY}
                                           Log To Console    ${server2_id}

        ${server2_id_str}                  Convert To String    ${server2_id}

        ${interfaces}                      PCC.Ceph Get RGW Interfaces Map
                                      ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

		${rgw_server2_interfaces}		   Get From Dictionary  ${interfaces}  ${server2_id_str}

		${rgw_server2_interface0}		   Get From List  ${rgw_server2_interfaces}  0



        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_2_HOST_IP_SECONDARY}
                                      ...  targetNodeIp=${rgw_server2_interface0}
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_2_HOST_IP_SECONDARY}

                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=ceph-pvt
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Get File From Bucket
                                      ...  pcc=${SERVER_2_HOST_IP_SECONDARY}

                                           Should Be Equal As Strings      ${status}    OK


####################################################################################################################################
EC-Ceph Rados Gateway Delete
####################################################################################################################################

    [Documentation]                 *Ceph Rados Gateway Delete*

                                    #Wait crush update
                                    Sleep  8m

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...    name=${CEPH_RGW_NAME_EC_SECONDARY}
		                       ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
		                            Pass Execution If    ${rgw_id} is ${None}    There is no RGW for deletion

        ${response}                 PCC.Ceph Delete Rgw
                               ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Deleted
                               ...  name=${CEPH_RGW_NAME_EC_SECONDARY}
			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
                               ...  num_daemons_map=${CEPH_RGW_NUMDAEMONSMAP_SECONDARY}
                                    Should Be Equal As Strings      ${backend_status}    OK

        ${status}                   PCC.Ceph Verify RGW Node role
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete Metadata Profile
###################################################################################################################################

        [Documentation]         *Create Metadata Profile* test
                                ...  keywords:
                                ...  PCC.Delete Profile By Id

        ${response}             PCC.Delete Profile By Id
                                ...    Name=appcred_ec

                                Log To Console    ${response}


