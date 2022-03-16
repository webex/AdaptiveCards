#include "NumberInputRender.h"
#include "Formatter.h"
#include "utils.h"
#include "ImageDataURI.h"

NumberInputElement::NumberInputElement(std::shared_ptr<AdaptiveCards::NumberInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context)
    :mInput(input),
    mContext(context),
    numberConfig(context->GetRenderConfig()->getInputNumberConfig())
{
    initialize();
}

std::shared_ptr<RendererQml::QmlTag> NumberInputElement::getDummyElementforNumberInput(bool isTop)
{
    auto DummyTag = std::make_shared<RendererQml::QmlTag>("Rectangle");
    DummyTag->Property("width", "2");
    DummyTag->Property("height", "2");
    DummyTag->Property("anchors.right", "parent.right");

    if (isTop)
    {
        DummyTag->Property("anchors.top", "parent.top");
    }
    else
    {
        DummyTag->Property("anchors.bottom", "parent.bottom");
    }
    DummyTag->Property("anchors.margins", "5");
    DummyTag->Property("color", "'transparent'");
    DummyTag->Property("z", "-1");

    return DummyTag;
}

std::shared_ptr<RendererQml::QmlTag> NumberInputElement::getQmlTag()
{
    return numberInputColElement;
}

void NumberInputElement::initialize()
{
    const std::string origionalElementId = mInput->GetId();
    mEscapedPlaceHolderString = RendererQml::Utils::getBackQuoteEscapedString(mInput->GetPlaceholder());
    mInput->SetId(mContext->ConvertToValidId(mInput->GetId()));
    mOrigionalElementId = mInput->GetId();

    numberInputColElement = std::make_shared<RendererQml::QmlTag>("Column");
    numberInputColElement->Property("id", RendererQml::Formatter() << mInput->GetId() << "_column");
    numberInputColElement->Property("spacing", RendererQml::Formatter() << RendererQml::Utils::GetSpacing(mContext->GetConfig()->GetSpacing(), AdaptiveCards::Spacing::Small));
    numberInputColElement->Property("width", "parent.width");
    numberInputColElement->Property("visible", mInput->GetIsVisible() ? "true" : "false");
    createInputLabel();
    auto numberInputRow = std::make_shared<RendererQml::QmlTag>("Row");
    numberInputColElement->AddChild(numberInputRow);
    numberInputRow->Property("id", RendererQml::Formatter() << mOrigionalElementId << "_input_row");
    numberInputRow->Property("width", "parent.width");
    numberInputRow->Property("height", RendererQml::Formatter() << numberConfig.height);

    auto numberInputRectangle = std::make_shared<RendererQml::QmlTag>("Rectangle");
    numberInputRectangle->Property("id", RendererQml::Formatter() << mOrigionalElementId << "_input");
    mNumberInputRectId = (RendererQml::Formatter() << mOrigionalElementId << "_input");

    numberInputRectangle->Property("border.width", RendererQml::Formatter() << numberConfig.borderWidth);
    numberInputRectangle->Property("border.color", RendererQml::Formatter() << mOrigionalElementId << ".activeFocus ? " << mContext->GetHexColor(numberConfig.borderColorOnFocus) << " : " << mContext->GetHexColor(numberConfig.borderColorNormal));
    numberInputRectangle->Property("radius", RendererQml::Formatter() << numberConfig.borderRadius);
    numberInputRectangle->Property("height", "parent.height");
    numberInputRectangle->Property("color", RendererQml::Formatter() << mOrigionalElementId << ".pressed ? " << mContext->GetHexColor(numberConfig.backgroundColorOnPressed) << " : " << mOrigionalElementId << ".hovered ? " << mContext->GetHexColor(numberConfig.backgroundColorOnHovered) << " : " << mContext->GetHexColor(numberConfig.backgroundColorNormal));

    auto uiNumberInput = std::make_shared<RendererQml::QmlTag>("SpinBox");
    uiNumberInput->Property("id", mOrigionalElementId);
    uiNumberInput->Property("width", RendererQml::Formatter() << "parent.width - " << numberConfig.clearIconSize << " - " << numberConfig.clearIconHorizontalPadding);
    uiNumberInput->Property("padding", "0");
    uiNumberInput->Property("stepSize", "1");
    uiNumberInput->Property("editable", "true");

    auto doubleValidatorTag = std::make_shared<RendererQml::QmlTag>("DoubleValidator");

    auto backgroundTag = std::make_shared<RendererQml::QmlTag>("Rectangle");
    backgroundTag->Property("color", "'transparent'");
    backgroundTag->Property("id", RendererQml::Formatter() << mInput->GetId() << "_background");


    auto textBackgroundTag = std::make_shared<RendererQml::QmlTag>("Rectangle");
    textBackgroundTag->Property("color", "'transparent'");
    textBackgroundTag->Property("id", RendererQml::Formatter() << mInput->GetId() << "_textbackground");
    auto contentItemTag = getContentItemTag(textBackgroundTag);

    auto upDummyTag = getDummyElementforNumberInput(true);

    auto downDummyTag = getDummyElementforNumberInput(false);
    auto textBackgroundTagUpDownIcon = std::make_shared<RendererQml::QmlTag>("Rectangle");
    textBackgroundTagUpDownIcon->Property("color", "'transparent'");
    auto upDownIcon = getIconTag(textBackgroundTagUpDownIcon);

    auto upIndicatorTag = std::make_shared<RendererQml::QmlTag>("MouseArea");
    upIndicatorTag->Property("id", RendererQml::Formatter() << mOrigionalElementId << "_up_indicator_area");
    upIndicatorTag->Property("width", "parent.width");
    upIndicatorTag->Property("height", "parent.height/2");
    upIndicatorTag->Property("anchors.top", "parent.top");

    auto downIndicatorTag = std::make_shared<RendererQml::QmlTag>("MouseArea");
    downIndicatorTag->Property("id", RendererQml::Formatter() << mOrigionalElementId << "_down_indicator_area");
    downIndicatorTag->Property("width", "parent.width");
    downIndicatorTag->Property("height", "parent.height/2");
    downIndicatorTag->Property("anchors.top", RendererQml::Formatter() << upIndicatorTag->GetId() << ".bottom");

    auto clearIcon = RendererQml::AdaptiveCardQmlRenderer::GetClearIconButton(mContext);
    clearIcon->Property("id", RendererQml::Formatter() << mOrigionalElementId << "_clear_icon");
    clearIcon->Property("visible", RendererQml::Formatter() << contentItemTag->GetId() << ".length !== 0");
    clearIcon->Property("onClicked", RendererQml::Formatter() << "{nextItemInFocusChain().forceActiveFocus();" << mOrigionalElementId << ".value = " << mOrigionalElementId << ".from;" << contentItemTag->GetId() << ".clear();}");

    if (mInput->GetValue() != std::nullopt)
    {
        uiNumberInput->Property("readonly property bool hasDefaultValue", "true");
        uiNumberInput->Property("readonly property int defaultValue", RendererQml::Formatter() << mInput->GetValue());
    }
    else if (mInput->GetMin() == std::nullopt)
    {
        mInput->SetValue(0);
        uiNumberInput->Property("readonly property bool hasDefaultValue", "true");
        uiNumberInput->Property("readonly property int defaultValue", std::to_string(0));
    }
    else
    {
        uiNumberInput->Property("readonly property bool hasDefaultValue", "false");
    }

    if (mInput->GetMin() == std::nullopt)
    {
        mInput->SetMin(INT_MIN);
    }
    if (mInput->GetMax() == std::nullopt)
    {
        mInput->SetMax(INT_MAX);
    }

    if ((mInput->GetMin() == mInput->GetMax() && mInput->GetMin() == 0) || mInput->GetMin() > mInput->GetMax())
    {
        mInput->SetMin(INT_MIN);
        mInput->SetMax(INT_MAX);
    }
    if (mInput->GetValue() < mInput->GetMin())
    {
        mInput->SetValue(mInput->GetMin());
        uiNumberInput->Property("readonly property int defaultValue", RendererQml::Formatter() << mInput->GetMin());
    }
    if (mInput->GetValue() > mInput->GetMax())
    {
        mInput->SetValue(mInput->GetMax());
        uiNumberInput->Property("readonly property int defaultValue", RendererQml::Formatter() << mInput->GetMax());
    }

    uiNumberInput->Property("from", RendererQml::Formatter() << mInput->GetMin());
    uiNumberInput->Property("to", RendererQml::Formatter() << mInput->GetMax());
    uiNumberInput->Property("value", RendererQml::Formatter() << mInput->GetValue());

    if (!mInput->GetIsVisible())
    {
        uiNumberInput->Property("visible", "false");
    }

    auto uiSplitterRactangle = std::make_shared<RendererQml::QmlTag>("Rectangle");
    uiSplitterRactangle->Property("id", RendererQml::Formatter() << uiNumberInput->GetId() << "_icon_set");
    uiSplitterRactangle->Property("width", RendererQml::Formatter() << numberConfig.upDownButtonWidth);
    uiSplitterRactangle->Property("radius", RendererQml::Formatter() << numberConfig.borderRadius);
    uiSplitterRactangle->Property("height", "parent.height");
    uiSplitterRactangle->Property("border.color", RendererQml::Formatter() << "activeFocus ? " << mContext->GetHexColor(numberConfig.borderColorOnFocus) << " : " << mContext->GetHexColor(numberConfig.borderColorNormal));
    uiSplitterRactangle->Property("activeFocusOnTab", "true");
    uiSplitterRactangle->Property("color", RendererQml::Formatter() << "(" << upDownIcon->GetId() << ".pressed || activeFocus) ? " << mContext->GetHexColor(numberConfig.backgroundColorOnPressed) << " : " << upDownIcon->GetId() << ".hovered ? " << mContext->GetHexColor(numberConfig.backgroundColorOnHovered) << " : " << mContext->GetHexColor(numberConfig.backgroundColorNormal));
    uiSplitterRactangle->Property("Keys.onPressed", RendererQml::Formatter() << "{\n"
        "if (event.key === Qt.Key_Up || event.key === Qt.Key_Down)\n"
        "{" << uiNumberInput->GetId() << ".changeValue(event.key);accessiblityPrefix = '';event.accepted = true;}}\n"
    );

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mInput->GetErrorMessage().empty())
        {
            createErrorMessage();
        }
        mContext->addToRequiredInputElementsIdList(contentItemTag->GetId());
        contentItemTag->Property("property bool showErrorMessage", "false");
        contentItemTag->Property("onTextChanged", "validate()");
        contentItemTag->AddFunctions(getValidatorFunction().str());
        numberInputRectangle->Property("border.color", RendererQml::Formatter() << mContentTagId << ".showErrorMessage ? " << mContext->GetHexColor(numberConfig.borderColorOnError) << " : " << mContentTagId << ".activeFocus? " << mContext->GetHexColor(numberConfig.borderColorOnFocus) << " : " << mContext->GetHexColor(numberConfig.borderColorNormal));
    }

    uiNumberInput->Property("contentItem", contentItemTag->ToString());
    uiNumberInput->Property("background", backgroundTag->ToString());
    uiNumberInput->Property("up.indicator", upDummyTag->ToString());
    uiNumberInput->Property("down.indicator", downDummyTag->ToString());
    uiNumberInput->Property("validator", doubleValidatorTag->ToString());
    uiNumberInput->Property("valueFromText", "function(text, locale){\nreturn Number(text)\n}");
    uiNumberInput->AddFunctions(RendererQml::Formatter() << "function changeValue(keyPressed) {"
        "if ((keyPressed === Qt.Key_Up || keyPressed === Qt.Key_Down) && " << contentItemTag->GetId() << ".text.length === 0)\n"
        "{value = (from < 0) ? 0 : from;" << contentItemTag->GetId() << ".text = value;}\n"
        "else if (keyPressed === Qt.Key_Up)\n"
        "{" << mOrigionalElementId << ".increase();" << contentItemTag->GetId() << ".text = value;}\n"
        "else if (keyPressed === Qt.Key_Down)\n"
        "{" << mOrigionalElementId << ".decrease();" << contentItemTag->GetId() << ".text = value;}}\n");
    uiNumberInput->Property("Keys.onPressed", RendererQml::Formatter() << "{\n"
        "if (event.key === Qt.Key_Up || event.key === Qt.Key_Down)\n"
        "{ " << mOrigionalElementId << ".changeValue(event.key);event.accepted = true}\n"
        "}\n");

    numberInputRectangle->Property("width", RendererQml::Formatter() << "parent.width - " << uiSplitterRactangle->GetId() << ".width");
    numberInputRectangle->AddFunctions(getColorFunction());

    numberInputRectangle->AddChild(uiNumberInput);
    numberInputRectangle->AddChild(clearIcon);
    numberInputRow->AddChild(numberInputRectangle);
    numberInputRow->AddChild(uiSplitterRactangle);

    upIndicatorTag->Property("onReleased", RendererQml::Formatter() << "{ " << mOrigionalElementId << ".changeValue(Qt.Key_Up); " << uiSplitterRactangle->GetId() << ".forceActiveFocus(); }");
    downIndicatorTag->Property("onReleased", RendererQml::Formatter() << "{ " << mOrigionalElementId << ".changeValue(Qt.Key_Down); " << uiSplitterRactangle->GetId() << ".forceActiveFocus(); }");
    uiSplitterRactangle->AddChild(upDownIcon);
    uiSplitterRactangle->AddChild(upIndicatorTag);
    uiSplitterRactangle->AddChild(downIndicatorTag);
    if (mInput->GetIsVisible())
    {
        mContext->addToInputElementList(origionalElementId, (mOrigionalElementId + ".value"));
    }
    uiNumberInput->Property("Accessible.ignored", "true");
    clearIcon->Property("Accessible.name", RendererQml::Formatter() << "String.raw`" << (mInput->GetPlaceholder().empty() ? "Number Input" : mEscapedPlaceHolderString) << " clear`");
    clearIcon->Property("Accessible.role", "Accessible.Button");

    uiSplitterRactangle->Property("property string accessiblityPrefix", "''");
    uiSplitterRactangle->Property("onActiveFocusChanged", RendererQml::Formatter() << "{"
        << "if (activeFocus)"
        << "accessiblityPrefix = String.raw`" << (mInput->GetPlaceholder().empty() ? "Number Input " : mEscapedPlaceHolderString) << "stepper. Current number is `}");
    uiSplitterRactangle->Property("Accessible.name", RendererQml::Formatter() << "accessiblityPrefix + " << contentItemTag->GetId() << ".displayText");
    uiSplitterRactangle->Property("Accessible.role", "Accessible.NoRole");
}

