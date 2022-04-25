#include "TextInputRender.h"
#include "Formatter.h"
#include "utils.h"

TextInputElement::TextInputElement(std::shared_ptr<AdaptiveCards::TextInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context)
	:mTextinput(input),
	mContext(context),
    mContainer(nullptr)
{
    initialize();
}

std::shared_ptr<RendererQml::QmlTag> TextInputElement::getQmlTag()
{
    return mTextinputColElement;
}

void TextInputElement::initialize()
{
    mOriginalElementId = mTextinput->GetId();
    mEscapedPlaceHolderString = RendererQml::Utils::getBackQuoteEscapedString(mTextinput->GetPlaceholder());
    mTextinput->SetId(mContext->ConvertToValidId(mTextinput->GetId()));
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    mTextinputColElement = std::make_shared<RendererQml::QmlTag>("Column");
    mTextinputColElement->Property("id", RendererQml::Formatter() << mTextinput->GetId() << "_column");
    mTextinputColElement->Property("spacing", RendererQml::Formatter() << RendererQml::Utils::GetSpacing(mContext->GetConfig()->GetSpacing(), AdaptiveCards::Spacing::Small));
    mTextinputColElement->Property("width", "parent.width");
    mTextinputColElement->Property("visible", mTextinput->GetIsVisible() ? "true" : "false");

    if (mTextinput->GetIsMultiline())
    {
        initMultiLine();
    }
    else
    {
        initSingleLine();
    }
}

std::shared_ptr<RendererQml::QmlTag> TextInputElement::createInputTextLabel(bool isRequired)
{
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    auto label = std::make_shared<RendererQml::QmlTag>("Label");
    label->Property("id", RendererQml::Formatter() << mTextinput->GetId() << "_label");
    label->Property("wrapMode", "Text.Wrap");
    label->Property("width", "parent.width");

    std::string color = mContext->GetColor(AdaptiveCards::ForegroundColor::Default, false, false);
    label->Property("color", color);
    label->Property("font.pixelSize", RendererQml::Formatter() << textConfig.labelSize);
    label->Property("Accessible.ignored", "true");

    if (isRequired)
    { 
        label->Property("text", RendererQml::Formatter() << (mTextinput->GetLabel().empty() ? "Text" : mTextinput->GetLabel()) << " <font color='" << textConfig.errorMessageColor << "'>*</font>", true);
    }
    else
    { 
        label->Property("text", RendererQml::Formatter() << (mTextinput->GetLabel().empty() ? "Text" : mTextinput->GetLabel()), true);
    }
    return label;
}

std::shared_ptr<RendererQml::QmlTag> TextInputElement::createErrorMessageText(std::string errorMessage, const std::shared_ptr<RendererQml::QmlTag> uiTextInput)
{
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    auto uiErrorMessage = std::make_shared<RendererQml::QmlTag>("Label");
    uiErrorMessage->Property("id", RendererQml::Formatter() << mTextinput->GetId() << "_errorMessage");
    uiErrorMessage->Property("wrapMode", "Text.Wrap");
    uiErrorMessage->Property("width", "parent.width");
    uiErrorMessage->Property("font.pixelSize", RendererQml::Formatter() << textConfig.labelSize);
    uiErrorMessage->Property("Accessible.ignored", "true");

    std::string color = mContext->GetHexColor(textConfig.errorMessageColor);
    uiErrorMessage->Property("color", color);
    uiErrorMessage->Property("text", errorMessage, true);
    uiErrorMessage->Property("visible", RendererQml::Formatter() << uiTextInput->GetId() << ".showErrorMessage");
    return uiErrorMessage;
}

