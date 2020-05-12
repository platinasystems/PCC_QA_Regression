*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC 
###################################################################################################################################      
        [Documentation]             *Login to PCC* test
        
        ${status}                   Login To PCC    ${pcc_setup}
                                    
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    
        ${invader1_id}              PCC.Get Node Id    Name=${CLUSTERHEAD_1_NAME}
                                    Log To Console    ${invader1_id}
                                    Set Global Variable    ${invader1_id}
                         
###################################################################################################################################
PCC Sites - Verify if user can access sites
###################################################################################################################################
        [Documentation]             *PCC Sites - Verify if user can access Sites* 
                                    ...  keywords:
                                    ...  PCC.Get Sites

        ${response}                 PCC.Get Sites                      
        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                       
###################################################################################################################################
PCC Sites Add and Verification
###################################################################################################################################
        [Documentation]             *PCC Sites Add and Verification*
                                    ...  keywords:
                                    ...  PCC.Add Sites
                                    ...  PCC.Verify Sites Add
        
        ${response}                 PCC.Add Sites
                                    ...  Name=sites
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Verify Sites Add
                                    ...  Name=sites
                                    Should Be Equal As Strings      ${status}    OK
                                               
###################################################################################################################################
PCC Add Site Without Description
###################################################################################################################################
        [Documentation]             *PCC Add Site Without Description*
                                    ...  keywords:
                                    ...  PCC.Add Sites
                                    ...  PCC.Verify Sites Add

        ${response}                 PCC.Add Sites
                                    ...  Name=sites1
                                    ...  Description=

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Verify Sites Add
                                    ...  Name=sites1
                                    Should Be Equal As Strings      ${status}    OK   

###################################################################################################################################
PCC Add Site Without Name (Negative)
###################################################################################################################################
        [Documentation]             *PCC Add Site Without Name*
                                    ...  keywords:
                                    ...  PCC.Add Sites
                                    ...  PCC.Verify Sites Add

        ${response}                 PCC.Add Sites
                                    ...  Name=
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200 

###################################################################################################################################
PCC Add Site With Special Character Only (Negative)
###################################################################################################################################
        [Documentation]             *PCC Add Site With Special Character Only*
                                    ...  keywords:
                                    ...  PCC.Add Sites
                                    ...  PCC.Verify Sites Add

        ${response}                 PCC.Add Sites
                                    ...  Name=!@#$%^&*
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200 
                                    
###################################################################################################################################
PCC Add Site With Numeric Value Only (Negative)
###################################################################################################################################
        [Documentation]             *PCC Add Site With Numeric Value Only*
                                    ...  keywords:
                                    ...  PCC.Add Sites
                                    ...  PCC.Verify Sites Add

        ${response}                 PCC.Add Sites
                                    ...  Name=1234567
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200
                                    

###################################################################################################################################
PCC Add Site With Blank Space Only (Negative)
###################################################################################################################################
        [Documentation]             *PCC Add Site With Blank Space Only* 
                                    ...  keywords:
                                    ...  PCC.Add Sites
                                    ...  PCC.Verify Sites Add

        ${response}                 PCC.Add Sites
                                    ...  Name=          
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200

###################################################################################################################################
PCC Add Site with name contain mixture of special character, numerical value, alphabet
###################################################################################################################################
        [Documentation]             *PCC Add Site with name contain mixture of special character, numerical value, alphabet* 
                                    ...  keywords:
                                    ...  PCC.Add Sites
                                    ...  PCC.Verify Sites Add

        ${response}                 PCC.Add Sites
                                    ...  Name=Test@123^&          
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Verify Sites Add
                                    ...  Name=Test@123^&
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
PCC Modify Site Description
###################################################################################################################################
        [Documentation]             *PCC Modify Site Name*
                                    ...  keywords:
                                    ...  PCC.Modify Sites
                                    ...  PCC.Get Sites Id
                                    ...  PCC.Verify Sites Add
                                    
        ${id}                       PCC.Get Sites Id
                                    ...  Name=sites

        ${response}                 PCC.Modify Sites
                                    ...  Id=${id}
                                    ...  Name=sites        
                                    ...  Description=testing1

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Verify Sites Add
                                    ...  Name=sites
                                    Should Be Equal As Strings      ${status}    OK
                                    
###################################################################################################################################
PCC Modify Site Name
###################################################################################################################################
        [Documentation]             *PCC Modify Site Name*
                                    ...  keywords:
                                    ...  PCC.Modify Sites
                                    ...  PCC.Get Sites Id
                                    ...  PCC.Verify Sites Add
                                    
        ${id}                       PCC.Get Sites Id
                                    ...  Name=sites

        ${response}                 PCC.Modify Sites
                                    ...  Id=${id}
                                    ...  Name=sites-pvt         
                                    ...  Description=testing1

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Verify Sites Add
                                    ...  Name=sites-pvt
                                    Should Be Equal As Strings      ${status}    OK

################################################################################################################################
PCC Sites Add Duplicate (Negative)
###################################################################################################################################
        [Documentation]             *PCC Sites Add Duplicate*
                                    ...  keywords:
                                    ...  PCC.Add Sites
                                    ...  PCC.Verify Sites Add
        
        ${response}                 PCC.Add Sites
                                    ...  Name=sites-dup
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Verify Sites Add
                                    ...  Name=sites-dup
                                    Should Be Equal As Strings      ${status}    OK         

        ${response}                 PCC.Add Sites
                                    ...  Name=sites-dup
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200     

