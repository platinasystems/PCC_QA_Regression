*** Settings ***
Library    Process
Library    zephyr-intergration.py

*** Test Cases ***
Marking Test Case Result in Zephyr
        ${result}    PCC.Zephyr Integration
        Log To Console    ${result}
        Should Be Equal As Strings    ${result}    OK
