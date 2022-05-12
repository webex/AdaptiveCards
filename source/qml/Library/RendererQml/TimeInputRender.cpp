#include "TimeInputRender.h"
#include "Formatter.h"
#include "ImageDataURI.h"
#include "Utils.h"

TimeInputElement::TimeInputElement(std::shared_ptr<AdaptiveCards::TimeInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context)
    :mTimeInput(input),
    mContext(context),
    mTimeInputConfig(context->GetRenderConfig()->getInputTimeConfig()),
    mIs12hour(RendererQml::Utils::isSystemTime12Hour())
{
    initialize();
}

std::shared_ptr<RendererQml::QmlTag> TimeInputElement::getQmlTag()
{
    return mTimeInputColElement;
}

void TimeInputElement::initialize()
{
    origionalElementId = mTimeInput->GetId();
    mTimeInput->SetId(mContext->ConvertToValidId(mTimeInput->GetId()));
    id = mTimeInput->GetId();

    mEscapedPlaceholderString = RendererQml::Utils::getBackQuoteEscapedString(mTimeInput->GetPlaceholder());

    timePopupId = id + "_timeBox";
    listViewHoursId = id + "_hours";
    listViewMinId = id + "_min";
    listViewttId = id + "_tt";
    timeComboboxId = id + "_combobox";

    mTimeInputColElement = std::make_shared<RendererQml::QmlTag>("Column");
    mTimeInputColElement->Property("id", RendererQml::Formatter() << id << "_column");
    mTimeInputColElement->Property("spacing", RendererQml::Formatter() << RendererQml::Utils::GetSpacing(mContext->GetConfig()->GetSpacing(), AdaptiveCards::Spacing::Small));
    mTimeInputColElement->Property("width", "parent.width");
    mTimeInputColElement->Property("visible", mTimeInput->GetIsVisible() ? "true" : "false");

    addInputLabel(mTimeInput->GetIsRequired());
    renderTimeElement();
    addErrorMessage();
}

void TimeInputElement::renderTimeElement()
{
    initTimeInputWrapper();
    initTimeInputTextField();
    initTimeIcon();
    initClearIcon();
    initTimeInputPopup();
    initTimeInputComboBox();
    initTimeInputRow();

    mTimeInputWrapper->AddChild(mTimeInputRow);

    mContext->addToInputElementList(origionalElementId, (id + ".selectedTime"));

    mTimeInputColElement->AddChild(mTimeInputWrapper);
}

void TimeInputElement::initTimeInputWrapper()
{
    mTimeInputWrapper = std::make_shared<RendererQml::QmlTag>("Rectangle");
    mTimeInputWrapper->Property("id", RendererQml::Formatter() << id << "_wrapper");
    mTimeInputWrapper->Property("width", "parent.width");
    mTimeInputWrapper->Property("height", RendererQml::Formatter() << mTimeInputConfig.height);
    mTimeInputWrapper->Property("radius", RendererQml::Formatter() << mTimeInputConfig.borderRadius);
    mTimeInputWrapper->Property("color", mContext->GetHexColor(mTimeInputConfig.backgroundColorNormal));
    mTimeInputWrapper->Property("border.color", RendererQml::Formatter() << id << ".activeFocus? " << mContext->GetHexColor(mTimeInputConfig.borderColorOnFocus) << " : " << mContext->GetHexColor(mTimeInputConfig.borderColorNormal));
    mTimeInputWrapper->Property("border.width", RendererQml::Formatter() << mTimeInputConfig.borderWidth);
    mTimeInputWrapper->AddFunctions(getColorFunction());
}

