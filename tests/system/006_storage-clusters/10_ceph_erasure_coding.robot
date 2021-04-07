*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_226

*** Test Cases ***
###################################################################################################################################
Login to PCC
###################################################################################################################################


        [Documentation]    *Login to PCC* test

        [Tags]    Mount_test
        ${status}        Login To PCC    ${pcc_setup}

                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         Load Server 3 Test Data    ${pcc_setup}

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

############################################################################################################################################################
Create erasure coded pools with quota size is in MiB, GiB, TiB, PiB and EiB - Also covers 4-2, 8-3 and 8-4 chunk ratio profiles
############################################################################################################################################################

        [Documentation]    *Get Erasure Code Profile Id* test
                           ...  keywords:
                           ...  PCC.Get Erasure Code Profile Id
                           ...  PCC.Ceph Get Cluster Id
                           ...  PCC.Ceph Create Erasure Pool

        [Tags]    Today


        ${cluster_id}          PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ######### Quota Size in MiB (2:1 ratio) #########

        ${response}            PCC.Ceph Create Erasure Pool

                               ...  name=ceph-erasure-pool-mib-2-1
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  pool_type=data
                               ...  resilienceScheme=erasure
                               ...  quota=3
                               ...  quota_unit=GiB
                               ...  Datachunks=2
                               ...  Codingchunks=1



        ${status_code}          Get Response Status Code        ${response}
                                Should Be Equal As Strings      ${status_code}  200


        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
                               ...  name=ceph-erasure-pool-mib-2-1

                               Should Be Equal As Strings      ${status}    OK


       ${status}               PCC.Ceph Erasure Pool Verify BE
                               ...  name=ceph-erasure-pool-mib-2-1
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}

                               Should Be Equal As Strings      ${status}    OK
                               Sleep    5s

#       ####  Quota Size in MiB (12:3 ratio) ####
#       ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-mib-12-3
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=data
#                               ...  resilienceScheme=erasure
#                               ...  quota=3
#                               ...  quota_unit=MiB
#                               ...  Datachunks=12
#                               ...  Codingchunks=3
#
#
#
#        ${status_code}          Get Response Status Code        ${response}
#                                Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-mib-12-3
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
#       ${status}               PCC.Ceph Erasure Pool Verify BE
#                               ...  name=ceph-erasure-pool-mib-12-3
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
#
#                               Should Be Equal As Strings      ${status}    OK
#                               Sleep    5s
#
#       ####  Quota Size in MiB (16:4 ratio) ####
#       ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-mib-16-4
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=data
#                               ...  resilienceScheme=erasure
#                               ...  quota=3
#                               ...  quota_unit=MiB
#                               ...  Datachunks=16
#                               ...  Codingchunks=4
#
#
#
#        ${status_code}          Get Response Status Code        ${response}
#                                Should Be Equal As Strings      ${status_code}  200
#
#
#        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
#                               ...  name=ceph-erasure-pool-mib-16-4
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
#       ${status}               PCC.Ceph Erasure Pool Verify BE
#                               ...  name=ceph-erasure-pool-mib-16-4
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
#
#                               Should Be Equal As Strings      ${status}    OK
#                               Sleep    5s
#
       #### Quota Size in MiB (4:2 ratio) ####

        ${response}            PCC.Ceph Create Erasure Pool

                               ...  name=ceph-erasure-pool-mib-4-2
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  pool_type=data
                               ...  resilienceScheme=erasure
                               ...  quota=3
                               ...  quota_unit=MiB
                               ...  Datachunks=4
                               ...  Codingchunks=2



        ${status_code}          Get Response Status Code        ${response}
                                Should Be Equal As Strings      ${status_code}  200


        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
                               ...  name=ceph-erasure-pool-mib-4-2

                               Should Be Equal As Strings      ${status}    OK


       ${status}               PCC.Ceph Erasure Pool Verify BE
                               ...  name=ceph-erasure-pool-mib-4-2
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}

                               Should Be Equal As Strings      ${status}    OK
                               Sleep    5s

