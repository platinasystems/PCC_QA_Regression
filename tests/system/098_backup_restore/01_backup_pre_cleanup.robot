#*** Settings ***
#Resource    pcc_resources.robot
#
#*** Variables ***
#${pcc_setup}                 pcc_212
#
#*** Test Cases ***
####################################################################################################################################
#Login
####################################################################################################################################
#
#                                    Load Clusterhead 1 Test Data        ${pcc_setup}
#                                    Load Clusterhead 2 Test Data        ${pcc_setup}
#                                    Load Server 2 Test Data        ${pcc_setup}
#                                    Load Server 1 Test Data        ${pcc_setup}
#                                    Load Server 3 Test Data        ${pcc_setup}
#                                    Load Network Manager Data    ${pcc_setup} 
#                                    Load Container Registry Data    ${pcc_setup}
#                                    Load Auth Profile Data    ${pcc_setup}
#                                    Load OpenSSH_Keys Data    ${pcc_setup}
#                                    Load Ceph Cluster Data    ${pcc_setup}
#                                    Load Ceph Pool Data    ${pcc_setup}
#                                    Load Ceph Rbd Data    ${pcc_setup}
#                                    Load Ceph Fs Data    ${pcc_setup}
#                                    Load Ceph Rgw Data    ${pcc_setup}
#                                    Load Tunneling Data    ${pcc_setup}
#                                    Load K8s Data    ${pcc_setup}
#                                    Load PXE-Boot Data    ${pcc_setup}
#                                    Load Alert Data    ${pcc_setup}
#                                    Load SAS Enclosure Data    ${pcc_setup}
#                                    Load Ipam Data    ${pcc_setup}
#                                    Load Certificate Data    ${pcc_setup}
#                                    Load i28 Data    ${pcc_setup}
#                                    Load OS-Deployment Data    ${pcc_setup}
#                                    Load Tenant Data    ${pcc_setup}
#                                    Load Node Roles Data    ${pcc_setup}
#                                    Load Node Groups Data    ${pcc_setup}
#                                    
#        ${status}                   Login To PCC        testdata_key=${pcc_setup}
#                                    Should be equal as strings    ${status}    OK
#        
#        ${server1_id}               PCC.Get Node Id    Name=${SERVER_1_NAME}
#                                    Log To Console    ${server1_id}
#                                    Set Global Variable    ${server1_id}                 
#                    
#        ${server2_id}               PCC.Get Node Id    Name=${SERVER_2_NAME}
#                                    Log To Console    ${server2_id}
#                                    Set Global Variable    ${server2_id}
#                                    
#        ${server3_id}               PCC.Get Node Id    Name=${SERVER_3_NAME}
#                                    Log To Console    ${server3_id}
#                                    Set Global Variable    ${server3_id}
#                                    
#        ${invader1_id}              PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
#                                    Log To Console    ${invader1_id}
#                                    Set Global Variable    ${invader1_id}
#                                    
#        ${invader2_id}              PCC.Get Node Id    Name=${CLUSTERHEAD_2_NAME}
#                                    Log To Console    ${invader2_id}
#                                    Set Global Variable    ${invader2_id}
#                                                                        
####################################################################################################################################
#Cleanup Auth Profiles after login as Admin user
####################################################################################################################################
#        
#        [Documentation]         *Clean-up Auth Profiles* test
#                                ...  keywords:
#                                ...  PCC.Delete All Auth Profile     
#        
#        [Tags]    Tenant
#        ########  Cleanup Auth Profile   ################################################################################
#        
#        ${result}               PCC.Delete All Auth Profile
#                    
#                                Log to Console    ${result}
#                                Should Be Equal As Strings    ${result}    OK
#                                
#                                Sleep    1 minutes
#                                
#        ${status}               PCC.CR Wait For CR updation
#                                ...    Name=${CR_NAME}
#                                
#                                Log to Console    ${status}
#                                Should Be Equal As Strings    ${status}    OK
#                          
#####################################################################################################################################
#Cleanup Container Registry after login as Admin user
#####################################################################################################################################
#        
#        [Documentation]         *Cleanup all CR* test
#                                ...  keywords:
#                                ...  PCC.Clean all CR
#                                ...  PCC.Wait for deletion of CR
#                
#        ${result}               PCC.Clean all CR
#                    
#                                Log to Console    ${result}
#                                Should Be Equal As Strings    ${result}    OK
#                                
#                    
#        ${result}               PCC.Wait for deletion of CR
#                                
#                                Log to Console    ${result}
#                                Should Be Equal As Strings    ${result}    OK
#                                          
#####################################################################################################################################
#Re-assigning ROOT to Node 
#####################################################################################################################################
#        
#        [Documentation]         *Re-assigning ROOT user to Node* test
#                                ...  keywords:
#                                ...  PCC.Get Tenant Id   
#                                ...  PCC.Assign Tenant to Node                   
#                     
#        ########  Getting ROOT ID   #######################################################################################  
#                   
#        ${tenant_id}            PCC.Get Tenant Id
#                                ...    Name=ROOT
#                                Set Global Variable    ${tenant_id} 
#        
#        ########  Assigning Tenant to Node   ################################################################################                
#                        
#        ${response}             PCC.Assign Tenant to Node
#                                ...    tenant=${tenant_id}
#                                ...    ids=${server1_id}
#                                
#                                Log To Console    ${response}
#                                ${status}    Get From Dictionary    ${response}    StatusCode
#                                Should Be Equal As Strings    ${status}    200
# 
#                                    
####################################################################################################################################
#Delete Key
####################################################################################################################################
#                
#        
#        [Documentation]             *Delete Key* test
#                        
#                                    
#        ${response}                 PCC.Delete OpenSSH Key
#                                    ...  Alias=${PUBLIC_KEY_ALIAS}
#                                    
#                                    Log To Console    ${response}
#                                    ${status}    Get From Dictionary    ${response}    StatusCode
#                                    Should Be Equal As Strings    ${status}    200
#                       
####################################################################################################################################
#Delete All Node Groups
####################################################################################################################################
#
#        [Documentation]             *Delete All Node Groups* test
#                                    ...  keywords:
#                                    ...  PCC.Get Tenant Id
#                                    ...  PCC.Add Node Group
#                                    ...  PCC.Validate Node Group
#       
#        ${status}                   PCC.Delete all Node groups
#                                           
#                                    Log To Console    ${status}
#                                    Should Be Equal As Strings    ${status}    OK    Node group still exists  
#                     
####################################################################################################################################
#Delete All Profiles
####################################################################################################################################
#
#        [Documentation]             *PCC.Delete All Profiles* test
#                                    ...  keywords:
#                                    ...  PCC.Delete All Profiles
#             
#        ${response}                 PCC.Delete All Profiles                      
#                                    Log To Console    ${response}  
#                       
####################################################################################################################################
#Ceph Rgw Delete Multiple
####################################################################################################################################
#    [Documentation]                 *Ceph Rbd Delete Multiple*
#                               ...  keywords:
#                               ...  PCC.Ceph Delete All Rgw
#
#        ${status}                   PCC.Ceph Delete All Rgw
#                                    Should be equal as strings    ${status}    OK
#
####################################################################################################################################
#Delete Certificate
####################################################################################################################################
#                
#        
#        [Documentation]             *Delete Certificate* test
#        [Tags]    Cert              
#        ${response}                 PCC.Delete Certificate
#                                    ...  Alias=Cert_without_pvt_cert
#                
#                                    Log To Console    ${response}
#                                    ${status}    Get From Dictionary    ${response}    StatusCode
#                                    Should Be Equal As Strings    ${status}    200
#                                    
#        ${response}                 PCC.Delete Certificate
#                                    ...  Alias=Cert_with_pvt_cert
#                
#                                    Log To Console    ${response}
#                                    ${status}    Get From Dictionary    ${response}    StatusCode
#                                    Should Be Equal As Strings    ${status}    200
#                                                                                                
########################             ############################################################################################################
#Ceph Fs Delete
####################################################################################################################################
#    [Documentation]                 *Delete Fs if it exist*   
#                               ...  keywords:
#                               ...  PCC.Ceph Delete All Fs
#
#        ${status}                   PCC.Ceph Delete All Fs
#                                    Should be equal as strings    ${status}    OK
#                                    
####################################################################################################################################
#Ceph Rbd Delete Multiple
####################################################################################################################################
#    [Documentation]                 *Ceph Rbd Delete Multiple*
#                               ...  keywords:
#                               ...  PCC.Ceph Delete All Rbds
#
#
#        ${status}                   PCC.Ceph Delete All Rbds
#                                    Should be equal as strings    ${status}    OK
#                               
#
####################################################################################################################################
#Ceph Pool Multiple Delete
####################################################################################################################################
#    [Documentation]                 *Deleting all Pools*
#                               ...  keywords:
#                               ...  CC.Ceph Delete All Pools
#                               
#        ${status}                   PCC.Ceph Delete All Pools
#                                    Should be equal as strings    ${status}    OK
#                                    
####################################################################################################################################
#PCC Multiple Tenant deletion
####################################################################################################################################
#
#        [Documentation]           *PCC Multiple Tenant deletion* test
#                                  ...  keywords:
#                                  ...  PCC.Delete Multiple Tenants
#                                  
#        ${status}                 PCC.Delete Multiple Tenants
#                                  ...    Tenant_list=['Test_Tenant_4','Test_Tenant_5'] 
#                                  
#                                  Log To Console    ${status}
#                                  Should Be Equal As Strings    ${status}    OK    Not Deleted
