#include "TextInputRender.h"
#include "Formatter.h"
#include "QmlScrollView.h"
#include <iostream>
#include "QmlRectangle.h"
#include "utils.h"

TextinputElement::TextinputElement(std::shared_ptr<AdaptiveCards::TextInput> input, std::shared_ptr<RendererQml::AdaptiveRenderContext> context)
	:mTextinput(input),
	mContext(context),
    mContainer(nullptr)
{  
}


std::shared_ptr<RendererQml::QmlTag> TextinputElement::getQmlString()
{
    return mTextinputColElement;
}

void TextinputElement::initialize()
{
    mTextinput->SetId(mContext->ConvertToValidId(mTextinput->GetId()));
    if (mTextinput->GetIsMultiline()) {
        initMultiLine();
    }
    else{
        initSingleLine();
    }
}

std::shared_ptr<RendererQml::QmlTag> TextinputElement::createInputTextLabel(bool isRequired)
{
    auto label = std::make_shared<RendererQml::QmlTag>("Label");
    label->Property("id", RendererQml::Formatter() << mTextinput->GetId() << "_label");
    label->Property("wrapMode", "Text.Wrap");
    label->Property("width", "parent.width");
    if (isRequired)
        label->Property("text", RendererQml::Formatter() << (mTextinput->GetLabel().empty() ? "Text" : mTextinput->GetLabel()) << " *", true);
    else
        label->Property("text", RendererQml::Formatter() << (mTextinput->GetLabel().empty() ? "Text" : mTextinput->GetLabel()), true);

    return label;
}

std::shared_ptr<RendererQml::QmlTag> TextinputElement::createErrorMessageText(std::string errorMessage)
{

    auto uiErrorMessage = std::make_shared<AdaptiveCards::TextBlock>();

    uiErrorMessage->SetText(errorMessage);
    uiErrorMessage->SetTextSize(mContext->GetConfig()->GetFactSet().value.size);
    uiErrorMessage->SetTextColor(mContext->GetConfig()->GetFactSet().value.color);
    uiErrorMessage->SetTextWeight(mContext->GetConfig()->GetFactSet().value.weight);
    uiErrorMessage->SetIsSubtle(mContext->GetConfig()->GetFactSet().value.isSubtle);
    uiErrorMessage->SetWrap(mContext->GetConfig()->GetFactSet().value.wrap);
    // MaxWidth is not supported on the Value of FactSet. Do not set it.
    auto uiValue = mContext->Render(uiErrorMessage);
    return uiValue;
}

void TextinputElement::initSingleLine()
{
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    mTextinputColElement = std::make_shared<RendererQml::QmlTag>("Column");
    mTextinputColElement->Property("id", RendererQml::Formatter() << mTextinput->GetId() << "_column");
    mTextinputColElement->Property("spacing", RendererQml::Formatter() << RendererQml::Utils::GetSpacing(mContext->GetConfig()->GetSpacing(), AdaptiveCards::Spacing::Small));
    mTextinputColElement->Property("width", "parent.width");
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

    mTextinputElement = std::make_shared<QmlRectangle>(RendererQml::Formatter() << mTextinput->GetId() << "_wrapper", std::make_shared<RendererQml::QmlTag>("Rectangle"));
    mTextinputElement.get()->setBorderColor(RendererQml::Formatter() << mTextinput->GetId() << ".activeFocus? " << mContext->GetHexColor(textConfig.borderColorOnFocus) << " : " << mContext->GetHexColor(textConfig.borderColorNormal));
    mTextinputElement->setBorderWidth(RendererQml::Formatter() << textConfig.borderWidth);
    mTextinputElement->setRadius(RendererQml::Formatter() << textConfig.borderRadius);
    mTextinputElement->setHeight(RendererQml::Formatter() << textConfig.height);
    mTextinputElement->setWidth("parent.width");
    mTextinputElement->setColor(mContext->GetHexColor(textConfig.backgroundColorNormal));
    mTextinputElement->setVisible(mTextinput->GetIsVisible() ? "true" : "false");

    auto uiTextInput = createSingleLineTextFieldElement();

    auto clearIcon = RendererQml::AdaptiveCardQmlRenderer::GetClearIconButton(mContext);
    clearIcon->Property("id", RendererQml::Formatter() << mTextinput->GetId() << "_clear_icon");
    clearIcon->Property("visible", RendererQml::Formatter() << mTextinput->GetId() << ".text.length != 0");
    clearIcon->Property("onClicked", RendererQml::Formatter() << "{nextItemInFocusChain().forceActiveFocus();" << mTextinput->GetId() << ".clear()}");
    clearIcon->Property("Accessible.name", RendererQml::Formatter() << (mTextinput->GetPlaceholder().empty() ? "Text" : mTextinput->GetPlaceholder()) << " clear", true);
    clearIcon->Property("Accessible.role", "Accessible.Button");
    uiTextInput->Property("width", RendererQml::Formatter() << "parent.width - " << clearIcon->GetId() << ".width - " << textConfig.clearIconHorizontalPadding);
    mTextinputElement->addChild(uiTextInput);
    mTextinputElement->addChild(clearIcon);
    mContext->addToInputElementList(mTextinput->GetId(), (uiTextInput->GetId() + ".text"));
    this->addInlineActionMode();

    if (!mTextinput->GetErrorMessage().empty())
    {
        auto label = createErrorMessageText(mTextinput->GetErrorMessage());
        mTextinputColElement->AddChild(label);
    }
}

