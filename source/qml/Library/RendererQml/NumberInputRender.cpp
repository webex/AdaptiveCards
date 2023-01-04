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

std::shared_ptr<RendererQml::QmlTag> NumberInputElement::getQmlTag()
{
    return mNumberInputQmlElement;
}

void NumberInputElement::initialize()
{
    mContext->addHeightEstimate(numberConfig.height);
    const std::string origionalElementId = mInput->GetId();
    mInput->SetId(mContext->ConvertToValidId(mInput->GetId()));

    mNumberInputQmlElement = std::make_shared<RendererQml::QmlTag>("NumberInputRender");
    mNumberInputQmlElement->Property("id", mInput->GetId());
    mNumberInputQmlElement->Property("_adaptiveCard", "adaptiveCard");
    mNumberInputQmlElement->Property("visible", mInput->GetIsVisible() ? "true" : "false");
    mNumberInputQmlElement->Property("_mEscapedPlaceholderString", RendererQml::Formatter() << "String.raw`" << RendererQml::Utils::getBackQuoteEscapedString(mInput->GetPlaceholder()) << "`");

    createInputLabel();

    if (mInput->GetValue() != std::nullopt)
    {
        mNumberInputQmlElement->Property("_value", RendererQml::Formatter() << mInput->GetValue());
        mNumberInputQmlElement->Property("_hasDefaultValue", "true");
    }

    mNumberInputQmlElement->Property("_minValue", RendererQml::Formatter() << (mInput->GetMin() != std::nullopt ? mInput->GetMin() : INT_MIN));
    mNumberInputQmlElement->Property("_maxValue", RendererQml::Formatter() << (mInput->GetMax() != std::nullopt ? mInput->GetMax() : INT_MAX));


    if (mInput->GetIsRequired() || mInput->GetMin() != std::nullopt || mInput->GetMax() != std::nullopt)
    {
        mContext->addToRequiredInputElementsIdList(mNumberInputQmlElement->GetId());
        mNumberInputQmlElement->Property((mInput->GetIsRequired() ? "_isRequired" : "_validationRequired"), "true");
    }

    mContext->addToInputElementList(origionalElementId, (mNumberInputQmlElement->GetId() + "._submitValue.toString()"));

    createErrorMessage();
}

void NumberInputElement::createInputLabel()
{
    if (!mInput->GetLabel().empty())
    {
        mContext->addHeightEstimate(mContext->getEstimatedTextHeight(mInput->GetLabel()));
        mNumberInputQmlElement->Property("_mEscapedLabelString", RendererQml::Formatter() << "String.raw`" << RendererQml::Utils::getBackQuoteEscapedString(mInput->GetLabel()) << "`");
    }
    else
    {
        if (mInput->GetIsRequired())
        {
            mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "isRequired is not supported without labels"));
        }
    }
}

void NumberInputElement::createErrorMessage()
{
    if (!mInput->GetErrorMessage().empty())
    {
        mNumberInputQmlElement->Property("_mEscapedErrorString", RendererQml::Formatter() << "String.raw`" << RendererQml::Utils::getBackQuoteEscapedString(mInput->GetErrorMessage()) << "`");
    }
    else
    {
        if (mInput->GetIsRequired())
        {
            mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "isRequired is not supported without error message"));
        }
    }
}
