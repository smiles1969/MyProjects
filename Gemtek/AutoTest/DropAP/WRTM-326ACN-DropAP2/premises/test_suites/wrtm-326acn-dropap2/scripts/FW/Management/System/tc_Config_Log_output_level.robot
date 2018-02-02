*** Settings ***
Resource    base.robot

Force Tags    @FEATURE=System    @AUTHOR=Hans_Sun
*** Variables ***

*** Test Cases ***
tc_Config_Log_output_level
    [Documentation]  tc_Config_Log_output_level
    ...    1. Go to web page Device Management>System and Beneath System Properties, select "Logging " Tab
    ...    2. Select a new Log output Level and Save
    ...    3. Refresh Page and Verify Log output Level Has been changed
    [Tags]   @TCID=WRTM-326ACN-315    @DUT=WRTM-326ACN     @AUTHOR=Hans_Sun
    [Timeout]

    Go to web page Device Management>System and Beneath System Properties, select "Logging " Tab
    Select a new Log output Level and Save
    Refresh Page and Verify Log output Level Has been changed

*** Keywords ***
Go to web page Device Management>System and Beneath System Properties, select "Logging " Tab
    [Documentation]
    [Tags]   @AUTHOR=Hans_Sun
    Login Web GUI
    Wait Until Keyword Succeeds    3x    2s    click links    web    Device Management  System
    cpe click    web    ${Logging_tab}

Select a new Log output Level and Save
    [Documentation]
    [Tags]   @AUTHOR=Hans_Sun
    Check Log Output Level Settings    web    Info
    Check Log Output Level Settings    web    Warning
    Check Log Output Level Settings    web    Error

Refresh Page and Verify Log output Level Has been changed
    [Documentation]
    [Tags]   @AUTHOR=Hans_Sun
    Check Log Output Level Settings    web    Debug

Check Log Output Level Settings
    [Arguments]    ${b}    ${input}
    Select From List By Label    web    ${Select_LogOutput_level}    ${input}
    cpe click    ${b}    ${System_save}
    #wait save compeletdly
    sleep    2
    Wait Until Keyword Succeeds    3x    2s    click links    ${b}    System
    cpe click    ${b}    ${Logging_tab}
    ${result} =    get_selected_list_label    ${b}    ${Select_LogOutput_level}
    Should Be Equal    ${result}    ${input}

*** comment ***
2017-12-11     Hans_Sun
Init the script