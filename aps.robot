*** Settings ***
Library           Selenium2Library
Library           String
Library           DateTime
Library           Collections
Library           Screenshot
Resource          APStender_subkeywords.robot
Resource          ../keywords.robot

*** Variables ***
${locator.tenderID}    xpath=//span[@id='titleTenderCode']
${locatorDeals}    id=tab3
${locatot.cabinetEnter}    id=login_ribbon
${locator.emailField}    xpath=//input[@name='LoginBox']
${locator.passwordField}    xpath=//input[@name='LoginPasswordBox']
${locator.loginButton}    id=ButtonLogin
${locator.buttonTenderAdd}    xpath=//a[@href="tenderadd"]
${locator.tenderTitle}    id=edtTenderTitle
${locator.tenderDetail}    id=edtTenderDetail
${locator.tenderBudget}    id=edtTenderBudget
${locator.tenderStep}    id=edtMinStep
${locator.tenderComStart}    id=date_enquiry_start
${locator.tenderComEnd}    id=date_enquiry_end
${locator.tenderStart}    id=date_tender_start
${locator.tenderEnd}    id=date_tender_end
${locator.tenderAdd}    id=btnAdd
${locator.topSearch}    id=topsearch
${locator.searchButton}    id=btnSearch
${locator.findTender}    xpath=//p[@class='cut_title']
${locator.informationTable}    xpath=//li[@id='tab1']
${locator.title}    id=edtTenderTitle
${locator.descriptions}    id=edtTenderDetail
${locator.value.amount}    id=edtTenderBudget
${locator.tenderId}    id=titleTenderGid
${locator.procuringEntity.name}    id=author_legal_name
${locator.enquiryPeriod.startDate}    id=date_enquiry_start
${locator.enquiryPeriod.endDate}    id=date_enquiry_end
${locator.tenderPeriod.startDate}    id=date_tender_start
${locator.tenderPeriod.endDate}    id=date_tender_end
${locator.value.valueAddedTaxIncluded}    xpath=//span[@id="lblPDV"]/b
${locator.minimalStep.amount}    id=edtMinStep
${locator.items[0].deliveryLocation.latitude}    id=qdelivlatitude
${locator.items[0].deliveryLocation.longitude}    id=qdelivlongitude
${locator.items[0].deliveryAddress.postalCode}    id=qdelivaddrpost_code
${locator.items[0].deliveryAddress.countryName}    id=qdelivaddrcountry
${locator.items[0].deliveryAddress.locality}    id=qdeliv_addr_locality
${locator.items[0].deliveryAddress.streetAddress}    id=qdeliv_addrstreet
${locator.items[0].classification.scheme}    id=scheme2015
${locator.items[0].classification.id}    id=cpv_code
${locator.items[0].classification.description}    id=cpv_name
${locator.items[0].additionalClassifications[0].scheme}    id=scheme2010
${locator.items[0].additionalClassifications[0].id}    id=qdkpp_code
${locator.items[0].additionalClassifications[0].description}    id=qdkpp_name
${locator.items[0].description}    xpath=//div[@class="col-md-8 col-sm-8 col-xs-7"]
${locator.questions[0].title}    id=questionTitlespan1
${locator.questions[0].description}    id=label_question_description
${locator.questions[0].date}    xpath=//div[@class="col-md-2 text-right"][@style="font-size: 11px; color: black;"]
${locator.items[0].deliveryDate.endDate}    id=ddto
${locator.value.currency}    id=lblTenderCurrency2
${locator.items[0].deliveryAddress.region}    id=qdeliv_addr_region
${locator.items[0].unit.code}    id=measure_prozorro_code
${locator.items[0].unit.name}    id=measure_name
${locator.items[0].quantity}    id=quantity
${locator.questions[0].answer}    id=answer

