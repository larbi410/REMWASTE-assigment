*** Settings ***
Documentation    UI-specific keywords for Selenium tests
Library          SeleniumLibrary
Resource         common.robot

*** Keywords ***
Open Browser To Login Page
    [Documentation]    Open browser and navigate to login page
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Set Selenium Speed    ${SELENIUM_SPEED}
    Set Selenium Timeout    ${SELENIUM_TIMEOUT}
    Maximize Browser Window

Go To Login Page
    [Documentation]    Navigate to login page
    Go To    ${BASE_URL}/login
    Wait Until Page Contains Element    id:username

Go To Task Manager Page
    [Documentation]    Navigate to task manager page (requires login)
    Go To    ${BASE_URL}/
    ${current_url}=    Get Location
    Run Keyword If    '${current_url}' == '${BASE_URL}/login'    Login With Valid Credentials And Navigate

Login With Valid Credentials And Navigate
    [Documentation]    Login with valid credentials and navigate to main page
    Input Username    user
    Input Password    password
    Click Login Button
    Wait Until Page Contains Element    xpath://h1[text()='Task Manager']

Input Username
    [Documentation]    Input username in login form
    [Arguments]    ${username}
    Wait Until Element Is Visible    id:username
    Clear Element Text    id:username
    Input Text    id:username    ${username}

Input Password
    [Documentation]    Input password in login form
    [Arguments]    ${password}
    Wait Until Element Is Visible    id:password
    Clear Element Text    id:password
    Input Text    id:password    ${password}

Click Login Button
    [Documentation]    Click the login button
    Wait Until Element Is Enabled    xpath://button[text()='Login']
    Click Button    xpath://button[text()='Login']

Click Logout Button
    [Documentation]    Click the logout button
    Wait Until Element Is Enabled    xpath://button[text()='Logout']
    Click Button    xpath://button[text()='Logout']

Create Task
    [Documentation]    Create a new task
    [Arguments]    ${task_text}
    Wait Until Element Is Visible    xpath://input[@placeholder='Add a new task']
    Clear Element Text    xpath://input[@placeholder='Add a new task']
    Input Text    xpath://input[@placeholder='Add a new task']    ${task_text}
    Click Button    xpath://button[text()='Add Task']

Edit Task
    [Documentation]    Edit an existing task
    [Arguments]    ${original_text}    ${new_text}
    Click Edit Task Button    ${original_text}
    Wait Until Element Is Visible    xpath://input[@value='${original_text}']
    Clear Element Text    xpath://input[@value='${original_text}']
    Input Text    xpath://input[@value='${original_text}']    ${new_text}
    Click Button    xpath://button[text()='Save']

Click Edit Task Button
    [Documentation]    Click edit button for a specific task
    [Arguments]    ${task_text}
    Wait Until Element Is Visible    xpath://label[contains(text(),'${task_text}')]/../..//button[@aria-label='Edit task']
    Click Button    xpath://label[contains(text(),'${task_text}')]/../..//button[@aria-label='Edit task']

Click Cancel Edit Button
    [Documentation]    Click cancel button during task edit
    Wait Until Element Is Enabled    xpath://button[text()='Cancel']
    Click Button    xpath://button[text()='Cancel']

Toggle Task Completion
    [Documentation]    Toggle task completion status
    [Arguments]    ${task_text}
    ${checkbox_xpath}=    Set Variable    xpath://label[contains(text(),'${task_text}')]/../input[@type='checkbox']
    Wait Until Element Is Visible    ${checkbox_xpath}
    Click Element    ${checkbox_xpath}

Delete Task
    [Documentation]    Delete a specific task
    [Arguments]    ${task_text}
    Wait Until Element Is Visible    xpath://label[contains(text(),'${task_text}')]/../..//button[@aria-label='Delete task']
    Click Button    xpath://label[contains(text(),'${task_text}')]/../..//button[@aria-label='Delete task']

Get Task Count
    [Documentation]    Get the current number of tasks
    ${elements}=    Get WebElements    xpath://label[contains(@class,'text-lg')]
    ${count}=    Get Length    ${elements}
    RETURN    ${count}

Setup Task Management Tests
    [Documentation]    Setup for task management tests
    Open Browser To Login Page
    Login With Valid Credentials And Navigate
