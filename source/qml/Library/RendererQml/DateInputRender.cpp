#include "DateInputRender.h"
#include "Formatter.h"
#include "ImageDataURI.h"
#include "Utils.h"

DateInputElement::DateInputElement(std::shared_ptr<AdaptiveCards::DateInput> input, std::shared_ptr<RendererQml::AdaptiveRenderContext> context)
    :mDateInput(input),
    mContext(context),
    mDateConfig(context->GetRenderConfig()->getInputDateConfig())
{  
}

std::shared_ptr<RendererQml::QmlTag> DateInputElement::getQmlTag()
{
    return mDateInputColElement;
}

void DateInputElement::initialize()
{
    mDateInputColElement = std::make_shared<RendererQml::QmlTag>("Column");
    mDateInputColElement->Property("id", RendererQml::Formatter() << mDateInput->GetId() << "_column");
    mDateInputColElement->Property("spacing", RendererQml::Formatter() << RendererQml::Utils::GetSpacing(mContext->GetConfig()->GetSpacing(), AdaptiveCards::Spacing::Small));
    mDateInputColElement->Property("width", "parent.width");

    addInputLabel(mDateInput->GetIsRequired());
    renderDateElement();
    addErrorMessage();
}

void DateInputElement::renderDateElement()
{
    const std::string origionalElementId = mDateInput->GetId();
    mDateInput->SetId(mContext->ConvertToValidId(mDateInput->GetId()));

    const std::string calendarBoxId = RendererQml::Formatter() << mDateInput->GetId() << "_calendarBox";

    auto uiDateInputField = getDateInputField();
    auto uiDateInputWrapper = getDateInputWrapper();
    auto uiDateInputCombobox = getDateInputComboBox(uiDateInputField, uiDateInputWrapper, calendarBoxId);

    auto uiDateInputRow = std::make_shared<RendererQml::QmlTag>("RowLayout");

    uiDateInputRow->Property("width", "parent.width");
    uiDateInputRow->Property("height", "parent.height");
    uiDateInputRow->Property("spacing", "0");

    auto dateIcon = getDateIconButton(uiDateInputField->GetId(), calendarBoxId);
    auto clearIcon = getClearIconButton(uiDateInputField->GetId());

    mContext->addToInputElementList(origionalElementId, (uiDateInputField->GetId() + ".selectedDate"));

    uiDateInputRow->AddChild(dateIcon);
    uiDateInputRow->AddChild(uiDateInputCombobox);
    uiDateInputRow->AddChild(clearIcon);

    uiDateInputWrapper->AddChild(uiDateInputRow);
    uiDateInputCombobox->Property("Accessible.ignored", "true");

    mDateInputColElement->AddChild(uiDateInputWrapper);
}

