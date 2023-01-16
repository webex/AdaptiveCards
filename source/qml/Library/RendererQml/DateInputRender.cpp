#include "DateInputRender.h"
#include "Formatter.h"
#include "ImageDataURI.h"
#include "Utils.h"

DateInputElement::DateInputElement(std::shared_ptr<AdaptiveCards::DateInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context)
    :mDateInput(input),
    mContext(context),
    mDateConfig(context->GetRenderConfig()->getInputDateConfig())
{
    initialize();
}

std::shared_ptr<RendererQml::QmlTag> DateInputElement::getQmlTag()
{
    return mDateInputElement;
}

void DateInputElement::initialize()
{
    mOrigionalElementId = mDateInput->GetId();
    mDateInput->SetId(mContext->ConvertToValidId(mDateInput->GetId()));

    mEscapedPlaceHolderString = RendererQml::Utils::getBackQuoteEscapedString(mDateInput->GetPlaceholder());
    mEscapedLabelString = RendererQml::Utils::getBackQuoteEscapedString(mDateInput->GetLabel());
    mEscapedErrorString = RendererQml::Utils::getBackQuoteEscapedString(mDateInput->GetErrorMessage());

    mDateInputElement = std::make_shared<RendererQml::QmlTag>("DateInputRender");
    mDateInputElement->Property("id", mDateInput->GetId());
    mDateInputElement->Property("property int minWidth", "300");
    mDateInputElement->Property("_adaptiveCard", "adaptiveCard");
    mDateInputElement->Property("_mEscapedLabelString", RendererQml::Formatter() << "`" << mEscapedLabelString << "`");
    mDateInputElement->Property("_mEscapedErrorString", RendererQml::Formatter() << "`" << mEscapedErrorString << "`");
    mDateInputElement->Property("_mEscapedPlaceholderString", RendererQml::Formatter() << "`" << mEscapedLabelString << "`");

    if (!mDateInput->GetMin().empty() && RendererQml::Utils::isValidDate(mDateInput->GetMin()))
    {
        mDateInputElement->Property("_minDate", RendererQml::Utils::GetDate(mDateInput->GetMin()));
    }

    if (!mDateInput->GetMax().empty() && RendererQml::Utils::isValidDate(mDateInput->GetMax()))
    {
        mDateInputElement->Property("_maxDate", RendererQml::Utils::GetDate(mDateInput->GetMax()));
    }

    if (!mDateInput->GetValue().empty() && RendererQml::Utils::isValidDate(mDateInput->GetValue()))
    {
        mDateInputElement->Property("_currentDate", RendererQml::Utils::GetDate(mDateInput->GetValue()));
    }

    if (mDateInput->GetIsRequired() || !mDateInput->GetMin().empty() || !mDateInput->GetMax().empty())
    {
        mContext->addToRequiredInputElementsIdList(mDateInputElement->GetId());
        mDateInputElement->Property((mDateInput->GetIsRequired() ? "_isRequired" : "_validationRequired"), "true");
    }

    mContext->addToInputElementList(mOrigionalElementId, (mDateInputElement->GetId() + "._submitValue"));
    mContext->addHeightEstimate(mDateConfig.height);

    if (!mDateInput->GetLabel().empty())
    {
        mContext->addHeightEstimate(mContext->getEstimatedTextHeight(mDateInput->GetLabel()));
    }

    mDateInputElement->Property("visible", mDateInput->GetIsVisible() ? "true" : "false");

    /*mDateInputColElementId = mDateInput->GetId();
    mDateFieldId = RendererQml::Formatter() << mDateInput->GetId() << "_dateInput";
    mCalendarBoxId = RendererQml::Formatter() << mDateFieldId << "_calendarBox";
    mDateInputWrapperId = RendererQml::Formatter() << mDateFieldId << "_wrapper";
    mDateInputComboboxId = RendererQml::Formatter() << mDateFieldId << "_combobox";
    mDateInputRowId = RendererQml::Formatter() << mDateFieldId << "_row";
    mDateIconId = RendererQml::Formatter() << mDateFieldId << "_icon";
    mClearIconId = RendererQml::Formatter() << mDateFieldId << "_clear_icon";

    mDateInputElement->Property("spacing", RendererQml::Formatter() << RendererQml::Utils::GetSpacing(mContext->GetConfig()->GetSpacing(), AdaptiveCards::Spacing::Small));
    mDateInputElement->Property("width", "parent.width");

    addInputLabel(mDateInput->GetIsRequired());
    renderDateElement();
    addErrorMessage();*/
}

//void DateInputElement::renderDateElement()
//{
//    initDateInputField();
//    initDateInputWrapper();
//    initDateInputComboBox();
//
//    mDateInputRow = std::make_shared<RendererQml::QmlTag>("RowLayout");
//
//    mDateInputRow->Property("id", mDateInputRowId);
//    mDateInputRow->Property("width", "parent.width");
//    mDateInputRow->Property("height", "parent.height");
//    mDateInputRow->Property("spacing", "0");
//
//    initDateIconButton();
//    initClearIconButton();
//
//    mContext->addToInputElementList(mOrigionalElementId, (mDateFieldId + ".selectedDate"));
//
//    mDateInputRow->AddChild(mDateIcon);
//    mDateInputRow->AddChild(mDateInputCombobox);
//    mDateInputRow->AddChild(mClearIcon);
//
//    mDateInputWrapper->AddChild(mDateInputRow);
//    mDateInputCombobox->Property("Accessible.ignored", "true");
//
//    mDateInputElement->AddChild(mDateInputWrapper);
//}
//

//void DateInputElement::initDateInputField()
//{
    //if (!mDateInput->GetMin().empty() && RendererQml::Utils::isValidDate(mDateInput->GetMin()))
    //{
    //    mMinimumDate = RendererQml::Utils::GetDate(mDateInput->GetMin());
    //}