#        ######### Quota Size in GiB (8:3 ratio)#########
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-gib-8-3
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=data
#                               ...  resilienceScheme=erasure
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
#                               ...  name=ceph-erasure-pool-gib-8-3
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
#        ${status}              PCC.Ceph Erasure Pool Verify BE
#                               ...  name=ceph-erasure-pool-gib-8-3
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
#
#                               Should Be Equal As Strings      ${status}    OK
#                               Sleep    5s
#
#
#        ######### Quota Size in TiB #########
#
#        ${response}            PCC.Ceph Create Erasure Pool
#
#                               ...  name=ceph-erasure-pool-tib-8-4
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  pool_type=data
#                               ...  resilienceScheme=erasure
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
#                               ...  name=ceph-erasure-pool-tib-8-4
#
#                               Should Be Equal As Strings      ${status}    OK
#
#
#        ${status}              PCC.Ceph Erasure Pool Verify BE
#                               ...  name=ceph-erasure-pool-tib-8-4
#                               ...  user=${PCC_LINUX_USER}
#                               ...  password=${PCC_LINUX_PASSWORD}
#                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
#
#                               Should Be Equal As Strings      ${status}    OK
#                               Sleep    5s
#

        ######### Quota Size in PiB #########

        ${response}            PCC.Ceph Create Erasure Pool

                               ...  name=ceph-erasure-pool-pib-4-2
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  pool_type=data
                               ...  resilienceScheme=erasure
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=PiB
                               ...  Datachunks=4
                               ...  Codingchunks=2

        ${status_code}          Get Response Status Code        ${response}
                                Should Be Equal As Strings      ${status_code}  200


        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
                               ...  name=ceph-erasure-pool-pib-4-2

                               Should Be Equal As Strings      ${status}    OK


        ${status}              PCC.Ceph Erasure Pool Verify BE
                               ...  name=ceph-erasure-pool-pib-4-2
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}

                               Should Be Equal As Strings      ${status}    OK
                               Sleep    5s

        ######### Quota Size in EiB #########

        ${response}            PCC.Ceph Create Erasure Pool

                               ...  name=ceph-erasure-pool-eib-4-2
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  pool_type=data
                               ...  resilienceScheme=erasure
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=EiB
                               ...  Datachunks=4
                               ...  Codingchunks=2

        ${status_code}          Get Response Status Code        ${response}
                                Should Be Equal As Strings      ${status_code}  200


        ${status}              PCC.Ceph Wait Until Erasure Pool Ready
                               ...  name=ceph-erasure-pool-eib-4-2

                               Should Be Equal As Strings      ${status}    OK


        ${status}              PCC.Ceph Erasure Pool Verify BE
                               ...  name=ceph-erasure-pool-eib-4-2
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}

                               Should Be Equal As Strings      ${status}    OK
                               Sleep    5s

############################################################################################################################################################
Create erasure coded pool with explicit coding and data chunks (For eg. 10,6 ratio)
############################################################################################################################################################

        [Documentation]    *Get Erasure Code Profile Id* test
                           ...  keywords:
                           ...  PCC.Get Erasure Code Profile Id
                           ...  PCC.Ceph Get Cluster Id
                           ...  PCC.Ceph Create Erasure Pool

        [Tags]    Today


        ${cluster_id}          PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}


        ${response}            PCC.Ceph Create Erasure Pool

                               ...  name=ceph-erasure-explicit
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  pool_type=data
                               ...  resilienceScheme=erasure
                               ...  quota=3
                               ...  quota_unit=MiB
                               ...  Datachunks=10
                               ...  Codingchunks=6

        ${status_code}          Get Response Status Code        ${response}
                                Should Not Be Equal As Strings      ${status_code}  200



###################################################################################################################################
Create duplicate erasure coded pool
###################################################################################################################################

        [Documentation]    *Create duplicate erasure coded pool* test
                           ...  keywords:
                           ...  PCC.Get Erasure Code Profile Id
                           ...  PCC.Ceph Get Cluster Id
                           ...  PCC.Ceph Create Erasure Pool

        [Tags]    Today
        ${cluster_id}    PCC.Ceph Get Cluster Id
                         ...  name=${CEPH_Cluster_NAME}


        ${response}            PCC.Ceph Create Erasure Pool

                               ...  name=ceph-erasure-pool-eib-4-2
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  pool_type=data
                               ...  resilienceScheme=erasure
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
                               ...  Datachunks=4
                               ...  Codingchunks=2

        ${status_code}          Get Response Status Code        ${response}
                                Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create erasure coded pool without Name (Negative)
