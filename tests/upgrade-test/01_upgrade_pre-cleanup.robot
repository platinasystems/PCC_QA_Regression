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

        ${server1_id}                PCC.Get Node Id    Name=${SERVER_1_NAME}
                                     Log To Console    ${server1_id}
                                     Set Global Variable    ${server1_id}

        ${server2_id}                PCC.Get Node Id    Name=${SERVER_2_NAME}
                                     Log To Console    ${server2_id}
                                     Set Global Variable    ${server2_id}

        ${server3_id}                PCC.Get Node Id    Name=${SERVER_3_NAME}
                                     Log To Console    ${server3_id}
                                     Set Global Variable    ${server3_id}

        ${invader1_id}               PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
                                     Log To Console    ${invader1_id}
                                     Set Global Variable    ${invader1_id}

        ${invader2_id}               PCC.Get Node Id    Name=${CLUSTERHEAD_2_NAME}
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

        [Documentation]        *Clean-up Auth Profiles* test
                               ...  keywords:
                               ...  PCC.Delete All Auth Profile

        ${result}                PCC.Delete All Auth Profile

                                 Log to Console    ${result}
                                 Should Be Equal As Strings    ${result}    OK

                     #Sleep    1 minutes

        ${cr_id}                PCC.Get CR Id
                                ...    Name=${CR_NAME}
                                Pass Execution If    ${cr_id} is ${None}    ${CR_NAME} Not Present on PCC

        ${status}                PCC.CR Wait For CR updation
                                 ...    Name=${CR_NAME}

                                 Log to Console    ${status}
                                 Should Be Equal As Strings    ${status}    OK

####################################################################################################################################
Cleanup Container Registry after login as Admin user
####################################################################################################################################

        [Documentation]            *Cleanup all CR* test
                                   ...  keywords:
                                   ...  PCC.Clean all CR
                                   ...  PCC.Wait for deletion of CR

        ${result}                PCC.Clean all CR

                                  Log to Console    ${result}
                                  Should Be Equal As Strings    ${result}    OK


        ${result}                PCC.Wait for deletion of CR

                                 Log to Console    ${result}
                                 Should Be Equal As Strings    ${result}    OK

####################################################################################################################################
Re-assigning ROOT to Node
####################################################################################################################################

        [Documentation]            *Re-assigning ROOT user to Node* test
                                    ...  keywords:
                                    ...  PCC.Get Tenant Id
                                    ...  PCC.Assign Tenant to Node



        ${tenant_id}                PCC.Get Tenant Id
                                    ...    Name=ROOT
                                    Set Global Variable    ${tenant_id}


        ${response}                PCC.Assign Tenant to Node
                                   ...    tenant=${tenant_id}
                                   ...    ids=${server1_id}

                                   Log To Console    ${response}
                                   ${status}    Get From Dictionary    ${response}    StatusCode
                                   Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Deleting Maas From Nodes
###################################################################################################################################
    [Documentation]                *Deleting Maas+LLDP From Nodes*
                                   ...  Keywords:
                                   ...  PCC.Delete and Verify Roles On Nodes
                                   ...  PCC.Wait Until Roles Ready On Nodes


	${response}                PCC.Delete and Verify Roles On Nodes
                               ...  nodes=["${CLUSTERHEAD_1_NAME}"]
                               ...  roles=["Baremetal Management Node"]
                               Should Be Equal As Strings      ${response}  OK

    ${status_code}                PCC.Wait Until Roles Ready On Nodes
                                  ...  node_name=${CLUSTERHEAD_1_NAME}
                                  Should Be Equal As Strings      ${status_code}  OK

    ${response}                PCC.Maas Verify BE
                               ...  nodes_ip=["${CLUSTERHEAD_1_HOST_IP}"]
                               ...  user=${PCC_LINUX_USER}
                               ...  password=${PCC_LINUX_PASSWORD}
                               Should Not Be Equal As Strings      ${response}  OK

###################################################################################################################################
Ceph Rgw Delete Multiple
###################################################################################################################################
    [Documentation]                *Ceph Rbd Delete Multiple*
                                   ...  keywords:
                                   ...  PCC.Ceph Delete All Rgw

    ${status}                PCC.Ceph Delete All Rgw
                             ...  ceph_cluster_name=ceph-pvt
                             Should be equal as strings    ${status}    OK