std::shared_ptr<RendererQml::QmlTag> DateInputElement::getDateInputField()
{
    auto uiTextFieldId = mDateInput->GetId();
    auto uiTextField = std::make_shared<RendererQml::QmlTag>("TextField");

    uiTextField->Property("id", uiTextFieldId);
    uiTextField->Property("width", "parent.width");
    uiTextField->Property("height", "parent.height");
    uiTextField->Property("font.family", mContext->GetConfig()->GetFontFamily(AdaptiveCards::FontType::Default), true);
    uiTextField->Property("font.pixelSize", RendererQml::Formatter() << mDateConfig.pixelSize);
    uiTextField->Property("selectByMouse", "true");
    uiTextField->Property("selectedTextColor", "'white'");
    uiTextField->Property("color", mContext->GetHexColor(mDateConfig.textColor));
    uiTextField->Property("property string selectedDate", mDateInput->GetValue(), true);
    uiTextField->AddFunctions(RendererQml::Formatter() << "signal " << "textChanged" << uiTextField->GetId() << "(var dateText)");

    uiTextField->Property("leftPadding", RendererQml::Formatter() << mDateConfig.textHorizontalPadding);
    uiTextField->Property("rightPadding", RendererQml::Formatter() << mDateConfig.textHorizontalPadding);
    uiTextField->Property("topPadding", RendererQml::Formatter() << mDateConfig.textVerticalPadding);
    uiTextField->Property("bottomPadding", RendererQml::Formatter() << mDateConfig.textVerticalPadding);

    uiTextField->Property("Accessible.name", "", true);
    uiTextField->Property("Accessible.role", "Accessible.EditableText");
    uiTextField->Property("Keys.onReleased", "{if (event.key === Qt.Key_Escape){event.accepted = true}}");

    auto backgroundTag = std::make_shared<RendererQml::QmlTag>("Rectangle");
    backgroundTag->Property("color", "'transparent'");
    uiTextField->Property("background", backgroundTag->ToString());

    if (!mDateInput->GetMin().empty() && RendererQml::Utils::isValidDate(mDateInput->GetMin()))
    {
        mMinimumDate = RendererQml::Utils::GetDate(mDateInput->GetMin());
    }

    if (!mDateInput->GetMax().empty() && RendererQml::Utils::isValidDate(mDateInput->GetMax()))
    {
        mMaximumDate = RendererQml::Utils::GetDate(mDateInput->GetMax());
    }

    auto EnumDateFormat = RendererQml::Utils::GetSystemDateFormat();

    const auto dateSeparator = "\\/";
    const auto day_Regex = "([-0123]-|0\\d|[12]\\d|3[01])";
    const auto month_Regex = "(---|[JFMASOND]--|Ja-|Jan|Fe-|Feb|Ma-|Mar|Ap-|Apr|May|Ju-|Jun|Jul|Au-|Aug|Se-|Sep|Oc-|Oct|No-|Nov|De-|Dec)";
    const auto year_Regex = "(-{4}|\\d-{3}|\\d{2}-{2}|\\d{3}-|\\d{4})";

    //Default date format: MMM-dd-yyyy
    auto month_Text = "getText(0,3)";
    auto day_Text = "getText(4,6)";
    auto year_Text = "getText(7,11)";
    std::string DateRegex = RendererQml::Formatter() << "/^" << month_Regex << dateSeparator << day_Regex << dateSeparator << year_Regex << "$/";
    mDateFormat = RendererQml::Formatter() << "MMM" << dateSeparator << "dd" << dateSeparator << "yyyy";
    std::string inputMask = RendererQml::Formatter() << ">x<xx" << dateSeparator << "xx" << dateSeparator << "xxxx;-";

    switch (EnumDateFormat)
    {
    case RendererQml::DateFormat::ddmmyy:
    {
        mDateFormat = RendererQml::Formatter() << "dd" << dateSeparator << "MMM" << dateSeparator << "yyyy";
        inputMask = RendererQml::Formatter() << "xx" << dateSeparator << ">x<xx" << dateSeparator << "xxxx;-";
        DateRegex = RendererQml::Formatter() << "/^" << day_Regex << dateSeparator << month_Regex << dateSeparator << year_Regex << "$/";

        day_Text = "getText(0,2)";
        month_Text = "getText(3,6)";
        year_Text = "getText(7,11)";
        break;
    }
    case RendererQml::DateFormat::yymmdd:
    {
        mDateFormat = RendererQml::Formatter() << "yyyy" << dateSeparator << "MMM" << dateSeparator << "dd";
        inputMask = RendererQml::Formatter() << "xxxx" << dateSeparator << ">x<xx" << dateSeparator << "xx;-";
        DateRegex = RendererQml::Formatter() << "/^" << year_Regex << dateSeparator << month_Regex << dateSeparator << day_Regex << "$/";

        day_Text = "getText(9,11)";
        month_Text = "getText(5,8)";
        year_Text = "getText(0,4)";
        break;
    }
    case RendererQml::DateFormat::yyddmm:
    {
        mDateFormat = RendererQml::Formatter() << "yyyy" << dateSeparator << "dd" << dateSeparator << "MMM";
        inputMask = RendererQml::Formatter() << "xxxx" << dateSeparator << "xx" << dateSeparator << ">x<xx;-";
        DateRegex = RendererQml::Formatter() << "/^" << year_Regex << dateSeparator << day_Regex << dateSeparator << month_Regex << "$/";

        day_Text = "getText(5,7)";
        month_Text = "getText(8,11)";
        year_Text = "getText(0,4)";
        break;
    }
    //Default case: mm-dd-yyyy
    default:
    {
        break;
    }
    }

    uiTextField->AddFunctions(RendererQml::Formatter() << "function setValidDate(dateString)"
        << "{"
        << "var Months = {Jan: 0,Feb: 1,Mar: 2,Apr: 3,May: 4,Jun: 5,July: 6,Aug: 7,Sep: 8,Oct: 9,Nov: 10,Dec: 11};"
        << "var d=new Date(" << year_Text << "," << "Months[" << month_Text << "]," << day_Text << ");"
        << "if( d.getFullYear().toString() === " << year_Text << "&& d.getMonth()===Months[" << month_Text << "] && parseInt(d.getDate().toString())===parseInt(" << day_Text << "))"
        << "{selectedDate = d.toLocaleString(Qt.locale(\"en_US\"),\"yyyy-MM-dd\");}"
        << "else { selectedDate = '';};"
        << "Accessible.name = getAccessibleName();"
        << "}");

    uiTextField->AddFunctions(getAccessibleName(uiTextField));

    uiTextField->Property("onTextChanged", RendererQml::Formatter() << "{textChanged" << uiTextField->GetId() << "(text); setValidDate(text);}");
    uiTextField->Property("onActiveFocusChanged", "{if(activeFocus){Accessible.name = getAccessibleName()}}");

    if (!mDateInput->GetValue().empty() && RendererQml::Utils::isValidDate(mDateInput->GetValue()))
    {
        uiTextField->Property("text", RendererQml::Formatter() << RendererQml::Utils::GetDate(mDateInput->GetValue()) << ".toLocaleString(Qt.locale(\"en_US\"),"
            << "\"" << mDateFormat << "\""
            << ")");
    }

    uiTextField->Property("validator", RendererQml::Formatter() << "RegExpValidator { regExp: " << DateRegex << "}");
    uiTextField->Property("onFocusChanged", RendererQml::Formatter() << "{"
        << "if(focus===true) {inputMask=\"" << inputMask << "\";}"
        << "if(focus === false){ "
        << "if(text === \"" << std::string(dateSeparator) + std::string(dateSeparator) << "\"){ inputMask = \"\" ; } "
        << "}} ");

    auto dateFormat = mDateFormat;
    uiTextField->Property("placeholderText", RendererQml::Formatter() << (!mDateInput->GetPlaceholder().empty() ? mDateInput->GetPlaceholder() : "Select date") << " in " << RendererQml::Utils::ToLower(dateFormat), true);
    uiTextField->Property("placeholderTextColor", mContext->GetHexColor(mDateConfig.placeHolderColor));

    return uiTextField;
}

std::shared_ptr<RendererQml::QmlTag> DateInputElement::getDateInputWrapper()
{
    auto uiDateInputWrapper = std::make_shared<RendererQml::QmlTag>("Rectangle");

    uiDateInputWrapper->Property("id", RendererQml::Formatter() << mDateInput->GetId() << "_wrapper");
    uiDateInputWrapper->Property("width", "parent.width");
    uiDateInputWrapper->Property("height", RendererQml::Formatter() << mDateConfig.height);
    uiDateInputWrapper->Property("radius", RendererQml::Formatter() << mDateConfig.borderRadius);
    uiDateInputWrapper->Property("color", mContext->GetHexColor(mDateConfig.backgroundColorNormal));
    uiDateInputWrapper->Property("border.color", RendererQml::Formatter() << mDateInput->GetId() << ".activeFocus? " << mContext->GetHexColor(mDateConfig.borderColorOnFocus) << " : " << mContext->GetHexColor(mDateConfig.borderColorNormal));
    uiDateInputWrapper->Property("border.width", RendererQml::Formatter() << mDateConfig.borderWidth);
    uiDateInputWrapper->Property("visible", mDateInput->GetIsVisible() ? "true" : "false");
    uiDateInputWrapper->AddFunctions(getColorFunction(uiDateInputWrapper->GetId()));

    return uiDateInputWrapper;
}

std::shared_ptr<RendererQml::QmlTag> DateInputElement::getDateInputComboBox(std::shared_ptr<RendererQml::QmlTag> dateInputField, std::shared_ptr<RendererQml::QmlTag> dateInputWrapper, const std::string calendarBoxId)
{
    auto uiDateInputCombobox = std::make_shared<RendererQml::QmlTag>("ComboBox");

    auto popUp = getCalendar(dateInputField->GetId(), calendarBoxId);
    popUp->Property("onClosed", RendererQml::Formatter() << dateInputField->GetId() << ".forceActiveFocus()");

    uiDateInputCombobox->Property("id", RendererQml::Formatter() << mDateInput->GetId() << "_combobox");
    uiDateInputCombobox->Property("Layout.fillWidth", "true");
    uiDateInputCombobox->Property("popup", popUp->ToString());
    uiDateInputCombobox->Property("indicator", "Rectangle{}");
    uiDateInputCombobox->Property("focusPolicy", "Qt.NoFocus");
    uiDateInputCombobox->Property("Keys.onReturnPressed", "this.popup.open()");

    dateInputField->Property("onPressed", RendererQml::Formatter() << dateInputWrapper->GetId() << ".colorChange(true)");
    dateInputField->Property("onReleased", RendererQml::Formatter() << dateInputWrapper->GetId() << ".colorChange(false)");
    dateInputField->Property("onHoveredChanged", RendererQml::Formatter() << dateInputWrapper->GetId() << ".colorChange(false)");
    uiDateInputCombobox->Property("onActiveFocusChanged", RendererQml::Formatter() << dateInputWrapper->GetId() << ".colorChange(false)");

    addValidation(dateInputField, dateInputWrapper);
    uiDateInputCombobox->Property("background", dateInputField->ToString());

    return uiDateInputCombobox;
}

std::shared_ptr<RendererQml::QmlTag> DateInputElement::getCalendar(const std::string dateFieldId, const std::string calendarBoxId)
{
    auto backgroundRectangle = std::make_shared<RendererQml::QmlTag>("Rectangle");
    backgroundRectangle->Property("radius", RendererQml::Formatter() << mDateConfig.calendarBorderRadius);
    backgroundRectangle->Property("border.color", mContext->GetHexColor(mDateConfig.calendarBorderColor));
    backgroundRectangle->Property("color", mContext->GetHexColor(mDateConfig.calendarBackgroundColor));

    auto listviewCalendar = getCalendarListView(dateFieldId);

    auto popupTag = std::make_shared<RendererQml::QmlTag>("Popup");
    popupTag->Property("id", calendarBoxId);
    popupTag->Property("y", RendererQml::Formatter() << dateFieldId << ".height + 2");
    popupTag->Property("x", RendererQml::Formatter() << "-" << mDateConfig.clearIconSize << "-" << mDateConfig.dateIconHorizontalPadding);
    popupTag->Property("width", RendererQml::Formatter() << mDateConfig.calendarWidth);
    popupTag->Property("height", RendererQml::Formatter() << mDateConfig.calendarHeight);
    popupTag->Property("bottomInset", "0");
    popupTag->Property("topInset", "0");
    popupTag->Property("rightInset", "0");
    popupTag->Property("leftInset", "0");
    popupTag->Property("background", backgroundRectangle->ToString());
    popupTag->Property("onOpened", RendererQml::Formatter() << listviewCalendar->GetId() << ".forceActiveFocus()");

    auto listViewDelegate = getCalendarListViewDelegate(listviewCalendar->GetId(), dateFieldId, popupTag->GetId());
    listviewCalendar->Property("delegate", listViewDelegate->ToString());

    auto contentItemRectangle = std::make_shared<RendererQml::QmlTag>("Rectangle");
    contentItemRectangle->Property("radius", RendererQml::Formatter() << mDateConfig.calendarBorderRadius);
    contentItemRectangle->Property("color", mContext->GetHexColor(mDateConfig.calendarBackgroundColor));
    contentItemRectangle->AddChild(listviewCalendar);

    auto leftArrowButton = getArrowIconButton("leftArrow", dateFieldId, listviewCalendar->GetId());
    auto rightArrowButton = getArrowIconButton("rightArrow", dateFieldId, listviewCalendar->GetId());

    leftArrowButton->Property("KeyNavigation.tab", rightArrowButton->GetId());
    leftArrowButton->Property("KeyNavigation.backtab", listviewCalendar->GetId());

    rightArrowButton->Property("KeyNavigation.tab", listviewCalendar->GetId());
    rightArrowButton->Property("KeyNavigation.backtab", leftArrowButton->GetId());

    listviewCalendar->Property("Keys.onPressed", RendererQml::Formatter() << "{"
        << "var date = new Date(selectedDate);"
        << "if (event.key === Qt.Key_Right)"
        << "date.setDate(date.getDate() + 1);"
        << "else if (event.key === Qt.Key_Left)"
        << "date.setDate(date.getDate() - 1);"
        << "else if (event.key === Qt.Key_Up)"
        << "date.setDate(date.getDate() - 7);"
        << "else if (event.key === Qt.Key_Down)"
        << "date.setDate(date.getDate() + 7);"
        << "else if (event.key === Qt.Key_Return)"
        << "{"
        << dateFieldId << ".text = selectedDate.toLocaleString(Qt.locale(\"en_US\"), \"" << mDateFormat << "\");"
        << popupTag->GetId() << ".close();"
        << "}"
        << "else if (event.key === Qt.Key_Tab) {"
        << leftArrowButton->GetId() << ".forceActiveFocus()}"
        << "else if (event.key === Qt.Key_Backtab) {"
        << rightArrowButton->GetId() << ".forceActiveFocus()}"
        << "if (date >= minimumDate && date <= maximumDate)"
        << "{"
        << "selectedDate = new Date(date);"
        << "currentIndex = (selectedDate.getFullYear()) * 12 + selectedDate.getMonth();"
        << "}"
        << listviewCalendar->GetId() << ".accessibilityPrefix = '';getDateForSC(selectedDate);"
        << "event.accepted = true}");

    popupTag->AddChild(rightArrowButton);
    popupTag->AddChild(leftArrowButton);
    popupTag->Property("contentItem", contentItemRectangle->ToString());
    return popupTag;
}

std::shared_ptr<RendererQml::QmlTag> DateInputElement::getCalendarListView(const std::string dateFieldId)
{
    const std::vector<int>upperDateLimit{ 3000,0,1 };
    const std::vector<int>lowerDateLimit{ 0,0,1 };

    if (!mDateInput->GetMin().empty() && RendererQml::Utils::isValidDate(mDateInput->GetMin()))
    {
        mMinimumDate = RendererQml::Utils::GetDate(mDateInput->GetMin());
    }

    if (!mDateInput->GetMax().empty() && RendererQml::Utils::isValidDate(mDateInput->GetMax()))
    {
        mMaximumDate = RendererQml::Utils::GetDate(mDateInput->GetMax());
    }

    auto listviewCalendar = std::make_shared<RendererQml::QmlTag>("ListView");
    listviewCalendar->Property("property int curCalendarYear", "0");
    listviewCalendar->Property("property int curCalendarMonth", "0");
    listviewCalendar->Property("property date minimumDate", mMinimumDate != "" ? mMinimumDate : RendererQml::Formatter() << "new Date(" << std::to_string(lowerDateLimit.at(0)) << "," << std::to_string(lowerDateLimit.at(1)) << "," << std::to_string(lowerDateLimit.at(2)) << ")");
    listviewCalendar->Property("property date maximumDate", mMaximumDate != "" ? mMaximumDate : RendererQml::Formatter() << "new Date(" << std::to_string(upperDateLimit.at(0)) << "," << std::to_string(upperDateLimit.at(1)) << "," << std::to_string(upperDateLimit.at(2)) << ")");
    listviewCalendar->Property("property date selectedDate", "new Date()");
    listviewCalendar->Property("property string accessibilityPrefix", "Date Picker. The current date is", true);
    listviewCalendar->Property("property string dateForSc", "''");

    listviewCalendar->Property("id", RendererQml::Formatter() << dateFieldId << "_calendarRoot");

    listviewCalendar->Property("anchors.fill", "parent");
    listviewCalendar->AddFunctions("signal clicked(date clickedDate)");

    listviewCalendar->AddFunctions(RendererQml::Formatter() << "function setDate(clickedDate)" << "{"
        << "selectedDate = clickedDate;"
        << "curCalendarYear = selectedDate.getFullYear();"
        << "curCalendarMonth = selectedDate.getMonth();"
        << "var curIndex = (selectedDate.getFullYear()) * 12 + selectedDate.getMonth();"
        << "currentIndex = curIndex;"
        << "positionViewAtIndex(curIndex, ListView.Center);" << "getDateForSC(clickedDate); }");

    listviewCalendar->AddFunctions(RendererQml::Formatter() << "function setCalendarDateFromString(dateString)"
        << "{"
        << "var Months = {Jan: 0,Feb: 1,Mar: 2,Apr: 3,May: 4,Jun: 5,July: 6,Aug: 7,Sep: 8,Oct: 9,Nov: 10,Dec: 11};"
        << "var y=dateString.match(/[0-9]{4}/);"
        << "dateString=dateString.replace(y,\"\");"
        << "var m=dateString.match(/[a-zA-Z]{3}/);"
        << "var d=dateString.match(/[0-9]{2}/);"
        << "if (d!==null && m!==null && y!==null){selectedDate=new Date(y[0],Months[m[0]],d[0]);}"
        << "setDate(selectedDate);"
        << "}");

    listviewCalendar->AddFunctions(RendererQml::Formatter() << "function getDateForSC(clickedDate)"
        << "{"
        << "var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];"
        << "var d = clickedDate.getDate();"
        << "var m = months[clickedDate.getMonth()];"
        << "var y = clickedDate.getFullYear();"
        << listviewCalendar->GetId() << ".dateForSc = m + ' ' + d + ' ' + y;"
        << "}");

    listviewCalendar->Property("Component.onCompleted", RendererQml::Formatter() << "{"
        << dateFieldId << "." << "textChanged" << dateFieldId << ".connect(setCalendarDateFromString);"
        << dateFieldId << "." << "textChanged" << dateFieldId << "( " << dateFieldId << ".text);"
        << "if (selectedDate < minimumDate) { selectedDate = minimumDate;}"
        << "else if (selectedDate > maximumDate) { selectedDate = maximumDate;}"
        << "}");

    listviewCalendar->Property("snapMode", "ListView.SnapOneItem");
    listviewCalendar->Property("orientation", "Qt.Horizontal");
    listviewCalendar->Property("clip", "true");
    listviewCalendar->Property("model", std::to_string((upperDateLimit.at(0) - lowerDateLimit.at(0)) * 12));
    listviewCalendar->Property("onClicked", RendererQml::Formatter() << "{" << "setDate(clickedDate)" << "}");

    return listviewCalendar;
}

std::shared_ptr<RendererQml::QmlTag> DateInputElement::getCalendarListViewDelegate(const std::string listViewId, const std::string dateFieldId, const std::string popupId)
{
    auto listViewDelegate = std::make_shared<RendererQml::QmlTag>("Item");
    listViewDelegate->Property("id", RendererQml::Formatter() << dateFieldId << "listViewDelegate");
    listViewDelegate->Property("property int year", "Math.floor(index/12)");
    listViewDelegate->Property("property int month", "index%12");
    listViewDelegate->Property("property int firstDay", "(new Date(year, month, 1).getDay()-1 < 0 ? 6 : new Date(year, month, 1).getDay() - 1)");
    listViewDelegate->Property("width", RendererQml::Formatter() << listViewId << ".width");
    listViewDelegate->Property("height", RendererQml::Formatter() << listViewId << ".height");

    auto headerText = std::make_shared<RendererQml::QmlTag>("Text");
    headerText->Property("id", RendererQml::Formatter() << dateFieldId << "headerText");
    headerText->Property("anchors.left", "parent.left");
    headerText->Property("color", mContext->GetHexColor(mDateConfig.textColor));
    headerText->Property("text", RendererQml::Formatter() << "['January', 'February', 'March', 'April', 'May', 'June','July', 'August', 'September', 'October', 'November', 'December'][" << listViewDelegate->GetId() << ".month] + ' ' + " << listViewDelegate->GetId() << ".year");
    headerText->Property("font.pixelSize", RendererQml::Formatter() << mDateConfig.calendarHeaderTextSize);
    listViewDelegate->AddChild(headerText);

    auto monthGrid = std::make_shared<RendererQml::QmlTag>("Grid");
    const std::string monthGridId = RendererQml::Formatter() << dateFieldId << "gridId";
    monthGrid->Property("id", monthGridId);
    monthGrid->Property("anchors.top", RendererQml::Formatter() << headerText->GetId() << ".bottom");
    monthGrid->Property("anchors.right", "parent.right");
    monthGrid->Property("anchors.left", "parent.left");
    monthGrid->Property("anchors.bottom", "parent.bottom");
    monthGrid->Property("anchors.topMargin", RendererQml::Formatter() << mDateConfig.dateGridTopMargin);
    monthGrid->Property("clip", "true");
    monthGrid->Property("columns", "7");
    monthGrid->Property("rows", "7");
    listViewDelegate->AddChild(monthGrid);

    auto repeaterTag = std::make_shared<RendererQml::QmlTag>("Repeater");
    repeaterTag->Property("model", RendererQml::Formatter() << monthGridId << ".columns * " << monthGridId << ".rows");

    auto delegateRectangle = std::make_shared<RendererQml::QmlTag>("Rectangle");
    delegateRectangle->Property("id", RendererQml::Formatter() << dateFieldId << "delegateRectangle");
    delegateRectangle->Property("property bool datePickerFocusCheck", RendererQml::Formatter() << listViewId << ".activeFocus && " << listViewId << ".activeFocus && new Date(year,month,date).toDateString() == " << listViewId << ".selectedDate.toDateString()");
    delegateRectangle->Property("onDatePickerFocusCheckChanged", "{if (datePickerFocusCheck)forceActiveFocus()}");
    delegateRectangle->Property("Accessible.name", RendererQml::Formatter() << listViewId << ".accessibilityPrefix + " << listViewId << ".dateForSc");
    delegateRectangle->Property("Accessible.role", "Accessible.NoRole");

    auto delegateMouseArea = std::make_shared<RendererQml::QmlTag>("MouseArea");
    delegateMouseArea->Property("id", RendererQml::Formatter() << dateFieldId << "delegateMouseArea");

    auto delegateText = std::make_shared<RendererQml::QmlTag>("Text");
    delegateText->Property("id", RendererQml::Formatter() << dateFieldId << "delegateText");
    delegateText->Property("anchors.centerIn", "parent");
    delegateText->Property("font.pixelSize", RendererQml::Formatter() << "day < 0 ? " << mDateConfig.calendarDayTextSize << " : " << mDateConfig.calendarDateTextSize);

    delegateText->Property("color", RendererQml::Formatter() << "{"
        << "if (" << delegateRectangle->GetId() << ".cellDate.toDateString() === " << listViewId << ".selectedDate.toDateString() && " << delegateMouseArea->GetId() << ".enabled)"
        << "{\"white\";}"
        << "else if (" << delegateRectangle->GetId() << ".cellDate.getMonth() === " << listViewDelegate->GetId() << ".month && " << delegateMouseArea->GetId() << ".enabled)"
        << "{" << mContext->GetHexColor(mDateConfig.textColor) << ";}"
        << "else"
        << "{" << mContext->GetHexColor(mDateConfig.notAvailabledateElementTextColor) << ";}"
        << "}");

    delegateText->Property("text", RendererQml::Formatter() << "{" << "if (day < 0){"
        << delegateRectangle->GetId() << ".dayArray[index]" << ";}"
        << "else if (new Date(year, month, date).getMonth() == month)" << ""
        << "{date" << ";}"
        << "else" << "{cellDate.getDate();}}");

    delegateMouseArea->Property("anchors.fill", "parent");
    delegateMouseArea->Property("enabled", RendererQml::Formatter() << delegateText->GetId() << ".text &&  day >= 0 && (new Date(year,month,date) >= " << listViewId << ".minimumDate ) && (new Date(year,month,date) <= " << listViewId << ".maximumDate )");
    delegateMouseArea->Property("hoverEnabled", "true");
    delegateMouseArea->Property("onClicked", RendererQml::Formatter() << "{"
        << "var selectedDate = new Date(year, month, date);"
        << listViewId << ".clicked(selectedDate)" << "}");

    delegateMouseArea->Property("onReleased", RendererQml::Formatter() << "{"
        << listViewId << ".selectedDate = " << delegateRectangle->GetId() << ".cellDate;"
        << dateFieldId << ".text = " << listViewId << ".selectedDate.toLocaleString(Qt.locale(\"en_US\"),\"" << mDateFormat << "\");"
        << popupId << ".close();"
        << "}");

    delegateRectangle->Property("property int day", "index - 7");
    delegateRectangle->Property("property int date", RendererQml::Formatter() << "day - " << listViewDelegate->GetId() << ".firstDay + 1");
    delegateRectangle->Property("width", RendererQml::Formatter() << mDateConfig.dateElementSize);
    delegateRectangle->Property("height", RendererQml::Formatter() << mDateConfig.dateElementSize);
    delegateRectangle->Property("property variant dayArray", "['M', 'T', 'W', 'T', 'F', 'S', 'S']");
    delegateRectangle->Property("color", RendererQml::Formatter() << "new Date(year,month,date).toDateString() == " << listViewId << ".selectedDate.toDateString() && " << delegateMouseArea->GetId() << ".enabled" << "? " << mContext->GetHexColor(mDateConfig.dateElementColorOnFocus) << " : " << delegateMouseArea->GetId() << ".containsMouse? " << mContext->GetHexColor(mDateConfig.dateElementColorOnHover) << " :" << mContext->GetHexColor(mDateConfig.dateElementColorNormal));
    delegateRectangle->Property("radius", "0.5 * width");
    delegateRectangle->Property("property date cellDate", "new Date(year,month,date)");

    auto borderFocusRectangle = std::make_shared<RendererQml::QmlTag>("Rectangle");
    borderFocusRectangle->Property("width", RendererQml::Formatter() << mDateConfig.dateElementSize);
    borderFocusRectangle->Property("height", RendererQml::Formatter() << mDateConfig.dateElementSize);
    borderFocusRectangle->Property("color", "'transparent'");
    borderFocusRectangle->Property("border.width", RendererQml::Formatter() << listViewId << ".activeFocus && new Date(year,month,date).toDateString() == " << listViewId << ".selectedDate.toDateString() ? 1 : 0");
    borderFocusRectangle->Property("border.color", mContext->GetHexColor(mDateConfig.calendarBorderColor));

    delegateRectangle->AddChild(borderFocusRectangle);
    delegateRectangle->AddChild(delegateText);
    delegateRectangle->AddChild(delegateMouseArea);
    repeaterTag->Property("delegate", delegateRectangle->ToString());

    monthGrid->AddChild(repeaterTag);

    return listViewDelegate;
}