*** Keywords ***
Підготувати клієнт для користувача
    [Arguments]    @{ARGUMENTS}
    [Documentation]    [Documentation] \ Відкрити брaузер, створити обєкт api wrapper, тощо
    ...    ... \ \ \ \ \ ${ARGUMENTS[0]} == \ username
    Open Browser    ${USERS.users['${ARGUMENTS[0]}'].homepage}    ${USERS.users['${ARGUMENTS[0]}'].browser}    alias=${ARGUMENTS[0]}
    Set Window Size    @{USERS.users['${ARGUMENTS[0]}'].size}
    Set Window Position    @{USERS.users['${ARGUMENTS[0]}'].position}
    Run Keyword If    '${ARGUMENTS[0]}'!= 'aps_Viewer'    Login    @{ARGUMENTS}

Створити тендер
    [Arguments]    @{ARGUMENTS}
    [Documentation]    [Documentation]
    ...    ... \ \ \ \ \ ${ARGUMENTS[0]} == \ username
    ...    ... \ \ \ \ \ ${ARGUMENTS[1]} == \ tender_data
    Switch Browser    ${ARGUMENTS[0]}
    Return From Keyword If    '${ARGUMENTS[0]}' != 'aps_Owner'
    ${tender_data}=    Get From Dictionary    ${ARGUMENTS[1]}    data
    ${procuringEntity}=    Get From Dictionary    ${tender_data}    procuringEntity
    Set To Dictionary    ${procuringEntity}    name    QA
    ${tender_data}=    Адаптувати дані для оголошення тендера    ${ARGUMENTS[0]}    ${tender_data}
    \    #
    Click Element    ${locator.buttonTenderAdd}
    TenderInfo    ${tender_data}
    \    #
    Run Keyword If    '${mode}'=='multiLot'    Click Element    css=label.btn.btn-info
    Capture Page Screenshot
    Заповнити дати тендеру    ${tender_data.enquiryPeriod}    ${tender_data.tenderPeriod}
    \    #
    sleep    3
    Click Button    ${locator.tenderAdd}
    sleep    3
    \    #
    Run Keyword If    '${mode}'=='single'    Додати багато предметів    ${tender_data}
    Run Keyword If    '${mode}'=='multiLot'    Додати багато лотів    ${tender_data}
    \    #
    ${tender_UAid}=    Опублікувати тендер
    Reload Page
    [Return]    ${tender_UAid}

Завантажити документ
    [Arguments]    @{ARGUMENTS}
    Log To Console    ${ARGUMENTS[1]}
    Click Button    ButtonTenderEdit
    Click Element    addFile
    Select From List By Label    category_of    Документи закупівлі
    Select From List By Label    file_of    тендеру
    InputText    TenderFileUpload    ${ARGUMENTS[1]}
    Click Link    lnkDownload
    Wait Until Element Is Enabled    addFile
    Click Element    id=btnPublishTop

Завантажити документ в лот
    [Arguments]    ${filepath}    ${TENDER_UAID}    ${lot_id}
    Log To Console    ${filepath}
    Click Button    ButtonTenderEdit
    Click Element    addFile
    Select From List By Label    category_of    Документи закупівлі
    Select From List By Label    file_of    лоту
    Wait Until Element Is Enabled    FileComboSelection2
    Log To Console    ${lot_id}
    Select From List By Label    FileComboSelection2    ${lot_id}
    InputText    TenderFileUpload    ${filepath}
    Click Link    lnkDownload
    Wait Until Element Is Enabled    addFile

Пошук тендера по ідентифікатору
    [Arguments]    ${username}    ${tender_UAid}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    Run Keyword And Return If    '${username}' == 'aps_Viewer'    SearchIdViewer    ${tender_UAid}    ${username}
    Sleep    3
    Go To    ${USERS.users['${username}'].homepage}
    sleep    3
    Input text    id=topsearch    ${tender_UAid}
    Click Element    id=btnSearch
    Wait Until Page Contains    ${tender_UAid}    10
    Click Element    xpath=//p[@class='cut_title']
    sleep    5

Подати цінову пропозицію
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    ...    ${ARGUMENTS[2]} == ${test_bid_data}
    Sleep    300
    Switch Browser    ${ARGUMENTS[0]}
    Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Reload Page
    Click Element    ${locatorDeals}
    ${amount}=    Get From Dictionary    ${ARGUMENTS[2].data.value}    amount
    Input Text    id=editBid    ${amount}
    Click Element    id=addBidButton
    sleep    2
    Reload Page
    ${resp}=    Get Value    id=my_bid_id
    [Return]    ${resp}

Скасувати цінову пропозицію
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == none
    ...    ${ARGUMENTS[2]} == tenderId
    Switch Browser    ${ARGUMENTS[0]}
    Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Wait Until Page Contains    Прийом пропозицій    10
    Click Element    id=tab3
    Wait Until Element Is Enabled    id=btnDeleteBid
    Click Element    id=btnDeleteBid
    Wait Until Page Contains Element    id=addBidButton

Login
    [Arguments]    @{ARGUMENTS}
    Wait Until Element Is Visible    ${locatot.cabinetEnter}    10
    Click Element    ${locatot.cabinetEnter}
    Wait Until Element Is Visible    ${locator.emailField}    10
    Input Text    ${locator.emailField}    ${USERS.users['${ARGUMENTS[0]}'].login}
    Input Text    ${locator.passwordField}    ${USERS.users['${ARGUMENTS[0]}'].password}
    Click Element    ${locator.loginButton}

Оновити сторінку з тендером
    [Arguments]    @{ARGUMENTS}
    [Documentation]    [Documentation]
    ...    ... \ \ \ \ \ ${ARGUMENTS[0]} = \ username
    ...    ... \ \ \ \ \ ${ARGUMENTS[1]} = \ ${TENDER_UAID}
    Switch Browser    ${ARGUMENTS[0]}
    Reload Page

Відображення бюджету оголошеного тендера
    ${return_value}=    Отримати текст із поля і показати на сторінці    id=edtTenderBudget

Отримати інформацію із тендера
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == fieldname
    Switch browser    ${ARGUMENTS[0]}
    Run Keyword And Return    Отримати інформацію про ${ARGUMENTS[1]}

Отримати текст із поля і показати на сторінці
    [Arguments]    ${fieldname}
    sleep    3
    Wait Until Page Contains Element    ${locator.${fieldname}}    22
    Sleep    2
    ${return_value}=    Get Text    ${locator.${fieldname}}
    [Return]    ${return_value}

Отримати інформацію про title
    ${return_value}=    Отримати текст із поля і показати на сторінці    title
    ${return_value}=    Convert To String    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про description
    ${return_value}=    Отримати текст із поля і показати на сторінці    descriptions
    [Return]    ${return_value}

Отримати інформацію про value.amount
    ${return_value}=    Отримати текст із поля і показати на сторінці    value.amount
    ${return_value}=    Replace String    ${return_value}    ,    .
    ${return_value}=    Convert To Number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про value.currency
    ${return_value}=    Отримати текст із поля і показати на сторінці    value.currency
    [Return]    ${return_value}

Отримати інформацію про value.valueAddedTaxIncluded
    ${return_value}=    Отримати текст із поля і показати на сторінці    value.valueAddedTaxIncluded
    ${return_value}=    Convert To Boolean    без ПДВ.
    [Return]    ${return_value}

Отримати інформацію про tenderID
    ${return_value}=    Отримати текст із поля і показати на сторінці    tenderId
    [Return]    ${return_value}

Отримати інформацію про procuringEntity.name
    ${return_value}=    Отримати текст із поля і показати на сторінці    procuringEntity.name
    [Return]    ${return_value}

Отримати інформацію про enquiryPeriod.startDate
    ${return_value}=    Отримати текст із поля і показати на сторінці    enquiryPeriod.startDate
    [Return]    ${return_value}

Отримати інформацію про enquiryPeriod.endDate
    ${return_value}=    Отримати текст із поля і показати на сторінці    enquiryPeriod.endDate
    [Return]    ${return_value}

Отримати інформацію про tenderPeriod.startDate
    ${return_value}=    Отримати текст із поля і показати на сторінці    tenderPeriod.startDate
    [Return]    ${return_value}

