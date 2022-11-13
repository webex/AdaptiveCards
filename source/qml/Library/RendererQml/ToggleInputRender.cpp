#include "ToggleInputRender.h"
#include "Formatter.h"
#include "Utils.h"

ToggleInputElement::ToggleInputElement(std::shared_ptr<AdaptiveCards::ToggleInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context)
    :mToggleInput(input),
    mContext(context),
    mToggleInputConfig(context->GetRenderConfig()->getToggleButtonConfig()),
    origionalElementId(mToggleInput->GetId())
{
    mToggleInputColElement = std::make_shared<RendererQml::QmlTag>("ToggleInputRender");
    initialize();
    addInputLabel();
    addErrorMessage();
    addCheckBox();
    addValidation();
}

std::shared_ptr<RendererQml::QmlTag> ToggleInputElement::getQmlTag()
{
    return mToggleInputColElement;
}

void ToggleInputElement::initialize()
{
    mToggleInput->SetId(mContext->ConvertToValidId(mToggleInput->GetId()));

    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        mEscapedLabelString = RendererQml::Utils::getBackQuoteEscapedString(mToggleInput->GetLabel());
        mEscapedErrorString = RendererQml::Utils::getBackQuoteEscapedString(mToggleInput->GetErrorMessage());
    }
    mToggleInputColElement->Property("id", RendererQml::Formatter() << mToggleInput->GetId());
    mToggleInputColElement->Property("_adaptiveCard", "adaptiveCard");
    mToggleInputColElement->Property("spacing", RendererQml::Formatter() << RendererQml::Utils::GetSpacing(mContext->GetConfig()->GetSpacing(), AdaptiveCards::Spacing::Small));
    mToggleInputColElement->Property("visible", mToggleInput->GetIsVisible() ? "true" : "false");
}

void ToggleInputElement::addCheckBox()
{
    const auto valueOn = !mToggleInput->GetValueOn().empty() ? mToggleInput->GetValueOn() : "true";
    const auto valueOff = !mToggleInput->GetValueOff().empty() ? mToggleInput->GetValueOff() : "false";
    const bool isChecked = mToggleInput->GetValue().compare(valueOn) == 0 ? true : false;
    const auto mCheckBoxConfig = mContext->GetRenderConfig()->getToggleButtonConfig();
    mContext->addHeightEstimate(mCheckBoxConfig.rowHeight);
    const RendererQml::Checkbox mCheckBox = RendererQml::Checkbox(mToggleInput->GetId() + "_inputToggle",
        RendererQml::CheckBoxType::Toggle,
        mToggleInput->GetTitle(),
        mToggleInput->GetValue(),
        valueOn,
        valueOff,
        mToggleInput->GetWrap(),
        mToggleInput->GetIsVisible(),
        isChecked);
    std::string mEscapedValueOn = RendererQml::Utils::getBackQuoteEscapedString(mCheckBox.valueOn);
    std::string mEscapedValueOff = RendererQml::Utils::getBackQuoteEscapedString(mCheckBox.valueOff);
    mToggleInputColElement->Property("_cbValueOn", RendererQml::Formatter() << "String.raw`" << mEscapedValueOn << "`");
    mToggleInputColElement->Property("_cbValueOff", RendererQml::Formatter() << "String.raw`" << mEscapedValueOff << "`");
    mToggleInputColElement->Property("_cbText", RendererQml::Formatter() << "String.raw`" << RendererQml::Utils::getBackQuoteEscapedString(mCheckBox.text) << "`");

    std::string text = RendererQml::TextUtils::ApplyTextFunctions(mCheckBox.text, mContext->GetLang());

    auto markdownParser = std::make_shared<AdaptiveSharedNamespace::MarkDownParser>(text);
    text = markdownParser->TransformToHtml();
    text = RendererQml::Utils::HandleEscapeSequences(text);

    const std::string linkColor = mContext->GetColor(AdaptiveCards::ForegroundColor::Accent, false, false);
    const std::string textDecoration = "none";
    text = RendererQml::Utils::FormatHtmlUrl(text, linkColor, textDecoration);

    mToggleInputColElement->Property("_cbTitle", text, true);
    mCheckBox.isVisible == true ? mToggleInputColElement->Property("_cbIsVisible", "true") : mToggleInputColElement->Property("_cbIsVisible", "false");
    mCheckBox.isChecked == true ? mToggleInputColElement->Property("_cbIsChecked", "true") : mToggleInputColElement->Property("_cbIsChecked", "false");
    mCheckBox.isWrap == true ? mToggleInputColElement->Property("_cbisWrap", "true") : mToggleInputColElement->Property("_cbisWrap", "false");
}
void ToggleInputElement::addInputLabel()
{
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled())
    {
        if (!mToggleInput->GetLabel().empty())
        {
            mContext->addHeightEstimate(mContext->getEstimatedTextHeight(mToggleInput->GetLabel()));
            const auto choiceSetConfig = mContext->GetRenderConfig()->getInputChoiceSetDropDownConfig();
            std::string color = mContext->GetColor(AdaptiveCards::ForegroundColor::Default, false, false);
            mToggleInputColElement->Property("_color", color);
            mToggleInput->GetIsRequired() == true ? mToggleInputColElement->Property("_isRequired", "true") : mToggleInputColElement->Property("_isRequired", "false");
            mToggleInputColElement->Property("_mEscapedLabelString", RendererQml::Formatter() << "String.raw`" << mEscapedLabelString << "`");
        }
        else
        {
            if (mToggleInput->GetIsRequired())
            {
                mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "isRequired is not supported without labels"));
            }
        }
    }
}

void ToggleInputElement::addErrorMessage()
{
    if (mContext->GetRenderConfig()->isAdaptiveCards1_3SchemaEnabled() && mToggleInput->GetIsRequired())
    {
        if (!mToggleInput->GetErrorMessage().empty())
        {
            mToggleInputColElement->Property("_mEscapedErrorString", RendererQml::Formatter() << "String.raw`" << mEscapedErrorString << "`");
        }
    }
}

void ToggleInputElement::addValidation()
{
    mContext->addToInputElementList(origionalElementId, mToggleInputColElement->GetId() + ".isChecked");
    if (mToggleInput->GetIsVisible() && mToggleInput->GetIsRequired())
    {
        mContext->addToRequiredInputElementsIdList(mToggleInputColElement->GetId());
    }
}
