*** Settings ***
Documentation     Menu functional test
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
    Check Menu Number Before Adding New Menu
    Menu Form Submission Test
    Check Menu Number After Adding New Menu
    Modify Menu Test
    Delete Mene Test
    Logout

*** Keywords ***
Initialize Suite Variables
    Set Suite Variable    ${menu_number}   0

Check Menu Number Before Adding New Menu
    Go To Menu Page
    ${num}   Get Element Count    ${MENUS}
    Set Suite Variable    ${menu_number}    ${num} 
    Log    The number of menu before adding new one is: ${menu_number}

Menu Form Submission Test
    Go To Login Page 
    Login With Admin Credential    admin    1234
    Go To Menu Page
    Choose File     menu_image    /home/alex/public_html/test/backend/static/dish_1.png
    Input Text      menu_name    Test Menu
    Input Text      menu_description    This is a description for the test menu.
    Input Text      menu_price    100
    Click Button    //*[@id="menuForm"]/button
    Sleep   2s

Check Menu Number After Adding New Menu
    ${expected_menu_number_after_add}    Evaluate    ${menu_number} + 1
    ${menu_number_after_add}    Get Element Count    ${MENUS}
    Set Suite Variable    ${menu_number}    ${menu_number_after_add}
    Log    The number of reservations after adding new one is: ${menu_number_after_add}
    Should Be Equal As Numbers    ${menu_number_after_add}    ${expected_menu_number_after_add}
    Capture Element Screenshot     //*[@id="menu"]/div[1]    menu_add.png

Modify Menu Test
    Click Button   //*[@id="menu"]/div[1]/button[2]
    Input Text      menu_name    Modified test Menu
    Click Button    //*[@id="updateMenuForm"]/button[1]
    ${text}    Get Text    ${ALERT}
    Should Contain    ${text}    successfully
    Sleep    2s
    ${modified_menu_title}    Get Text    //*[@id="menu"]/div[1]/h2
    Should Be Equal As Strings    ${modified_menu_title}    Modified test Menu
    Capture Element Screenshot     //*[@id="menu"]/div[1]    menu_modify.png

Delete Mene Test
    Click Element    //*[@id="menu"]/div[1]/button[1]
    ${expected_menu_number_after_delete}    Evaluate    ${menu_number} - 1
    ${menu_number_after_delete}    Get Element Count    ${MENUS}
    Should Be Equal As Numbers    ${menu_number_after_delete}    ${expected_menu_number_after_delete}
    Capture Element Screenshot    //*[@id="menu"]     menu_delete.png
