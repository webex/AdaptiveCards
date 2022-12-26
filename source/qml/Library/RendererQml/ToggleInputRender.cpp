#include "ToggleInputRender.h"
#include "Formatter.h"
#include "Utils.h"

ToggleInputElement::ToggleInputElement(std::shared_ptr<AdaptiveCards::ToggleInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context)
    :mToggleInput(input),
    mContext(context),
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

    mEscapedLabelString = RendererQml::Utils::getBackQuoteEscapedString(mToggleInput->GetLabel());
    mEscapedErrorString = RendererQml::Utils::getBackQuoteEscapedString(mToggleInput->GetErrorMessage());

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
    if (mToggleInput->GetIsVisible())
    {
        mContext->addHeightEstimate(mContext->GetRenderConfig()->getCardConfig().checkBoxRowHeight);
    }
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
    mToggleInputColElement->Property("checkBox._cbValueOn", RendererQml::Formatter() << "String.raw`" << mEscapedValueOn << "`");
    mToggleInputColElement->Property("checkBox._cbValueOff", RendererQml::Formatter() << "String.raw`" << mEscapedValueOff << "`");

    std::string text = RendererQml::AdaptiveCardQmlRenderer::ParseMarkdownString(mCheckBox.text, mContext);
    mToggleInputColElement->Property("checkBox._cbTitle", text, true);
    mToggleInputColElement->Property("checkBox._cbIsChecked", mCheckBox.isChecked == true ? "true" : "false");
    mToggleInputColElement->Property("checkBox._cbisWrap", mCheckBox.isWrap == true ? "true" : "false");
}
void ToggleInputElement::addInputLabel()
{
    if (!mToggleInput->GetLabel().empty())
    {
        if (mToggleInput->GetIsVisible())
        {
            mContext->addHeightEstimate(mContext->getEstimatedTextHeight(mToggleInput->GetLabel()));
        }
        std::string color = mContext->GetColor(AdaptiveCards::ForegroundColor::Default, false, false);
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

void ToggleInputElement::addErrorMessage()
{
    if (!mToggleInput->GetErrorMessage().empty())
    {
        mToggleInputColElement->Property("_mEscapedErrorString", RendererQml::Formatter() << "String.raw`" << mEscapedErrorString << "`");
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
