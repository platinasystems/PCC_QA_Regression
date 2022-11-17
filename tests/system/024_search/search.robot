*** Settings ***

Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}    pcc_212

*** Test Cases ***
###################################################################################################################################
Login to PCC
###################################################################################################################################


        [Documentation]    *Login to PCC* test

        ${status}        Login To PCC    ${pcc_setup}


###################################################################################################################################
Get Search Data
###################################################################################################################################

        [Documentation]    *Get Search Data*


        ${response}                        PCC.Get Search Data

        ${status_code}                     Get Response Status Code        ${response}
                                           Should Be Equal As Strings      ${status_code}  200


###################################################################################################################################
Search App Catalog
###################################################################################################################################

        [Documentation]    *Search App Catalog*


        ${response}                        PCC.Find In Search Data
                                      ...  key=Apps
                                      ...  value=Trusted CA certificates

                                           Should Be Equal As Strings      ${response}   OK

        ${response}                        PCC.Find In Search Data
                                      ...  key=Apps
                                      ...  value=Custom Load Balancer

                                           Should Be Equal As Strings      ${response}   OK


###################################################################################################################################
Search Interfaces
###################################################################################################################################

        [Documentation]    *Search Interfaces*


        ${response}                        PCC.Find In Search Data
                                      ...  key=Interfaces
                                      ...  value=enp1s0f0

                                           Should Be Equal As Strings      ${response}   OK

        ${response}                        PCC.Find In Search Data
                                      ...  key=Interfaces
                                      ...  value=enp1s0

                                           Should Be Equal As Strings      ${response}   OK

                ${response}                PCC.Find In Search Data
                                      ...  key=Interfaces
                                      ...  value=xeth1-1

                                           Should Be Equal As Strings      ${response}   OK

###################################################################################################################################
Search Nodes
###################################################################################################################################

        [Documentation]    *Search Nodes*


        ${response}                        PCC.Find In Search Data
                                      ...  key=Nodes
                                      ...  value=cluster-head-69

                                           Should Be Equal As Strings      ${response}   OK

        ${response}                        PCC.Find In Search Data
                                      ...  key=Nodes
                                      ...  value=cluster-head-68

                                           Should Be Equal As Strings      ${response}   OK

        ${response}                        PCC.Find In Search Data
                                      ...  key=Nodes
                                      ...  value=consul-01

                                           Should Be Equal As Strings      ${response}   OK

        ${response}                        PCC.Find In Search Data
                                      ...  key=Nodes
                                      ...  value=consul-02

                                           Should Be Equal As Strings      ${response}   OK


        ${response}                        PCC.Find In Search Data
                                      ...  key=Nodes
                                      ...  value=servernode-130

                                           Should Be Equal As Strings      ${response}   OK


###################################################################################################################################
Search Network Cluster
###################################################################################################################################

        [Documentation]    *Search Network Cluster*


        ${response}                        PCC.Find In Search Data
                                      ...  key=NetworkClusters
                                      ...  value=network-pvt

                                           Should Be Equal As Strings      ${response}   OK

###################################################################################################################################
Search Policies
###################################################################################################################################

        [Documentation]    *Search Policies*


        ${response}                        PCC.Find In Search Data
                                      ...  key=Policies
                                      ...  value=trust-ca-policy

                                           Should Be Equal As Strings      ${response}   OK

###################################################################################################################################
Search Storage
###################################################################################################################################

        [Documentation]    *Search Storage*


        ${response}                        PCC.Find In Search Data
                                      ...  key=Storage
                                      ...  value=sdb

                                           Should Be Equal As Strings      ${response}   OK

        ${response}                        PCC.Find In Search Data
                                      ...  key=Storage
                                      ...  value=sdc

                                           Should Be Equal As Strings      ${response}   OK