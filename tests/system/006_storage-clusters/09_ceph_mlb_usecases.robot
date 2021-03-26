#*** Settings ***
#Resource    pcc_resources.robot
#
#*** Variables ***
#${pcc_setup}                 pcc_218
#
#*** Test Cases ***
####################################################################################################################################
#Login
####################################################################################################################################
#      [Tags]    Only  
#                                    Load Ipam Data    ${pcc_setup}
#                                    Load Ceph Rbd Data    ${pcc_setup}
#                                    Load Ceph Pool Data    ${pcc_setup}
#                                    Load Ceph Cluster Data    ${pcc_setup}
#                                    Load Clusterhead 1 Test Data    ${pcc_setup}
#                                    Load Clusterhead 2 Test Data    ${pcc_setup}
#                                    Load Server 1 Test Data    ${pcc_setup}
#                                    Load Server 2 Test Data    ${pcc_setup}
#                                    Load Server 3 Test Data    ${pcc_setup} 
#                                    Load Network Manager Data    ${pcc_setup}
#
#        ${status}                   Login To PCC        testdata_key=${pcc_setup}
#                                    Should Be Equal     ${status}  OK
#
####################################################################################################################################
#Ceph Mons
####################################################################################################################################
#
#       
#        ${status}                   PCC.Ceph Get State Nodes
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  state=mons
#                               Log To Console   ${status} 
#
####################################################################################################################################
#Ceph Osds
####################################################################################################################################
#
#         
#        ${status}                   PCC.Ceph Get State Nodes
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  state=osds
#                               Log To Console   ${status} 
#                               
####################################################################################################################################
#Ceph Mds
####################################################################################################################################
#    
#        ${status}                   PCC.Ceph Get State Nodes
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  state=mds
#                               ...  state_status=active
#                               Log To Console   ${status} 
#                 
####################################################################################################################################
#CephFS - Create CephFS, mount to Client, copy some data on it and reboot one MON node (TCP-1069)
####################################################################################################################################
#    [Documentation]                 *Creating Ceph Cluster*
#                               ...  keywords:
#                               ...  PCC.Ceph Create Cluster
#                               ...  PCC.Ceph Wait Until Cluster Ready
#        
#    
#        ### Creating CEPH Cluster ###
#        ${id}                       PCC.Ceph Get Cluster Id
#                              ...   name=${CEPH_CLUSTER_NAME}
#                                    Pass Execution If    ${id} is not ${None}    Cluster is already there
#
#        ${status}                   PCC.Health Check Network Manager
#                               ...  name=${NETWORK_MANAGER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK 
#
#        ${response}                 PCC.Ceph Create Cluster
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  nodes=[${SERVER_1_HOST_IP},${SERVER_2_HOST_IP},${CLUSTERHEAD_1_HOST_IP},${SERVER_3_HOST_IP}]
#                               ...  tags=${CEPH_CLUSTER_TAGS}
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${status}                   PCC.Ceph Verify BE
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ### Creating 5 Pools for usecases ###
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=pool-1-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=GiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=pool-1-usecase
#
#                                    Should Be Equal As Strings      ${status}    OK 
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=pool-2-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=GiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=pool-2-usecase
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=pool-3-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=GiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=pool-3-usecase
#                                    Should Be Equal As Strings      ${status}    OK 
#
#        ###  Create CEPH FS  ###
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${meta}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-1-usecase
#
#        ${data}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-2-usecase
#
#        ${default}                  PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-3-usecase
#
#        ${response}                 PCC.Ceph Create Fs
#                               ...  name=fs-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  metadata_pool=${meta}
#                               ...  data_pool=[${data}]
#                               ...  default_pool=${default}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}              PCC.Ceph Wait Until Fs Ready
#                               ...  name=fs-usecase
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
##        ${status}               PCC.Ceph Fs Verify BE
##                                ...  name=fs-usecase
##                                ...  user=${PCC_LINUX_USER}
##                                ...  password=${PCC_LINUX_PASSWORD}
##                                ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
##
##                                Should Be Equal As Strings      ${status}    OK
#
#        ###  Get MON nodes  ###
#
#        ${status}              PCC.Ceph Get State Nodes
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  state=mons
#                               Log To Console   ${status}
#                               ${mon_node_ip_1}    Set Variable    ${status}[0]
#                               Log To Console    ${mon_node_ip_1}
#                               Set Global Variable    ${mon_node_ip_1}
#                               ${mon_node_ip_2}    Set Variable    ${status}[1]
#                               Log To Console    ${mon_node_ip_2}
#                               Set Global Variable    ${mon_node_ip_2}
#
#
#
#        ###  Get OSD nodes  ###
#
#        ${status}              PCC.Ceph Get State Nodes
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  state=osds
#                               Log To Console   ${status}
#                               ${osd_node_ip_1}    Set Variable    ${status}[0]
#                               Log To Console    ${osd_node_ip_1}
#                               Set Global Variable    ${osd_node_ip_1}
#                               ${osd_node_ip_2}    Set Variable    ${status}[1]
#                               Log To Console    ${osd_node_ip_2}
#                               Set Global Variable    ${osd_node_ip_2}
#                               
#        ###  Get Active MDS nodes  ###
#
#        ${status}              PCC.Ceph Get State Nodes
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  state=mds
#                               ...  state_status=active
#                               
#                               Log To Console   ${status}
#                               ${active_mds_node_ip}    Set Variable    ${status}[0]
#                               Log To Console    ${active_mds_node_ip}
#                               Set Global Variable    ${active_mds_node_ip}
#                               
#        ###  Get Standby MDS nodes  ###
#
#        ${status}              PCC.Ceph Get State Nodes
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  state=mds
#                               ...  state_status=standby
#                               
#                               Log To Console   ${status}
#                               ${standby_mds_node_ip}    Set Variable    ${status}[0]
#                               Log To Console    ${standby_mds_node_ip}
#                               Set Global Variable    ${standby_mds_node_ip}
#                               
#
#
#
#        ###  Get INET IP  ###
#        ${inet_ip}     PCC.Get CEPH Inet IP
#                       ...    hostip=${mon_node_ip_2}
#
#                       Log To Console    ${inet_ip}
#                       Set Global Variable    ${inet_ip}
#
#        ###  Get Stored size before mount  ###
#        ${size_replicated_pool_before_mount}      PCC.Get Stored Size for Replicated Pool
#                                                  ...    hostip=${mon_node_ip_2}
#                                                  ...    pool_name=pool-3-usecase
#
#                                                  Log To Console    ${size_replicated_pool_before_mount}
#                                                  Set Suite Variable    ${size_replicated_pool_before_mount}
#
#        ###  Mount FS to Mount Point  ###
#
#
#        ${status}    Create mount folder
#                     ...    mount_folder_name=test_fs_mnt
#                     ...    hostip=${osd_node_ip_1}
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}
#
#                     Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    1 minutes 
#
#        ${status}      Create dummy file and copy to mount path
#                       ...    dummy_file_name=test_fs_mnt_10mb.bin
#                       ...    dummy_file_size=10MiB
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}  
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK     
#
#                       Sleep    3 minutes  
#
#
#        ###  Get Stored size after mount  ###
#        ${size_replicated_pool_after_mount}     PCC.Get Stored Size for Replicated Pool
#                                                #...    hostip=172.17.2.113
#                                                ...    hostip=${mon_node_ip_2}
#                                                ...    pool_name=pool-3-usecase
#
#                                                Log To Console    ${size_replicated_pool_after_mount}
#                                                #Set Suite Variable    ${size_replicated_pool_before_mount}    0
#                                                Set Suite Variable    ${size_replicated_pool_after_mount}
#                                                Should Be True    ${size_replicated_pool_after_mount} > ${size_replicated_pool_before_mount}
#
#        ###  Reboot Node  ###               
#        ${status}    Force Restart node
#                     ...    hostip=${mon_node_ip_2}
#                     #...    hostip=172.17.2.113   
#                     ...    username=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}
#                     ...    time_to_wait=180
#
#                     Log To Console    ${status}
#
#        ###  Get Stored size after reboot  ###
#        ${size_replicated_pool_after_reboot}     PCC.Get Stored Size for Replicated Pool
#                                                ...    hostip=${mon_node_ip_2}
#                                                #...    hostip=172.17.2.113
#                                                ...    pool_name=pool-3-usecase
#
#                                                Log To Console    ${size_replicated_pool_after_reboot}
#                                                Set Suite Variable    ${size_replicated_pool_after_reboot}
#                                                #Set Suite Variable    ${size_replicated_pool_after_mount}    1000
#                                                Should Be Equal As Strings    ${size_replicated_pool_after_reboot}    ${size_replicated_pool_after_mount}
#
#        ###  Check FS mount on other server  ###
#
#        ${status}      PCC.Check FS Mount on other server
#                       ...    hostip=${osd_node_ip_2}
#                       #...    hostip=172.17.2.113
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    dummy_file_name=test_fs_mnt_10mb.bin
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    3 minutes
#
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#        ###  Creating dummy file and copy to mount path and check stored size of primary pool  ###
#
#         ${status}     Create dummy file and copy to mount path
#                       ...    dummy_file_name=test_fs_mnt_2mb.bin
#                       ...    dummy_file_size=2MiB
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1} 
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}  
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK     
#
#                       Sleep    3 minutes
#
#
#        ###  Get Stored size after file copy  ###
#        ${size_replicated_pool_after_file_copy}     PCC.Get Stored Size for Replicated Pool
#                                                    ...    hostip=${mon_node_ip_2}
#                                                    #...    hostip=172.17.2.113
#                                                    ...    pool_name=pool-3-usecase
#
#                                                    Log To Console    ${size_replicated_pool_after_file_copy}
#                                                    Set Global Variable    ${size_replicated_pool_after_file_copy}
#                                                    #Set Suite Variable    ${size_replicated_pool_after_mount}    1000
#                                                    Should Be True    ${size_replicated_pool_after_file_copy} > ${size_replicated_pool_after_mount}
#
#        ###  Unmount FS and removing file created while FS mount ###                                            
#        ${status}      PCC.Unmount FS
#                       ...    hostip=${mon_node_ip_2} 
#                       #...    hostip=172.17.2.113
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK    
#
#        ${status}      PCC.Unmount FS
#                       ...    hostip=${osd_node_ip_1} 
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK      
#
#         ${status}    Remove dummy file
#                     ...    dummy_file_name=test_fs_mnt_10mb.bin
#                     ...    hostip=${mon_node_ip_2} 
#                     #...    hostip=172.17.2.112
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}         
#
#         ${status}    Remove dummy file
#                     ...    hostip=${osd_node_ip_1} 
#                     #...    hostip=172.17.2.112
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD} 
#                     ...    dummy_file_name=test_fs_mnt_2mb.bin
#
#                     Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#          ${status}    PCC.Ceph Delete All Fs
#                       Should Be Equal     ${status}  OK
#
#          ${pool_id}    PCC.Ceph Get Pool Id
#                        ...  name=pool-3-usecase
#
#          ${response}    PCC.Ceph Delete Pool
#                         ...  id=${pool_id}
#
#                         ${status_code}    Get Response Status Code    ${response}     
#                         Should Be Equal As Strings      ${status_code}  200
#
#          ${status}    PCC.Ceph Wait Until Pool Deleted
#                       ...  id=${pool_id}
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#       
#         
####################################################################################################################################
#CephFS - Create CephFS, mount to Client, copy some data on it and reboot one OSD node (TCP-1068)
####################################################################################################################################        
#
#        
#        ### Creating Pool for usecase ###
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}        
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=pool-3-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=GiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=pool-3-usecase
#                                    Should Be Equal As Strings      ${status}    OK 
#        
#        
#        ###  Create CEPH FS  ###
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${meta}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-1-usecase
#
#        ${data}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-2-usecase
#
#        ${default}                  PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-3-usecase
#
#        ${response}                 PCC.Ceph Create Fs
#                               ...  name=fs-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  metadata_pool=${meta}
#                               ...  data_pool=[${data}]
#                               ...  default_pool=${default}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}              PCC.Ceph Wait Until Fs Ready
#                               ...  name=fs-usecase
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
##        ${status}               PCC.Ceph Fs Verify BE
##                                ...  name=fs-usecase
##                                ...  user=${PCC_LINUX_USER}
##                                ...  password=${PCC_LINUX_PASSWORD}
##                                ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
##
##                                Should Be Equal As Strings      ${status}    OK
#        
#        ###  Get MON nodes  ###
#
#        Set Global Variable    ${mon_node_ip_1}    172.17.2.112
#        Set Global Variable    ${mon_node_ip_2}    172.17.2.113
#
#
#
#        ###  Get OSD nodes  ###
#
#        Set Global Variable    ${osd_node_ip_1}    172.17.2.112
#        Set Global Variable    ${osd_node_ip_2}    172.17.2.113
#        
#        
#        ###  Get INET IP  ###
#        ${inet_ip}     PCC.Get CEPH Inet IP
#                       ...    hostip=${mon_node_ip_2}
#
#                       Log To Console    ${inet_ip}
#                       Set Global Variable    ${inet_ip}
#
#        ###  Get Stored size before mount  ###
#        ${size_replicated_pool_before_mount}      PCC.Get Stored Size for Replicated Pool
#                                                  ...    hostip=${mon_node_ip_2}
#                                                  ...    pool_name=pool-3-usecase
#
#                                                  Log To Console    ${size_replicated_pool_before_mount}
#                                                  Set Suite Variable    ${size_replicated_pool_before_mount}
#
#        ###  Mount FS to Mount Point  ###
#
#
#        ${status}    Create mount folder
#                     ...    mount_folder_name=test_fs_mnt
#                     ...    hostip=${osd_node_ip_1}
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}
#
#                     Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    1 minutes 
#
#        ${status}      Create dummy file and copy to mount path
#                       ...    dummy_file_name=test_fs_mnt_10mb.bin
#                       ...    dummy_file_size=10MiB
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}  
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK     
#
#                       Sleep    3 minutes  
#
#
#        ###  Get Stored size after mount  ###
#        ${size_replicated_pool_after_mount}     PCC.Get Stored Size for Replicated Pool
#                                                #...    hostip=172.17.2.113
#                                                ...    hostip=${mon_node_ip_2}
#                                                ...    pool_name=pool-3-usecase
#
#                                                Log To Console    ${size_replicated_pool_after_mount}
#                                                #Set Suite Variable    ${size_replicated_pool_before_mount}    0
#                                                Set Suite Variable    ${size_replicated_pool_after_mount}
#                                                Should Be True    ${size_replicated_pool_after_mount} > ${size_replicated_pool_before_mount}
#
#        ###  Reboot Node  ###               
#        ${status}    Force Restart node
#                     ...    hostip=${osd_node_ip_1}
#                     #...    hostip=172.17.2.113   
#                     ...    username=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}
#                     ...    time_to_wait=180
#
#                     Log To Console    ${status}
#
#        ###  Get Stored size after reboot  ###
#        ${size_replicated_pool_after_reboot}     PCC.Get Stored Size for Replicated Pool
#                                                ...    hostip=${mon_node_ip_2}
#                                                #...    hostip=172.17.2.113
#                                                ...    pool_name=pool-3-usecase
#
#                                                Log To Console    ${size_replicated_pool_after_reboot}
#                                                Set Suite Variable    ${size_replicated_pool_after_reboot}
#                                                #Set Suite Variable    ${size_replicated_pool_after_mount}    1000
#                                                Should Be Equal As Strings    ${size_replicated_pool_after_reboot}    ${size_replicated_pool_after_mount}
#
#        ###  Check FS mount on other server  ###
#
#        ${status}      PCC.Check FS Mount on other server
#                       ...    hostip=${osd_node_ip_2}
#                       #...    hostip=172.17.2.113
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    dummy_file_name=test_fs_mnt_10mb.bin
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    3 minutes
#
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#        ###  Creating dummy file and copy to mount path and check stored size of primary pool  ###
#
#         ${status}     Create dummy file and copy to mount path
#                       ...    dummy_file_name=test_fs_mnt_2mb.bin
#                       ...    dummy_file_size=2MiB
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1} 
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}  
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK     
#
#                       Sleep    3 minutes
#
#
#        ###  Get Stored size after file copy  ###
#        ${size_replicated_pool_after_file_copy}     PCC.Get Stored Size for Replicated Pool
#                                                    ...    hostip=${mon_node_ip_2}
#                                                    #...    hostip=172.17.2.113
#                                                    ...    pool_name=pool-3-usecase
#
#                                                    Log To Console    ${size_replicated_pool_after_file_copy}
#                                                    Set Global Variable    ${size_replicated_pool_after_file_copy}
#                                                    #Set Suite Variable    ${size_replicated_pool_after_mount}    1000
#                                                    Should Be True    ${size_replicated_pool_after_file_copy} > ${size_replicated_pool_after_mount}
#
#        ###  Unmount FS and removing file created while FS mount ###                                            
#        ${status}      PCC.Unmount FS
#                       ...    hostip=${mon_node_ip_2} 
#                       #...    hostip=172.17.2.113
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK    
#
#        ${status}      PCC.Unmount FS
#                       ...    hostip=${osd_node_ip_1} 
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK      
#
#         ${status}    Remove dummy file
#                     ...    dummy_file_name=test_fs_mnt_10mb.bin
#                     ...    hostip=${mon_node_ip_2} 
#                     #...    hostip=172.17.2.112
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}         
#
#         ${status}    Remove dummy file
#                     ...    hostip=${osd_node_ip_1} 
#                     #...    hostip=172.17.2.112
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD} 
#                     ...    dummy_file_name=test_fs_mnt_2mb.bin
#
#                     Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#          ${status}    PCC.Ceph Delete All Fs
#                       Should Be Equal     ${status}  OK
#
#          ${pool_id}    PCC.Ceph Get Pool Id
#                        ...  name=pool-3-usecase
#
#          ${response}    PCC.Ceph Delete Pool
#                         ...  id=${pool_id}
#
#                         ${status_code}    Get Response Status Code    ${response}     
#                         Should Be Equal As Strings      ${status_code}  200
#
#          ${status}    PCC.Ceph Wait Until Pool Deleted
#                       ...  id=${pool_id}
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#                                                    
####################################################################################################################################
#CephFS - Create CephFS, mount to Client, copy some data on it and reboot one active MDS node (TCP-1070, 1072)
####################################################################################################################################        
#           
#
#        [Tags]    Only
#        
#        ### Creating Pool for usecase ###
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}        
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=pool-3-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=GiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=pool-3-usecase
#                                    Should Be Equal As Strings      ${status}    OK 
#        
#        
#        ###  Create CEPH FS  ###
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${meta}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-1-usecase
#
#        ${data}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-2-usecase
#
#        ${default}                  PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-3-usecase
#
#        ${response}                 PCC.Ceph Create Fs
#                               ...  name=fs-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  metadata_pool=${meta}
#                               ...  data_pool=[${data}]
#                               ...  default_pool=${default}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}              PCC.Ceph Wait Until Fs Ready
#                               ...  name=fs-usecase
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
##        ${status}               PCC.Ceph Fs Verify BE
##                                ...  name=fs-usecase
##                                ...  user=${PCC_LINUX_USER}
##                                ...  password=${PCC_LINUX_PASSWORD}
##                                ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
##
##                                Should Be Equal As Strings      ${status}    OK
#        
#        ###  Get MON nodes  ###
#
#        Set Global Variable    ${mon_node_ip_1}    172.17.2.112
#        Set Global Variable    ${mon_node_ip_2}    172.17.2.113
#
#
#
#        ###  Get OSD nodes  ###
#
#        Set Global Variable    ${osd_node_ip_1}    172.17.2.112
#        Set Global Variable    ${osd_node_ip_2}    172.17.2.113
#        
#        
#        ###  Get MDS nodes  ###
#
#        Set Global Variable    ${active_mds_node}    172.17.2.112
#        Set Global Variable    ${standby_mds_node}    172.17.2.113
#        
#        ###  Get Active MDS nodes  ###
#        
#        Set Global Variable    ${active_mds_node_ip}    172.17.2.59
#        
#        ###  Get Standby MDS nodes  ###
#        
#        Set Global Variable    ${standby_mds_node_ip}    172.17.2.112
#        
#        ###  Get INET IP  ###
#        ${inet_ip}     PCC.Get CEPH Inet IP
#                       ...    hostip=${mon_node_ip_2}
#
#                       Log To Console    ${inet_ip}
#                       Set Global Variable    ${inet_ip}
#
#        ###  Get Stored size before mount  ###
#        ${size_replicated_pool_before_mount}      PCC.Get Stored Size for Replicated Pool
#                                                  ...    hostip=${mon_node_ip_2}
#                                                  ...    pool_name=pool-3-usecase
#
#                                                  Log To Console    ${size_replicated_pool_before_mount}
#                                                  Set Suite Variable    ${size_replicated_pool_before_mount}
#
#        ###  Mount FS to Mount Point  ###
#
#
#        ${status}    Create mount folder
#                     ...    mount_folder_name=test_fs_mnt
#                     ...    hostip=${osd_node_ip_1}
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}
#
#                     Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    1 minutes 
#
#        ${status}      Create dummy file and copy to mount path
#                       ...    dummy_file_name=test_fs_mnt_10mb.bin
#                       ...    dummy_file_size=10MiB
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}  
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK     
#
#                       Sleep    3 minutes  
#
#
#        ###  Get Stored size after mount  ###
#        ${size_replicated_pool_after_mount}     PCC.Get Stored Size for Replicated Pool
#                                                #...    hostip=172.17.2.113
#                                                ...    hostip=${mon_node_ip_2}
#                                                ...    pool_name=pool-3-usecase
#
#                                                Log To Console    ${size_replicated_pool_after_mount}
#                                                #Set Suite Variable    ${size_replicated_pool_before_mount}    0
#                                                Set Suite Variable    ${size_replicated_pool_after_mount}
#                                                Should Be True    ${size_replicated_pool_after_mount} > ${size_replicated_pool_before_mount}
#
#        ###  Reboot Node  ###               
#        ${status}    Force Restart node
#                     ...    hostip=${active_mds_node_ip}
#                     #...    hostip=172.17.2.113   
#                     ...    username=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}
#                     ...    time_to_wait=180
#
#                     Log To Console    ${status}
#
#        ###  Get Stored size after reboot  ###
#        ${size_replicated_pool_after_reboot}     PCC.Get Stored Size for Replicated Pool
#                                                ...    hostip=${mon_node_ip_2}
#                                                #...    hostip=172.17.2.113
#                                                ...    pool_name=pool-3-usecase
#
#                                                Log To Console    ${size_replicated_pool_after_reboot}
#                                                Set Suite Variable    ${size_replicated_pool_after_reboot}
#                                                #Set Suite Variable    ${size_replicated_pool_after_mount}    1000
#                                                Should Be Equal As Strings    ${size_replicated_pool_after_reboot}    ${size_replicated_pool_after_mount}
#
#        ###  Check FS mount on other server  ###
#
#        ${status}      PCC.Check FS Mount on other server
#                       ...    hostip=${osd_node_ip_2}
#                       #...    hostip=172.17.2.113
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    dummy_file_name=test_fs_mnt_10mb.bin
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    3 minutes
#
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#        ###  Creating dummy file and copy to mount path and check stored size of primary pool  ###
#
#         ${status}     Create dummy file and copy to mount path
#                       ...    dummy_file_name=test_fs_mnt_2mb.bin
#                       ...    dummy_file_size=2MiB
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1} 
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}  
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK     
#
#                       Sleep    3 minutes
#
#
#        ###  Get Stored size after file copy  ###
#        ${size_replicated_pool_after_file_copy}     PCC.Get Stored Size for Replicated Pool
#                                                    ...    hostip=${mon_node_ip_2}
#                                                    #...    hostip=172.17.2.113
#                                                    ...    pool_name=pool-3-usecase
#
#                                                    Log To Console    ${size_replicated_pool_after_file_copy}
#                                                    Set Global Variable    ${size_replicated_pool_after_file_copy}
#                                                    #Set Suite Variable    ${size_replicated_pool_after_mount}    1000
#                                                    Should Be True    ${size_replicated_pool_after_file_copy} > ${size_replicated_pool_after_mount}
#
#        ###  Unmount FS and removing file created while FS mount ###                                            
#        ${status}      PCC.Unmount FS
#                       ...    hostip=${mon_node_ip_2} 
#                       #...    hostip=172.17.2.113
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK    
#
#        ${status}      PCC.Unmount FS
#                       ...    hostip=${osd_node_ip_1} 
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK      
#
#         ${status}    Remove dummy file
#                     ...    dummy_file_name=test_fs_mnt_10mb.bin
#                     ...    hostip=${mon_node_ip_2} 
#                     #...    hostip=172.17.2.112
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}         
#
#         ${status}    Remove dummy file
#                     ...    hostip=${osd_node_ip_1} 
#                     #...    hostip=172.17.2.112
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD} 
#                     ...    dummy_file_name=test_fs_mnt_2mb.bin
#
#                     Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#          ${status}    PCC.Ceph Delete All Fs
#                       Should Be Equal     ${status}  OK
#
#          ${pool_id}    PCC.Ceph Get Pool Id
#                        ...  name=pool-3-usecase
#
#          ${response}    PCC.Ceph Delete Pool
#                         ...  id=${pool_id}
#
#                         ${status_code}    Get Response Status Code    ${response}     
#                         Should Be Equal As Strings      ${status_code}  200
#
#          ${status}    PCC.Ceph Wait Until Pool Deleted
#                       ...  id=${pool_id}
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#                       
####################################################################################################################################
#CephFS - Create CephFS, mount to Client, copy some data on it and reboot one spare MDS node (TCP-1494)
####################################################################################################################################        
#           
#
#        [Tags]    Only
#        
#        ### Creating Pool for usecase ###
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}        
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=pool-3-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=GiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=pool-3-usecase
#                                    Should Be Equal As Strings      ${status}    OK 
#        
#        
#        ###  Create CEPH FS  ###
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${meta}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-1-usecase
#
#        ${data}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-2-usecase
#
#        ${default}                  PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-3-usecase
#
#        ${response}                 PCC.Ceph Create Fs
#                               ...  name=fs-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  metadata_pool=${meta}
#                               ...  data_pool=[${data}]
#                               ...  default_pool=${default}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}              PCC.Ceph Wait Until Fs Ready
#                               ...  name=fs-usecase
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
##        ${status}               PCC.Ceph Fs Verify BE
##                                ...  name=fs-usecase
##                                ...  user=${PCC_LINUX_USER}
##                                ...  password=${PCC_LINUX_PASSWORD}
##                                ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
##
##                                Should Be Equal As Strings      ${status}    OK
#        
#        ###  Get MON nodes  ###
#
#        Set Global Variable    ${mon_node_ip_1}    172.17.2.112
#        Set Global Variable    ${mon_node_ip_2}    172.17.2.113
#
#
#
#        ###  Get OSD nodes  ###
#
#        Set Global Variable    ${osd_node_ip_1}    172.17.2.112
#        Set Global Variable    ${osd_node_ip_2}    172.17.2.113
#        
#        
#        ###  Get MDS nodes  ###
#
#        Set Global Variable    ${active_mds_node}    172.17.2.112
#        Set Global Variable    ${standby_mds_node}    172.17.2.113
#        
#        ###  Get Active MDS nodes  ###
#        
#        Set Global Variable    ${active_mds_node_ip}    172.17.2.59
#        
#        ###  Get Standby MDS nodes  ###
#        
#        Set Global Variable    ${standby_mds_node_ip}    172.17.2.112
#        
#        ###  Get INET IP  ###
#        ${inet_ip}     PCC.Get CEPH Inet IP
#                       ...    hostip=${mon_node_ip_2}
#
#                       Log To Console    ${inet_ip}
#                       Set Global Variable    ${inet_ip}
#
#        ###  Get Stored size before mount  ###
#        ${size_replicated_pool_before_mount}      PCC.Get Stored Size for Replicated Pool
#                                                  ...    hostip=${mon_node_ip_2}
#                                                  ...    pool_name=pool-3-usecase
#
#                                                  Log To Console    ${size_replicated_pool_before_mount}
#                                                  Set Suite Variable    ${size_replicated_pool_before_mount}
#
#        ###  Mount FS to Mount Point  ###
#
#
#        ${status}    Create mount folder
#                     ...    mount_folder_name=test_fs_mnt
#                     ...    hostip=${osd_node_ip_1}
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}
#
#                     Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    1 minutes 
#
#        ${status}      Create dummy file and copy to mount path
#                       ...    dummy_file_name=test_fs_mnt_10mb.bin
#                       ...    dummy_file_size=10MiB
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}  
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK     
#
#                       Sleep    3 minutes  
#
#
#        ###  Get Stored size after mount  ###
#        ${size_replicated_pool_after_mount}     PCC.Get Stored Size for Replicated Pool
#                                                #...    hostip=172.17.2.113
#                                                ...    hostip=${mon_node_ip_2}
#                                                ...    pool_name=pool-3-usecase
#
#                                                Log To Console    ${size_replicated_pool_after_mount}
#                                                #Set Suite Variable    ${size_replicated_pool_before_mount}    0
#                                                Set Suite Variable    ${size_replicated_pool_after_mount}
#                                                Should Be True    ${size_replicated_pool_after_mount} > ${size_replicated_pool_before_mount}
#
#        ###  Reboot Node  ###               
#        ${status}    Force Restart node
#                     ...    hostip=${standby_mds_node_ip}
#                     #...    hostip=172.17.2.113   
#                     ...    username=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}
#                     ...    time_to_wait=180
#
#                     Log To Console    ${status}
#
#        ###  Get Stored size after reboot  ###
#        ${size_replicated_pool_after_reboot}     PCC.Get Stored Size for Replicated Pool
#                                                ...    hostip=${mon_node_ip_2}
#                                                #...    hostip=172.17.2.113
#                                                ...    pool_name=pool-3-usecase
#
#                                                Log To Console    ${size_replicated_pool_after_reboot}
#                                                Set Suite Variable    ${size_replicated_pool_after_reboot}
#                                                #Set Suite Variable    ${size_replicated_pool_after_mount}    1000
#                                                Should Be Equal As Strings    ${size_replicated_pool_after_reboot}    ${size_replicated_pool_after_mount}
#
#        ###  Check FS mount on other server  ###
#
#        ${status}      PCC.Check FS Mount on other server
#                       ...    hostip=${osd_node_ip_2}
#                       #...    hostip=172.17.2.113
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    dummy_file_name=test_fs_mnt_10mb.bin
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    3 minutes
#
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#        ###  Creating dummy file and copy to mount path and check stored size of primary pool  ###
#
#         ${status}     Create dummy file and copy to mount path
#                       ...    dummy_file_name=test_fs_mnt_2mb.bin
#                       ...    dummy_file_size=2MiB
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1} 
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}  
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK     
#
#                       Sleep    3 minutes
#
#
#        ###  Get Stored size after file copy  ###
#        ${size_replicated_pool_after_file_copy}     PCC.Get Stored Size for Replicated Pool
#                                                    ...    hostip=${mon_node_ip_2}
#                                                    #...    hostip=172.17.2.113
#                                                    ...    pool_name=pool-3-usecase
#
#                                                    Log To Console    ${size_replicated_pool_after_file_copy}
#                                                    Set Global Variable    ${size_replicated_pool_after_file_copy}
#                                                    #Set Suite Variable    ${size_replicated_pool_after_mount}    1000
#                                                    Should Be True    ${size_replicated_pool_after_file_copy} > ${size_replicated_pool_after_mount}
#
#        ###  Unmount FS and removing file created while FS mount ###                                            
#        ${status}      PCC.Unmount FS
#                       ...    hostip=${mon_node_ip_2} 
#                       #...    hostip=172.17.2.113
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK    
#
#        ${status}      PCC.Unmount FS
#                       ...    hostip=${osd_node_ip_1} 
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK      
#
#         ${status}    Remove dummy file
#                     ...    dummy_file_name=test_fs_mnt_10mb.bin
#                     ...    hostip=${mon_node_ip_2} 
#                     #...    hostip=172.17.2.112
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}         
#
#         ${status}    Remove dummy file
#                     ...    hostip=${osd_node_ip_1} 
#                     #...    hostip=172.17.2.112
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD} 
#                     ...    dummy_file_name=test_fs_mnt_2mb.bin
#
#                     Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#          ${status}    PCC.Ceph Delete All Fs
#                       Should Be Equal     ${status}  OK
#
#          ${pool_id}    PCC.Ceph Get Pool Id
#                        ...  name=pool-3-usecase
#
#          ${response}    PCC.Ceph Delete Pool
#                         ...  id=${pool_id}
#
#                         ${status_code}    Get Response Status Code    ${response}     
#                         Should Be Equal As Strings      ${status_code}  200
#
#          ${status}    PCC.Ceph Wait Until Pool Deleted
#                       ...  id=${pool_id}
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#                       
####################################################################################################################################
#Ceph OSD node - Make all ceph daemons down on one OSD node (TCP-1540)
####################################################################################################################################        
#           
#
#        [Tags]    Only
#        
#        ### Creating Pool for usecase ###
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}        
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=pool-3-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=GiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=pool-3-usecase
#                                    Should Be Equal As Strings      ${status}    OK 
#        
#        
#        ###  Create CEPH FS  ###
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${meta}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-1-usecase
#
#        ${data}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-2-usecase
#
#        ${default}                  PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-3-usecase
#
#        ${response}                 PCC.Ceph Create Fs
#                               ...  name=fs-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  metadata_pool=${meta}
#                               ...  data_pool=[${data}]
#                               ...  default_pool=${default}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}              PCC.Ceph Wait Until Fs Ready
#                               ...  name=fs-usecase
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
##        ${status}               PCC.Ceph Fs Verify BE
##                                ...  name=fs-usecase
##                                ...  user=${PCC_LINUX_USER}
##                                ...  password=${PCC_LINUX_PASSWORD}
##                                ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
##
##                                Should Be Equal As Strings      ${status}    OK
#        
#        ###  Get MON nodes  ###
#
#        Set Global Variable    ${mon_node_ip_1}    172.17.2.112
#        Set Global Variable    ${mon_node_ip_2}    172.17.2.113
#
#
#
#        ###  Get OSD nodes  ###
#
#        Set Global Variable    ${osd_node_ip_1}    172.17.2.112
#        Set Global Variable    ${osd_node_ip_2}    172.17.2.113
#        
#        
#        ###  Get MDS nodes  ###
#
#        Set Global Variable    ${active_mds_node}    172.17.2.112
#        Set Global Variable    ${standby_mds_node}    172.17.2.113
#        
#        ###  Get Active MDS nodes  ###
#        
#        Set Global Variable    ${active_mds_node_ip}    172.17.2.59
#        
#        ###  Get Standby MDS nodes  ###
#        
#        Set Global Variable    ${standby_mds_node_ip}    172.17.2.112
#        
#        ###  Get INET IP  ###
#        ${inet_ip}     PCC.Get CEPH Inet IP
#                       ...    hostip=${mon_node_ip_2}
#
#                       Log To Console    ${inet_ip}
#                       Set Global Variable    ${inet_ip}
#
#        ###  Get Stored size before mount  ###
#        ${size_replicated_pool_before_mount}      PCC.Get Stored Size for Replicated Pool
#                                                  ...    hostip=${mon_node_ip_2}
#                                                  ...    pool_name=pool-3-usecase
#
#                                                  Log To Console    ${size_replicated_pool_before_mount}
#                                                  Set Suite Variable    ${size_replicated_pool_before_mount}
#
#        ###  Mount FS to Mount Point  ###
#
#
#        ${status}    Create mount folder
#                     ...    mount_folder_name=test_fs_mnt
#                     ...    hostip=${osd_node_ip_1}
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}
#
#                     Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    1 minutes 
#
#        ${status}      Create dummy file and copy to mount path
#                       ...    dummy_file_name=test_fs_mnt_10mb.bin
#                       ...    dummy_file_size=10MiB
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}  
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK     
#
#                       Sleep    3 minutes  
#
#
#        ###  Get Stored size after mount  ###
#        ${size_replicated_pool_after_mount}     PCC.Get Stored Size for Replicated Pool
#                                                #...    hostip=172.17.2.113
#                                                ...    hostip=${mon_node_ip_2}
#                                                ...    pool_name=pool-3-usecase
#
#                                                Log To Console    ${size_replicated_pool_after_mount}
#                                                #Set Suite Variable    ${size_replicated_pool_before_mount}    0
#                                                Set Suite Variable    ${size_replicated_pool_after_mount}
#                                                Should Be True    ${size_replicated_pool_after_mount} > ${size_replicated_pool_before_mount}
#
#        ###  Stop all CEPH daemons  ###               
#        ${status}                   PCC.Operation to perform on All OSD Daemons Of Node
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  operation_to_perform=stop 
#                               ...  hostip=${osd_node_ip_1}
#                               
#                               Log To Console   ${status}
#                               Should be equal as strings    ${status}    OK 
#
#        ###  Get Stored size after reboot  ###
#        ${size_replicated_pool_after_reboot}     PCC.Get Stored Size for Replicated Pool
#                                                ...    hostip=${mon_node_ip_2}
#                                                #...    hostip=172.17.2.113
#                                                ...    pool_name=pool-3-usecase
#
#                                                Log To Console    ${size_replicated_pool_after_reboot}
#                                                Set Suite Variable    ${size_replicated_pool_after_reboot}
#                                                #Set Suite Variable    ${size_replicated_pool_after_mount}    1000
#                                                Should Be Equal As Strings    ${size_replicated_pool_after_reboot}    ${size_replicated_pool_after_mount}
#
#        ###  Check FS mount on other server  ###
#
#        ${status}      PCC.Check FS Mount on other server
#                       ...    hostip=${osd_node_ip_2}
#                       #...    hostip=172.17.2.113
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    dummy_file_name=test_fs_mnt_10mb.bin
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    3 minutes
#
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#        ###  Creating dummy file and copy to mount path and check stored size of primary pool  ###
#
#         ${status}     Create dummy file and copy to mount path
#                       ...    dummy_file_name=test_fs_mnt_2mb.bin
#                       ...    dummy_file_size=2MiB
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1} 
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}  
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK     
#
#                       Sleep    3 minutes
#
#
#        ###  Get Stored size after file copy  ###
#        ${size_replicated_pool_after_file_copy}     PCC.Get Stored Size for Replicated Pool
#                                                    ...    hostip=${mon_node_ip_2}
#                                                    #...    hostip=172.17.2.113
#                                                    ...    pool_name=pool-3-usecase
#
#                                                    Log To Console    ${size_replicated_pool_after_file_copy}
#                                                    Set Global Variable    ${size_replicated_pool_after_file_copy}
#                                                    #Set Suite Variable    ${size_replicated_pool_after_mount}    1000
#                                                    Should Be True    ${size_replicated_pool_after_file_copy} > ${size_replicated_pool_after_mount}
#                                                    
#        ###  Start all CEPH daemons  ###               
#        ${status}                   PCC.Operation to perform on All OSD Daemons Of Node
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  operation_to_perform=start 
#                               ...  hostip=${osd_node_ip_1}
#                               
#                               Log To Console   ${status}
#                               Should be equal as strings    ${status}    OK
#
#        ###  Unmount FS and removing file created while FS mount ###                                            
#        ${status}      PCC.Unmount FS
#                       ...    hostip=${mon_node_ip_2} 
#                       #...    hostip=172.17.2.113
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK    
#
#        ${status}      PCC.Unmount FS
#                       ...    hostip=${osd_node_ip_1} 
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK      
#
#         ${status}    Remove dummy file
#                     ...    dummy_file_name=test_fs_mnt_10mb.bin
#                     ...    hostip=${mon_node_ip_2} 
#                     #...    hostip=172.17.2.112
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}         
#
#         ${status}    Remove dummy file
#                     ...    hostip=${osd_node_ip_1} 
#                     #...    hostip=172.17.2.112
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD} 
#                     ...    dummy_file_name=test_fs_mnt_2mb.bin
#
#                     Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#          ${status}    PCC.Ceph Delete All Fs
#                       Should Be Equal     ${status}  OK
#
#          ${pool_id}    PCC.Ceph Get Pool Id
#                        ...  name=pool-3-usecase
#
#          ${response}    PCC.Ceph Delete Pool
#                         ...  id=${pool_id}
#
#                         ${status_code}    Get Response Status Code    ${response}     
#                         Should Be Equal As Strings      ${status_code}  200
#
#          ${status}    PCC.Ceph Wait Until Pool Deleted
#                       ...  id=${pool_id}
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#                       
####################################################################################################################################
#Ceph OSD node - Make all ceph daemons down on one active MDS node (TCP-1541)
####################################################################################################################################        
#           
#
#        [Tags]    Only
#        
#        ### Creating Pool for usecase ###
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}        
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=pool-3-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=GiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=pool-3-usecase
#                                    Should Be Equal As Strings      ${status}    OK 
#        
#        
#        ###  Create CEPH FS  ###
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${meta}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-1-usecase
#
#        ${data}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-2-usecase
#
#        ${default}                  PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-3-usecase
#
#        ${response}                 PCC.Ceph Create Fs
#                               ...  name=fs-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  metadata_pool=${meta}
#                               ...  data_pool=[${data}]
#                               ...  default_pool=${default}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}              PCC.Ceph Wait Until Fs Ready
#                               ...  name=fs-usecase
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
##        ${status}               PCC.Ceph Fs Verify BE
##                                ...  name=fs-usecase
##                                ...  user=${PCC_LINUX_USER}
##                                ...  password=${PCC_LINUX_PASSWORD}
##                                ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
##
##                                Should Be Equal As Strings      ${status}    OK
#        
#        ###  Get MON nodes  ###
#
#        Set Global Variable    ${mon_node_ip_1}    172.17.2.112
#        Set Global Variable    ${mon_node_ip_2}    172.17.2.113
#
#
#
#        ###  Get OSD nodes  ###
#
#        Set Global Variable    ${osd_node_ip_1}    172.17.2.112
#        Set Global Variable    ${osd_node_ip_2}    172.17.2.113
#        
#        
#        ###  Get MDS nodes  ###
#
#        Set Global Variable    ${active_mds_node}    172.17.2.112
#        Set Global Variable    ${standby_mds_node}    172.17.2.113
#        
#        ###  Get Active MDS nodes  ###
#        
#        Set Global Variable    ${active_mds_node_ip}    172.17.2.59
#        
#        ###  Get Standby MDS nodes  ###
#        
#        Set Global Variable    ${standby_mds_node_ip}    172.17.2.112
#        
#        ###  Get INET IP  ###
#        ${inet_ip}     PCC.Get CEPH Inet IP
#                       ...    hostip=${mon_node_ip_2}
#
#                       Log To Console    ${inet_ip}
#                       Set Global Variable    ${inet_ip}
#
#        ###  Get Stored size before mount  ###
#        ${size_replicated_pool_before_mount}      PCC.Get Stored Size for Replicated Pool
#                                                  ...    hostip=${mon_node_ip_2}
#                                                  ...    pool_name=pool-3-usecase
#
#                                                  Log To Console    ${size_replicated_pool_before_mount}
#                                                  Set Suite Variable    ${size_replicated_pool_before_mount}
#
#        ###  Mount FS to Mount Point  ###
#
#
#        ${status}    Create mount folder
#                     ...    mount_folder_name=test_fs_mnt
#                     ...    hostip=${osd_node_ip_1}
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}
#
#                     Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    1 minutes 
#
#        ${status}      Create dummy file and copy to mount path
#                       ...    dummy_file_name=test_fs_mnt_10mb.bin
#                       ...    dummy_file_size=10MiB
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}  
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK     
#
#                       Sleep    3 minutes  
#
#
#        ###  Get Stored size after mount  ###
#        ${size_replicated_pool_after_mount}     PCC.Get Stored Size for Replicated Pool
#                                                #...    hostip=172.17.2.113
#                                                ...    hostip=${mon_node_ip_2}
#                                                ...    pool_name=pool-3-usecase
#
#                                                Log To Console    ${size_replicated_pool_after_mount}
#                                                #Set Suite Variable    ${size_replicated_pool_before_mount}    0
#                                                Set Suite Variable    ${size_replicated_pool_after_mount}
#                                                Should Be True    ${size_replicated_pool_after_mount} > ${size_replicated_pool_before_mount}
#
#        ###  Stop all CEPH daemons  ###               
#        ${status}                   PCC.Operation to perform on All OSD Daemons Of Node
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  operation_to_perform=stop 
#                               ...  hostip=${active_mds_node_ip}
#                               
#                               Log To Console   ${status}
#                               Should be equal as strings    ${status}    OK 
#
#        ###  Get Stored size after reboot  ###
#        ${size_replicated_pool_after_reboot}     PCC.Get Stored Size for Replicated Pool
#                                                ...    hostip=${mon_node_ip_2}
#                                                #...    hostip=172.17.2.113
#                                                ...    pool_name=pool-3-usecase
#
#                                                Log To Console    ${size_replicated_pool_after_reboot}
#                                                Set Suite Variable    ${size_replicated_pool_after_reboot}
#                                                #Set Suite Variable    ${size_replicated_pool_after_mount}    1000
#                                                Should Be Equal As Strings    ${size_replicated_pool_after_reboot}    ${size_replicated_pool_after_mount}
#
#        ###  Check FS mount on other server  ###
#
#        ${status}      PCC.Check FS Mount on other server
#                       ...    hostip=${osd_node_ip_2}
#                       #...    hostip=172.17.2.113
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    dummy_file_name=test_fs_mnt_10mb.bin
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    3 minutes
#
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#        ###  Creating dummy file and copy to mount path and check stored size of primary pool  ###
#
#         ${status}     Create dummy file and copy to mount path
#                       ...    dummy_file_name=test_fs_mnt_2mb.bin
#                       ...    dummy_file_size=2MiB
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1} 
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}  
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK     
#
#                       Sleep    3 minutes
#
#
#        ###  Get Stored size after file copy  ###
#        ${size_replicated_pool_after_file_copy}     PCC.Get Stored Size for Replicated Pool
#                                                    ...    hostip=${mon_node_ip_2}
#                                                    #...    hostip=172.17.2.113
#                                                    ...    pool_name=pool-3-usecase
#
#                                                    Log To Console    ${size_replicated_pool_after_file_copy}
#                                                    Set Global Variable    ${size_replicated_pool_after_file_copy}
#                                                    #Set Suite Variable    ${size_replicated_pool_after_mount}    1000
#                                                    Should Be True    ${size_replicated_pool_after_file_copy} > ${size_replicated_pool_after_mount}
#                                                    
#        ###  Start all CEPH daemons  ###               
#        ${status}                   PCC.Operation to perform on All OSD Daemons Of Node
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  operation_to_perform=start 
#                               ...  hostip=${active_mds_node_ip}
#                               
#                               Log To Console   ${status}
#                               Should be equal as strings    ${status}    OK
#
#        ###  Unmount FS and removing file created while FS mount ###                                            
#        ${status}      PCC.Unmount FS
#                       ...    hostip=${mon_node_ip_2} 
#                       #...    hostip=172.17.2.113
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK    
#
#        ${status}      PCC.Unmount FS
#                       ...    hostip=${osd_node_ip_1} 
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK      
#
#         ${status}    Remove dummy file
#                     ...    dummy_file_name=test_fs_mnt_10mb.bin
#                     ...    hostip=${mon_node_ip_2} 
#                     #...    hostip=172.17.2.112
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}         
#
#         ${status}    Remove dummy file
#                     ...    hostip=${osd_node_ip_1} 
#                     #...    hostip=172.17.2.112
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD} 
#                     ...    dummy_file_name=test_fs_mnt_2mb.bin
#
#                     Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#          ${status}    PCC.Ceph Delete All Fs
#                       Should Be Equal     ${status}  OK
#
#          ${pool_id}    PCC.Ceph Get Pool Id
#                        ...  name=pool-3-usecase
#
#          ${response}    PCC.Ceph Delete Pool
#                         ...  id=${pool_id}
#
#                         ${status_code}    Get Response Status Code    ${response}     
#                         Should Be Equal As Strings      ${status_code}  200
#
#          ${status}    PCC.Ceph Wait Until Pool Deleted
#                       ...  id=${pool_id}
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#                       
####################################################################################################################################
#Ceph OSD node - Make all ceph daemons down on one spare MDS node (TCP-1549)
####################################################################################################################################        
#           
#
#        [Tags]    Only
#        
#        ### Creating Pool for usecase ###
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}        
#
#        ${response}                 PCC.Ceph Create Pool
#                               ...  name=pool-3-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=GiB
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Pool Ready
#                               ...  name=pool-3-usecase
#                                    Should Be Equal As Strings      ${status}    OK 
#        
#        
#        ###  Create CEPH FS  ###
#
#        ${cluster_id}               PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${meta}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-1-usecase
#
#        ${data}                     PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-2-usecase
#
#        ${default}                  PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-3-usecase
#
#        ${response}                 PCC.Ceph Create Fs
#                               ...  name=fs-usecase
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  metadata_pool=${meta}
#                               ...  data_pool=[${data}]
#                               ...  default_pool=${default}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}              PCC.Ceph Wait Until Fs Ready
#                               ...  name=fs-usecase
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
##        ${status}               PCC.Ceph Fs Verify BE
##                                ...  name=fs-usecase
##                                ...  user=${PCC_LINUX_USER}
##                                ...  password=${PCC_LINUX_PASSWORD}
##                                ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
##
##                                Should Be Equal As Strings      ${status}    OK
#        
#        ###  Get MON nodes  ###
#
#        Set Global Variable    ${mon_node_ip_1}    172.17.2.112
#        Set Global Variable    ${mon_node_ip_2}    172.17.2.113
#
#
#
#        ###  Get OSD nodes  ###
#
#        Set Global Variable    ${osd_node_ip_1}    172.17.2.112
#        Set Global Variable    ${osd_node_ip_2}    172.17.2.113
#        
#        
#        ###  Get MDS nodes  ###
#
#        Set Global Variable    ${active_mds_node}    172.17.2.112
#        Set Global Variable    ${standby_mds_node}    172.17.2.113
#        
#        ###  Get Active MDS nodes  ###
#        
#        Set Global Variable    ${active_mds_node_ip}    172.17.2.59
#        
#        ###  Get Standby MDS nodes  ###
#        
#        Set Global Variable    ${standby_mds_node_ip}    172.17.2.112
#        
#        ###  Get INET IP  ###
#        ${inet_ip}     PCC.Get CEPH Inet IP
#                       ...    hostip=${mon_node_ip_2}
#
#                       Log To Console    ${inet_ip}
#                       Set Global Variable    ${inet_ip}
#
#        ###  Get Stored size before mount  ###
#        ${size_replicated_pool_before_mount}      PCC.Get Stored Size for Replicated Pool
#                                                  ...    hostip=${mon_node_ip_2}
#                                                  ...    pool_name=pool-3-usecase
#
#                                                  Log To Console    ${size_replicated_pool_before_mount}
#                                                  Set Suite Variable    ${size_replicated_pool_before_mount}
#
#        ###  Mount FS to Mount Point  ###
#
#
#        ${status}    Create mount folder
#                     ...    mount_folder_name=test_fs_mnt
#                     ...    hostip=${osd_node_ip_1}
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}
#
#                     Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    1 minutes 
#
#        ${status}      Create dummy file and copy to mount path
#                       ...    dummy_file_name=test_fs_mnt_10mb.bin
#                       ...    dummy_file_size=10MiB
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}  
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK     
#
#                       Sleep    3 minutes  
#
#
#        ###  Get Stored size after mount  ###
#        ${size_replicated_pool_after_mount}     PCC.Get Stored Size for Replicated Pool
#                                                #...    hostip=172.17.2.113
#                                                ...    hostip=${mon_node_ip_2}
#                                                ...    pool_name=pool-3-usecase
#
#                                                Log To Console    ${size_replicated_pool_after_mount}
#                                                #Set Suite Variable    ${size_replicated_pool_before_mount}    0
#                                                Set Suite Variable    ${size_replicated_pool_after_mount}
#                                                Should Be True    ${size_replicated_pool_after_mount} > ${size_replicated_pool_before_mount}
#
#        ###  Stop all CEPH daemons  ###               
#        ${status}                   PCC.Operation to perform on All OSD Daemons Of Node
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  operation_to_perform=stop 
#                               ...  hostip=${standby_mds_node_ip}
#                               
#                               Log To Console   ${status}
#                               Should be equal as strings    ${status}    OK 
#
#        ###  Get Stored size after reboot  ###
#        ${size_replicated_pool_after_reboot}     PCC.Get Stored Size for Replicated Pool
#                                                ...    hostip=${mon_node_ip_2}
#                                                #...    hostip=172.17.2.113
#                                                ...    pool_name=pool-3-usecase
#
#                                                Log To Console    ${size_replicated_pool_after_reboot}
#                                                Set Suite Variable    ${size_replicated_pool_after_reboot}
#                                                #Set Suite Variable    ${size_replicated_pool_after_mount}    1000
#                                                Should Be Equal As Strings    ${size_replicated_pool_after_reboot}    ${size_replicated_pool_after_mount}
#
#        ###  Check FS mount on other server  ###
#
#        ${status}      PCC.Check FS Mount on other server
#                       ...    hostip=${osd_node_ip_2}
#                       #...    hostip=172.17.2.113
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    dummy_file_name=test_fs_mnt_10mb.bin
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    3 minutes
#
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1}
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#        ###  Creating dummy file and copy to mount path and check stored size of primary pool  ###
#
#         ${status}     Create dummy file and copy to mount path
#                       ...    dummy_file_name=test_fs_mnt_2mb.bin
#                       ...    dummy_file_size=2MiB
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${osd_node_ip_1} 
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}  
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK     
#
#                       Sleep    3 minutes
#
#
#        ###  Get Stored size after file copy  ###
#        ${size_replicated_pool_after_file_copy}     PCC.Get Stored Size for Replicated Pool
#                                                    ...    hostip=${mon_node_ip_2}
#                                                    #...    hostip=172.17.2.113
#                                                    ...    pool_name=pool-3-usecase
#
#                                                    Log To Console    ${size_replicated_pool_after_file_copy}
#                                                    Set Global Variable    ${size_replicated_pool_after_file_copy}
#                                                    #Set Suite Variable    ${size_replicated_pool_after_mount}    1000
#                                                    Should Be True    ${size_replicated_pool_after_file_copy} > ${size_replicated_pool_after_mount}
#                                                    
#        ###  Start all CEPH daemons  ###               
#        ${status}                   PCC.Operation to perform on All OSD Daemons Of Node
#                               ...  name=${CEPH_CLUSTER_NAME}
#                               ...  operation_to_perform=start 
#                               ...  hostip=${standby_mds_node_ip}
#                               
#                               Log To Console   ${status}
#                               Should be equal as strings    ${status}    OK
#
#        ###  Unmount FS and removing file created while FS mount ###                                            
#        ${status}      PCC.Unmount FS
#                       ...    hostip=${mon_node_ip_2} 
#                       #...    hostip=172.17.2.113
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK    
#
#        ${status}      PCC.Unmount FS
#                       ...    hostip=${osd_node_ip_1} 
#                       #...    hostip=172.17.2.112
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK      
#
#         ${status}    Remove dummy file
#                     ...    dummy_file_name=test_fs_mnt_10mb.bin
#                     ...    hostip=${mon_node_ip_2} 
#                     #...    hostip=172.17.2.112
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}         
#
#         ${status}    Remove dummy file
#                     ...    hostip=${osd_node_ip_1} 
#                     #...    hostip=172.17.2.112
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD} 
#                     ...    dummy_file_name=test_fs_mnt_2mb.bin
#
#                     Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#          ${status}    PCC.Ceph Delete All Fs
#                       Should Be Equal     ${status}  OK
#
#          ${pool_id}    PCC.Ceph Get Pool Id
#                        ...  name=pool-3-usecase
#
#          ${response}    PCC.Ceph Delete Pool
#                         ...  id=${pool_id}
#
#                         ${status_code}    Get Response Status Code    ${response}     
#                         Should Be Equal As Strings      ${status_code}  200
#
#          ${status}    PCC.Ceph Wait Until Pool Deleted
#                       ...  id=${pool_id}
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
