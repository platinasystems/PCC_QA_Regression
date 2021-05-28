*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Ipam Data    ${pcc_setup}
                                    Load Ceph Rbd Data    ${pcc_setup}
                                    Load Ceph Pool Data    ${pcc_setup}
                                    Load Ceph Fs Data    ${pcc_setup}
                                    Load Ceph Rgw Data    ${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup} 
                                    Load Network Manager Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK


##################################################################################################################################
Ceph Certificate For Rgws
###################################################################################################################################

        [Documentation]              *Ceph Ceph Certificate For Rgws*
          
        ${cert_id}                   PCC.Get Certificate Id
                                ...  Alias=${CEPH_RGW_CERT_NAME}
                                     Pass Execution If    ${cert_id} is not ${None}    Certificate is already there

        ${response}                  PCC.Add Certificate
                                ...  Alias=${CEPH_RGW_CERT_NAME}
                                ...  Description=certificate-for-rgw
                                ...  Private_key=domain.key
                                ...  Certificate_upload=domain.crt

                                     Log To Console    ${response}
        ${result}                    Get Result    ${response}
        ${status}                    Get From Dictionary    ${result}    statusCodeValue
                                     Should Be Equal As Strings    ${status}    200


##################################################################################################################################
#Cli PCC Pull Code
####################################################################################################################################
#        [Documentation]         *Cli PCC Pull Code*
#
#            ${result}            CLI.PCC Pull Code
#                            ...  host_ip=${PCC_HOST_IP}
#                            ...  linux_user=${PCC_LINUX_USER}
#                            ...  linux_password=${PCC_LINUX_PASSWORD}
#                            ...  pcc_version_cmd=sudo /home/pcc/platina-cli-ws/platina-cli pull --configRepo master -p ${PCC_SETUP_PWD}
#
#                                 Should Be Equal     ${result}       OK
#                                 
####################################################################################################################################
#Cli PCC Set Keys
####################################################################################################################################
#        [Documentation]         *Cli PCC Set Keys*
#
#                                 Load PCC Test Data        testdata_key=${pcc_setup}
#            ${result}            CLI.Pcc Set Keys
#                            ...  host_ip=${PCC_HOST_IP}
#                            ...  linux_user=${PCC_LINUX_USER}
#                            ...  linux_password=${PCC_LINUX_PASSWORD}
#                            ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_2_HOST_IP}"]
#
#                                 Should Be Equal     ${result}       OK

#####################################################################################################################################
Install net-tools on nodes
#####################################################################################################################################

    [Documentation]    *Install net-tools on nodes* test
    [Tags]    add

    ${status}    Install net-tools command


                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK
