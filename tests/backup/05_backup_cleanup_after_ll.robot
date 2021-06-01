*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

        [Tags]    certs

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
                                    Should be equal as strings    ${status}    OK
        
        ${server1_id}               PCC.Get Node Id    Name=${SERVER_1_NAME}
                                    Log To Console    ${server1_id}
                                    Set Global Variable    ${server1_id}                 
                    
        ${server2_id}               PCC.Get Node Id    Name=${SERVER_2_NAME}
                                    Log To Console    ${server2_id}
                                    Set Global Variable    ${server2_id}
                                    
        ${server3_id}               PCC.Get Node Id    Name=${SERVER_3_NAME}
                                    Log To Console    ${server3_id}
                                    Set Global Variable    ${server3_id}
                                    
        ${invader1_id}              PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
                                    Log To Console    ${invader1_id}
                                    Set Global Variable    ${invader1_id}
                                    
        ${invader2_id}              PCC.Get Node Id    Name=${CLUSTERHEAD_2_NAME}
                                    Log To Console    ${invader2_id}
                                    Set Global Variable    ${invader2_id}
                                                                        
###################################################################################################################################
Cleanup Auth Profiles after login as Admin user
###################################################################################################################################
        
        [Documentation]         *Clean-up Auth Profiles* test
                                ...  keywords:
                                ...  PCC.Delete All Auth Profile     
        
        [Tags]    Tenant
        ########  Cleanup Auth Profile   ################################################################################
        
        ${result}               PCC.Delete All Auth Profile
                    
                                Log to Console    ${result}
                                Should Be Equal As Strings    ${result}    OK
                                
                                Sleep    1 minutes
                                
        ${status}               PCC.CR Wait For CR updation
                                ...    Name=${CR_NAME}
                                
                                Log to Console    ${status}
                                Should Be Equal As Strings    ${status}    OK
                          
####################################################################################################################################
Cleanup Container Registry after login as Admin user: TCP-839
####################################################################################################################################
        
        [Documentation]         *Cleanup all CR* test
                                ...  keywords:
                                ...  PCC.Clean all CR
                                ...  PCC.Wait for deletion of CR
                
        ${result}               PCC.Clean all CR
                    
                                Log to Console    ${result}
                                Should Be Equal As Strings    ${result}    OK
                                
                    
        ${result}               PCC.Wait for deletion of CR
                                
                                Log to Console    ${result}
                                Should Be Equal As Strings    ${result}    OK
                                          
####################################################################################################################################
Re-assigning ROOT to Node 
####################################################################################################################################
        
        [Documentation]         *Re-assigning ROOT user to Node* test
                                ...  keywords:
                                ...  PCC.Get Tenant Id   
                                ...  PCC.Assign Tenant to Node                   
                     
        ########  Getting ROOT ID   #######################################################################################  
                   
        ${tenant_id}            PCC.Get Tenant Id
                                ...    Name=ROOT
                                Set Global Variable    ${tenant_id} 
        
        ########  Assigning Tenant to Node   ################################################################################                
                        
        ${response}             PCC.Assign Tenant to Node
                                ...    tenant=${tenant_id}
                                ...    ids=${server1_id}
                                
                                Log To Console    ${response}
                                ${status}    Get From Dictionary    ${response}    StatusCode
                                Should Be Equal As Strings    ${status}    200
 
                                    
###################################################################################################################################
Delete Key
###################################################################################################################################
                
        
        [Documentation]             *Delete Key* test
                        
                                    
        ${response}                 PCC.Delete OpenSSH Key
                                    ...  Alias=${PUBLIC_KEY_ALIAS}
                                    
                                    Log To Console    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Be Equal As Strings    ${status}    200
                       
###################################################################################################################################
Delete All Node Groups :TCP-361
###################################################################################################################################

        [Documentation]             *Delete All Node Groups* test
                                    ...  keywords:
                                    ...  PCC.Get Tenant Id
                                    ...  PCC.Add Node Group
                                    ...  PCC.Validate Node Group
       
        ${status}                   PCC.Delete all Node groups
                                           
                                    Log To Console    ${status}
                                    Should Be Equal As Strings    ${status}    OK    Node group still exists  
                     
