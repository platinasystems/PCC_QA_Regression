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
Primary Download Trust File
###################################################################################################################################
        [Documentation]                *Primary Download Trust File*

        ${status_code}              PCC.Ceph Download Trust File
                               ...  id=${primary_trust_id}

                                    Should Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Login To PCC Secondary
###################################################################################################################################

        ${status}        Login To PCC Secondary  ${pcc_setup}


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






