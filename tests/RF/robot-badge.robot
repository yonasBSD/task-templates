*** Settings ***
Documentation       robot:badge tests
...
...                 A test suite to validate badge task of robot.yml template.

Library             OperatingSystem
Library             Process
Library             String

Test Tags           badge    simple


*** Variables ***
${TASKFILE_PATH}    ${CURDIR}/../../Taskfile.d/robot.yml
${TESTS_DIR}        ${CURDIR}/../../tests
${TASK_BIN}         task
${BADGE_DIR}        /tmp
${D_FILE}           FILE=${TESTS_DIR}/robot/output-ref.xml
${D_DIR}            DIR=${BADGE_DIR}
${COLOR_GREEN}      \#4C1
${COLOR_ORANGE}     \#FE7D37
${COLOR_RED}        \#C00
${BADGE_PATH}       ${BADGE_DIR}/all_tests.svg


*** Test Cases ***
FILE argument missing
    [Documentation]    FILE|F argument missing badge test
    Run Task Badge    ${EMPTY}    1    ${EMPTY}    FILE|F argument is required

File not found
    [Documentation]    File not found
    Run Task Badge    ${D_DIR} FILE=/tmp/output.xml    1    ${EMPTY}    File /tmp/output.xml not found!

Successfull generate a badge
    [Documentation]    Generate a badge
    When Run Task Badge    ${D_DIR} ${D_FILE}    0    Passed Tests: 4 / 4 (Skipped tests 0)
    And Badge Displays    ${BADGE_PATH}    4 / 4 passed    ${COLOR_GREEN}

Successfull generate a badge with short arguments
    [Documentation]    Generate a badge with short argument
    When Run Task Badge
    ...    D=${BADGE_DIR} F=${TESTS_DIR}/robot/output-ref.xml
    ...    0
    ...    Passed Tests: 4 / 4 (Skipped tests 0)
    And Badge Displays    ${BADGE_PATH}    4 / 4 passed    ${COLOR_GREEN}

One test is failed
    [Documentation]    Generate a badge with a failed test
    When Run Task Badge
    ...    ${D_DIR} FILE=${TESTS_DIR}/robot/output-1-fail.xml
    ...    0
    ...    Passed Tests: 3 / 4 (Skipped tests 0)
    And Badge Displays    ${BADGE_PATH}    3 / 4 passed    ${COLOR_RED}

One test is skipped
    [Documentation]    Generate a badge with a skipped test
    When Run Task Badge
    ...    ${D_DIR} FILE=${TESTS_DIR}/robot/output-1-skip.xml
    ...    0
    ...    Passed Tests: 3 / 4 (Skipped tests 1)
    And Badge Displays    ${BADGE_PATH}    3 / 4 passed    ${COLOR_ORANGE}

One test is failed one is skipped
    [Documentation]    Generate a badge with a failed and a skipped test
    When Run Task Badge
    ...    ${D_DIR} FILE=${TESTS_DIR}/robot/output-1-skip-1-fail.xml
    ...    0
    ...    Passed Tests: 2 / 4 (Skipped tests 1)
    And Badge Displays    ${BADGE_PATH}    2 / 4 passed    ${COLOR_RED}


*** Keywords ***
Run Task Badge
    [Documentation]    Run command badge
    [Arguments]    ${arguments}    ${expected_rc}    ${expected_output}    ${expected_err}=${EMPTY}
    ${result} =    When Run Process    ${TASK_BIN} --taskfile ${TASKFILE_PATH} badge ${arguments}    shell=True
    Log    ${result.stdout}
    Log    ${result.stderr}
    Should Contain    ${result.stderr}    ${expected_err}
    Should Be Equal As Integers    ${result.rc}    ${expected_rc}
    Should Be Equal As Strings    ${result.stdout}    ${expected_output}

Badge Displays
    [Documentation]    Check badge display
    [Arguments]    ${file}    ${text}    ${color}
    File Should Exist    ${file}
    ${content} =    Get File    ${file}
    Should Contain    ${content}    ${text}
    Should Contain    ${content}    ${color}