###################################################################################################################################
Ceph Fs Delete
###################################################################################################################################
    [Documentation]                *Delete Fs if it exist*
                                   ...  keywords:
                                   ...  PCC.Ceph Delete All Fs

    ${status}                PCC.Ceph Delete All Fs
                             Should be equal as strings    ${status}    OK

###################################################################################################################################
Ceph Rbd Delete Multiple
###################################################################################################################################
    [Documentation]                *Ceph Rbd Delete Multiple*
                                   ...  keywords:
                                   ...  PCC.Ceph Delete All Rbds

    ${status}                PCC.Ceph Delete All Rbds
                             Should be equal as strings    ${status}    OK


###################################################################################################################################
Ceph Pool Multiple Delete
###################################################################################################################################
    [Documentation]                *Deleting all Pools*
                                   ...  keywords:
                                   ...  CC.Ceph Delete All Pools

    ${status}                PCC.Ceph Delete All Pools
                             Should be equal as strings    ${status}    OK

###################################################################################################################################
Ceph Cluster Delete
###################################################################################################################################
    [Documentation]                *Delete cluster if it exist*
                                   ...  keywords:
                                   ...  PCC.Ceph Delete All Cluster

    ${status}                PCC.Ceph Delete All Cluster
                             Should be equal as strings    ${status}    OK

###################################################################################################################################
BE Ceph Cleanup
###################################################################################################################################

    ${status}                PCC.Ceph Cleanup BE
                             ...  nodes_ip=${CEPH_CLUSTER_NODES_IP}
                             ...  user=${PCC_LINUX_USER}
                             ...  password=${PCC_LINUX_PASSWORD}

                             Should be equal as strings    ${status}    OK

###################################################################################################################################
Network Manager Delete
###################################################################################################################################
    [Documentation]                *Delete Network Manager if it exist*
                                   ...  keywords:
                                   ...  PCC.Network Manager Delete All

    ${status}                PCC.Network Manager Delete All
                             Should be equal as strings    ${status}    OK

###################################################################################################################################
Delete Multiple Subnet
###################################################################################################################################
    [Documentation]                *Delete IPAM Subnet*
                                   ...  keywords:
                                   ...  PCC.Ipam Subnet Delete All

    ${status}                PCC.Ipam Subnet Delete All
                             Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Cleanup features associated to Node
###################################################################################################################################
    [Documentation]                *Deleting all Pools*
                                   ...  keywords:
                                   ...  PCC.Cleanup features associated to Node

    ${parent1_Id}                PCC.Get Scope Id
                                 ...  scope_name=Default region
                                 Log To Console    ${parent1_Id}

    ${parent2_Id}                PCC.Get Scope Id
                                 ...  scope_name=Default zone
                                 ...  parentID=${parent1_Id}
                                 Log To Console    ${parent2_Id}

    ${parent3_Id}                PCC.Get Scope Id
                                 ...  scope_name=Default site
                                 ...  parentID=${parent2_Id}
                                 Log To Console    ${parent3_Id}

    ${scope_id}                PCC.Get Scope Id
                               ...  scope_name=Default rack
                               ...  parentID=${parent3_Id}
                               Log To Console    ${scope_id}

    ${status}                PCC.Cleanup features associated to Node
                             ...    scopeId=${scope_id}
                             Log To Console    ${status}
                             Should Be Equal As Strings      ${status}  OK

####################################################################################################################################
Wait Until All Nodes Are Ready
####################################################################################################################################
    [Documentation]                *Cleanup all keys*
                                   ...  keywords:
                                   ...  PCC.Wait Until All Nodes Are Ready

    ${status}                PCC.Wait Until All Nodes Are Ready

                             Log To Console    ${status}
                             Should Be Equal As Strings      ${status}  OK


###################################################################################################################################
Delete All Node Roles
###################################################################################################################################

    [Documentation]                *Delete All Node Roles* test
                                   ...  keywords:
                                   ...  PCC.Delete all Node roles

    ${status}                PCC.Delete all Node roles

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK    Node roles still exists

####################################################################################################################################
Cleanup all certificates from PCC
####################################################################################################################################
    [Documentation]                *Cleanup all certificates*
                                   ...  keywords:
                                   ...  PCC.Delete All Certificates

    ${status}                PCC.Delete All Certificates

                             Log To Console    ${status}
                             Should be equal as strings    ${status}    OK