//
//    if (!mDateInput->GetMax().empty() && RendererQml::Utils::isValidDate(mDateInput->GetMax()))
//    {
//        mMaximumDate = RendererQml::Utils::GetDate(mDateInput->GetMax());
//    }
//
//    auto EnumDateFormat = RendererQml::Utils::GetSystemDateFormat();
//
//    const auto dateSeparator = "\\/";
//    const auto day_Regex = "([-0123]-|0\\d|[12]\\d|3[01])";
//    const auto month_Regex = "(---|[JFMASOND]--|Ja-|Jan|Fe-|Feb|Ma-|Mar|Ap-|Apr|May|Ju-|Jun|Jul|Au-|Aug|Se-|Sep|Oc-|Oct|No-|Nov|De-|Dec)";
//    const auto year_Regex = "(-{4}|\\d-{3}|\\d{2}-{2}|\\d{3}-|\\d{4})";
//
//    //Default date format: MMM-dd-yyyy
//    auto month_Text = "getText(0,3)";
//    auto day_Text = "getText(4,6)";
//    auto year_Text = "getText(7,11)";
//    std::string DateRegex = RendererQml::Formatter() << "/^" << month_Regex << dateSeparator << day_Regex << dateSeparator << year_Regex << "$/";
//    mDateFormat = RendererQml::Formatter() << "MMM" << dateSeparator << "dd" << dateSeparator << "yyyy";
//    std::string inputMask = RendererQml::Formatter() << ">x<xx" << dateSeparator << "xx" << dateSeparator << "xxxx;-";
//
//    switch (EnumDateFormat)
//    {
//    case RendererQml::DateFormat::ddmmyy:
//    {
//        mDateFormat = RendererQml::Formatter() << "dd" << dateSeparator << "MMM" << dateSeparator << "yyyy";
//        inputMask = RendererQml::Formatter() << "xx" << dateSeparator << ">x<xx" << dateSeparator << "xxxx;-";
//        DateRegex = RendererQml::Formatter() << "/^" << day_Regex << dateSeparator << month_Regex << dateSeparator << year_Regex << "$/";
//
//        day_Text = "getText(0,2)";
//        month_Text = "getText(3,6)";
//        year_Text = "getText(7,11)";
//        break;
//    }
//    case RendererQml::DateFormat::yymmdd:
//    {
//        mDateFormat = RendererQml::Formatter() << "yyyy" << dateSeparator << "MMM" << dateSeparator << "dd";
//        inputMask = RendererQml::Formatter() << "xxxx" << dateSeparator << ">x<xx" << dateSeparator << "xx;-";
//        DateRegex = RendererQml::Formatter() << "/^" << year_Regex << dateSeparator << month_Regex << dateSeparator << day_Regex << "$/";
//
//        day_Text = "getText(9,11)";
//        month_Text = "getText(5,8)";
//        year_Text = "getText(0,4)";
//        break;
//    }
//    case RendererQml::DateFormat::yyddmm:
//    {
//        mDateFormat = RendererQml::Formatter() << "yyyy" << dateSeparator << "dd" << dateSeparator << "MMM";
//        inputMask = RendererQml::Formatter() << "xxxx" << dateSeparator << "xx" << dateSeparator << ">x<xx;-";
//        DateRegex = RendererQml::Formatter() << "/^" << year_Regex << dateSeparator << day_Regex << dateSeparator << month_Regex << "$/";
//
//        day_Text = "getText(5,7)";
//        month_Text = "getText(8,11)";
//        year_Text = "getText(0,4)";
//        break;
//    }
//    //Default case: mm-dd-yyyy
//    default:
//    {
//        break;
//    }
//    }
//
//    mDateInputTextField->AddFunctions(RendererQml::Formatter() << "function setValidDate(dateString)"
//        << "{"
//        << "var Months = {Jan: 0,Feb: 1,Mar: 2,Apr: 3,May: 4,Jun: 5,Jul: 6,Aug: 7,Sep: 8,Oct: 9,Nov: 10,Dec: 11};"
//        << "var d=new Date(" << year_Text << "," << "Months[" << month_Text << "]," << day_Text << ");"
//        << "if( d.getFullYear().toString() === " << year_Text << "&& d.getMonth()===Months[" << month_Text << "] && parseInt(d.getDate().toString())===parseInt(" << day_Text << "))"
//        << "{selectedDate = d.toLocaleString(Qt.locale(\"en_US\"),\"yyyy-MM-dd\");}"
//        << "else { selectedDate = '';};"
//        << "Accessible.name = getAccessibleName();"
//        << "}");
//
//    mDateInputTextField->AddFunctions(getAccessibleName());
//
//    mDateInputTextField->Property("onTextChanged", RendererQml::Formatter() << "{textChanged" << mDateInputTextField->GetId() << "(text); setValidDate(text);}");
//    mDateInputTextField->Property("onActiveFocusChanged", "{if(activeFocus){Accessible.name = getAccessibleName();cursorPosition=0;}}");
//
    //if (!mDateInput->GetValue().empty() && RendererQml::Utils::isValidDate(mDateInput->GetValue()))
    //{
    //    mDateInputTextField->Property("text", RendererQml::Formatter() << RendererQml::Utils::GetDate(mDateInput->GetValue()) << ".toLocaleString(Qt.locale(\"en_US\"),"
    //        << "\"" << mDateFormat << "\""
    //        << ")");
    //}
//
//    mDateInputTextField->Property("validator", RendererQml::Formatter() << "RegExpValidator { regExp: " << DateRegex << "}");
//    mDateInputTextField->Property("onFocusChanged", RendererQml::Formatter() << "{"
//        << "if(focus===true) {inputMask=\"" << inputMask << "\";}"
//        << "if(focus === false){ "
//        << "if(text === \"" << std::string(dateSeparator) + std::string(dateSeparator) << "\"){ inputMask = \"\" ; } "
//        << "}} ");
//
//    auto dateFormat = mDateFormat;
//    mDateInputTextField->Property("placeholderText", RendererQml::Formatter() << "String.raw`" << (!mDateInput->GetPlaceholder().empty() ? mEscapedPlaceHolderString : "Select date") << " in ` + '" << RendererQml::Utils::ToLower(dateFormat) << "'");
//    mDateInputTextField->Property("placeholderTextColor", mContext->GetHexColor(mDateConfig.placeHolderColor));
//}