void TimeInputElement::initTimeInputTextField()
{
    mTimeInputTextField = std::make_shared<RendererQml::QmlTag>("TextField");
    const std::string value = mTimeInput->GetValue();

    mTimeInputTextField->Property("id", id);
    mTimeInputTextField->Property("font.family", mContext->GetConfig()->GetFontFamily(AdaptiveCards::FontType::Default), true);
    mTimeInputTextField->Property("font.pixelSize", RendererQml::Formatter() << mTimeInputConfig.pixelSize);
    mTimeInputTextField->Property("selectByMouse", "true");
    mTimeInputTextField->Property("selectedTextColor", "'white'");
    mTimeInputTextField->Property("property string selectedTime", "", true);
    mTimeInputTextField->Property("width", "parent.width");

    mTimeInputTextField->Property("placeholderTextColor", mContext->GetHexColor(mTimeInputConfig.placeHolderColor));
    mTimeInputTextField->Property("placeholderText", RendererQml::Formatter() << "String.raw`" << (!mTimeInput->GetPlaceholder().empty() ? mEscapedPlaceholderString : "Select time") << "`");
    mTimeInputTextField->Property("color", mContext->GetHexColor(mTimeInputConfig.textColor));

    mTimeInputTextField->Property("onPressed", RendererQml::Formatter() << "{" << mTimeInputWrapper->GetId() << ".colorChange(true);event.accepted = true;}");
    mTimeInputTextField->Property("onReleased", RendererQml::Formatter() << "{" << mTimeInputWrapper->GetId() << ".colorChange(false);forceActiveFocus();event.accepted = true;}");
    mTimeInputTextField->Property("onHoveredChanged", RendererQml::Formatter() << mTimeInputWrapper->GetId() << ".colorChange(false)");

    mTimeInputTextField->Property("leftPadding", RendererQml::Formatter() << mTimeInputConfig.textHorizontalPadding);
    mTimeInputTextField->Property("rightPadding", RendererQml::Formatter() << mTimeInputConfig.textHorizontalPadding);
    mTimeInputTextField->Property("topPadding", RendererQml::Formatter() << mTimeInputConfig.textVerticalPadding);
    mTimeInputTextField->Property("bottomPadding", RendererQml::Formatter() << mTimeInputConfig.textVerticalPadding);

    mTimeInputTextField->Property("Accessible.name", "", true);
    mTimeInputTextField->Property("Accessible.role", "Accessible.EditableText");

    mTimeInputTextField->Property("Keys.onReleased", RendererQml::Formatter() << "{"
        "if (event.key === Qt.Key_Escape)\n"
        "{event.accepted = true}\n}");

    mTimeInputTextField->Property("validator", "RegExpValidator { regExp: /^(--|[01][0-9|-]|2[0-3|-]):(--|[0-5][0-9|-])$/}");
    mTimeInputTextField->AddFunctions(getAccessibleName());

    if (!mTimeInput->GetValue().empty() && RendererQml::Utils::isValidTime(value))
    {
        std::string defaultTime = value;
        std::string defaultSelectedTime = value;
        if (mIs12hour == true)
        {
            defaultTime = RendererQml::Utils::defaultTimeto12hour(defaultTime);
            defaultSelectedTime = RendererQml::Utils::defaultTimeto24hour(defaultSelectedTime);
        }
        else
        {
            defaultTime = defaultSelectedTime = RendererQml::Utils::defaultTimeto24hour(defaultTime);
        }
        mTimeInputTextField->Property("text", defaultTime, true);
        mTimeInputTextField->Property("property string selectedTime", defaultSelectedTime, true);
    }

    mTimeInputTextField->Property("property string minTime", mTimeInput->GetMin().empty() ? "00:00" : mTimeInput->GetMin(), true);
    mTimeInputTextField->Property("property string maxTime", mTimeInput->GetMax().empty() ? "23:59" : mTimeInput->GetMax(), true);

    mTimeInputTextField->Property("onFocusChanged", RendererQml::Formatter() << "{ if (focus===true) inputMask=\"xx:xx;-\";"
        << " if(focus===false){ " << "if(text===\":\") { inputMask=\"\" }" << "}}");

    mTimeInputTextField->Property("onTextChanged", RendererQml::Formatter() << "{" << listViewHoursId << ".currentIndex=parseInt(getText(0,2));" << listViewMinId << ".currentIndex=parseInt(getText(3,5));" << "if(getText(0,2) === '--' || getText(3,5) === '--'){" << id << ".selectedTime ='';} else{" << id << ".selectedTime =" << id << ".text;}}");

    mTimeInputTextField->Property("onActiveFocusChanged",
        RendererQml::Formatter() << "{"
        << "if(activeFocus){"
        << "onTextChanged();"
        << "Accessible.name = getAccessibleName();"
        << "cursorPosition = 0;"
        << "}}");

    mTimeInputTextField->Property("activeFocusOnTab", "true");

    auto backgroundTag = std::make_shared<RendererQml::QmlTag>("Rectangle");
    backgroundTag->Property("color", "'transparent'");
    mTimeInputTextField->Property("background", backgroundTag->ToString());
}

void TimeInputElement::initTimeInputComboBox()
{
    mTimeInputComboBox = std::make_shared<RendererQml::QmlTag>("ComboBox");
    mTimeInputComboBox->Property("id", RendererQml::Formatter() << id << "_combobox");

    mTimeInputComboBox->Property("Layout.fillWidth", "true");
    mTimeInputComboBox->Property("Keys.onReturnPressed", RendererQml::Formatter() << "{setFocusBackOnClose(" << mTimeInputComboBox->GetId() << ");" << timePopupId << ".open();}");
    mTimeInputComboBox->Property("focusPolicy", "Qt.NoFocus");
    mTimeInputComboBox->Property("onActiveFocusChanged", RendererQml::Formatter() << mTimeInputWrapper->GetId() << ".colorChange(false)");
    mTimeInputComboBox->Property("Accessible.ignored", "true");
    mTimeInputComboBox->Property("indicator", "Rectangle{}");

    addValidation();
    mTimeInputComboBox->Property("popup", mTimeInputPopup->ToString());
    mTimeInputComboBox->Property("background", mTimeInputTextField->ToString());
}

