*** Settings ***
Resource    pcc_resources.robot
Library    Collections

*** Variables ***
${pcc_setup}    pcc_242

*** Test Cases ***
###################################################################################################################################
Login to PCC.
###################################################################################################################################
        
        [Documentation]    *Login to PCC* test
        
        [Tags]    add
        ${status}        Login To PCC    ${pcc_setup}
                         Should Be Equal    ${status}  OK
                         
                         Load Clusterhead 1 Test Data    ${pcc_setup}
                         Load Clusterhead 2 Test Data    ${pcc_setup}
                         Load Server 1 Test Data    ${pcc_setup}
                         Load Server 2 Test Data    ${pcc_setup}
                         Load Tunneling Data    ${pcc_setup}
                                 
#####################################################################################################################################
#Delete All Nodes
#####################################################################################################################################
#
#    [Documentation]    *Delete All Nodes* test                 
#    [Tags]    delete
#    
#    ${status}    PCC.Delete mutliple nodes and wait until deletion
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    OK
#
####################################################################################################################################
#Tunnel On
####################################################################################################################################
#
#    [Documentation]    *Tunnel On* test  
#    
#    [Tags]    nodes    
#    ${response}    Tunnel Turn On
#                   ...  cidr_val=${CIDR_VAL}
#                   ...  hostip=${PCC_HOST_IP}
#                       
#                   Log To Console    ${response}
#                   
####################################################################################################################################
#Verification of Tunneling from backend
####################################################################################################################################                   
#
#    
#    [Documentation]   *Verification of Tunneling from backend* Test
#    [Tags]    nodes
#        
#    ${status}    Updated pccserver.yml with cidr value
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  cidr_val=${CIDR_VAL}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                     
#
#    ${status}    Restart Container and Check up Status
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  setup_password=${PCC_SETUP_PWD}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                 Sleep    3 minutes
#
####################################################################################################################################
#Addition of nodes and checking Tun interfaces
####################################################################################################################################                   
#
#    
#    [Documentation]   *Addition of nodes and checking Tun interfaces* Test
#    
#    [Tags]    nodes
#
#                 
#    ##################### Add Invader #####################
#        
#        PCC.Add Node
#        ...  Name=${CLUSTERHEAD_1_NAME}
#        ...  Host=${CLUSTERHEAD_1_HOST_IP}
#        
#    ######### Wait for invader to get added to PCC ########
#        
#        PCC.Wait Until Node Ready
#        ...  Name=${CLUSTERHEAD_1_NAME}  
#                     
#        
#    ${status}    Tun command execution
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#                 
#                 Log To Console    ${status}
#                 
#                 ${tun_val}    Set Variable    ${status}[0]
#                 
#                 Log To Console    ${tun_val}
#                 Set Global Variable    ${tun_val}
#                 
#                 ${peer_IP}    Set Variable    ${status}[1]
#                 
#                 Log To Console    ${peer_IP}
#                 Set Global Variable    ${peer_IP}
#                 
#                 ${inet_IP}    Set Variable    ${status}[2]
#                 
#                 Log To Console    ${inet_IP}
#                 Set Global Variable    ${inet_IP}
#    
#    ${status}    Peer IP Address Reachability
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#                 ...  interface_ip=${peer_IP}
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                     
#                     
#    ${status}    Verify Profile_node.json
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#                 ...  list_of_nodes=[${peer_IP}]
#                 ...  hostip=${PCC_HOST_IP}
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#    
#    
#    ${status}    Tun value validation
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  tun_value=${tun_val}
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                 
#    
#    ############ Add Server ###########################
#    
#        PCC.Add Node
#        ...  Name=${SERVER_1_NAME}
#        ...  Host=${SERVER_1_HOST_IP}
#    
#    ###### Wait for server to get added to PCC ########
#    
#        PCC.Wait Until Node Ready
#        ...  Name=${SERVER_1_NAME}
#                 
#
#    ${status}    Verify Profile_node.json
#                 ...  node_hostip=${SERVER_1_HOST_IP}
#                 ...  list_of_nodes=[${CLUSTERHEAD_1_HOST_IP}]
#                 ...  hostip=${PCC_HOST_IP}
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                 
#    
#    ${status}    Kafka memory validation
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  host_name=${CLUSTERHEAD_1_NAME}
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                 
#    
#    ${status}    Kafka CPU validation
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  host_name=${CLUSTERHEAD_1_NAME}
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#    
#
####################################################################################################################################
#Restart tunnel and verify all traffic and connectivity
####################################################################################################################################
#
#    [Documentation]   *Restart tunnel and verify all traffic and connectivity* Test
#    
#    [Tags]    run
#    
#    ${status}    Restart Tunnel interface from invader
#                 ...  tun_value=${tun_val}
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#                 ...  interface_ip=${peer_IP}
#                 ...  host_name=${CLUSTERHEAD_1_NAME}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                     
####################################################################################################################################
#Kill tunnel operation and verify all traffic and connectivity
####################################################################################################################################
#
#    [Documentation]   *Kill tunnel operation and verify all traffic and connectivity* Test
#    
#    [Tags]    run
#    ${status}    Kill Tunnel interface from PCC
#                 ...  tun_value=${tun_val}
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  interface_ip=${peer_IP}
#                 ...  host_name=${CLUSTERHEAD_1_NAME}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
                     
                     
####################################################################################################################################
#Check regular keep alive packets to make SSH tunnel up & running
####################################################################################################################################                    
#
#    [Documentation]   *Check regular keep alive packets to make SSH tunnel up & running* Test
#    
#    [Tags]    nodes
#    
#    ${status}    Peer IP Address Reachability
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#                 ...  interface_ip=${peer_IP} 
#                     
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                     
#                     
#    ${status}    Peer IP Address Reachability
#                 ...  node_hostip=${PCC_HOST_IP}
#                 ...  interface_ip=${inet_IP}
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
                     

    
####################################################################################################################################
#Shutdown Tunneling from PCC
####################################################################################################################################                   
#
#    
#    [Documentation]   *Shutting down Tunneling Interface from PCC* Test
#    
#    [Tags]    run
#    
#    ${status}    Tunnel interface switch from PCC
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  tun_switch=down
#                 ...  tun_value=${tun_val}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True  
#                     
#                     
#    ${status}    Peer IP Address Reachability
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#                 ...  interface_ip=${peer_IP}
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                 
#    
#    ${status}    Kafka memory validation
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  host_name=${CLUSTERHEAD_1_NAME}
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                 
#    
#    ${status}    Kafka CPU validation
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  host_name=${CLUSTERHEAD_1_NAME}
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#    
####################################################################################################################################
#Down SSH tunnel (by making the tunnel interface down) and verify auto establish SSH session
####################################################################################################################################    
#
#    [Documentation]   *Shutting down Tunneling Interface from Invader* Test
#    
#    [Tags]    run
#    
#    ${status}    Tunnel interface switch from PCC
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  tun_switch=up
#                 ...  tun_value=${tun_val}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                     
#                     
#    ${status}    Tunnel interface switch from invader
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#                 ...  tun_switch=down
#                 ...  tun_value=${tun_val}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True 
#                 
#                 
#    ${status}    Peer IP Address Reachability
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#                 ...  interface_ip=${peer_IP}
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                 
#    
#    ${status}    Kafka memory validation
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  host_name=${CLUSTERHEAD_1_NAME}
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                 
#    
#    ${status}    Kafka CPU validation
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  host_name=${CLUSTERHEAD_1_NAME}
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#
#    
#    ${status}    Peer IP Address Reachability
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#                 ...  interface_ip=${peer_IP} 
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                     
#                     
#    ${status}    Peer IP Address Reachability
#                 ...  node_hostip=${PCC_HOST_IP}
#                 ...  interface_ip=${inet_IP}
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
    
           
    