void TextInputElement::initSingleLine()
{
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mTextinput->GetLabel().empty())
        {
            auto label = createInputTextLabel(mTextinput->GetIsRequired());
            mTextinputColElement->AddChild(label);
        }
        else
        {
            if (mTextinput->GetIsRequired())
            {
                mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "isRequired is not supported without labels"));
            }
        }
    }

    mTextinputElement = std::make_shared<RendererQml::QmlTag>("Rectangle");
    mTextinputElement->Property("id", RendererQml::Formatter() << mTextinput->GetId() << "_wrapper");
    mTextinputElement->Property("border.color", RendererQml::Formatter() << mTextinput->GetId() << ".showErrorMessage? " << mContext->GetHexColor(textConfig.borderColorOnError) << ":" << mTextinput->GetId() << ".activeFocus? " << mContext->GetHexColor(textConfig.borderColorOnFocus) << " : " << mContext->GetHexColor(textConfig.borderColorNormal));
    mTextinputElement->Property("border.width", RendererQml::Formatter() << textConfig.borderWidth);
    mTextinputElement->Property("radius", RendererQml::Formatter() << textConfig.borderRadius);
    mTextinputElement->Property("height", RendererQml::Formatter() << textConfig.height);
    mTextinputElement->Property("width", "parent.width");
    mTextinputElement->Property("color", mContext->GetHexColor(textConfig.backgroundColorNormal));

    auto uiTextInput = createSingleLineTextFieldElement();

    auto clearIcon = RendererQml::AdaptiveCardQmlRenderer::GetClearIconButton(mContext);
    clearIcon->Property("id", RendererQml::Formatter() << mTextinput->GetId() << "_clear_icon");
    clearIcon->Property("visible", RendererQml::Formatter() << mTextinput->GetId() << ".text.length != 0");
    clearIcon->Property("onClicked", RendererQml::Formatter() << "{nextItemInFocusChain().forceActiveFocus();" << mTextinput->GetId() << ".clear()}");
    clearIcon->Property("Accessible.name", RendererQml::Formatter() << "String.raw`" << (mEscapedPlaceHolderString.empty() ? "Text" : mEscapedPlaceHolderString) << " clear`");
    clearIcon->Property("Accessible.role", "Accessible.Button");
    uiTextInput->Property("width", RendererQml::Formatter() << "parent.width");
    mTextinputElement->AddChild(uiTextInput);
    mTextinputElement->AddChild(clearIcon);
    mContext->addToInputElementList(mOriginalElementId, (uiTextInput->GetId() + ".text"));
    this->addInlineActionMode();

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (mTextinput->GetIsRequired() || !mTextinput->GetRegex().empty())
        {
            if(!mTextinput->GetErrorMessage().empty())
            { 
                auto label = createErrorMessageText(mTextinput->GetErrorMessage(), uiTextInput);
                mTextinputColElement->AddChild(label);
            }
            addValidationToInputText(uiTextInput);

        }
    }
}

void TextInputElement::initMultiLine()
{
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mTextinput->GetLabel().empty())
        {
            auto label = createInputTextLabel(mTextinput->GetIsRequired());
            mTextinputColElement->AddChild(label);
        }
        else
        {
            if (mTextinput->GetIsRequired())
            {
                mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "isRequired is not supported without labels"));
            }
        }
    }

    mTextinputElement = std::make_shared<RendererQml::QmlTag>("ScrollView");
    mTextinputElement->Property("width", "parent.width");
    mTextinputElement->Property("height", RendererQml::Formatter() << mTextinput->GetId() << ".visible ? " << textConfig.multiLineTextHeight << " : 0");
    mTextinputElement->Property("ScrollBar.vertical.interactive", "true");
    mTextinputElement->Property("ScrollBar.horizontal.interactive", "false");
    mTextinputElement->Property("ScrollBar.horizontal.visible", "false");

    if (mTextinput->GetHeight() == AdaptiveCards::HeightType::Stretch)
    {
        mTextinputElement->Property("height", RendererQml::Formatter() << "parent.height > 0 ? parent.height : " << textConfig.multiLineTextHeight);
    }

    auto uiTextInput = createMultiLineTextAreaElement();
    mTextinputElement->AddChild(uiTextInput);
    mContext->addToInputElementList(mOriginalElementId, (uiTextInput->GetId() + ".text"));
    this->addInlineActionMode();

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (mTextinput->GetIsRequired() || !mTextinput->GetRegex().empty())
        {
            if(!mTextinput->GetErrorMessage().empty())
            {
                auto label = createErrorMessageText(mTextinput->GetErrorMessage(), uiTextInput);
                mTextinputColElement->AddChild(label);
            }
            addValidationToInputText(uiTextInput);

        }
    }
}