std::shared_ptr<RendererQml::QmlTag> TimeInputElement::getListViewTagforTimeInput(const std::string& parent_id, const std::string& listView_id, std::map<std::string, std::map<std::string, std::string>>& properties, bool isThirdTag, std::shared_ptr<RendererQml::AdaptiveRenderContext> context)
{
    auto ListViewTag = std::make_shared<RendererQml::QmlTag>("ListView");
    ListViewTag->Property("id", listView_id);

    //TODO:Avoid fixed values inside ListView
    ListViewTag->Property("width", RendererQml::Formatter() << mTimeInputConfig.timePickerHoursAndMinutesTagWidth);
    ListViewTag->Property("height", RendererQml::Formatter() << "parent.height-" << mTimeInputConfig.timePickerMargins);
    ListViewTag->Property("spacing", RendererQml::Formatter() << mTimeInputConfig.timePickerSpacing);
    ListViewTag->Property("flickableDirection", "Flickable.VerticalFlick");
    ListViewTag->Property("boundsBehavior", "Flickable.StopAtBounds");
    ListViewTag->Property("clip", "true");


    //Elements inside delegate: Rectangle{ Text{} MouseArea{} }
    std::string MouseArea_id = listView_id + "mouseArea";
    auto MouseAreaTag = std::make_shared<RendererQml::QmlTag>("MouseArea");
    MouseAreaTag->Property("id", MouseArea_id);
    MouseAreaTag->Property("anchors.fill", "parent");
    MouseAreaTag->Property("enabled", "true");
    MouseAreaTag->Property("hoverEnabled", "true");
    MouseAreaTag->Property("onClicked", RendererQml::Formatter() << "{" << listView_id << ".currentIndex=index;" << "var x=String(index).padStart(2, '0') ;" << parent_id << ".insert(0,x);" << "}");

    auto TextTag = std::make_shared<RendererQml::QmlTag>("Text");
    TextTag->Property("text", "String(index).padStart(2, '0')");
    TextTag->Property("anchors.fill", "parent");
    TextTag->Property("horizontalAlignment", "Text.AlignHCenter");
    TextTag->Property("verticalAlignment", "Text.AlignVCenter");
    TextTag->Property("font.pixelSize", RendererQml::Formatter() << mTimeInputConfig.pixelSize);
    TextTag->Property("color", RendererQml::Formatter() << listView_id << ".currentIndex==index ? " << context->GetHexColor(mTimeInputConfig.timePickerElementTextColorOnHighlighted) << " : " << context->GetHexColor(mTimeInputConfig.timePickerElementTextColorNormal));

    auto delegateRectTag = std::make_shared<RendererQml::QmlTag>("Rectangle");
    delegateRectTag->Property("width", RendererQml::Formatter() << mTimeInputConfig.timePickerHoursAndMinutesTagWidth);
    delegateRectTag->Property("height", RendererQml::Formatter() << mTimeInputConfig.timePickerElementHeight);
    delegateRectTag->Property("radius", RendererQml::Formatter() << mTimeInputConfig.timePickerElementRadius);
    delegateRectTag->Property("color", RendererQml::Formatter() << listView_id << ".currentIndex==index ? " << context->GetHexColor(mTimeInputConfig.timePickerElementColorOnFocus) << " : " << MouseArea_id << ".containsMouse? " << context->GetHexColor(mTimeInputConfig.timePickerElementColorOnHover) << " : " << context->GetHexColor(mTimeInputConfig.timePickerElementColorNormal));

    if (isThirdTag)
    {
        delegateRectTag->Property("width", RendererQml::Formatter() << mTimeInputConfig.timePickerAMPMTagWidth);
        ListViewTag->Property("width", RendererQml::Formatter() << mTimeInputConfig.timePickerAMPMTagWidth);
    }

    std::map<std::string, std::map<std::string, std::string>>::iterator outer_iterator;
    std::map<std::string, std::string>::iterator inner_iterator;

    for (outer_iterator = properties.begin(); outer_iterator != properties.end(); outer_iterator++)
    {
        std::shared_ptr<RendererQml::QmlTag> propertyTag;

        if (outer_iterator->first.compare("ListView") == 0)
        {
            propertyTag = ListViewTag;
        }

        else if (outer_iterator->first.compare("MouseArea") == 0)
        {
            propertyTag = MouseAreaTag;
        }

        else if (outer_iterator->first.compare("Text") == 0)
        {
            propertyTag = TextTag;
        }

        else if (outer_iterator->first.compare("Rectangle") == 0)
        {
            propertyTag = delegateRectTag;
        }

        for (inner_iterator = outer_iterator->second.begin(); inner_iterator != outer_iterator->second.end(); inner_iterator++)
        {
            propertyTag->Property(inner_iterator->first, inner_iterator->second);
        }
    }

    delegateRectTag->AddChild(MouseAreaTag);
    delegateRectTag->AddChild(TextTag);

    ListViewTag->Property("delegate", delegateRectTag->ToString());

    return ListViewTag;
}

