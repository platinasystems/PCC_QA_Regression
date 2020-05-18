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
                                    Load Ceph Fs Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}                                    

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Ceph Cluster with one node (Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster with one node*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=[${SERVER_1_NAME}]
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  config=${CEPH_CLUSTER_CONFIG}
                               ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                               ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Cluster with two node (Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster with two node*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=["${SERVER_2_NAME}", "${CLUSTERHEAD_1_NAME}"]
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  config=${CEPH_CLUSTER_CONFIG}
                               ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                               ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Cluster with alpbhabet/special-chars in CIDRs (192.168.xx.0/xx) (Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster with alpbhabet/special-chars in CIDRs (192.168.xx.0/xx)*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  config={"cluster_network":"192.168.xx.0/xx","public_network":"192.168.75.0/27"}
                               ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                               ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Ceph Cluster with Invalid IP subnet range in CIDRs (192.168.75.0/35)(Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster with Invalid IP subnet range in CIDRs*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  config={"cluster_network":"192.168.76.0/27","public_network":"192.168.75.0/27"}
                               ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                               ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Cluster with Invalid IP address range in CIDRs (555.5555.555.555/29)(Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster with Invalid IP address range in CIDRs*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  config={"cluster_network":"555.5555.555.555/29","public_network":"192.168.75.0/27"}
                               ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                               ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Cluster provide different network than that of provisioned on nodes(Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster provide different network than that of provisioned on nodes*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  config={"cluster_network":"192.168.32.0/27","public_network":"192.168.75.0/27"}
                               ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                               ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    
###################################################################################################################################
Ceph Cluster with smaller subnet covered with larger subnet(Negative)
###################################################################################################################################
    [Documentation]                 *Ceph Cluster with smaller subnet covered with larger subnet*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  config={"cluster_network":"192.168.32.0/27","public_network":"192.168.33.0/31"}
                               ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                               ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Ceph Cluster Create 
###################################################################################################################################
    [Documentation]                 *Creating Ceph Cluster*
                               ...  keywords:
                               ...  PCC.Ceph Create Cluster
                               ...  PCC.Ceph Wait Until Cluster Ready

        ${response}                 PCC.Ceph Create Cluster
                               ...  name=${CEPH_CLUSTER_NAME}
                               ...  nodes=${CEPH_CLUSTER_NODES}
                               ...  tags=${CEPH_CLUSTER_TAGS}
                               ...  config=${CEPH_CLUSTER_CONFIG}
                               ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                               ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

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
                               ...  config=${CEPH_CLUSTER_CONFIG}
                               ...  controlCIDR=${CEPH_CLUSTER_CNTLCIDR}
                               ...  igwPolicy=${CEPH_CLUSTER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200


