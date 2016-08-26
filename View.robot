*** Settings ***
Resource          aps.robot    # Отримання інформації про ...

*** Keywords ***
Відображення бюджету оголошеного тендера
    ${return_value}=    Отримати текст із поля і показати на сторінці    id=edtTenderBudget

aps.Отримати інформацію із тендера
    [Arguments]    ${username}    ${field_name}
    [Documentation]    *SingleItemstendetr* \ \ \ - ${ARGUMENTS[0]} == username \ ${ARGUMENTS[1]} == fieldname \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ *below* \ ---- \ \ \ \ (${username} | ${tender_uaid} | ${field_name})
    #Switch browser    ${username}
    #Run Keyword And Return    Отримати інформацію про ${field_name}
    Switch Browser    ${username}
    Run Keyword And Return    Отримати інформацію про ${field_name}

Отримати текст із поля і показати на сторінці
    [Arguments]    ${fieldname}    ${mod}
    sleep    1
    Log To Console    ${locator.${fieldname}}${mod}
    Wait Until Page Contains Element    ${locator.${fieldname}}${mod}    22
    ${return_value}=    Get Text    ${locator.${fieldname}}${mod}
    [Return]    ${return_value}

Отримати інформацію про title
    ${return_value}=    Отримати текст із поля і показати на сторінці    title    ${EMPTY}
    ${return_value}=    Convert To String    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про description
    ${return_value}=    Отримати текст із поля і показати на сторінці    descriptions    ${EMPTY}
    [Return]    ${return_value}

Отримати інформацію про value.amount
    ${return_value}=    Отримати текст із поля і показати на сторінці    value.amount    ${EMPTY}
    ${return_value}=    Replace String    ${return_value}    ,    .
    ${return_value}=    Convert To Number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про value.currency
    ${return_value}=    Отримати текст із поля і показати на сторінці    value.currency    ${EMPTY}
    [Return]    ${return_value}

Отримати інформацію про value.valueAddedTaxIncluded
    ${value}=    Отримати текст із поля і показати на сторінці    value.valueAddedTaxIncluded    ${EMPTY}
    ${return_value}=    Run Keyword And Return If    'без ПДВ.' == '${value}'    Set Variable    ${False}
    ${return_value}=    Run Keyword And Return If    'з ПДВ.' == '${value}'    Set Variable    ${True}
    [Return]    ${return_value}

Отримати інформацію про tenderID
    ${return_value}=    Отримати текст із поля і показати на сторінці    tenderId    ${EMPTY}
    [Return]    ${return_value}

Отримати інформацію про procuringEntity.name
    ${return_value}=    Отримати текст із поля і показати на сторінці    procuringEntity.name    ${EMPTY}
    [Return]    ${return_value}

Отримати інформацію про enquiryPeriod.startDate
    ${return_value}=    Отримати текст із поля і показати на сторінці    enquiryPeriod.startDate    ${EMPTY}
    ${return_value}=    aps_service.parse_date    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про enquiryPeriod.endDate
    ${return_value}=    Отримати текст із поля і показати на сторінці    enquiryPeriod.endDate    ${EMPTY}
    ${return_value}=    aps_service.parse_date    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про tenderPeriod.startDate
    ${return_value}=    Отримати текст із поля і показати на сторінці    tenderPeriod.startDate    ${EMPTY}
    ${return_value}=    aps_service.parse_date    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про tenderPeriod.endDate
    ${return_value}=    Отримати текст із поля і показати на сторінці    tenderPeriod.endDate    ${EMPTY}
    ${return_value}=    aps_service.parse_date    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про minimalStep.amount
    ${return_value}=    Отримати текст із поля і показати на сторінці    minimalStep.amount    ${EMPTY}
    ${return_value}=    Replace String    ${return_value}    ,    .
    ${return_value}=    Convert To Number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryDate.endDate
    WaitClickXPATH    //div[@class="col-md-8 col-sm-8 col-xs-7"]
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryDate.endDate    1
    ${return_value}=    aps_service.parse_date    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryLocation.latitude
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryLocation.latitude    1
    ${return_value}=    Convert To Number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryLocation.longitude
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryLocation.longitude    1
    ${return_value}=    Convert To Number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryAddress.countryName
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.countryName    1
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryAddress.postalCode
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.postalCode    1
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryAddress.region
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.region    1
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryAddress.locality
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.locality    1
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryAddress.streetAddress
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.streetAddress    1
    [Return]    ${return_value}

