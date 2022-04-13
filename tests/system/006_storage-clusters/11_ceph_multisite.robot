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
                        Load Server 2 Secondary Test Data    ${pcc_setup}


###################################################################################################################################
Primary Started Trust Creation
###################################################################################################################################
        [Documentation]                *Primary Started Trust Creation*

        ${status}                   Login To PCC    ${pcc_setup}

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

        ${status_code}              PCC.Ceph Download Trust File
                               ...  id=${primary_trust_id}
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
Create Trust Using Bad App Side Trust File (Negative)
###################################################################################################################################
        [Documentation]                *Create Trust Using Bad App Side Trust File (Negative)*

        ${status}                   Login To PCC Secondary  ${pcc_setup}

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
Wait Until Trust Established - Primary
###################################################################################################################################

        ${status}                   Login To PCC    ${pcc_setup}

        ${result}                   PCC.Ceph Wait Until Trust Established
                               ...  id=${primary_trust_id}
                                    Should Be Equal As Strings      ${result}  OK


###################################################################################################################################
Change location on primary side with replica established (Negative)
###################################################################################################################################

        [Documentation]    *Change location on primary side with replica established (Negative)*

        ${response}    PCC.Create Scope
                       ...  type=region
                       ...  scope_name=region-1
                       ...  description=region-description

        ${node_id}    PCC.Get Node Id
                      ...  Name=${SERVER_1_NAME}
                      Log To Console    ${node_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=region-1

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

        ${region_id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${region_id}

        ${zone_id}    PCC.Get Scope Id
                        ...  scope_name=Default zone
                        ...  parentID=${region_id}
                        Log To Console    ${zone_id}

        ${site_id}    PCC.Get Scope Id
                        ...  scope_name=Default site
                        ...  parentID=${zone_id}
                        Log To Console    ${site_id}

        ${rack_id}    PCC.Get Scope Id
                        ...  scope_name=Default rack
                        ...  parentID=${site_id}
                        Log To Console    ${rack_id}

        ${response}    PCC.Update Node
                       ...  Id=${node_id}
                       ...  Name=${SERVER_1_NAME}
                       ...  Host=${SERVER_1_HOST_IP}
                       ...  scopeId=${rack_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200

        ${response}    PCC.Delete Scope By id
                       ...  scopeId=${region_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Change location on secondary side with replica established (Negative)
###################################################################################################################################

        [Documentation]    *Change location on secondary side with replica established (Negative)*

        ${status}      Login To PCC Secondary   ${pcc_setup}

        ${response}    PCC.Create Scope
                       ...  type=region
                       ...  scope_name=region-1
                       ...  description=region-description

        ${node_id}    PCC.Get Node Id
                      ...  Name=${SERVER_1_NAME_SECONDARY}
                      Log To Console    ${node_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

        ${status}      PCC.Check Scope Creation From PCC
                       ...  scope_name=region-1

                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK

        ${region_id}    PCC.Get Scope Id
                        ...  scope_name=region-1
                        Log To Console    ${region_id}

        ${zone_id}    PCC.Get Scope Id
                        ...  scope_name=Default zone
                        ...  parentID=${region_id}
                        Log To Console    ${zone_id}

        ${site_id}    PCC.Get Scope Id
                        ...  scope_name=Default site
                        ...  parentID=${zone_id}
                        Log To Console    ${site_id}

        ${rack_id}    PCC.Get Scope Id
                        ...  scope_name=Default rack
                        ...  parentID=${site_id}
                        Log To Console    ${rack_id}

        ${response}    PCC.Update Node
                       ...  Id=${node_id}
                       ...  Name=${SERVER_1_NAME_SECONDARY}
                       ...  Host=${SERVER_1_HOST_IP_SECONDARY}
                       ...  scopeId=${rack_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Not Be Equal As Strings    ${status}    200

        ${response}    PCC.Delete Scope By id
                       ...  scopeId=${region_id}

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Create Primary Rgw Configuration File
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*

        ${status}                          Login To PCC    ${pcc_setup}

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
Wait Until Secondary Replica Status: Caught up
###################################################################################################################################

        ${status}                   Login To PCC Secondary    ${pcc_setup}


        ${result}                   PCC.Ceph Wait Until Replica Status Caught Up
                               ...  id=${secondary_trust_id}
                                    Should Be Equal As Strings      ${result}  OK

###################################################################################################################################
Create Secondary Rgw Configuration File
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File*

        ${status}                          Login To PCC    ${pcc_setup}

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
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete Rgw Bucket - Primary
###################################################################################################################################
      [Documentation]                      *Delete Rgw Bucket*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK
#####################################################################################################################################
Ceph Primary Rados Gateway Delete While Using it As Replica (Negative)
#####################################################################################################################################

    [Documentation]                 *Ceph Primary Rados Gateway Delete While Using it As Replica (Negative)*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Delete Rgw
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

#####################################################################################################################################
Ceph Secondary Rados Gateway Delete While Using it As Replica (Negative)
#####################################################################################################################################

    [Documentation]                 *Ceph Secondary Rados Gateway Delete While Using it As Replica (Negative)*

        ${status}                   Login To PCC Secondary   ${pcc_setup}

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Ceph Delete Rgw
                               ...  name=${CEPH_RGW_NAME_SECONDARY}
			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Primary tear-down
###################################################################################################################################

        ${status}                   Login To PCC    ${pcc_setup}

        ${response}                 PCC.Ceph Trust Delete
                               ...  id=${primary_trust_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${result}                   PCC.Ceph Wait Until Trust Deleted
                               ...  id=${primary_trust_id}
                                    Should Be Equal As Strings      ${result}  OK

###################################################################################################################################
Secondary Delete Trust
###################################################################################################################################

        ${status}                   Login To PCC Secondary   ${pcc_setup}

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

        ${status_code}              PCC.Ceph Download Trust File
                               ...  id=${secondary_trust_id}

                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Primary End Trust Creation
###################################################################################################################################
        [Documentation]                *Primary End Trust Creation*

        ${status}                   Login To PCC    ${pcc_setup}

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
Wait Until Trust Established - Secondary
###################################################################################################################################

        ${status}                   Login To PCC Secondary  ${pcc_setup}

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
Primary Delete Trust
###################################################################################################################################

        ${status}                   Login To PCC   ${pcc_setup}

        ${response}                 PCC.Ceph Trust Delete
                               ...  id=${primary_trust_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
						Sleep   1m

#####################################################################################################################################
Ceph Rados Update Nodes And Certficate for LB
#####################################################################################################################################
     [Documentation]                *Ceph Rados Update Nodes And Certficate for LB*

	    ${status}                   Login To PCC Secondary  ${pcc_setup}

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME_SECONDARY}
			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}

        ${response}                 PCC.Ceph Update Rgw
                               ...  ID=${rgw_id}
                               ...  name=${CEPH_RGW_NAME_SECONDARY}
                               ...  poolName=${CEPH_RGW_POOLNAME_SECONDARY}
                               ...  targetNodes=["sv46","sv51"]
                               ...  port=${CEPH_RGW_PORT_SECONDARY}
                               ...  certificateName=${CEPH_RGW_CERT_NAME_LB_SECONDARY}
                               ...  certificateUrl=${CEPH_RGW_CERT_URL_LB_SECONDARY}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Ready
                               ...  name=${CEPH_RGW_NAME_SECONDARY}
			                   ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
                                    Should Be Equal As Strings      ${status}    OK


#####################################################################################################################################
Ceph Load Balancer create on Rgw with 2 nodes
#####################################################################################################################################
     [Documentation]                *Ceph Load Balancer create on Rgw with 2 nodes*


        ${app_id}              PCC.Get App Id from Policies
                               ...  Name=loadbalancer-ceph
                               Log To Console    ${app_id}

        ${rgw_id_secondary}    PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME_SECONDARY}
                               ...  ceph_cluster_name=${CEPH_CLUSTER_NAME_SECONDARY}
                               Set Suite Variable   ${rgw_id_secondary}

        ${scope1_id}           PCC.Get Scope Id
                               ...  scope_name=Default region

        ${response}            PCC.Create Policy
                               ...  appId=${app_id}
                               ...  description=test-ceph-lb
                               ...  scopeIds=[${scope1_id}]
                               ...  inputs=[{"name": "lb_name","value": "testcephlb"},{"name": "lb_balance_method","value": "roundrobin"},{"name": "lb_frontend","value": "0.0.0.0:9898"},{"name": "lb_backends","value": "${rgw_id_secondary}"}]

                               Log To Console    ${response}
                               ${result}    Get Result    ${response}
                               ${status}    Get From Dictionary    ${result}    status
                               ${message}    Get From Dictionary    ${result}    message
                               Log to Console    ${message}
                               Should Be Equal As Strings    ${status}    200

        ${response}            PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${SERVER_2_NAME_SECONDARY}"]
                               ...  roles=["Ceph Load Balancer"]

                               Should Be Equal As Strings      ${response}  OK

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME_SECONDARY}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK


###################################################################################################################################
Secondary Started Trust Creation (LB)
###################################################################################################################################
        [Documentation]                *Secondary Started Trust Creation with LB*

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

        ${status_code}              PCC.Ceph Download Trust File
                               ...  id=${secondary_trust_id}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Primary End Trust Creation (LB)
###################################################################################################################################
        [Documentation]                *Primary End Trust Creation (LB)*

        ${status}                   Login To PCC    ${pcc_setup}

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
Primary Edit Trust (LB)
###################################################################################################################################
        [Documentation]                *Primary Edit Trust (LB)*

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
Wait Until Trust Established - Secondary (LB)
###################################################################################################################################

        ${status}                   Login To PCC Secondary  ${pcc_setup}

        ${result}                   PCC.Ceph Wait Until Trust Established
                               ...  id=${secondary_trust_id}


###################################################################################################################################
Create Primary Rgw Configuration File (LB)
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File (LB)*

        ${status}                          Login To PCC    ${pcc_setup}

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
Create Rgw Bucket - Primary (LB)
###################################################################################################################################
    [Documentation]                        *Create Rgw Bucket (LB)*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Make Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
List Rgw Bucket - Primary (LB)
###################################################################################################################################
    [Documentation]                        *List Rgw Bucket (LB)*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
ADD File - Primary (LB)
###################################################################################################################################
    [Documentation]                        *ADD File - Primary (LB)*

        ${status}                          PCC.Ceph Rgw Upload File To Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}
                                           Should Be Equal As Strings      ${status}    OK

                                           Sleep  1m

###################################################################################################################################
Wait Until Secondary Replica Status: Caught up (LB)
###################################################################################################################################

        ${status}                   Login To PCC Secondary    ${pcc_setup}


        ${result}                   PCC.Ceph Wait Until Replica Status Caught Up
                               ...  id=${secondary_trust_id}
                                    Should Be Equal As Strings      ${result}  OK

###################################################################################################################################
Create Secondary Rgw Configuration File (LB)
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File (LB)*

        ${status}                          Login To PCC    ${pcc_setup}

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
                                      ...  targetNodeIp=${SERVER_2_HOST_IP_SECONDARY}
                                      ...  port=9898

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
List Rgw Bucket - Secondary (LB)
###################################################################################################################################
    [Documentation]                        *List Rgw Bucket (LB)*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Buckets
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK
###################################################################################################################################
List Rgw Objects inside Bucket - Secondary (LB)
###################################################################################################################################
    [Documentation]                        *List Rgw Bucket (LB)*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw List Objects inside Buckets
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create Primary Rgw Configuration File (LB)
###################################################################################################################################
    [Documentation]                        *Create Rgw Configuration File (LB)*

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
Delete A File From Rgw Bucket - Primary (LB)
####################################################################################################################################
    [Documentation]                        *Delete a file from Rgw Bucket (LB)*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete File From Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Delete Rgw Bucket - Primary (LB)
###################################################################################################################################
      [Documentation]                      *Delete Rgw Bucket (LB)*

        ${status}                          PCC.Ceph Get Pcc Status
                                      ...  name=${CEPH_CLUSTER_NAME}
                                           Should Be Equal As Strings      ${status}    OK

        ${status}                          PCC.Ceph Rgw Delete Bucket
                                      ...  pcc=${SERVER_1_HOST_IP}

                                           Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Primary tear-down (LB)
###################################################################################################################################

        ${status}                   Login To PCC    ${pcc_setup}

        ${response}                 PCC.Ceph Trust Delete
                               ...  id=${primary_trust_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${result}                   PCC.Ceph Wait Until Trust Deleted
                               ...  id=${primary_trust_id}
                                    Should Be Equal As Strings      ${result}  OK

###################################################################################################################################
Secondary Delete Trust (LB)
###################################################################################################################################

        ${status}                   Login To PCC Secondary   ${pcc_setup}

        ${response}                 PCC.Ceph Trust Delete
                               ...  id=${secondary_trust_id}

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Removing Ceph Load balancer
###################################################################################################################################
    [Documentation]                 *Removing Ceph Load balancer*

        ${response}                 PCC.Delete and Verify Roles On Nodes
                               ...  nodes=["${SERVER_2_NAME_SECONDARY}"]
                               ...  roles=["Ceph Load Balancer"]

                                    Should Be Equal As Strings      ${response}  OK


        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_2_NAME_SECONDARY}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
#####################################################################################################################################
Delete Primary Ceph Rados Gateway Delete
#####################################################################################################################################

    [Documentation]                 *Ceph Rados Gateway Delete*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...    name=${CEPH_RGW_NAME}
		                       ...  ceph_cluster_name=ceph-pvt
		                            Pass Execution If    ${rgw_id} is ${None}    There is no RGW for deletion

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
				                    Sleep    1 minutes
####################################################################################################################################
Delete Seondary Ceph Rados Gateway
#####################################################################################################################################

    [Documentation]                 *Ceph Rados Gateway Delete*

	    ${status}                   Login To PCC Secondary  ${pcc_setup}

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...    name=${CEPH_RGW_NAME_SECONDARY}
		                       ...  ceph_cluster_name=ceph-pvt
		                            Pass Execution If    ${rgw_id} is ${None}    There is no RGW for deletion

        ${response}                 PCC.Ceph Delete Rgw
                               ...  name=${CEPH_RGW_NAME_SECONDARY}
			                   ...  ceph_cluster_name=ceph-pvt

        ${status_code}              Get Response Status Code        ${response}
        ${message}                  Get Response Message        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Rgw Deleted
                               ...  name=${CEPH_RGW_NAME_SECONDARY}
			                   ...  ceph_cluster_name=ceph-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${backend_status}           PCC.Ceph Rgw Verify BE Deletion
                               ...  targetNodeIp=['${SERVER_1_HOST_IP}']
                                    Should Be Equal As Strings      ${backend_status}    OK
				                    Sleep    1 minutes
