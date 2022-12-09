#include "TextInputRender.h"
#include "Formatter.h"
#include "utils.h"

TextInputElement::TextInputElement(std::shared_ptr<AdaptiveCards::TextInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context)
	:mTextinput(input),
	mContext(context),
    mContainer(nullptr)
{
    mTextinputColElement = std::make_shared<RendererQml::QmlTag>("TextInputRender");
    initialize();
}

std::shared_ptr<RendererQml::QmlTag> TextInputElement::getQmlTag()
{
    return mTextinputColElement;
}

void TextInputElement::initialize()
{
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    mContext->addHeightEstimate(mTextinput->GetIsMultiline() ? textConfig.multiLineTextHeight : textConfig.height);

    mOriginalElementId = mTextinput->GetId();
    mEscapedPlaceHolderString = RendererQml::Utils::getBackQuoteEscapedString(mTextinput->GetPlaceholder());
    mEscapedValueString = RendererQml::Utils::getBackQuoteEscapedString(mTextinput->GetValue());

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        mEscapedLabelString = RendererQml::Utils::getBackQuoteEscapedString(mTextinput->GetLabel());
        mEscapedErrorString = RendererQml::Utils::getBackQuoteEscapedString(mTextinput->GetErrorMessage());
    }

    mTextinput->SetId(mContext->ConvertToValidId(mTextinput->GetId()));
    mTextinputColElement->Property("id", mTextinput->GetId());
    mTextinput->SetId(mTextinput->GetId() + "_textField");
    
    mTextinputColElement->Property("visible", mTextinput->GetIsVisible() ? "true" : "false");



    /* Setting QML Properties */

    mTextinputColElement->Property("_spacing", RendererQml::Formatter() << RendererQml::Utils::GetSpacing(mContext->GetConfig()->GetSpacing(), AdaptiveCards::Spacing::Small));
    mTextinputColElement->Property("id", mTextinput->GetId());
    std::string color = mContext->GetColor(AdaptiveCards::ForegroundColor::Default, false, false);
    mTextinputColElement->Property("_labelColor", color);
    mTextinputColElement->Property("_isRequired", mTextinput->GetIsRequired() == true ? "true" : "false");
    mTextinputColElement->Property("_mEscapedLabelString", RendererQml::Formatter() << "String.raw`" << mEscapedLabelString << "`");
    mTextinputColElement->Property("_mEscapedErrorString", RendererQml::Formatter() << "String.raw`" << mEscapedErrorString << "`");
    mTextinputColElement->Property("_mEscapedPlaceHolderString", RendererQml::Formatter() << "String.raw`" << mEscapedPlaceHolderString << "`");
    mTextinputColElement->Property("_mEscapedValueString", RendererQml::Formatter() << "String.raw`" << mEscapedValueString << "`");
    if (mContext->GetConfig()->GetSupportsInteractivity() && mTextinput->GetInlineAction() != nullptr)
    {
        mTextinputColElement->Property("_supportsInterActivity", "true");
        if (mTextinput->GetInlineAction()->GetElementType() == AdaptiveCards::ActionType::ShowCard &&
            mContext->GetConfig()->GetActions().showCard.actionMode == AdaptiveCards::ActionMode::Inline)
        {
            mTextinputColElement->Property("_supportsInlineAction", "false");
        }
        else
        {
            mTextinputColElement->Property("_supportsInlineAction", "true");
        }
    }
    else
    {
        mTextinputColElement->Property("_supportsInterActivity", "false");
        mTextinputColElement->Property("_supportsInlineAction", "false");
    }
    //mTextinputColElement->Property("_heightType", RendererQml::Formatter() << mTextinput->GetHeight());
    if (mTextinput->GetRegex() != "")
    {
        mTextinputColElement->Property("_regex", RendererQml::Formatter() << "String.raw`" << mTextinput->GetRegex() << "`");
    }
    mTextinputColElement->Property("_maxLength", RendererQml::Formatter() << mTextinput->GetMaxLength());
    /* Ends Here */


    mContext->addHeightEstimate(mContext->getEstimatedTextHeight(mTextinput->GetLabel()));
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (mTextinput->GetLabel().empty())
        {
            if (mTextinput->GetIsRequired())
            {
                mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "isRequired is not supported without labels"));
            }
        }
    }

    mContext->addToInputElementList(mOriginalElementId, (mTextinput->GetId() + "._submitValue"));
    if (mTextinput->GetIsMultiline())
    {
        mTextinputColElement->Property("_isMultiLineText", "true");
        initMultiLine();
    }
    else
    {
        mTextinputColElement->Property("_isMultiLineText", "false");
        initSingleLine();
    }
}

void TextInputElement::initSingleLine()
{
   
    this->addInlineActionMode();
}

void TextInputElement::initMultiLine()
{
   
    // To be discussed mTextinputElement->Property("height", RendererQml::Formatter() << mTextinput->GetId() << ".visible ? " << textConfig.multiLineTextHeight << " : 0");

    this->addInlineActionMode();

    /*if (mTextinput->GetHeight() == AdaptiveCards::HeightType::Stretch)
    {
        std::string spacing = std::to_string(RendererQml::Utils::GetSpacing(mContext->GetConfig()->GetSpacing(), AdaptiveCards::Spacing::Small));
        std::string labelHeight = RendererQml::Formatter() << (mLabelId.empty() ? 0 : (mLabelId + ".height + " + spacing));
        std::string errorMessageHeight = RendererQml::Formatter() << (mErrorMessageId.empty() ? 0 : (mErrorMessageId + ".visible ? " + mErrorMessageId + ".implicitHeight + " + spacing + ": 0"));
        mTextinputElement->Property("height", RendererQml::Formatter() << "parent.height > 0 ? (parent.height - (" << labelHeight << ") - (" << errorMessageHeight << " )): " << textConfig.multiLineTextHeight);
    }*/

    //mTextinputElement->AddChild(mScrollViewWrapper);
}


void TextInputElement::addInlineActionMode()
{
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
}