std::shared_ptr<RendererQml::QmlTag> DateInputElement::getArrowIconButton(const std::string arrowType, const std::string dateFieldId, const std::string listViewId)
{
    auto iconBackground = std::make_shared<RendererQml::QmlTag>("Rectangle");
    iconBackground->Property("color", mContext->GetHexColor(mDateConfig.calendarBackgroundColor));
    iconBackground->Property("border.width", "parent.activeFocus ? 1 : 0");
    iconBackground->Property("border.color", mContext->GetHexColor(mDateConfig.calendarBorderColor));

    auto arrowButton = RendererQml::AdaptiveCardQmlRenderer::GetIconTag(mContext);
    arrowButton->Property("id", RendererQml::Formatter() << dateFieldId << "_" << arrowType);
    arrowButton->RemoveProperty("anchors.bottom");
    arrowButton->Property("width", "icon.width");
    arrowButton->Property("height", "icon.height");
    arrowButton->Property("icon.width", RendererQml::Formatter() << mDateConfig.arrowIconSize);
    arrowButton->Property("icon.height", RendererQml::Formatter() << mDateConfig.arrowIconSize);
    arrowButton->Property("horizontalPadding", "0");
    arrowButton->Property("verticalPadding", "0");
    arrowButton->Property("anchors.margins", "0");
    arrowButton->Property("background", iconBackground->ToString());
    arrowButton->Property("Keys.onReturnPressed", "onReleased()");
    arrowButton->Property("Accessible.role", "Accessible.Button");

    std::string setMonthDate = RendererQml::Formatter() << "var tempDate = new Date()\n"
        << "tempDate.setMonth(" << listViewId << ".curCalendarMonth)\n"
        << "tempDate.setYear(" << listViewId << ".curCalendarYear)\n"
        << "tempDate.setDate(1)\n"
        << listViewId << ".setDate(tempDate);" << listViewId << ".getDateForSC(tempDate)\n";

    std::string onReleased = "";

    if (arrowType == "leftArrow")
    {
        arrowButton->Property("anchors.right", RendererQml::Formatter() << dateFieldId << "_rightArrow" << ".left");
        arrowButton->Property("icon.source", RendererQml::left_arrow_28, true);
        arrowButton->Property("Accessible.name", "Previous Month", true);
        onReleased = RendererQml::Formatter() << "{"
            << listViewId << ".curCalendarYear = " << listViewId << ".curCalendarMonth - 1 < 0 ? " << listViewId << ".curCalendarYear - 1 : " << listViewId << ".curCalendarYear;"
            << listViewId << ".curCalendarMonth = " << listViewId << ".curCalendarMonth - 1 < 0 ? 11 : " << listViewId << ".curCalendarMonth - 1;"
            << listViewId << ".positionViewAtIndex((" << listViewId << ".curCalendarYear) * 12 + (" << listViewId << ".curCalendarMonth), ListView.Center);"
            << setMonthDate << "}";
    }
    else
    {
        arrowButton->Property("icon.source", RendererQml::right_arrow_28, true);
        arrowButton->Property("Accessible.name", "Next Month", true);
        onReleased = RendererQml::Formatter() << "{"
            << listViewId << ".curCalendarYear = " << listViewId << ".curCalendarMonth ==11? " << listViewId << ".curCalendarYear + 1 : " << listViewId << ".curCalendarYear;"
            << listViewId << ".curCalendarMonth = (" << listViewId << ".curCalendarMonth + 1)%12;"
            << listViewId << ".positionViewAtIndex((" << listViewId << ".curCalendarYear) * 12 + (" << listViewId << ".curCalendarMonth), ListView.Center);"
            << setMonthDate << "}";
    }

    arrowButton->Property("onReleased", onReleased);

    return arrowButton;
}

