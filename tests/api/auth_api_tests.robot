*** Settings ***
Documentation    API Tests for Authentication endpoints
Library          RequestsLibrary
Library          Collections
Resource         ../resources/common.robot
Resource         ../resources/api_keywords.robot

*** Test Cases ***
POST Login With Valid Credentials
    [Documentation]    Test successful login via API
    [Tags]    positive    api    auth
    ${response}=    Login Via API    user    password
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    message
    Dictionary Should Contain Key    ${response.json()}    token
    Should Be Equal    ${response.json()}[message]    Login successful
    Should Not Be Empty    ${response.json()}[token]

POST Login With Invalid Username
    [Documentation]    Test login failure with invalid username via API
    [Tags]    negative    api    auth
    ${response}=    Login Via API    invalid_user    password
    Should Be Equal As Integers    ${response.status_code}    401
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Invalid credentials

POST Login With Invalid Password
    [Documentation]    Test login failure with invalid password via API
    [Tags]    negative    api    auth
    ${response}=    Login Via API    user    invalid_password
    Should Be Equal As Integers    ${response.status_code}    401
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Invalid credentials

POST Login With Empty Credentials
    [Documentation]    Test login failure with empty credentials via API
    [Tags]    negative    api    auth
    ${response}=    Login Via API    ${EMPTY}    ${EMPTY}
    Should Be Equal As Integers    ${response.status_code}    401
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Invalid credentials

POST Login With Missing Username
    [Documentation]    Test login failure with missing username via API
    [Tags]    negative    api    auth
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    password=password
    ${response}=    POST    ${API_BASE_URL}/auth/login    json=${data}    headers=${headers}    expected_status=401
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Invalid credentials

POST Login With Missing Password
    [Documentation]    Test login failure with missing password via API
    [Tags]    negative    api    auth
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    username=user
    ${response}=    POST    ${API_BASE_URL}/auth/login    json=${data}    headers=${headers}    expected_status=401
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal    ${response.json()}[message]    Invalid credentials