void TimeInputElement::initTimeInputPopup()
{
    auto PopupBgrTag = std::make_shared<RendererQml::QmlTag>("Rectangle");
    PopupBgrTag->Property("anchors.fill", "parent");
    PopupBgrTag->Property("border.color", mContext->GetHexColor(mTimeInputConfig.timePickerBorderColor));
    PopupBgrTag->Property("radius", RendererQml::Formatter() << mTimeInputConfig.timePickerBorderRadius);
    PopupBgrTag->Property("color", mContext->GetHexColor(mTimeInputConfig.timePickerBackgroundColor));

    mTimeInputPopup = std::make_shared<RendererQml::QmlTag>("Popup");
    mTimeInputPopup->Property("id", timePopupId);
    mTimeInputPopup->Property("width", RendererQml::Formatter() << mTimeInputConfig.timePickerWidth24Hour);
    mTimeInputPopup->Property("height", RendererQml::Formatter() << mTimeInputConfig.timePickerHeight);
    mTimeInputPopup->Property("y", RendererQml::Formatter() << id << ".height + 4");
    mTimeInputPopup->Property("x", RendererQml::Formatter() << "-" << id << "_icon.width - " << mTimeInputConfig.clearIconHorizontalPadding);
    mTimeInputPopup->Property("background", PopupBgrTag->ToString());
    mTimeInputPopup->Property("onOpened", RendererQml::Formatter() << listViewHoursId << ".forceActiveFocus()");
    mTimeInputPopup->Property("onClosed", RendererQml::Formatter() << "{\n"
        << "var x = String(" << listViewHoursId << ".currentIndex).padStart(2, '0');\n"
        << "var y = String(" << listViewMinId << ".currentIndex).padStart(2, '0');\n"
        << id << ".insert(0, x);\n"
        << id << ".insert(2, y);\n"
        << id << ".forceActiveFocus();\n"
        << "}");

    auto timeBoxTag = std::make_shared<RendererQml::QmlTag>("Rectangle");
    timeBoxTag->Property("anchors.fill", "parent");
    timeBoxTag->Property("color", "'transparent'");
    timeBoxTag->Property("Accessible.name", "Time Picker", true);

    auto timeBoxRow = std::make_shared<RendererQml::QmlTag>("RowLayout");
    timeBoxRow->Property("width", "parent.width");
    timeBoxRow->Property("height", "parent.height");
    timeBoxRow->Property("spacing", RendererQml::Formatter() << mTimeInputConfig.timePickerColumnSpacing);

    //ListView for DropDown Selection
    std::map<std::string, std::map<std::string, std::string>> ListViewHoursProperties;
    std::map<std::string, std::map<std::string, std::string>> ListViewMinProperties;
    std::map<std::string, std::map<std::string, std::string>> ListViewttProperties;
    std::shared_ptr<RendererQml::QmlTag> listViewttTag;
    int hoursRange = 24;

    if (mIs12hour == true)
    {
        mTimeInputPopup->Property("width", RendererQml::Formatter() << mTimeInputConfig.timePickerWidth12Hour);
        mTimeInputTextField->Property("validator", "RegExpValidator { regExp: /^(--|[01]-|0\\d|1[0-2]):(--|[0-5]-|[0-5]\\d)\\s(--|A-|AM|P-|PM)$/}");
        mTimeInputTextField->Property("onFocusChanged", RendererQml::Formatter() << "{ if (focus===true) inputMask=\"xx:xx >xx;-\";" <<
            " if(focus===false){ " << "if(text===\": \" ) { inputMask=\"\" }" << "}}");
        mTimeInputTextField->Property("onTextChanged", RendererQml::Formatter() << "{" << listViewHoursId << ".currentIndex=parseInt(getText(0,2))-1;" << listViewMinId << ".currentIndex=parseInt(getText(3,5));"
            << "var tt_index=-1;var hh = getText(0,2);" << "switch(getText(6,8)){ case 'PM':tt_index = 1; if(parseInt(getText(0,2))!==12){hh=parseInt(getText(0,2))+12;} break;case 'AM':tt_index = 0; if(parseInt(getText(0,2))===12){hh=parseInt(getText(0,2))-12;} break;}" << listViewttId << ".currentIndex=tt_index;" << "if(getText(0,2) === '--' || getText(3,5) === '--' || getText(6,8) === '--'){" << id << ".selectedTime ='';} else{" << id << ".selectedTime = (hh === 0 ? '00' : hh) + ':' + getText(3,5);}}");
        mTimeIcon->Property("onClicked", RendererQml::Formatter() << "{" << id << ".forceActiveFocus();\n" << timePopupId << ".open();\n" << listViewHoursId << ".currentIndex=parseInt(" << id << ".getText(0,2))-1;\n" << listViewMinId << ".currentIndex=parseInt(" << id << ".getText(3,5));\n"
            << "var tt_index=-1;" << "switch(" << id << ".getText(6,8)){ case 'PM':tt_index = 1; break;case 'AM':tt_index = 0; break;}" << listViewttId << ".currentIndex=tt_index;" << "}");


        ListViewHoursProperties["Text"].insert(std::pair<std::string, std::string>("text", "String(index+1).padStart(2, '0')"));
        ListViewHoursProperties["MouseArea"].insert(std::pair<std::string, std::string>("onClicked", RendererQml::Formatter() << "{ forceActiveFocus();" << listViewHoursId << ".currentIndex=index;" << "var x=String(index+1).padStart(2, '0') ;" << id << ".insert(0,x);" << "}"));

        hoursRange = 12;

        ListViewttProperties["ListView"].insert(std::pair<std::string, std::string>("model", "ListModel{ListElement { name: \"AM\"} ListElement { name: \"PM\"}}"));
        ListViewttProperties["Text"].insert(std::pair<std::string, std::string>("text", "model.name"));
        ListViewttProperties["MouseArea"].insert(std::pair<std::string, std::string>("onClicked", RendererQml::Formatter() << "{ forceActiveFocus(); " << listViewttId << ".currentIndex=index;" << id << ".insert(6,model.name);" << "}"));
        ListViewttProperties["Text"].insert(std::pair<std::string, std::string>("KeyNavigation.left", listViewMinId));
        ListViewttProperties["ListView"].insert(std::pair<std::string, std::string>("Keys.onReturnPressed", RendererQml::Formatter() << timePopupId << ".close()"));
        ListViewttProperties["ListView"].insert(std::pair<std::string, std::string>("Layout.rightMargin", RendererQml::Formatter() << mTimeInputConfig.timePickerColumnSpacing));
        ListViewttProperties["Rectangle"].insert(std::pair<std::string, std::string>("Accessible.name", RendererQml::Formatter() << "(" << listViewttId << ".currentIndex < 0) ? ' ' : (" << listViewttId << ".currentIndex == 0 ? 'AM' : 'PM')"));
        ListViewttProperties["Rectangle"].insert(std::pair<std::string, std::string>("Accessible.role", "Accessible.StaticText"));

        listViewttTag = getListViewTagforTimeInput(id, listViewttId, ListViewttProperties, true, mContext);

        ListViewMinProperties["ListView"].insert(std::pair<std::string, std::string>("KeyNavigation.right", listViewttId));
        mTimeInputPopup->Property("onClosed", RendererQml::Formatter() << "{\n"
            << "var x = String(" << listViewHoursId << ".currentIndex + 1).padStart(2, '0');\n"
            << "var y = String(" << listViewMinId << ".currentIndex).padStart(2, '0');\n"
            << "var z = (" << listViewttId << ".currentIndex === -1) ? '--' :  " << listViewttId << ".currentIndex === 0 ? 'AM' : 'PM';\n"
            << id << ".insert(0, x);\n"
            << id << ".insert(2, y);\n"
            << id << ".insert(6, z);\n"
            << id << ".forceActiveFocus();\n"
            << "}");
    }
    ListViewHoursProperties["ListView"].insert(std::pair<std::string, std::string>("Layout.leftMargin", RendererQml::Formatter() << mTimeInputConfig.timePickerColumnSpacing));
    ListViewHoursProperties["ListView"].insert(std::pair<std::string, std::string>("model", std::to_string(hoursRange)));
    ListViewHoursProperties["MouseArea"].insert(std::pair<std::string, std::string>("onClicked", RendererQml::Formatter() << "{ forceActiveFocus();" << listViewHoursId << ".currentIndex=index;" << "var x=String(index).padStart(2, '0') ;" << id << ".insert(0,x);" << "}"));
    ListViewHoursProperties["ListView"].insert(std::pair<std::string, std::string>("KeyNavigation.right", listViewMinId));
    ListViewHoursProperties["ListView"].insert(std::pair<std::string, std::string>("Keys.onReturnPressed", RendererQml::Formatter() << timePopupId << ".close()"));
    ListViewHoursProperties["Rectangle"].insert(std::pair<std::string, std::string>("Accessible.name", RendererQml::Formatter() << "(" << listViewHoursId << ".currentIndex < 0) ? ' ' : 'Hour ' + String(" << listViewHoursId << ".currentIndex" << (mIs12hour ? " + 1" : "") << ")"));
    ListViewHoursProperties["Rectangle"].insert(std::pair<std::string, std::string>("Accessible.role", "Accessible.StaticText"));

    auto ListViewHoursTag = getListViewTagforTimeInput(id, listViewHoursId, ListViewHoursProperties, false, mContext);

    ListViewMinProperties["ListView"].insert(std::pair<std::string, std::string>("model", "60"));
    ListViewMinProperties["MouseArea"].insert(std::pair<std::string, std::string>("onClicked", RendererQml::Formatter() << "{ forceActiveFocus();" << listViewMinId << ".currentIndex=index;" << "var x=String(index).padStart(2, '0') ;" << id << ".insert(2,x);" << "}"));
    ListViewMinProperties["ListView"].insert(std::pair<std::string, std::string>("KeyNavigation.left", listViewHoursId));
    ListViewMinProperties["ListView"].insert(std::pair<std::string, std::string>("Keys.onReturnPressed", RendererQml::Formatter() << timePopupId << ".close()"));
    ListViewMinProperties["Rectangle"].insert(std::pair<std::string, std::string>("Accessible.name", RendererQml::Formatter() << "(" << listViewMinId << ".currentIndex < 0) ? ' ' : 'Minute ' + String(" << listViewMinId << ".currentIndex)"));
    ListViewMinProperties["Rectangle"].insert(std::pair<std::string, std::string>("Accessible.role", "Accessible.StaticText"));
    if (mIs12hour == false)
    {
        ListViewMinProperties["ListView"].insert(std::pair<std::string, std::string>("Layout.rightMargin", RendererQml::Formatter() << mTimeInputConfig.timePickerColumnSpacing));
    }

    auto ListViewMinTag = getListViewTagforTimeInput(id, listViewMinId, ListViewMinProperties, false, mContext);

    timeBoxTag->AddChild(timeBoxRow);

    timeBoxRow->AddChild(ListViewHoursTag);
    timeBoxRow->AddChild(ListViewMinTag);
    if (mIs12hour)
    {
        timeBoxRow->AddChild(listViewttTag);
    }
    mTimeInputPopup->Property("contentItem", timeBoxTag->ToString());
}