void TextinputElement::initMultiLine()
{
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    mTextinputColElement = std::make_shared<RendererQml::QmlTag>("Column");
    mTextinputColElement->Property("id", RendererQml::Formatter() << mTextinput->GetId() << "_column");
    mTextinputColElement->Property("spacing", RendererQml::Formatter() << RendererQml::Utils::GetSpacing(mContext->GetConfig()->GetSpacing(), mTextinput->GetSpacing()));
    mTextinputColElement->Property("width", "parent.width");
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
    mTextinputElement = std::make_shared<QmlScrollView>(RendererQml::Formatter() << mTextinput->GetId() << "_wrapper", std::make_shared<RendererQml::QmlTag>("ScrollView"));
    mTextinputElement->setWidth("parent.width");
    mTextinputElement->setHeight(RendererQml::Formatter() << mTextinput->GetId() << ".visible ? " << textConfig.multiLineTextHeight << " : 0");
    mTextinputElement->setScrollViewVerticalInteractive("true");
    mTextinputElement->setScrollViewHorizontalInteractive("false");
    mTextinputElement->setScrollViewHorizontalVisible("false");
    mTextinputElement->setVisible(mTextinput->GetIsVisible() ? "true" : "false");

    auto uiTextInput = createMultiLineTextAreaElement();
    mTextinputElement->addChild(uiTextInput);
    mContext->addToInputElementList(mTextinput->GetId(), (uiTextInput->GetId() + ".text"));
    this->addInlineActionMode();
}


std::shared_ptr<RendererQml::QmlTag> TextinputElement::createSingleLineTextFieldElement()
{
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    auto uiTextInput = std::make_shared<RendererQml::QmlTag>("TextField");
    uiTextInput->Property("id", mTextinput->GetId());
    uiTextInput->Property("selectByMouse", "true");
    uiTextInput->Property("selectedTextColor", "'white'");
    uiTextInput->Property("color", mContext->GetHexColor(textConfig.textColor));
    uiTextInput->Property("placeholderTextColor", mContext->GetHexColor(textConfig.placeHolderColor));

    auto backgroundTag = std::make_shared<RendererQml::QmlTag>("Rectangle");
    backgroundTag->Property("color", "'transparent'");
    uiTextInput->Property("background", backgroundTag->ToString());
    uiTextInput->AddFunctions(getColorFunction());
    uiTextInput->Property("onPressed", RendererQml::Formatter() << "colorChange(" << mTextinputElement->getId() << "," << mTextinput->GetId() << ",true)");
    uiTextInput->Property("onReleased", RendererQml::Formatter() << "colorChange(" << mTextinputElement->getId() << "," << mTextinput->GetId() << ",false)");
    uiTextInput->Property("onHoveredChanged", RendererQml::Formatter() << "colorChange(" << mTextinputElement->getId() << "," << mTextinput->GetId() << ",false)");
    uiTextInput->Property("onActiveFocusChanged", RendererQml::Formatter() << "colorChange(" << mTextinputElement->getId() << "," << mTextinput->GetId() << ",false)");
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
    uiTextInput->Property("Accessible.name", mTextinput->GetPlaceholder().empty() ? "Text Field" : mTextinput->GetPlaceholder(), true);
    uiTextInput->Property("Accessible.role", "Accessible.EditableText");


    if (!mTextinput->GetValue().empty())
    {
        uiTextInput->Property("text", mTextinput->GetValue(), true);
    }

    if (!mTextinput->GetPlaceholder().empty())
    {
        uiTextInput->Property("placeholderText", RendererQml::Formatter() << "activeFocus? \"\" : " << "\"" << mTextinput->GetPlaceholder() << "\"");
    }

    //TODO: Add stretch property

    if (!mTextinput->GetIsVisible())
    {
        uiTextInput->Property("visible", "false");
    }
    return uiTextInput;
}
std::shared_ptr<RendererQml::QmlTag> TextinputElement::createMultiLineTextAreaElement()
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

    if (mTextinput->GetMaxLength() > 0)
    {
        uiTextInput->Property("onTextChanged", RendererQml::Formatter() << "remove(" << mTextinput->GetMaxLength() << ", length)");
    }

    auto backgroundTag = createMultiLineBackgroundElement();
    uiTextInput->Property("background", backgroundTag->ToString());
    uiTextInput->AddFunctions(getColorFunction());
    uiTextInput->Property("onPressed", RendererQml::Formatter() << "colorChange(" << backgroundTag->GetId() << "," << mTextinput->GetId() << ",true)");
    uiTextInput->Property("onReleased", RendererQml::Formatter() << "colorChange(" << backgroundTag->GetId() << "," << mTextinput->GetId() << ",false)");
    uiTextInput->Property("onHoveredChanged", RendererQml::Formatter() << "colorChange(" << backgroundTag->GetId() << "," << mTextinput->GetId() << ",false)");
    uiTextInput->Property("onActiveFocusChanged", RendererQml::Formatter() << "colorChange(" << backgroundTag->GetId() << "," << mTextinput->GetId() << ",false)");
    uiTextInput->Property("Keys.onTabPressed", "{nextItemInFocusChain().forceActiveFocus(); event.accepted = true;}");
    uiTextInput->Property("Keys.onBacktabPressed", "{nextItemInFocusChain(false).forceActiveFocus(); event.accepted = true;}");
    uiTextInput->Property("font.pixelSize", RendererQml::Formatter() << textConfig.pixelSize);
    uiTextInput->Property("Accessible.name", mTextinput->GetPlaceholder().empty() ? "Text Field" : mTextinput->GetPlaceholder(), true);
    uiTextInput->Property("Accessible.role", "Accessible.EditableText");


    if (!mTextinput->GetValue().empty())
    {
        uiTextInput->Property("text", mTextinput->GetValue(), true);
    }

    if (!mTextinput->GetPlaceholder().empty())
    {
        uiTextInput->Property("placeholderText", RendererQml::Formatter() << "activeFocus? \"\" : " << "\"" << mTextinput->GetPlaceholder() << "\"");
    }

    //TODO: Add stretch property

    if (!mTextinput->GetIsVisible())
    {
        uiTextInput->Property("visible", "false");
    }
    return uiTextInput;
}

