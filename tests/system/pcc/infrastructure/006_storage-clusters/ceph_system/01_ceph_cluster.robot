*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Ceph Rbd Data    ${pcc_setup}
                                    Load Ceph Pool Data    ${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup} 
                                    Load Network Manager Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Network Manager Creation
###################################################################################################################################
    [Documentation]                *Network Manager Creation*
                              ...  keywords:
                              ...  PCC.Network Manager Create
                             
        ${network_id}              PCC.Get Network Manager Id
                              ...  name=${NETWORK_MANAGER_NAME}
                                   Pass Execution If    ${network_id} is not ${None}    Network is already there
                             
        ${response}                PCC.Network Manager Create
                              ...  name=${NETWORK_MANAGER_NAME}
                              ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}","${CLUSTERHEAD_1_NAME}"]
                              ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                              ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}
                             
        ${status_code}             Get Response Status Code        ${response}     
                                   Should Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Cluster Creation with 2 nodes both servers (Negative)
###################################################################################################################################
    [Documentation]                *Creating a cluster - Creation with 2 nodes*
                              ...  keywords:
                              ...  PCC.Ceph Create Cluster

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Pass Execution If    ${id} is not ${None}    Cluster is alredy there
                             
        ${response}                PCC.Ceph Create Cluster
                              ...  name=${CEPH_CLUSTER_NAME}
                              ...  nodes=["${SERVER_1_NAME}", "${SERVER_2_NAME}"]
                              ...  tags=["ALL"]
                              ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
                             
        ${status_code}             Get Response Status Code  ${response}
                                   Should Not Be Equal As Strings  ${status_code}  200

###################################################################################################################################
Ceph Cluster Creation without name (Negative)
###################################################################################################################################
    [Documentation]                *Creating a cluster - without name*
                              ...  keywords:
                              ...  PCC.Ceph Create Cluster

        ${id}                      PCC.Ceph Get Cluster Id
                              ...  name=${CEPH_CLUSTER_NAME}
                                   Pass Execution If    ${id} is not ${None}    Cluster is alredy there
                              
        ${response}                PCC.Ceph Create Cluster
                              ...  name=""
                              ...  nodes=${CEPH_CLUSTER_NODES}
                              ...  tags=["ALL"]
                              ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}             Get Response Status Code  ${response}
                                   Should Not Be Equal As Strings  ${status_code}  200


###################################################################################################################################
Ceph Cluster Creation with invalid name (Negative)
###################################################################################################################################
    [Documentation]                *Creating a cluster - with invalid name*
                              ...  keywords:
                              ...  PCC.Ceph Create Cluster

        ${id}                      PCC.Ceph Get Cluster Id
                              ...  name=${CEPH_CLUSTER_NAME}
                                   Pass Execution If    ${id} is not ${None}    Cluster is alredy there  
                    
        ${response}                PCC.Ceph Create Cluster
                              ...  name="!@#$%^"
                              ...  nodes=${CEPH_CLUSTER_NODES}
                              ...  tags=["ALL"]
                              ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}             Get Response Status Code  ${response}
                                   Should Not Be Equal As Strings  ${status_code}  200


###################################################################################################################################
Ceph Cluster Creation without selecting any nodes (Negative)
###################################################################################################################################
    [Documentation]                *Creating a cluster - without selecting any nodes* 
                              ...  keywords:
                              ...  PCC.Ceph Create Cluster

        ${id}                      PCC.Ceph Get Cluster Id
                              ...  name=${CEPH_CLUSTER_NAME}
                                   Pass Execution If    ${id} is not ${None}    Cluster is alredy there
                              
        ${response}                PCC.Ceph Create Cluster
                              ...  name=${CEPH_CLUSTER_NAME}
                              ...  nodes=[]
                              ...  tags=["ALL"]
                              ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}             Get Response Status Code  ${response}
                                   Should Not Be Equal As Strings  ${status_code}  200


###################################################################################################################################
Ceph Cluster Creation without tags (Negative)
###################################################################################################################################
    [Documentation]                *Creating a cluster - without tags*
                              ...  keywords:
                              ...  PCC.Ceph Create Cluster

        ${id}                      PCC.Ceph Get Cluster Id
                              ...  name=${CEPH_CLUSTER_NAME}
                                   Pass Execution If    ${id} is not ${None}    Cluster is alredy there
                              
        ${response}                PCC.Ceph Create Cluster
                              ...  name=${CEPH_CLUSTER_NAME}
                              ...  nodes=${CEPH_CLUSTER_NODES}
                              ...  tags=[]
                              ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}             Get Response Status Code  ${response}
                                   Should Not Be Equal As Strings  ${status_code}  200

