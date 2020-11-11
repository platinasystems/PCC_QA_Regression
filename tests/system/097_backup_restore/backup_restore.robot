*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_218

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
Backup PCC instance
###################################################################################################################################
        
        [Documentation]    *Backup PCC instance* test
                           ...  keywords:
                           ...  CLI.Backup PCC Instance     
        
        ${status}    CLI.Backup PCC Instance
                     ...    pcc_password=${PCC_SETUP_PWD}
                     ...    backup_hostip=172.17.2.215
                     ...    host_ip=${PCC_HOST_IP}
                     ...    linux_user=${PCC_LINUX_USER}
                     ...    linux_password=${PCC_LINUX_PASSWORD}
                     
                     
                     Log to Console    ${status}
                     Should Be Equal As Strings    ${status}    OK
                     
                     Sleep    1 minutes
                     
###################################################################################################################################
Prune Volumes And Perform Fresh Install
###################################################################################################################################
        
        [Documentation]    *Prune Volumes And Perform Fresh Install* test
        
        ${result}            CLI.Pcc Down
                            ...  host_ip=${PCC_HOST_IP}
                            ...  linux_user=${PCC_LINUX_USER}
                            ...  linux_password=${PCC_LINUX_PASSWORD}
                            ...  pcc_password=${PCC_SETUP_PWD}

                                 Should Be Equal     ${result}       OK
                                 
        ${result}            CLI.Pcc Cleanup
                            ...  host_ip=${PCC_HOST_IP}
                            ...  linux_user=${PCC_LINUX_USER}
                            ...  linux_password=${PCC_LINUX_PASSWORD}

                                 Should Be Equal     ${result}       OK

        ${result}            CLI.PCC Pull Code
                            ...  host_ip=${PCC_HOST_IP}
                            ...  linux_user=${PCC_LINUX_USER}
                            ...  linux_password=${PCC_LINUX_PASSWORD}
                            ...  pcc_version_cmd=sudo /home/pcc/platina-cli-ws/platina-cli run -u Road_Runner -p vRcek8jqNBOtYKqA --url https://cust-dev.lab.platinasystems.com --insecure --registryUrl https://cust-dev.lab.platinasystems.com:5000 --ru Road_Runner --rp vRcek8jqNBOtYKqA --prtKey /home/pcc/i28-keys/i28-id_rsa --pblKey /home/pcc/i28-keys/i28-authorized_keys --release v1.6.1 --pruneVolumes
                                 Should Be Equal     ${result}       OK
                                 
        ${result}            CLI.Pcc Set Keys
                            ...  host_ip=${PCC_HOST_IP}
                            ...  linux_user=${PCC_LINUX_USER}
                            ...  linux_password=${PCC_LINUX_PASSWORD}
                            ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${SERVER_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_2_HOST_IP}"]

                                 Should Be Equal     ${result}       OK


###################################################################################################################################
Restore PCC instance
###################################################################################################################################
        
        [Documentation]    *Restore PCC instance* test
                           ...  keywords:
                           ...  CLI.Restore PCC Instance     
        
        ${status}    CLI.Restore PCC Instance
                     ...    pcc_password=${PCC_SETUP_PWD}
                     ...    restore_hostip=172.17.2.215
                     ...    host_ip=${PCC_HOST_IP}
                     ...    linux_user=${PCC_LINUX_USER}
                     ...    linux_password=${PCC_LINUX_PASSWORD}
                     
                     
                     Log to Console    ${status}
                     Should Be Equal As Strings    ${status}    OK
                     
                     Sleep    1 minutes
                     
###################################################################################################################################
Login after Pruning volumes
###################################################################################################################################
        [Tags]    Only
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

        ${result}      PCC.Update OS Images
                       ...    setup_password=${PCC_SETUP_PWD}
                       ...    host_ip=${PCC_HOST_IP}
                       ...    username=${PCC_LINUX_USER}
                       ...    password=${PCC_LINUX_PASSWORD}

                       Log To Console    ${result}
                       Should Be Equal As Strings      ${result}  OK
                                           
