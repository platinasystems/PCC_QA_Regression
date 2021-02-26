*** Settings ***
Resource    pcc_resources.robot

*** Variables ***
${pcc_setup}                 pcc_212

*** Test Cases ***
###################################################################################################################################
Login
###################################################################################################################################
	[Tags]    Only
                                    Load Clusterhead 1 Test Data    ${pcc_setup}
                                    Load Clusterhead 2 Test Data    ${pcc_setup}
                                    Load Server 1 Test Data    ${pcc_setup}
                                    Load Server 2 Test Data    ${pcc_setup}
                      			             

        ${status}                   Login To PCC        testdata_key=${pcc_setup}
                                    Should Be Equal     ${status}  OK

###################################################################################################################################
PCC Phone Home - Update Config File
###################################################################################################################################

        [Documentation]    *PCC Phone Home - Update Config File * test
                           ...  keywords:
                           ...  PCC.PhoneHome Update Config File


        ${status}      PCC.PhoneHome Update Config File
                       ...  host_ip=${PCC_HOST_IP}
                       ...  config_file=config_without_ssl.json
                       ...  user=${PCC_LINUX_USER}
                       ...  password=${PCC_LINUX_PASSWORD}

                       Should Be Equal As Strings     ${status}  OK

###################################################################################################################################
PCC Phone Home - Verify Application.yml File
###################################################################################################################################

        [Documentation]    *PCC Phone Home - Verify Application.yml File * test
                           ...  keywords:
                           ...  PCC.PhoneHome Verify Application.yml File


        ${status}      PCC.PhoneHome Verify Application.yml File
                       ...  host_ip=${PCC_HOST_IP}
                       ...  user=${PCC_LINUX_USER}
                       ...  password=${PCC_LINUX_PASSWORD}
                       ...  config_file=config_without_ssl.json

                       Should Be Equal As Strings     ${status}  OK


###################################################################################################################################
PCC Phone Home - Verify Data Push
###################################################################################################################################

        [Documentation]    *PCC Phone Home - Verify Data Push * test
                           ...  keywords:
                           ...  PCC.PhoneHome Verify Data Push


        ${status}      PCC.PhoneHome Verify Data Push
                       ...  host_ip=${PCC_HOST_IP}
                       ...  user=${PCC_LINUX_USER}
                       ...  password=${PCC_LINUX_PASSWORD}

                       Should Be Equal As Strings     ${status}  OK

###################################################################################################################################
PCC Phone Home - Wait Until Phone Home Job Is Finished
###################################################################################################################################

        [Documentation]    *PCC Phone Home - Wait Until Phone Home Job Is Finished * test
                           ...  keywords:
                           ...  PCC.Wait Until Phone Home Job Is Finished

	[Tags]    Only

        ${status}      PCC.Wait Until Phone Home Job Is Finished
                       ...  host_ip=${PCC_HOST_IP}
                       ...  user=${PCC_LINUX_USER}
                       ...  password=${PCC_LINUX_PASSWORD}

                       Should Be Equal As Strings     ${status}  OK

###################################################################################################################################
PCC Phone Home - Verify Success Logs In Container
###################################################################################################################################

        [Documentation]    *PCC Phone Home - Verify Success Logs In Container * test
                           ...  keywords:
                           ...  PCC.PhoneHome Verify Success Logs In Container


        ${status}      PCC.PhoneHome Verify Success Logs In Container
                       ...  host_ip=${PCC_HOST_IP}
                       ...  user=${PCC_LINUX_USER}
                       ...  password=${PCC_LINUX_PASSWORD}

                       Should Be Equal As Strings     ${status}  OK

###################################################################################################################################
PCC Phone Home - Verify Daily Tar File Size
###################################################################################################################################

        [Documentation]    *PCC Phone Home - Verify Daily Tar File Size * test
                           ...  keywords:
                           ...  PCC.PhoneHome Verify Tar File Size


        ${status}      PCC.PhoneHome Verify Tar File Size
                       ...  tar_file_type=daily
                       ...  host_ip=${PCC_HOST_IP}
                       ...  user=${PCC_LINUX_USER}
                       ...  password=${PCC_LINUX_PASSWORD}
                       ...  setup_username=${PCC_SETUP_USERNAME}

                       Should Be Equal As Strings     ${status}  OK

###################################################################################################################################
PCC Phone Home - Verify Manual Tar File Size
###################################################################################################################################

        [Documentation]    *PCC Phone Home - Verify Manual Tar File Size * test
                           ...  keywords:
                           ...  PCC.PhoneHome Verify Tar File Size


        ${status}      PCC.PhoneHome Verify Tar File Size
                       ...  tar_file_type=manual
                       ...  host_ip=${PCC_HOST_IP}
                       ...  user=${PCC_LINUX_USER}
                       ...  password=${PCC_LINUX_PASSWORD}
                       ...  setup_username=${PCC_SETUP_USERNAME}

                       Should Be Equal As Strings     ${status}  OK

###################################################################################################################################
PCC Phone Home - Untar File
###################################################################################################################################

        [Documentation]    *PCC Phone Home - Untar File * test
                           ...  keywords:
                           ...  PCC.PhoneHome Untar File


        ${status}      PCC.PhoneHome Untar File
                       ...  host_ip=${PCC_HOST_IP}
                       ...  user=${PCC_LINUX_USER}
                       ...  password=${PCC_LINUX_PASSWORD}
                       ...  setup_username=${PCC_SETUP_USERNAME}

                       Should Be Equal As Strings     ${status}  OK

###################################################################################################################################
PCC Phone Home - Validation of Logs
###################################################################################################################################

        [Documentation]    *PCC Phone Home - Validation of Logs * test
                           ...  keywords:
                           ...  PCC.PhoneHome Validation of Logs


        ${status}      PCC.PhoneHome Validation of Logs
                       ...  host_ip=${PCC_HOST_IP}
                       ...  user=${PCC_LINUX_USER}
                       ...  password=${PCC_LINUX_PASSWORD}

                       Should Be Equal As Strings     ${status}  OK
