*** Settings ***
Documentation     Message functional test
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           DateTime  
Resource          ../common.resource   
Test Teardown     Close Browser
Default Tags      Functional

*** Test Cases ***
Message Functional Test
    Initialize Suite Variables
    Open Web Application
    Check Message Number Before Adding New Message
    Message Form Submission Test
    Check Message Number After Adding New Message
    Acknowledge Message Test
    Delete Message Test
    Logout

*** Keywords ***
Initialize Suite Variables
    Set Suite Variable    ${message_number}   0

Check Message Number Before Adding New Message
    Go To Login Page 
    Login With Admin Credential    admin    1234
    Go To Message Page 
    ${num}   Get Element Count    ${MESSAGES}
    Set Suite Variable    ${message_number}    ${num} 
    Log    The number of message before adding new one is: ${message_number}
    Logout

Message Form Submission Test
    Go To Contact Page 
    Input Text    message_email    tester@test.com
    Input Text    message_content    This is a test message
    Click Button    //*[@id="messageForm"]/button
    ${text}    Get Text    ${ALERT}
    Should Be Equal As Strings    ${text}    Message send successfully

Check Message Number After Adding New Message
    Go To Login Page 
    Login With Admin Credential    admin    1234
    Go To Message Page 
    ${expected_message_number_after_add}    Evaluate    ${message_number} + 1
    ${message_number_after_add}    Get Element Count    ${MESSAGES}
    Set Suite Variable    ${message_number}    ${message_number_after_add}
    Log    The number of reservations after adding new one is: ${message_number_after_add}
    Should Be Equal As Numbers    ${message_number_after_add}    ${expected_message_number_after_add}
    Capture Page Screenshot     message_add.png

Acknowledge Message Test
    ${status_before}    Get Text    //*[@id="message_list"]/div[1]/p[3]
    Should Be Equal As Strings    ${status_before}     Message status: unacknowledged
    Click Element    //*[@id="message_list"]/div[1]/button[2]
    ${status_after}    Get Text    //*[@id="message_list"]/div[1]/p[3]
    Should Be Equal As Strings    ${status_after}     Message status: acknowledged
    Capture Page Screenshot     message_acknowledge.png

Delete Message Test
    Click Element    //*[@id="message_list"]/div[1]/button[1]
    ${expected_message_number_after_delete}    Evaluate    ${message_number} - 1
    ${message_number_after_delete}    Get Element Count    ${MESSAGES}
    Should Be Equal As Numbers    ${message_number_after_delete}    ${expected_message_number_after_delete}
    Capture Page Screenshot     message_delete.png