###################################################################################################################################
Delete All Profiles : TCP-1443
###################################################################################################################################

        [Documentation]             *PCC.Delete All Profiles* test
                                    ...  keywords:
                                    ...  PCC.Delete All Profiles
             
        ${response}                 PCC.Delete All Profiles                      
                                    Log To Console    ${response}  
                       
###################################################################################################################################
Ceph Rgw Delete Multiple
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Delete Multiple*
                               ...  keywords:
                               ...  PCC.Ceph Delete All Rgw

        ${status}                   PCC.Ceph Delete All Rgw
                                    Should be equal as strings    ${status}    OK

###################################################################################################################################
Delete Certificate : TCP-1233
###################################################################################################################################
                
        
        [Documentation]             *Delete Certificate* test
        [Tags]    certs              
                
        ${response}                 PCC.Delete Certificate
                                    ...  Alias=Cert_with_pvt_cert
                
                                    Log To Console    ${response}
                                    ${status}    Get From Dictionary    ${response}    StatusCode
                                    Should Be Equal As Strings    ${status}    200

##################################################################################################################
Cepf FS unmount
##################################################################################################################

        ###  Unmount FS and removing file created while FS mount ###
        ${status}      PCC.Unmount FS
                       ...    hostip=${SERVER_2_HOST_IP}
                       ...    user=${PCC_LINUX_USER}
                       ...    password=${PCC_LINUX_PASSWORD}
                       ...    mount_folder_name=test_fs_mnt

                       Log To Console    ${status}
                       Should be equal as strings    ${status}    OK

         ${status}    Remove dummy file
                     ...    dummy_file_name=test_fs_mnt_1mb.bin
                     ...    hostip=${SERVER_2_HOST_IP}
                     ...    user=${PCC_LINUX_USER}
                     ...    password=${PCC_LINUX_PASSWORD}

		     Log To Console    ${status}
                     Should be equal as strings    ${status}    OK


###################################################################################################################
Ceph Rbd Unmout
###################################################################################################################

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

                                                                                                
###################################################################################################################################
Ceph Fs Delete : TCP-808
###################################################################################################################################
    [Documentation]                 *Delete Fs if it exist*   
                               ...  keywords:
                               ...  PCC.Ceph Delete All Fs

        ${status}                   PCC.Ceph Delete All Fs
                                    Should be equal as strings    ${status}    OK
                                    
###################################################################################################################################
Ceph Rbd Delete Multiple : TCP-571
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Delete Multiple*
                               ...  keywords:
                               ...  PCC.Ceph Delete All Rbds


        ${status}                   PCC.Ceph Delete All Rbds
                                    Should be equal as strings    ${status}    OK
                               