void NumberInputElement::createInputLabel()
{
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mInput->GetLabel().empty())
        {
            auto label = std::make_shared<RendererQml::QmlTag>("Label");
            label->Property("id", RendererQml::Formatter() << mInput->GetId() << "_label");
            label->Property("wrapMode", "Text.Wrap");
            label->Property("width", "parent.width");

            std::string color = mContext->GetColor(AdaptiveCards::ForegroundColor::Default, false, false);
            label->Property("color", color);
            label->Property("font.pixelSize", RendererQml::Formatter() << numberConfig.labelSize);

            if (mInput->GetIsRequired())
                label->Property("text", RendererQml::Formatter() << (mInput->GetLabel().empty() ? "Text" : mInput->GetLabel()) << " <font color='" << numberConfig.errorMessageColor << "'>*</font>", true);
            else
                label->Property("text", RendererQml::Formatter() << (mInput->GetLabel().empty() ? "Text" : mInput->GetLabel()), true);

            numberInputColElement->AddChild(label);
        }
        else
        {
            if (mInput->GetIsRequired())
            {
                mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "isRequired is not supported without labels"));
            }
        }
    }
}

std::shared_ptr<RendererQml::QmlTag> NumberInputElement::getContentItemTag(const std::shared_ptr<RendererQml::QmlTag> textBackgroundTag)
{
    auto contentItemTag = std::make_shared<RendererQml::QmlTag>("TextField");
    contentItemTag->Property("id", mOrigionalElementId + "_contentItem");
    mContentTagId = mOrigionalElementId + "_contentItem";
    contentItemTag->Property("font.pixelSize", RendererQml::Formatter() << numberConfig.pixelSize);
    contentItemTag->Property("anchors.left", "parent.left");
    contentItemTag->Property("anchors.right", "parent.right");
    contentItemTag->Property("selectByMouse", "true");
    contentItemTag->Property("selectedTextColor", "'white'");
    contentItemTag->Property("readOnly", RendererQml::Formatter() << "!" << mOrigionalElementId << ".editable");
    contentItemTag->Property("validator", RendererQml::Formatter() << mOrigionalElementId << ".validator");
    contentItemTag->Property("inputMethodHints", "Qt.ImhFormattedNumbersOnly");
    contentItemTag->Property("text", RendererQml::Formatter() << mOrigionalElementId << ".defaultValue");
    contentItemTag->Property("onPressed", RendererQml::Formatter() << mNumberInputRectId << ".colorChange(true)");
    contentItemTag->Property("onReleased", RendererQml::Formatter() << mNumberInputRectId << ".colorChange(false)");
    contentItemTag->Property("onHoveredChanged", RendererQml::Formatter() << mNumberInputRectId << ".colorChange(false)");
    contentItemTag->Property("onActiveFocusChanged", RendererQml::Formatter() << "{" << mNumberInputRectId << ".colorChange(false);" << "Accessible.name = " << "getAccessibleName();}\n");
    contentItemTag->Property("leftPadding", RendererQml::Formatter() << numberConfig.textHorizontalPadding);
    contentItemTag->Property("rightPadding", RendererQml::Formatter() << numberConfig.textHorizontalPadding);
    contentItemTag->Property("topPadding", RendererQml::Formatter() << numberConfig.textVerticalPadding);
    contentItemTag->Property("bottomPadding", RendererQml::Formatter() << numberConfig.textVerticalPadding);
    contentItemTag->Property("padding", "0");
    {
        contentItemTag->Property("placeholderText", RendererQml::Formatter() << "String.raw`" << mEscapedPlaceHolderString << "`");
    }
    contentItemTag->Property("Accessible.name", RendererQml::Formatter() << "String.raw`" << (mInput->GetPlaceholder().empty() ? "Number Input Field" : mEscapedPlaceHolderString) << "`");
    contentItemTag->Property("Accessible.role", "Accessible.EditableText");
    contentItemTag->Property("background", textBackgroundTag->ToString());
    contentItemTag->AddFunctions(getAccessibleName());
    contentItemTag->Property("color", mContext->GetHexColor(numberConfig.textColor));
    contentItemTag->Property("placeholderTextColor", mContext->GetHexColor(numberConfig.placeHolderColor));

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        contentItemTag->Property("onShowErrorMessageChanged", RendererQml::Formatter() << "{\n"
            << mNumberInputRectId << ".colorChange( false)}\n");

        contentItemTag->Property("Accessible.name", RendererQml::Formatter() << "String.raw`" << (mInput->GetLabel().empty() ? (mInput->GetPlaceholder().empty() ? "Text Field" : mInput->GetPlaceholder()) : mInput->GetLabel()) << "`");
    }
    else
    {
        contentItemTag->Property("Accessible.name", RendererQml::Formatter() << "String.raw`" << (mInput->GetPlaceholder().empty() ? "Text Field" : mInput->GetPlaceholder()) << "`");
    }
    return contentItemTag;
}

