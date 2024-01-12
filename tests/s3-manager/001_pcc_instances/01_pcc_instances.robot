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
Create PCC Instance Without Name (NEGATIVE)
###################################################################################################################################

        ${response}                 S3.Create PCC Instance
                                    ...  username=${PCC_USERNAME}
                                    ...  pwd=${PCC_PASSWORD}
                                    ...  address=${PCC_ADDRESS}
                                    ...  port=${PCC_PORT}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create PCC Instance Without Username (NEGATIVE)
###################################################################################################################################

        ${response}                 S3.Create PCC Instance
                                    ...  name=${PCC_NAME}
                                    ...  pwd=${PCC_PASSWORD}
                                    ...  address=${PCC_ADDRESS}
                                    ...  port=${PCC_PORT}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create PCC Instance Without Password (NEGATIVE)
###################################################################################################################################

        ${response}                 S3.Create PCC Instance
                                    ...  name=${PCC_NAME}
                                    ...  username=${PCC_USERNAME}
                                    ...  address=${PCC_ADDRESS}
                                    ...  port=${PCC_PORT}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create PCC Instance Without Address (NEGATIVE)
###################################################################################################################################

        ${response}                 S3.Create PCC Instance
                                    ...  name=${PCC_NAME}
                                    ...  username=${PCC_USERNAME}
                                    ...  pwd=${PCC_PASSWORD}
                                    ...  port=${PCC_PORT}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

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
Create PCC Instance With Same Name (NEGATIVE)
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
                                    Should Not Be Equal As Strings      ${status_code}  200

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
Update PCC Instance Without Name (NEGATIVE)
###################################################################################################################################

        ${response}                 S3.Update PCC Instance
                                    ...  id=${pcc_id}
                                    ...  username=${PCC_USERNAME}
                                    ...  pwd=${PCC_PASSWORD}
                                    ...  address=${PCC_ADDRESS}
                                    ...  port=${PCC_PORT}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Update PCC Instance Without Username (NEGATIVE)
###################################################################################################################################

        ${response}                 S3.Update PCC Instance
                                    ...  id=${pcc_id}
                                    ...  name=${PCC_NAME}
                                    ...  pwd=${PCC_PASSWORD}
                                    ...  address=${PCC_ADDRESS}
                                    ...  port=${PCC_PORT}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Update PCC Instance Without Password (NEGATIVE)
###################################################################################################################################

        ${response}                 S3.Update PCC Instance
                                    ...  id=${pcc_id}
                                    ...  name=${PCC_NAME}
                                    ...  username=${PCC_USERNAME}
                                    ...  address=${PCC_ADDRESS}
                                    ...  port=${PCC_PORT}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Update PCC Instance Without Address (NEGATIVE)
###################################################################################################################################

        ${response}                 S3.Update PCC Instance
                                    ...  id=${pcc_id}
                                    ...  name=${PCC_NAME}
                                    ...  username=${PCC_USERNAME}
                                    ...  pwd=${PCC_PASSWORD}
                                    ...  port=${PCC_PORT}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Update PCC Instance With Wrong Port (NEGATIVE)
###################################################################################################################################
        ${response}                 S3.Update PCC Instance
                                    ...  id=${pcc_id}
                                    ...  name=${PCC_NAME}
                                    ...  username=${PCC_USERNAME}
                                    ...  pwd=${PCC_PASSWORD}
                                    ...  address=${PCC_ADDRESS}
                                    ...  port=${1111}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Update PCC Instance
###################################################################################################################################
        ${response}                 S3.Update PCC Instance
                                    ...  id=${pcc_id}
                                    ...  name=pcc-name-update
                                    ...  username=${PCC_USERNAME}
                                    ...  pwd=${PCC_PASSWORD}
                                    ...  address=${PCC_ADDRESS}
                                    ...  port=${PCC_PORT}

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