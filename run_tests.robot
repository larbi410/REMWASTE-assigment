*** Settings ***
Documentation    Test runner configuration
Library          OperatingSystem

*** Variables ***
${TEST_RESULTS_DIR}    results
${LOG_LEVEL}          INFO

*** Keywords ***
Run All Tests
    [Documentation]    Run all test suites
    Create Directory    ${TEST_RESULTS_DIR}
    
    # Run UI Tests
    Run Tests    tests/ui    ui_tests
    
    # Run API Tests  
    Run Tests    tests/api    api_tests
    
    # Run Integration Tests
    Run Tests    tests/integration    integration_tests

Run Tests
    [Arguments]    ${test_path}    ${output_name}
    ${result}=    Run Process    robot    
    ...    --outputdir    ${TEST_RESULTS_DIR}
    ...    --output    ${output_name}.xml
    ...    --log    ${output_name}.html
    ...    --report    ${output_name}_report.html
    ...    --loglevel    ${LOG_LEVEL}
    ...    ${test_path}
    Log    ${result.stdout}
    Log    ${result.stderr}

Run UI Tests Only
    [Documentation]    Run only UI tests
    Create Directory    ${TEST_RESULTS_DIR}
    Run Tests    tests/ui    ui_tests

Run API Tests Only
    [Documentation]    Run only API tests
    Create Directory    ${TEST_RESULTS_DIR}
    Run Tests    tests/api    api_tests

Run Integration Tests Only
    [Documentation]    Run only integration tests
    Create Directory    ${TEST_RESULTS_DIR}
    Run Tests    tests/integration    integration_tests
