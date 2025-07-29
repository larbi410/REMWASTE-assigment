*** Settings ***
Documentation    API-specific keywords for REST API tests
Library          RequestsLibrary
Library          Collections
Resource         common.robot

*** Keywords ***
Get Auth Token
    [Documentation]    Get authentication token for API tests
    ${response}=    Login Via API    user    password
    Set Global Variable    ${AUTH_TOKEN}    ${response.json()}[token]

Login Via API
    [Documentation]    Login via API and return response
    [Arguments]    ${username}    ${password}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    username=${username}    password=${password}
    ${response}=    POST    ${API_BASE_URL}/auth/login    json=${data}    headers=${headers}    expected_status=any
    RETURN    ${response}

Get Tasks Via API
    [Documentation]    Get all tasks via API
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Content-Type=application/json
    Run Keyword If    '${token}' != '${EMPTY}'    Set To Dictionary    ${headers}    Authorization=Bearer ${token}
    ${response}=    GET    ${API_BASE_URL}/items    headers=${headers}    expected_status=any
    RETURN    ${response}

Get Task By ID Via API
    [Documentation]    Get a specific task by ID via API
    [Arguments]    ${token}    ${task_id}
    ${headers}=    Create Dictionary    Content-Type=application/json
    Run Keyword If    '${token}' != '${EMPTY}'    Set To Dictionary    ${headers}    Authorization=Bearer ${token}
    ${response}=    GET    ${API_BASE_URL}/items/${task_id}    headers=${headers}    expected_status=any
    RETURN    ${response}

Create Task Via API
    [Documentation]    Create a new task via API
    [Arguments]    ${token}    ${task_text}
    ${headers}=    Create Dictionary    Content-Type=application/json
    Run Keyword If    '${token}' != '${EMPTY}'    Set To Dictionary    ${headers}    Authorization=Bearer ${token}
    ${data}=    Create Dictionary    text=${task_text}
    ${response}=    POST    ${API_BASE_URL}/items    json=${data}    headers=${headers}    expected_status=any
    RETURN    ${response}

Update Task Via API
    [Documentation]    Update an existing task via API
    [Arguments]    ${token}    ${task_id}    ${update_data}
    ${headers}=    Create Dictionary    Content-Type=application/json
    Run Keyword If    '${token}' != '${EMPTY}'    Set To Dictionary    ${headers}    Authorization=Bearer ${token}
    ${response}=    PUT    ${API_BASE_URL}/items/${task_id}    json=${update_data}    headers=${headers}    expected_status=any
    RETURN    ${response}

Delete Task Via API
    [Documentation]    Delete a task via API
    [Arguments]    ${token}    ${task_id}
    ${headers}=    Create Dictionary    Content-Type=application/json
    Run Keyword If    '${token}' != '${EMPTY}'    Set To Dictionary    ${headers}    Authorization=Bearer ${token}
    ${response}=    DELETE    ${API_BASE_URL}/items/${task_id}    headers=${headers}    expected_status=any
    RETURN    ${response}

Reset Tasks State
    [Documentation]    Reset tasks to initial state (for API tests)
    # This is a simplified reset - in a real scenario, you might need to implement
    # a test-specific endpoint or database reset functionality
    Log    Tasks state reset (in-memory database will reset on server restart)
