*** Settings ***
Documentation     Admin GUI tests
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           DateTime  
Resource          ../common.resource   
Test Teardown     Close Browser
Default Tags      GUI

*** Test Cases ***
Admin GUI Test
    Open Web Application
    Login Page GUI Test
    Login With Admin Credential    admin    1234
    Admin Home Page GUI Test
    Add New Promotion Page GUI Test
    Modify Promotion Page GUI Test
    Menu Page GUI Test
    Reservation Page GUI Test
    Message Page GUI Test
    Logout

*** Keywords ***
Login Page GUI Test
    Go To Login Page 
    ${login_page_title_correct}   Check Page Title    Food Paradise - Login
    Should Be True    ${login_page_title_correct} 
    ${text}    Get Text    xpath=/html/body/main/div/h2
    Should Be Equal As Strings      ${text}    Admin Login
    Page Should Contain Element     ${LOGIN_PAGE_FORM} 
    Capture Page Screenshot      login_page.png

Admin Home Page GUI Test
    Go To Home Page
    ${home_page_title_correct}   Check Page Title    Food Paradise - Home
    Should Be True    ${home_page_title_correct} 
    Page Should Contain Element     ${ADD_PROMOTION_BUTTON} 
    Page Should Contain Element     ${PROMOTION_LIST}
    ${promotion_number}    Get Element Count    ${PROMOTIONS} 
    IF  ${promotion_number} > 1
        Log    There are ${promotion_number} promotions on the list.
        Page Should Contain Element     ${DELETE_PROMOTION_BUTTON} 
        Page Should Contain Element     ${MODIFY_PROMOTION_BUTTON}
    ELSE IF  ${promotion_number} == 1
        Log    There is 1 promotion on the list.
        Page Should Contain Element     ${DELETE_PROMOTION_BUTTON} 
        Page Should Contain Element     ${MODIFY_PROMOTION_BUTTON}
    ELSE
        Fail     There is no promotion on the list!
    END
    Capture Page Screenshot      admin_home_page.png

Add New Promotion Page GUI Test
    Go To Add New Promotion Page 
    ${add_new_promotion_page_title_correct}   Check Page Title    Food Paradise - Add Promotion
    Should Be True    ${add_new_promotion_page_title_correct}
    Page Should Contain Element     ${ADD_NEW_PROMOTION_FORM}
    Capture Page Screenshot      add_new_promotion_page.png
    Click Element    ${CANCEL_BUTTON} 

Modify Promotion Page GUI Test
    Go To Modify Promotion Page    1
    ${modify_promotion_page_title_correct}   Check Page Title    Food Paradise - Modify Promotion
    Should Be True    ${modify_promotion_page_title_correct}
    Page Should Contain Element     ${MODIFY_PROMOTION_FORM}
    Capture Page Screenshot      modify_promotion_page.png
    Click Element    ${CANCEL_BUTTON} 

Menu Page GUI Test
    Go To Menu Page
    ${menu_page_title_correct}   Check Page Title    Food Paradise - Menu
    Should Be True    ${menu_page_title_correct} 
    Page Should Contain Element     ${ADD_NEW_MENU_FORM}
    Page Should Contain Element     ${MENU_LIST}
    ${menu_number}    Get Element Count    ${MENUS}
    IF  ${menu_number} > 1
        Log    There are ${menu_number} menus on the list.
        Page Should Contain Element    ${DELETE_MENU_BUTTON}
        Page Should Contain Element    ${MODIFY_MENU_BUTTON}
    ELSE IF  ${menu_number} == 1
        Log    There is 1 menu on the list.
        Page Should Contain Element    ${DELETE_MENU_BUTTON}
        Page Should Contain Element    ${MODIFY_MENU_BUTTON}
    ELSE
        Fail     There is no menu on the list!
    END
    Capture Page Screenshot      admin_menu_page.png

Modify Menu Page GUI Test
    Go To Modify Menu Page    1
    ${modify_promotion_page_title_correct}   Check Page Title    Food Paradise - Modify Menu
    Should Be True    ${modify_promotion_page_title_correct}
    Page Should Contain Element     ${MODIFY_MENU_FORM}
    Capture Page Screenshot      modify_menu_page.png
    Click Button    ${CANCEL_BUTTON}

Reservation Page GUI Test
    Go To Reservation Page 
    ${reservation_page_title_correct}   Check Page Title    Food Paradise - Reservation
    Should Be True    ${reservation_page_title_correct}
    Page Should Contain Element     ${RESERVATION_LIST}
    ${reservation_number}    Get Element Count    ${RESERVATIONS}
    IF  ${reservation_number} > 1
        Log    There are ${reservation_number} reservations on the list.
        Page Should Contain Element    ${DELETE_BUTTON}
    ELSE IF  ${reservation_number} == 1
        Log    There is 1 reservation on the list.
        Page Should Contain Element    ${DELETE_BUTTON}
    ELSE
        Fail     There is no reservation on the list!
    END
    Capture Page Screenshot      reservation_page.png

Message Page GUI Test
    Go To Message Page 
    ${message_page_title_correct}   Check Page Title    Food Paradise - Message
    Should Be True    ${message_page_title_correct}
    Page Should Contain Element     ${MESSAGE_LIST}
    ${message_number}    Get Element Count    ${MESSAGES}
    IF  ${message_number} > 1
        Log    There are ${message_number} messages on the list.
        Page Should Contain Element    ${DELETE_BUTTON}
    ELSE IF  ${message_number} == 1
        Log    There is 1 message on the list.
        Page Should Contain Element    ${DELETE_BUTTON}
    ELSE
        Fail     There is no message on the list!
    END
    Capture Page Screenshot      message_page.png