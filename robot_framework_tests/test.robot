*** Settings ***
Documentation     A simple test case to open a web page and check its title.
Library           SeleniumLibrary

*** Variables ***
${URL}              http://10.120.32.84
${EXPECTED_TITLE}   Food Paradise - Homes

*** Test Cases ***
Open Website And Check Title
    Open Browser    ${URL}    headlessFirefox
    ${title}=    Get Title
    Capture Page Screenshot      test.png
    Should Be Equal As Strings    ${title}    ${EXPECTED_TITLE}

[Teardown]
    Close Browser