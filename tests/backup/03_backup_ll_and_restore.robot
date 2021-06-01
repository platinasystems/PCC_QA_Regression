*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

        ## aa_infra
                                    Load Clusterhead 1 Test Data        ${pcc_setup}
                                    Load Clusterhead 2 Test Data        ${pcc_setup}
                                    Load Server 2 Test Data        ${pcc_setup}
                                    Load Server 1 Test Data        ${pcc_setup}
                                    Load Server 3 Test Data        ${pcc_setup}
                                    Load Network Manager Data    ${pcc_setup}
                                    Load Container Registry Data    ${pcc_setup}
                                    Load Auth Profile Data    ${pcc_setup}
                                    Load OpenSSH_Keys Data    ${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Ceph Pool Data    ${pcc_setup}
                                    Load Ceph Rbd Data    ${pcc_setup}
                                    Load Ceph Fs Data    ${pcc_setup}
                                    Load Ceph Rgw Data    ${pcc_setup}
                                    Load Tunneling Data    ${pcc_setup}
                                    Load K8s Data    ${pcc_setup}
                                    Load PXE-Boot Data    ${pcc_setup}
                                    Load Alert Data    ${pcc_setup}
                                    Load SAS Enclosure Data    ${pcc_setup}
                                    Load Ipam Data    ${pcc_setup}
                                    Load Certificate Data    ${pcc_setup}
                                    Load i28 Data    ${pcc_setup}
                                    Load OS-Deployment Data    ${pcc_setup}
                                    Load Tenant Data    ${pcc_setup}
                                    Load Node Roles Data    ${pcc_setup}
                                    Load Node Groups Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Backup PCC Instance Locally:TCP-296,TCP-439 
####################################################################################################################################

        [Documentation]            *Backup PCC instance* test
                               ...  keywords:
                               ...  CLI.Backup PCC Instance

        ${status}                   CLI.Backup PCC Instance
                              ...   pcc_password=${PCC_SETUP_PWD}
                              ...   host_ip=${PCC_HOST_IP}
                              ...   linux_user=${PCC_LINUX_USER}
                              ...   linux_password=${PCC_LINUX_PASSWORD}
                              ...   backup_params=all
                              ...   backup_type=local


                                    Log to Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK
                                    Sleep    1 minutes

###################################################################################################################################
Backend Verification Before Restore:TCP-1667,TCP-1668,TCP-1669,TCP-1670,TCP-302,TCP-304,TCP-300
###################################################################################################################################
        ${response}                 CLI.Backend Verification Before Restore
                               ...  backup_hostip=${PCC_HOST_IP}
                               ...  linux_user=pcc
                               ...  linux_password=cals0ft
                               ...  pcc_password=${PCC_SETUP_PWD}
                                    Should Be Equal As Strings      ${response}  OK

##################################################################################################################################
Prune Volumes And Perform Fresh Install:TCP-425,TCP-429,TCP-433
###################################################################################################################################

        [Documentation]    *Prune Volumes And Perform Fresh Install* test

        ${result}                  CLI.Pcc Down
                              ...  host_ip=${PCC_HOST_IP}
                              ...  linux_user=${PCC_LINUX_USER}
                              ...  linux_password=${PCC_LINUX_PASSWORD}
                              ...  pcc_password=${PCC_SETUP_PWD}

                                   Should Be Equal     ${result}       OK

        ${result}                  CLI.Pcc Cleanup
                              ...  host_ip=${PCC_HOST_IP}
                              ...  linux_user=${PCC_LINUX_USER}
                              ...  linux_password=${PCC_LINUX_PASSWORD}
                                   Should Be Equal     ${result}       OK

        ${result}                  CLI.PCC Pull Code
                              ...  host_ip=${PCC_HOST_IP}
                              ...  linux_user=${PCC_LINUX_USER}
                              ...  linux_password=${PCC_LINUX_PASSWORD}
                              ...  pcc_version_cmd=${PCC_SETUP_UPGRADE_CMD}
                                   Should Be Equal     ${result}       OK

        ${result}                  CLI.Pcc Set Keys
                              ...  host_ip=${PCC_HOST_IP}
                              ...  linux_user=${PCC_LINUX_USER}
                              ...  linux_password=${PCC_LINUX_PASSWORD}
                              ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_2_HOST_IP}"]

                                   Should Be Equal     ${result}       OK


###################################################################################################################################
Restore PCC Instance Locally:TCP-1679,TCP-296
###################################################################################################################################

        [Documentation]            *Restore PCC instance* test
                               ...  keywords:
                               ...  CLI.Restore PCC Instance

        ${status}                   CLI.Restore PCC Instance
                               ...  pcc_password=${PCC_SETUP_PWD}
                               ...  host_ip=${PCC_HOST_IP}
                               ...  linux_user=${PCC_LINUX_USER}
                               ...  linux_password=${PCC_LINUX_PASSWORD}
                               ...  backup_params=all
                               ...  backup_type=local
                               ...  restore_type=local

                                    Log to Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

                                    Sleep    1 minutes

###################################################################################################################################
Backend Verification After Restore:TCP-1667,TCP-1668,TCP-1669,TCP-1670,TCP-302,TCP-304,TCP-300
###################################################################################################################################
        ${response}                 CLI.Backend Verification After Restore
                               ...  backup_hostip=${PCC_HOST_IP}
                               ...  linux_user=pcc
                               ...  linux_password=cals0ft
                               ...  pcc_password=${PCC_SETUP_PWD}
                                    Should Be Equal As Strings      ${response}  OK