void NumberInputElement::createErrorMessage()
{
    auto uiErrorMessage = std::make_shared<RendererQml::QmlTag>("Label");
    uiErrorMessage->Property("id", RendererQml::Formatter() << mInput->GetId() << "_errorMessage");
    uiErrorMessage->Property("wrapMode", "Text.Wrap");
    uiErrorMessage->Property("width", "parent.width");
    uiErrorMessage->Property("font.pixelSize", RendererQml::Formatter() << numberConfig.labelSize);
    uiErrorMessage->Property("Accessible.ignored", "true");

    std::string color = mContext->GetHexColor(numberConfig.errorMessageColor);
    uiErrorMessage->Property("color", color);
    uiErrorMessage->Property("text", mInput->GetErrorMessage(), true);
    uiErrorMessage->Property("visible", RendererQml::Formatter() << mContentTagId << ".showErrorMessage");
    numberInputColElement->AddChild(uiErrorMessage);
}

std::shared_ptr<RendererQml::QmlTag> NumberInputElement::getIconTag(const std::shared_ptr<RendererQml::QmlTag> textBackgroundTag)
{
    auto upDownIcon = RendererQml::AdaptiveCardQmlRenderer::GetIconTag(mContext);
    upDownIcon->RemoveProperty("anchors.top");
    upDownIcon->RemoveProperty("anchors.bottom");
    upDownIcon->RemoveProperty("anchors.margins");
    upDownIcon->Property("id", RendererQml::Formatter() << mOrigionalElementId << "_up_down_icon");
    upDownIcon->Property("width", "parent.width");
    upDownIcon->Property("height", "parent.height");
    upDownIcon->Property("icon.width", RendererQml::Formatter() << numberConfig.upDownIconSize);
    upDownIcon->Property("icon.height", RendererQml::Formatter() << numberConfig.upDownIconSize);
    upDownIcon->Property("icon.color", mContext->GetHexColor(numberConfig.upDownIconColor));
    upDownIcon->Property("icon.source", RendererQml::vector_up_down, true);
    upDownIcon->Property("background", textBackgroundTag->ToString());
    return upDownIcon;
}
std::ostringstream NumberInputElement::getValidatorFunction()
{
    std::ostringstream validator;
    validator << "function validate(){\n";
    if (mInput->GetIsRequired())
    {
        validator << "if (" << mContentTagId << ".text.length != 0 && (parseInt(" << mContentTagId << ".text) >=" << mOrigionalElementId <<
            ".from) && (parseInt(" << mContentTagId << ".text) <= " << mOrigionalElementId << ".to))";
    }
    else
    {
        validator << "if (" << mContentTagId << ".text.length == 0 || (parseInt(" << mContentTagId << ".text) >=" << mOrigionalElementId <<
            ".from) && (parseInt(" << mContentTagId << ".text) <= " << mOrigionalElementId << ".to))";
    }

    validator << "{ showErrorMessage = false; return false; }";
    validator << "else { return true; } ";
    validator << "}";

    return validator;
}