###################################################################################################################################
Validation after restoring PCC
###################################################################################################################################
        [Tags]    Only
        ### Validating Container registry exists or not ###

        ${result}    PCC.CR Verify Creation from PCC
                     ...    Name=${CR_NAME}
                     Log to console    "${result}"
                     Should Be Equal As Strings    ${result}    OK
        
        ${CR_id_after_restore}    PCC.Get CR Id
                                  ...    Name=${CR_NAME}  

                                  Log To Console    ${CR_id_before_backup}
                                  Set Global Variable    ${CR_id_before_backup}

                                  Should Be Equal As Strings    ${CR_id_after_restore}    ${CR_id_before_backup}
    
        ### Validate Auth Profile exists or not ###
        
        ${auth_profile_id_after_restore}    PCC.Get Auth Profile Id
                                            ...    Name=${AUTH_PROFILE_NAME}

                                            Log To Console    ${auth_profile_id_after_restore}
                                            Set Global Variable    ${auth_profile_id_after_restore} 

                                            Should Be Equal As Strings    ${auth_profile_id_after_restore}    ${auth_profile_id_before_backup}  

        ### Validating OpenSSH Keys after restoring ###

        ${key_id_after_restore}    PCC.Get OpenSSH Key Id
                                   ...    Name=${PUBLIC_KEY_ALIAS}

                                   Log To Console    ${key_id_after_restore}
                                   Set Global Variable    ${key_id_after_restore}
                                   Should Be Equal As Strings    ${key_id_after_restore}    ${key_id_before_backup} 

        ### Validating IPAM after restoring ###
        
        ${ipam_subnet_id_after_restore}    PCC.Ipam Subnet Get Id
                                           ...  name=${IPAM_DATA_SUBNET_NAME}
                                           Log To Console    ${ipam_subnet_id_after_restore}
                                           Set Global Variable    ${ipam_subnet_id_after_restore} 
                                           Should Be Equal As Strings    ${ipam_subnet_id_after_restore}    ${ipam_subnet_id_before_backup} 
        
        ### Validating FS after restoring ###
        ${ceph_fs_id_after_restore}        PCC.Ceph Get Fs Id
                                            ...  name=${CEPH_FS_NAME}                            
                                            Log To Console    ${ceph_fs_id_after_restore}
                                            Set Global Variable    ${ceph_fs_id_after_restore} 
                                            Should Be Equal As Strings    ${ceph_fs_id_after_restore}    ${ceph_fs_id_before_backup}
                                            
        ### Validating RBD after restoring ###
        
        ${rbd_id_after_restore}    PCC.Ceph Get Rbd Id
                                    ...  name=rbd-5                            
                                    Log To Console    ${rbd_id_after_restore}
                                    Set Global Variable    ${rbd_id_after_restore}
                                    Should Be Equal As Strings    ${rbd_id_after_restore}    ${rbd_id_before_backup}
                                    
        ### Validating Pool after restoring ###  
                                  
        ${pool_id_after_restore}    PCC.Ceph Get Pool Id
                                     ...  name=${CEPH_POOL_NAME}                            
                                     Log To Console    ${pool_id_after_restore}
                                     Set Global Variable    ${pool_id_after_restore}  
                                     Should Be Equal As Strings    ${pool_id_after_restore}    ${pool_id_before_backup}
        
        ### Validating K8s after restoring ###
        
        ${K8s_cluster_id_after_restore}        PCC.K8s Get Cluster Id
                                                ...  name=${K8S_NAME}                            
                                                Log To Console    ${K8s_cluster_id_after_restore}
                                                Set Global Variable    ${K8s_cluster_id_after_restore} 
                                                Should Be Equal As Strings    ${K8s_cluster_id_after_restore}    ${K8s_cluster_id_before_backup}
                                                
        ${status}                   PCC.K8s Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]

                                    Should Be Equal As Strings      ${status}    OK
        
        ### Validating Network Manager after restoring ### 
        
        ${network_id_after_restore}    PCC.Get Network Manager Id
                                       ...  name=${NETWORK_MANAGER_NAME}
                                       Log To Console    ${network_id_after_restore}
                                       Set Global Variable    ${network_id_after_restore}
                                       Should Be Equal As Strings    ${network_id_after_restore}    ${network_id_before_backup}
                                       
        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Network Manager Verify BE      
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_2_HOST_IP}"]
                               ...  dataCIDR=${IPAM_DATA_SUBNET_IP}
                                    Should Be Equal As Strings      ${status}  OK

        ${status}                   PCC.Health Check Network Manager
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK
        
        ### Validating CEPH cluster after restoring ###                             
        ${ceph_cluster_id_after_restore}    PCC.Ceph Get Cluster Id
                                             ...  name=${CEPH_Cluster_NAME}                          
                                             Log To Console    ${ceph_cluster_id_after_restore}
                                             Set Global Variable    ${ceph_cluster_id_after_restore} 
                                             Should Be Equal As Strings    ${ceph_cluster_id_after_restore}    ${ceph_cluster_id_before_backup}
                                             
        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK
                                    
        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
                                    Should Be Equal As Strings      ${status}    OK
                                              
        ### Validating Certificate after restoring ###                           
        
        ${certificate_id_after_restore}    PCC.Get Certificate Id
                                           ...    Alias=Cert_with_pvt_cert
                                           
                                           Log To Console    ${certificate_id_after_restore}
                                           Set Global Variable    ${certificate_id_after_restore} 
                                           Should Be Equal As Strings    ${certificate_id_after_restore}    ${certificate_id_before_backup} 

        ### Validating Node role after restoring ###

        ${node_role_id_after_restore}    PCC.Get Node Role Id    
                                         ...    Name=${NODE_ROLE_5}
                                         Log To Console    ${node_role_id_after_restore}
                                         Set Global Variable    ${node_role_id_after_restore}                                    
                                         Should Be Equal As Strings    ${node_role_id_after_restore}    ${node_role_id_before_backup}   

        ### Validating Tenant after restoring ###
        ${tenant_id_after_restore}    PCC.Get Tenant Id
                                      ...    Name=${TENANT4}
                                      Log To Console    ${tenant_id_after_restore}
                                      Set Global Variable    ${tenant_id_after_restore}  
                                      Should Be Equal As Strings    ${tenant_id_after_restore}    ${tenant_id_before_backup}   
                                      
        ### Validating Node group after restoring ###
        ${nodegroup_id_after_restore}    PCC.Get Node Group Id                                  
                                         ...    Name=${NODE_GROUP9}
                                         Log To Console    ${nodegroup_id_after_restore}
                                         Set Global Variable    ${nodegroup_id_after_restore}
                                         Should Be Equal As Strings    ${nodegroup_id_after_restore}    ${nodegroup_id_before_backup}
                                         
        ### Validating Profile after restoring ###                                 
        ${profile_id_after_restore}    PCC.Get Profile Id                                  
                                       ...    Name=profile_without_active
                                       Log To Console    ${profile_id_after_restore}
                                       Set Global Variable    ${profile_id_after_restore}
                                       Should Be Equal As Strings    ${profile_id_after_restore}    ${profile_id_before_backup}
                                       
        
                                       
        ### Verifying topology after restoring ###
                                       
        ${status}    PCC.Verify LLDP Neighbors
                     ...    servers_hostip=['${SERVER_1_HOST_IP}','${SERVER_2_HOST_IP}']
                     ...    invaders_hostip=['${CLUSTERHEAD_1_HOST_IP}']
                       
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK
                     
        ### Validating Node Roles (MaaS, LLDP) after restoring ###

        ${status_code}         PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${CLUSTERHEAD_1_NAME}                                     
                               Should Be Equal As Strings      ${status_code}  OK     

        ${response}            PCC.Maas Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               Should Be Equal As Strings      ${response}  OK    

        ${response}            PCC.Lldp Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               Should Be Equal As Strings      ${response}  OK

        ${status_code}         PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${SERVER_2_NAME}
                               Should Be Equal As Strings      ${status_code}  OK     

        ${response}            PCC.Lldp Verify BE
                               ...  nodes_ip=["${SERVER_2_HOST_IP}"]
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               Should Be Equal As Strings      ${response}  OK




















