*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Clusterhead 1 Test Data        testdata_key=${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK
                                    
###################################################################################################################################
Alert Create Template Rule
###################################################################################################################################
    [Documentation]                 *Alert Create Template Rule*
                               ...  Keywords:
                               ...  PCC.Alert Create Rule Template


        ${response}                 PCC.Alert Create Rule Template
                               ...  name=alert1
                               ...  parameter=cachedMem
                               ...  operator=>
                               ...  value=60000
                               ...  time=1m
                               ...  templateId=1
                               ...  nodes=["${CLUSTERHEAD_1_NAME}"]

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Alert Verify Template Rule
###################################################################################################################################
    [Documentation]                 *Alert Verify Template Rule*
                               ...  Keywords:
                               ...  PCC.Alert Verify Rule

        ${status}                   PCC.Alert Verify Rule
                               ...  name=alert1

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

        ${status}                   PCC.Alert Verify Raw Rule
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

        ${alert_id}                 PCC.Alert Get Rule Id
                               ...  name=alert1

                                    Pass Execution If    ${alert_id} is not ${None}    Alert is Created

###################################################################################################################################
Alert Update Rule
###################################################################################################################################
    [Documentation]                 *Alert Update Rule*
                               ...  Keywords:
                               ...  PCC.Alert Update Rule

        ${alert_id}                 PCC.Alert Get Rule Id
                               ...  name=alert1

        ${response}                 PCC.Alert Update Rule
                               ...  id=${alert_id}
                               ...  name=alert1
                               ...  parameter=cachedMem
                               ...  operator=>
                               ...  value=70000
                               ...  time=1m
                               ...  templateId=1
                               ...  nodes=["${CLUSTERHEAD_1_NAME}"]


        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Alert Verify Rule
                               ...  name=alert1

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Alert Delete Template Rule
###################################################################################################################################
    [Documentation]                 *Alert Delete Template Rule*
                               ...  Keywords:
                               ...  PCC.Alert Delete Rule
                               ...  PCC.Alert Verify Rule

        ${response}                 PCC.Alert Delete Rule
                               ...  name=alert1

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${alert_id}                 PCC.Alert Get Rule Id
                               ...  name=alert1

                                    Pass Execution If    ${alert_id} is ${None}    Alert is Deleted

###################################################################################################################################
Alert Delete Raw Rule
###################################################################################################################################
    [Documentation]                 *Alert Delete Raw Rule *
                               ...  Keywords:
                               ...  PCC.Alert Delete Rule
                               ...  PCC.Alert Verify Rule

        ${status}                   PCC.Alert Delete All Rule
                                    Should Be Equal As Strings      ${status}  OK


###################################################################################################################################
Alert osd down/out
###################################################################################################################################
    [Documentation]                 *Alert osd down/out*

       ${alert_id}                 PCC.Alert Get Rule Id
                               ...  name=osds down/out

       ${response}                 PCC.Alert Edit Rule Notifications
                               ...  id=${alert_id}
                               ...  mail=${TENANT_USER_PCC_USERNAME}

       ${status_code}              Get Response Status Code        ${response}
       ${message}                  Get Response Message        ${response}
                                   Should Be Equal As Strings      ${status_code}  200

       ${response}                  PCC.Ceph Make Osds Down
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  limit=1
                                    Should Be Equal As Strings      ${response}  OK

                                    sleep  7m

       ${response}                  PCC.Find Notification
                               ...  type=alert
                               ...  message=osds down/out. Status:firing
                                    Should Be Equal As Strings      ${response}  OK

       ${mail}                       PCC.Get Body From Last Mail
                               ...   Email=${TENANT_USER_PCC_USERNAME}

       ${result}                     PCC.Find Alert Mail
                               ...   mail=${mail}
                               ...   info=["osds down/out", "firing"]
                                     Should Be Equal As Strings      ${result}  OK

       ${response}                   PCC.Ceph Make Osds Up
                               ...   name=${CEPH_CLUSTER_NAME}
                                     Should Be Equal As Strings      ${response}  OK

                                     sleep  3m

       ${response}                  PCC.Find Notification
                               ...  type=alert
                               ...  message=osds down/out. Status:resolved
                                    Should Be Equal As Strings      ${response}  OK

       ${mail}                       PCC.Get Body From Last Mail
                               ...   Email=${TENANT_USER_PCC_USERNAME}

       ${result}                     PCC.Find Alert Mail
                               ...   mail=${mail}
                               ...   info=["osds down/out", "resolved"]
                                     Should Be Equal As Strings      ${result}  OK

