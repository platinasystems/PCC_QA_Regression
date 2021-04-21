*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
									Load PCC Test Data      ${pcc_setup}
									Load Clusterhead 1 Test Data    ${pcc_setup}
									Load Server 1 Test Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
PCC Version
###################################################################################################################################
    [Documentation]                 *PCC Version*
                               ...  keywords:
                               ...  PCC.Get PCC Version


	${pcc_ver}                    PCC.Get PCC Version
                                ...  user=${PCC_LINUX_USER}
                                ...  password=${PCC_LINUX_PASSWORD}
                                ...  nodes_ip=${PCC_HOST_IP}

                                Log To Console    ${pcc_ver}


###################################################################################################################################
Ceph Version
###################################################################################################################################
    [Documentation]                 *Ceph Version*
                               ...  keywords:
                               ...  PCC.Get Ceph Version

	${ceph_ver}                    PCC.Get Ceph Version
                                ...  user=${SERVER_1_UNAME}
                                ...  password=${SERVER_1_PWD}
                                ...  nodes_ip=${SERVER_1_HOST_IP}

                                Log To Console    ${ceph_ver}


###################################################################################################################################
K8s Version
###################################################################################################################################
    [Documentation]                 *K8s Version*
                               ...  keywords:
                               ...  PCC.Get K8s Version

	${ceph_ver}                    PCC.Get K8s Version
                                ...  user=${CLUSTERHEAD_1_UNAME}
                                ...  password=${CLUSTERHEAD_1_PWD}
                                ...  nodes_ip=${CLUSTERHEAD_1_HOST_IP}

                                Log To Console    ${ceph_ver}