###################################################################################################################################
Ceph Cluster with one node (Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster with one node*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${id}                      PCC.Ceph Get Cluster Id
                              ...  name=${CEPH_CLUSTER_NAME}
                                   Pass Execution If    ${id} is not ${None}    Cluster is alredy there

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=["${SERVER_2_NAME}"]
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Cluster with two node one server one invader(Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster with two node*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${id}                      PCC.Ceph Get Cluster Id
                              ...  name=${CEPH_CLUSTER_NAME}
                                   Pass Execution If    ${id} is not ${None}    Cluster is alredy there

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=["${SERVER_2_NAME}", "${CLUSTERHEAD_1_NAME}"]
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    

###################################################################################################################################
Ceph Cluster Create 
###################################################################################################################################
    [Documentation]                 *Creating Ceph Cluster*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${id}                      PCC.Ceph Get Cluster Id
                              ...  name=${CEPH_CLUSTER_NAME}
                                   Pass Execution If    ${id} is not ${None}    Cluster is alredy there

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME}

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Cluster Verification Back End
###################################################################################################################################
    [Documentation]                 *Verifying Ceph cluster BE*
                               ...  keywords:
                               ...  PCC.Ceph Verify BE

        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Ceph Cluster Creation With Nodes Which Are Part of Existing Cluster (Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster Creation With Nodes Which Are Part of Existing Cluster*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Cluster Update - Add Invader
###################################################################################################################################
    [Documentation]                 *Ceph Cluster Update - Add Invade*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready


        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_2_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK
                                    
##################################################################################################################################
Reboot Node And Verify Ceph is Intact
##################################################################################################################################
    [Documentation]                 *Verifying Ceph cluster BE*
                               ...  keywords:
                               ...  Ceph Verify BE
                               ...  Restart node

    ${restart_status}               Restart node
                               ...  hostip=${SERVER_1_HOST_IP}
                               ...  time_to_wait=240
                                    Log to console    ${restart_status}
                                    Should Be Equal As Strings    ${restart_status}    OK

        ${status}                   PCC.Ceph Verify BE
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]

                                    Should Be Equal As Strings      ${status}    OK
							   
###################################################################################################################################
TCP-1012 Update Cluster(2 Invader setup) - Remove - Remove TWO OSD nodes from cluster [4 nodes (3 MONs + 2 OSDs)] (Negative)
###################################################################################################################################
    [Documentation]                 *Update Cluster(2 Invader setup) - Remove - Remove TWO OSD nodes from cluster [4 nodes (3 MONs + 2 OSDs)]*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  nodes=["${CLUSTERHEAD_2_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200

####################################################################################################################################
#TCP-1016 Ceph Cluster Update - Remove Invader
####################################################################################################################################
#    [Documentation]                 *Ceph Cluster Update - Remove Invader*
#                               ...  keyword:
#                               ...  PCC.Ceph Get Cluster Id
#                               ...  PCC.Ceph Cluster Update
#                               ...  PCC.Ceph Wait Until Cluster Ready
#
#        ${id}                       PCC.Ceph Get Cluster Id
#                               ...  name=${CEPH_CLUSTER_NAME}
#
#        ${response}                 PCC.Ceph Cluster Update
#                               ...  id=${id}
#                               ...  nodes=[${SERVER_2_NAME},${SERVER_1_NAME},${CLUSTERHEAD_1_NAME}]
#                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#
#        ${status}                   PCC.Ceph Wait Until Cluster Ready
#                               ...  name=${CEPH_CLUSTER_NAME}
#                                    Should Be Equal As Strings      ${status}    OK
#							   																		
###################################################################################################################################	
TCP-981 Update Cluster - Try to rename cluster Name (Negative)
###################################################################################################################################
    [Documentation]                 *Update Cluster - Try to rename cluster Name*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
							   

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
													
###################################################################################################################################	
TCP-985 Update Cluster - Try to add Tags
###################################################################################################################################
    [Documentation]                 *Update Cluster - Try to add Tags*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  tags=["ROTATIONAL","SOLID_STATE","SATA/SAS"]
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
							   
        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
													
	${status}                   PCC.Ceph Wait Until Cluster Ready
                               ...  name=${CEPH_CLUSTER_NAME}
                                    Should Be Equal As Strings      ${status}    OK
							  
###################################################################################################################################	
TCP-985 Update Cluster - Try to remove Tags (Negative)
###################################################################################################################################
    [Documentation]                 *Update Cluster - Try to remove Tags*
                               ...  keyword:
                               ...  PCC.Ceph Get Cluster Id
                               ...  PCC.Ceph Cluster Update
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${id}                       PCC.Ceph Get Cluster Id
                               ...  name=${CEPH_CLUSTER_NAME}

        ${response}                 PCC.Ceph Cluster Update
                               ...  id=${id}
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=["${SERVER_2_NAME}","${SERVER_1_NAME}","${CLUSTERHEAD_1_NAME}"]
                               ...  tags=["ROTATIONAL","SOLID_STATE"]
                               ...  networkClusterName=${CEPH_CLUSTER_NETWORK}
							   

        ${status_code}              Get Response Status Code        ${response}
                                    Should Not Be Equal As Strings      ${status_code}  200