###################################################################################################################################

        [Documentation]    *Create erasure coded pool without Name(Negative)* test
                           ...  keywords:
                           ...  PCC.Get Erasure Code Profile Id
                           ...  PCC.Ceph Get Cluster Id
                           ...  PCC.Ceph Create Erasure Pool

        [Tags]    Today

        ${cluster_id}          PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}


        ${response}            PCC.Ceph Create Erasure Pool

                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  pool_type=data
                               ...  resilienceScheme=erasure
                               ...  quota=${CEPH_POOL_QUOTA}
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
                               ...  Datachunks=4
                               ...  Codingchunks=2


        ${status_code}          Get Response Status Code        ${response}
                                Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Create erasure coded pool without quota (Negative)
###################################################################################################################################

        [Documentation]    *Create erasure coded pool without quota(Negative)* test
                           ...  keywords:
                           ...  PCC.Get Erasure Code Profile Id
                           ...  PCC.Ceph Get Cluster Id
                           ...  PCC.Ceph Create Erasure Pool

        [Tags]    Today

        ${cluster_id}          PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}


        ${response}            PCC.Ceph Create Erasure Pool

                               ...  name=ceph-erasure-pool-without-quota
                               ...  ceph_cluster_id=${cluster_id}
                               ...  size=${CEPH_POOL_SIZE}
                               ...  pool_type=data
                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
                               ...  Datachunks=4
                               ...  Codingchunks=2


                               Log To Console    ${response}


        ${status_code}          Get Response Status Code        ${response}
                                Should Not Be Equal As Strings      ${status_code}  200


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
#                                 ...    Name=ceph-erasure-pool-gib-8-3_ec_profile
#
#        ${pool_id}             PCC.Ceph Get Erasure Pool Id
#                               ...  name=ceph-erasure-pool-gib-8-3
#
#        ${response}            PCC.Ceph Erasure Pool Update
#                               ...  id=${pool_id}
#                               ...  name=ceph-erasure-pool-gib-8-3
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=data
#                               ...  resilienceScheme=erasure
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
#                               ...  name=ceph-erasure-pool-gib-8-3
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
#                                 ...    Name=ceph-erasure-pool-gib-8-3_ec_profile
#
#        ${pool_id}             PCC.Ceph Get Erasure Pool Id
#                               ...  name=ceph-erasure-pool-gib-8-3
#
#        ${response}            PCC.Ceph Erasure Pool Update
#                               ...  id=${pool_id}
#                               ...  name=ceph-erasure-pool-gib-8-3
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=data
#                               ...  resilienceScheme=erasure
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
#                               ...  name=ceph-erasure-pool-gib-8-3
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
#                                 ...    Name=ceph-erasure-pool-eib-4-2_ec_profile
#
#        ${pool_id}             PCC.Ceph Get Erasure Pool Id
#                               ...  name=ceph-erasure-pool-gib-8-3
#
#        ${response}            PCC.Ceph Erasure Pool Update
#                               ...  id=${pool_id}
#                               ...  name=ceph-erasure-pool-gib-8-3
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=data
#                               ...  resilienceScheme=erasure
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
#                                 ...    Name=ceph-erasure-pool-gib-8-3_ec_profile
#
#        ${pool_id}             PCC.Ceph Get Erasure Pool Id
#                               ...  name=ceph-erasure-pool-gib-8-3
#
#        ${response}            PCC.Ceph Erasure Pool Update
#                               ...  id=${pool_id}
#                               ...  name=@!#^&%$
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  size=${CEPH_POOL_SIZE}
#                               ...  tags=${CEPH_POOL_TAGS}
#                               ...  pool_type=data
#                               ...  resilienceScheme=erasure
#                               ...  quota=3
#                               ...  quota_unit=${CEPH_POOL_QUOTA_UNIT}
#                               ...  ErasureCodeProfileID=${erasure_profile_id}
#
#                               Log To Console    ${response}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Not Be Equal As Strings      ${status_code}  200
#
###################################################################################################################################
Ceph Rbd Creation with Erasure Coded Pool
###################################################################################################################################

        [Documentation]            *Creating Ceph Rbd*
                               ...  keywords:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Create Rbd

        [Tags]    xyz

        ${cluster_id}          PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_Cluster_NAME}

        ${pool_id}             PCC.Ceph Get Pool Id
                               ...  name=ceph-erasure-pool-mib-2-1

	${metadata_pool_id}    PCC.Ceph Get Pool Id
                               ...  name=pool9

        ${response}            PCC.Ceph Create Rbd
			       ...  pool_type=erasure
			       ...  ceph_metadata_pool_id=${metadata_pool_id}		
                               ...  name=ceph-rbd-erasure-1
                               ...  ceph_cluster_id=${cluster_id}
                               ...  ceph_pool_id=${pool_id}
                               ...  size=1
                               ...  tags=${CEPH_RBD_TAGS}
                               ...  image_feature=${CEPH_RBD_IMG}
                               ...  size_units=GiB

        ${status_code}         Get Response Status Code        ${response}
                               Should Be Equal As Strings      ${status_code}  200


        ${status}              PCC.Ceph Wait Until Rbd Ready
                               ...  name=ceph-rbd-erasure-1

                               Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Get CEPH Inet IP
