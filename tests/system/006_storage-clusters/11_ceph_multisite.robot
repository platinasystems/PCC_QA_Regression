*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212


*** Test Cases ***
###################################################################################################################################
Load Test Variable
###################################################################################################################################
                        Load Ceph Rgw Data    ${pcc_setup}
                        Load Ceph Cluster Data  ${pcc_setup}
                        Load Ceph Rgw Data Secondary   ${pcc_setup}
                        Load Ceph Cluster Data Secondary  ${pcc_setup}
                        Load Server 1 Test Data    ${pcc_setup}
                        Load Server 1 Secondary Test Data    ${pcc_setup}

###################################################################################################################################
Login to PCC Primary
###################################################################################################################################

        ${status}        Login To PCC    ${pcc_setup}

###################################################################################################################################
Primary Started Trust Creation
###################################################################################################################################
        [Documentation]                *Primary Started Trust Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}

		${response}	                PCC.Ceph Primary Start Trust
			                   ...  masterAppID=${rgw_id}

        ${result}                   Get Result    ${response}
        ${data}                     Get From Dictionary     ${result}   Data
        ${primary_trust_id}         Get From Dictionary     ${data}     id
                                    Set Suite Variable   ${primary_trust_id}
                                    Log To Console      ${primary_trust_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create Trust With Rgw Already Used As Primary (Negative)
###################################################################################################################################
        [Documentation]                *Create Trust With Rgw Already Used As Primary (Negative)*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}

		${response}	                PCC.Ceph Primary Start Trust
			                   ...  masterAppID=${rgw_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Primary Download Trust File
###################################################################################################################################
        [Documentation]                *Primary Download Trust File*

        ${status_code}              PCC.Ceph Download Trust File
                               ...  id=${primary_trust_id}

                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create Remote Replica Using The Same PCC (Negative)
###################################################################################################################################
        [Documentation]                *Create Remote Replica Using The Same PCC (Negative)*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

		${response}	                PCC.Ceph Secondary End Trust
			                   ...  clusterID=${cluster_id}
			                   ...  id=${primary_trust_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Login To PCC Secondary
###################################################################################################################################

        ${status}        Login To PCC Secondary  ${pcc_setup}


###################################################################################################################################
Create Trust Using Bad App Side Trust File (Negative)
###################################################################################################################################
        [Documentation]                *Create Trust Using Bad App Side Trust File (Negative)*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME_SECONDARY}
			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

		${response}	                PCC.Ceph Primary End Trust
			                   ...  masterAppID=${rgw_id}
			                   ...  id=${primary_trust_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Secondary End Trust Creation
###################################################################################################################################
        [Documentation]                *Secondary End Trust Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

        ${cluster_id}               PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}

		${response}	                PCC.Ceph Secondary End Trust
			                   ...  clusterID=${cluster_id}
			                   ...  id=${primary_trust_id}

        ${result}                   Get Result    ${response}
        ${data}                     Get From Dictionary     ${result}   Data
        ${secondary_trust_id}       Get From Dictionary     ${data}     id
                                    Set Suite Variable   ${secondary_trust_id}
                                    Log To Console      ${secondary_trust_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Secondary Edit Trust
###################################################################################################################################
        [Documentation]                *Secondary Edit Trust*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME_SECONDARY}
			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

		${response}	                PCC.Ceph Edit Trust
			                   ...  id=${secondary_trust_id}
			                   ...  slaveAppID=${rgw_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${result}                   PCC.Ceph Wait Until Trust Established
                               ...  id=${secondary_trust_id}
                                    Should Be Equal As Strings      ${result}  OK

###################################################################################################################################
Login to PCC Primary
###################################################################################################################################

        ${status}        Login To PCC    ${pcc_setup}

###################################################################################################################################
Wait Until Trust Established - Primary
###################################################################################################################################

        ${result}                   PCC.Ceph Wait Until Trust Established
                               ...  id=${primary_trust_id}
                                    Should Be Equal As Strings      ${result}  OK

###################################################################################################################################
Create Primary Rgw Configuration File
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${accessKey}                       PCC.Ceph Get Rgw Access Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}

        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}

        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=0.0.0.0
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Create Rgw Bucket - Primary
###################################################################################################################################
    [Documentation]                        *Create Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Make Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
List Rgw Bucket - Primary
###################################################################################################################################
    [Documentation]                        *List Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
ADD File - Primary
###################################################################################################################################
    [Documentation]                        *ADD File - Primary*

        ${status}                          PCC.Ceph Rgw Upload File To Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                           Should Be Equal As Strings      ${status}    OK

                                           Sleep  1m

###################################################################################################################################
Login to PCC Secondary
###################################################################################################################################

        ${status}        Login To PCC Secondary    ${pcc_setup}

###################################################################################################################################
Wait Until Secondary Replica Status: Caught up
###################################################################################################################################

        ${result}                   PCC.Ceph Wait Until Replica Status Caught Up
                               ...  id=${secondary_trust_id}
                                    Should Be Equal As Strings      ${result}  OK

