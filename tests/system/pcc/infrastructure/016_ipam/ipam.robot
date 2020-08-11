*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_242

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################

                                    Load Network Manager Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    
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
Create IPAM Subnet For Network Manager
###################################################################################################################################
    [Documentation]                 *Create IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Create
                               ...  PCC.Wait Until Ipam Subnet Ready


        ${response}                 PCC.Ipam Subnet Create
                               ...  name=control-pvt
                               ...  subnet=10.0.130.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=control-pvt
                                    Should Be Equal As Strings      ${status}    OK 
                                    
        ${response}                 PCC.Ipam Subnet Create
                               ...  name=data-pvt
                               ...  subnet=10.0.131.0/24
                               ...  pubAccess=False
                               ...  routed=False

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Ready
                               ...  name=data-pvt
                                    Should Be Equal As Strings      ${status}    OK 

###################################################################################################################################
Network Manager Creation
###################################################################################################################################
    [Documentation]                 *Network Manager Creation*
                               ...  keywords:
                               ...  PCC.Network Manager Create


        ${response}                 PCC.Network Manager Create
                               ...  name=${NETWORK_MANAGER_NAME}
                               ...  nodes=${NETWORK_MANAGER_NODES}
                               ...  controlCIDR=${NETWORK_MANAGER_CNTLCIDR}
                               ...  dataCIDR=${NETWORK_MANAGER_DATACIDR}
                               ...  igwPolicy=${NETWORK_MANAGER_IGWPOLICY}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Wait Until Network Manager Ready
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
Delete Subnets Which Are Mapped To Nework Manager (Negative)
###################################################################################################################################
    [Documentation]                 *Delete IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Delete
                               ...  PCC.Wait Until Ipam Subnet Deleted


        ${response}                 PCC.Ipam Subnet Delete
                               ...  name=data-pvt

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
Delete Subnet
###################################################################################################################################
    [Documentation]                 *Delete IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Delete
                               ...  PCC.Wait Until Ipam Subnet Deleted


        ${response}                 PCC.Ipam Subnet Delete
                               ...  name=subnet-pvt

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Ipam Subnet Deleted
                               ...  name=subnet-pvt

                                    Should Be Equal As Strings      ${status}    OK
 
###################################################################################################################################
Network Manager Delete
###################################################################################################################################
    [Documentation]                 *Network Manager Verification PCC*
                               ...  keywords:
                               ...  PCC.Network Manager Delete

        ${response}                 PCC.Network Manager Delete
                               ...  name=${NETWORK_MANAGER_NAME}

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Wait Until Network Manager Deleted
                               ...  name=${NETWORK_MANAGER_NAME}
                                    Should Be Equal As Strings      ${status}    OK
 
###################################################################################################################################
Delete Multiple Subnet
###################################################################################################################################
    [Documentation]                 *Delete IPAM Subnet*
                               ...  keywords:
                               ...  PCC.Ipam Subnet Delete All

        ${status}                   PCC.Ipam Subnet Delete All
                               ...  name=subnet-pvt
                               
                                    Should Be Equal As Strings      ${status}    OK