Отримати інформацію про tenderPeriod.endDate
    ${return_value}=    Отримати текст із поля і показати на сторінці    tenderPeriod.endDate
    [Return]    ${return_value}

Отримати інформацію про minimalStep.amount
    ${return_value}=    Отримати текст із поля і показати на сторінці    minimalStep.amount
    ${return_value}=    Replace String    ${return_value}    ,    .
    ${return_value}=    Convert To Number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryDate.endDate
    Click Element    xpath=//div[@class="col-md-8 col-sm-8 col-xs-7"]
    Capture Page Screenshot
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryDate.endDate
    ${return_value}=    Convert Date To String    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryLocation.latitude
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryLocation.latitude
    ${return_value}=    Replace String    ${return_value}    ,    .
    ${return_value}=    Convert To Number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryLocation.longitude
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryLocation.longitude
    ${return_value}=    Replace String    ${return_value}    ,    .
    ${return_value}=    Convert To Number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryAddress.countryName
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.countryName
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryAddress.postalCode
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.postalCode
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryAddress.region
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.region
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryAddress.locality
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.locality
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryAddress.streetAddress
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.streetAddress
    [Return]    ${return_value}

Отримати інформацію про items[0].classification.scheme
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].classification.scheme
    ${return_value}=    Remove String    ${return_value}    :
    [Return]    ${return_value}

Отримати інформацію про items[0].classification.id
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].classification.id
    [Return]    ${return_value}

Отримати інформацію про items[0].classification.description
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].classification.description
    [Return]    ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].scheme
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].additionalClassifications[0].scheme
    ${return_value}=    Remove String    ${return_value}    :
    [Return]    ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].id
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].additionalClassifications[0].id
    [Return]    ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].description
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].additionalClassifications[0].description
    [Return]    ${return_value}

Отримати інформацію про items[0].unit.name
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].unit.name
    ${return_value}=    Remove String    ${return_value}    и
    [Return]    ${return_value}

Отримати інформацію про items[0].unit.code
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].unit.code
    [Return]    ${return_value}

Отримати інформацію про items[0].quantity
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].quantity
    ${return_value}=    Convert To Integer    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про items[0].description
    [Arguments]    @{ARGUMENTS}
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].description
    [Return]    ${return_value}

Задати питання
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderUaId
    ...    ${ARGUMENTS[2]} == questionId
    ${title}=    Get From Dictionary    ${ARGUMENTS[2].data}    title
    ${description}=    Get From Dictionary    ${ARGUMENTS[2].data}    description
    Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
    Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    sleep    3
    Wait Until Page Contains Element    xpath=//a[@href="#questions"]    20
    Click Element    xpath=//a[@href="#questions"]
    Wait Until Page Contains Element    id=addQuestButton    20
    Click Button    id=addQuestButton
    Input text    id=editQuestionTitle    ${title}
    Input text    id=editQuestionDetails    ${description}
    sleep    2
    Click Element    id=AddQuestion_Button
    Wait Until Page Contains    ${title}    30
    Capture Page Screenshot

Отримати інформацію про questions[0].title
    [Arguments]    @{ARGUMENTS[0]}
    Click Element    xpath=//a[@href="#questions"]
    sleep    2
    ${return_value}=    Отримати текст із поля і показати на сторінці    questions[0].title
    ${return_value}=    Get Text    id=questionTitlespan1
    [Return]    ${return_value}

Отримати інформацію про questions[0].description
    Click Element    css=div.panel-title > div.row > div.col-md-9
    Capture Page Screenshot
    sleep    2
    ${return_value}=    Отримати текст із поля і показати на сторінці    questions[0].description
    [Return]    ${return_value}

Отримати інформацію про questions[0].date
    ${return_value}=    Отримати текст із поля і показати на сторінці    questions[0].date
    [Return]    ${return_value}

