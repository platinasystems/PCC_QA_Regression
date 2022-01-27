*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_218

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
      [Tags]    Today
                                    Load Ipam Data    ${pcc_setup}
                                    Load Ceph Rbd Data    ${pcc_setup}
                                    Load Ceph Pool Data    ${pcc_setup}
                                    Load Ceph Cluster Data    ${pcc_setup}
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                                    Load Network Manager Data    ${pcc_setup}
                                    Load Tenant Data    ${pcc_setup}
                                    Load Certificate Data    ${pcc_setup}

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
Check if PCC have a new entry under the applications list to represent Remote Syslog Client(TCP-1615)
###################################################################################################################################

        ${status}                   PCC.Validate Applications Present on PCC
                               ...  app_list=["RSYSLOG client"]

                               Log To Console   ${status}
                               Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Check if user can create a new node role using application Remote Syslog Client(TCP-1616)
###################################################################################################################################

        [Documentation]    *Check if user can create a new node role using application Remote Syslog Client* test
                           ...  keywords:
                           ...  PCC.Add Node Role
                           ...  PCC.Validate Node Role


        ${owner}       PCC.Get Tenant Id       Name=${ROOT_TENANT}

        #### Creating RSyslog node role ####

        ${template_id}    PCC.Get Template Id    Name=RSYSLOG
                          Log To Console    ${template_id}

        ${response}    PCC.Add Node Role
                       ...    Name=Rsyslog-NR
                       ...    Description=Rsyslog-NR-DESC
                       ...    templateIDs=[${template_id}]
                       ...    owners=[${owner}]

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    status
                       ${message}    Get From Dictionary    ${result}    message
                       Log to Console    ${message}
                       Should Be Equal As Strings    ${status}    200

                       Sleep    2s

        ${status}    PCC.Validate Node Role
                     ...    Name=Rsyslog-NR

                     Log To Console    ${status}
                     Should Be Equal As Strings    ${status}    OK    Node role doesnot exists

###################################################################################################################################
Check if Remote Syslog Package already exists, if exists delete the package
###################################################################################################################################

        [Documentation]    *Check if Remote Syslog Package already exists, if exists delete the package* test
                           ...  keywords:
                           ...  CLI.Check package installed
                                                   ...  CLI.Remove a package from machine
	[Tags]    Today
                ${status}               CLI.Check package installed
                                        ...    package_name=rsyslog
                                        ...    host_ip=${SERVER_1_HOST_IP}
                                        ...    linux_user=${PCC_LINUX_USER}
                                        ...    linux_password=${PCC_LINUX_PASSWORD}

                                        Pass Execution If    "${status}" == "rsyslog Package not installed"    rsyslog Package not installed

                ${status}               CLI.Remove a package from machine
                                                ...    package_name=rsyslog
                                                ...    host_ip=${SERVER_1_HOST_IP}
                                                ...    linux_user=${PCC_LINUX_USER}
                                                ...    linux_password=${PCC_LINUX_PASSWORD}
						
                                                Should Be Equal As Strings    ${status}    rsyslog Package removed

###################################################################################################################################
Check that the rsyslog and rsyslog-gnutls package is installed and the services are configured to start at boot time when node role with application Remote Syslog Client is installed on a node (TCP-1617)
###################################################################################################################################

        [Documentation]    *Check that the rsyslog and rsyslog-gnutls package is installed.*
                           ...  keywords:
                           ...  CLI.Check package installed

                ${response}            PCC.Add and Verify Roles On Nodes
                               ...  nodes=["${SERVER_1_NAME}"]
                               ...  roles=["Rsyslog-NR"]

                               Should Be Equal As Strings      ${response}  OK

        ${node_wait_status}    PCC.Wait Until Node Ready
                               ...  Name=${SERVER_1_NAME}

                               Log To Console    ${node_wait_status}
                               Should Be Equal As Strings    ${node_wait_status}    OK
			       Sleep    50s
	
                ${status}               CLI.Check package installed
                                                ...    package_name=rsyslog
                                                ...    host_ip=${SERVER_1_HOST_IP}
                                                ...    linux_user=${PCC_LINUX_USER}
                                                ...    linux_password=${PCC_LINUX_PASSWORD}

                                                Log To Console    ${status}
                                                Should Be Equal As Strings    ${status}    rsyslog Package installed

                ${status}               CLI.Check package installed
                                                ...    package_name=rsyslog-gnutls
                                                ...    host_ip=${SERVER_1_HOST_IP}
                                                ...    linux_user=${PCC_LINUX_USER}
                                                ...    linux_password=${PCC_LINUX_PASSWORD}

                                                Log To Console    ${status}
                                                Should Be Equal As Strings    ${status}    rsyslog-gnutls Package installed