std::shared_ptr<RendererQml::QmlTag> DateInputElement::getDateIconButton(const std::string dateFieldId, const std::string calendarBoxId)
{
    auto dateIcon = RendererQml::AdaptiveCardQmlRenderer::GetClearIconButton(mContext);

    dateIcon->RemoveProperty("anchors.right");
    dateIcon->RemoveProperty("anchors.margins");
    dateIcon->RemoveProperty("anchors.verticalCenter");
    dateIcon->Property("id", RendererQml::Formatter() << mDateInput->GetId() << "_icon");
    dateIcon->Property("Layout.leftMargin", RendererQml::Formatter() << mDateConfig.dateIconHorizontalPadding);
    dateIcon->Property("Layout.alignment", "Qt.AlignVCenter");
    dateIcon->Property("focusPolicy", "Qt.NoFocus");
    dateIcon->Property("width", "18");
    dateIcon->Property("height", "18");
    dateIcon->Property("icon.color", RendererQml::Formatter() << mDateInput->GetId() << ".activeFocus ? " << mContext->GetHexColor(mDateConfig.dateIconColorOnFocus) << " : " << mContext->GetHexColor(mDateConfig.dateIconColorNormal));
    dateIcon->Property("icon.source", RendererQml::calendar_icon, true);
    std::string onClicked_value = "{ " + dateFieldId + ".forceActiveFocus(); " + calendarBoxId + ".open();}";
    dateIcon->Property("onClicked", onClicked_value);

    return dateIcon;
}

std::shared_ptr<RendererQml::QmlTag> DateInputElement::getClearIconButton(const std::string dateFieldId)
{
    auto clearIcon = RendererQml::AdaptiveCardQmlRenderer::GetClearIconButton(mContext);

    clearIcon->RemoveProperty("anchors.right");
    clearIcon->RemoveProperty("anchors.margins");
    clearIcon->RemoveProperty("anchors.verticalCenter");
    clearIcon->Property("id", RendererQml::Formatter() << mDateInput->GetId() << "_clear_icon");
    clearIcon->Property("Layout.rightMargin", RendererQml::Formatter() << mDateConfig.clearIconHorizontalPadding);
    std::string clearIcon_visible_value = RendererQml::Formatter() << "(!" << dateFieldId << ".focus && " << dateFieldId << ".text !==\"\") || (" << dateFieldId << ".focus && " << dateFieldId << ".text !== " << "\"\\/\\/\")";
    clearIcon->Property("visible", clearIcon_visible_value);
    std::string clearIcon_OnClicked_value = RendererQml::Formatter() << " {"
        << "nextItemInFocusChain().forceActiveFocus();\n"
        << dateFieldId << ".clear();\n" << "}";
    clearIcon->Property("onClicked", clearIcon_OnClicked_value);
    clearIcon->Property("Accessible.name", "Date Picker clear", true);
    clearIcon->Property("Accessible.role", "Accessible.Button");

    return clearIcon;
}

void DateInputElement::addInputLabel(bool isRequired)
{
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mDateInput->GetLabel().empty())
        {
            auto label = std::make_shared<RendererQml::QmlTag>("Label");
            label->Property("id", RendererQml::Formatter() << mDateInput->GetId() << "_label");
            label->Property("wrapMode", "Text.Wrap");
            label->Property("width", "parent.width");

            std::string color = mContext->GetColor(AdaptiveCards::ForegroundColor::Default, false, false);
            label->Property("color", color);
            label->Property("font.pixelSize", RendererQml::Formatter() << mDateConfig.labelSize);
            label->Property("Accessible.ignored", "true");

            if (isRequired)
            {
                label->Property("text", RendererQml::Formatter() << (mDateInput->GetLabel().empty() ? "Text" : mDateInput->GetLabel()) << " <font color='" << mDateConfig.errorMessageColor << "'>*</font>", true);
            }
            else
            {
                label->Property("text", RendererQml::Formatter() << (mDateInput->GetLabel().empty() ? "Text" : mDateInput->GetLabel()), true);
            }

            mDateInputColElement->AddChild(label);
        }
        else
        {
            if (mDateInput->GetIsRequired())
            {
                mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "isRequired is not supported without labels"));
            }
        }
    }
}

