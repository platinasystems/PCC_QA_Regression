*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

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
        
        ${server1_id}    PCC.Get Node Id    Name=${SERVER_1_NAME}
                         Log To Console    ${server1_id}
                         Set Global Variable    ${server1_id}                 
        
        ${server2_id}    PCC.Get Node Id    Name=${SERVER_2_NAME}
                         Log To Console    ${server2_id}
                         Set Global Variable    ${server2_id}
                         
        ${server3_id}    PCC.Get Node Id    Name=${SERVER_3_NAME}
                         Log To Console    ${server3_id}
                         Set Global Variable    ${server3_id}
                         
        ${invader1_id}    PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
                          Log To Console    ${invader1_id}
                          Set Global Variable    ${invader1_id}
                          
        ${invader2_id}    PCC.Get Node Id    Name=${CLUSTERHEAD_2_NAME}
                          Log To Console    ${invader2_id}
                          Set Global Variable    ${invader2_id}

###################################################################################################################################
Ceph K8s Multiple
###################################################################################################################################
    [Documentation]                 *Deleting all Pools*
                               ...  keywords:
                               ...  PCC.K8s Delete All Cluster
                               
        ${status}                   PCC.K8s Delete All Cluster
                                    Should be equal as strings    ${status}    OK
                                                                        
###################################################################################################################################
Cleanup Auth Profiles after login as Admin user
###################################################################################################################################
        
        [Documentation]    *Clean-up Auth Profiles* test
                           ...  keywords:
                           ...  PCC.Delete All Auth Profile     
        
        [Tags]    Tenant
        ########  Cleanup Auth Profile   ################################################################################
        
        ${result}    PCC.Delete All Auth Profile
        
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                     
                     Sleep    1 minutes
                     
        ${status}    PCC.CR Wait For CR updation
                     ...    Name=${CR_NAME}
                     
                     Log to Console    ${status}
                     Should Be Equal As Strings    ${status}    OK
                          
####################################################################################################################################
Cleanup Container Registry after login as Admin user
####################################################################################################################################
        
        [Documentation]    *Cleanup all CR* test
                           ...  keywords:
                           ...  PCC.Clean all CR
                           ...  PCC.Wait for deletion of CR
        
        ${result}    PCC.Clean all CR
        
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                     
        
        ${result}    PCC.Wait for deletion of CR
                     
                     Log to Console    ${result}
                     Should Be Equal As Strings    ${result}    OK
                                          
####################################################################################################################################
Re-assigning ROOT to Node 
####################################################################################################################################
        
        [Documentation]    *Re-assigning ROOT user to Node* test
                           ...  keywords:
                           ...  PCC.Get Tenant Id   
                           ...  PCC.Assign Tenant to Node                   
                     
        ########  Getting ROOT ID   #######################################################################################  
                   
        ${tenant_id}    PCC.Get Tenant Id
                        ...    Name=ROOT
                        Set Global Variable    ${tenant_id} 
        
        ########  Assigning Tenant to Node   ################################################################################                
                        
        ${response}    PCC.Assign Tenant to Node
                       ...    tenant=${tenant_id}
                       ...    ids=${server1_id}
                      
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
 
###################################################################################################################################
Deleting Maas From Nodes
###################################################################################################################################
    [Documentation]                 *Deleting Maas+LLDP From Nodes*
                               ...  Keywords:
                               ...  PCC.Delete and Verify Roles On Nodes
                               ...  PCC.Wait Until Roles Ready On Nodes
                               
        ${response}                 PCC.Delete and Verify Roles On Nodes
                               ...  nodes=["${CLUSTERHEAD_1_NAME}"]
                               ...  roles=["Baremetal Management Node"]
                                    Should Be Equal As Strings      ${response}  OK

        ${status_code}              PCC.Wait Until Roles Ready On Nodes
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                                    Should Be Equal As Strings      ${status_code}  OK

        ${response}                 PCC.Maas Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                                    Should Not Be Equal As Strings      ${response}  OK
                                    
###################################################################################################################################
Delete Key
###################################################################################################################################
                
        
        [Documentation]    *Delete Key* test
        
                       
        ${response}    PCC.Delete OpenSSH Key
                       ...  Alias=${PUBLIC_KEY_ALIAS}
                       
                       Log To Console    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       

                       
###################################################################################################################################
Delete All Node Roles
###################################################################################################################################

        [Documentation]    *Delete All Node Roles* test
                           ...  keywords:
                           ...  PCC.Delete all Node roles
        [Tags]    Only

        ${status}    PCC.Delete all Node roles
                       
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node group still exists  

###################################################################################################################################
Delete All Node Groups
###################################################################################################################################

        [Documentation]    *Delete All Node Groups* test
                           ...  keywords:
                           ...  PCC.Get Tenant Id
                           ...  PCC.Add Node Group
                           ...  PCC.Validate Node Group
        [Tags]    Only

        ${status}    PCC.Delete all Node groups
                       
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node group still exists  
                     
###################################################################################################################################
Delete All Profiles
###################################################################################################################################

        [Documentation]    *PCC.Delete All Profiles* test
                           ...  keywords:
                           ...  PCC.Delete All Profiles
        
        
        
        ${response}    PCC.Delete All Profiles
                       
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
Delete Certificate
###################################################################################################################################
                
        
        [Documentation]    *Delete Certificate* test
        [Tags]    Cert
        
                       
        ${response}    PCC.Delete Certificate
                       ...  Alias=Cert_with_pvt_cert
  
                       Log To Console    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                       
        ${response}    PCC.Delete Certificate
                       ...  Alias=${CEPH_RGW_CERT_NAME}
  
                       Log To Console    ${response}
                       ${status}    Get From Dictionary    ${response}    StatusCode
                       Should Be Equal As Strings    ${status}    200
                                                           
