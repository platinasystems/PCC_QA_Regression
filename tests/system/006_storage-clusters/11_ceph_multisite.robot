*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212


*** Test Cases ***
###################################################################################################################################
Login to PCC
###################################################################################################################################
                        Load Ceph Rgw Data    ${pcc_setup}
                        Load Ceph Cluster Data  ${pcc_setup}


        ${status}        Login To PCC    ${pcc_setup}

###################################################################################################################################
Primary Started Trust Creation
###################################################################################################################################
        [Documentation]                *Primary Started Trust Creation*

        ${status}                   PCC.Ceph Get Pcc Status
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${rgw_id}                   PCC.Ceph Get Rgw Id
                               ...  name=${CEPH_RGW_NAME}
			                   ...  ceph_cluster_name=ceph-pvt

		${status}	                PCC.Ceph Primary Start Trust
			                   ...  masterAppID=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK




