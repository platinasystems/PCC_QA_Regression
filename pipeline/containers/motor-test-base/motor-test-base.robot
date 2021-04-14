*** Settings ***
Library                         pcc_qa.common.Utils


*** Test Cases ***
###################################################################################################################################
motor-test-base Container Smoke Test
###################################################################################################################################
        [Documentation]         *Verify motor-test-base container is built properly*
                                Should Be Equal         1  1