std::shared_ptr<RendererQml::QmlTag> TextinputElement::createMultiLineBackgroundElement()
{
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    auto backgroundTag = std::make_shared<QmlRectangle>(RendererQml::Formatter() << mTextinput->GetId() << "_background", std::make_shared<RendererQml::QmlTag>("Rectangle"));
    backgroundTag->setRadius(RendererQml::Formatter() << textConfig.borderRadius);   
    backgroundTag->setColor(mContext->GetHexColor(textConfig.backgroundColorNormal));
    backgroundTag->setBorderColor(RendererQml::Formatter() << mTextinput->GetId() << ".activeFocus? " << mContext->GetHexColor(textConfig.borderColorOnFocus) << " : " << mContext->GetHexColor(textConfig.borderColorNormal));
    backgroundTag->setBorderWidth(RendererQml::Formatter() << textConfig.borderWidth);
    return backgroundTag->getQmlString();
}

void TextinputElement::addInlineActionMode()
{
    auto temp = mTextinput->GetLabel();
    if (mContext->GetConfig()->GetSupportsInteractivity() && mTextinput->GetInlineAction() != nullptr)
    {
        // ShowCard Inline Action Mode is not supported
        if (mTextinput->GetInlineAction()->GetElementType() == AdaptiveCards::ActionType::ShowCard &&
            mContext->GetConfig()->GetActions().showCard.actionMode == AdaptiveCards::ActionMode::Inline)
        {
            mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "Inline ShowCard not supported for InlineAction"));
            mTextinputColElement->AddChild(mTextinputElement->getQmlString());
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

            mTextinputElement->setWidth(RendererQml::Formatter() << "parent.width - " << buttonElement->GetId() << ".width - " << mContainer->GetId() << ".spacing");
            mContainer->AddChild(mTextinputElement->getQmlString());
            mContainer->AddChild(buttonElement);
            mTextinputColElement->AddChild(mContainer);
        }
    }
    else {
        mTextinputColElement->AddChild(mTextinputElement->getQmlString());
    }
    
}

const std::string TextinputElement::getColorFunction()
{
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    std::string colorFunction = RendererQml::Formatter() << "function colorChange(colorItem,focusItem,isPressed) {\n"
        "if (isPressed) {\n"
        "colorItem.color = " << mContext->GetHexColor(textConfig.backgroundColorOnPressed) << "\n"
        "}\n"
        "else {\n"
        "colorItem.color = focusItem.activeFocus ? " << mContext->GetHexColor(textConfig.backgroundColorOnPressed) << " : focusItem.hovered ? " << mContext->GetHexColor(textConfig.backgroundColorOnHovered) << " : " << mContext->GetHexColor(textConfig.backgroundColorNormal) << "\n"
        "}\n"
        "}\n";
    return colorFunction;
}