###################################################################################################################################

        [Documentation]    *Get CEPH Inet IP* test

        [Tags]    RBD

        ${inet_ip}     PCC.Get CEPH Inet IP
                       ...    hostip=${CLUSTERHEAD_1_HOST_IP}


                       Log To Console    ${inet_ip}
                       Set Global Variable    ${inet_ip}

###################################################################################################################################
RBD Mount use case (2-1 erasure coded pool)
###################################################################################################################################
	
	[Documentation]    *RBD Mount test cases with erasure pool* test
	[Tags]    Mount_test
        ###  Get INET IP  ###
        ${inet_ip}     PCC.Get CEPH Inet IP
                       ...    hostip=${CLUSTERHEAD_1_HOST_IP}

                       Log To Console    ${inet_ip}
                       Set Global Variable    ${inet_ip}

        ###  Get Stored size before mount  ###
        ${size_erasure_pool_before_mount}      PCC.Get Stored Size for Erasure Pool
                                                  ...    hostip=${SERVER_2_HOST_IP}
                                                  ...    pool_name=ceph-erasure-pool-mib-2-1
                                                  Log To Console    ${size_erasure_pool_before_mount}
                                                  Set Suite Variable    ${size_erasure_pool_before_mount}

        ###  Mount RBD to Mount Point  ###


        ${status}    Create mount folder
                     ...    mount_folder_name=test_rbd_mnt
                     ...    hostip=${SERVER_2_HOST_IP}
                     ...    user=${PCC_LINUX_USER}
                     ...    password=${PCC_LINUX_PASSWORD}

                     Log To Console    ${status}
                     Should be equal as strings    ${status}    OK

        ${status}    PCC.Map RBD
		     ...    name=ceph-rbd-erasure-1
		     ...    pool_name=pool9
		     ...    inet_ip=${inet_ip}
		     ...    hostip=${SERVER_2_HOST_IP}
                     ...    username=${PCC_LINUX_USER}
                     ...    password=${PCC_LINUX_PASSWORD}
		     Log To Console    ${status}
                     Should be equal as strings    ${status}    OK
		
		
		${status}      PCC.Mount RBD to Mount Point
                       ...    mount_folder_name=test_rbd_mnt
                       ...    hostip=${SERVER_2_HOST_IP}
                       ...    username=${PCC_LINUX_USER}
                       ...    password=${PCC_LINUX_PASSWORD}

                       Log To Console    ${status}
                       Should be equal as strings    ${status}    OK

                       Sleep    1 minutes 

        ${status}      Create dummy file and copy to mount path
                       ...    dummy_file_name=test_rbd_mnt_4mb.bin
                       ...    dummy_file_size=4MiB
                       ...    mount_folder_name=test_rbd_mnt
                       ...    hostip=${SERVER_2_HOST_IP}
                       ...    user=${PCC_LINUX_USER}
                       ...    password=${PCC_LINUX_PASSWORD}  

                       Log To Console    ${status}
                       Should be equal as strings    ${status}    OK     

                       Sleep    2 minutes  


        ###  Get Stored size after mount  ###
        ${size_erasure_pool_after_mount}     PCC.Get Stored Size for Erasure Pool
                                                ...    hostip=${SERVER_2_HOST_IP}
                                                ...    pool_name=ceph-erasure-pool-mib-2-1

                                                Log To Console    ${size_erasure_pool_after_mount}
                                                Set Suite Variable    ${size_erasure_pool_after_mount}
                                                Should Be True    ${size_erasure_pool_after_mount} > ${size_erasure_pool_before_mount}
		
		###  Unmount and unmap RBD  ###
		${status}		PCC.Unmount and Unmap RBD
						...    mount_folder_name=test_rbd_mnt
						...    hostip=${SERVER_2_HOST_IP}
                        ...    username=${PCC_LINUX_USER}
                        ...    password=${PCC_LINUX_PASSWORD}
						
						Log To Console    ${status}
                        Should be equal as strings    ${status}    OK
						
		${status}    Remove dummy file
                     ...    dummy_file_name=test_rbd_mnt_4mb.bin
                     ...    hostip=${SERVER_2_HOST_IP} 
		     ...    user=${PCC_LINUX_USER}
                     ...    password=${PCC_LINUX_PASSWORD}
					 Log To Console    ${status}
                     Should be equal as strings    ${status}    OK


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
#                               ...#  resilienceScheme=${POOL_RESILIENCE_SCHEME}
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
#                               ...  name=ceph-erasure-pool-pib-4-2
#
#        ${default}             PCC.Ceph Get Pool Details For FS
#                               ...  name=ceph-erasure-pool-tib-8-4
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
#        ${status}               PCC.Ceph Fs Verify BE
#                                ...  name=ceph-fs-erasure-coded-1
#                                ...  user=${PCC_LINUX_USER}
#                                ...  password=${PCC_LINUX_PASSWORD}
#                                ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
#
#                                Should Be Equal As Strings      ${status}    OK
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
#                               ...  name=ceph-erasure-pool-mib-4-2
#
#        ${data}                PCC.Ceph Get Pool Details For FS
#                               ...  name=ceph-erasure-pool-eib-4-2
#
#        ${default}             PCC.Ceph Get Pool Details For FS
#                               ...  name=ceph-erasure-pool-pib-4-2
#
#        ${response}            PCC.Ceph Create Fs
#                               ...  name=ceph-fs-erasure-coded-negative
#                               ...  ceph_cluster_id=${cluster_id}
#                               ...  metadata_pool=${meta}
#                               ...  default_pool=${default}
#                               ...  data_pool=[${data}]
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
#                       ...    hostip=${SERVER_2_HOST_IP}
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-8-4
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
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
#                       ...    hostip=${SERVER_2_HOST_IP}
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-8-4
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
#        ${inet_ip}     PCC.Get CEPH Inet IP
#                       ...    hostip=${CLUSTERHEAD_1_HOST_IP}
#
#                       Log To Console    ${inet_ip}
#                       Set Global Variable    ${inet_ip}
#
#        ${status}    Create mount folder
#                     ...    mount_folder_name=test_fs_mnt
#                     ...    hostip=${SERVER_2_HOST_IP}
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}
#
#                     Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#        ${status}      PCC.Mount FS to Mount Point
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${SERVER_2_HOST_IP}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#		               ...    inet_ip=${inet_ip}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    1 minutes
#
#        ${status}      Create dummy file and copy to mount path
#                       ...    dummy_file_name=test_fs_mnt_1mb.bin
#                       ...    dummy_file_size=1MiB
#                       ...    mount_folder_name=test_fs_mnt
#                       ...    hostip=${SERVER_2_HOST_IP}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#                       Sleep    2 minutes
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
#                       ...    hostip=${SERVER_2_HOST_IP}
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-8-4
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
#                       ...    inet_ip=${inet_ip}
#                       ...    hostip=${SERVER_1_HOST_IP}
#                       ...    username=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
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
#                       ...    hostip=${SERVER_2_HOST_IP}
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-8-4
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
#                       ...    hostip=${SERVER_2_HOST_IP}
#                       ...    erasure_pool_name=ceph-erasure-pool-tib-8-4
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
#                       ...    hostip=${SERVER_2_HOST_IP}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#        ${status}    Remove dummy file
#                     ...    dummy_file_name=test_fs_mnt_1mb.bin
#                     ...    hostip=${SERVER_2_HOST_IP}
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}
#
#		             Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
#
#        ${status}      PCC.Unmount FS
#                       ...    hostip=${SERVER_1_HOST_IP}
#                       ...    user=${PCC_LINUX_USER}
#                       ...    password=${PCC_LINUX_PASSWORD}
#                       ...    mount_folder_name=test_fs_mnt
#
#                       Log To Console    ${status}
#                       Should be equal as strings    ${status}    OK
#
#        ${status}    Remove dummy file
#                     ...    dummy_file_name=test_fs_mnt_1mb.bin
#                     ...    hostip=${SERVER_1_HOST_IP}
#                     ...    user=${PCC_LINUX_USER}
#                     ...    password=${PCC_LINUX_PASSWORD}
#
#		             Log To Console    ${status}
#                     Should be equal as strings    ${status}    OK
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
#        ############  Deleting ceph-erasure-pool-mib-4-2  ################
#
#        ${id}                  PCC.Ceph Get Pool Id
#                               ...  name=ceph-erasure-pool-mib-4-2
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