###################################################################################################################################
Ceph Pool Multiple Delete: TCP-572,TCP-573
###################################################################################################################################

        #rbd
        ${id}                  PCC.Ceph Get Pool Id
                               ...  name=rbd
                               Pass Execution If    ${id} is ${None}    Pool is alredy Deleted

        ${response}            PCC.Ceph Delete Pool
                               ...  id=${id}

        ${status_code}         Get Response Status Code        ${response}
                               Should Be Equal As Strings      ${status_code}  200

        ${status}              PCC.Ceph Wait Until Pool Deleted
                               ...  id=${id}
                               Should Be Equal     ${status}  OK

        #rgw
        ${id}                  PCC.Ceph Get Pool Id
                               ...  name=rgw
                               Pass Execution If    ${id} is ${None}    Pool is alredy Deleted

        ${response}            PCC.Ceph Delete Pool
                               ...  id=${id}

        ${status_code}         Get Response Status Code        ${response}
                               Should Be Equal As Strings      ${status_code}  200

        ${status}              PCC.Ceph Wait Until Pool Deleted
                               ...  id=${id}
                               Should Be Equal     ${status}  OK

        #fs1
        ${id}                  PCC.Ceph Get Pool Id
                               ...  name=fs1
                               Pass Execution If    ${id} is ${None}    Pool is alredy Deleted

        ${response}            PCC.Ceph Delete Pool
                               ...  id=${id}

        ${status_code}         Get Response Status Code        ${response}
                               Should Be Equal As Strings      ${status_code}  200

        ${status}              PCC.Ceph Wait Until Pool Deleted
                               ...  id=${id}
                               Should Be Equal     ${status}  OK

        #fs2
        ${id}                  PCC.Ceph Get Pool Id
                               ...  name=fs2
                               Pass Execution If    ${id} is ${None}    Pool is alredy Deleted

        ${response}            PCC.Ceph Delete Pool
                               ...  id=${id}

        ${status_code}         Get Response Status Code        ${response}
                               Should Be Equal As Strings      ${status_code}  200

        ${status}              PCC.Ceph Wait Until Pool Deleted
                               ...  id=${id}
                               Should Be Equal     ${status}  OK

        #fs3
        ${id}                  PCC.Ceph Get Pool Id
                               ...  name=fs3
                               Pass Execution If    ${id} is ${None}    Pool is alredy Deleted

        ${response}            PCC.Ceph Delete Pool
                               ...  id=${id}

        ${status_code}         Get Response Status Code        ${response}
                               Should Be Equal As Strings      ${status_code}  200

        ${status}              PCC.Ceph Wait Until Pool Deleted
                               ...  id=${id}
                               Should Be Equal     ${status}  OK

        #rgw-erasure-pool
        ${id}                  PCC.Ceph Get Pool Id
                               ...  name=rgw-erasure-pool
                               Pass Execution If    ${id} is ${None}    Pool is alredy Deleted

        ${response}            PCC.Ceph Delete Pool
                               ...  id=${id}

        ${status_code}         Get Response Status Code        ${response}
                               Should Be Equal As Strings      ${status_code}  200

        ${status}              PCC.Ceph Wait Until Pool Deleted
                               ...  id=${id}
                               Should Be Equal     ${status}  OK

        #${CEPH_RGW_POOLNAME}
        ${id}                  PCC.Ceph Get Pool Id
                               ...  name=${CEPH_RGW_POOLNAME}
                               Pass Execution If    ${id} is ${None}    Pool is alredy Deleted

        ${response}            PCC.Ceph Delete Pool
                               ...  id=${id}

        ${status_code}         Get Response Status Code        ${response}
                               Should Be Equal As Strings      ${status_code}  200

        ${status}              PCC.Ceph Wait Until Pool Deleted
                               ...  id=${id}
                               Should Be Equal     ${status}  OK


###################################################################################################################################
PCC-Users Deletion : TCP-332
###################################################################################################################################

        [Documentation]    *Delete Admin User* test
                           ...  keywords:
                           ...  PCC.Delete User

        ${response}    PCC.Delete User
                       ...     Username=${READONLY_USER_PCC_USERNAME}

                        Log To Console    ${response}
                        ${result}    Get Result    ${response}
                        ${status}    Get From Dictionary    ${response}    StatusCode
                        Should Be Equal As Strings    ${status}    200

        ${response}    PCC.Delete User
                       ...     Username=${TENANT_USER_PCC_USERNAME}

                        Log To Console    ${response}
                        ${result}    Get Result    ${response}
                        ${status}    Get From Dictionary    ${response}    StatusCode
                        Should Be Equal As Strings    ${status}    200



###################################################################################################################################
Alert Delete Raw Rule :TCP-1088
###################################################################################################################################
    [Documentation]                 *Alert Delete Raw Rule *
                               ...  Keywords:
                               ...  PCC.Alert Delete Rule
                               ...  PCC.Alert Verify Rule

        ${status}                   PCC.Alert Delete All Rule
                                    Should Be Equal As Strings      ${status}  OK

