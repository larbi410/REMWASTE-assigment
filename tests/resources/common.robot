*** Settings ***
Documentation    Common variables and settings for all tests
Library          SeleniumLibrary
Library          RequestsLibrary

*** Variables ***
${BASE_URL}              http://localhost:3000
${API_BASE_URL}          http://localhost:3000/api
${BROWSER}               Chrome
${SELENIUM_SPEED}        0.2s
${SELENIUM_TIMEOUT}      10s
${AUTH_TOKEN}            ${EMPTY}

*** Keywords ***
Setup Test Session
    [Documentation]    Setup session for API tests
    Create Session    api    ${API_BASE_URL}    verify=False
