*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Clusterhead 1 Test Data        testdata_key=${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK
                                    
###################################################################################################################################
Alert Create Template Rule 
###################################################################################################################################
    [Documentation]                 *Alert Create Template Rule*
                               ...  Keywords:
                               ...  PCC.Alert Create Rule Template
    

        ${status}                   PCC.Alert Create Rule Template
                               ...  name=alert1
                               ...  parameter=cachedMem
                               ...  operator=>
                               ...  value=60000
                               ...  time=1m
                               ...  templateId=1
                               ...  nodes=["${CLUSTERHEAD_1_NAME}"]
                               ...  auth_data=${PCC_CONN}
                               ...  setup_ip=${PCC_HOST_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                             
                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Alert Verify Template Rule
###################################################################################################################################
    [Documentation]                 *Alert Verify Template Rule*
                               ...  Keywords:
                               ...  PCC.Alert Verify Rule   

        ${status}                   PCC.Alert Verify Rule
                               ...  name=alert1
                               ...  parameter=cachedMem
                               ...  operator=>
                               ...  value=60000
                               ...  time=1m
                               ...  templateId=1
                               ...  nodes=["${CLUSTERHEAD_1_NAME}"]
                               ...  auth_data=${PCC_CONN}
                               ...  setup_ip=${PCC_HOST_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                             
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Alert Create Raw Rule 
###################################################################################################################################
    [Documentation]                 *Alert Create Raw Rule*
                               ...  Keywords:
                               ...  PCC.Alert Create Rule Raw   

        ${status}                   PCC.Alert Create Rule Raw
                               ...  auth_data=${PCC_CONN}
                               ...  setup_ip=${PCC_HOST_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  filename=freeswap.yml
                             
                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Alert Verify Raw Rule
###################################################################################################################################
    [Documentation]                 *Alert Verify Raw Rule*
                               ...  Keywords:
                               ...  PCC.Alert Verify Rule   

        ${status}                   PCC.Alert Verify Rule
                               ...  name=FreeSwap
                               ...  auth_data=${PCC_CONN}
                               ...  setup_ip=${PCC_HOST_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                             
                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Alert Get Rule Id 
###################################################################################################################################
    [Documentation]                 *Alert Get Rule Id*
                               ...  Keywords:
                               ...  PCC.Alert Get Rule Id   

        ${status}                   PCC.Alert Get Rule Id
                               ...  name=alert1
                               ...  auth_data=${PCC_CONN}
                               ...  setup_ip=${PCC_HOST_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                             
                                    Should Not Be Equal As Strings      ${status}    None
                                    
###################################################################################################################################
Alert Update Rule
###################################################################################################################################
    [Documentation]                 *Alert Update Rule*
                               ...  Keywords:
                               ...  PCC.Alert Update Rule       

        ${status}                   PCC.Alert Update Rule
                               ...  name=alert1
                               ...  parameter=cachedMem
                               ...  operator=>
                               ...  value=70000
                               ...  time=1m
                               ...  templateId=1
                               ...  nodes=["${CLUSTERHEAD_1_NAME}"]
                               ...  auth_data=${PCC_CONN}
                               ...  setup_ip=${PCC_HOST_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                             
                                    Should Be Equal As Strings      ${status}    OK
                                    
        ${status}                   PCC.Alert Verify Rule
                               ...  name=alert1
                               ...  parameter=cachedMem
                               ...  operator=>
                               ...  value=70000
                               ...  time=1m
                               ...  nodes=["${CLUSTERHEAD_1_NAME}"]
                               ...  templateId=1
                               ...  auth_data=${PCC_CONN}
                               ...  setup_ip=${PCC_HOST_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                                    
###################################################################################################################################
Alert Delete Template Rule 
###################################################################################################################################
    [Documentation]                 *Alert Delete Template Rule*
                               ...  Keywords:
                               ...  PCC.Alert Delete Rule    
                               ...  PCC.Alert Verify Rule

        ${status}                   PCC.Alert Delete Rule
                               ...  name=alert1
                               ...  auth_data=${PCC_CONN}
                               ...  setup_ip=${PCC_HOST_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                             
                                    Should Be Equal As Strings      ${status}    OK
                                    
        ${status}                   PCC.Alert Verify Rule
                               ...  name=alert1
                               ...  auth_data=${PCC_CONN}
                               ...  setup_ip=${PCC_HOST_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                             
                                    Should Not Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Alert Delete Raw Rule 
###################################################################################################################################
    [Documentation]                 *Alert Delete Raw Rule *
                               ...  Keywords:
                               ...  PCC.Alert Delete Rule    
                               ...  PCC.Alert Verify Rule    

        ${status}                   PCC.Alert Delete Rule
                               ...  name=FreeSwap
                               ...  auth_data=${PCC_CONN}
                               ...  setup_ip=${PCC_HOST_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                             
                                    Should Be Equal As Strings      ${status}    OK
                                    
        ${status}                   PCC.Alert Verify Rule
                               ...  name=FreeSwap
                               ...  auth_data=${PCC_CONN}
                               ...  setup_ip=${PCC_HOST_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                             
                                    Should Not Be Equal As Strings      ${status}    OK

