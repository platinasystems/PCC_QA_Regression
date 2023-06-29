*** Settings ***
Resource    s3_resources.robot

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

        ${status}                   Login To S3-Manager
                                    Should Be Equal     ${status}  OK


        ${response}                 S3.Get PCC Instances

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${response}                 S3.Create PCC Instance
                                    ...  name=pcc221
                                    ...  username=admin
                                    ...  pwd=admin
                                    ...  address=172.17.2.221
                                    ...  port=${9999}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${pcc_id}                   S3.Get PCC Instance Id By Name
                                    ...  name=pcc221

        ${response}                 S3.Update PCC Instance
                                    ...  id=${pcc_id}
                                    ...  name=pcc221-rename
                                    ...  username=admin
                                    ...  pwd=admin
                                    ...  address=172.17.2.221
                                    ...  port=${9999}

        ${status_code}              Get Response Status Code        ${response}
        ${data}                     Get Response Data        ${response}
                                    Log To Console      ${data}
                                    Should Be Equal As Strings      ${status_code}  200

        ${response}                 S3.Delete PCC Instance
                                    ...  id=${pcc_id}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200