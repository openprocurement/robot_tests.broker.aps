*** Settings ***
Library           Selenium2Library
Library           String
Library           DateTime
Library           Collections
Library           Screenshot
Resource          aps.robot
Library           aps_service.py

*** Variables ***
${lot.titleEdt}    //*[@id="divLotsItemsDynamic"]/div[@class="panel panel-default"]/a/div/h4/div/div[@class="col-md-9"]/p/b    # заголовок лота на странице редктирования
${lot.hrefEdt}    //*[@id="divLotsItemsDynamic"]/div[@class="panel panel-default"]/a    # ссылка для раскрытия блока лота на странице редактирования
${lot.btnEditEdt}    //*[@id="divLotsItemsDynamic"]/div[@class="panel panel-default"]/div/div/div/div/button[@class="btn btn-dark_blue btn-sm"]    # кнопка редактирования лота
${lot.btnDelEdt}    //*[@id="divLotsItemsDynamic"]/div[@class="panel panel-default"]/div/div/div/div/button[@class="btn btn-yellow btn-sm"]    # кнопка удаления лота

*** Keywords ***
Додати предмет
    [Arguments]    ${tender_date}    ${index}    ${lot_title}
    [Documentation]    ${ARGUMENTS[0]} == ${tender_data}
    ...    ${ARGUMENTS[1]} == ${INDEX}
    ...    ${ARGUMENTS[1]} ==${txt_title} \ \ \ (lots title)
    Wait Until Element Is Enabled    id=AddPoss
    Click Element    id=AddPoss
    Wait Until Page Contains Element    id=AddItemButton    10
    \    #
    #${lot_title}=    Get From List    ${ARGUMENTS}    2
    #${index}=    Get From List    ${ARGUMENTS}    1
    #${tender_date}=    Get From List    ${ARGUMENTS}    0
    ${items}=    Get From Dictionary    ${tender_date}    items
    ${item}=    Get From List    ${items}    ${index}
    ${editItemDetails}=    Get From Dictionary    ${item}    description
    Log To Console    id=editItemDetails \ \ ${editItemDetails}
    Input text    id=editItemDetails    ${editItemDetails}
    #Run Keyword If    '${TEST NAME}' == 'Можливість оголосити мультилотовий тендер'    Select From List By Label    lot_combo    ${lot_title}
    \    #
    ${unit}=    Get From Dictionary    ${item}    unit
    ${tov}=    Get From Dictionary    ${unit}    code
    ${editItemQuantity}=    Get From Dictionary    ${item}    quantity
    Input Text    id=editItemQuantity    ${editItemQuantity}
    Click Element    xpath=//button[@data-id="tov"]
    Input Text    id=input_tov    ${tov}
    Press Key    id=input_tov    \\\13
    #choise CPV
    ${cpv_id}=    Get From Dictionary    ${item.classification}    id
    ${dkpp_id}=    Get From Dictionary    ${item.additionalClassifications[0]}    id
    Click Element    id=button_add_cpv
    Input Text    id=cpv_search    ${cpv_id}
    sleep    2
    Press Key    id=cpv_search    \\\13
    Click Element    id=populate_cpv
    #choise DKPP
    Wait Until Element Is Enabled    id=button_add_dkpp
    Click Element    id=button_add_dkpp
    Input Text    id=dkpp_search    ${dkpp_id}
    sleep    2
    Press Key    id=dkpp_search    \\\13
    Click Element    id=populate_dkpp
    Click Element    css=div.checkbox > label
    ${countryName}=    Get From Dictionary    ${items[0].deliveryAddress}    countryName_en
    ${latitude}=    Get From Dictionary    ${items[0].deliveryLocation}    latitude
    ${locality}=    Get From Dictionary    ${items[0].deliveryAddress}    locality
    Wait Until Element Is Enabled    id=latitude
    ${text}=    Convert To String    ${latitude}
    Input Text    id=latitude    ${text}
    ${longitude}=    Get From Dictionary    ${items[0].deliveryLocation}    longitude
    ${text}=    Convert To String    ${longitude}
    Input Text    id=longitude    ${text}
    Input Text    id=elevation    111
    Click Element    id=div_combo_selectCountry
    Wait Until Element Is Visible    input_combo_selectCountry
    Input Text    input_combo_selectCountry    ${countryName}
    Press Key    input_combo_selectCountry    \\\13
    ${region}=    Get From Dictionary    ${items[0].deliveryAddress}    region
    Click Element    xpath=//button[@class="btn dropdown-toggle btn-default"][@title="Оберіть регіон"]
    sleep    2
    Wait Until Element Is Visible    id=input_combo_selectRegion
    sleep    2
    Input Text    id=input_combo_selectRegion    ${region}
    Sleep    2
    Press Key    id=input_combo_selectRegion    \\\13
    ${locality}=    Get From Dictionary    ${items[0].deliveryAddress}    locality
    Input Text    id=addr_locality    ${locality}
    \    #
    ${items_description}=    Get From Dictionary    ${items[0].additionalClassifications[0]}    description
    ${quantity}=    Get From Dictionary    ${items[0]}    quantity
    ${cpv}=    Get From Dictionary    ${items[0].classification}    description
    ${unit}=    Get From Dictionary    ${items[0].unit}    code
    #
    ${latitude}=    Get From Dictionary    ${items[0].deliveryLocation}    latitude
    ${postalCode}=    Get From Dictionary    ${items[0].deliveryAddress}    postalCode
    ${streetAddress}=    Get From Dictionary    ${items[0].deliveryAddress}    streetAddress
    #add address    -------------------------------------------
    ${deliveryDate}=    Get From Dictionary    ${items[0].deliveryDate}    endDate
    ${deliveryDate}=    aps_service.Convert Date To String    ${deliveryDate}
    Input Text    id=date_delivery_end    ${deliveryDate}
    \    #
    Click Element    id=post_code
    ${postalCode}    Get From Dictionary    ${items[0].deliveryAddress}    postalCode
    Input Text    id=post_code    ${postalCode}
    ${streetAddress}=    Get From Dictionary    ${items[0].deliveryAddress}    streetAddress
    Input Text    id=addr_street    ${streetAddress}
    \    #
    Wait Until Element Is Visible    id=AddItemButton
    Click Button    id=AddItemButton

