*** Settings ***
Documentation     Custom GUI tests
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           DateTime  
Resource          ../common.resource   
Test Teardown     Close Browser
Default Tags      GUI

*** Test Cases ***
GUI Test
    Open Web Application
    Home Page GUI Test
    Menu Page GUI Test
    About Page GUI Test
    Contact Page GUI Test

*** Keywords ***
Home Page GUI Test
    Go To Home Page
    ${home_page_title_correct}   Check Page Title    Food Paradise - Home
    Should Be True    ${home_page_title_correct} 
    Page Should Contain Element     ${PROMOTION_LIST}
    ${promotion_number}    Get Element Count    xpath=//div[@class="promotion_container"]
    IF  ${promotion_number} > 1
        Log    There are ${promotion_number} promotions on the list.
    ELSE IF  ${promotion_number} == 1
        Log    There is 1 promotion on the list.
    ELSE
        Fail     There is no promotion on the list!
    END
    Page Should Contain Element     ${RESERVATION_FORM}
    Capture Page Screenshot      custom_home_page.png

Menu Page GUI Test
    Go To Menu Page
    ${menu_page_title_correct}   Check Page Title    Food Paradise - Menu
    Should Be True    ${menu_page_title_correct} 
    Page Should Contain Element     ${MENU_LIST}
    ${menu_number}    Get Element Count    xpath=//div[@class="menu_container"]
    IF  ${menu_number} > 1
        Log    There are ${menu_number} menus on the list.
    ELSE IF  ${menu_number} == 1
        Log    There is 1 menu on the list.
    ELSE
        Fail     There is no menu on the list!
    END
    Capture Page Screenshot      custom_menu_page.png

About Page GUI Test
    Go To About Page 
    ${about_page_title_correct}   Check Page Title    Food Paradise - About
    Should Be True    ${about_page_title_correct} 
    Page Should Contain Element     ${ABOUT_PAGE_TEXT_CONTENT}
    ${text}=    Get Text    xpath=/html/body/main/section/h1
    Should Be Equal As Strings      ${text}    About Us
    Capture Page Screenshot      about_page.png
    
Contact Page GUI Test
    Go To Contact Page 
    ${contact_page_title_correct}   Check Page Title    Food Paradise - Contact
    Should Be True    ${contact_page_title_correct} 
    Page Should Contain Element     ${CONTACT_PAGE_TEXT_CONTENT} 
    Page Should Contain Element     ${CONTACT_PAGE_MESSAGE_FORM}
    Capture Page Screenshot      contact_page.png