####################################################################################################################################
Cleanup all keys from PCC
####################################################################################################################################
    [Documentation]                *Cleanup all keys*
                                   ...  keywords:
                                   ...  PCC.Delete All Keys

    ${status}                PCC.Delete All Keys

                             Log To Console    ${status}
                             Should be equal as strings    ${status}    OK

###################################################################################################################################
Delete All Node Groups
###################################################################################################################################

    [Documentation]                *Delete All Node Groups* test
                                   ...  keywords:
                                   ...  PCC.Get Tenant Id
                                   ...  PCC.Add Node Group
                                   ...  PCC.Validate Node Group

    ${status}                PCC.Delete all Node groups

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK    Node group still exists

###################################################################################################################################
Delete All Profiles
###################################################################################################################################

    [Documentation]                *PCC.Delete All Profiles* test
                                   ...  keywords:
                                   ...  PCC.Delete All Profiles


    ${response}                PCC.Delete All Profiles

                               Log To Console    ${response}

###################################################################################################################################
Delete All Tenants
###################################################################################################################################

    [Documentation]                *PCC Multiple Tenant deletion* test
                                   ...  keywords:
                                   ...  PCC.Delete Multiple Tenants

    ${status}                PCC.Delete All Tenants


                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK    Not Deleted

###################################################################################################################################
Policy driven management cleanup
###################################################################################################################################

    [Documentation]                *Policy driven management cleanup* test
                                   ...  keywords:
                                   ...  PCC.Delete Multiple Tenants
                ###  Unassign locations from policies  ###
    ${status}                PCC.Unassign Locations Assigned from All Policies

                             Log to Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

                                ####  Delete All Policies  ####
    ${status}                PCC.Delete All Policies

                             Log To Console    ${status}
                             Should Be Equal As Strings    ${status}    OK

                                ####  Delete All Locations  ####
    ${status}                PCC.Check Scope Creation From PCC
                             ...  scope_name=region-1

                             Log To Console    ${status}
                             Pass Execution If    "${status}"    "Scope with name region-1 not found on PCC"

    ${response}                PCC.Delete Scope
                               ...  scope_name=region-1
                               ...  parentID=

                               Log To Console    ${response}
                               ${result}    Get Result    ${response}
                               ${status}    Get From Dictionary    ${result}    status
                               ${message}   Get From Dictionary    ${result}    message
                               Log To Console    ${message}
                               Should Be Equal As Strings    ${status}    200

###################################################################################################################################
Disable Firewall on CentOS
##################################################################################################################################

    [Documentation]                *Disable firewall on CentOS* test

    ${status}                Cli.Disable Firewall
                             ...  host_ip=${SERVER_2_HOST_IP}
                             ...  linux_user=${SERVER_2_UNAME}
                             ...  linux_password=${SERVER_2_PWD}
                             Log To Console    ${status}
                             Should be equal as strings    ${status}    OK

##### Uncommenting interface cleanup code for pcc242 nodes ######

