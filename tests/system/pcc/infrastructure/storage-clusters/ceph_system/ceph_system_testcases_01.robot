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

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Ceph Cluster Creation with Invalid CIDR (Negative)
###################################################################################################################################
    [Documentation]                      *Creating a cluster - with Invalid CIDR*
                                    ...  keywords:
                                    ...  PCC.Ceph Create Cluster
                                    
        ${response}                      PCC.Ceph Create Cluster
                                    ...  name=${CEPH_CLUSTER_NAME}
                                    ...  nodes=${CEPH_CLUSTER_NODES}
                                    ...  tags=["ROTATIONAL", "SOLID_STATE"]
                                    ...  config={"cluster_network":"300.168.32.300/27","public_network":"300.168.33.300/27"}
                                    ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                                    ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}                   Get Response Status Code  ${response}
                                         Should Not Be Equal As Strings  ${status_code}  200


###################################################################################################################################
Ceph Cluster Creation with Invalid Subnet mask (Negative)
###################################################################################################################################
    [Documentation]                      *Creating a cluster - with Invalid Subnet mask*
                                    ...  keywords:
                                    ...  PCC.Ceph Create Cluster
                                    
        ${response}                      PCC.Ceph Create Cluster
                                    ...  name=${CEPH_CLUSTER_NAME}
                                    ...  nodes=${CEPH_CLUSTER_NODES}
                                    ...  tags=["ALL"]
                                    ...  config={"cluster_network":"192.168.32.0/31","public_network":"192.168.33.0/31"}
                                    ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                                    ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}                   Get Response Status Code  ${response}
                                         Should Not Be Equal As Strings  ${status_code}  200

###################################################################################################################################
Ceph Cluster Creation with 2 nodes (Negative)
###################################################################################################################################
    [Documentation]                      *Creating a cluster - Creation with 2 nodes*
                                    ...  keywords:
                                    ...  PCC.Ceph Create Cluster
    
        ${response}                      PCC.Ceph Create Cluster
                                    ...  name=${CEPH_CLUSTER_NAME}
                                    ...  nodes=["${SERVER_1_NAME}", "${SERVER_2_NAME}"]
                                    ...  tags=["ALL"]
                                    ...  config=${CEPH_CLUSTER_CONFIG}
                                    ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                                    ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}                   Get Response Status Code  ${response}
                                         Should Not Be Equal As Strings  ${status_code}  200


###################################################################################################################################
Ceph Cluster Creation without public CIDR (Negative)
###################################################################################################################################
    [Documentation]                      *Creating a cluster - without public CIDR*
                                    ...  keywords:
                                    ...  PCC.Ceph Create Cluster
                                    
        ${response}                      PCC.Ceph Create Cluster
                                    ...  name=${CEPH_CLUSTER_NAME}
                                    ...  nodes=${CEPH_CLUSTER_NODES}
                                    ...  tags=["ALL"]
                                    ...  config={"cluster_network":"192.168.32.0/27","public_network":""}
                                    ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                                    ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}                   Get Response Status Code  ${response}
                                         Should Not Be Equal As Strings  ${status_code}  200


###################################################################################################################################
Ceph Cluster Creation without cluster CIDR (Negative)
###################################################################################################################################
    [Documentation]                      *Ceph Cluster Creation without cluster CIDR*
                                    ...  keywords:
                                    ...  PCC.Ceph Create Cluster
                                    
        ${response}                      PCC.Ceph Create Cluster
                                    ...  name=${CEPH_CLUSTER_NAME}
                                    ...  nodes=${CEPH_CLUSTER_NODES}
                                    ...  tags=["ALL"]
                                    ...  config={"cluster_network":"","public_network":"192.168.33.0/27"}
                                    ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                                    ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}                   Get Response Status Code  ${response}
                                         Should Not Be Equal As Strings  ${status_code}  200


###################################################################################################################################
Ceph Cluster Creation without name (Negative)
###################################################################################################################################
    [Documentation]                      *Creating a cluster - without name*
                                    ...  keywords:
                                    ...  PCC.Ceph Create Cluster
                                    
        ${response}                      PCC.Ceph Create Cluster
                                    ...  name=""
                                    ...  nodes=${CEPH_CLUSTER_NODES}
                                    ...  tags=["ALL"]
                                    ...  config=${CEPH_CLUSTER_CONFIG}
                                    ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                                    ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}                   Get Response Status Code  ${response}
                                         Should Not Be Equal As Strings  ${status_code}  200


###################################################################################################################################
Ceph Cluster Creation with invalid name (Negative)
###################################################################################################################################
    [Documentation]                      *Creating a cluster - with invalid name*
                                    ...  keywords:
                                    ...  PCC.Ceph Create Cluster
                                    
        ${response}                       PCC.Ceph Create Cluster
                                     ...  name="!@#$%^"
                                     ...  nodes=${CEPH_CLUSTER_NODES}
                                     ...  tags=["ALL"]
                                     ...  config=${CEPH_CLUSTER_CONFIG}
                                     ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                                     ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}                    Get Response Status Code  ${response}
                                          Should Not Be Equal As Strings  ${status_code}  200


###################################################################################################################################
Ceph Cluster Creation with same public and cluster CIDR (Negative)
###################################################################################################################################
    [Documentation]                      *Creating a cluster - with same public and cluster CIDR*
                                    ...  keywords:
                                    ...  PCC.Ceph Create Cluster
                                    
        ${response}                      PCC.Ceph Create Cluster
                                    ...  name=${CEPH_CLUSTER_NAME}
                                    ...  nodes=${CEPH_CLUSTER_NODES}
                                    ...  tags=["ALL"]
                                    ...  config={"cluster_network":"192.168.32.0/27","public_network":"192.168.32.0/27"}
                                    ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                                    ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}                   Get Response Status Code  ${response}
                                         Should Not Be Equal As Strings  ${status_code}  200

###################################################################################################################################
Ceph Cluster Creation without selecting any nodes (Negative)
###################################################################################################################################
    [Documentation]                      *Creating a cluster - without selecting any nodes* 
                                    ...  keywords:
                                    ...  PCC.Ceph Create Cluster
                                    
        ${response}                      PCC.Ceph Create Cluster
                                    ...  name=${CEPH_CLUSTER_NAME}
                                    ...  nodes=[]
                                    ...  tags=["ALL"]
                                    ...  config=${CEPH_CLUSTER_CONFIG}
                                    ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                                    ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}                   Get Response Status Code  ${response}
                                         Should Not Be Equal As Strings  ${status_code}  200


###################################################################################################################################
Ceph Cluster Creation without tags (Negative)
###################################################################################################################################
    [Documentation]                      *Creating a cluster - without tags*
                                    ...  keywords:
                                    ...  PCC.Ceph Create Cluster
                                    
        ${response}                      PCC.Ceph Create Cluster
                                    ...  name=${CEPH_CLUSTER_NAME}
                                    ...  nodes=${CEPH_CLUSTER_NODES}
                                    ...  tags=[]
                                    ...  config=${CEPH_CLUSTER_CONFIG}
                                    ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                                    ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}                   Get Response Status Code  ${response}
                                         Should Not Be Equal As Strings  ${status_code}  200
