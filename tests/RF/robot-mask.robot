*** Settings ***
Documentation       robot:mask tests
...
...                 A test suite to validate mask task of robot.yml template.

Library             OperatingSystem
Library             Process
Library             String

Test Tags           mask    simple


*** Variables ***
${TASKFILE_PATH}    ${CURDIR}/../../Taskfile.d/robot.yml
${TESTS_DIR}        tests
${TASK_BIN}         task
${OUTPUT_REF}       ${TESTS_DIR}/robot/output-ref.xml
${OUTPUT_TEST}      /tmp/output.xml
${MASK}             **MASKED**
${D_DATA}           DATA=P4ssw0rd
${D_FILE}           FILE=${OUTPUT_TEST}
${LONG_OUTPUT1}     Masked variable [0]: 4 matches${\n}Masked variable [1]: 2 matches${\n}
${LONG_OUTPUT2}     Masked variable [2]: 0 matches${\n}Masked variable [3]: 2 matches


*** Test Cases ***
DATA argument missing
    [Documentation]    DATA|D argument missing mask test
    Run Task Mask    ${D_FILE}    1    ${EMPTY}    DATA|D argument is required

FILE argument missing
    [Documentation]    DATA|D argument missing mask test
    Run Task Mask    ${D_DATA}    1    ${EMPTY}    FILE|F argument is required

File not found
    [Documentation]    File not found
    Run Task Mask    ${D_DATA} ${D_FILE}    1    ${EMPTY}    File ${OUTPUT_TEST} not found!

Successfull mask a value
    [Documentation]    Mask a value
    Given Copy File    ${OUTPUT_REF}   ${OUTPUT_TEST}
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    P4ssw0rd    4
    When Run Task Mask    ${D_DATA} ${D_FILE}    0    Masked variable [0]: 4 matches    ${EMPTY}
    Then Pattern Matches N Times In File    ${OUTPUT_TEST}    P4ssw0rd    0
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    ${MASK}    4

Successfull mask a value with short arguments
    [Documentation]    Mask a value with short arguments
    Given Copy File    ${OUTPUT_REF}   ${OUTPUT_TEST}
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    P4ssw0rd    4
    When Run Task Mask    D=P4ssw0rd F=${OUTPUT_TEST}    0    Masked variable [0]: 4 matches    ${EMPTY}
    Then Pattern Matches N Times In File    ${OUTPUT_TEST}    P4ssw0rd    0
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    ${MASK}    4

Mask a value that does not exist
    [Documentation]    Mask a value that does not exist
    Given Copy File    ${OUTPUT_REF}   ${OUTPUT_TEST}
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    P4ssw0rdX    0
    When Run Task Mask    DATA=P4ssw0rdX ${D_FILE}    0    Masked variable [0]: 0 matches    ${EMPTY}
    Then Pattern Matches N Times In File    ${OUTPUT_TEST}    P4ssw0rdX    0
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    ${MASK}    0

Successfull mask multiple values
    [Documentation]    Mask multiple values
    Given Copy File    ${OUTPUT_REF}   ${OUTPUT_TEST}
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    P4ssw0rd    4
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    fred    2
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    betty    2
    When Run Task Mask
    ...    DATA=P4ssw0rd,fred,P4ssw0rdX,betty ${D_FILE}
    ...    0
    ...    ${LONG_OUTPUT1}${LONG_OUTPUT2}
    ...    ${EMPTY}
    Then Pattern Matches N Times In File    ${OUTPUT_TEST}    P4ssw0rd    0
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    fred    0
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    P4ssw0rdX    0
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    betty    0
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    ${MASK}    8

Successfull mask a value twice
    [Documentation]    Mask a value twice
    Given Copy File    ${OUTPUT_REF}   ${OUTPUT_TEST}
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    P4ssw0rd    4
    When Run Task Mask    ${D_DATA} ${D_FILE}    0    Masked variable [0]: 4 matches    ${EMPTY}
    Then Pattern Matches N Times In File    ${OUTPUT_TEST}    P4ssw0rd    0
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    ${MASK}    4
    When Run Task Mask    ${D_DATA} ${D_FILE}    0    Masked variable [0]: 0 matches    ${EMPTY}
    Then Pattern Matches N Times In File    ${OUTPUT_TEST}    P4ssw0rd    0
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    ${MASK}    4

Successfull mask 2 values with 2 runs
    [Documentation]    Mask 2 values with 2 runs
    Given Copy File    ${OUTPUT_REF}   ${OUTPUT_TEST}
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    P4ssw0rd    4
    When Run Task Mask    ${D_DATA} ${D_FILE}    0    Masked variable [0]: 4 matches    ${EMPTY}
    Then Pattern Matches N Times In File    ${OUTPUT_TEST}    P4ssw0rd    0
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    ${MASK}    4
    When Run Task Mask    DATA=fred ${D_FILE}    0    Masked variable [0]: 2 matches    ${EMPTY}
    Then Pattern Matches N Times In File    ${OUTPUT_TEST}    P4ssw0rd    0
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    fred    0
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    ${MASK}    6

Successfull mask a value with escaped character /
    [Documentation]    Mask a value with escaped character /
    Given Copy File    ${OUTPUT_REF}   ${OUTPUT_TEST}
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    dir1/dir2/dir3    2
    When Run Task Mask    DATA=dir1/dir2/dir3 ${D_FILE}    0    Masked variable [0]: 2 matches    ${EMPTY}
    Then Pattern Matches N Times In File    ${OUTPUT_TEST}    dir1/dir2/dir3    0
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    ${MASK}    2

Successfull mask a value with escaped characters []/\dot^$*
    [Documentation]    Mask a value with escaped characters []/\dot^$*
    Given Copy File    ${OUTPUT_REF}   ${OUTPUT_TEST}
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    a/[]\\y.^$*    2
    When Run Task Mask    DATA="a/[]\\y.^$*" ${D_FILE}    0    Masked variable [0]: 2 matches    ${EMPTY}
    Then Pattern Matches N Times In File    ${OUTPUT_TEST}    a/[]\\y.^$*    0
    And Pattern Matches N Times In File    ${OUTPUT_TEST}    ${MASK}    2


*** Keywords ***
Run Task Mask
    [Documentation]    Run command mask
    [Arguments]    ${arguments}    ${expected_rc}    ${expected_output}    ${expected_err}=${EMPTY}
    ${result} =    When Run Process    ${TASK_BIN} --taskfile ${TASKFILE_PATH} mask ${arguments}    shell=True
    Should Contain    ${result.stderr}    ${expected_err}
    Should Be Equal As Integers    ${result.rc}    ${expected_rc}
    Should Be Equal As Strings    ${result.stdout}    ${expected_output}

Pattern Matches N Times In File
    [Documentation]    Find occurences of a pattern
    [Arguments]    ${file}    ${pattern}    ${n}
    ${lines} =    Grep File    ${file}    ${pattern}
    ${count} =    Get Count    ${lines}    ${pattern}
    Should Be Equal As Integers    ${n}    ${count}