###################################################################################################################################
Set Interfaces For ${CLUSTERHEAD_1_NAME}
###################################################################################################################################
    [Documentation]                *Set Interfaces For ${CLUSTERHEAD_1_NAME}(i43)*
                                   ...  keywords:
                                   ...  PCC.Interface Set 1D Link
                                   ...  PCC.Interface Apply
                                   ...  PCC.Interface Verify PCC
                                   ...  PCC.Wait Until Interface Ready

    ${response}                PCC.Interface Set 1D Link
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                               ...  interface_name=xeth5
                               ...  assign_ip=[]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=40000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

    ${status_code}                Get Response Status Code        ${response}
                                  Should Be Equal As Strings      ${status_code}  200
                                  Sleep    10s

    ${response}                PCC.Interface Apply
                               ...  node_name=${CLUSTERHEAD_1_NAME}

    ${status_code}                Get Response Status Code        ${response}
                                  Should Be Equal As Strings      ${status_code}  200

    ${status}                PCC.Wait Until Interface Ready
                             ...  node_name=${CLUSTERHEAD_1_NAME}
                             ...  interface_name=xeth5
                             Should Be Equal As Strings      ${status}    OK

    ${status}                PCC.Interface Verify PCC
                             ...  node_name=${CLUSTERHEAD_1_NAME}
                             ...  interface_name=xeth5
                             ...  assign_ip=[]
                             Should Be Equal As Strings      ${status}    OK

    ${response}                PCC.Interface Set 1D Link
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                               ...  interface_name=xeth1-1
                               ...  assign_ip=[]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

    ${status_code}                Get Response Status Code        ${response}
                                  Should Be Equal As Strings      ${status_code}  200
                                  Sleep    10s

    ${response}                PCC.Interface Apply
                               ...  node_name=${CLUSTERHEAD_1_NAME}

    ${status_code}                Get Response Status Code        ${response}
                                  Should Be Equal As Strings      ${status_code}  200

    ${status}                PCC.Wait Until Interface Ready
                             ...  node_name=${CLUSTERHEAD_1_NAME}
                             ...  interface_name=xeth1-1
                             Should Be Equal As Strings      ${status}    OK

    ${status}                PCC.Interface Verify PCC
                             ...  node_name=${CLUSTERHEAD_1_NAME}
                             ...  interface_name=xeth1-1
                             ...  assign_ip=[]
                             ...  cleanUp=yes
                             Should Be Equal As Strings      ${status}    OK

    ${response}                PCC.Interface Set 1D Link
                               ...  node_name=${CLUSTERHEAD_1_NAME}
                               ...  interface_name=xeth1-2
                               ...  assign_ip=[]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

    ${status_code}                Get Response Status Code        ${response}
                                  Should Be Equal As Strings      ${status_code}  200
                                  Sleep    10s

    ${response}                PCC.Interface Apply
                               ...  node_name=${CLUSTERHEAD_1_NAME}

    ${status_code}                Get Response Status Code        ${response}
                                  Should Be Equal As Strings      ${status_code}  200

    ${status}                PCC.Wait Until Interface Ready
                             ...  node_name=${CLUSTERHEAD_1_NAME}
                             ...  interface_name=xeth1-2
                             Should Be Equal As Strings      ${status}    OK

    ${status}                PCC.Interface Verify PCC
                             ...  node_name=${CLUSTERHEAD_1_NAME}
                             ...  interface_name=xeth1-2
                             ...  assign_ip=[]
                             ...  cleanUp=yes
                             Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Set Interfaces For ${CLUSTERHEAD_2_NAME}
###################################################################################################################################
    [Documentation]                *Set Interfaces For ${CLUSTERHEAD_2_NAME} (i42)*
                                   ...  keywords:
                                   ...  PCC.Interface Set 1D Link
                                   ...  PCC.Interface Apply
                                   ...  PCC.Interface Verify PCC
                                   ...  PCC.Wait Until Interface Ready

    ${response}                PCC.Interface Set 1D Link
                               ...  node_name=${CLUSTERHEAD_2_NAME}
                               ...  interface_name=xeth5
                               ...  assign_ip=[]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=40000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

    ${status_code}                Get Response Status Code        ${response}
                                  Should Be Equal As Strings      ${status_code}  200
                                  Sleep    10s

    ${response}                PCC.Interface Apply
                               ...  node_name=${CLUSTERHEAD_2_NAME}

    ${status_code}                Get Response Status Code        ${response}
                                  Should Be Equal As Strings      ${status_code}  200

    ${status}                PCC.Wait Until Interface Ready
                             ...  node_name=${CLUSTERHEAD_2_NAME}
                             ...  interface_name=xeth5
                             Should Be Equal As Strings      ${status}    OK

    ${status}                PCC.Interface Verify PCC
                             ...  node_name=${CLUSTERHEAD_2_NAME}
                             ...  interface_name=xeth5
                             ...  assign_ip=[]
                             Should Be Equal As Strings      ${status}    OK

    ${response}                PCC.Interface Set 1D Link
                               ...  node_name=${CLUSTERHEAD_2_NAME}
                               ...  interface_name=xeth1-1
                               ...  assign_ip=[]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

    ${status_code}                Get Response Status Code        ${response}
                                  Should Be Equal As Strings      ${status_code}  200
                                  Sleep    10s

    ${response}                PCC.Interface Apply
                               ...  node_name=${CLUSTERHEAD_2_NAME}
    ${status_code}              Get Response Status Code        ${response}
                                Should Be Equal As Strings      ${status_code}  200

    ${status}                PCC.Wait Until Interface Ready
                             ...  node_name=${CLUSTERHEAD_2_NAME}
                             ...  interface_name=xeth1-1
                             Should Be Equal As Strings      ${status}    OK

    ${status}                PCC.Interface Verify PCC
                             ...  node_name=${CLUSTERHEAD_2_NAME}
                             ...  interface_name=xeth1-1
                             ...  assign_ip=[]
                             ...  cleanUp=yes
                             Should Be Equal As Strings      ${status}    OK

    ${response}                PCC.Interface Set 1D Link
                               ...  node_name=${CLUSTERHEAD_2_NAME}
                               ...  interface_name=xeth1-2
                               ...  assign_ip=[]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

    ${status_code}                Get Response Status Code        ${response}
                                  Should Be Equal As Strings      ${status_code}  200
                                  Sleep    10s

    ${response}                PCC.Interface Apply
                               ...  node_name=${CLUSTERHEAD_2_NAME}

    ${status_code}                Get Response Status Code        ${response}
                                  Should Be Equal As Strings      ${status_code}  200

    ${status}                PCC.Wait Until Interface Ready
                             ...  node_name=${CLUSTERHEAD_2_NAME}
                             ...  interface_name=xeth1-2
                             Should Be Equal As Strings      ${status}    OK
    ${status}                PCC.Interface Verify PCC
                             ...  node_name=${CLUSTERHEAD_2_NAME}
                             ...  interface_name=xeth1-2
                             ...  assign_ip=[]
                             ...  cleanUp=yes
                             Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Set Interfaces For ${SERVER_1_NAME}