###################################################################################################################################
Ceph Fs Delete
###################################################################################################################################
    [Documentation]                 *Delete Fs if it exist*   
                               ...  keywords:
                               ...  PCC.Ceph Delete All Fs

        ${status}                   PCC.Ceph Delete All Fs
                                    Should be equal as strings    ${status}    OK
                                    
###################################################################################################################################
Ceph Rbd Delete Multiple
###################################################################################################################################
    [Documentation]                 *Ceph Rbd Delete Multiple*
                               ...  keywords:
                               ...  PCC.Ceph Delete All Rbds


        ${status}                   PCC.Ceph Delete All Rbds
                                    Should be equal as strings    ${status}    OK
                               

###################################################################################################################################
Ceph Pool Multiple Delete
###################################################################################################################################
    [Documentation]                 *Deleting all Pools*
                               ...  keywords:
                               ...  CC.Ceph Delete All Pools
                               
        ${status}                   PCC.Ceph Delete All Pools
                                    Should be equal as strings    ${status}    OK

###################################################################################################################################
Ceph Cluster Delete
###################################################################################################################################
    [Documentation]                 *Delete cluster if it exist*
                               ...  keywords:
                               ...  PCC.Ceph Delete All Cluster

        ${status}                   PCC.Ceph Delete All Cluster
                                    Should be equal as strings    ${status}    OK
                                    
###################################################################################################################################
BE Ceph Cleanup
###################################################################################################################################
 
        ${status}                   PCC.Ceph Cleanup BE
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               
                                    Should be equal as strings    ${status}    OK

###################################################################################################################################
Network Manager Delete
###################################################################################################################################
    [Documentation]                 *Delete Network Manager if it exist*
                               ...  keywords:
                               ...  PCC.Network Manager Delete All

        ${status}                   PCC.Network Manager Delete All
                                    Should be equal as strings    ${status}    OK

###################################################################################################################################
Delete Multiple Subnet
###################################################################################################################################
    [Documentation]                 *Delete IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Delete All

        ${status}                   PCC.Ipam Subnet Delete All                          
                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
PCC Multiple Tenant deletion
###################################################################################################################################

        [Documentation]    *PCC Multiple Tenant deletion* test
                           ...  keywords:
                           ...  PCC.Delete Multiple Tenants
        
        [Tags]    Delete
                           
        ${status}    PCC.Delete Multiple Tenants
                       ...    Tenant_list=["${TENANT1}"] 
                       
                       Log To Console    ${status}
                       Should Be Equal As Strings    ${status}    OK    Not Deleted
					   
###################################################################################################################################
Policy driven management cleanup
###################################################################################################################################
		
		[Documentation]    *Policy driven management cleanup* test
                           ...  keywords:
                           ...  PCC.Delete Multiple Tenants
		
		####  Removing Node roles from node ####
		${response}                 PCC.Delete and Verify Roles On Nodes
								    ...  nodes=["${SERVER_2_NAME}"]
								    ...  roles=["DNS_NODE_ROLE"]

                                    Should Be Equal As Strings      ${response}  OK


        ${status_code}              PCC.Wait Until Roles Ready On Nodes
                                    ...  node_name=${SERVER_2_NAME}

                                    Should Be Equal As Strings      ${status_code}  OK				   
						   
		####  Deleting Node role from PCC  ####
		${status}    PCC.Delete all Node roles
                       
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role still exists
					 
		####  Removing policies from Scope  ####
		
		${parent1_Id}    PCC.Get Scope Id
                         ...  scope_name=region-1
                         Log To Console    ${parent1_Id}
        
		${response}    PCC.Update Scope
                       ...  Id=${parent1_Id}
                       ...  type=region
                       ...  scope_name=region-1
                       ...  description=region-description
                       ...  parentID=
                       ...  policyIDs=[]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
					   
		####  Assigning Default rack to node  ####
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
                       ...  node_names=['${SERVER_2_NAME}']
                       ...  scopeId=${scope_id}
                       
                       Log to Console    ${status}
                       Should Be Equal As Strings    ${status}    OK
		
		####  Delete All Locations  ####
		${response}    PCC.Delete Scope
                       ...  scope_name=region-1
                       
                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200
		
		####  Delete All Policies  ####
		${status}    PCC.Delete All Policies
                       
                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK
                                                                                                                                          
#####################################################################################################################################
Delete Nodes
#####################################################################################################################################

    [Documentation]    *Delete Nodes* test                 
    [Tags]    delete

        ${network_id}              PCC.Get Network Manager Id
                              ...  name=${NETWORK_MANAGER_NAME}
                                   Pass Execution If    ${network_id} is not ${None}    Network Cluster is Present Deleting Aborted

        ${status}                  PCC.Delete mutliple nodes and wait until deletion
                              ...  Names=['${CLUSTERHEAD_1_NAME}', '${CLUSTERHEAD_2_NAME}', '${SERVER_1_NAME}','${SERVER_2_NAME}','${SERVER_3_NAME}']

                                   Log To Console    ${status}
                                   Should be equal as strings    ${status}    OK

###################################################################################################################################
Nodes Verification Back End (Services should not be active)
###################################################################################################################################
    [Documentation]                      *Nodes Verification Back End*
                                    ...  keywords:
                                    ...  PCC.Node Verify Back End

        ${status}                   PCC.Node Verify Back End
                                    ...  host_ips=["${SERVER_2_HOST_IP}","${SERVER_1_HOST_IP}","${SERVER_3_HOST_IP}","${CLUSTERHEAD_1_HOST_IP}","${CLUSTERHEAD_2_HOST_IP}"]
                                    Should Not Be Equal As Strings      ${status}    OK
