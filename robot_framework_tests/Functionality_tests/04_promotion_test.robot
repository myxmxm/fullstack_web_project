*** Settings ***
Documentation     Promotion functional test
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
    Check Promotion Number Before Adding New Promotion
    Promotion Form Submission Test
    Check Promotion Number After Adding New Promotion
    Modify Promotion Test
    Delete Promotion Test
    Logout

*** Keywords ***
Initialize Suite Variables
    Set Suite Variable    ${promotion_number}   0

Check Promotion Number Before Adding New Promotion
    Go To Home Page
    ${num}   Get Element Count    ${PROMOTIONS} 
    Set Suite Variable    ${promotion_number}    ${num} 
    Log    The number of promotion before adding new one is: ${promotion_number}

Promotion Form Submission Test
    Go To Login Page 
    Login With Admin Credential    admin    1234
    Go To Home Page
    Click Button    ${ADD_PROMOTION_BUTTON}
    Input Text    promotion_name     Test Promotion
    Input Text    promotion_description   This is a description for testing promotion.
    Click Button    //*[@id="addPromotionForm"]/button[1]
    Sleep  2s

Check Promotion Number After Adding New Promotion
    ${expected_promotion_number_after_add}    Evaluate    ${promotion_number} + 1
    ${promotion_number_after_add}    Get Element Count    ${PROMOTIONS}
    Set Suite Variable    ${promotion_number}    ${promotion_number_after_add}
    Log    The number of promotions after adding new one is: ${promotion_number_after_add}
    Should Be Equal As Numbers    ${promotion_number_after_add}    ${expected_promotion_number_after_add}
    Capture Page Screenshot    promotion_add.png

Modify Promotion Test
    Click Button    //*[@id="promotions"]/div[1]/button[2]
    Input Text    promotion_name     Modified test Promotion
    Click Button    //*[@id="updatePromotionForm"]/button[1]
    ${text}    Get Text    ${ALERT}
    Should Contain    ${text}    successfully
    Sleep    2s
    ${modified_promotion_title}    Get Text    //*[@id="promotions"]/div[1]/h3
    Should Be Equal As Strings    ${modified_promotion_title}    Modified test Promotion
    Capture Page Screenshot    promotion_modify.png

Delete Promotion Test
    Click Button    //*[@id="promotions"]/div[1]/button[1]
    ${expected_promotion_number_after_delete}    Evaluate    ${promotion_number} - 1
    ${promotion_number_after_delete}    Get Element Count    ${PROMOTIONS}
    Should Be Equal As Numbers    ${promotion_number_after_delete}    ${expected_promotion_number_after_delete}
    Capture Page Screenshot     promotion_delete.png
