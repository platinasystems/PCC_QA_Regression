*** Settings ***
Library                         pcc_qa.common.Utils
Library                         pcc_qa.common.Result
Library                         pcc_qa.common.TestData
Library                         pcc_qa.common.LinuxUtils
Library                         pcc_qa.common.DockerUtils
Library                         pcc_qa.s3.Login
Library                         pcc_qa.s3.PccInstance
Library                         pcc_qa.s3.Organization
Library                         pcc_qa.s3.User
Library                         pcc_qa.s3.Endpoint
Library                         Collections

*** Keywords ***
###################################################################################################################################
Login To S3-Manager
###################################################################################################################################
    [Arguments]                 ${testdata_key}=None

        [Documentation]         *Login to S3-Manager* - obtain token
                                Log To Console          **** Login To S3-Manager ****

                                # Load Test Data sets Suite Variables used by all tests

#                                Load PCC Test Data      ${testdata_key}
#
#                                #Load Clusterhead 1 Test Data    ${pcc_server_key}.json
#                                # PCC.Login is defined in Login.py   it takes PCC_URL from defined Robot variable

        ${S3_CONN}             S3.Login               url=https://172.17.2.221:59999   username=admin    password=admin

                                # Log To Console          CH-NAME=${CLUSTERHEAD_1_NAME}
                                # Using SESSION and TOKEN for all subsequent REST API calls

                                Set Suite Variable      ${S3_CONN}
        ${login_success}        Set Variable If  "${S3_CONN}" == "None"  ERROR  OK
    [Return]                    ${login_success}
