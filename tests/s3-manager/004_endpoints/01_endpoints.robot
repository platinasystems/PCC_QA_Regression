*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***
###################################################################################################################################
Login To S3-Manager
###################################################################################################################################
                                    Load PCC Test Data      ${s3_setup}
                                    Load Ceph Rgw Data      ${s3_setup}
                                    Load Endpoint Test Data    ${s3_setup}
                                    Load Ceph Cluster Data      ${s3_setup}
                                    Load Organization Data      ${s3_setup}

        ${status}                   Login To S3-Manager     testdata_key=${s3_setup}
                                    Should Be Equal     ${status}  OK


###################################################################################################################################
Create PCC Instance
###################################################################################################################################

        ${response}                 S3.Create PCC Instance
                                    ...  name=${PCC_NAME}
                                    ...  username=${PCC_USERNAME}
                                    ...  pwd=${PCC_PASSWORD}
                                    ...  address=${PCC_ADDRESS}
                                    ...  port=${PCC_PORT}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200


####################################################################################################################################
#Attach Endpoint Without Name (NEGATIVE)
####################################################################################################################################
#
#        ${pcc_id}                   S3.Get PCC Instance Id By Name
#                                    ...  name=${PCC_NAME}
#
#        ${rgw_id}                   S3.Get Attachable Endpoint Id By Name
#                                    ...  pccId=${pcc_id}
#                                    ...  name=${CEPH_RGW_NAME}
#
#        ${customers}                Create List     ${1}
#
#        ${response}                 S3.Attach Endpoint
#                                    ...  pccId=${pcc_id}
#                                    ...  description=attached endpoint
#                                    ...  rgwID=${rgw_id}
#                                    ...  customers=${customers}
#
#        ${status_code}              Get Response Status Code        ${response}
#        ${data}                     Get Response Data        ${response}
#                                    Log To Console      ${data}
#                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Attach Endpoint Without Organizations (NEGATIVE)
###################################################################################################################################

        ${pcc_id}                   S3.Get PCC Instance Id By Name
                                    ...  name=${PCC_NAME}

        ${rgw_id}                   S3.Get Attachable Endpoint Id By Name
                                    ...  pccId=${pcc_id}
                                    ...  name=${CEPH_RGW_NAME}

        ${response}                 S3.Attach Endpoint
                                    ...  pccId=${pcc_id}
                                    ...  name=${ATTACHED_ENDPOINT_NAME}
                                    ...  description=attached endpoint
                                    ...  rgwID=${rgw_id}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Attach Endpoint Without PCC Instance (NEGATIVE)
###################################################################################################################################

        ${pcc_id}                   S3.Get PCC Instance Id By Name
                                    ...  name=${PCC_NAME}

        ${rgw_id}                   S3.Get Attachable Endpoint Id By Name
                                    ...  pccId=${pcc_id}
                                    ...  name=${CEPH_RGW_NAME}

        ${customers}                Create List     ${1}

        ${response}                 S3.Attach Endpoint
                                    ...  pccId=${0}
                                    ...  name=${ATTACHED_ENDPOINT_NAME}
                                    ...  description=attached endpoint
                                    ...  rgwID=${rgw_id}
                                    ...  customers=${customers}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Attach Endpoint Without Endpoint Attachable (NEGATIVE)
###################################################################################################################################

        ${pcc_id}                   S3.Get PCC Instance Id By Name
                                    ...  name=${PCC_NAME}

        ${rgw_id}                   S3.Get Attachable Endpoint Id By Name
                                    ...  pccId=${pcc_id}
                                    ...  name=${CEPH_RGW_NAME}

        ${customers}                Create List     ${1}

        ${response}                 S3.Attach Endpoint
                                    ...  pccId=${pcc_id}
                                    ...  name=${ATTACHED_ENDPOINT_NAME}
                                    ...  description=attached endpoint
                                    ...  customers=${customers}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Attach Endpoint
###################################################################################################################################

        ${pcc_id}                   S3.Get PCC Instance Id By Name
                                    ...  name=${PCC_NAME}

        ${rgw_id}                   S3.Get Attachable Endpoint Id By Name
                                    ...  pccId=${pcc_id}
                                    ...  name=${CEPH_RGW_NAME}

        ${customers}                Create List     ${1}

        ${response}                 S3.Attach Endpoint
                                    ...  pccId=${pcc_id}
                                    ...  name=${ATTACHED_ENDPOINT_NAME}
                                    ...  description=attached endpoint
                                    ...  rgwID=${rgw_id}
                                    ...  customers=${customers}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   S3.Wait Until Endpoint Ready
                                    ...  name=${ATTACHED_ENDPOINT_NAME}
                                    Should Be Equal As Strings      ${status}  OK
###################################################################################################################################
Get All Endpoint
###################################################################################################################################

        ${response}                 S3.Get Endpoints

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Get Endpoint Id
###################################################################################################################################

        ${endpoint_id}              S3.Get Endpoint Id By Name
                                    ...  name=${ATTACHED_ENDPOINT_NAME}

                                    Set Suite Variable      ${endpoint_id}
