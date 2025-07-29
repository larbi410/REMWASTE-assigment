*** Settings ***
Documentation    UI Tests for Login functionality
Library          SeleniumLibrary
Resource         ../resources/common.robot
Resource         ../resources/ui_keywords.robot
Suite Setup      Open Browser To Login Page
Suite Teardown   Close Browser

*** Test Cases ***
Login With Valid Credentials
    [Documentation]    Test successful login with valid credentials
    [Tags]    positive    login    ui
    Input Username    user
    Input Password    password
    Click Login Button
    Wait Until Page Contains Element    xpath://h1[text()='Task Manager']
    Page Should Contain    Task Manager
    Page Should Contain    Logout
    Location Should Be    ${BASE_URL}/

Login With Invalid Username
    [Documentation]    Test login failure with invalid username
    [Tags]    negative    login    ui
    Go To Login Page
    Input Username    invalid_user
    Input Password    password
    Click Login Button
    Wait Until Page Contains    Invalid credentials
    Page Should Contain    Invalid credentials
    Location Should Be    ${BASE_URL}/login

Login With Invalid Password
    [Documentation]    Test login failure with invalid password
    [Tags]    negative    login    ui
    Go To Login Page
    Input Username    user
    Input Password    invalid_password
    Click Login Button
    Wait Until Page Contains    Invalid credentials
    Page Should Contain    Invalid credentials
    Location Should Be    ${BASE_URL}/login

Login With Empty Credentials
    [Documentation]    Test login failure with empty credentials
    [Tags]    negative    login    ui
    Go To Login Page
    Input Username    ${EMPTY}
    Input Password    ${EMPTY}
    Click Login Button
    # HTML5 validation should prevent form submission
    Location Should Be    ${BASE_URL}/login

Login With Empty Username
    [Documentation]    Test login failure with empty username
    [Tags]    negative    login    ui
    Go To Login Page
    Input Username    ${EMPTY}
    Input Password    password
    Click Login Button
    Location Should Be    ${BASE_URL}/login

Login With Empty Password
    [Documentation]    Test login failure with empty password
    [Tags]    negative    login    ui
    Go To Login Page
    Input Username    user
    Input Password    ${EMPTY}
    Click Login Button
    Location Should Be    ${BASE_URL}/login
