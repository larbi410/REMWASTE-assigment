*** Settings ***
Documentation    End-to-end integration tests combining UI and API
Library          SeleniumLibrary
Library          RequestsLibrary
Resource         ../resources/common.robot
Resource         ../resources/ui_keywords.robot
Resource         ../resources/api_keywords.robot
Suite Setup      Setup Integration Tests
Suite Teardown   Close Browser

*** Test Cases ***
Create Task Via API And Verify In UI
    [Documentation]    Create a task via API and verify it appears in UI
    [Tags]    integration    positive
    ${task_text}=    Set Variable    Task created via API for UI verification
    
    # Create task via API
    ${response}=    Create Task Via API    ${AUTH_TOKEN}    ${task_text}
    Should Be Equal As Integers    ${response.status_code}    201
    
    # Refresh UI and verify task appears
    Go To Task Manager Page
    Reload Page
    Wait Until Page Contains    ${task_text}
    Page Should Contain    ${task_text}

Create Task Via UI And Verify Via API
    [Documentation]    Create a task via UI and verify it exists via API
    [Tags]    integration    positive
    ${task_text}=    Set Variable    Task created via UI for API verification
    
    # Create task via UI
    Go To Task Manager Page
    Create Task    ${task_text}
    Wait Until Page Contains    ${task_text}
    
    # Verify via API
    ${response}=    Get Tasks Via API    ${AUTH_TOKEN}
    Should Be Equal As Integers    ${response.status_code}    200
    ${tasks}=    Set Variable    ${response.json()}
    ${task_texts}=    Create List
    FOR    ${task}    IN    @{tasks}
        Append To List    ${task_texts}    ${task}[text]
    END
    Should Contain    ${task_texts}    ${task_text}

Update Task Via UI And Verify Via API
    [Documentation]    Update a task via UI and verify changes via API
    [Tags]    integration    positive
    ${original_text}=    Set Variable    Original task for integration test
    ${updated_text}=    Set Variable    Updated task via UI for API verification
    
    # Create task via API first
    ${create_response}=    Create Task Via API    ${AUTH_TOKEN}    ${original_text}
    ${task_id}=    Set Variable    ${create_response.json()}[id]
    
    # Update via UI
    Go To Task Manager Page
    Reload Page
    Wait Until Page Contains    ${original_text}
    Edit Task    ${original_text}    ${updated_text}
    Wait Until Page Contains    ${updated_text}
    
    # Verify via API
    ${response}=    Get Task By ID Via API    ${AUTH_TOKEN}    ${task_id}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[text]    ${updated_text}

Delete Task Via UI And Verify Via API
    [Documentation]    Delete a task via UI and verify it's gone via API
    [Tags]    integration    positive
    ${task_text}=    Set Variable    Task to be deleted via UI
    
    # Create task via API first
    ${create_response}=    Create Task Via API    ${AUTH_TOKEN}    ${task_text}
    ${task_id}=    Set Variable    ${create_response.json()}[id]
    
    # Delete via UI
    Go To Task Manager Page
    Reload Page
    Wait Until Page Contains    ${task_text}
    Delete Task    ${task_text}
    Wait Until Page Does Not Contain    ${task_text}
    
    # Verify via API
    ${response}=    Get Task By ID Via API    ${AUTH_TOKEN}    ${task_id}
    Should Be Equal As Integers    ${response.status_code}    404

*** Keywords ***
Setup Integration Tests
    [Documentation]    Setup for integration tests
    Get Auth Token
    Open Browser To Login Page
    Login With Valid Credentials And Navigate