//
//void DateInputElement::initDateInputWrapper()
//{
//    mContext->addHeightEstimate(mDateConfig.height);
//    mDateInputWrapper = std::make_shared<RendererQml::QmlTag>("Rectangle");
//
//    mDateInputWrapper->Property("id", mDateInputWrapperId);
//    mDateInputWrapper->Property("width", "parent.width");
//    mDateInputWrapper->Property("height", RendererQml::Formatter() << mDateConfig.height);
//    mDateInputWrapper->Property("radius", RendererQml::Formatter() << mDateConfig.borderRadius);
//    mDateInputWrapper->Property("color", mContext->GetHexColor(mDateConfig.backgroundColorNormal));
//    mDateInputWrapper->Property("border.color", RendererQml::Formatter() << mDateFieldId << ".activeFocus? " << mContext->GetHexColor(mDateConfig.borderColorOnFocus) << " : " << mContext->GetHexColor(mDateConfig.borderColorNormal));
//    mDateInputWrapper->Property("border.width", RendererQml::Formatter() << mDateConfig.borderWidth);
//    mDateInputWrapper->AddFunctions(getColorFunction());
//}
//
//void DateInputElement::initDateInputComboBox()
//{
//    mDateInputCombobox = std::make_shared<RendererQml::QmlTag>("ComboBox");
//
//    initCalendar();
//    mDateInputCalendar->Property("onClosed", RendererQml::Formatter() << mDateFieldId << ".forceActiveFocus()");
//
//    mDateInputCombobox->Property("id", mDateInputComboboxId);
//    mDateInputCombobox->Property("Layout.fillWidth", "true");
//    mDateInputCombobox->Property("popup", mDateInputCalendar->ToString());
//    mDateInputCombobox->Property("indicator", "Rectangle{}");
//    mDateInputCombobox->Property("focusPolicy", "Qt.NoFocus");
//    mDateInputCombobox->Property("Keys.onReturnPressed", RendererQml::Formatter() << "{setFocusBackOnClose(" << mDateInputComboboxId << ");this.popup.open();}");
//
//    mDateInputTextField->Property("onPressed", RendererQml::Formatter() << "{" << mDateInputWrapperId << ".colorChange(true);event.accepted = true;}");
//    mDateInputTextField->Property("onReleased", RendererQml::Formatter() << "{" << mDateInputWrapperId << ".colorChange(false);forceActiveFocus();event.accepted = true;}");
//    mDateInputTextField->Property("onHoveredChanged", RendererQml::Formatter() << mDateInputWrapperId << ".colorChange(false)");
//    mDateInputCombobox->Property("onActiveFocusChanged", RendererQml::Formatter() << mDateInputWrapperId << ".colorChange(false)");
//
//    addValidation();
//    mDateInputCombobox->Property("background", mDateInputTextField->ToString());
//}
//
//void DateInputElement::initCalendar()
//{
//    auto backgroundRectangle = std::make_shared<RendererQml::QmlTag>("Rectangle");
//    backgroundRectangle->Property("radius", RendererQml::Formatter() << mDateConfig.calendarBorderRadius);
//    backgroundRectangle->Property("border.color", mContext->GetHexColor(mDateConfig.calendarBorderColor));
//    backgroundRectangle->Property("color", mContext->GetHexColor(mDateConfig.calendarBackgroundColor));
//
//    auto listviewCalendar = getCalendarListView();
//
//    mDateInputCalendar = std::make_shared<RendererQml::QmlTag>("Popup");
//    mDateInputCalendar->Property("id", mCalendarBoxId);
//    mDateInputCalendar->Property("y", RendererQml::Formatter() << mDateFieldId << ".height + 2");
//    mDateInputCalendar->Property("x", RendererQml::Formatter() << "-" << mDateConfig.clearIconSize << "-" << mDateConfig.dateIconHorizontalPadding);
//    mDateInputCalendar->Property("width", RendererQml::Formatter() << mDateConfig.calendarWidth);
//    mDateInputCalendar->Property("height", RendererQml::Formatter() << mDateConfig.calendarHeight);
//    mDateInputCalendar->Property("bottomInset", "0");
//    mDateInputCalendar->Property("topInset", "0");
//    mDateInputCalendar->Property("rightInset", "0");
//    mDateInputCalendar->Property("leftInset", "0");
//    mDateInputCalendar->Property("background", backgroundRectangle->ToString());
//    mDateInputCalendar->Property("onOpened", RendererQml::Formatter() << listviewCalendar->GetId() << ".forceActiveFocus()");
//
//    auto listViewDelegate = getCalendarListViewDelegate(listviewCalendar->GetId());
//    listviewCalendar->Property("delegate", listViewDelegate->ToString());
//
//    auto contentItemRectangle = std::make_shared<RendererQml::QmlTag>("Rectangle");
//    contentItemRectangle->Property("radius", RendererQml::Formatter() << mDateConfig.calendarBorderRadius);
//    contentItemRectangle->Property("color", mContext->GetHexColor(mDateConfig.calendarBackgroundColor));
//    contentItemRectangle->AddChild(listviewCalendar);
//
//    auto leftArrowButton = getArrowIconButton("leftArrow", listviewCalendar->GetId());
//    auto rightArrowButton = getArrowIconButton("rightArrow", listviewCalendar->GetId());
//
//    leftArrowButton->Property("KeyNavigation.tab", rightArrowButton->GetId());
//    leftArrowButton->Property("KeyNavigation.backtab", listviewCalendar->GetId());
//
//    rightArrowButton->Property("KeyNavigation.tab", listviewCalendar->GetId());
//    rightArrowButton->Property("KeyNavigation.backtab", leftArrowButton->GetId());
//
//    listviewCalendar->Property("Keys.onPressed", RendererQml::Formatter() << "{"
//        << "var date = new Date(selectedDate);"
//        << "if (event.key === Qt.Key_Right)"
//        << "date.setDate(date.getDate() + 1);"
//        << "else if (event.key === Qt.Key_Left)"
//        << "date.setDate(date.getDate() - 1);"
//        << "else if (event.key === Qt.Key_Up)"
//        << "date.setDate(date.getDate() - 7);"
//        << "else if (event.key === Qt.Key_Down)"
//        << "date.setDate(date.getDate() + 7);"
//        << "else if (event.key === Qt.Key_Return)"
//        << "{"
//        << mDateFieldId << ".text = selectedDate.toLocaleString(Qt.locale(\"en_US\"), \"" << mDateFormat << "\");"
//        << mCalendarBoxId << ".close();"
//        << "}"
//        << "else if (event.key === Qt.Key_Tab) {"
//        << leftArrowButton->GetId() << ".forceActiveFocus()}"
//        << "else if (event.key === Qt.Key_Backtab) {"
//        << rightArrowButton->GetId() << ".forceActiveFocus()}"
//        << "if (date >= minimumDate && date <= maximumDate)"
//        << "{"
//        << "selectedDate = new Date(date);"
//        << "currentIndex = (selectedDate.getFullYear()) * 12 + selectedDate.getMonth();"
//        << "}"
//        << listviewCalendar->GetId() << ".accessibilityPrefix = '';getDateForSC(selectedDate);"
//        << "event.accepted = true}");
//
//    mDateInputCalendar->AddChild(rightArrowButton);
//    mDateInputCalendar->AddChild(leftArrowButton);
//    mDateInputCalendar->Property("contentItem", contentItemRectangle->ToString());
//}
//
//std::shared_ptr<RendererQml::QmlTag> DateInputElement::getCalendarListView()
//{
//    const std::vector<int>upperDateLimit{ 3000,0,1 };
//    const std::vector<int>lowerDateLimit{ 0,0,1 };
//
//    if (!mDateInput->GetMin().empty() && RendererQml::Utils::isValidDate(mDateInput->GetMin()))
//    {
//        mMinimumDate = RendererQml::Utils::GetDate(mDateInput->GetMin());
//    }
//
//    if (!mDateInput->GetMax().empty() && RendererQml::Utils::isValidDate(mDateInput->GetMax()))
//    {
//        mMaximumDate = RendererQml::Utils::GetDate(mDateInput->GetMax());
//    }
//
//    auto listviewCalendar = std::make_shared<RendererQml::QmlTag>("ListView");
//    listviewCalendar->Property("property int curCalendarYear", "0");
//    listviewCalendar->Property("property int curCalendarMonth", "0");
//    listviewCalendar->Property("property date minimumDate", mMinimumDate != "" ? mMinimumDate : RendererQml::Formatter() << "new Date(" << std::to_string(lowerDateLimit.at(0)) << "," << std::to_string(lowerDateLimit.at(1)) << "," << std::to_string(lowerDateLimit.at(2)) << ")");
//    listviewCalendar->Property("property date maximumDate", mMaximumDate != "" ? mMaximumDate : RendererQml::Formatter() << "new Date(" << std::to_string(upperDateLimit.at(0)) << "," << std::to_string(upperDateLimit.at(1)) << "," << std::to_string(upperDateLimit.at(2)) << ")");
//    listviewCalendar->Property("property date selectedDate", "new Date()");
//    listviewCalendar->Property("property string accessibilityPrefix", "Date Picker. The current date is", true);
//    listviewCalendar->Property("property string dateForSc", "''");
//
//    listviewCalendar->Property("id", RendererQml::Formatter() << mDateFieldId << "_calendarRoot");
//
//    listviewCalendar->Property("anchors.fill", "parent");
//    listviewCalendar->AddFunctions("signal clicked(date clickedDate)");
//
//    listviewCalendar->AddFunctions(RendererQml::Formatter() << "function setDate(clickedDate)" << "{"
//        << "selectedDate = clickedDate;"
//        << "curCalendarYear = selectedDate.getFullYear();"
//        << "curCalendarMonth = selectedDate.getMonth();"
//        << "var curIndex = (selectedDate.getFullYear()) * 12 + selectedDate.getMonth();"
//        << "currentIndex = curIndex;"
//        << "positionViewAtIndex(curIndex, ListView.Center);" << "getDateForSC(clickedDate); }");
//
//    listviewCalendar->AddFunctions(RendererQml::Formatter() << "function setCalendarDateFromString(dateString)"
//        << "{"
//        << "var Months = {Jan: 0,Feb: 1,Mar: 2,Apr: 3,May: 4,Jun: 5,Jul: 6,Aug: 7,Sep: 8,Oct: 9,Nov: 10,Dec: 11};"
//        << "var y=dateString.match(/[0-9]{4}/);"
//        << "dateString=dateString.replace(y,\"\");"
//        << "var m=dateString.match(/[a-zA-Z]{3}/);"
//        << "var d=dateString.match(/[0-9]{2}/);"
//        << "if (d!==null && m!==null && y!==null){selectedDate=new Date(y[0],Months[m[0]],d[0]);}"
//        << "setDate(selectedDate);"
//        << "}");
//
//    listviewCalendar->AddFunctions(RendererQml::Formatter() << "function getDateForSC(clickedDate)"
//        << "{"
//        << "var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];"
//        << "var d = clickedDate.getDate();"
//        << "var m = months[clickedDate.getMonth()];"
//        << "var y = clickedDate.getFullYear();"
//        << listviewCalendar->GetId() << ".dateForSc = m + ' ' + d + ' ' + y;"
//        << "}");
//
//    listviewCalendar->Property("Component.onCompleted", RendererQml::Formatter() << "{"
//        << mDateFieldId << "." << "textChanged" << mDateFieldId << ".connect(setCalendarDateFromString);"
//        << mDateFieldId << "." << "textChanged" << mDateFieldId << "( " << mDateFieldId << ".text);"
//        << "if (selectedDate < minimumDate) { selectedDate = minimumDate;}"
//        << "else if (selectedDate > maximumDate) { selectedDate = maximumDate;}"
//        << "}");
//
//    listviewCalendar->Property("snapMode", "ListView.SnapOneItem");
//    listviewCalendar->Property("orientation", "Qt.Horizontal");
//    listviewCalendar->Property("clip", "true");
//    listviewCalendar->Property("model", std::to_string((upperDateLimit.at(0) - lowerDateLimit.at(0)) * 12));
//    listviewCalendar->Property("onClicked", RendererQml::Formatter() << "{" << "setDate(clickedDate)" << "}");
//
//    return listviewCalendar;
//}
//
//std::shared_ptr<RendererQml::QmlTag> DateInputElement::getCalendarListViewDelegate(const std::string listViewId)
//{
//    auto listViewDelegate = std::make_shared<RendererQml::QmlTag>("Item");
//    listViewDelegate->Property("id", RendererQml::Formatter() << mDateFieldId << "listViewDelegate");
//    listViewDelegate->Property("property int year", "Math.floor(index/12)");
//    listViewDelegate->Property("property int month", "index%12");
//    listViewDelegate->Property("property int firstDay", "(new Date(year, month, 1).getDay()-1 < 0 ? 6 : new Date(year, month, 1).getDay() - 1)");
//    listViewDelegate->Property("width", RendererQml::Formatter() << listViewId << ".width");
//    listViewDelegate->Property("height", RendererQml::Formatter() << listViewId << ".height");
//
//    auto headerText = std::make_shared<RendererQml::QmlTag>("Text");
//    headerText->Property("id", RendererQml::Formatter() << mDateFieldId << "headerText");
//    headerText->Property("anchors.left", "parent.left");
//    headerText->Property("color", mContext->GetHexColor(mDateConfig.textColor));
//    headerText->Property("text", RendererQml::Formatter() << "['January', 'February', 'March', 'April', 'May', 'June','July', 'August', 'September', 'October', 'November', 'December'][" << listViewDelegate->GetId() << ".month] + ' ' + " << listViewDelegate->GetId() << ".year");
//    headerText->Property("font.pixelSize", RendererQml::Formatter() << mDateConfig.calendarHeaderTextSize);
//    listViewDelegate->AddChild(headerText);
//
//    auto monthGrid = std::make_shared<RendererQml::QmlTag>("Grid");
//    const std::string monthGridId = RendererQml::Formatter() << mDateFieldId << "gridId";
//    monthGrid->Property("id", monthGridId);
//    monthGrid->Property("anchors.top", RendererQml::Formatter() << headerText->GetId() << ".bottom");
//    monthGrid->Property("anchors.right", "parent.right");
//    monthGrid->Property("anchors.left", "parent.left");
//    monthGrid->Property("anchors.bottom", "parent.bottom");
//    monthGrid->Property("anchors.topMargin", RendererQml::Formatter() << mDateConfig.dateGridTopMargin);
//    monthGrid->Property("clip", "true");
//    monthGrid->Property("columns", "7");
//    monthGrid->Property("rows", "7");
//    listViewDelegate->AddChild(monthGrid);
//
//    auto repeaterTag = std::make_shared<RendererQml::QmlTag>("Repeater");
//    repeaterTag->Property("model", RendererQml::Formatter() << monthGridId << ".columns * " << monthGridId << ".rows");
//
//    auto delegateRectangle = std::make_shared<RendererQml::QmlTag>("Rectangle");
//    delegateRectangle->Property("id", RendererQml::Formatter() << mDateFieldId << "delegateRectangle");
//    delegateRectangle->Property("property bool datePickerFocusCheck", RendererQml::Formatter() << listViewId << ".activeFocus && " << listViewId << ".activeFocus && new Date(year,month,date).toDateString() == " << listViewId << ".selectedDate.toDateString()");
//    delegateRectangle->Property("onDatePickerFocusCheckChanged", "{if (datePickerFocusCheck)forceActiveFocus()}");
//    delegateRectangle->Property("Accessible.name", RendererQml::Formatter() << listViewId << ".accessibilityPrefix + " << listViewId << ".dateForSc");
//    delegateRectangle->Property("Accessible.role", "Accessible.NoRole");
//
//    auto delegateMouseArea = std::make_shared<RendererQml::QmlTag>("MouseArea");
//    delegateMouseArea->Property("id", RendererQml::Formatter() << mDateFieldId << "delegateMouseArea");
//
//    auto delegateText = std::make_shared<RendererQml::QmlTag>("Text");
//    delegateText->Property("id", RendererQml::Formatter() << mDateFieldId << "delegateText");
//    delegateText->Property("anchors.centerIn", "parent");
//    delegateText->Property("font.pixelSize", RendererQml::Formatter() << "day < 0 ? " << mDateConfig.calendarDayTextSize << " : " << mDateConfig.calendarDateTextSize);
//
//    delegateText->Property("color", RendererQml::Formatter() << "{"
//        << "if (" << delegateRectangle->GetId() << ".cellDate.toDateString() === " << listViewId << ".selectedDate.toDateString() && " << delegateMouseArea->GetId() << ".enabled)"
//        << "{\"white\";}"
//        << "else if (" << delegateRectangle->GetId() << ".cellDate.getMonth() === " << listViewDelegate->GetId() << ".month && " << delegateMouseArea->GetId() << ".enabled)"
//        << "{" << mContext->GetHexColor(mDateConfig.textColor) << ";}"
//        << "else"
//        << "{" << mContext->GetHexColor(mDateConfig.notAvailabledateElementTextColor) << ";}"
//        << "}");
//
//    delegateText->Property("text", RendererQml::Formatter() << "{" << "if (day < 0){"
//        << delegateRectangle->GetId() << ".dayArray[index]" << ";}"
//        << "else if (new Date(year, month, date).getMonth() == month)" << ""
//        << "{date" << ";}"
//        << "else" << "{cellDate.getDate();}}");
//
//    delegateMouseArea->Property("anchors.fill", "parent");
//    delegateMouseArea->Property("enabled", RendererQml::Formatter() << delegateText->GetId() << ".text &&  day >= 0 && (new Date(year,month,date) >= " << listViewId << ".minimumDate ) && (new Date(year,month,date) <= " << listViewId << ".maximumDate )");
//    delegateMouseArea->Property("hoverEnabled", "true");
//    delegateMouseArea->Property("onClicked", RendererQml::Formatter() << "{"
//        << "var selectedDate = new Date(year, month, date);"
//        << listViewId << ".clicked(selectedDate)" << "}");
//
//    delegateMouseArea->Property("onReleased", RendererQml::Formatter() << "{"
//        << listViewId << ".selectedDate = " << delegateRectangle->GetId() << ".cellDate;"
//        << mDateFieldId << ".text = " << listViewId << ".selectedDate.toLocaleString(Qt.locale(\"en_US\"),\"" << mDateFormat << "\");"
//        << mCalendarBoxId << ".close();"
//        << "}");
//
//    delegateRectangle->Property("property int day", "index - 7");
//    delegateRectangle->Property("property int date", RendererQml::Formatter() << "day - " << listViewDelegate->GetId() << ".firstDay + 1");
//    delegateRectangle->Property("width", RendererQml::Formatter() << mDateConfig.dateElementSize);
//    delegateRectangle->Property("height", RendererQml::Formatter() << mDateConfig.dateElementSize);
//    delegateRectangle->Property("property variant dayArray", "['M', 'T', 'W', 'T', 'F', 'S', 'S']");
//    delegateRectangle->Property("color", RendererQml::Formatter() << "new Date(year,month,date).toDateString() == " << listViewId << ".selectedDate.toDateString() && " << delegateMouseArea->GetId() << ".enabled" << "? " << mContext->GetHexColor(mDateConfig.dateElementColorOnFocus) << " : " << delegateMouseArea->GetId() << ".containsMouse? " << mContext->GetHexColor(mDateConfig.dateElementColorOnHover) << " :" << mContext->GetHexColor(mDateConfig.dateElementColorNormal));
//    delegateRectangle->Property("radius", "0.5 * width");
//    delegateRectangle->Property("property date cellDate", "new Date(year,month,date)");
//
//    auto borderFocusRectangle = std::make_shared<RendererQml::QmlTag>("Rectangle");
//    borderFocusRectangle->Property("width", RendererQml::Formatter() << mDateConfig.dateElementSize);
//    borderFocusRectangle->Property("height", RendererQml::Formatter() << mDateConfig.dateElementSize);
//    borderFocusRectangle->Property("color", "'transparent'");
//    borderFocusRectangle->Property("border.width", RendererQml::Formatter() << listViewId << ".activeFocus && new Date(year,month,date).toDateString() == " << listViewId << ".selectedDate.toDateString() ? 1 : 0");
//    borderFocusRectangle->Property("border.color", mContext->GetHexColor(mDateConfig.calendarBorderColor));
//
//    delegateRectangle->AddChild(borderFocusRectangle);
//    delegateRectangle->AddChild(delegateText);
//    delegateRectangle->AddChild(delegateMouseArea);
//    repeaterTag->Property("delegate", delegateRectangle->ToString());
//
//    monthGrid->AddChild(repeaterTag);
//
//    return listViewDelegate;
//}
//
//std::shared_ptr<RendererQml::QmlTag> DateInputElement::getArrowIconButton(const std::string arrowType, const std::string listViewId)
//{
//    auto iconBackground = std::make_shared<RendererQml::QmlTag>("Rectangle");
//    iconBackground->Property("color", mContext->GetHexColor(mDateConfig.calendarBackgroundColor));
//    iconBackground->Property("border.width", "parent.activeFocus ? 1 : 0");
//    iconBackground->Property("border.color", mContext->GetHexColor(mDateConfig.calendarBorderColor));
//
//    auto arrowButton = RendererQml::AdaptiveCardQmlRenderer::GetIconTag(mContext);
//    arrowButton->Property("id", RendererQml::Formatter() << mDateFieldId << "_" << arrowType);
//    arrowButton->RemoveProperty("anchors.bottom");
//    arrowButton->Property("width", "icon.width");
//    arrowButton->Property("height", "icon.height");
//    arrowButton->Property("icon.width", RendererQml::Formatter() << mDateConfig.arrowIconSize);
//    arrowButton->Property("icon.height", RendererQml::Formatter() << mDateConfig.arrowIconSize);
//    arrowButton->Property("horizontalPadding", "0");
//    arrowButton->Property("verticalPadding", "0");
//    arrowButton->Property("anchors.margins", "0");
//    arrowButton->Property("background", iconBackground->ToString());
//    arrowButton->Property("Keys.onReturnPressed", "onReleased()");
//    arrowButton->Property("Accessible.role", "Accessible.Button");
//
//    std::string setMonthDate = RendererQml::Formatter() << "var tempDate = new Date()\n"
//        << "tempDate.setMonth(" << listViewId << ".curCalendarMonth)\n"
//        << "tempDate.setYear(" << listViewId << ".curCalendarYear)\n"
//        << "tempDate.setDate(1)\n"
//        << listViewId << ".setDate(tempDate);" << listViewId << ".getDateForSC(tempDate)\n";
//
//    std::string onReleased = "";
//
//    if (arrowType == "leftArrow")
//    {
//        arrowButton->Property("anchors.right", RendererQml::Formatter() << mDateFieldId << "_rightArrow" << ".left");
//        arrowButton->Property("icon.source", RendererQml::left_arrow_28, true);
//        arrowButton->Property("Accessible.name", "Previous Month", true);
//        onReleased = RendererQml::Formatter() << "{"
//            << listViewId << ".curCalendarYear = " << listViewId << ".curCalendarMonth - 1 < 0 ? " << listViewId << ".curCalendarYear - 1 : " << listViewId << ".curCalendarYear;"
//            << listViewId << ".curCalendarMonth = " << listViewId << ".curCalendarMonth - 1 < 0 ? 11 : " << listViewId << ".curCalendarMonth - 1;"
//            << listViewId << ".positionViewAtIndex((" << listViewId << ".curCalendarYear) * 12 + (" << listViewId << ".curCalendarMonth), ListView.Center);"
//            << setMonthDate << "}";
//    }
//    else
//    {
//        arrowButton->Property("icon.source", RendererQml::right_arrow_28, true);
//        arrowButton->Property("Accessible.name", "Next Month", true);
//        onReleased = RendererQml::Formatter() << "{"
//            << listViewId << ".curCalendarYear = " << listViewId << ".curCalendarMonth ==11? " << listViewId << ".curCalendarYear + 1 : " << listViewId << ".curCalendarYear;"
//            << listViewId << ".curCalendarMonth = (" << listViewId << ".curCalendarMonth + 1)%12;"
//            << listViewId << ".positionViewAtIndex((" << listViewId << ".curCalendarYear) * 12 + (" << listViewId << ".curCalendarMonth), ListView.Center);"
//            << setMonthDate << "}";
//    }
//
//    arrowButton->Property("onReleased", onReleased);
//
//    return arrowButton;
//}
//
//void DateInputElement::initDateIconButton()
//{
//    mDateIcon = RendererQml::AdaptiveCardQmlRenderer::GetClearIconButton(mContext);
//
//    mDateIcon->RemoveProperty("anchors.right");
//    mDateIcon->RemoveProperty("anchors.margins");
//    mDateIcon->RemoveProperty("anchors.verticalCenter");
//    mDateIcon->Property("id", mDateIconId);
//    mDateIcon->Property("Layout.leftMargin", RendererQml::Formatter() << mDateConfig.dateIconHorizontalPadding);
//    mDateIcon->Property("Layout.alignment", "Qt.AlignVCenter");
//    mDateIcon->Property("focusPolicy", "Qt.NoFocus");
//    mDateIcon->Property("width", "18");
//    mDateIcon->Property("height", "18");
//    mDateIcon->Property("icon.color", RendererQml::Formatter() << mDateFieldId << ".showErrorMessage ? " << mContext->GetHexColor(mDateConfig.dateIconColorOnError) << " : " << mDateFieldId << ".activeFocus ? " << mContext->GetHexColor(mDateConfig.dateIconColorOnFocus) << " : " << mContext->GetHexColor(mDateConfig.dateIconColorNormal));
//    mDateIcon->Property("icon.source", RendererQml::calendar_icon, true);
//    std::string onClicked_value = "{ " + mDateFieldId + ".forceActiveFocus(); " + mCalendarBoxId + ".open();}";
//    mDateIcon->Property("onClicked", onClicked_value);
//}
//
//void DateInputElement::initClearIconButton()
//{
//    mClearIcon = RendererQml::AdaptiveCardQmlRenderer::GetClearIconButton(mContext);
//
//    mClearIcon->RemoveProperty("anchors.right");
//    mClearIcon->RemoveProperty("anchors.margins");
//    mClearIcon->RemoveProperty("anchors.verticalCenter");
//    mClearIcon->Property("id", mClearIconId);
//    mClearIcon->Property("Layout.rightMargin", RendererQml::Formatter() << mDateConfig.clearIconHorizontalPadding);
//    std::string clearIcon_visible_value = RendererQml::Formatter() << "(!" << mDateFieldId << ".focus && " << mDateFieldId << ".text !==\"\") || (" << mDateFieldId << ".focus && " << mDateFieldId << ".text !== " << "\"\\/\\/\")";
//    mClearIcon->Property("visible", clearIcon_visible_value);
//    std::string clearIcon_OnClicked_value = RendererQml::Formatter() << " {"
//        << "nextItemInFocusChain().forceActiveFocus();\n"
//        << mDateFieldId << ".clear();\n" << "}";
//    mClearIcon->Property("onClicked", clearIcon_OnClicked_value);
//    mClearIcon->Property("Accessible.name", "Date Picker clear", true);
//    mClearIcon->Property("Accessible.role", "Accessible.Button");
//}
//
//void DateInputElement::addInputLabel(bool isRequired)
//{
//    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
//    {
//        if (!mDateInput->GetLabel().empty())
//        {
//            mContext->addHeightEstimate(mContext->getEstimatedTextHeight(mDateInput->GetLabel()));
//            auto label = std::make_shared<RendererQml::QmlTag>("Label");
//            label->Property("id", RendererQml::Formatter() << mDateInputElement->GetId() << "_label");
//            label->Property("wrapMode", "Text.Wrap");
//            label->Property("width", "parent.width");
//
//            std::string color = mContext->GetColor(AdaptiveCards::ForegroundColor::Default, false, false);
//            label->Property("color", color);
//            label->Property("font.pixelSize", RendererQml::Formatter() << mDateConfig.labelSize);
//            label->Property("Accessible.ignored", "true");
//
//            if (isRequired)
//            {
//                label->Property("text", RendererQml::Formatter() << "String.raw`" << (mDateInput->GetLabel().empty() ? "Text" : mEscapedLabelString) << " <font color='" << mDateConfig.errorMessageColor << "'>*</font>`");
//            }
//            else
//            {
//                label->Property("text", RendererQml::Formatter() << "String.raw`" << (mDateInput->GetLabel().empty() ? "Text" : mEscapedLabelString) << "`");
//            }
//
//            mDateInputElement->AddChild(label);
//        }
//        else
//        {
//            if (mDateInput->GetIsRequired())
//            {
//                mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "isRequired is not supported without labels"));
//            }
//        }
//    }
//}
//
//void DateInputElement::addErrorMessage()
//{
//    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
//    {
//        if (!mDateInput->GetErrorMessage().empty())
//        {
//            auto uiErrorMessage = std::make_shared<RendererQml::QmlTag>("Label");
//            uiErrorMessage->Property("id", RendererQml::Formatter() << mDateInputElement->GetId() << "_errorMessage");
//            uiErrorMessage->Property("wrapMode", "Text.Wrap");
//            uiErrorMessage->Property("width", "parent.width");
//            uiErrorMessage->Property("font.pixelSize", RendererQml::Formatter() << mDateConfig.labelSize);
//            uiErrorMessage->Property("Accessible.ignored", "true");
//
//            uiErrorMessage->Property("color", mContext->GetHexColor(mDateConfig.errorMessageColor));
//            uiErrorMessage->Property("text", RendererQml::Formatter() << "String.raw`" << mEscapedErrorString << "`");
//            uiErrorMessage->Property("visible", RendererQml::Formatter() << mDateFieldId << ".showErrorMessage");
//            mDateInputElement->AddChild(uiErrorMessage);
//        }
//    }
//}
//
//void DateInputElement::addValidation()
//{
//    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
//    {
//        if (mDateInput->GetIsVisible())
//        {
//            mContext->addToRequiredInputElementsIdList(mDateFieldId);
//        }
//        mDateInputTextField->Property("property bool showErrorMessage", "false");
//
//        std::ostringstream validator;
//        std::string condition;
//
//        if (mDateInput->GetIsRequired())
//        {
//            condition  = RendererQml::Formatter() << "var isValid = (" << mDateFieldId << ".selectedDate !== '' && (" << mDateFieldId << "_calendarRoot.selectedDate >= " << mDateFieldId << "_calendarRoot.minimumDate) && (" << mDateFieldId << "_calendarRoot.selectedDate <= " << mDateFieldId << "_calendarRoot.maximumDate));";
//        }
//        else
//        {
//            condition = RendererQml::Formatter() << "var isValid = true; if(selectedDate !== ''){isValid = ((" << mDateFieldId << "_calendarRoot.selectedDate >= " << mDateFieldId << "_calendarRoot.minimumDate) && (" << mDateFieldId << "_calendarRoot.selectedDate <= " << mDateFieldId << "_calendarRoot.maximumDate)); }";
//        }
//
//        validator << "function validate(){"
//            << condition
//            << "if(showErrorMessage){"
//            << "if(isValid){"
//            << "showErrorMessage = false;"
//            << "}}"
//            << "return !isValid;}";
//
//        mDateInputTextField->AddFunctions(validator.str());
//        mDateInputTextField->Property("onSelectedDateChanged", "validate()");
//        mDateInputTextField->Property("onShowErrorMessageChanged", RendererQml::Formatter() << mDateInputWrapperId<< ".colorChange(false)");
//        mDateInputWrapper->Property("border.color", RendererQml::Formatter() << mDateFieldId << ".showErrorMessage ? " << mContext->GetHexColor(mDateConfig.borderColorOnError) << " : " << mDateFieldId << ".activeFocus? " << mContext->GetHexColor(mDateConfig.borderColorOnFocus) << " : " << mContext->GetHexColor(mDateConfig.borderColorNormal));
//    }
//}
//
//const std::string DateInputElement::getColorFunction()
//{
//    std::ostringstream colorFunction;
//
//    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
//    {
//        colorFunction << "function colorChange(isPressed){"
//            "if (isPressed && !" << mDateFieldId << ".showErrorMessage)  color = " << mContext->GetHexColor(mDateConfig.backgroundColorOnPressed) << ";"
//            "else color = " << mDateFieldId << ".showErrorMessage ? " << mContext->GetHexColor(mDateConfig.backgroundColorOnError) << " : " << mDateFieldId << ".activeFocus ? " << mContext->GetHexColor(mDateConfig.backgroundColorOnPressed) << " : " << mDateFieldId << ".hovered ? " << mContext->GetHexColor(mDateConfig.backgroundColorOnHovered) << " : " << mContext->GetHexColor(mDateConfig.backgroundColorNormal) << "}";
//    }
//    else
//    {
//        colorFunction << "function colorChange(isPressed){"
//            "if (isPressed)  color = " << mContext->GetHexColor(mDateConfig.backgroundColorOnPressed) << ";"
//            "else color = " << mDateFieldId << ".activeFocus ? " << mContext->GetHexColor(mDateConfig.backgroundColorOnPressed) << " : " << mDateFieldId << ".hovered ? " << mContext->GetHexColor(mDateConfig.backgroundColorOnHovered) << " : " << mContext->GetHexColor(mDateConfig.backgroundColorNormal) << "}";
//    }
//
//    return colorFunction.str();
//}
//
//const std::string DateInputElement::getAccessibleName()
//{
//    std::ostringstream accessibleName;
//    std::ostringstream labelString;
//    std::ostringstream errorString;
//    std::ostringstream placeHolderString;
//
//    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
//    {
//        if (!mDateInput->GetLabel().empty())
//        {
//            labelString << "accessibleName += String.raw`" << mEscapedLabelString << ". `;";
//        }
//
//        if (!mDateInput->GetErrorMessage().empty())
//        {
//            errorString << "if(" << mDateFieldId << ".showErrorMessage === true){"
//                << "accessibleName += String.raw`Error. " << mEscapedErrorString << ". `;}";
//        }
//    }
//
//    placeHolderString << "if(" << mDateFieldId << ".selectedDate !== ''){"
//        << "accessibleName += (" << mDateFieldId << "_calendarRoot.selectedDate.toLocaleDateString() + '. ');"
//        << "}else{"
//        << "accessibleName += placeholderText;}";
//
//    accessibleName << "function getAccessibleName(){"
//        << "let accessibleName = '';" << errorString.str() << labelString.str() << placeHolderString.str() << "return accessibleName;}";
//
//    return accessibleName.str();
//}
