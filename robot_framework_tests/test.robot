*** Settings ***
Documentation     A simple test case to open a web page and check its title.
Library           SeleniumLibrary

*** Variables ***
${URL}              http://10.120.32.84
${EXPECTED_TITLE}   Food Paradise - Home

*** Test Cases ***
Open Website And Check Title
    Open Browser    ${URL}    headlessFirefox
    ${title}=    Get Title
    Capture Page Screenshot      index.png
    Should Be Equal As Strings    ${title}    ${EXPECTED_TITLE}

[Teardown]
    Close Browser