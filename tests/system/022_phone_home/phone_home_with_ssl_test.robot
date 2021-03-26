#*** Settings ***
#Resource    pcc_resources.robot
#
#*** Variables ***
#${pcc_setup}                 pcc_212
#
#*** Test Cases ***
####################################################################################################################################
#Login
####################################################################################################################################
#	[Tags]    Only
#                                    Load Clusterhead 1 Test Data    ${pcc_setup}
#                                    Load Clusterhead 2 Test Data    ${pcc_setup}
#                                    Load Server 1 Test Data    ${pcc_setup}
#                                    Load Server 2 Test Data    ${pcc_setup}
#
#
#        ${status}                   Login To PCC        testdata_key=${pcc_setup}
#                                    Should Be Equal     ${status}  OK
#
####################################################################################################################################
#PCC Phone Home - Install Storage
####################################################################################################################################
#
#        [Documentation]    *PCC Phone Home. - Install storage * test
#                           ...  keywords:
#                           ...  PCC.PhoneHome Install Storage
#
#
#        ${status}      PCC.PhoneHome Install Storage
#                       ...  host_ip=${PCC_HOST_IP}
#                       ...  user=${PCC_LINUX_USER}
#                       ...  password=${PCC_LINUX_PASSWORD}
#
#                       Should Be Equal As Strings     ${status}  OK
#
####################################################################################################################################
#PCC Phone Home - Update Config File
####################################################################################################################################
#
#        [Documentation]    *PCC Phone Home - Update Config File * test
#                           ...  keywords:
#                           ...  PCC.PhoneHome Update Config File
#
#
#        ${status}      PCC.PhoneHome Update Config File
#                       ...  host_ip=${PCC_HOST_IP}
#                       ...  config_file=config_with_ssl.json
#                       ...  user=${PCC_LINUX_USER}
#                       ...  password=${PCC_LINUX_PASSWORD}
#
#                       Should Be Equal As Strings     ${status}  OK
#
####################################################################################################################################
#PCC Phone Home - Verify Application.yml File
####################################################################################################################################
#
#        [Documentation]    *PCC Phone Home - Verify Application.yml File * test
#                           ...  keywords:
#                           ...  PCC.PhoneHome Verify Application.yml File
#
#
#        ${status}      PCC.PhoneHome Verify Application.yml File
#                       ...  host_ip=${PCC_HOST_IP}
#                       ...  user=${PCC_LINUX_USER}
#                       ...  password=${PCC_LINUX_PASSWORD}
#                       ...  config_file=config_with_ssl.json
#
#                       Should Be Equal As Strings     ${status}  OK
#
#
####################################################################################################################################
#PCC Phone Home - Copy Public certificate And Private Key
####################################################################################################################################
#
#        [Documentation]    *PCC Phone Home - Copy Public certificate And Private Key * test
#                           ...  keywords:
#                           ...  PCC.PhoneHome Copy Public certificate And Private Key
#
#
#        ${status}      PCC.PhoneHome Copy Public certificate And Private Key
#                       ...  host_ip=${PCC_HOST_IP}
#                       ...  user=${PCC_LINUX_USER}
#                       ...  password=${PCC_LINUX_PASSWORD}
#
#                       Should Be Equal As Strings     ${status}  OK
#
#
####################################################################################################################################
#PCC Phone Home - Verify Data Push
####################################################################################################################################
#
#        [Documentation]    *PCC Phone Home - Verify Data Push * test
#                           ...  keywords:
#                           ...  PCC.PhoneHome Verify Data Push
#
#
#        ${status}      PCC.PhoneHome Verify Data Push
#                       ...  host_ip=${PCC_HOST_IP}
#                       ...  user=${PCC_LINUX_USER}
#                       ...  password=${PCC_LINUX_PASSWORD}
#
#                       Should Be Equal As Strings     ${status}  OK
#
####################################################################################################################################
#PCC Phone Home - Wait Until Phone Home Job Is Finished
####################################################################################################################################
#
#        [Documentation]    *PCC Phone Home - Wait Until Phone Home Job Is Finished * test
#                           ...  keywords:
#                           ...  PCC.Wait Until Phone Home Job Is Finished
#
#
#        ${status}      PCC.Wait Until Phone Home Job Is Finished
#                       ...  host_ip=${PCC_HOST_IP}
#                       ...  user=${PCC_LINUX_USER}
#                       ...  password=${PCC_LINUX_PASSWORD}
#
#                       ${job_status}    Get From List    ${status}    0
#                       Should Be Equal As Strings     ${job_status}    OK
#                       ${get_file_name}    Get From List    ${status}    1
#                       Set Global Variable    ${get_file_name}
#                       Log To Console    ${get_file_name}
#
####################################################################################################################################
#PCC Phone Home - Verify Success Logs In Container
####################################################################################################################################
#
#        [Documentation]    *PCC Phone Home - Verify Success Logs In Container * test
#                           ...  keywords:
#                           ...  PCC.PhoneHome Verify Success Logs In Container
#
#
#        ${status}      PCC.PhoneHome Verify Success Logs In Container
#                       ...  host_ip=${PCC_HOST_IP}
#                       ...  user=${PCC_LINUX_USER}
#                       ...  get_file_name=${get_file_name}
#                       ...  password=${PCC_LINUX_PASSWORD}
#
#                       Should Be Equal As Strings     ${status}  OK
#
#####################################################################################################################################
##PCC Phone Home - Verify Daily Tar File Size
#####################################################################################################################################
##
##        [Documentation]    *PCC Phone Home - Verify Daily Tar File Size * test
##                           ...  keywords:
##                           ...  PCC.PhoneHome Verify Tar File Size
##
##
##        ${status}      PCC.PhoneHome Verify Tar File Size
##                       ...  tar_file_type=daily
##                       ...  host_ip=${PCC_HOST_IP}
##                       ...  user=${PCC_LINUX_USER}
##                       ...  password=${PCC_LINUX_PASSWORD}
##                       ...  setup_username=${PCC_SETUP_USERNAME}
##
##                       Should Be Equal As Strings     ${status}  OK
#
####################################################################################################################################
#PCC Phone Home - Verify Manual Tar File Size
####################################################################################################################################
#
#        [Documentation]    *PCC Phone Home - Verify Manual Tar File Size * test
#                           ...  keywords:
#                           ...  PCC.PhoneHome Verify Tar File Size
#
#
#        ${status}      PCC.PhoneHome Verify Tar File Size
#                       ...  tar_file_type=manual
#                       ...  host_ip=${PCC_HOST_IP}
#                       ...  user=${PCC_LINUX_USER}
#                       ...  password=${PCC_LINUX_PASSWORD}
#                       ...  get_file_name=${get_file_name}
#                       ...  setup_username=${PCC_SETUP_USERNAME}
#
#                       Should Be Equal As Strings     ${status}  OK
#
####################################################################################################################################
#PCC Phone Home - Import PrivateKey On Platina-cli-ws For SSL
####################################################################################################################################
#
#        [Documentation]    *PCC Phone Home -Import PrivateKey On Platina-cli-ws For SSL * test
#                           ...  keywords:
#                           ...  PCC.PhoneHome Import PrivateKey On Platina-cli-ws For SSL
#	[Tags]    Only
#
#        ${status}      PCC.PhoneHome Import PrivateKey On Platina-cli-ws For SSL
#                       ...  host_ip=${PCC_HOST_IP}
#                       ...  user=${PCC_LINUX_USER}
#                       ...  password=${PCC_LINUX_PASSWORD}
#                       ...  setup_username=${PCC_SETUP_USERNAME}
#
#                       Should Be Equal As Strings     ${status}  OK
#
####################################################################################################################################
#PCC Phone Home - Decrypt Files
####################################################################################################################################
#
#        [Documentation]    *PCC Phone Home - Decrypt Files * test
#                           ...  keywords:
#                           ...  PCC.PhoneHome Decrypt Files
#	[Tags]    Only
#
#        ${status}      PCC.PhoneHome Decrypt Files
#                       ...  host_ip=${PCC_HOST_IP}
#                       ...  user=${PCC_LINUX_USER}
#                       ...  password=${PCC_LINUX_PASSWORD}
#                       ...  setup_username=${PCC_SETUP_USERNAME}
#                       ...  get_file_name=${get_file_name}
#                       #...  get_file_name=2021-03-17-10.17.53.570360-utc
#		       ...  tar_file_type=manual
#
#                       Should Be Equal As Strings     ${status}  OK
#
####################################################################################################################################
#PCC Phone Home - Validation of Logs
####################################################################################################################################
#
#        [Documentation]    *PCC Phone Home - Validation of Logs * test
#                           ...  keywords:
#                           ...  PCC.PhoneHome Validation of Logs
#
#	[Tags]    Only
#        ${status}      PCC.PhoneHome Validation of Logs
#                       ...  host_ip=${PCC_HOST_IP}
#                       ...  user=${PCC_LINUX_USER}
#                       ...  password=${PCC_LINUX_PASSWORD}
#		       ...  encryption_type=with_ssl
#
#                       Should Be Equal As Strings     ${status}  OK
#
####################################################################################################################################
#PCC Phone Home - Encrypted Values Validation (Negative Test Case)
####################################################################################################################################
#
#        [Documentation]    *PCC Phone Home - Encrypted Values Validation* test
#                           ...  keywords:
#                           ...  PCC.PhoneHome Encrypted Values Validation
#
#	[Tags]    Only
#        ${status}      PCC.PhoneHome Encrypted Values Validation
#                       ...  host_ip=${PCC_HOST_IP}
#                       ...  user=${PCC_LINUX_USER}
#                       ...  password=${PCC_LINUX_PASSWORD}
#
#                       Should Be Equal As Strings     ${status}  OK
#
####################################################################################################################################
#PCC Phone Home - Cleanup for Phone Home
####################################################################################################################################
#
#        [Documentation]    *PCC Phone Home - Cleanup Phone Home logs * test
#                           ...  keywords:
#                           ...  PCC.PhoneHome Cleanup
#
#        [Tags]    Only_this
#        ${status}      PCC.PhoneHome Cleanup
#                       ...  host_ip=${PCC_HOST_IP}
#                       ...  user=${PCC_LINUX_USER}
#                       ...  password=${PCC_LINUX_PASSWORD}
#                       ...  setup_username=${PCC_SETUP_USERNAME}
#
#                       Should Be Equal As Strings     ${status}  OK