###################################################################################################################################
    [Documentation]                 *Set Interfaces For ${SERVER_1_NAME}*
                               ...  keywords:
                               ...  PCC.Interface Set 1D Link
                               ...  PCC.Interface Apply
                               ...  PCC.Interface Verify PCC
                               ...  PCC.Wait Until Interface Ready

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0
                               ...  assign_ip=[]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${SERVER_1_NAME}
        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name${SERVER_1_NAME}
                               ...  interface_name=enp129s0
                                    Should Be Equal As Strings      ${status}    OK
        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0
                               ...  assign_ip=[]
                               ...  cleanUp=yes
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0d1
                               ...  assign_ip=[]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${SERVER_1_NAME}
        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name${SERVER_1_NAME}
                               ...  interface_name=enp129s0d1
                                    Should Be Equal As Strings      ${status}    OK
        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_1_NAME}
                               ...  interface_name=enp129s0d1
                               ...  assign_ip=[]
                               ...  cleanUp=yes
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Set Interfaces For ${SERVER_2_NAME}
###################################################################################################################################
    [Documentation]                 *Set Interfaces For ${SERVER_2_NAME} (sv125)*
                               ...  keywords:
                               ...  PCC.Interface Set 1D Link
                               ...  PCC.Interface Apply
                               ...  PCC.Interface Verify PCC
                               ...  PCC.Wait Until Interface Ready

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${SERVER_2_NAME}
                               ...  interface_name=enp129s0
                               ...  assign_ip=[]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${SERVER_2_NAME}
        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name${SERVER_2_NAME}
                               ...  interface_name=enp129s0
                                    Should Be Equal As Strings      ${status}    OK
        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_2_NAME}
                               ...  interface_name=enp129s0
                               ...  assign_ip=[]
                               ...  cleanUp=yes
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${SERVER_2_NAME}
                               ...  interface_name=enp129s0d1
                               ...  assign_ip=[]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=10000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${SERVER_2_NAME}
        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name${SERVER_2_NAME}
                               ...  interface_name=enp129s0d1
                                    Should Be Equal As Strings      ${status}    OK
        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_2_NAME}
                               ...  interface_name=enp129s0d1
                               ...  assign_ip=[]
                               ...  cleanUp=yes
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Set Interfaces For ${SERVER_3_NAME}
###################################################################################################################################
    [Documentation]                 *Set Interfaces For ${SERVER_3_NAME} (sv110)*
                               ...  keywords:
                               ...  PCC.Interface Set 1D Link
                               ...  PCC.Interface Apply
                               ...  PCC.Interface Verify PCC
                               ...  PCC.Wait Until Interface Ready

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${SERVER_3_NAME}
                               ...  interface_name=enp3s0
                               ...  assign_ip=[]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=40000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${SERVER_3_NAME}
        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name${SERVER_3_NAME}
                               ...  interface_name=enp3s0
                                    Should Be Equal As Strings      ${status}    OK
        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_3_NAME}
                               ...  interface_name=enp3s0
                               ...  assign_ip=[]
                               ...  cleanUp=yes
                                    Should Be Equal As Strings      ${status}    OK

        ${response}                 PCC.Interface Set 1D Link
                               ...  node_name=${SERVER_3_NAME}
                               ...  interface_name=enp3s0d1
                               ...  assign_ip=[]
                               ...  managedbypcc=True
                               ...  autoneg=off
                               ...  speed=40000
                               ...  adminstatus=UP
                               ...  cleanUp=yes

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
                                    Sleep    10s
        ${response}                 PCC.Interface Apply
                               ...  node_name=${SERVER_3_NAME}
        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200
        ${status}                   PCC.Wait Until Interface Ready
                               ...  node_name${SERVER_3_NAME}
                               ...  interface_name=enp3s0d1
                                    Should Be Equal As Strings      ${status}    OK
        ${status}                   PCC.Interface Verify PCC
                               ...  node_name=${SERVER_3_NAME}
                               ...  interface_name=enp3s0d1
                               ...  assign_ip=[]
                               ...  cleanUp=yes
                                    Should Be Equal As Strings      ${status}    OK