###################################################################################################################################
Check if user is able to define one or more Remote Syslog Client policies and associate them with various parts of the scoping tree
###################################################################################################################################

        [Documentation]    *Check if user is able to define one or more Remote Syslog Client policies test*
                           ...  keywords:

        [Tags]    Only
                
		####  Create Rsyslog configuration ####

		${status}    CLI.Rsyslog Server Configuration
                	     ...  rsys_server=${SERVER_1_NAME}
                 	     ...  rsys_tls=yes
                	     Should be equal as strings    ${status}    OK
		
		#### Restart RSYSLog client service ####

                ${status}     CLI.Restart Rsyslog service
                              ...  host_ips=['${SERVER_1_HOST_IP}']

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

		####  Creating certificate with private keys for rsyslog ####
                ${response}    PCC.Add Certificate
                       ...  Alias=Cert_for_rsyslog
                       ...  Description=Cert_for_rsyslog
                       ...  Certificate_upload=domain.crt
		               ...  Private_key=domain.key

                       Log To Console    ${response}
                       ${result}    Get Result    ${response}
                       ${status}    Get From Dictionary    ${result}    statusCodeValue
                       Should Be Equal As Strings    ${status}    200

                ${certificate_id}    PCC.Get Certificate Id
                                                     ...    Alias=Cert_for_rsyslog

                                                     Log To Console    ${certificate_id}
                                                     Set Global Variable    ${certificate_id}

                ####  Fetching Default scopeIds ####
                ${default_region_Id}    PCC.Get Scope Id
                                ...  scope_name=Default region
                                Log To Console    ${default_region_Id}
                                Set Global Variable    ${default_region_Id}

        ${default_zone_Id}    PCC.Get Scope Id
                              ...  scope_name=Default zone
                              ...  parentID=${default_region_Id}

                              Log To Console    ${default_zone_Id}
                              Set Global Variable    ${default_zone_Id}

        ${default_site_Id}    PCC.Get Scope Id
                              ...  scope_name=Default site
                              ...  parentID=${default_zone_Id}
                              Log To Console    ${default_site_Id}
                              Set Global Variable    ${default_site_Id}

        ${default_rack_Id}    PCC.Get Scope Id
                              ...  scope_name=Default rack
                              ...  parentID=${default_site_Id}
                              Log To Console    ${default_rack_Id}
                              Set Global Variable    ${default_rack_Id}

            #### Creating rsyslog Policy and assigning it to location####
                ${app_id}    PCC.Get App Id from Policies
                                        ...  Name=rsyslogd
                                        Log To Console    ${app_id}

                ${response}    PCC.Create Policy
                               ...  appId=${app_id}
                               ...  description=rsyslog-policy
                               ...  scopeIds=[${default_rack_Id}]
                               ...  inputs=[{"name": "rsyslog_remote_address","value":"${SERVER_1_HOST_IP}"},{"name":"rsyslog_enable_tls","value":"true"},{"name":"rsyslog_tcp_port","value":"6514"},{"name":"rsyslog_ca_certificate","value":"${certificate_id}"}]

                               Log To Console    ${response}
                               ${result}    Get Result    ${response}
                               ${status}    Get From Dictionary    ${result}    status
                               ${message}    Get From Dictionary    ${result}    message
                               Log to Console    ${message}
                               Should Be Equal As Strings    ${status}    200

	    #### Wait until all nodes are ready ####

		${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
			      Should Be Equal As Strings    ${status}    OK

	    #### Restart RSYSLog client ####
		
		${status}     CLI.Restart Rsyslog service
			      ...  host_ips=['${SERVER_1_HOST_IP}']
			      			
                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

	    #### Validate RSYSlog from backend ####
		
		${status}     CLI.Validate Rsyslog from backend
                        ...  node_names=['${SERVER_1_NAME}']
			            ...  host_ip=${SERVER_1_HOST_IP}	

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

	    #### Unassign loactions from policies ####

		${status}    PCC.Unassign Locations Assigned from All Policies

                           Log To Console    ${status}
                           Should Be Equal As Strings    ${status}    OK
	   
 	    #### Wait until all nodes are ready ####

                ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

	    #### Cleanup logs created by Rsyslog ####
	
		${status}     CLI.Cleanup logs created by Rsyslog
                              ...  host_ips=['${SERVER_1_HOST_IP}']

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Check if user is able to define one or more Remote Syslog Client policies(without TLS) and associate them with various parts of the scoping tree
###################################################################################################################################

        [Documentation]    *Check if user is able to define one or more Remote Syslog Client policies test*
                           ...  keywords:

		####  Create Rsyslog configuration ####

                ${status}    CLI.Rsyslog Server Configuration
                             ...  rsys_server=${CLUSTERHEAD_1_NAME}
                             ...  rsys_tls=no
                             Should be equal as strings    ${status}    OK

                #### Restart RSYSLog client service ####

                ${status}     CLI.Restart Rsyslog service
                              ...  host_ips=['${CLUSTERHEAD_1_HOST_IP}']

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK		


		####  Fetching Default scopeIds ####
                ${default_region_Id}    PCC.Get Scope Id
                	                ...  scope_name=Default region
                        	        Log To Console    ${default_region_Id}
                                	Set Global Variable    ${default_region_Id}

        	${default_zone_Id}    PCC.Get Scope Id
                  	              ...  scope_name=Default zone
        	                      ...  parentID=${default_region_Id}
	
                          	      Log To Console    ${default_zone_Id}
                              	      Set Global Variable    ${default_zone_Id}

        	${default_site_Id}    PCC.Get Scope Id
                	              ...  scope_name=Default site
                        	      ...  parentID=${default_zone_Id}
                              	      Log To Console    ${default_site_Id}
                              	      Set Global Variable    ${default_site_Id}

	    #### Creating rsyslog Policy and assigning it to location####
                ${app_id}    PCC.Get App Id from Policies
                                        ...  Name=rsyslogd
                                        Log To Console    ${app_id}

                ${response}    PCC.Create Policy
                               ...  appId=${app_id}
                               ...  description=rsyslog-policy-without-tls
                               ...  scopeIds=[${default_site_Id}]
                               ...  inputs=[{"name": "rsyslog_remote_address","value":"${CLUSTERHEAD_1_HOST_IP}"},{"name":"rsyslog_enable_tls","value":"false"},{"name":"rsyslog_tcp_port","value":"514"}]

                               Log To Console    ${response}
                               ${result}    Get Result    ${response}
                               ${status}    Get From Dictionary    ${result}    status
                               ${message}    Get From Dictionary    ${result}    message
                               Log to Console    ${message}
                               Should Be Equal As Strings    ${status}    200

	    #### Wait until all nodes are ready ####

                ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

            #### Restart RSYSLog client ####

                ${status}     CLI.Restart Rsyslog service
                              ...  host_ips=['${CLUSTERHEAD_1_HOST_IP}','${SERVER_1_HOST_IP}']

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

            #### Validate RSYSlog from backend ####

                ${status}     CLI.Validate Rsyslog from backend
                              ...  node_names=['${CLUSTERHEAD_1_NAME}']
                              ...  host_ip=${CLUSTERHEAD_1_HOST_IP}

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

            #### Unassign loactions from policies ####

                ${status}    PCC.Unassign Locations Assigned from All Policies

                           Log To Console    ${status}
                           Should Be Equal As Strings    ${status}    OK

            #### Wait until all nodes are ready ####

                ${status}     PCC.Wait Until All Nodes Are Ready

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

	    #### Cleanup logs created by Rsyslog ####

                ${status}     CLI.Cleanup logs created by Rsyslog
                              ...  host_ips=['${CLUSTERHEAD_1_HOST_IP}']

                              Log To Console    ${status}
                              Should Be Equal As Strings    ${status}    OK

###################################################################################################################################
Delete Policies
###################################################################################################################################

        [Documentation]    *Delete Policies*
                           ...  keywords:
	
	${status}     PCC.Delete All Policies

                      Log To Console    ${status}
                      Should Be Equal As Strings    ${status}    OK