Відповісти на питання
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} = username
    ...    ${ARGUMENTS[1]} = tenderUaId
    ...    ${ARGUMENTS[2]} = 0
    ...    ${ARGUMENTS[3]} = answer_data
    ${answer}=    Get From Dictionary    ${ARGUMENTS[3].data}    answer
    Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
    Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Wait Until Page Contains Element    xpath=//a[@href="#questions"]    20
    Click Element    xpath=//a[@href="#questions"]
    Sleep    2
    Click Element    css=div.panel-title > div.row > div.col-md-9
    Wait Until Page Contains Element    id=answerQuestion    20
    Click Element    id=answerQuestion
    Input text    id=editAnswerDetails    ${answer}
    Click Element    id=AddQuestionButton
    Sleep    2
    Reload Page
    Wait Until Page Contains    ${answer}    30
    Capture Page Screenshot

Відображення відповіді на запитання
    [Arguments]    @{ARGUMENTS}
    Reload Page
    Click Element    xpath=//a[@href="#questions"]
    Click Element    css=div.panel-title > div.row > div.col-md-9
    Click Element    xpath=//div[@class="col-md-5"]/p
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].description
    [Return]    ${return_value}

Змінити цінову пропозицію
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    ...    ${ARGUMENTS[2]} == amount
    ...    ${ARGUMENTS[3]} == amount.value
    sleep    50
    Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
    Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Click Element    id=tab3
    Click Element    id=btnDeleteBid
    Clear Element Text    id=editBid
    Input Text    id=editBid    ${ARGUMENTS[3]}
    sleep    3
    Click Element    id=addBidButton
    Wait Until Page Contains    Ви подали пропозицію. Очікуйте посилання на аукціон.

Внести зміни в тендер
    [Arguments]    @{ARGUMENTS}
    Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
    Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Sleep    2
    Click Element    id=ButtonTenderEdit
    Sleep    2
    Input text    id=edtTenderTitle    ${ARGUMENTS[2]}
    Sleep    2
    Click Element    id=btnPublishTop
    Wait Until Page Contains Element    ${ARGUMENTS[2]}    15
    Click Element    id=btnView
    Capture Page Screenshot

Отримати інформацію про questions[0].answer
    sleep    10
    Reload Page
    Click Element    id=tab2
    Click Element    css=div.panel-title > div.row > div.col-md-9
    ${return_value}=    Отримати текст із поля і показати на сторінці    questions[0].answer
    [Return]    ${return_value}

Завантажити документ в ставку
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[1]} == file
    ...    ${ARGUMENTS[2]} == tenderId
    Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
    Click Element    ${locatorDeals}
    Sleep    2
    Choose File    id=BidFileUpload    ${ARGUMENTS[1]}
    sleep    2
    Click Element    xpath=//*[@id='lnkDownload'][@class="btn btn-success"]

Змінити документ в ставці
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == file
    ...    ${ARGUMENTS[2]} == tenderId
    Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
    Sleep    2
    Click Element    id=deleteBidFileButton
    Click Element    id=Button6
    sleep    2
    Click Element    id=BidFileUpload
    Sleep    2
    Choose File    id=BidFileUpload    ${ARGUMENTS[1]}
    sleep    5
    Reload Page
    Click Element    xpath=.//*[@id='lnkDownload'][@class="btn btn-success"]

Отримати посилання на аукціон для глядача
    [Arguments]    @{ARGUMENTS}
    Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
    Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Wait Until Page Contains    Аукціон    5
    Capture Page Screenshot
    ${url} =    Get Element Attribute    xpath=//a[@id="a_auction_url"]@href
    Log To Console    ${url}
    [Return]    ${url}

Отримати посилання на аукціон для учасника
    [Arguments]    @{ARGUMENTS}
    Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
    Click Element    xpath=//div[@id='bs-example-navbar-collapse-1']/div/div/a/img[2]
    Sleep    2
    Clear Element Text    id=topsearch
    Click Element    id=inprogress
    Input Text    id=topsearch    ${ARGUMENTS[1]}
    Wait Until Page Contains    Аукціон    5
    Click Element    id=btnSearch
    Click Element    xpath=//p[@class='cut_title']
    Capture Page Screenshot
    ${url}=    Get Element Attribute    xpath=//a[@id="labelAuction2"]@href
    [Return]    ${url}
