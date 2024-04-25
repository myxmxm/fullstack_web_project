*** Settings ***
Documentation     Reservation functional test
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           DateTime  
Resource          ../common.resource   
Test Teardown     Close Browser
Default Tags      Functional

*** Test Cases ***
Reservation Functional Test
    Initialize Suite Variables
    Open Web Application
    Go To Home Page
    Check Reservation Number Before Adding New Reservation
    Reservation Form Submission Test
    Check Reservation Number After Adding New Reservation
    Confirm Reservation Test
    Delete Reservation Test
    Logout

*** Keywords ***
Initialize Suite Variables
    Set Suite Variable    ${reservation_number}   0

Check Reservation Number Before Adding New Reservation
    Go To Login Page 
    Login With Admin Credential    admin    1234
    Go To Reservation Page
    ${num}   Get Element Count    ${RESERVATIONS}
    Set Suite Variable    ${reservation_number}    ${num} 
    Log    The number of reservations before adding new one is: ${reservation_number}
    Logout

Reservation Form Submission Test
    Go To Home Page
    Input Text     name    Tester
    Input Text     email   tester@test.com
    Input Text     date    2024-05-23
    Input Text     time    12:00
    Click Button    xpath=//*[@id="reservationForm"]/button
    ${text}    Get Text    ${ALERT}
    Should Be Equal As Strings    ${text}    Reservation created successfully

Check Reservation Number After Adding New Reservation
    Go To Login Page 
    Login With Admin Credential    admin    1234
    Go To Reservation Page
    ${expected_reservation_number_after_add}    Evaluate    ${reservation_number} + 1
    ${eservation_number_after_add}    Get Element Count    ${RESERVATIONS}
    Set Suite Variable    ${reservation_number}    ${eservation_number_after_add}
    Log    The number of reservations after adding new one is: ${reservation_number}
    Should Be Equal As Numbers    ${eservation_number_after_add}    ${expected_reservation_number_after_add}
    Capture Page Screenshot     reservation_add.png

Confirm Reservation Test
    ${status_before}    Get Text    //*[@id="reservation_list"]/div[1]/p[5]
    Should Be Equal As Strings    ${status_before}     Reservation status: unconfirmed
    Click Element    //*[@id="reservation_list"]/div[1]/button[2]
    ${status_after}    Get Text    //*[@id="reservation_list"]/div[1]/p[5]
    Should Be Equal As Strings    ${status_after}     Reservation status: confirmed
    Capture Page Screenshot     reservation_confirm.png

Delete Reservation Test
    Click Element    //*[@id="reservation_list"]/div[1]/button[1]
    ${expected_reservation_number_after_delete}    Evaluate    ${reservation_number} - 1
    ${reservation_number_after_delete}    Get Element Count    ${RESERVATIONS}
    Should Be Equal As Numbers    ${reservation_number_after_delete}    ${expected_reservation_number_after_delete}
    Capture Page Screenshot     reservation_delete.png
