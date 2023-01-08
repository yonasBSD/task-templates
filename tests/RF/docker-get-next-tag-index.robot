** Settings ***
Documentation     docker:get-next-tag-index tests
...
...               A test suite to validate get-next-tag-index task of docker.yml template.

Library           Process

*** Variables ***
${TESTS_DIR}   tests
${TASKFILE_PATH}   ${CURDIR}/../../Taskfile.d/docker.yml
${TASK_BIN}   task
${REPOSITORY}   index.docker.io/jfxs/test-purposes-only

*** Test Cases ***
[IMG] option missing
    [Tags]    docker    get-next-tag-index       simple
    Run task get-next-tag-index   DUMMY=${REPOSITORY}   VERSION=1.0.0    1    ${EMPTY}    IMG|I argument is required

[VERSION] option missing
    [Tags]    docker    get-next-tag-index       simple
    Run task get-next-tag-index   IMG=${REPOSITORY}   DUMMY=1.0.0    1    ${EMPTY}    VERSION|V argument is required

Not existing tag returns 001
    [Tags]    docker    get-next-tag-index   internet
    Run task get-next-tag-index   IMG=${REPOSITORY}   VERSION=1.0.0    0    001

Not existing tag returns 001 with short arguments
    [Tags]    docker    get-next-tag-index   internet
    Run task get-next-tag-index   I=${REPOSITORY}   V=1.0.0    0    001

Continuous existing tag returns last + 1
    [Tags]    docker    get-next-tag-index   internet
    Run task get-next-tag-index   IMG=${REPOSITORY}   VERSION=1.0.1    0    004

Missing first index of existing tag returns last + 1
    [Tags]    docker    get-next-tag-index   internet
    Run task get-next-tag-index   IMG=${REPOSITORY}   VERSION=1.0.2    0    003

Discontinuous existing tag returns last + 1
    [Tags]    docker    get-next-tag-index   internet
    Run task get-next-tag-index   IMG=${REPOSITORY}   VERSION=1.0.3    0    004

*** Keywords ***
Run task get-next-tag-index
    [Arguments]    ${argument1}    ${argument2}    ${expected_rc}    ${expected_output}    ${expected_err}=${EMPTY}
    ${result} =    When Run Process    ${TASK_BIN}   --taskfile   ${TASKFILE_PATH}   get-next-tag-index    ${argument1}    ${argument2}
    Should Contain    ${result.stderr}    ${expected_err}
    Should Be Equal As Integers    ${result.rc}    ${expected_rc}
    Should Be Equal As Strings    ${result.stdout}    ${expected_output}