void TextInputElement::addValidationToInputText(std::shared_ptr<RendererQml::QmlTag> &uiTextInput)
{
    if (mTextinput->GetIsVisible())
    {
        mContext->addToRequiredInputElementsIdList(uiTextInput->GetId());
    }
    uiTextInput->Property("property bool showErrorMessage", "false");
    uiTextInput->Property("onTextChanged", "validate()");
    std::ostringstream validator;
    validator << "function validate(){\n";
    if (!mTextinput->GetRegex().empty())
    {
        validator << "const regex = new RegExp('" << mTextinput->GetRegex() << "');\n";
    }
    validator << "var isValid = ";
    if (mTextinput->GetIsRequired() && !mTextinput->GetRegex().empty()) {
        validator << "(text !== '' && regex.test(text))";
    }
    else if (mTextinput->GetIsRequired() && mTextinput->GetRegex().empty()) {
        validator << "text !== ''";
    }
    else {
        validator << "text == '' || regex.test(text)";
    }
    validator << "\n" << "if (showErrorMessage) {\n"
        << "if (isValid) {\n" << "showErrorMessage = false\n" << "}\n}" << "return !isValid}\n";
    uiTextInput->AddFunctions(validator.str());
}

std::shared_ptr<RendererQml::QmlTag> TextInputElement::createSingleLineTextFieldElement()
{
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    auto uiTextInput = std::make_shared<RendererQml::QmlTag>("TextField");
    uiTextInput->Property("id", mTextinput->GetId());
    uiTextInput->Property("selectByMouse", "true");
    uiTextInput->Property("selectedTextColor", "'white'");
    uiTextInput->Property("color", mContext->GetHexColor(textConfig.textColor));
    uiTextInput->Property("placeholderTextColor", mContext->GetHexColor(textConfig.placeHolderColor));
    uiTextInput->Property("Accessible.role", "Accessible.EditableText");
    uiTextInput->AddFunctions(getAccessibleName(uiTextInput));

    auto backgroundTag = std::make_shared<RendererQml::QmlTag>("Rectangle");
    backgroundTag->Property("color", "'transparent'");
    uiTextInput->Property("background", backgroundTag->ToString());
    uiTextInput->AddFunctions(getColorFunction());
    uiTextInput->Property("onPressed", RendererQml::Formatter() << "{colorChange(" << mTextinputElement->GetId() << "," << mTextinput->GetId() << ",true);event.accepted = true;}");
    uiTextInput->Property("onReleased", RendererQml::Formatter() << "{colorChange(" << mTextinputElement->GetId() << "," << mTextinput->GetId() << ",false);forceActiveFocus();event.accepted = true;}");
    uiTextInput->Property("onHoveredChanged", RendererQml::Formatter() << "colorChange(" << mTextinputElement->GetId() << "," << mTextinput->GetId() << ",false)");
    uiTextInput->Property("onActiveFocusChanged", RendererQml::Formatter() << "{\n"
        << "colorChange(" << mTextinputElement->GetId() << "," << mTextinput->GetId() << ",false)\n" << "if(activeFocus){\n"
        << "Accessible.name = getAccessibleName()}}");

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (mTextinput->GetIsRequired() || !mTextinput->GetRegex().empty())
        {
            uiTextInput->Property("onShowErrorMessageChanged", RendererQml::Formatter() << "{\n"
                << "colorChange(" << mTextinputElement->GetId() << "," << mTextinput->GetId() << ",false)\n}");
        }
    }

    uiTextInput->Property("Accessible.name", "", true);
    uiTextInput->Property("leftPadding", RendererQml::Formatter() << textConfig.textHorizontalPadding);
    uiTextInput->Property("rightPadding", RendererQml::Formatter() << textConfig.textHorizontalPadding);
    uiTextInput->Property("topPadding", RendererQml::Formatter() << textConfig.textVerticalPadding);
    uiTextInput->Property("bottomPadding", RendererQml::Formatter() << textConfig.textVerticalPadding);
    uiTextInput->Property("padding", "0");

    if (mTextinput->GetMaxLength() > 0)
    {
        uiTextInput->Property("maximumLength", std::to_string(mTextinput->GetMaxLength()));
    }

    uiTextInput->Property("font.pixelSize", RendererQml::Formatter() << textConfig.pixelSize);

    if (!mTextinput->GetValue().empty())
    {
        uiTextInput->Property("text", mTextinput->GetValue(), true);
    }

    if (!mTextinput->GetPlaceholder().empty())
    {
        uiTextInput->Property("placeholderText", RendererQml::Formatter() << "activeFocus? '' : String.raw`" << mEscapedPlaceHolderString << "`");
    }

    return uiTextInput;
}
std::shared_ptr<RendererQml::QmlTag> TextInputElement::createMultiLineTextAreaElement()
{
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    auto uiTextInput = std::make_shared<RendererQml::QmlTag>("TextArea");
    uiTextInput->Property("id", mTextinput->GetId());
    uiTextInput->Property("wrapMode", "Text.Wrap");
    uiTextInput->Property("selectByMouse", "true");
    uiTextInput->Property("selectedTextColor", "'white'");
    uiTextInput->Property("topPadding", RendererQml::Formatter() << textConfig.multiLineTextTopPadding);
    uiTextInput->Property("bottomPadding", RendererQml::Formatter() << textConfig.multiLineTextBottomPadding);
    uiTextInput->Property("color", mContext->GetHexColor(textConfig.textColor));
    uiTextInput->Property("placeholderTextColor", mContext->GetHexColor(textConfig.placeHolderColor));
    uiTextInput->Property("leftPadding", RendererQml::Formatter() << textConfig.textHorizontalPadding);
    uiTextInput->Property("rightPadding", RendererQml::Formatter() << textConfig.textHorizontalPadding);
    uiTextInput->Property("Accessible.role", "Accessible.EditableText");
    uiTextInput->AddFunctions(getAccessibleName(uiTextInput));

    if (mTextinput->GetMaxLength() > 0)
    {
        uiTextInput->Property("onTextChanged", RendererQml::Formatter() << "remove(" << mTextinput->GetMaxLength() << ", length)");
    }

    auto backgroundTag = createMultiLineBackgroundElement();
    uiTextInput->Property("background", backgroundTag->ToString());
    uiTextInput->AddFunctions(getColorFunction());
    uiTextInput->Property("onPressed", RendererQml::Formatter() << "{colorChange(" << backgroundTag->GetId() << "," << mTextinput->GetId() << ",true);event.accepted = true;}");
    uiTextInput->Property("onReleased", RendererQml::Formatter() << "{colorChange(" << backgroundTag->GetId() << "," << mTextinput->GetId() << ",false);forceActiveFocus();event.accepted = true;}");
    uiTextInput->Property("onHoveredChanged", RendererQml::Formatter() << "colorChange(" << backgroundTag->GetId() << "," << mTextinput->GetId() << ",false)");
    uiTextInput->Property("onActiveFocusChanged", RendererQml::Formatter() << "{\n"
        << "colorChange(" << backgroundTag->GetId() << "," << mTextinput->GetId() << ",false)\n" << "if(activeFocus){\n"
        << "Accessible.name = getAccessibleName()}}");

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (mTextinput->GetIsRequired() || !mTextinput->GetErrorMessage().empty())
        {
            uiTextInput->Property("onShowErrorMessageChanged", RendererQml::Formatter() << "{\n"
                << "colorChange(" << backgroundTag->GetId() << "," << mTextinput->GetId() << ",false)\n}");
        }
    }

    uiTextInput->Property("Accessible.name", "", true);
    uiTextInput->Property("Keys.onTabPressed", "{nextItemInFocusChain().forceActiveFocus(); event.accepted = true;}");
    uiTextInput->Property("Keys.onBacktabPressed", "{nextItemInFocusChain(false).forceActiveFocus(); event.accepted = true;}");
    uiTextInput->Property("font.pixelSize", RendererQml::Formatter() << textConfig.pixelSize);

    if (!mTextinput->GetValue().empty())
    {
        uiTextInput->Property("text", mTextinput->GetValue(), true);
    }

    if (!mTextinput->GetPlaceholder().empty())
    {
        uiTextInput->Property("placeholderText", RendererQml::Formatter() << "activeFocus? '' : String.raw`" << mEscapedPlaceHolderString << "`");
    }

    return uiTextInput;
}