void TimeInputElement::initTimeInputRow()
{
    mTimeInputRow = std::make_shared<RendererQml::QmlTag>("RowLayout");

    mTimeInputRow->Property("width", "parent.width");
    mTimeInputRow->Property("height", RendererQml::Formatter() << id << ".implicitHeight");
    mTimeInputRow->Property("spacing", "0");

    mTimeInputRow->AddChild(mTimeIcon);
    mTimeInputRow->AddChild(mTimeInputComboBox);
    mTimeInputRow->AddChild(mClearIcon);
}

void TimeInputElement::initTimeIcon()
{
    mTimeIcon = RendererQml::AdaptiveCardQmlRenderer::GetClearIconButton(mContext);
    mTimeIcon->RemoveProperty("anchors.right");
    mTimeIcon->RemoveProperty("anchors.margins");
    mTimeIcon->RemoveProperty("anchors.verticalCenter");
    mTimeIcon->Property("id", RendererQml::Formatter() << id << "_icon");
    mTimeIcon->Property("Layout.leftMargin", RendererQml::Formatter() << mTimeInputConfig.timeIconHorizontalPadding);
    mTimeIcon->Property("Layout.alignment", "Qt.AlignVCenter");
    mTimeIcon->Property("focusPolicy", "Qt.NoFocus");
    mTimeIcon->Property("width", "18");
    mTimeIcon->Property("height", "18");
    mTimeIcon->Property("icon.color", RendererQml::Formatter() << id << ".showErrorMessage ? " << mContext->GetHexColor(mTimeInputConfig.timeIconColorOnError) << " : " << timeComboboxId << ".activeFocus ? " << mContext->GetHexColor(mTimeInputConfig.timeIconColorOnFocus) << " : " << mContext->GetHexColor(mTimeInputConfig.timeIconColorNormal));
    mTimeIcon->Property("icon.source", RendererQml::clock_icon, true);
    mTimeIcon->Property("onClicked", RendererQml::Formatter() << "{" << id << ".forceActiveFocus();\n" << timePopupId << ".open();\n" << listViewHoursId + ".currentIndex=parseInt(" << id << ".getText(0,2));\n" << listViewMinId + ".currentIndex=parseInt(" << id << ".getText(3,5));\n" << "}");
}