######## commenting cleanup script for 212 nodes ###########

####################################################################################################################################
#Set Interfaces For ${CLUSTERHEAD_1_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${CLUSTERHEAD_1_NAME}(i43)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth6-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth6-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth6-2
#                               ...  assign_ip=[]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_1_NAME}
#                               ...  interface_name=xeth32-2
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${CLUSTERHEAD_2_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${CLUSTERHEAD_2_NAME} (i42)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth6-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth6-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth6-2
#                               ...  assign_ip=[]
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${CLUSTERHEAD_2_NAME}
#                               ...  interface_name=xeth32-2
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${SERVER_1_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${SERVER_1_NAME}*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_1_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_1_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${SERVER_2_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${SERVER_2_NAME} (sv125)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_2_NAME}
#                               ...  interface_name=enp130s0
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp130s0
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_2_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_2_NAME}
#                               ...  interface_name=enp130s0d1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_2_NAME}
#                               ...  interface_name=enp130s0d1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
####################################################################################################################################
#Set Interfaces For ${SERVER_3_NAME}
####################################################################################################################################
#    [Documentation]                 *Set Interfaces For ${SERVER_3_NAME} (sv110)*
#                               ...  keywords:
#                               ...  PCC.Interface Set 1D Link
#                               ...  PCC.Interface Apply
#                               ...  PCC.Interface Verify PCC
#                               ...  PCC.Wait Until Interface Ready
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=ens2
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_3_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_3_NAME}
#                               ...  interface_name=ens2
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=ens2
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK
#
#        ${response}                 PCC.Interface Set 1D Link
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=ens2d1
#                               ...  assign_ip=[]
#                               ...  managedbypcc=True
#                               ...  autoneg=off
#                               ...  speed=10000
#                               ...  adminstatus=UP
#                               ...  cleanUp=yes
#
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#                                    Sleep    10s
#        ${response}                 PCC.Interface Apply
#                               ...  node_name=${SERVER_3_NAME}
#        ${status_code}              Get Response Status Code        ${response}
#                                    Should Be Equal As Strings      ${status_code}  200
#        ${status}                   PCC.Wait Until Interface Ready
#                               ...  node_name${SERVER_3_NAME}
#                               ...  interface_name=ens2d1
#                                    Should Be Equal As Strings      ${status}    OK
#        ${status}                   PCC.Interface Verify PCC
#                               ...  node_name=${SERVER_3_NAME}
#                               ...  interface_name=ens2d1
#                               ...  assign_ip=[]
#                               ...  cleanUp=yes
#                                    Should Be Equal As Strings      ${status}    OK


#Installing net-tools on nodes

#####################################################################################################################################
Install net-tools on nodes
#####################################################################################################################################

    [Documentation]    *Install net-tools on nodes* test


    ${status}    Install net-tools command


                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK


#Installing s2cmd on nodes

#####################################################################################################################################
Install s3cmd utility on nodes
#####################################################################################################################################

    [Documentation]    *Install s3cmd on nodes* test


    ${status}    Install s3cmd command

                 Log To Console    ${status}
                 Should be equal as strings    ${status}    OK

