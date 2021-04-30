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
									Load Ceph Cluster Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK


###################################################################################################################################
Portus Version
###################################################################################################################################
    [Documentation]             *Portus Version*

	${ceph_ver_list}            PCC.Get Portus Version

                                Log To Console    ${ceph_ver_list}


###################################################################################################################################
Ceph Version
###################################################################################################################################
    [Documentation]             *Ceph Version*
                               ...  keywords:
                               ...  PCC.Get Ceph Version

	${ceph_ver_list}                 PCC.Get Ceph Version
								...  name=${CEPH_CLUSTER_NAME}


                                Log To Console    ${ceph_ver_list}


###################################################################################################################################
K8s Version
###################################################################################################################################
    [Documentation]             *K8s Version*

	${k8s_ver}                 PCC.Get K8s Version

                                Log To Console    ${k8s_ver}


