*** Settings ***
Documentation    UI Tests for Task Management functionality
Library          SeleniumLibrary
Resource         ../resources/common.robot
Resource         ../resources/ui_keywords.robot
Suite Setup      Setup Task Management Tests
Suite Teardown   Close Browser
Test Setup       Go To Task Manager Page

*** Test Cases ***
Create New Task
    [Documentation]    Test creating a new task
    [Tags]    positive    create    ui
    ${task_text}=    Set Variable    Test Task Created by Robot Framework
    Create Task    ${task_text}
    Wait Until Page Contains    ${task_text}
    Page Should Contain    ${task_text}
    Element Should Be Visible    xpath://label[contains(text(),'${task_text}')]

Create Task With Empty Text
    [Documentation]    Test creating a task with empty text should not work
    [Tags]    negative    create    ui
    Create Task    ${EMPTY}
    # Task should not be created, verify by checking task count doesn't increase
    ${initial_count}=    Get Task Count
    Create Task    ${EMPTY}
    ${final_count}=    Get Task Count
    Should Be Equal    ${initial_count}    ${final_count}

Edit Existing Task
    [Documentation]    Test editing an existing task
    [Tags]    positive    edit    ui
    ${original_task}=    Set Variable    Task to be edited
    ${edited_task}=    Set Variable    Task has been edited by Robot Framework
    
    # Create a task first
    Create Task    ${original_task}
    Wait Until Page Contains    ${original_task}
    
    # Edit the task
    Edit Task    ${original_task}    ${edited_task}
    Wait Until Page Contains    ${edited_task}
    Page Should Contain    ${edited_task}
    Page Should Not Contain    ${original_task}

Cancel Task Edit
    [Documentation]    Test canceling task edit operation
    [Tags]    positive    edit    ui
    ${original_task}=    Set Variable    Task edit to be canceled
    
    # Create a task first
    Create Task    ${original_task}
    Wait Until Page Contains    ${original_task}
    
    # Start editing but cancel
    Click Edit Task Button    ${original_task}
    Wait Until Element Is Visible    xpath://input[@value='${original_task}']
    Click Cancel Edit Button
    
    # Verify original task is still there
    Wait Until Page Contains    ${original_task}
    Page Should Contain    ${original_task}

Toggle Task Completion
    [Documentation]    Test toggling task completion status
    [Tags]    positive    toggle    ui
    ${task_text}=    Set Variable    Task to be completed
    
    # Create a task first
    Create Task    ${task_text}
    Wait Until Page Contains    ${task_text}
    
    # Toggle completion
    Toggle Task Completion    ${task_text}
    Wait Until Element Is Visible    xpath://label[contains(text(),'${task_text}') and contains(@class,'line-through')]
    
    # Toggle back to incomplete
    Toggle Task Completion    ${task_text}
    Wait Until Element Is Visible    xpath://label[contains(text(),'${task_text}') and not(contains(@class,'line-through'))]

Delete Task
    [Documentation]    Test deleting a task
    [Tags]    positive    delete    ui
    ${task_text}=    Set Variable    Task to be deleted
    
    # Create a task first
    Create Task    ${task_text}
    Wait Until Page Contains    ${task_text}
    
    # Delete the task
    Delete Task    ${task_text}
    Wait Until Page Does Not Contain    ${task_text}
    Page Should Not Contain    ${task_text}

Verify Initial Tasks Present
    [Documentation]    Test that initial tasks are present after login
    [Tags]    positive    read    ui
    Page Should Contain    Learn Next.js
    Page Should Contain    Build a full-stack app
    Page Should Contain    Deploy to Vercel

Logout Functionality
    [Documentation]    Test logout functionality
    [Tags]    positive    logout    ui
    Click Logout Button
    Wait Until Location Is    ${BASE_URL}/login
    Page Should Contain    Login
    Page Should Contain    Enter your credentials
