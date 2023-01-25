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
    return mTimeInputElement;
}

void TimeInputElement::initialize()
{
    mOrigionalElementId = mTimeInput->GetId();
    mTimeInput->SetId(mContext->ConvertToValidId(mTimeInput->GetId()));

    mEscapedPlaceholderString = RendererQml::Utils::getBackQuoteEscapedString(mTimeInput->GetPlaceholder());
    mEscapedLabelString = RendererQml::Utils::getBackQuoteEscapedString(mTimeInput->GetLabel());
    mEscapedErrorString = RendererQml::Utils::getBackQuoteEscapedString(mTimeInput->GetErrorMessage());

    mTimeInputElement = std::make_shared<RendererQml::QmlTag>("TimeInputRender");
    mTimeInputElement->Property("id", mTimeInput->GetId());
    mTimeInputElement->Property("_adaptiveCard", "adaptiveCard");
    mTimeInputElement->Property("_mEscapedLabelString", RendererQml::Formatter() << "String.raw`" << mEscapedLabelString << "`");
    mTimeInputElement->Property("_mEscapedErrorString", RendererQml::Formatter() << "String.raw`" << mEscapedErrorString << "`");
    mTimeInputElement->Property("_mEscapedPlaceholderString", RendererQml::Formatter() << "String.raw`" << mEscapedPlaceholderString << "`");
    mTimeInputElement->Property("spacing", RendererQml::Formatter() << RendererQml::Utils::GetSpacing(mContext->GetConfig()->GetSpacing(), AdaptiveCards::Spacing::Small));

    if (!mTimeInput->GetMin().empty() && RendererQml::Utils::isValidTime(mTimeInput->GetMin()))
    {
        mTimeInputElement->Property("_minHour", mTimeInput->GetMin().substr(0, 2));
        mTimeInputElement->Property("_minMinute", mTimeInput->GetMin().substr(3, 2));
    }

    if (!mTimeInput->GetMax().empty() && RendererQml::Utils::isValidTime(mTimeInput->GetMax()))
    {
        mTimeInputElement->Property("_maxHour", mTimeInput->GetMax().substr(0, 2));
        mTimeInputElement->Property("_maxMinute", mTimeInput->GetMax().substr(3, 2));
    }

    if (!mTimeInput->GetValue().empty() && RendererQml::Utils::isValidTime(mTimeInput->GetValue()))
    {
        mTimeInputElement->Property("_currHour", mTimeInput->GetValue().substr(0, 2));
        mTimeInputElement->Property("_currMinute", mTimeInput->GetValue().substr(3, 2));
    }

    if (mTimeInput->GetIsRequired() || !mTimeInput->GetMin().empty() || !mTimeInput->GetMax().empty())
    {
        mContext->addToRequiredInputElementsIdList(mTimeInputElement->GetId());
        mTimeInputElement->Property((mTimeInput->GetIsRequired() ? "_isRequired" : "_validationRequired"), "true");
    }

    mContext->addToInputElementList(mOrigionalElementId, (mTimeInputElement->GetId() + "._submitValue"));
    mContext->addHeightEstimate(mTimeInputConfig.height);

    if (!mTimeInput->GetLabel().empty())
    {
        mContext->addHeightEstimate(mContext->getEstimatedTextHeight(mTimeInput->GetLabel()));
    }

    mTimeInputElement->Property("visible", mTimeInput->GetIsVisible() ? "true" : "false");

    mTimeInputElement->Property("_is12Hour", mIs12hour ? "true" : "false");
    mTimeInputElement->Property("_regex", RendererQml::Formatter() << "new RegExp(" << (mIs12hour ? "/^(--|[01]-|0\\d|1[0-2]):(--|[0-5]-|[0-5]\\d)\\s(--|A-|AM|P-|PM)$/" : "/^(--|[01][0-9|-]|2[0-3|-]):(--|[0-5][0-9|-])$/") << ")");
    mTimeInputElement->Property("_inputMask", mIs12hour ? "xx:xx >xx;-" : "xx:xx;-", true);
}