Отримати інформацію про items[0].classification.scheme
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].classification.scheme    _1
    ${return_value}=    Replace String    ${return_value}    021:2015:    CPV
    [Return]    ${return_value}

Отримати інформацію про items[0].classification.id
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].classification.id    _1
    [Return]    ${return_value}

Отримати інформацію про items[0].classification.description
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].classification.description    1
    [Return]    ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].scheme
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].additionalClassifications[0].scheme    _1
    ${return_value}=    Replace String    ${return_value}    016:2010    ДКПП
    [Return]    ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].id
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].additionalClassifications[0].id    _1
    [Return]    ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].description
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].additionalClassifications[0].description    1
    [Return]    ${return_value}

Отримати інформацію про items[0].unit.name
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].unit.name    1
    [Return]    ${return_value}

Отримати інформацію про items[0].unit.code
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].unit.code    1
    [Return]    ${return_value}

Отримати інформацію про items[0].quantity
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].quantity    1
    ${return_value}=    Convert To Integer    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про items[0].description
    [Arguments]    @{ARGUMENTS}
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].description    ${EMPTY}
    [Return]    ${return_value}

Отримати інформацію про questions[0].title
    [Arguments]    @{ARGUMENTS[0]}
    sleep    120
    Reload Page
    WaitClickXPATH    //a[@href="#questions"]
    ${return_value}=    Отримати текст із поля і показати на сторінці    questions[0].title    ${EMPTY}
    [Return]    ${return_value}

Отримати інформацію про questions[0].description
    WaitClickCSS    div.panel-title > div.row > div.col-md-9
    ${return_value}=    Отримати текст із поля і показати на сторінці    questions[0].description    ${EMPTY}
    [Return]    ${return_value}

Отримати інформацію про questions[0].date
    ${return_value}=    Отримати текст із поля і показати на сторінці    questions[0].date    ${EMPTY}
    ${return_value}=    aps_service.parse_date    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про questions[0].answer
    sleep    210
    Reload Page
    WaitClickXPATH    //a[@href="#questions"]
    WaitClickCSS    div.panel-title > div.row > div.col-md-9
    ${return_value}=    Отримати текст із поля і показати на сторінці    questions[0].answer    ${EMPTY}
    [Return]    ${return_value}

aps.Отримати інформацію із предмету
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}    ${field_name}
    Run Keyword If    '${TEST NAME}' == 'Відображення опису номенклатур тендера'    Click Element    xpath=.//*[@id='headingThree']/h4/div/div[2][contains(text(), '${item_id}')]
    ${item_value}=    Get Text    xpath=.//div[@id='headingThree']/h4/div/div[2][contains(text(), '${item_id}')]/../../../../..${locator.items.${field_name}}
    ###########################################################
    Run Keyword And Return If    '${TEST NAME}' == 'Відображення схеми класифікації номенклатур тендера'    CPV(below)    ${item_value}
    Run Keyword And Return If    '${TEST NAME}' == 'Відображення схеми додаткової класифікації номенклатур тендера'    DKPP    ${item_value}
    Run Keyword And Return If    '${TEST NAME}' == 'Відображення дати доставки номенклатур тендера'    deliveryDate    ${item_value}
    Run Keyword And Return If    '${TEST NAME}' == 'Відображення кількості номенклатур тендера'    itemquantity    ${item_value}
    [Return]    ${item_value}