void DateInputElement::addErrorMessage()
{
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled() && mDateInput->GetIsRequired())
    {
        if (!mDateInput->GetErrorMessage().empty())
        {
            auto uiErrorMessage = std::make_shared<RendererQml::QmlTag>("Label");
            uiErrorMessage->Property("id", RendererQml::Formatter() << mDateInput->GetId() << "_errorMessage");
            uiErrorMessage->Property("wrapMode", "Text.Wrap");
            uiErrorMessage->Property("width", "parent.width");
            uiErrorMessage->Property("font.pixelSize", RendererQml::Formatter() << mDateConfig.labelSize);
            uiErrorMessage->Property("Accessible.ignored", "true");

            uiErrorMessage->Property("color", mContext->GetHexColor(mDateConfig.errorMessageColor));
            uiErrorMessage->Property("text", mDateInput->GetErrorMessage(), true);
            uiErrorMessage->Property("visible", RendererQml::Formatter() << mDateInput->GetId() << ".showErrorMessage");
            mDateInputColElement->AddChild(uiErrorMessage);
        }
    }
}

void DateInputElement::addValidation(std::shared_ptr<RendererQml::QmlTag> uiDateInput, std::shared_ptr<RendererQml::QmlTag> dateInputWrapper)
{
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled() && mDateInput->GetIsRequired())
    {
        mContext->addToRequiredInputElementsIdList(uiDateInput->GetId());
        uiDateInput->Property("property bool showErrorMessage", "false");

        std::ostringstream validator;
        std::string condition;

        validator << "function validate(){"
            << "var isValid = (" << uiDateInput->GetId() << ".selectedDate !== '' && (" << uiDateInput->GetId() << "_calendarRoot.selectedDate >= " << uiDateInput->GetId() << "_calendarRoot.minimumDate) && (" << uiDateInput->GetId() << "_calendarRoot.selectedDate <= " << uiDateInput->GetId() << "_calendarRoot.maximumDate));"
            << "if(showErrorMessage){"
            << "if(isValid){"
            << "showErrorMessage = false;"
            << "}}"
            << "return !isValid;}";

        uiDateInput->AddFunctions(validator.str());
        uiDateInput->Property("onSelectedDateChanged", "validate()");
        uiDateInput->Property("onShowErrorMessageChanged", RendererQml::Formatter() << dateInputWrapper->GetId() << ".colorChange(false)");
        dateInputWrapper->Property("border.color", RendererQml::Formatter() << mDateInput->GetId() << ".showErrorMessage ? " << mContext->GetHexColor(mDateConfig.borderColorOnError) << " : " << mDateInput->GetId() << ".activeFocus? " << mContext->GetHexColor(mDateConfig.borderColorOnFocus) << " : " << mContext->GetHexColor(mDateConfig.borderColorNormal));
    }
}

const std::string DateInputElement::getColorFunction(const std::string wrapperId)
{
    std::ostringstream colorFunction;

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        colorFunction << "function colorChange(isPressed){"
            "if (isPressed && !" << mDateInput->GetId() << ".showErrorMessage)  color = " << mContext->GetHexColor(mDateConfig.backgroundColorOnPressed) << ";"
            "else color = " << mDateInput->GetId() << ".showErrorMessage ? " << mContext->GetHexColor(mDateConfig.backgroundColorOnError) << " : " << mDateInput->GetId() << ".activeFocus ? " << mContext->GetHexColor(mDateConfig.backgroundColorOnPressed) << " : " << mDateInput->GetId() << ".hovered ? " << mContext->GetHexColor(mDateConfig.backgroundColorOnHovered) << " : " << mContext->GetHexColor(mDateConfig.backgroundColorNormal) << "}";
    }
    else
    {
        colorFunction << "function colorChange(isPressed){"
            "if (isPressed)  color = " << mContext->GetHexColor(mDateConfig.backgroundColorOnPressed) << ";"
            "else color = " << mDateInput->GetId() << ".activeFocus ? " << mContext->GetHexColor(mDateConfig.backgroundColorOnPressed) << " : " << mDateInput->GetId() << ".hovered ? " << mContext->GetHexColor(mDateConfig.backgroundColorOnHovered) << " : " << mContext->GetHexColor(mDateConfig.backgroundColorNormal) << "}";
    }

    return colorFunction.str();
}

std::string DateInputElement::getAccessibleName(std::shared_ptr<RendererQml::QmlTag> uiDateInput)
{
    std::ostringstream accessibleName;
    std::ostringstream labelString;
    std::ostringstream errorString;
    std::ostringstream placeHolderString;

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mDateInput->GetLabel().empty())
        {
            labelString << "accessibleName += '" << mDateInput->GetLabel() << ". ';";
        }

        if (!mDateInput->GetErrorMessage().empty())
        {
            errorString << "if(" << uiDateInput->GetId() << ".showErrorMessage === true){"
                << "accessibleName += 'Error. " << mDateInput->GetErrorMessage() << ". ';}";
        }
    }

    placeHolderString << "if(" << uiDateInput->GetId() << ".selectedDate !== ''){"
        << "accessibleName += (" << uiDateInput->GetId() << "_calendarRoot.selectedDate.toLocaleDateString() + '. ');"
        << "}else{"
        << "accessibleName += placeholderText;}";

    accessibleName << "function getAccessibleName(){"
        << "let accessibleName = '';" << errorString.str() << labelString.str() << placeHolderString.str() << "return accessibleName;}";

    return accessibleName.str();
}
