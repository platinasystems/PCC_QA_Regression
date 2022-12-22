*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load K8s Data    ${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Network Manager Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    Load Ipam Data    ${pcc_setup}
                                    
        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK
                                    
###################################################################################################################################
Create Subnet
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready

        ${response}                 PCC.Ipam Subnet Create
                               ...  name=subnet-pvt
                               ...  subnet=10.0.130.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=subnet-pvt

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create another subnet with different name and same CIDR
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready

        ${response}                 PCC.Ipam Subnet Create
                               ...  name=subnet-pvt-1
                               ...  subnet=10.0.130.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=subnet-pvt-1

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Create another subnet with different name and different CIDR
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready

        ${response}                 PCC.Ipam Subnet Create
                               ...  name=subnet-pvt-2
                               ...  subnet=10.0.131.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=subnet-pvt-2

                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Update subnet name
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready

        ${id}                       PCC.Ipam Subnet Get Id
                               ...  name=subnet-pvt-2

        ${response}                 PCC.Ipam Subnet Update
                               ...  id=${id}
                               ...  name=subnet-pvt-upd
                               ...  subnet=10.0.131.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=subnet-pvt-upd
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Verify Ipam Subnet Updated
                               ...  name=subnet-pvt-upd
                                    Should Be Equal As Strings      ${status}    OK                                    

###################################################################################################################################
Update subnet name to the name of already existing subnet
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready

        ${id}                       PCC.Ipam Subnet Get Id
                               ...  name=subnet-pvt-upd

        ${response}                 PCC.Ipam Subnet Update
                               ...  id=${id}
                               ...  name=subnet-pvt-1
                               ...  subnet=10.0.131.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=subnet-pvt-1
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Verify Ipam Subnet Updated
                               ...  name=subnet-pvt-1
                                    Should Be Equal As Strings      ${status}    OK  


###################################################################################################################################
Update subnet 
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready

        ${id}                       PCC.Ipam Subnet Get Id
                               ...  name=subnet-pvt

        ${response}                 PCC.Ipam Subnet Update
                               ...  id=${id}
                               ...  name=subnet-pvt
                               ...  subnet=10.0.141.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=subnet-pvt
                                    Should Be Equal As Strings      ${status}    OK

        ${status}                   PCC.Verify Ipam Subnet Updated
                               ...  name=subnet-pvt
                               ...  subnet=10.0.141.0/24
                                    Should Be Equal As Strings      ${status}    OK  
 
###################################################################################################################################
Create IPAM ControlCIDR Subnet : TCP-1773 
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready


        ${response}                 PCC.Ipam Subnet Create
                               ...  name=${IPAM_CONTROL_SUBNET_NAME}
                               ...  subnet=${IPAM_CONTROL_SUBNET_IP}
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=${IPAM_CONTROL_SUBNET_NAME}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create IPAM DataCIDR Subnet : TCP-1774
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready


        ${response}                 PCC.Ipam Subnet Create
                               ...  name=${IPAM_DATA_SUBNET_NAME}
                               ...  subnet=${IPAM_DATA_SUBNET_IP}
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=${IPAM_DATA_SUBNET_NAME}

                                    Should Be Equal As Strings      ${status}    OK


###################################################################################################################################
Create IPAM Lab Data Subnet
###################################################################################################################################

        ${response}                 PCC.Ipam Subnet Create
                               ...  name=lab-pvt
                               ...  subnet=172.17.2.0/23
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=lab-pvt

                                    Should Be Equal As Strings      ${status}    OK
###################################################################################################################################
Fetching IPAM subnet ID before backup
###################################################################################################################################                                      
        ${ipam_subnet_id_before_backup}    PCC.Ipam Subnet Get Id
                                           ...  name=${IPAM_DATA_SUBNET_NAME}
                                           Log To Console    ${ipam_subnet_id_before_backup}
                                           Set Global Variable    ${ipam_subnet_id_before_backup}


###################################################################################################################################
Login To PCC Secondary
###################################################################################################################################

                                    Load Ipam Data Secondary   ${pcc_setup}

        ${status}                   Login To PCC Secondary        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Create IPAM ControlCIDR Subnet Secondary
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet Secondary*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready

        ${response}                 PCC.Ipam Subnet Create
                               ...  name=${IPAM_CONTROL_SUBNET_NAME_SECONDARY}
                               ...  subnet=${IPAM_CONTROL_SUBNET_IP_SECONDARY}
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=${IPAM_CONTROL_SUBNET_NAME_SECONDARY}

                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Create IPAM DataCIDR Subnet Secondary
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet Secondary*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready

        ${response}                 PCC.Ipam Subnet Create
                               ...  name=${IPAM_DATA_SUBNET_NAME_SECONDARY}
                               ...  subnet=${IPAM_DATA_SUBNET_IP_SECONDARY}
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=${IPAM_DATA_SUBNET_NAME_SECONDARY}

                                    Should Be Equal As Strings      ${status}    OK

                                           