void TimeInputElement::initClearIcon()
{
    mClearIcon = RendererQml::AdaptiveCardQmlRenderer::GetClearIconButton(mContext);
    mClearIcon->RemoveProperty("anchors.right");
    mClearIcon->RemoveProperty("anchors.margins");
    mClearIcon->RemoveProperty("anchors.verticalCenter");
    mClearIcon->Property("id", RendererQml::Formatter() << id << "_clear_icon");
    mClearIcon->Property("Layout.rightMargin", RendererQml::Formatter() << mTimeInputConfig.clearIconHorizontalPadding);
    std::string mClearIcon_visible_value = RendererQml::Formatter() << "(!" << id << ".focus && " << id << ".text !==\"\") || (" << id << ".focus && " << id << ".text !== " << (mIs12hour ? "\": \"" : "\":\"") << ")";
    mClearIcon->Property("visible", mClearIcon_visible_value);

    std::string mClearIcon_OnClicked_value = RendererQml::Formatter() << " { "
        << "nextItemInFocusChain().forceActiveFocus();\n"
        << id << ".clear();\n"
        << timePopupId << ".close();\n"
        << "}";
    mClearIcon->Property("onClicked", mClearIcon_OnClicked_value);
    mClearIcon->Property("Accessible.name", RendererQml::Formatter() << "String.raw`" << (mTimeInput->GetPlaceholder().empty() ? "Time Input" : mEscapedPlaceholderString) << " clear`");
    mClearIcon->Property("Accessible.role", "Accessible.Button");
}

