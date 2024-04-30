*** Settings ***
Documentation     Reusable variables and keywords.
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           DateTime     

*** Variables ***
# ${URL}              http://10.120.32.84
${URL}              http://localhost:8000/frontend/index.html
${BROWSER}          headlessFirefox
${TIMEOUT}          20s
${NAVAGATION_BAR}      //*[@id="nav"]
${ALERT}             //*[@id="messageText"]
${CANCEL_BUTTON}     //button[contains(text(),'Cancel')]
${DELETE_BUTTON}     //button[contains(text(),'Delete')]
${HOME_TAG}         //*[@id="nav"]/li/a[contains(text(),'Home')]
${MENU_TAG}         //*[@id="nav"]/li/a[contains(text(),'Menu')]
${ABOUT_TAG}         //*[@id="nav"]/li/a[contains(text(),'About')]
${CONTACT_TAG}         //*[@id="nav"]/li/a[contains(text(),'Contact')]
${LOGOUT_TAG}         //*[@id="nav"]/li/a[contains(text(),'Logout')]
${LOGIN_TAG}         //*[@id="nav"]/li/a[contains(text(),'Login')]
${RESERVATION_TAG}         //*[@id="nav"]/li/a[contains(text(),'Reservations')]
${MESSAGE_TAG}      //*[@id="nav"]/li/a[contains(text(),'Message')]
${PROMOTION_LIST}     //*[@id="promotions"]
${RESERVATION_FORM}    //*[@id="reservationForm"]
${MENU_LIST}    //*[@id="menu"]
${ABOUT_PAGE_TEXT_CONTENT}     //*[@class="text_container"]
${CONTACT_PAGE_TEXT_CONTENT}       //*[@class="text_container"]
${CONTACT_PAGE_MESSAGE_FORM}       //*[@id="messageForm"]
${LOGIN_PAGE_FORM}     //*[@id="loginForm"]
${LOGIN_PAGE_BUTTON}    //*[@id="loginForm"]/button
${ADD_PROMOTION_BUTTON}    //*[@id="addPromotionButton"]
${DELETE_PROMOTION_BUTTON}    //*[@id="promotions"]/div/button[contains(text(),'Delete')]
${MODIFY_PROMOTION_BUTTON}    //*[@id="promotions"]/div/button[contains(text(),'Modify')]
${ADD_NEW_PROMOTION_FORM}     //*[@id="addPromotionForm"]
${MODIFY_PROMOTION_FORM}     //*[@id="updatePromotionForm"]
${ADD_NEW_MENU_FORM}    //*[@id="menuForm"]
${DELETE_MENU_BUTTON}    //*[@id="menu"]/div/button[contains(text(),'Delete')]
${MODIFY_MENU_BUTTON}    //*[@id="menu"]/div/button[contains(text(),'Modify')]
${MENUS}    //div[@class="menu_container"]
${MODIFY_MENU_FORM}    //*[@id="updateMenuForm"]
${RESERVATION_LIST}      //*[@id="reservation_list"]
${RESERVATIONS}      //*[@id="reservation_list"]/div[@class="reservation_container"]
${MESSAGE_LIST}      //*[@id="message_list"]
${MESSAGES}       //*[@id="message_list"]/div[@class="message_container"]
${PROMOTIONS}     //div[@class="promotion_container"]

*** Keywords ***
Open Web Application
    [Documentation]    This keyword will open the website specified by variable ${URL}.
    [Arguments]    ${url}=${URL}    ${browser}=${BROWSER}
    Open Browser    ${url}    ${browser}
    Set Selenium Speed    0.2
    Wait Until Page Contains Element     ${NAVAGATION_BAR}

Check Page Title
    [Documentation]    This keyword check if the page title is as expacted.
    [Arguments]    ${expacted_title}
    ${title}=    Get Title
    ${page_title_correct}    Run Keyword And Return Status     Should Be Equal As Strings    ${title}    ${expacted_title}
    RETURN    ${page_title_correct} 

Go To Home Page
    [Documentation]    This keyword will click Home tag
    Click Element    ${HOME_TAG}
    Wait Until Page Contains Element     ${PROMOTION_LIST}     timeout=${TIMEOUT} 
    Wait Until Page Contains Element     ${RESERVATION_FORM}    timeout=${TIMEOUT} 

Go To Menu Page
    [Documentation]    This keyword will click Menu tag
    Click Element    ${MENU_TAG} 
    Wait Until Page Contains Element     ${MENU_LIST}    timeout=${TIMEOUT} 

Go To Modify Menu Page 
    [Documentation]    This keyword will click Modify Menu button
    [Arguments]    ${menu_number}
    Click Button    xpath=//*[@id="menu"]/div[${menu_number}]/button[contains(text(),'Modify')]
    Wait Until Page Contains Element     ${MODIFY_MENU_FORM}   timeout=${TIMEOUT}  

Go To About Page 
    [Documentation]    This keyword will click About tag
    Click Element    ${ABOUT_TAG}
    Wait Until Page Contains Element     ${ABOUT_PAGE_TEXT_CONTENT}    timeout=${TIMEOUT} 

Go To Contact Page 
    [Documentation]    This keyword will click Contact tag
    Click Element    ${CONTACT_TAG}
    Wait Until Page Contains Element     ${CONTACT_PAGE_TEXT_CONTENT}    timeout=${TIMEOUT}  
    Wait Until Page Contains Element     ${CONTACT_PAGE_MESSAGE_FORM}    timeout=${TIMEOUT}  

Go To Login Page 
    [Documentation]    This keyword will click Login tag
    Click Element    ${LOGIN_TAG}
    Wait Until Page Contains Element     ${LOGIN_PAGE_FORM}    timeout=${TIMEOUT} 

Go To Add New Promotion Page 
    [Documentation]    This keyword will click Add new promotion button
    Click Button    ${ADD_PROMOTION_BUTTON}
    Wait Until Page Contains Element     ${ADD_NEW_PROMOTION_FORM}    timeout=${TIMEOUT}  

Go To Modify Promotion Page 
    [Documentation]    This keyword will click Add new promotion button
    [Arguments]    ${promotion_number}
    Click Button    xpath=//*[@id="promotions"]/div[${promotion_number}]/button[contains(text(),'Modify')]
    Wait Until Page Contains Element     ${MODIFY_PROMOTION_FORM}   timeout=${TIMEOUT}  

Go To Reservation Page 
    [Documentation]    This keyword will click Reservation tag
    Click Element    ${RESERVATION_TAG}
    Wait Until Page Contains Element     ${RESERVATION_LIST}    timeout=${TIMEOUT} 

Go To Message Page 
    [Documentation]    This keyword will click Message tag
    Click Element    ${MESSAGE_TAG}
    Wait Until Page Contains Element     ${MESSAGE_LIST}    timeout=${TIMEOUT}  

Login With Admin Credential
    [Documentation]    This keyword will login  with admin user credentials
    [Arguments]    ${username}    ${password}
    Input Text     username    ${username}
    Input Text     password    ${password}
    Click Button   ${LOGIN_PAGE_BUTTON}
    ${text}    Get Text    ${ALERT}
    Should Be Equal As Strings    ${text}    Login successfully!
    Sleep      2s

Logout
    [Documentation]    This keyword will click logout tag
    Click Element    ${LOGOUT_TAG}
    Sleep      2s
    Wait Until Element Is Not Visible    ${LOGOUT_TAG}


