*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC 
###################################################################################################################################
                
        
        [Documentation]    *Login to PCC* test
        
        [Tags]    Create
        ${status}        Login To PCC    ${pcc_setup}
                         
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         
                         Load Ceph Rbd Data    ${pcc_setup}
                         Load Ceph Pool Data    ${pcc_setup}
                         Load Ceph Cluster Data    ${pcc_setup}
                         Load Ceph Fs Data    ${pcc_setup}
                         Load Network Manager Data    ${pcc_setup}
                         
                      
        ${server1_id}    PCC.Get Node Id    Name=${SERVER_1_NAME}
                         Log To Console    ${server1_id}
                         Set Global Variable    ${server1_id}
                         
        ${server2_id}    PCC.Get Node Id    Name=${SERVER_2_NAME}
                         Log To Console    ${server2_id}
                         Set Global Variable    ${server2_id}
                         
        ${invader1_id}    PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
                         Log To Console    ${invader1_id}
                         Set Global Variable    ${invader1_id}
                         
###################################################################################################################################
#Create Erasure Code Profile With 4:2 Ratio
####################################################################################################################################
#
#        [Documentation]    *Create Erasure Code Profile* test
#                           ...  keywords:
#                           ...  PCC.Ceph Get Cluster Id
#                           ...  PCC.Create Erasure Code Profile
#        [Tags]    Create
#        
#        ${cluster_id}    PCC.Ceph Get Cluster Id
#                         ...  name=${CEPH_Cluster_NAME}
#        
#        ${response}    PCC.Create Erasure Code Profile
#                       ...    Name=erasure_profile1
#                       ...    DataChunks=4
#                       ...    CodingChunks=2
#                       ...    CephClusterId=${cluster_id}
#                       
#
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Be Equal As Strings    ${status}    200
#                       
#                       
#                       ## TO DO - Wait until Erasure code profile added to PCC and verify creation
#                       
####################################################################################################################################
#Create duplicate erasure coded profile (Negative)
####################################################################################################################################
#
#        [Documentation]    *Create Erasure Code Profile* test
#                           ...  keywords:
#                           ...  PCC.Ceph Get Cluster Id
#                           ...  PCC.Create Erasure Code Profile
#        
#
#        ${cluster_id}    PCC.Ceph Get Cluster Id
#                         ...  name=${CEPH_Cluster_NAME}
#        
#        
#        ${response}    PCC.Create Erasure Code Profile
#                       ...    Name=erasure_profile1
#                       ...    DataChunks=4
#                       ...    CodingChunks=2
#                       ...    CephClusterId=${cluster_id}
#                       
#
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Not Be Equal As Strings    ${status}    200
#                       
#                       
####################################################################################################################################
#Create CEPH Pool with 4:2 Erasure Code Profile
####################################################################################################################################
#
#        [Documentation]    *Get Erasure Code Profile Id* test
#                           ...  keywords:
#                           ...  PCC.Get Erasure Code Profile Id
#                           ...  PCC.Ceph Get Cluster Id
#                           ...  PCC.Ceph Create Erasure Pool
#        
#                            
#
#        ${erasure_profile_id}    PCC.Get Erasure Code Profile Id
#                                 ...    Name=erasure_profile1
#                       
#        ${cluster_id}    PCC.Ceph Get Cluster Id
#                         ...  name=${CEPH_Cluster_NAME}
#                         
#                                                  
#        ${response}            PCC.Ceph Create Erasure Pool
#        
#                               ...  name=ceph-erasure-pool-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  ErasureCodeProfileID=${erasure_profile_id}
#                               
#        ${status_code}          Get Response Status Code        ${response}     
#                                Should Be Equal As Strings      ${status_code}  200
#        
#        
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-1
#
#                               Should Be Equal As Strings      ${status}    OK
#                               Sleep    30s 
#        
#        ${status}              PCC.Ceph Erasure Pool Verify BE
#                               ...  name=ceph-erasure-pool-1
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
#
#                               Should Be Equal As Strings      ${status}    OK
#                               
#                               
#############################################################################################################################################################
#Create erasure coded pool with quota size is in MiB, GiB, TiB, PiB and EiB ---> Also covers Create two erasure coded pool using same erasure coded profile
#############################################################################################################################################################
#
#        [Documentation]    *Get Erasure Code Profile Id* test
#                           ...  keywords:
#                           ...  PCC.Get Erasure Code Profile Id
#                           ...  PCC.Ceph Get Cluster Id
#                           ...  PCC.Ceph Create Erasure Pool
#
#        [Tags]    Create
#        
#        ${erasure_profile_id}    PCC.Get Erasure Code Profile Id
#                                 ...    Name=erasure_profile1
#
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ######### Quota Size in MiB #########
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-mib
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=MiB
#                               ...  ErasureCodeProfileID=${erasure_profile_id}
#
#        ${status_code}          Get Response Status Code        ${response}     
#                                Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-mib
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
#        ${status}              PCC.Ceph Erasure Pool Verify BE
#                               ...  name=ceph-erasure-pool-mib
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
#        ######### Quota Size in GiB #########
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-gib
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=GiB
#                               ...  ErasureCodeProfileID=${erasure_profile_id}
#
#        ${status_code}          Get Response Status Code        ${response}     
#                                Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-gib
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
#        ${status}              PCC.Ceph Erasure Pool Verify BE
#                               ...  name=ceph-erasure-pool-gib
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
#
#        ######### Quota Size in TiB #########
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-tib
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=TiB
#                               ...  ErasureCodeProfileID=${erasure_profile_id}
#
#        ${status_code}          Get Response Status Code        ${response}
#                                Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-tib
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
#        ${status}              PCC.Ceph Erasure Pool Verify BE
#                               ...  name=ceph-erasure-pool-tib
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
#
#        ######### Quota Size in PiB #########
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-pib
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=PiB
#                               ...  ErasureCodeProfileID=${erasure_profile_id}
#
#        ${status_code}          Get Response Status Code        ${response}
#                                Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-pib
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
#        ${status}              PCC.Ceph Erasure Pool Verify BE
#                               ...  name=ceph-erasure-pool-pib
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
#        ######### Quota Size in EiB #########
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-eib
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=EiB
#                               ...  ErasureCodeProfileID=${erasure_profile_id}
#
#        ${status_code}          Get Response Status Code        ${response}
#                                Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-eib
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
#        ${status}              PCC.Ceph Erasure Pool Verify BE
#                               ...  name=ceph-erasure-pool-eib
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
#
#                               Should Be Equal As Strings      ${status}    OK
#                               
####################################################################################################################################
#Create erasure coded pool without Erasure coded profile (Negative)
####################################################################################################################################
#
#        [Documentation]    *Create erasure coded pool without Erasure coded profile (Negative)* test
#                           ...  keywords:
#                           ...  PCC.Get Erasure Code Profile Id
#                           ...  PCC.Ceph Get Cluster Id
#                           ...  PCC.Ceph Create Erasure Pool
#        
#        
#                           
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#                         
#                                                  
#        ${response}            PCC.Ceph Create Erasure Pool
#        
#                               ...  name=ceph-pool-without-erasure-profile
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#                               
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
#        
#        ${erasure_profile_id}    PCC.Get Erasure Code Profile Id
#                                 ...    Name=erasure_profile1
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
#                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#                               ...  ErasureCodeProfileID=${erasure_profile_id}
#                               
#                               
#        ${status_code}          Get Response Status Code        ${response}     
#                                Should Not Be Equal As Strings      ${status_code}  200
#                                
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
#        
#        
#        ${erasure_profile_id}    PCC.Get Erasure Code Profile Id
#                                 ...    Name=erasure_profile1
#        
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#                         
#                                                  
#        ${response}            PCC.Ceph Create Erasure Pool
#        
#                               ...  name=ceph-pool-without-quota
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=erasure
#                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#                               ...  ErasureCodeProfileID=${erasure_profile_id}
#                               
#                               
#                               Log To Console    ${response}
#                               
#                               
#        ${status_code}          Get Response Status Code        ${response}     
#                                Should Not Be Equal As Strings      ${status_code}  200
#                                
#
#                               
####################################################################################################################################
#Create erasure coded profile with explicit coding and data chunks (For eg. 10:6 ratio)
####################################################################################################################################
#
#        [Documentation]    *Create erasure coded profile with explicit coding and data chunks (For eg. 10:6 ratio)* test
#                           ...  keywords:
#                           ...  PCC.Ceph Get Cluster Id
#                           ...  PCC.Create Erasure Code Profile
#
#        
#        
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#        
#        ${response}    PCC.Create Erasure Code Profile
#                       ...    Name=erasure_profile_explicit_chunks_ratio
#                       ...    DataChunks=10
#                       ...    CodingChunks=6
#                       ...    CephClusterId=${cluster_id}
#                       
#
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Not Be Equal As Strings    ${status}    200
#                       
#                       
#                       ## TO DO - Wait until Erasure code profile added to PCC and verify creation
#                       
####################################################################################################################################
#Create Erasure Code Profile (for Update Test cases)
####################################################################################################################################
#
#        [Documentation]    *Create Erasure Code Profile* test
#                           ...  keywords:
#                           ...  PCC.Ceph Get Cluster Id
#                           ...  PCC.Create Erasure Code Profile
#
#        
#        
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${response}    PCC.Create Erasure Code Profile
#                       ...    Name=erasure_profile_for_update
#                       ...    DataChunks=4
#                       ...    CodingChunks=2
#                       ...    CephClusterId=${cluster_id}
#
#                       Log To Console    ${response}
#                       ${result}    Get Result    ${response}
#                       ${status}    Get From Dictionary    ${result}    status
#                       ${message}    Get From Dictionary    ${result}    message
#                       Log to Console    ${message}
#                       Should Be Equal As Strings    ${status}    200
#
#
#                       ## TO DO - Wait until Erasure code profile added to PCC and verify creation                               
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
#                               
#        
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#        
#        ${erasure_profile_id}    PCC.Get Erasure Code Profile Id
#                                 ...    Name=erasure_profile1
#
#        ${pool_id}             PCC.Ceph Get Erasure Pool Id
#                               ...  name=ceph-erasure-pool-1
#
#        ${response}            PCC.Ceph Erasure Pool Update
#                               ...  id=${pool_id}
#                               ...  name=ceph-erasure-pool-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=erasure
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=MiB
#                               ...  ErasureCodeProfileID=${erasure_profile_id}  
#                               
#                               Log To Console    ${response}
#                               
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-1
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
#        
#        
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${erasure_profile_id}    PCC.Get Erasure Code Profile Id
#                                 ...    Name=erasure_profile1        
#        
#        ${pool_id}             PCC.Ceph Get Erasure Pool Id
#                               ...  name=ceph-erasure-pool-1
#
#        ${response}            PCC.Ceph Erasure Pool Update
#                               ...  id=${pool_id}
#                               ...  name=ceph-erasure-pool-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=erasure
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
#                               ...  name=ceph-erasure-pool-1
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
#        
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${erasure_profile_id}    PCC.Get Erasure Code Profile Id
#                                 ...    Name=ceph-rbd-erasure-pool-4_ec_profile        
#        
#        ${pool_id}             PCC.Ceph Get Erasure Pool Id
#                               ...  name=ceph-erasure-pool-1
#
#        ${response}            PCC.Ceph Erasure Pool Update
#                               ...  id=${pool_id}
#                               ...  name=ceph-erasure-pool-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=erasure
#                               ...  quota=${CEPH_POOL_QUOTA}
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
#        
#        
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${erasure_profile_id}    PCC.Get Erasure Code Profile Id
#                                 ...    Name=erasure_profile1        
#        
#        ${pool_id}             PCC.Ceph Get Erasure Pool Id
#                               ...  name=ceph-erasure-pool-1
#
#        ${response}            PCC.Ceph Erasure Pool Update
#                               ...  id=${pool_id}
#                               ...  name=@!#^&%$
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=erasure
#                               ...  quota=${CEPH_POOL_QUOTA}
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
#    [Documentation]            *Creating Ceph Rbd*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Create Rbd
#        
#                               
#        
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#
#        ${pool_id}             PCC.Ceph Get Pool Id
#                               ...  name=ceph-erasure-pool-eib
#
#        ${response}            PCC.Ceph Create Rbd
#                               ...  name=ceph-rbd-erasure-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  ceph_pool_id=${pool_id}
#                               ...  size=${CEPH_RBD_SIZE}
#                               ...  tags=${CEPH_RBD_TAGS}
#                               ...  image_feature=${CEPH_RBD_IMG}
#                               ...  size_units=${CEPH_RBD_SIZE_UNIT}
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
#        ${status}              PCC.Check Replicated Pool Creation After Erasure Pool RBD Creation
#                               ...    hostip=${SERVER_2_HOST_IP}
#                               ...    erasure_pool_name=ceph-erasure-pool-eib
#                               
#                               Log To Console    ${status}
#                               Should be equal as strings    ${status}    OK
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
#        [Tags]    Test
#        
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#                               
#        ${response}            PCC.Ceph Create Pool
#                               ...  name=pool-for-fs
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=${CEPH_POOL_TYPE}
#                               ...  quota=${CEPH_POOL_QUOTA}
#                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#                               
#                               Log To Console    ${response}
#                               
#
#        ${status_code}              Get Response Status Code        ${response}     
#                                    Should Be Equal As Strings      ${status_code}  200
#        
#        ${meta}                PCC.Ceph Get Pool Details For FS
#                               ...  name=pool-for-fs
#
#        ${data}                PCC.Ceph Get Pool Details For FS
#                               ...  name=ceph-erasure-pool-mib
#
#        ${default}             PCC.Ceph Get Pool Details For FS
#                               ...  name=ceph-erasure-pool-gib
#
#        ${response}            PCC.Ceph Create Fs
#                               ...  name=ceph-fs-erasure-coded-1
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  metadata_pool=${meta}
#                               ...  default_pool=${default}
#                               #...  data_pool=${data}
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
#        ${status}               PCC.Ceph Fs Verify BE
#                                ...  name=ceph-fs-erasure-coded-1
#                                ...  user=${PCC_LINUX_USER}
#                                ...  password=${PCC_LINUX_PASSWORD}
#                                ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
#   
#                                Should Be Equal As Strings      ${status}    OK
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
#        [Tags]    Test
#        
#        ${cluster_id}          PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_Cluster_NAME}
#        
#        ${meta}                PCC.Ceph Get Pool Details For FS
#                               ...  name=ceph-erasure-pool-tib
#
#        ${data}                PCC.Ceph Get Pool Details For FS
#                               ...  name=ceph-erasure-pool-mib
#
#        ${default}             PCC.Ceph Get Pool Details For FS
#                               ...  name=ceph-erasure-pool-gib
#
#        ${response}            PCC.Ceph Create Fs
#                               ...  name=ceph-fs-erasure-coded-negative
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  metadata_pool=${meta}
#                               ...  default_pool=${default}
#                               #...  data_pool=${data}
#                               
#                               Log To Console    ${response}
#
#        ${status_code}         Get Response Status Code        ${response}     
#                               Should Not Be Equal As Strings      ${status_code}  200
#
####################################################################################################################################
#Ceph Fs Delete (Erasure coded)
####################################################################################################################################
#    [Documentation]            *Delete Fs if it exist*   
#                               ...  keywords:
#                               ...  PCC.Ceph Get Fs Id
#                               ...  PCC.Ceph Delete Fs
#                               ...  PCC.Ceph Wait Until Fs Deleted
#        [Tags]    Delete
#                               
#        ${id}                  PCC.Ceph Get Fs Id
#                               ...  name=ceph-fs-erasure-coded-1
#                               Pass Execution If    ${id} is ${None}    Fs is alredy Deleted
#
#        ${response}            PCC.Ceph Delete Fs
#                               ...  id=${id}
#
#        ${status_code}         Get Response Status Code        ${response}
#                               Should Be Equal As Strings      ${status_code}  200
#
#        ${status}              PCC.Ceph Wait Until Fs Deleted
#                               ...  id=${id}
#                               Should Be Equal     ${status}  OK
#
####################################################################################################################################
#Ceph Rbd Delete (Erasure coded)
####################################################################################################################################
#    [Documentation]            *Delete Pool if it exist*
#                               ...  keywords:
#                               ...  PCC.Ceph Get Rbd Id
#                               ...  PCC.Ceph Delete Rbd
#                               ...  PCC.Ceph Wait Until Rbd Deleted
#        [Tags]    Delete
#                               
#        ${id}                  PCC.Ceph Get Rbd Id
#                               ...  name=ceph-rbd-erasure-1
#                               Pass Execution If    ${id} is ${None}    Rbd is alredy Deleted
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
#Delete erasure coded profile in which erasure coded pool is created (Negative)
####################################################################################################################################
#                
#        
#        [Documentation]    *Delete erasure coded profile in which erasure coded pool is created (Negative)* test
#        
#        [Tags]    Delete
#        ${response}    PCC.Delete Erasure Code Profile
#                       ...  Name=erasure_profile1
#  
#                       Log To Console    ${response}
#                       ${status}    Get From Dictionary    ${response}    StatusCode
#                       Should Not Be Equal As Strings    ${status}    200
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
#        [Tags]    Delete
#        
#        ############  Deleting ceph_erasure_pool_1  ################ 
#                               
#        ${id}                  PCC.Ceph Get Pool Id
#                               ...  name=ceph_erasure_pool_1
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
#Ceph Erasure Pool Multiple Delete
####################################################################################################################################
#    [Documentation]                 *Deleting all Pools*
#                                    ...  keywords:
#                                    ...  PCC.Ceph Delete All Pools
#        [Tags]    Delete
#        
#        ${status}                   PCC.Ceph Delete All Pools
#                                    Should Be Equal     ${status}  OK
#
####################################################################################################################################
#Delete Erasure Code Profile
####################################################################################################################################
#
#
#        [Documentation]    *Delete Erasure Code Profile* test
#        
#        [Tags]    Delete
#        
#        ${response}    PCC.Delete Erasure Code Profile
#                       ...  Name=erasure_profile1
#
#                       Log To Console    ${response}
#                       ${status}    Get From Dictionary    ${response}    StatusCode
#                       Should Be Equal As Strings    ${status}    200
#
#
#                      ## To DO - Verify Erasure Profile Deleted or not .. Wait until deletion
#
####################################################################################################################################
#Delete Multiple Erasure Code Profiles
####################################################################################################################################
#
#
#        [Documentation]    *Delete Multiple Erasure Code Profiles* test
#
#        [Tags]    Delete
#
#        ${response}    PCC.Delete Multiple Erasure Code Profiles
#                       #...  erasure_profile_list=['erasure_profile_for_update']
#                       #...  erasure_profile_list=['erasure_profile2','erasure_profile3','erasure_profile4', 'ceph-rbd-erasure-pool-4_ec_profile', ]
#
#                       Log To Console    ${response}
#                       Should Be Equal As Strings    ${status}    OK
#
#                       ## To DO - Verify Erasure Profile Deleted or not .. Wait until deletion
#                       
####################################################################################################################################
Ceph Cluster Delete
###################################################################################################################################
    [Documentation]            *Delete cluster if it exist*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Delete Cluster
                               ...  PCC.Ceph Wait Until Cluster Deleted
                               ...  PCC.Ceph Cleanup BE
    

        ${id}                  PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}
                               Pass Execution If    ${id} is ${None}    Cluster is alredy Deleted

        ${response}            PCC.Ceph Delete Cluster
                               ...  id=${id}

        ${status_code}         Get Response Status Code        ${response}
                               Should Be Equal As Strings      ${status_code}  200

        ${status}              PCC.Ceph Wait Until Cluster Deleted
                               ...  id=${id}
                               Should Be Equal     ${status}  OK
                                    
        ${response}            PCC.Ceph Cleanup BE
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}    
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               
        ${status}              PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
                               Should Not Be Equal As Strings      ${status}    OK

