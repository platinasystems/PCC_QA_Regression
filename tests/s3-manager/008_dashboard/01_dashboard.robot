*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***
###################################################################################################################################
Login To S3-Manager
###################################################################################################################################
                                    Load Endpoint Test Data    ${s3_setup}
                                    Load Ceph Cluster Data      ${s3_setup}
                                    Load Ceph Rgw Data      ${s3_setup}

        ${status}                   Login To S3-Manager     testdata_key=${s3_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Get Organization Statistics
###################################################################################################################################

        ${response}                 S3.Get Organization Statistics
                                    ...  organizationId=1

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Get Endpoint Statistics
###################################################################################################################################
        ${endpoint_id}              S3.Get Endpoint Id By Name
                                    ...  name=${ATTACHED_ENDPOINT_NAME}
                                    Set Suite Variable      ${endpoint_id}

        ${response}                 S3.Get Endpoint Statistics
                                    ...  endpointId=${endpoint_id}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Get Endpoint Prometheus Statistics (radosgw_usage_total_objects)
###################################################################################################################################
         ${status}                 Login To PCC        testdata_key=${s3_setup}
                                   Should Be Equal     ${status}  OK

         ${rgw_id}                  PCC.Ceph Get Rgw Id
                                    ...  name=${CEPH_RGW_NAME}
			                        ...  ceph_cluster_name=${CEPH_CLUSTER_NAME}
			                        Log To Console      ${rgw_id}

         ${status}                  Login To S3-Manager     testdata_key=${s3_setup}
                                    Should Be Equal     ${status}  OK

         ${response}                 S3.Get Endpoint Prometheus Statistics
                                    ...  endpointId=${endpoint_id}
                                    ...  rgwId=${rgw_id}
                                    ...  stat_name=radosgw_usage_total_objects

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200