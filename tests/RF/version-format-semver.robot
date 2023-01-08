** Settings ***
Documentation     version:format-semver tests
...
...               A test suite to validate format-semver task of version.yml template.

Library           Process

*** Variables ***
${TESTS_DIR}   tests
${TASKFILE_PATH}   ${CURDIR}/../../Taskfile.d/version.yml
${TASK_BIN}   task

*** Test Cases ***
[VERSION] option missing
    [Tags]    docker    get-next-tag-index       simple
    Run task format-semver   DUMMY=1.2.3    1    ${EMPTY}    VERSION|V argument is required

Successfull identical return with VERSION argument
    [Tags]    version    format-semver    simple
    Run task format-semver   VERSION=1.2.3    0    1.2.3

Successfull identical return with V argument
    [Tags]    version    format-semver    simple
    Run task format-semver   V=1.2.3    0    1.2.3

Successfull identical return with pre-release alpha
    [Tags]    version    format-semver    simple
    Run task format-semver   VERSION=1.2.3-alpha    0    1.2.3-alpha

Successfull identical return with pre-release rc1
    [Tags]    version    format-semver    simple
    Run task format-semver   VERSION=1.2.3-rc1    0    1.2.3-rc1

Successfull return without build
    [Tags]    version    format-semver    simple
    Run task format-semver   VERSION=1.2.3+b012    0    1.2.3

Format with default patch
    [Tags]    version    format-semver    simple
    Run task format-semver   VERSION=1.2    0    1.2.0

Format with default patch with pre-release alpha
    [Tags]    version    format-semver    simple
    Run task format-semver   VERSION=1.2-alpha    0    1.2.0-alpha

Format with default minor and patch
    [Tags]    version    format-semver    simple
    Run task format-semver   VERSION=1    0    1.0.0

Format with default minor and patch with pre-release alpha
    [Tags]    version    format-semver    simple
    Run task format-semver   VERSION=1-alpha    0    1.0.0-alpha

Format with default patch with pre-release alpha with build
    [Tags]    version    format-semver    simple
    Run task format-semver   VERSION=1-alpha+b012    0    1.0.0-alpha

*** Keywords ***
Run task format-semver
    [Arguments]    ${argument}    ${expected_rc}    ${expected_output}    ${expected_err}=${EMPTY}
    ${result} =    When Run Process    ${TASK_BIN}   --taskfile   ${TASKFILE_PATH}   format-semver   ${argument}
    Should Contain    ${result.stderr}    ${expected_err}
    Should Be Equal As Integers    ${result.rc}    ${expected_rc}
    Should Be Equal As Strings    ${result.stdout}    ${expected_output}