std::shared_ptr<RendererQml::QmlTag> TextInputElement::createMultiLineBackgroundElement()
{
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    auto backgroundTag = std::make_shared<RendererQml::QmlTag>("Rectangle");
    backgroundTag->Property("radius", RendererQml::Formatter() << textConfig.borderRadius);
    backgroundTag->Property("id", RendererQml::Formatter() << mTextinput->GetId() << "_background");
    backgroundTag->Property("color", mContext->GetHexColor(textConfig.backgroundColorNormal));
    backgroundTag->Property("border.color", RendererQml::Formatter() << mTextinput->GetId() << ".showErrorMessage? " << mContext->GetHexColor(textConfig.borderColorOnError) << ":" << mTextinput->GetId() << ".activeFocus? " << mContext->GetHexColor(textConfig.borderColorOnFocus) << " : " << mContext->GetHexColor(textConfig.borderColorNormal));
    backgroundTag->Property("border.width", RendererQml::Formatter() << textConfig.borderWidth);
    return backgroundTag;
}

void TextInputElement::addInlineActionMode()
{
    auto temp = mTextinput->GetLabel();
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    if (mContext->GetConfig()->GetSupportsInteractivity() && mTextinput->GetInlineAction() != nullptr)
    {
        // ShowCard Inline Action Mode is not supported
        if (mTextinput->GetInlineAction()->GetElementType() == AdaptiveCards::ActionType::ShowCard &&
            mContext->GetConfig()->GetActions().showCard.actionMode == AdaptiveCards::ActionMode::Inline)
        {
            mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "Inline ShowCard not supported for InlineAction"));
            mTextinputColElement->AddChild(mTextinputElement);
        }

        else
        {
            mContainer = std::make_shared<RendererQml::QmlTag>("Row");
            mContainer->Property("id", RendererQml::Formatter() << mTextinput->GetId() << "_row");
            mContainer->Property("spacing", "5");
            mContainer->Property("width", "parent.width");

            auto buttonElement = RendererQml::AdaptiveCardQmlRenderer::AdaptiveActionRender(mTextinput->GetInlineAction(), mContext);

            if (mTextinput->GetIsMultiline())
            {
                buttonElement->Property("anchors.bottom", "parent.bottom");
            }
            mTextinputElement->Property("width", RendererQml::Formatter() << "parent.width - " << buttonElement->GetId() << ".width - " << mContainer->GetId() << ".spacing");
            mContainer->AddChild(mTextinputElement);
            mContainer->AddChild(buttonElement);
            mTextinputColElement->AddChild(mContainer);

            if (mTextinput->GetHeight() == AdaptiveCards::HeightType::Stretch)
            {
                mContainer->Property("height", RendererQml::Formatter() << "parent.height > 0 ? parent.height : " << textConfig.multiLineTextHeight);
            }
        }
    }
    else
    {
        mTextinputColElement->AddChild(mTextinputElement);
    }

}

