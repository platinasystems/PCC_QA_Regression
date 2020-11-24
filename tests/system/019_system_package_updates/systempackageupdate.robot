*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_218

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
      [Tags]    Only  
                                    Load Ipam Data    ${pcc_setup}
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
Check if PCC have a new entry under the applications list to represent the packages (TCP-1576,1577,1578,1580,1581)
###################################################################################################################################

         
        ${status}                   PCC.Validate Applications Present on PCC
                               ...  app_list=["OS Packages Repository","Docker Community Package Repository","Ceph Community Package Repository","FRRouting Community Package Repository","Platina Systems Packages"]
                               
                               Log To Console   ${status} 
                               Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Check if PCC define default node role for the following to include Platina Systems Package Repository (TCP-1582,1583,1584,1585)
###################################################################################################################################                               

        ## Check for Cluster Head node role                    
        ${status}          PCC.Validate Node Role
                           ...    Name=Cluster Head
                           
                           Log To Console   ${status} 
                           Should Be Equal As Strings    ${status}    OK 
                           
        ## Check for Ceph Resource node role                    
        ${status}          PCC.Validate Node Role
                           ...    Name=Ceph Resource
                           
                           Log To Console   ${status} 
                           Should Be Equal As Strings    ${status}    OK 
                           
        ## Check for Kubernetes Resource node role                    
        ${status}          PCC.Validate Node Role
                           ...    Name=Kubernetes Resource
                           
                           Log To Console   ${status} 
                           Should Be Equal As Strings    ${status}    OK 
                           
        ## Check for Network Resource node role                    
        ${status}          PCC.Validate Node Role
                           ...    Name=Network Resource
                           
                           Log To Console   ${status} 
                           Should Be Equal As Strings    ${status}    OK  
                           
                           
        