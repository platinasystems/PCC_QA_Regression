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
Backup PCC Instance Locally
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

##################################################################################################################################
Prune Volumes And Perform Fresh Install
###################################################################################################################################

        [Documentation]    *Prune Volumes And Perform Fresh Install* test


        ${result}                  CLI.Pcc Down
                              ...  host_ip=172.17.2.242
                              ...  linux_user=${PCC_LINUX_USER}
                              ...  linux_password=${PCC_LINUX_PASSWORD}
                              ...  pcc_password=1m1pAscj0O3IaKRN
                                   Should Be Equal     ${result}       OK

        ${result}                  CLI.PCC Pull Code
                              ...  host_ip=172.17.2.242
                              ...  linux_user=${PCC_LINUX_USER}
                              ...  linux_password=${PCC_LINUX_PASSWORD}
                              ...  pcc_version_cmd=sudo /home/pcc/platina-cli-ws/platina-cli run -u Hippety_Hopper -p 1m1pAscj0O3IaKRN --url https://cust-dev.lab.platinasystems.com --insecure --registryUrl https://cust-dev.lab.platinasystems.com:5000 --ru Hippety_Hopper --rp 1m1pAscj0O3IaKRN --prtKey /home/pcc/i28-keys/i28-key --pblKey /home/pcc/i28-keys/i28-key.pub --release v1.7.0

                                   Should Be Equal     ${result}       OK

###################################################################################################################################
Restore PCC Instance Local To Remote
###################################################################################################################################

        [Documentation]            *Restore PCC instance* test
                               ...  keywords:
                               ...  CLI.Restore PCC Instance

        ${result}                   CLI.Pcc Down
                               ...  host_ip=${PCC_HOST_IP}
                               ...  linux_user=${PCC_LINUX_USER}
                               ...  linux_password=${PCC_LINUX_PASSWORD}
                               ...  pcc_password=${PCC_SETUP_PWD}
                                    Should Be Equal     ${result}       OK

        ${status}                   CLI.Restore PCC Instance
                               ...  pcc_password=1m1pAscj0O3IaKRN
                               ...  host_ip=172.17.2.242
                               ...  linux_user=${PCC_LINUX_USER}
                               ...  linux_password=${PCC_LINUX_PASSWORD}
                               ...  backup_type=local
                               ...  restore_type=remote
                               ...  restore_hostip=${PCC_HOST_IP}

                                    Log to Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK

                                    Sleep    1 minutes