void TimeInputElement::addInputLabel(bool isRequired)
{
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mTimeInput->GetLabel().empty())
        {
            auto label = std::make_shared<RendererQml::QmlTag>("Label");
            label->Property("id", RendererQml::Formatter() << id << "_label");
            label->Property("wrapMode", "Text.Wrap");
            label->Property("width", "parent.width");

            std::string color = mContext->GetColor(AdaptiveCards::ForegroundColor::Default, false, false);
            label->Property("color", color);
            label->Property("font.pixelSize", RendererQml::Formatter() << mTimeInputConfig.labelSize);
            label->Property("Accessible.ignored", "true");

            if (isRequired)
            {
                label->Property("text", RendererQml::Formatter() << (mTimeInput->GetLabel().empty() ? "Text" : mTimeInput->GetLabel()) << " <font color='" << mTimeInputConfig.errorMessageColor << "'>*</font>", true);
            }
            else
            {
                label->Property("text", RendererQml::Formatter() << (mTimeInput->GetLabel().empty() ? "Text" : mTimeInput->GetLabel()), true);
            }

            mTimeInputColElement->AddChild(label);
        }
        else
        {
            if (mTimeInput->GetIsRequired())
            {
                mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "isRequired is not supported without labels"));
            }
        }
    }
}

void TimeInputElement::addErrorMessage()
{
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mTimeInput->GetErrorMessage().empty())
        {
            auto uiErrorMessage = std::make_shared<RendererQml::QmlTag>("Label");
            uiErrorMessage->Property("id", RendererQml::Formatter() << mTimeInput->GetId() << "_errorMessage");
            uiErrorMessage->Property("wrapMode", "Text.Wrap");
            uiErrorMessage->Property("width", "parent.width");
            uiErrorMessage->Property("font.pixelSize", RendererQml::Formatter() << mTimeInputConfig.labelSize);
            uiErrorMessage->Property("Accessible.ignored", "true");

            uiErrorMessage->Property("color", mContext->GetHexColor(mTimeInputConfig.errorMessageColor));
            uiErrorMessage->Property("text", mTimeInput->GetErrorMessage(), true);
            uiErrorMessage->Property("visible", RendererQml::Formatter() << id << ".showErrorMessage");
            mTimeInputColElement->AddChild(uiErrorMessage);
        }
    }
}

