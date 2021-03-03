#*** Settings ***
#
#Resource    pcc_resources.robot
#
#*** Variables ***
#${pcc_setup}    pcc_215
#
#*** Test Cases ***
####################################################################################################################################
#Login to PCC 
####################################################################################################################################
#                
#        
#        [Documentation]    *Login to PCC* test
#        
#        [Tags]    Runonly
#        ${status}        Login To PCC    ${pcc_setup}
#                         
#                         Load Clusterhead 1 Test Data    ${pcc_setup}
#                         Load Clusterhead 2 Test Data    ${pcc_setup}
#                         Load Server 1 Test Data    ${pcc_setup}
#                         Load Server 2 Test Data    ${pcc_setup}
#                         Load Server 3 Test Data    ${pcc_setup}
#                         
#                         Load Ceph Rbd Data    ${pcc_setup}
#                         Load Ceph Pool Data    ${pcc_setup}
#                         Load Ceph Cluster Data    ${pcc_setup}
#                         Load Ceph Fs Data    ${pcc_setup}
#                         Load Network Manager Data    ${pcc_setup}
#                         
#                      
#        ${server1_id}    PCC.Get Node Id    Name=${SERVER_1_NAME}
#                         Log To Console    ${server1_id}
#                         Set Global Variable    ${server1_id}
#                         
#        ${server2_id}    PCC.Get Node Id    Name=${SERVER_2_NAME}
#                         Log To Console    ${server2_id}
#                         Set Global Variable    ${server2_id}
#                         
#        ${invader1_id}    PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
#                         Log To Console    ${invader1_id}
#                         Set Global Variable    ${invader1_id}
#                         
#############################################################################################################################################################
#Create erasure coded pools with quota size is in MiB, GiB, TiB, PiB and EiB - Also covers 4-2, 8-3 and 8-4 chunk ratio profiles  
#############################################################################################################################################################
#
#        [Documentation]    *Get Erasure Code Profile Id* test
#                           ...  keywords:
#                           ...  PCC.Get Erasure Code Profile Id
#                           ...  PCC.Ceph Get Cluster Id
#                           ...  PCC.Ceph Create Erasure Pool
#
#        [Tags]    Today
#
#
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ######### Quota Size in MiB #########
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-mib-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=MiB
#                               ...  Datachunks=4
#                               ...  Codingchunks=2
#                               
#                               
#
#        ${status_code}          Get Response Status Code        ${response}     
#                                Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-mib-1
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
##       ${status}               PCC.Ceph Erasure Pool Verify BE
##                               ...  name=ceph-erasure-pool-mib-1
##                               ...  user=${PCC_LINUX_USER}
##                               ...  password=${PCC_LINUX_PASSWORD}
##                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
##
##                               Should Be Equal As Strings      ${status}    OK
#                               Sleep    5s 
#
#        ######### Quota Size in GiB #########
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-gib-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=GiB
#                               ...  Datachunks=8
#                               ...  Codingchunks=3
#
#        ${status_code}          Get Response Status Code        ${response}     
#                                Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-gib-1
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
##        ${status}              PCC.Ceph Erasure Pool Verify BE
##                               ...  name=ceph-erasure-pool-gib-1
##                               ...  user=${PCC_LINUX_USER}
##                               ...  password=${PCC_LINUX_PASSWORD}
##                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
##
##                               Should Be Equal As Strings      ${status}    OK
#                               Sleep    5s     
#
#
#        ######### Quota Size in TiB #########
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-tib-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=TiB
#                               ...  Datachunks=8
#                               ...  Codingchunks=4
#
#        ${status_code}          Get Response Status Code        ${response}
#                                Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-tib-1
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
##        ${status}              PCC.Ceph Erasure Pool Verify BE
##                               ...  name=ceph-erasure-pool-tib-1
##                               ...  user=${PCC_LINUX_USER}
##                               ...  password=${PCC_LINUX_PASSWORD}
##                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
##
##                               Should Be Equal As Strings      ${status}    OK
#                               Sleep    5s 
#
#
#        ######### Quota Size in PiB #########
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-pib-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=PiB
#                               ...  Datachunks=4
#                               ...  Codingchunks=2
#
#        ${status_code}          Get Response Status Code        ${response}
#                                Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-pib-1
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
##        ${status}              PCC.Ceph Erasure Pool Verify BE
##                               ...  name=ceph-erasure-pool-pib-1
##                               ...  user=${PCC_LINUX_USER}
##                               ...  password=${PCC_LINUX_PASSWORD}
##                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
##
##                               Should Be Equal As Strings      ${status}    OK
#                               Sleep    5s 
#
#        ######### Quota Size in EiB #########
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-eib-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=EiB
#                               ...  Datachunks=4
#                               ...  Codingchunks=2
#
#        ${status_code}          Get Response Status Code        ${response}
#                                Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-eib-1
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
##        ${status}              PCC.Ceph Erasure Pool Verify BE
##                               ...  name=ceph-erasure-pool-eib-1
##                               ...  user=${PCC_LINUX_USER}
##                               ...  password=${PCC_LINUX_PASSWORD}
##                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
##
##                               Should Be Equal As Strings      ${status}    OK
#                               Sleep    5s
#
#############################################################################################################################################################
#Create erasure coded pool with explicit coding and data chunks (For eg. 10,6 ratio)
#############################################################################################################################################################
#
#        [Documentation]    *Get Erasure Code Profile Id* test
#                           ...  keywords:
#                           ...  PCC.Get Erasure Code Profile Id
#                           ...  PCC.Ceph Get Cluster Id
#                           ...  PCC.Ceph Create Erasure Pool
#
#        [Tags]    Today
#
#
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-explicit
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=MiB
#                               ...  Datachunks=10
#                               ...  Codingchunks=6
#                               
#        ${status_code}          Get Response Status Code        ${response}     
#                                Should Not Be Equal As Strings      ${status_code}  200
#
#
#                               
####################################################################################################################################
#Create duplicate erasure coded pool
####################################################################################################################################
#
#        [Documentation]    *Create duplicate erasure coded pool* test
#                           ...  keywords:
#                           ...  PCC.Get Erasure Code Profile Id
#                           ...  PCC.Ceph Get Cluster Id
#                           ...  PCC.Ceph Create Erasure Pool
#
#        [Tags]    Today
#        ${cluster_id}    PCC.Ceph Get Cluster Id
#                         ...  name=${CEPH_Cluster_NAME}
#
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-eib-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#                               ...  Datachunks=4
#                               ...  Codingchunks=2
#
#        ${status_code}          Get Response Status Code        ${response}     
#                                Should Not Be Equal As Strings      ${status_code}  200
#                                
####################################################################################################################################
#Create erasure coded pool without Name (Negative)
####################################################################################################################################
#
#        [Documentation]    *Create erasure coded pool without Name(Negative)* test
#                           ...  keywords:
#                           ...  PCC.Get Erasure Code Profile Id
#                           ...  PCC.Ceph Get Cluster Id
#                           ...  PCC.Ceph Create Erasure Pool
#        
#        [Tags]    Today
#        
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#                               ...  Datachunks=4
#                               ...  Codingchunks=2
#
#
#        ${status_code}          Get Response Status Code        ${response}     
#                                Should Not Be Equal As Strings      ${status_code}  200
#                                
####################################################################################################################################
#Create erasure coded pool without quota (Negative)
####################################################################################################################################
#
#        [Documentation]    *Create erasure coded pool without quota(Negative)* test
#                           ...  keywords:
#                           ...  PCC.Get Erasure Code Profile Id
#                           ...  PCC.Ceph Get Cluster Id
#                           ...  PCC.Ceph Create Erasure Pool
#        
#        [Tags]    Today
#        
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-without-quota
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#                               ...  Datachunks=4
#                               ...  Codingchunks=2
#
#
#                               Log To Console    ${response}
#
#
#        ${status_code}          Get Response Status Code        ${response}     
#                                Should Not Be Equal As Strings      ${status_code}  200
#
#
####################################################################################################################################
#Ceph Erasure Pool Update Quota Unit
####################################################################################################################################
#        [Documentation]                 *Updating Ceph Pool Size*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Get Pool Id
#                               ...  PCC.Ceph Pool Update
#                               ...  PCC.Ceph Wait Until Pool Ready
#
#        [Tags]    Today
#
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${erasure_profile_id}    PCC.Get Erasure Code Profile Id
#                                 ...    Name=ceph-erasure-pool-gib-1_ec_profile        
#
#        ${pool_id}             PCC.Ceph Get Erasure Pool Id
#                               ...  name=ceph-erasure-pool-gib-1
#
#        ${response}            PCC.Ceph Erasure Pool Update
#                               ...  id=${pool_id}
#                               ...  name=ceph-erasure-pool-gib-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=erasure
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=MiB
#                               ...  ErasureCodeProfileID=${erasure_profile_id}
#
#                               Log To Console    ${response}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-gib-1
#
#                               Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Ceph Erasure Pool Update Quota
####################################################################################################################################
#    [Documentation]                 *Updating Ceph Pool Size*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Get Pool Id
#                               ...  PCC.Ceph Pool Update
#                               ...  PCC.Ceph Wait Until Pool Ready
#
#        [Tags]    Today
#
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${erasure_profile_id}    PCC.Get Erasure Code Profile Id
#                                 ...    Name=ceph-erasure-pool-gib-1_ec_profile        
#
#        ${pool_id}             PCC.Ceph Get Erasure Pool Id
#                               ...  name=ceph-erasure-pool-gib-1
#
#        ${response}            PCC.Ceph Erasure Pool Update
#                               ...  id=${pool_id}
#                               ...  name=ceph-erasure-pool-gib-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=erasure
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#                               ...  ErasureCodeProfileID=${erasure_profile_id}
#
#                               Log To Console    ${response}
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-gib-1
#
#                               Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Ceph Erasure Pool Update Erasure Coded Profile (Negative)
####################################################################################################################################
#    [Documentation]                 *Ceph Erasure Pool Update Erasure Coded Profile*
#                                     ...  keywords:
#                                     ...  PCC.Ceph Get Cluster Id
#                                     ...  PCC.Ceph Get Pool Id
#                                     ...  PCC.Ceph Pool Update
#                                     ...  PCC.Ceph Wait Until Pool Ready
#
#
#        [Tags]    Today
#        
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${erasure_profile_id}    PCC.Get Erasure Code Profile Id
#                                 ...    Name=ceph-erasure-pool-eib-1_ec_profile        
#
#        ${pool_id}             PCC.Ceph Get Erasure Pool Id
#                               ...  name=ceph-erasure-pool-gib-1
#
#        ${response}            PCC.Ceph Erasure Pool Update
#                               ...  id=${pool_id}
#                               ...  name=ceph-erasure-pool-gib-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=erasure
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#                               ...  ErasureCodeProfileID=${erasure_profile_id}
#
#                               Log To Console    ${response}
#
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
####################################################################################################################################
#Ceph Erasure Pool Update, with special characters in Name (Negative)
####################################################################################################################################
#    [Documentation]            *Updating Ceph Pool Size*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Get Pool Id
#                               ...  PCC.Ceph Pool Update
#                               ...  PCC.Ceph Wait Until Pool Ready
#
#        [Tags]    Today
#
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${erasure_profile_id}    PCC.Get Erasure Code Profile Id
#                                 ...    Name=ceph-erasure-pool-gib-1_ec_profile        
#
#        ${pool_id}             PCC.Ceph Get Erasure Pool Id
#                               ...  name=ceph-erasure-pool-gib-1
#
#        ${response}            PCC.Ceph Erasure Pool Update
#                               ...  id=${pool_id}
#                               ...  name=@!#^&%$
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=erasure
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=3
#                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#                               ...  ErasureCodeProfileID=${erasure_profile_id}
#
#                               Log To Console    ${response} 
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
####################################################################################################################################
#Ceph Rbd Creation with Erasure Coded Pool
####################################################################################################################################
#
#        [Documentation]            *Creating Ceph Rbd*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Create Rbd
#
#        [Tags]    xyz
#
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${pool_id}             PCC.Ceph Get Pool Id
#                               ...  name=ceph-erasure-pool-tib-1
#
#        ${response}            PCC.Ceph Create Rbd
#                               ...  name=ceph-rbd-erasure-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  ceph_pool_id=${pool_id}
#                               ...  size=1
#                               ...  tags=${CEPH_RBD_TAGS}
#                               ...  image_feature=${CEPH_RBD_IMG}
#                               ...  size_units=GiB
#
#        ${status_code}         Get Response Status Code        ${response}     
#                               Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}              PCC.Ceph Wait Until Rbd Ready
#                               ...  name=ceph-rbd-erasure-1
#
#                               Should Be Equal As Strings      ${status}    OK
#                               
####################################################################################################################################
#Get CEPH Inet IP
####################################################################################################################################
#
#        [Documentation]    *Get CEPH Inet IP* test
#                           
#        [Tags]    RBD
#        
#        ${inet_ip}     PCC.Get CEPH Inet IP
#                       ...    hostip=172.17.2.127
#        
#                       
#                       Log To Console    ${inet_ip}
#                       Set Global Variable    ${inet_ip}
#                       
####################################################################################################################################
#Check Replicated Pool Creation After Erasure Pool RBD Creation
####################################################################################################################################
#
#        [Documentation]    *Check Replicated Pool Creation After Erasure Pool RBD Creation* test
#                           
#        [Tags]    RBD
#        
#        ${status}      PCC.Check Replicated Pool Creation After Erasure Pool RBD/FS Creation
#                       ...    hostip=172.17.2.61
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-1
#                       
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#                       
#
####################################################################################################################################
#Get Stored Size for Replicated Pool and Erasure Pool
####################################################################################################################################
#
#        [Documentation]    *Get Stored Size for Replicated Pool and Erasure Pool* test
#                           
#        [Tags]    RBD
#        
#        ${status}      PCC.Get Stored Size for Replicated Pool and Erasure Pool
#                       ...    hostip=172.17.2.61
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-1
#                       
#                       Log To Console    ${status}
#                       
#                       ${size_erasure_pool_before_mount}    Get From List	${status}    0
#                       Log to Console    ${size_erasure_pool_before_mount} 
#                       Set Suite Variable    ${size_erasure_pool_before_mount}
#        
#                       ${size_replicated_pool_before_mount}    Get From List	${status}    1
#                       Log to Console    ${size_replicated_pool_before_mount} 
#                       Set Suite Variable    ${size_replicated_pool_before_mount}
#
####################################################################################################################################
#Mount RBD to Mount Point
####################################################################################################################################
#
#        [Documentation]    *Mount RBD to Mount Point* test
#                           
#        [Tags]    RBD
#        
#        ${status}      PCC.Mount RBD to Mount Point
#                       ...    hostip=172.17.2.127
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-1
#                       ...    rbd_name=ceph-rbd-erasure-1
#                       
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#                       
#                       Sleep    3 minutes
#                       
####################################################################################################################################
#Check Stored Size for Replicated Pool and Erasure Pool after mount
####################################################################################################################################
#
#        [Documentation]    *Get Stored Size for Replicated Pool and Erasure Pool after mount* test
#                           
#        [Tags]    RBD
#        
#        ${status}      PCC.Get Stored Size for Replicated Pool and Erasure Pool
#                       ...    hostip=172.17.2.61
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-1
#                       
#                       Log To Console    ${status}
#                       
#                       ${size_erasure_pool_after_mount}    Get From List	${status}    0
#                       Log to Console    ${size_erasure_pool_after_mount} 
#                       Set Suite Variable    ${size_erasure_pool_after_mount}
#        
#                       ${size_replicated_pool_after_mount}    Get From List	${status}    1
#                       Log to Console    ${size_replicated_pool_after_mount} 
#                       Set Suite Variable    ${size_replicated_pool_after_mount}
#                       
#                       Log to Console    ${size_replicated_pool_before_mount}
#                       Should Be True    ${size_replicated_pool_after_mount} > ${size_replicated_pool_before_mount}
#                       Should Be True    ${size_erasure_pool_after_mount} == ${size_erasure_pool_before_mount}
#                       
####################################################################################################################################
#Flush replicated pool storage to erasure coded pool
####################################################################################################################################
#
#        [Documentation]    *Flush replicated pool storage to erasure coded pool* test
#                           
#        [Tags]    RBD
#        
#        ${status}      PCC.Flush replicated pool storage to erasure coded pool
#                       ...    hostip=172.17.2.127
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-1
#                       
#                       
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#                       
#                       Sleep    3 minutes
#                       
####################################################################################################################################
#Check Stored Size for Replicated Pool and Erasure Pool after data flush
####################################################################################################################################
#
#        [Documentation]    *Get Stored Size for Replicated Pool and Erasure Pool after data flush* test
#                           
#        [Tags]    RBD
#        
#        ${status}      PCC.Get Stored Size for Replicated Pool and Erasure Pool
#                       ...    hostip=172.17.2.127
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-1
#                       
#                       Log To Console    ${status}
#                       
#                       ${size_erasure_pool_after_data_flush}    Get From List	${status}    0
#                       Log to Console    ${size_erasure_pool_after_data_flush} 
#                       Set Suite Variable    ${size_erasure_pool_after_data_flush}
#        
#                       ${size_replicated_pool_after_data_flush}    Get From List	${status}    1
#                       Log to Console    ${size_replicated_pool_after_data_flush} 
#                       Set Suite Variable    ${size_replicated_pool_after_data_flush}
#                       
#                       Log to Console    ${size_replicated_pool_after_mount}
#                       
#                       Should Be True    ${size_erasure_pool_after_data_flush} > ${size_erasure_pool_after_mount}
#                       Should Be True    ${size_replicated_pool_after_data_flush} == 0
#
####################################################################################################################################
#Umount, Unmap RBD and delete related files
####################################################################################################################################
#
#        [Documentation]    *Umount and Unmap RBD and delete related files* test
#                           
#        [Tags]    RBD
#        
#        ${status}      PCC.Unmount and Unmap RBD
#                       ...    hostip=172.17.2.127
#                       
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#  
####################################################################################################################################
#Ceph Fs Creation with Erasure Coded Pool - Replicated Pool in metadata
####################################################################################################################################
#        [Documentation]            *Creating Cepf FS*
#                                   ...  keywords:
#                                   ...  PCC.Ceph Get Cluster Id
#                                   ...  PCC.Ceph Get Pool Details For FS
#                                   ...  PCC.Ceph Create Fs
#
#        [Tags]    FSOnly
#
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${response}            PCC.Ceph Create Pool
#                               ...  name=replicated-pool-for-fs
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  resilienceScheme=${POOL_RESILIENCE_SCHEME}
#                               ...  quota=1
#                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#
#                               Log To Console    ${response}
#
#
#        ${status_code}         Get Response Status Code        ${response}     
#                               Should Be Equal As Strings      ${status_code}  200
#        
#        ${status}              PCC.Ceph Wait Until Pool Ready
#                               ...    name=replicated-pool-for-fs
#                               
#                               Log To Console    ${status}
#        
#        ${meta}                PCC.Ceph Get Pool Details For FS
#                               ...  name=replicated-pool-for-fs
#
#        ${data}                PCC.Ceph Get Pool Details For FS
#                               ...  name=ceph-erasure-pool-pib-1
#
#        ${default}             PCC.Ceph Get Pool Details For FS
#                               ...  name=ceph-erasure-pool-tib-1
#                               
#                               Log To Console    ${default}
#
#        ${response}            PCC.Ceph Create Fs
#                               ...  name=ceph-fs-erasure-coded-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  metadata_pool=${meta}
#                               ...  default_pool=${default}
#                               ...  data_pool=[${data}]
#
#                               Log To Console    ${response}
#
#        ${status_code}         Get Response Status Code        ${response}     
#                               Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}              PCC.Ceph Wait Until Fs Ready
#                               ...  name=ceph-fs-erasure-coded-1
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
##        ${status}               PCC.Ceph Fs Verify BE
##                                ...  name=ceph-fs-erasure-coded-1
##                                ...  user=${PCC_LINUX_USER}
##                                ...  password=${PCC_LINUX_PASSWORD}
##                                ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
##
##                                Should Be Equal As Strings      ${status}    OK
#                               
#                               Sleep    10s   
#
#
####################################################################################################################################
#Ceph Fs Creation with Erasure Coded Pool - Erasure Pool in metadata (Negative)
####################################################################################################################################
#        [Documentation]            *Creating Cepf FS*
#                                   ...  keywords:
#                                   ...  PCC.Ceph Get Cluster Id
#                                   ...  PCC.Ceph Get Pool Details For FS
#                                   ...  PCC.Ceph Create Fs
#
#        [Tags]    FSOnly
#
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${meta}                PCC.Ceph Get Pool Details For FS
#                               ...  name=ceph-erasure-pool-mib-1
#
#        ${data}                PCC.Ceph Get Pool Details For FS
#                               ...  name=ceph-erasure-pool-eib-1
#
#        ${default}             PCC.Ceph Get Pool Details For FS
#                               ...  name=ceph-erasure-pool-pib-1
#
#        ${response}            PCC.Ceph Create Fs
#                               ...  name=ceph-fs-erasure-coded-negative
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  metadata_pool=${meta}
#                               ...  default_pool=${default}
#                               ...  data_pool=${data}
#
#                               Log To Console    ${response}
#
#        ${status_code}         Get Response Status Code        ${response}     
#                               Should Not Be Equal As Strings      ${status_code}  200
#                       
####################################################################################################################################
#Check Replicated Pool Creation After FS Creation
####################################################################################################################################
#
#        [Documentation]    *Check Replicated Pool Creation After FS Creation* test
#                           
#        [Tags]    FS
#        
#        ${status}      PCC.Check Replicated Pool Creation After Erasure Pool RBD/FS Creation
#                       ...    hostip=172.17.2.127
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-1
#                       
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#                       
#        
#                       
####################################################################################################################################
#Get Stored Size for Replicated Pool and Erasure Pool for FS
####################################################################################################################################
#
#        [Documentation]    *Get Stored Size for Replicated Pool and Erasure Pool* test
#                           
#        [Tags]    FS
#        
#                       
#        ${status}      PCC.Get Stored Size for Replicated Pool and Erasure Pool
#                       ...    hostip=172.17.2.127
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-1
#                       
#                       Log To Console    ${status}
#                       
#                       ${size_erasure_pool_before_mount}    Get From List	${status}    0
#                       Log to Console    ${size_erasure_pool_before_mount} 
#                       Set Suite Variable    ${size_erasure_pool_before_mount}
#        
#                       ${size_replicated_pool_before_mount}    Get From List	${status}    1
#                       Log to Console    ${size_replicated_pool_before_mount} 
#                       Set Suite Variable    ${size_replicated_pool_before_mount}
#                       
####################################################################################################################################
#Mount FS to Mount Point
####################################################################################################################################
#
#        [Documentation]    *Mount FS to Mount Point* test
#                           
#        [Tags]    FS
#        
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    hostip=172.17.2.127
#                       
#                       
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#                       
#                       Sleep    3 minutes
#                       
####################################################################################################################################
#Check Stored Size for Replicated Pool and Erasure Pool after FS mount
####################################################################################################################################
#
#        [Documentation]    *Get Stored Size for Replicated Pool and Erasure Pool after FS mount* test
#                           
#        [Tags]    FS
#        
#        ${status}      PCC.Get Stored Size for Replicated Pool and Erasure Pool
#                       ...    hostip=172.17.2.127
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-1
#                       
#                       Log To Console    ${status}
#                       
#                       ${size_erasure_pool_after_mount}    Get From List	${status}    0
#                       Log to Console    ${size_erasure_pool_after_mount} 
#                       Set Suite Variable    ${size_erasure_pool_after_mount}
#        
#                       ${size_replicated_pool_after_mount}    Get From List	${status}    1
#                       Log to Console    ${size_replicated_pool_after_mount} 
#                       Set Suite Variable    ${size_replicated_pool_after_mount}
#                       
#                       Log to Console    ${size_replicated_pool_before_mount}
#                       Should Be True    ${size_replicated_pool_after_mount} > ${size_replicated_pool_before_mount}
#                       
#
#
####################################################################################################################################
#Check FS Mount on other server
####################################################################################################################################
#
#        [Documentation]    *Check FS Mount on other server* test
#                           
#        [Tags]    FS
#        
#        ${status}      PCC.Check FS Mount on other server
#                       ...    hostip=172.17.2.119
#                       ...    username=pcc
#                       ...    password=cals0ft
#                       
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#                       
#                       Sleep    3 minutes
#
####################################################################################################################################
#Flush replicated pool storage to erasure coded pool for FS
####################################################################################################################################
#
#        [Documentation]    *Flush replicated pool storage to erasure coded pool for FS* test
#                           
#        [Tags]    FS
#        
#        ${status}      PCC.Flush replicated pool storage to erasure coded pool
#                       ...    hostip=172.17.2.127
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-1
#                       
#                       
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#                       
#                       Sleep    3 minutes
#                       
####################################################################################################################################
#Check Stored Size for Replicated Pool and Erasure Pool after data flush for FS
####################################################################################################################################
#
#        [Documentation]    *Get Stored Size for Replicated Pool and Erasure Pool after data flush for FS* test
#                           
#        [Tags]    FS
#        
#        ${status}      PCC.Get Stored Size for Replicated Pool and Erasure Pool
#                       ...    hostip=172.17.2.127
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-1
#                       
#                       Log To Console    ${status}
#                       
#                       ${size_erasure_pool_after_data_flush}    Get From List	${status}    0
#                       Log to Console    ${size_erasure_pool_after_data_flush} 
#                       Set Suite Variable    ${size_erasure_pool_after_data_flush}
#        
#                       ${size_replicated_pool_after_data_flush}    Get From List	${status}    1
#                       Log to Console    ${size_replicated_pool_after_data_flush} 
#                       Set Suite Variable    ${size_replicated_pool_after_data_flush}
#                       
#                       Log to Console    ${size_replicated_pool_after_mount}
#                       
#                       Should Be True    ${size_erasure_pool_after_data_flush} >= ${size_erasure_pool_after_mount}
#                       Should Be True    ${size_replicated_pool_after_data_flush} == 0
#                       
####################################################################################################################################
#Umount FS and delete related files
####################################################################################################################################
#
#        [Documentation]    *Umount FS and delete related files* test
#                           
#        [Tags]    FS
#        
#        ${status}      PCC.Unmount FS
#                       ...    hostip=172.17.2.127
#                       
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#                       
#        ${status}      PCC.Unmount FS
#                       ...    hostip=172.17.2.119
#                       ...    username=pcc
#                       ...    password=cals0ft
#                       
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK   
#                               
####################################################################################################################################
#Ceph Fs Delete (Erasure coded)
####################################################################################################################################
#    [Documentation]            *Delete Fs if it exist*   
#                               ...  keywords:
#                               ...  PCC.Ceph Get Fs Id
#                               ...  PCC.Ceph Delete Fs
#                               ...  PCC.Ceph Wait Until Fs Deleted
#        [Tags]    Runonly
#
#        ${id}                  PCC.Ceph Get Fs Id
#                               ...  name=ceph-fs-erasure-coded-1
#                               Pass Execution If    ${id} is ${None}    Fs is alredy Deleted
#
#        ${response}            PCC.Ceph Delete Fs
#                               ...  id=${id}
#                               
#                               Log To Console    ${response}
#
#        ${status_code}         Get Response Status Code        ${response}
#                               Should Be Equal As Strings      ${status_code}  200
#
#        ${status}              PCC.Ceph Wait Until Fs Deleted
#                               ...  id=${id}
#                               Should Be Equal     ${status}  OK
#                               
#                               Sleep    8s
#
####################################################################################################################################
#Ceph Rbd Delete (Erasure coded)
####################################################################################################################################
#    [Documentation]            *Delete Pool if it exist.*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Rbd Id
#                               ...  PCC.Ceph Delete Rbd
#                               ...  PCC.Ceph Wait Until Rbd Deleted
#        [Tags]    Runonly
#
#        ${id}                  PCC.Ceph Get Rbd Id
#                               ...  name=ceph-rbd-erasure-1
#                               Pass Execution If    ${id} is ${None}    Rbd is already Deleted
#
#        ${response}            PCC.Ceph Delete Rbd
#                               ...  id=${id}
#
#        ${status_code}         Get Response Status Code        ${response}
#                               Should Be Equal As Strings      ${status_code}  200
#
#        ${status}              PCC.Ceph Wait Until Rbd Deleted
#                               ...  id=${id}
#                               Should Be Equal     ${status}  OK 
#                               
#                       
####################################################################################################################################
#Ceph Pool Delete (Erasure coded)
####################################################################################################################################
#
#    [Documentation]            *Delete Pool if it exist*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Pool Id
#                               ...  PCC.Ceph Delete Pool
#                               ...  PCC.Ceph Wait Until Pool Deleted
#
#        [Tags]    Runonly
#
#        ############  Deleting ceph-erasure-pool-mib-1  ################ 
#
#        ${id}                  PCC.Ceph Get Pool Id
#                               ...  name=ceph-erasure-pool-mib-1
#                               Pass Execution If    ${id} is ${None}    Pool is alredy Deleted
#
#        ${response}            PCC.Ceph Delete Pool
#                               ...  id=${id}
#
#        ${status_code}         Get Response Status Code        ${response}
#                               Should Be Equal As Strings      ${status_code}  200
#
#        ${status}              PCC.Ceph Wait Until Pool Deleted
#                               ...  id=${id}
#                               Should Be Equal     ${status}  OK
#
####################################################################################################################################
#Ceph Pool Multiple Delete
####################################################################################################################################
#    [Documentation]                 *Deleting all Pools*
#                                    ...  keywords:
#                                    ...  PCC.Ceph Delete All Pools
#        [Tags]    Run
#
#        ${status}                   PCC.Ceph Delete All Pools
#                                    Should Be Equal     ${status}  OK                                                         