###################################################################################################################################
Update Endpoint fields (Name/Description)
###################################################################################################################################
        ${customers}                Create List     ${1}

        ${response}                 S3.Update Endpoint
                                    ...  id=${endpoint_id}
                                    ...  name=endpoint-attach-updt
                                    ...  description=attached endpoint
                                    ...  customers=${customers}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Set Old Endpoint Name
###################################################################################################################################
        ${customers}                Create List     ${1}

        ${response}                 S3.Update Endpoint
                                    ...  id=${endpoint_id}
                                    ...  name=${ATTACHED_ENDPOINT_NAME}
                                    ...  description=attached endpoint
                                    ...  customers=${customers}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Add Custom Organization
###################################################################################################################################
        ${org_id}                   S3.Get Organization Id By Name
                                    ...  name=${ORG_NAME}

        ${customers}                Create List     ${1}    ${org_id}

        ${response}                 S3.Update Endpoint
                                    ...  id=${endpoint_id}
                                    ...  name=${ATTACHED_ENDPOINT_NAME}
                                    ...  description=attached endpoint
                                    ...  customers=${customers}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create Endpoint Without Name (NEGATIVE)
###################################################################################################################################

        ${pcc_id}                   S3.Get PCC Instance Id By Name
                                    ...  name=${PCC_NAME}

        ${cluster_id}               S3.Get PCC Ceph Cluster Id By Name
                                    ...  clusterName=${CEPH_CLUSTER_NAME}
                                    ...  pccId=${pcc_id}

        ${customers}                Create List     ${1}

        ${response}                 S3.Create Endpoint
                                    ...  pccId=${pcc_id}
                                    ...  description=test create endpoint
                                    ...  clusterID=${cluster_id}
                                    ...  customers=${customers}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create Endpoint Without Organizations (NEGATIVE)
###################################################################################################################################

        ${pcc_id}                   S3.Get PCC Instance Id By Name
                                    ...  name=${PCC_NAME}

        ${cluster_id}               S3.Get PCC Ceph Cluster Id By Name
                                    ...  clusterName=${CEPH_CLUSTER_NAME}
                                    ...  pccId=${pcc_id}

        ${customers}                Create List     ${1}

        ${response}                 S3.Create Endpoint
                                    ...  pccId=${pcc_id}
                                    ...  name=${ENDPOINT_NAME}
                                    ...  description=test create endpoint
                                    ...  clusterID=${cluster_id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create Endpoint Without PCC Instance (NEGATIVE)
###################################################################################################################################

        ${pcc_id}                   S3.Get PCC Instance Id By Name
                                    ...  name=${PCC_NAME}

        ${cluster_id}               S3.Get PCC Ceph Cluster Id By Name
                                    ...  clusterName=${CEPH_CLUSTER_NAME}
                                    ...  pccId=${pcc_id}

        ${customers}                Create List     ${1}

        ${response}                 S3.Create Endpoint
                                    ...  pccId=${0}
                                    ...  name=${ENDPOINT_NAME}
                                    ...  description=test create endpoint
                                    ...  clusterID=${cluster_id}
                                    ...  customers=${customers}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create Endpoint Without Cluster (NEGATIVE)
###################################################################################################################################

        ${pcc_id}                   S3.Get PCC Instance Id By Name
                                    ...  name=${PCC_NAME}

        ${cluster_id}               S3.Get PCC Ceph Cluster Id By Name
                                    ...  clusterName=${CEPH_CLUSTER_NAME}
                                    ...  pccId=${pcc_id}

        ${customers}                Create List     ${1}

        ${response}                 S3.Create Endpoint
                                    ...  pccId=${pcc_id}
                                    ...  name=${ENDPOINT_NAME}
                                    ...  description=test create endpoint
                                    ...  customers=${customers}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create Endpoint Without Advanced options
###################################################################################################################################

        ${pcc_id}                   S3.Get PCC Instance Id By Name
                                    ...  name=${PCC_NAME}

        ${cluster_id}               S3.Get PCC Ceph Cluster Id By Name
                                    ...  clusterName=${CEPH_CLUSTER_NAME}
                                    ...  pccId=${pcc_id}

        ${org_id}                   S3.Get Organization Id By Name
                                    ...  name=${ORG_NAME}

        ${customers}                Create List     ${1}    ${org_id}

        ${response}                 S3.Create Endpoint
                                    ...  pccId=${pcc_id}
                                    ...  name=${ENDPOINT_NAME}
                                    ...  description=test create endpoint
                                    ...  clusterID=${cluster_id}
                                    ...  customers=${customers}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   S3.Wait Until Endpoint Ready
                                    ...  name=${ENDPOINT_NAME}
                                    Should Be Equal As Strings      ${status}  OK