Додати багато лотів
    [Arguments]    ${tender_data}
    ${lots}=    Get From Dictionary    ${tender_data}    lots
    ${length}=    Get Length    ${lots}
    Run Keyword If    '${length}' == 1    DeleteDefaultLot
    : FOR    ${INDEX}    IN RANGE    0    ${length}
    \    Click Element    AddLot
    \    Wait Until Element Is Visible    lot_name
    \    ${txt_title}=    Get From Dictionary    ${lots[${INDEX}]}    title
    \    Input Text    lot_name    ${txt_title}
    \    ${txt}=    Get From Dictionary    ${lots[${INDEX}]}    description
    \    Input Text    lot_description    ${txt}
    \    ${txt}=    Get From Dictionary    ${lots[${INDEX}].value}    amount
    \    ${txt}=    Convert To String    ${txt}
    \    Input Text    lot_budget    ${txt}
    \    ${txt}=    Get From Dictionary    ${lots[${INDEX}].minimalStep}    amount
    \    ${txt}=    Convert To String    ${txt}
    \    Input Text    lot_auction_min_step    ${txt}
    \    Wait Until Element Is Enabled    button_add_lot
    \    Click Button    button_add_lot
    \    Додати предмет    ${tender_data}    ${INDEX}    ${txt_title}
    \    Log To Console    item ${INDEX} added
    \    \    #

Додати багато предметів
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == tender_data
    ${items}=    Get From Dictionary    ${ARGUMENTS[0]}    items
    ${Items_length}=    Get Length    ${items}
    : FOR    ${INDEX}    IN RANGE    0    ${Items_length}
    \    Додати предмет    ${items}    ${INDEX}    0

Опублікувати тендер
    Sleep    3
    Wait Until Element Is Enabled    btnPublishTop
    Click Button    btnPublishTop
    sleep    5
    Reload Page
    Wait Until Element Is Enabled    btnView
    Click Button    btnView
    ${starttime}=    Get Current Date
    sleep    2
    ${tender_id}=    Get Text    id=titleTenderCode
    [Return]    ${tender_id}

TenderInfo
    [Arguments]    ${tender_data}
    ${title}=    Get From Dictionary    ${tender_data}    title
    ${description}=    Get From Dictionary    ${tender_data}    description
    ${budget}=    Get From Dictionary    ${tender_data.value}    amount
    ${step_rate}=    Get From Dictionary    ${tender_data.minimalStep}    amount
    \    #
    Input text    ${locator.tenderTitle}    ${title}
    Input text    ${locator.tenderDetail}    ${description}
    ${text}=    Convert To string    ${budget}
    Input text    ${locator.tenderBudget}    ${text}
    ${text}=    Convert To String    ${step_rate}
    Input text    ${locator.tenderStep}    ${text}
    Click Element    xpath=.//*[@id='mt']/div[4]/div/div/li/div[5]/div/div[3]/div/div/label/span/label

Заповнити дати тендеру
    [Arguments]    ${enquiryPeriod}    ${tenderPeriod}
    ${enquiry_start}=    Get From Dictionary    ${enquiryPeriod}    startDate
    ${enquiry_end}=    Get From Dictionary    ${enquiryPeriod}    endDate
    #
    ${tender_start}=    Get From Dictionary    ${tenderPeriod}    startDate
    ${tender_end}=    Get From Dictionary    ${tenderPeriod}    endDate
    #
    ${dt1}=    aps_service.Convert Date To String    ${enquiry_start}
    Input text    ${locator.tenderComStart}    ${dt1}
    Press Key    ${locator.tenderComStart}    \\\13
    ${dt2}=    aps_service.Convert Date To String    ${enquiry_end}
    Input text    ${locator.tenderComEnd}    ${dt2}
    Press Key    ${locator.tenderComEnd}    \\\13
    #
    ${dt3}=    aps_service.Convert Date To String    ${tender_start}
    Input text    ${locator.tenderStart}    ${dt3}
    Press Key    ${locator.tenderStart}    \\\13
    ${dt4}=    aps_service.Convert Date To String    ${tender_end}
    Input text    ${locator.tenderEnd}    ${dt4}
    Press Key    ${locator.tenderEnd}    \\\13

SearchIdViewer
    [Arguments]    ${tender_UAid}    ${username}
    sleep    80
    Go To    ${USERS.users['${username}'].homepage}view?TenderID=${tender_UAid}
    log    ${USERS.users['${username}'].homepage}view?TenderID=${tender_UAid}
    Wait Until Page Contains    ${tender_UAid}    10
    Reload Page

DeleteDefaultLot
    Wait Until Page Contains Element    ${lot.titleEdt}    50
    Click Element    ${lot.hrefEdt}
    Wait Until Element Is Visible    ${lot.btnDelEdt}
    Click Element    ${lot.btnDelEdt}
    Wait Until Element Is Visible    button_delete_lot
    Click Element    button_delete_lot
    Wait Until Element Is Visible    AddLot
