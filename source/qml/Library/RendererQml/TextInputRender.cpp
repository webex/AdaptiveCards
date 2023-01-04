#include "TextInputRender.h"
#include "Formatter.h"
#include "utils.h"

TextInputElement::TextInputElement(std::shared_ptr<AdaptiveCards::TextInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context)
	:mTextinput(input),
	mContext(context)
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
    mContext->addHeightEstimate(mContext->getEstimatedTextHeight(mTextinput->GetLabel()));

    mOriginalElementId = mTextinput->GetId();
    std::string mEscapedPlaceHolderString = RendererQml::Utils::getBackQuoteEscapedString(mTextinput->GetPlaceholder());
    std::string mEscapedValueString = RendererQml::Utils::getBackQuoteEscapedString(mTextinput->GetValue());

    std::string mEscapedErrorString{ "" };
    std::string mEscapedLabelString{ "" };
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
            mTextinputColElement->Property("_isInlineShowCardAction", "true");
        }
        else
        {
            mTextinputColElement->Property("_isInlineShowCardAction", "false");
        }
    }
    else
    {
        mTextinputColElement->Property("_supportsInterActivity", "false");
        mTextinputColElement->Property("_isInlineShowCardAction", "false");
    }
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

    if (mTextinput->GetHeight() == AdaptiveCards::HeightType::Stretch)
    {
        mTextinputColElement->Property("_isheightStreched", mTextinput->GetHeight() == AdaptiveCards::HeightType::Stretch ? "true" : "false");
    }

    if (mTextinput->GetIsMultiline())
    {
        mTextinputColElement->Property("_isMultiLineText", "true");
        addActions();
    }
    else
    {
        mTextinputColElement->Property("_isMultiLineText", "false");
        addActions();
    }
}


void TextInputElement::addActions()
{
    const auto textConfig = mContext->GetRenderConfig()->getInputTextConfig();
    if (mContext->GetConfig()->GetSupportsInteractivity() && mTextinput->GetInlineAction() != nullptr)
    {
        // ShowCard Inline Action Mode is not supported
        if (mTextinput->GetInlineAction()->GetElementType() == AdaptiveCards::ActionType::ShowCard &&
            mContext->GetConfig()->GetActions().showCard.actionMode == AdaptiveCards::ActionMode::Inline)
        {
            mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "Inline ShowCard not supported for InlineAction"));
        }

        else {
            std::shared_ptr<AdaptiveCards::BaseActionElement> action = mTextinput->GetInlineAction();
            auto context = mContext;

            auto buttonElement = std::make_shared<RendererQml::QmlTag>("AdaptiveActionRender");

            if (!RendererQml::Utils::IsNullOrWhitespace(action->GetStyle()) && !RendererQml::Utils::CaseInsensitiveCompare(action->GetStyle(), "default"))
            {
                if (RendererQml::Utils::CaseInsensitiveCompare(action->GetStyle(), "positive"))
                {
                    mTextinputColElement->Property("buttonConfigType", "'positiveColorConfig'");
                }
                else if (RendererQml::Utils::CaseInsensitiveCompare(action->GetStyle(), "destructive"))
                {
                    mTextinputColElement->Property("buttonConfigType", "'destructiveColorConfig'");
                }
                else
                {
                    mTextinputColElement->Property("buttonConfigType", "'primaryColorConfig'");
                }
            }
            else
            {
                mTextinputColElement->Property("buttonConfigType", "'primaryColorConfig'");
            }

            mTextinputColElement->Property("isIconLeftOfTitle", context->GetConfig()->GetActions().iconPlacement == AdaptiveCards::IconPlacement::LeftOfTitle ? "true" : "false");
            mTextinputColElement->Property("escapedTitle", RendererQml::Formatter() << "String.raw`" << RendererQml::Utils::getBackQuoteEscapedString(action->GetTitle()) << "`");
            // always sending as false not supported 
            mTextinputColElement->Property("isShowCardButton", "false");
            mTextinputColElement->Property("isActionSubmit", action->GetElementTypeString() == "Action.Submit" ? "true" : "false");
            mTextinputColElement->Property("isActionOpenUrl", action->GetElementTypeString() == "Action.OpenUrl" ? "true" : "false");
            mTextinputColElement->Property("isActionToggleVisibility", action->GetElementTypeString() == "Action.ToggleVisibility" ? "true" : "false");

            if (!action->GetIconUrl().empty())
            {
                mTextinputColElement->Property("hasIconUrl", "true");
                mTextinputColElement->Property("imgSource", RendererQml::AdaptiveCardQmlRenderer::GetImagePath(context, action->GetIconUrl()), true);
            }
            std::string selectActionId = "";
            if (action->GetElementTypeString() == "Action.OpenUrl")
            {
                RendererQml::AdaptiveCardQmlRenderer::getActionData(context, action, selectActionId);

            }
            else if (action->GetElementTypeString() == "Action.ToggleVisibility")
            {
                mTextinputColElement->Property("toggleVisibilityTarget", RendererQml::AdaptiveCardQmlRenderer::getActionData(context, action, selectActionId));
            }
            else if (action->GetElementTypeString() == "Action.Submit")
            {
                mTextinputColElement->Property("paramStr", RendererQml::Formatter() << "String.raw`" << RendererQml::AdaptiveCardQmlRenderer::getActionData(context, action, selectActionId) << "`");
            }
            mTextinputColElement->Property("is1_3Enabled", context->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled() == true ? "true" : "false");
            mTextinputColElement->Property("adaptiveCard", "adaptiveCard");
            mTextinputColElement->Property("selectActionId", RendererQml::Formatter() << "String.raw`" << selectActionId << "`");

        }
    }
}
