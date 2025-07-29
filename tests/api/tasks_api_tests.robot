*** Settings ***
Documentation    API Tests for Tasks endpoints
Library          RequestsLibrary
Library          Collections
Resource         ../resources/common.robot
Resource         ../resources/api_keywords.robot
Suite Setup      Get Auth Token
Test Setup       Reset Tasks State

*** Test Cases ***
GET Items With Valid Token
    [Documentation]    Test retrieving all tasks via API
    [Tags]    positive    api    get
    ${response}=    Get Tasks Via API    ${AUTH_TOKEN}
    Should Be Equal As Integers    ${response.status_code}    200
    ${tasks}=    Set Variable    ${response.json()}
    Should Be True    len($tasks) >= 3
    # Verify initial tasks are present
    ${task_texts}=    Create List
    FOR    ${task}    IN    @{tasks}
        Append To List    ${task_texts}    ${task}[text]
    END
    Should Contain    ${task_texts}    Learn Next.js
    Should Contain    ${task_texts}    Build a full-stack app
    Should Contain    ${task_texts}    Deploy to Vercel

GET Items Without Token
    [Documentation]    Test retrieving tasks without authentication token
    [Tags]    negative    api    get
    ${response}=    Get Tasks Via API    ${EMPTY}
    Should Be Equal As Integers    ${response.status_code}    401
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Unauthorized

GET Items With Invalid Token
    [Documentation]    Test retrieving tasks with invalid authentication token
    [Tags]    negative    api    get
    ${response}=    Get Tasks Via API    invalid-token
    Should Be Equal As Integers    ${response.status_code}    401
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Unauthorized

POST Create New Task
    [Documentation]    Test creating a new task via API
    [Tags]    positive    api    post
    ${task_text}=    Set Variable    New task created via API
    ${response}=    Create Task Via API    ${AUTH_TOKEN}    ${task_text}
    Should Be Equal As Integers    ${response.status_code}    201
    ${created_task}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${created_task}    id
    Dictionary Should Contain Key    ${created_task}    text
    Dictionary Should Contain Key    ${created_task}    completed
    Should Be Equal    ${created_task}[text]    ${task_text}
    Should Be Equal    ${created_task}[completed]    ${False}
    Should Not Be Empty    ${created_task}[id]

POST Create Task Without Token
    [Documentation]    Test creating a task without authentication token
    [Tags]    negative    api    post
    ${task_text}=    Set Variable    Unauthorized task
    ${response}=    Create Task Via API    ${EMPTY}    ${task_text}
    Should Be Equal As Integers    ${response.status_code}    401
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Unauthorized

POST Create Task With Empty Text
    [Documentation]    Test creating a task with empty text
    [Tags]    negative    api    post
    ${response}=    Create Task Via API    ${AUTH_TOKEN}    ${EMPTY}
    Should Be Equal As Integers    ${response.status_code}    400
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Task text is required

PUT Update Existing Task
    [Documentation]    Test updating an existing task via API
    [Tags]    positive    api    put
    # First create a task
    ${original_text}=    Set Variable    Task to be updated
    ${create_response}=    Create Task Via API    ${AUTH_TOKEN}    ${original_text}
    ${task_id}=    Set Variable    ${create_response.json()}[id]
    
    # Update the task
    ${updated_text}=    Set Variable    Task has been updated via API
    ${update_data}=    Create Dictionary    text=${updated_text}    completed=${True}
    ${response}=    Update Task Via API    ${AUTH_TOKEN}    ${task_id}    ${update_data}
    Should Be Equal As Integers    ${response.status_code}    200
    ${updated_task}=    Set Variable    ${response.json()}
    Should Be Equal    ${updated_task}[id]    ${task_id}
    Should Be Equal    ${updated_task}[text]    ${updated_text}
    Should Be Equal    ${updated_task}[completed]    ${True}

PUT Update Non-Existent Task
    [Documentation]    Test updating a non-existent task via API
    [Tags]    negative    api    put
    ${update_data}=    Create Dictionary    text=Updated text
    ${response}=    Update Task Via API    ${AUTH_TOKEN}    999    ${update_data}
    Should Be Equal As Integers    ${response.status_code}    404
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Task not found

PUT Update Task Without Token
    [Documentation]    Test updating a task without authentication token
    [Tags]    negative    api    put
    ${update_data}=    Create Dictionary    text=Unauthorized update
    ${response}=    Update Task Via API    ${EMPTY}    1    ${update_data}
    Should Be Equal As Integers    ${response.status_code}    401
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Unauthorized

DELETE Existing Task
    [Documentation]    Test deleting an existing task via API
    [Tags]    positive    api    delete
    # First create a task
    ${task_text}=    Set Variable    Task to be deleted
    ${create_response}=    Create Task Via API    ${AUTH_TOKEN}    ${task_text}
    ${task_id}=    Set Variable    ${create_response.json()}[id]
    
    # Delete the task
    ${response}=    Delete Task Via API    ${AUTH_TOKEN}    ${task_id}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Task deleted successfully
    
    # Verify task is deleted by trying to get it
    ${get_response}=    Get Task By ID Via API    ${AUTH_TOKEN}    ${task_id}
    Should Be Equal As Integers    ${get_response.status_code}    404

DELETE Non-Existent Task
    [Documentation]    Test deleting a non-existent task via API
    [Tags]    negative    api    delete
    ${response}=    Delete Task Via API    ${AUTH_TOKEN}    999
    Should Be Equal As Integers    ${response.status_code}    404
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Task not found

DELETE Task Without Token
    [Documentation]    Test deleting a task without authentication token
    [Tags]    negative    api    delete
    ${response}=    Delete Task Via API    ${EMPTY}    1
    Should Be Equal As Integers    ${response.status_code}    401
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Unauthorized
