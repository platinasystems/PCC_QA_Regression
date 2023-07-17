*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***
###################################################################################################################################
Login To S3-Manager
###################################################################################################################################

                                    Load PCC Test Data      ${s3_setup}

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

###################################################################################################################################
Get All PCC Instances
###################################################################################################################################

        ${response}                 S3.Get PCC Instances

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Get PCC Instance
###################################################################################################################################

        ${pcc_id}                   S3.Get PCC Instance Id By Name
                                    ...  name=${PCC_NAME}

                                    Set Suite Variable      ${pcc_id}

###################################################################################################################################
Update PCC Instance
###################################################################################################################################
        ${response}                 S3.Update PCC Instance
                                    ...  id=${pcc_id}
                                    ...  name=pcc-name-update
                                    ...  username=admin
                                    ...  pwd=admin
                                    ...  address=172.17.2.221
                                    ...  port=${9999}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Delete PCC Instance
###################################################################################################################################

        ${response}                 S3.Delete PCC Instance
                                    ...  id=${pcc_id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200