###################################################################################################################################
Login to PCC Primary
###################################################################################################################################

        ${status}        Login To PCC    ${pcc_setup}


###################################################################################################################################
Create Secondary Rgw Configuration File
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${accessKey}                       PCC.Ceph Get Rgw Access Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}

        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}


        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=${SERVER_1_HOST_IP_SECONDARY}
                                      ...  port=${CEPH_RGW_PORT_SECONDARY}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
List Rgw Bucket - Secondary
###################################################################################################################################
    [Documentation]                        *List Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK
###################################################################################################################################
List Rgw Objects inside Bucket - Secondary
###################################################################################################################################
    [Documentation]                        *List Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Objects inside Buckets
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create Primary Rgw Configuration File
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${accessKey}                       PCC.Ceph Get Rgw Access Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
				                           Set Suite Variable   ${accessKey}

        ${secretKey}                       PCC.Ceph Get Rgw Secret Key
                                      ...  name=${CEPH_RGW_NAME}
				                      ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
				                           Set Suite Variable   ${secretKey}

        ${status}                          PCC.Ceph Rgw Configure
                                      ...  accessKey=${accessKey}
                                      ...  secretKey=${secretKey}
                                      ...  pcc=${SERVER_1_HOST_IP}
                                      ...  targetNodeIp=0.0.0.0
                                      ...  port=${CEPH_RGW_PORT}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete A File From Rgw Bucket - Primary
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
Delete Rgw Bucket - Primary
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

###################################################################################################################################
Primary tear-down
###################################################################################################################################

        ${response}                 PCC.Ceph Trust Delete
                               ...  id=${primary_trust_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${result}                   PCC.Ceph Wait Until Trust Deleted
                               ...  id=${primary_trust_id}
                                    Should Be Equal As Strings      ${result}  OK


###################################################################################################################################
Login To PCC Secondary
###################################################################################################################################

        ${status}        Login To PCC Secondary   ${pcc_setup}

###################################################################################################################################
Secondary Delete Trust
###################################################################################################################################

        ${response}                 PCC.Ceph Trust Delete
                               ...  id=${secondary_trust_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Secondary Started Trust Creation
###################################################################################################################################
        [Documentation]                *Secondary Started Trust Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

        ${secondary_cluster_id}     PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}

        ${rgw_id_secondary}         PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME_SECONDARY}
			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
			                        Set Suite Variable   ${rgw_id_secondary}

		${response}	                PCC.Ceph Secondary Start Trust
			                   ...  clusterID=${secondary_cluster_id}

        ${result}                   Get Result    ${response}
        ${data}                     Get From Dictionary     ${result}   Data
        ${secondary_trust_id}       Get From Dictionary     ${data}     id
                                    Set Suite Variable   ${secondary_trust_id}
                                    Log To Console      ${secondary_trust_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Secondary Download Trust File
###################################################################################################################################
        [Documentation]                *Secondary Download Trust File*

        ${status_code}              PCC.Ceph Download Trust File
                               ...  id=${secondary_trust_id}

                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Login To PCC Primary
###################################################################################################################################

        ${status}        Login To PCC    ${pcc_setup}

###################################################################################################################################
Primary End Trust Creation
###################################################################################################################################
        [Documentation]                *Primary End Trust Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}

		${response}	                PCC.Ceph Primary End Trust
			                   ...  masterAppID=${rgw_id}
			                   ...  id=${secondary_trust_id}

        ${result}                   Get Result    ${response}
        ${data}                     Get From Dictionary     ${result}   Data
        ${primary_trust_id}         Get From Dictionary     ${data}     id
                                    Set Suite Variable   ${primary_trust_id}
                                    Log To Console      ${primary_trust_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Primary Edit Trust
###################################################################################################################################
        [Documentation]                *Primary Edit Trust*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

		${response}	                PCC.Ceph Edit Trust
			                   ...  id=${primary_trust_id}
			                   ...  slaveAppID=${rgw_id_secondary}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${result}                   PCC.Ceph Wait Until Trust Established
                               ...  id=${primary_trust_id}
                                    Should Be Equal As Strings      ${result}  OK

###################################################################################################################################
Login To PCC Secondary
###################################################################################################################################

        ${status}        Login To PCC Secondary  ${pcc_setup}

###################################################################################################################################
Wait Until Trust Established - Secondary
###################################################################################################################################

        ${result}                   PCC.Ceph Wait Until Trust Established
                               ...  id=${secondary_trust_id}

###################################################################################################################################
Secondary tear-down
###################################################################################################################################

        ${response}                 PCC.Ceph Trust Delete
                               ...  id=${secondary_trust_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${result}                   PCC.Ceph Wait Until Trust Deleted
                               ...  id=${secondary_trust_id}
                                    Should Be Equal As Strings      ${result}  OK

###################################################################################################################################
Login To PCC Primary
###################################################################################################################################

        ${status}        Login To PCC   ${pcc_setup}

###################################################################################################################################
Primary Delete Trust
###################################################################################################################################

        ${response}                 PCC.Ceph Trust Delete
                               ...  id=${primary_trust_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200