const std::string TextInputElement::getColorFunction()
{
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    std::string colorFunction = RendererQml::Formatter() << "function colorChange(colorItem,focusItem,isPressed) {\n"
        "if (isPressed && !focusItem.showErrorMessage) {\n"
        "colorItem.color = " << mContext->GetHexColor(textConfig.backgroundColorOnPressed) << "\n"
        "}\n"
        "else {\n"
        "colorItem.color = focusItem.showErrorMessage ? " << mContext->GetHexColor(textConfig.backgroundColorOnError) << " : focusItem.activeFocus ? " << mContext->GetHexColor(textConfig.backgroundColorOnPressed) << " : focusItem.hovered ? " << mContext->GetHexColor(textConfig.backgroundColorOnHovered) << " : " << mContext->GetHexColor(textConfig.backgroundColorNormal) << "\n"
        "}\n"
        "}\n";
    return colorFunction;
}

std::string TextInputElement::getAccessibleName(std::shared_ptr<RendererQml::QmlTag> uiTextInput)
{
    std::ostringstream accessibleName;
    std::ostringstream labelString;
    std::ostringstream errorString;
    std::ostringstream placeHolderString;

    if(mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mTextinput->GetLabel().empty())
        {
            labelString << "accessibleName += '" << mTextinput->GetLabel() << ". ';";
        }

        if(!mTextinput->GetErrorMessage().empty())
        {
            errorString << "if(" << uiTextInput->GetId() << ".showErrorMessage === true){"
                << "accessibleName += 'Error. " << mTextinput->GetErrorMessage() << ". ';}";
        }
    }

    placeHolderString << "if(" << uiTextInput->GetId() << ".text !== ''){"
        << "accessibleName += (" << uiTextInput->GetId() << ".text + '. ');"
        << "}else{"
        << "accessibleName += String.raw`" << (mTextinput->GetPlaceholder().empty() ? "Text Block" : mEscapedPlaceHolderString) << "`;}";

    accessibleName << "function getAccessibleName(){"
        << "let accessibleName = '';" << errorString.str() << labelString.str() << placeHolderString.str() << "return accessibleName;}";

    return accessibleName.str();
}
