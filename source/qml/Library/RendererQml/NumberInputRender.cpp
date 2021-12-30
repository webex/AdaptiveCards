#include "NumberInputRender.h"
#include "Formatter.h"
#include "utils.h"
#include "ImageDataURI.h"

NumberinputElement::NumberinputElement(std::shared_ptr<AdaptiveCards::NumberInput> input, std::shared_ptr<RendererQml::AdaptiveRenderContext> context)
	:mInput(input),
	mContext(context)
{
}

std::shared_ptr<RendererQml::QmlTag> NumberinputElement::getDummyElementforNumberInput(bool isTop)
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

std::shared_ptr<RendererQml::QmlTag> NumberinputElement::getQmlTag()
{
    if (mInput->GetHeight() == AdaptiveCards::HeightType::Stretch)
    {
        return RendererQml::AdaptiveCardQmlRenderer::GetStretchRectangle(numberInputColElement);
    }
    return numberInputColElement;
}

void NumberinputElement::initialize()
{
    auto numberConfig = mContext->GetRenderConfig()->getInputNumberConfig();
    numberInputColElement = std::make_shared<RendererQml::QmlTag>("Column");
    numberInputColElement->Property("id", RendererQml::Formatter() << mInput->GetId() << "_column");
    numberInputColElement->Property("spacing", RendererQml::Formatter() << RendererQml::Utils::GetSpacing(mContext->GetConfig()->GetSpacing(), AdaptiveCards::Spacing::Small));
    numberInputColElement->Property("width", "parent.width");

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


    const std::string origionalElementId = mInput->GetId();
    mInput->SetId(mContext->ConvertToValidId(mInput->GetId()));
    const auto inputId = mInput->GetId();

    auto numberInputRow = std::make_shared<RendererQml::QmlTag>("Row");
    numberInputColElement->AddChild(numberInputRow);
    numberInputRow->Property("id", RendererQml::Formatter() << inputId << "_input_row");
    numberInputRow->Property("width", "parent.width");
    numberInputRow->Property("height", RendererQml::Formatter() << numberConfig.height);
    numberInputRow->Property("visible", mInput->GetIsVisible() ? "true" : "false");

    auto numberInputRectangle = std::make_shared<RendererQml::QmlTag>("Rectangle");
    numberInputRectangle->Property("id", RendererQml::Formatter() << inputId << "_input");

    numberInputRectangle->Property("border.width", RendererQml::Formatter() << numberConfig.borderWidth);
    numberInputRectangle->Property("border.color", RendererQml::Formatter() << inputId << ".activeFocus ? " << mContext->GetHexColor(numberConfig.borderColorOnFocus) << " : " << mContext->GetHexColor(numberConfig.borderColorNormal));
    numberInputRectangle->Property("radius", RendererQml::Formatter() << numberConfig.borderRadius);
    numberInputRectangle->Property("height", "parent.height");
    numberInputRectangle->Property("color", RendererQml::Formatter() << inputId << ".pressed ? " << mContext->GetHexColor(numberConfig.backgroundColorOnPressed) << " : " << inputId << ".hovered ? " << mContext->GetHexColor(numberConfig.backgroundColorOnHovered) << " : " << mContext->GetHexColor(numberConfig.backgroundColorNormal));

    auto uiNumberInput = std::make_shared<RendererQml::QmlTag>("SpinBox");
    uiNumberInput->Property("id", inputId);
    uiNumberInput->Property("width", RendererQml::Formatter() << "parent.width - " << numberConfig.clearIconSize << " - " << numberConfig.clearIconHorizontalPadding);
    uiNumberInput->Property("padding", "0");
    uiNumberInput->Property("stepSize", "1");
    uiNumberInput->Property("editable", "true");

    auto doubleValidatorTag = std::make_shared<RendererQml::QmlTag>("DoubleValidator");

    auto backgroundTag = std::make_shared<RendererQml::QmlTag>("Rectangle");
    backgroundTag->Property("color", "'transparent'");

    auto contentItemTag = std::make_shared<RendererQml::QmlTag>("TextField");
    contentItemTag->Property("id", inputId + "_contentItem");
    contentItemTag->Property("font.pixelSize", RendererQml::Formatter() << numberConfig.pixelSize);
    contentItemTag->Property("anchors.left", "parent.left");
    contentItemTag->Property("anchors.right", "parent.right");
    contentItemTag->Property("selectByMouse", "true");
    contentItemTag->Property("selectedTextColor", "'white'");
    contentItemTag->Property("readOnly", RendererQml::Formatter() << "!" << inputId << ".editable");
    contentItemTag->Property("validator", RendererQml::Formatter() << inputId << ".validator");
    contentItemTag->Property("inputMethodHints", "Qt.ImhFormattedNumbersOnly");
    contentItemTag->Property("text", RendererQml::Formatter() << inputId << ".value");
    contentItemTag->Property("onPressed", RendererQml::Formatter() << numberInputRectangle->GetId() << ".colorChange(true)");
    contentItemTag->Property("onReleased", RendererQml::Formatter() << numberInputRectangle->GetId() << ".colorChange(false)");
    contentItemTag->Property("onHoveredChanged", RendererQml::Formatter() << numberInputRectangle->GetId() << ".colorChange(false)");
    contentItemTag->Property("onActiveFocusChanged", RendererQml::Formatter() << numberInputRectangle->GetId() << ".colorChange(false)");
    contentItemTag->Property("leftPadding", RendererQml::Formatter() << numberConfig.textHorizontalPadding);
    contentItemTag->Property("rightPadding", RendererQml::Formatter() << numberConfig.textHorizontalPadding);
    contentItemTag->Property("topPadding", RendererQml::Formatter() << numberConfig.textVerticalPadding);
    contentItemTag->Property("bottomPadding", RendererQml::Formatter() << numberConfig.textVerticalPadding);
    contentItemTag->Property("padding", "0");
    {
        contentItemTag->Property("placeholderText", mInput->GetPlaceholder(), true);
    }
    contentItemTag->Property("Accessible.name", mInput->GetPlaceholder().empty() ? "Number Input Field" : mInput->GetPlaceholder(), true);
    contentItemTag->Property("Accessible.role", "Accessible.EditableText");

    auto textBackgroundTag = std::make_shared<RendererQml::QmlTag>("Rectangle");
    textBackgroundTag->Property("color", "'transparent'");

    contentItemTag->Property("background", textBackgroundTag->ToString());
    //contentItemTag->Property("onEditingFinished", Formatter() << "{ if(text < " << inputId << ".from || text > " << inputId << ".to){\nremove(0,length)\nif(" << inputId << ".hasDefaultValue)\ninsert(0, " << inputId << ".defaultValue)\nelse\ninsert(0, " << inputId << ".from)\n}\n}");
    contentItemTag->Property("color", mContext->GetHexColor(numberConfig.textColor));
    contentItemTag->Property("placeholderTextColor", mContext->GetHexColor(numberConfig.placeHolderColor));

    //Dummy indicator element to remove the default indicators of SpinBox
    auto upDummyTag = getDummyElementforNumberInput(true);

    //Dummy indicator element to remove the default indicators of SpinBox
    auto downDummyTag = getDummyElementforNumberInput(false);

    auto upDownIcon = RendererQml::AdaptiveCardQmlRenderer::GetIconTag(mContext);
    upDownIcon->RemoveProperty("anchors.top");
    upDownIcon->RemoveProperty("anchors.bottom");
    upDownIcon->RemoveProperty("anchors.margins");
    upDownIcon->Property("id", RendererQml::Formatter() << inputId << "_up_down_icon");
    upDownIcon->Property("width", "parent.width");
    upDownIcon->Property("height", "parent.height");
    upDownIcon->Property("icon.width", RendererQml::Formatter() << numberConfig.upDownIconSize);
    upDownIcon->Property("icon.height", RendererQml::Formatter() << numberConfig.upDownIconSize);
    upDownIcon->Property("icon.color", mContext->GetHexColor(numberConfig.upDownIconColor));
    upDownIcon->Property("icon.source", RendererQml::vector_up_down, true);
    upDownIcon->Property("background", textBackgroundTag->ToString());

    auto upIndicatorTag = std::make_shared<RendererQml::QmlTag>("MouseArea");
    upIndicatorTag->Property("id", RendererQml::Formatter() << inputId << "_up_indicator_area");
    upIndicatorTag->Property("width", "parent.width");
    upIndicatorTag->Property("height", "parent.height/2");
    upIndicatorTag->Property("anchors.top", "parent.top");

    auto downIndicatorTag = std::make_shared<RendererQml::QmlTag>("MouseArea");
    downIndicatorTag->Property("id", RendererQml::Formatter() << inputId << "_down_indicator_area");
    downIndicatorTag->Property("width", "parent.width");
    downIndicatorTag->Property("height", "parent.height/2");
    downIndicatorTag->Property("anchors.top", RendererQml::Formatter() << upIndicatorTag->GetId() << ".bottom");

    auto clearIcon = RendererQml::AdaptiveCardQmlRenderer::GetClearIconButton(mContext);
    clearIcon->Property("id", RendererQml::Formatter() << inputId << "_clear_icon");
    clearIcon->Property("visible", RendererQml::Formatter() << contentItemTag->GetId() << ".length !== 0");
    clearIcon->Property("onClicked", RendererQml::Formatter() << "{nextItemInFocusChain().forceActiveFocus();" << inputId << ".value = " << inputId << ".from;" << contentItemTag->GetId() << ".clear();}");

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

    //TODO: Add stretch property

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
            // auto label = createErrorMessageText(input->GetErrorMessage(), uiNumberInput);
            auto uiErrorMessage = std::make_shared<RendererQml::QmlTag>("Label");
            uiErrorMessage->Property("id", RendererQml::Formatter() << mInput->GetId() << "_errorMessage");
            uiErrorMessage->Property("wrapMode", "Text.Wrap");
            uiErrorMessage->Property("width", "parent.width");
            uiErrorMessage->Property("font.pixelSize", RendererQml::Formatter() << numberConfig.labelSize);
            uiErrorMessage->Property("Accessible.ignored", "true");

            std::string color = mContext->GetHexColor(numberConfig.errorMessageColor);
            uiErrorMessage->Property("color", color);
            uiErrorMessage->Property("text", mInput->GetErrorMessage(), true);
            uiErrorMessage->Property("visible", RendererQml::Formatter() << contentItemTag->GetId() << ".showErrorMessage");
            numberInputColElement->AddChild(uiErrorMessage);

            mContext->addToRequiredInputElementsIdList(contentItemTag->GetId());
            contentItemTag->Property("property bool showErrorMessage", "false");
            contentItemTag->Property("onTextChanged", "validate()");
            std::ostringstream validator;
            validator << "function validate(){\n";
            validator << "if (" << contentItemTag->GetId() << ".text.length != 0 && (parseInt(" << contentItemTag->GetId() << ".text) >=" << uiNumberInput->GetId() <<
                ".from) && (parseInt(" << contentItemTag->GetId() << ".text) <= " << uiNumberInput->GetId() << ".to))";
            validator << "{ showErrorMessage = false; return false; }";
            validator << "else { return true; } ";
            validator << "}";
            contentItemTag->AddFunctions(validator.str());
        }
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
        "{" << inputId << ".increase();" << contentItemTag->GetId() << ".text = value;}\n"
        "else if (keyPressed === Qt.Key_Down)\n"
        "{" << inputId << ".decrease();" << contentItemTag->GetId() << ".text = value;}}\n");
    uiNumberInput->Property("Keys.onPressed", RendererQml::Formatter() << "{\n"
        "if (event.key === Qt.Key_Up || event.key === Qt.Key_Down)\n"
        "{ " << inputId << ".changeValue(event.key);event.accepted = true}\n"
        "}\n");

    numberInputRectangle->Property("width", RendererQml::Formatter() << "parent.width - " << uiSplitterRactangle->GetId() << ".width");
    numberInputRectangle->AddFunctions(RendererQml::Formatter() << "function colorChange(isPressed){\n"
        "if (isPressed) color = " << mContext->GetHexColor(numberConfig.backgroundColorOnPressed) << ";\n"
        "else color = " << contentItemTag->GetId() << ".activeFocus ? " << mContext->GetHexColor(numberConfig.backgroundColorOnPressed) << " : " << contentItemTag->GetId() << ".hovered ? " << mContext->GetHexColor(numberConfig.backgroundColorOnHovered) << " : " << mContext->GetHexColor(numberConfig.backgroundColorNormal) << "}"
    );

    numberInputRectangle->AddChild(uiNumberInput);
    numberInputRectangle->AddChild(clearIcon);
    numberInputRow->AddChild(numberInputRectangle);
    numberInputRow->AddChild(uiSplitterRactangle);

    upIndicatorTag->Property("onReleased", RendererQml::Formatter() << "{ " << inputId << ".changeValue(Qt.Key_Up); " << uiSplitterRactangle->GetId() << ".forceActiveFocus(); }");
    downIndicatorTag->Property("onReleased", RendererQml::Formatter() << "{ " << inputId << ".changeValue(Qt.Key_Down); " << uiSplitterRactangle->GetId() << ".forceActiveFocus(); }");
    uiSplitterRactangle->AddChild(upDownIcon);
    uiSplitterRactangle->AddChild(upIndicatorTag);
    uiSplitterRactangle->AddChild(downIndicatorTag);

    mContext->addToInputElementList(origionalElementId, (inputId + ".value"));

    uiNumberInput->Property("Accessible.ignored", "true");
    clearIcon->Property("Accessible.name", RendererQml::Formatter() << (mInput->GetPlaceholder().empty() ? "Number Input" : mInput->GetPlaceholder()) << " clear", true);
    clearIcon->Property("Accessible.role", "Accessible.Button");

    uiSplitterRactangle->Property("property string accessiblityPrefix", "''");
    uiSplitterRactangle->Property("onActiveFocusChanged", RendererQml::Formatter() << "{"
        << "if (activeFocus)"
        << "accessiblityPrefix = '" << (mInput->GetPlaceholder().empty() ? "Number Input " : mInput->GetPlaceholder()) << "stepper. Current number is '}");
    uiSplitterRactangle->Property("Accessible.name", RendererQml::Formatter() << "accessiblityPrefix + " << contentItemTag->GetId() << ".displayText");
    uiSplitterRactangle->Property("Accessible.role", "Accessible.NoRole");
}