const std::string NumberInputElement::getColorFunction()
{
    std::ostringstream colorFunction;
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        colorFunction << "function colorChange(isPressed){"
            "if (isPressed && !" << mContentTagId << ".showErrorMessage)  color = " << mContext->GetHexColor(numberConfig.backgroundColorOnPressed) << ";"
            "else color = " << mContentTagId << ".showErrorMessage ? " << mContext->GetHexColor(numberConfig.backgroundColorOnError) << " : " << mContentTagId << ".activeFocus ? " << mContext->GetHexColor(numberConfig.backgroundColorOnPressed) << " : " << mContentTagId << ".hovered ? " << mContext->GetHexColor(numberConfig.backgroundColorOnHovered) << " : " << mContext->GetHexColor(numberConfig.backgroundColorNormal) << "}";
    }
    else
    {
        colorFunction << "function colorChange(isPressed){"
            "if (isPressed)  color = " << mContext->GetHexColor(numberConfig.backgroundColorOnPressed) << ";"
            "else color = " << mContentTagId << ".activeFocus ? " << mContext->GetHexColor(numberConfig.backgroundColorOnPressed) << " : " << mContentTagId << ".hovered ? " << mContext->GetHexColor(numberConfig.backgroundColorOnHovered) << " : " << mContext->GetHexColor(numberConfig.backgroundColorNormal) << "}";
    }

    return colorFunction.str();
}

const std::string NumberInputElement::getAccessibleName()
{
    std::ostringstream accessibleName;
    std::ostringstream labelString;
    std::ostringstream errorString;
    std::ostringstream placeHolderString;
    
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mInput->GetLabel().empty())
        {
            labelString << "accessibleName += '" << mInput->GetLabel() << ". ';";
        }

        if (!mInput->GetErrorMessage().empty())
        {
            errorString << "if(" << mContentTagId << ".showErrorMessage === true){"
                << "accessibleName += 'Error. " << mInput->GetErrorMessage() << ". ';}";
        }
    }

    placeHolderString << "if(" << mContentTagId << ".text !== ''){"
        << "accessibleName += (" << mContentTagId <<".text);"
        << "}else{"
        << "accessibleName += placeholderText;}";

    accessibleName << "function getAccessibleName(){"
        << "let accessibleName = '';" << errorString.str() << labelString.str() << placeHolderString.str() << "return accessibleName;}";

    return accessibleName.str();
}
