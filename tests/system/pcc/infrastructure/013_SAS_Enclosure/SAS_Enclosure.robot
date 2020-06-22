*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK
        
        
                                    #Load Clusterhead 1 Test Data    ${pcc_setup}
                                    #Load Clusterhead 2 Test Data    ${pcc_setup}
                                    #Load Server 1 Test Data    ${pcc_setup}
                                    #Load Server 2 Test Data    ${pcc_setup}

        
                                    
####################################################################################################################################
#Get SAS Enclosures
####################################################################################################################################
#    [Documentation]                 *Get SAS Enclosures*
#                                     ...  Keywords:
#                                     ...  PCC.Get SAS Enclosures
#    
#
#        ${response}                 PCC.Get SAS Enclosures
#                               
#                                    ...  auth_data=${PCC_CONN}
#                                    ...  setup_ip=${PCC_HOST_IP}
#                                    ...  user=${PCC_LINUX_USER}
#                                    ...  password=${PCC_LINUX_PASSWORD}
#                             
#                                    Log To Console    ${response}
#                                    ${status}    Get From Dictionary    ${response}    status
#                                    ${message}    Get From Dictionary    ${response}    message
#                                    Log to Console    ${message}
#                                    Should Be Equal As Strings    ${status}    200
#                                    ${data}    Get From Dictionary    ${response}    Data
#                                    Should Not Be Equal As Strings    None
                                    
####################################################################################################################################
#Edit SAS Enclosure
####################################################################################################################################
#    [Documentation]                 *Get SAS Enclosures*
#                                     ...  Keywords:
#                                     ...  PCC.Update SAS Enclosure
#
#
#        ${response}                 PCC.Update SAS Enclosure
#
#                                    ...  auth_data=${PCC_CONN}
#                                    ...  setup_ip=${PCC_HOST_IP}
#                                    ...  user=${PCC_LINUX_USER}
#                                    ...  password=${PCC_LINUX_PASSWORD}
#                                    ...  led_status=false
#                                    ...  slot_name=/dev/sg8
#
#                                    Log To Console    ${response}
#                                    ${status}    Get From Dictionary    ${response}    status
#                                    ${message}    Get From Dictionary    ${response}    message
#                                    Log to Console    ${message}
#                                    Should Be Equal As Strings    ${status}    200