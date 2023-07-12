*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***
###################################################################################################################################
Login To S3-Manager
###################################################################################################################################

                                    Load Organization Data      ${s3_setup}

        ${status}                   Login To S3-Manager     testdata_key=${s3_setup}
                                    Should Be Equal     ${status}  OK


        ${response}                 S3.Get PCC Certificates
                                    ...  pccId=${8}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${response}                 S3.Get PCC Ceph Clusters
                                    ...  pccId=${8}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${response}                 S3.Get PCC CephLB Nodes
                                    ...  pccId=${8}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${response}                 S3.Get PCC RGW Available Nodes
                                    ...  pccId=${8}
                                    ...  clusterID=${1}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${rgw_id}                   S3.Get Attachable Endpoint Id By Name
                                    ...  pccId=${8}
                                    ...  name=rgw-attach


        ${response}                 S3.Attach Endpoint
                                    ...  pccId=${8}
                                    ...  name=endpoint-attach
                                    ...  description=attached endpoint
                                    ...  rgwID=${rgw_id}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

                                    sleep  10s

        ${response}                 S3.Get Endpoints

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${id}                       S3.Get Endpoint Id By Name
                                    ...  name=endpoint-attach

        ${response}                 S3.Update Endpoint
                                    ...  id=${id}
                                    ...  name=endpoint-attach-updt
                                    ...  description=attached endpoint

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${response}                 S3.Delete Endpoint
                                    ...  id=${id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${response}                 S3.Create Endpoint
                                    ...  pccId=${8}
                                    ...  name=test-endpoint
                                    ...  description=test create endpoint
                                    ...  clusterID=${1}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200