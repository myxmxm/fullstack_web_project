*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${BROWSER}        HeadlessChrome
${URL}            http://example.com
${EXPECTED TITLE}    Example Domainn

*** Test Cases ***
Check Web Page Title
    Open Browser    ${URL}    ${BROWSER}
    ${actual_title}=    Get Title
    Should Be Equal As Strings    ${actual_title}    ${EXPECTED TITLE}
    Close Browser