################################################################################################################################
PCC Modify Site Name to blank (Negative)
###################################################################################################################################
        [Documentation]             *PCC Modify Site Name to blank*
                                    ...  keywords:
                                    ...  PCC.Add Sites
                                    ...  PCC.Verify Sites Add
        
        ${response}                 PCC.Add Sites
                                    ...  Name=sites-mod
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Verify Sites Add
                                    ...  Name=sites-mod
                                    Should Be Equal As Strings      ${status}    OK 
                                    
        ${id}                       PCC.Get Sites Id
                                    ...  Name=sites-mod

        ${response}                 PCC.Modify Sites
                                    ...  Id=${id}  
                                    ...  Name=
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200   

################################################################################################################################
PCC Modify Site description to blank 
###################################################################################################################################
        [Documentation]             *PCC Modify Site description to blank*
                                    ...  keywords:
                                    ...  PCC.Add Sites
                                    ...  PCC.Verify Sites Add
        
        ${response}                 PCC.Add Sites
                                    ...  Name=sites-mod1
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Verify Sites Add
                                    ...  Name=sites-mod1
                                    Should Be Equal As Strings      ${status}    OK                                     
                                    
        ${id}                       PCC.Get Sites Id
                                    ...  Name=sites-mod1

        ${response}                 PCC.Modify Sites
                                    ...  Id=${id}  
                                    ...  Name=sites-mod1
                                    ...  Description=

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200    

################################################################################################################################
PCC Modify Site Name to Existing name (Negative)
###################################################################################################################################
        [Documentation]             *PCC Modify Site Name to Existing name*
                                    ...  keywords:
                                    ...  PCC.Add Sites
                                    ...  PCC.Verify Sites Add
        
        ${response}                 PCC.Add Sites
                                    ...  Name=sites-10
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Verify Sites Add
                                    ...  Name=sites-10
                                    Should Be Equal As Strings      ${status}    OK     

        ${response}                 PCC.Add Sites
                                    ...  Name=sites-11
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Verify Sites Add
                                    ...  Name=sites-11
                                    Should Be Equal As Strings      ${status}    OK                                       
                                    
        ${id}                       PCC.Get Sites Id
                                    ...  Name=sites-10

        ${response}                 PCC.Modify Sites
                                    ...  Id=${id}  
                                    ...  Name=sites-11
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Not Be Equal As Strings      ${status_code}  200                                     
                                    
###################################################################################################################################
PCC Sites deletion
###################################################################################################################################
        [Documentation]             *PCC Sites deletion*
                                    ...  keywords:
                                    ...  PCC.Delete Sites

        ${response}                 PCC.Add Sites
                                    ...  Name=sites-del
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Verify Sites Add
                                    ...  Name=sites-del
                                    Should Be Equal As Strings      ${status}    OK     
                                    
        ${response}                 PCC.Delete Sites
                                    ...  Name=sites-del

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200
                                    
        ${status}                   PCC.Verify Sites Delete
                                    ...  Name=sites-del
                                    Should Be Equal As Strings      ${status}    OK  
                     
###################################################################################################################################
PCC Add 20 Sites
###################################################################################################################################
        [Documentation]             *PCC Add 50 Sites*
                                    ...  keywords:
                                    ...  PCC.Add Multiple Sites and Verify
              
        ${status}                   PCC.Add Multiple Sites and Verify
                                    ...  count=20
                                    ...  Name=multi
                                    ...  Description=testing

                                    Should Be Equal As Strings      ${status}    OK     
                     
###################################################################################################################################
PCC Delete All Sites
###################################################################################################################################
        [Documentation]             *PCC Delete All Sites*
                                    ...  keywords:
                                    ...  PCC.Add Sites
                           
        ${status}                   PCC.Delete All Sites
                                    Should Be Equal As Strings      ${status}    OK   
                                    
                     
###################################################################################################################################
Pcc Sites Assignment To Node
###################################################################################################################################
        [Documentation]             *Pcc Sites Assignment To Node* 
                                    ...  keywords:
                                    ...  PCC.Get Tenant Id
                                    ...  PCC.Add Sites
                                    ...  PCC.Validate Sites

        ${response}                 PCC.Add Sites
                                    ...  Name=node-site
                                    ...  Description=testing

        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Verify Sites Add
                                    ...  Name=node-site
                                    Should Be Equal As Strings      ${status}    OK     
                                    
        ${site_id}                  PCC.Get Sites Id                                  
                                    ...  Name=node-site
                     
        ${response}                 PCC.Assign Sites to Node                                  
                                    ...  Id=${site_id}
                                    ...  node_id=${invader1_id}
                     
        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Verify Sites Assigned to Node
                                    ...  node_id=${invader1_id}
                                    Should Be Equal As Strings      ${status}    OK     
                     
###################################################################################################################################
Delete Sites in the PCC when site is associated with the Node
###################################################################################################################################
        [Documentation]             *Delete Sites in the PCC when site is associated with the Node* 
                                    ...  keywords:
                                    ...  PCC.Delete Sites
                                    ...  PCC.Get Sites Id
                                    ...  PCC.Validate Sites 

                           
        ${response}                 PCC.Assign Sites to Node                                  
                                    ...  Id=0
                                    ...  node_id=${invader1_id}
                     
        ${status_code}              Get Response Status Code        ${response}     
                                    Should Be Equal As Strings      ${status_code}  200

        ${status}                   PCC.Verify Sites Assigned to Node
                                    ...  node_id=${invader1_id}
                                    Should Be Equal As Strings      ${status}    OK

###################################################################################################################################
Pcc Sites cleanup 
###################################################################################################################################
        [Documentation]             *Pcc Sites cleanup*
                                    ...  keywords:
                                    ...  PCC.Add Sites
                           
        ${status}                   PCC.Delete All Sites
                                    Should Be Equal As Strings      ${status}    OK