####################################################################################################################################
#Add Invader connected to respective Server and Verify Profile_node.json
####################################################################################################################################                   
#
#    
#    [Documentation]   *Add Invader connected to respective Server and Verify Profile_node.json* Test    
#    
#    [Tags]    nodes
#    
#    
#    ###################### Add Invader #######################
#    
#        PCC.Add Node
#        ...  Name=${CLUSTERHEAD_2_NAME}
#        ...  Host=${CLUSTERHEAD_2_HOST_IP}
#        
#    ############# Wait for invader to get added to PCC #######
#    
#        PCC.Wait Until Node Ready
#        ...  Name=${CLUSTERHEAD_2_NAME}
#   
#    
#    ${status}    Verify Profile_node.json
#                 ...  node_hostip=${SERVER_1_HOST_IP}
#                 ...  list_of_nodes=[${CLUSTERHEAD_2_HOST_IP},${CLUSTERHEAD_1_HOST_IP}]
#                 ...  hostip=${PCC_HOST_IP}
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                 
#                       
#
####################################################################################################################################
#Restart Invader and Verify Tunneling after restart
####################################################################################################################################
#
#    [Documentation]   *Restart Invader and Verify Tunneling after restart* Test
#
#    [Tags]    restart
#    ${restart_status}    Restart node
#                         ...  hostip=${CLUSTERHEAD_1_HOST_IP}
#                         ...  time_to_wait=240
#                         Log to console    ${restart_status}
#                         Should Be Equal As Strings    ${restart_status}    OK
#                         Sleep    6 minutes
#
#    ${status}    Tun command execution
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#
#                 Log To Console    ${status}
#
#                 ${tun_val}    Set Variable    ${status}[0]
#
#                 Log To Console    ${tun_val}
#                 Set Global Variable    ${tun_val}
#
#                 ${peer_IP}    Set Variable    ${status}[1]
#
#                 Log To Console    ${peer_IP}
#                 Set Global Variable    ${peer_IP}
#
#                 ${inet_IP}    Set Variable    ${status}[2]
#
#                 Log To Console    ${inet_IP}
#                 Set Global Variable    ${inet_IP}     
#
#
#    ${status}    Peer IP Address Reachability
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#                 ...  interface_ip=${peer_IP}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#
#    ${status}    Kafka memory validation
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  host_name=${CLUSTERHEAD_1_NAME}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#
#
#    ${status}    Kafka CPU validation
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  host_name=${CLUSTERHEAD_1_NAME}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#
#                    
####################################################################################################################################
#Restart PCC-Setup and Verify Tunneling after restart
####################################################################################################################################
#
#    [Documentation]   *Restart PCC-Setup and Verify Tunneling after restart* Test
#    
#    [Tags]    restart
#    ${restart_status}    Restart node
#                         ...  hostip=${PCC_HOST_IP}
#                         ...  time_to_wait=240
#                         Log to console    ${restart_status}
#                         Should Be Equal As Strings    ${restart_status}    OK
#                         Sleep    6 minutes
#
#    ${status}    Tun command execution
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#
#                 Log To Console    ${status}
#
#                 ${tun_val}    Set Variable    ${status}[0]
#
#                 Log To Console    ${tun_val}
#                 Set Global Variable    ${tun_val}
#
#                 ${peer_IP}    Set Variable    ${status}[1]
#
#                 Log To Console    ${peer_IP}
#                 Set Global Variable    ${peer_IP}
#
#                 ${inet_IP}    Set Variable    ${status}[2]
#
#                 Log To Console    ${inet_IP}
#                 Set Global Variable    ${inet_IP}     
#
#
#    ${status}    Peer IP Address Reachability
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#                 ...  interface_ip=${peer_IP}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#
#    ${status}    Kafka memory validation
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  host_name=${CLUSTERHEAD_1_NAME}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#
#
#    ${status}    Kafka CPU validation
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  host_name=${CLUSTERHEAD_1_NAME}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                 
#                 
####################################################################################################################################
#Restart Server and Verify Profile Node.json file
####################################################################################################################################
#
#    [Documentation]   *Restart Server and Verify Profile Node.json file* Test
#
#    [Tags]    restart
#    ${restart_status}    Restart node
#                         ...  hostip=${SERVER_1_HOST_IP}
#                         ...  time_to_wait=240
#                         Log to console    ${restart_status}
#                         Should Be Equal As Strings    ${restart_status}    OK
#                         Sleep    6 minutes
#
#    ${status}    Tun command execution
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#
#                 Log To Console    ${status}
#
#                 ${tun_val}    Set Variable    ${status}[0]
#
#                 Log To Console    ${tun_val}
#                 Set Global Variable    ${tun_val}
#
#                 ${peer_IP}    Set Variable    ${status}[1]
#
#                 Log To Console    ${peer_IP}
#                 Set Global Variable    ${peer_IP}
#
#                 ${inet_IP}    Set Variable    ${status}[2]
#
#                 Log To Console    ${inet_IP}
#                 Set Global Variable    ${inet_IP}
#
#    ${status}    Verify Profile_node.json
#                 ...  node_hostip=${SERVER_1_HOST_IP}
#                 ...  list_of_nodes=[${CLUSTERHEAD_2_HOST_IP},${CLUSTERHEAD_1_HOST_IP}]
#                 ...  hostip=${PCC_HOST_IP}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#
#
#####################################################################################################################################
#Tunnel Off
#####################################################################################################################################
#
#    [Documentation]    *Tunnel Off* test
#        
#    [Tags]    restart
#    
#    ${response}    Tunnel Turn Off
#                   ...  hostip=${PCC_HOST_IP} 
#                       
#                   Log To Console    ${response}
#                   Should be equal as strings    ${response}    True
#                   
#####################################################################################################################################
#Verify Tunnel Tunnel Off
#####################################################################################################################################
#
#    [Documentation]    *Verify Tunnel Turn Off* test
#    [Tags]    restart
#
#    ${status}    Restart Container and Check up Status
#                 ...  hostip=${PCC_HOST_IP}
#                 ...  setup_password=${PCC_SETUP_PWD}
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
#                 Sleep    3 minutes
#
#
#
#####################################################################################################################################
#Delete Nodes
#####################################################################################################################################
#
#    [Documentation]    *Delete Nodes* test                 
#    [Tags]    delete
#    
#    ${status}    PCC.Delete mutliple nodes and wait until deletion
#                 ...  Names=['${CLUSTERHEAD_1_NAME}', '${CLUSTERHEAD_2_NAME}', '${SERVER_1_NAME}']
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    OK
#                 
#####################################################################################################################################
#Add Nodes
#####################################################################################################################################
#
#    [Documentation]    *Add Nodes* test                 
#    [Tags]    add
#    
#    ${status}    PCC.Add mutliple nodes and check online
#                 ...  host_ips=['${CLUSTERHEAD_1_HOST_IP}', '${CLUSTERHEAD_2_HOST_IP}', '${SERVER_1_HOST_IP}']
#                 ...  Names=['${CLUSTERHEAD_1_NAME}', '${CLUSTERHEAD_2_NAME}', '${SERVER_1_NAME}']
#
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    OK
#
#####################################################################################################################################
#Tun command check after adding nodes
#####################################################################################################################################
#
#    [Documentation]    *Tun command check after adding nodes* test                  
#    [Tags]    restart
#    
#    ${status}    Tun command execution
#                 ...  node_hostip=${CLUSTERHEAD_1_HOST_IP}
#                 ...  restart=Restarted
#                 
#                 Log To Console    ${status}
#                 Should be equal as strings    ${status}    True
                 