void TimeInputElement::addValidation()
{
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (mTimeInput->GetIsVisible())
        {
            mContext->addToRequiredInputElementsIdList(id);
        }
        mTimeInputTextField->Property("property bool showErrorMessage", "false");

        std::ostringstream validator;
        std::string condition;
        std::string minTimeValidate = "";
        std::string maxTimeValidate = "";

        minTimeValidate = RendererQml::Formatter() << "";

        if (mTimeInput->GetIsRequired())
        {
            condition = RendererQml::Formatter() << "var isValid = " << id << ".text.length === " << (mIs12hour ? 8 : 5) << ";";
        }
        else
        {
            condition = RendererQml::Formatter() << "var isValid = true;";
        }

        validator << "function validate(){"
            << condition
            << "if(isValid){"
            << "var minTimeHour = parseInt(minTime.slice(0, 2)); var minTimeMinute = parseInt(minTime.slice(3, 5));var maxTimeHour = parseInt(maxTime.slice(0, 2)); var maxTimeMinute = parseInt(maxTime.slice(3, 5));var selTimeHour = parseInt(selectedTime.slice(0, 2)); var selTimeMinute = parseInt(selectedTime.slice(3, 5));"
            << "if(selTimeHour < minTimeHour || (selTimeHour === minTimeHour && selTimeMinute < minTimeMinute)){isValid = false}"
            << "if(selTimeHour > maxTimeHour || (selTimeHour === maxTimeHour && selTimeMinute > maxTimeMinute)){isValid = false}"
            << "}"
            << "if(showErrorMessage){"
            << "if(isValid){"
            << "showErrorMessage = false;"
            << "}}"
            << "return !isValid;}";

        mTimeInputTextField->AddFunctions(validator.str());
        mTimeInputTextField->Property("onSelectedTimeChanged", "validate()");
        mTimeInputTextField->Property("onShowErrorMessageChanged", RendererQml::Formatter() << mTimeInputWrapper->GetId() << ".colorChange(false)");

        if (mIs12hour)
        {
            mTimeInputTextField->Property("onTextChanged", RendererQml::Formatter() << "{" << listViewHoursId << ".currentIndex=parseInt(getText(0,2))-1;" << listViewMinId << ".currentIndex=parseInt(getText(3,5));"
                << "var tt_index=-1;var hh = getText(0,2);" << "switch(getText(6,8)){ case 'PM':tt_index = 1; if(parseInt(getText(0,2))!==12){hh=parseInt(getText(0,2))+12;} break;case 'AM':tt_index = 0; if(parseInt(getText(0,2))===12){hh=parseInt(getText(0,2))-12;} break;}" << listViewttId << ".currentIndex=tt_index;" << "if(getText(0,2) === '--' || getText(3,5) === '--' || getText(6,8) === '--'){" << id << ".selectedTime ='';} else{" << id << ".selectedTime = (hh === 0 ? '00' : hh) + ':' + getText(3,5);};validate()}");
        }
        else
        {
            mTimeInputTextField->Property("onTextChanged", RendererQml::Formatter() << "{" << listViewHoursId << ".currentIndex=parseInt(getText(0,2));" << listViewMinId << ".currentIndex=parseInt(getText(3,5));" << "if(getText(0,2) === '--' || getText(3,5) === '--'){" << id << ".selectedTime ='';} else{" << id << ".selectedTime =" << id << ".text;};validate()}");
        }
        mTimeInputWrapper->Property("border.color", RendererQml::Formatter() << id << ".showErrorMessage ? " << mContext->GetHexColor(mTimeInputConfig.borderColorOnError) << " : " << id << ".activeFocus? " << mContext->GetHexColor(mTimeInputConfig.borderColorOnFocus) << " : " << mContext->GetHexColor(mTimeInputConfig.borderColorNormal));
    }
}

const std::string TimeInputElement::getColorFunction()
{
    std::ostringstream colorFunction;

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        colorFunction << "function colorChange(isPressed){"
            "if (isPressed && !" << id << ".showErrorMessage)  color = " << mContext->GetHexColor(mTimeInputConfig.backgroundColorOnPressed) << ";"
            "else color = " << id << ".showErrorMessage ? " << mContext->GetHexColor(mTimeInputConfig.backgroundColorOnError) << " : " << id << ".activeFocus ? " << mContext->GetHexColor(mTimeInputConfig.backgroundColorOnPressed) << " : " << id << ".hovered ? " << mContext->GetHexColor(mTimeInputConfig.backgroundColorOnHovered) << " : " << mContext->GetHexColor(mTimeInputConfig.backgroundColorNormal) << "}";
    }
    else
    {
        colorFunction << "function colorChange(isPressed){"
            "if (isPressed)  color = " << mContext->GetHexColor(mTimeInputConfig.backgroundColorOnPressed) << ";"
            "else color = " << id << ".activeFocus ? " << mContext->GetHexColor(mTimeInputConfig.backgroundColorOnPressed) << " : " << id << ".hovered ? " << mContext->GetHexColor(mTimeInputConfig.backgroundColorOnHovered) << " : " << mContext->GetHexColor(mTimeInputConfig.backgroundColorNormal) << "}";
    }

    return colorFunction.str();
}

const std::string TimeInputElement::getAccessibleName()
{
    std::ostringstream accessibleName;
    std::ostringstream labelString;
    std::ostringstream errorString;
    std::ostringstream placeHolderString;

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mTimeInput->GetLabel().empty())
        {
            labelString << "accessibleName += '" << mTimeInput->GetLabel() << ". ';";
        }

        if (!mTimeInput->GetErrorMessage().empty())
        {
            errorString << "if(" << id << ".showErrorMessage === true){"
                << "accessibleName += 'Error. " << mTimeInput->GetErrorMessage() << ". ';}";
        }
    }

    placeHolderString << "if(" << id << ".text.length === " << (mIs12hour ? 8 : 5) << "){"
        << "accessibleName += text"
        << "}else{"
        << "accessibleName += placeholderText;}";

    accessibleName << "function getAccessibleName(){"
        << "let accessibleName = '';" << errorString.str() << labelString.str() << placeHolderString.str() << "return accessibleName;}";

    return accessibleName.str();
}