####################################################################################################################################
#Network Manager Delete and Verify PCC
####################################################################################################################################
#    [Documentation]            *Network Manager Verification PCC*
#                               ...  keywords:
#                               ...  PCC.Network Manager Delete
#                               ...  PCC.Wait Until Network Manager Ready
#
#        ${response}            PCC.Network Manager Delete
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#        ${status_code}         Get Response Status Code        ${response}     
#                               Should Be Equal As Strings      ${status_code}  200
#
#        ${status}              PCC.Wait Until Network Manager Deleted
#                               ...  name=${NETWORK_MANAGER_NAME}
#
#                               Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Re-assign default location to multiple nodes
###################################################################################################################################

        [Documentation]    *Re-assign default location to multiple nodes* test
                           ...  keywords:
                           ...  PCC.Apply scope to multiple nodes

        ${parent1_Id}    PCC.Get Scope Id
                        ...  scope_name=Default region
                        Log To Console    ${parent1_Id}
        
        ${parent2_Id}    PCC.Get Scope Id
                        ...  scope_name=Default zone
                        ...  parentID=${parent1_Id}
                        Log To Console    ${parent2_Id}
        
        ${parent3_Id}    PCC.Get Scope Id
                        ...  scope_name=Default site
                        ...  parentID=${parent2_Id}
                        
                        Log To Console    ${parent3_Id}
                       
        ${scope_id}    PCC.Get Scope Id
                        ...  scope_name=Default rack
                        ...  parentID=${parent3_Id}
                        
                        Log To Console    ${scope_id}
                        
        ${status}      PCC.Apply scope to multiple nodes
                       ...  node_names=['${CLUSTERHEAD_1_NAME}','${CLUSTERHEAD_2_NAME}','${SERVER_2_NAME}','${SERVER_1_NAME}']
                       ...  scopeId=${scope_id}
                       
                       Log to Console    ${status}
                       Should Be Equal As Strings    ${status}    OK
                       
###################################################################################################################################
Delete all locations related to CEPH
###################################################################################################################################

        [Documentation]    *Delete all locations related to CEPH* test
                           ...  keywords:
                           ...  PCC.Delete Scope             
        [Tags]    delete          
        ${response}    PCC.Delete Scope
                       ...  scope_name=region-for-ceph
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200