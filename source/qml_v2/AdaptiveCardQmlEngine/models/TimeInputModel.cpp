#include "TimeInputModel.h"
#include "SharedAdaptiveCard.h"
#include <QDebug.h>
#include "Utils.h"
#include "MarkDownParser.h"

TimeInputModel::TimeInputModel(std::shared_ptr<AdaptiveCards::TimeInput> input, QObject* parent) :
    QObject(parent),
    mTimeInputConfig(AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getCardConfig()->getInputTimeConfig())
{
    const auto rendererConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getCardConfig();

    mLabel = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(input->GetLabel()));
    mErrorMessage = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(input->GetErrorMessage()));
    mPlaceHolder = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(input->GetPlaceholder()));

    auto spacing = AdaptiveCardQmlEngine::Utils::getSpacing(AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig()->GetSpacing(), AdaptiveCards::Spacing::Small);

    if (!input->GetMin().empty() && AdaptiveCardQmlEngine::Utils::isValidTime(input->GetMin()))
    {
        mMinHour = QString::fromStdString(input->GetMin().substr(0, 2));
        mMinMinute = QString::fromStdString(input->GetMin().substr(3, 2));
    }

    if (!input->GetMax().empty() && AdaptiveCardQmlEngine::Utils::isValidTime(input->GetMax()))
    {
        mMaxHour = QString::fromStdString(input->GetMax().substr(0, 2));
        mMaxMinute = QString::fromStdString(input->GetMax().substr(3, 2));
    }

    if (!input->GetValue().empty() && AdaptiveCardQmlEngine::Utils::isValidTime(input->GetValue()))
    {
        mCurrHour = QString::fromStdString(input->GetValue().substr(0, 2));
        mCurrMinute = QString::fromStdString(input->GetValue().substr(3, 2));
    }

    if (input->GetIsRequired() || !input->GetMin().empty() || !input->GetMax().empty())
    {
        mIsRequired = input->GetIsRequired();
        mValidationRequired = input->GetIsRequired();
    }

    AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().addHeightEstimate(mTimeInputConfig.height);

    if (!input->GetLabel().empty())
    {
        AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().addHeightEstimate(AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getEstimatedTextHeight(input->GetLabel()));
    }

    mIsVisible = input->GetIsVisible() ? true : false;

    mIs12hour = AdaptiveCardQmlEngine::Utils::isSystemTime12Hour();
    mRegex = mIs12hour ? QRegExp("/^(--|[01]-|0\\d|1[0-2]):(--|[0-5]-|[0-5]\\d)\\s(--|A-|AM|P-|PM)$/") : QRegExp("/^(--|[01][0-9|-]|2[0-3|-]):(--|[0-5][0-9|-])$/");
    mInputMask = mIs12hour ? "xx:xx >xx;-" : "xx:xx;-";
}

TimeInputModel::~TimeInputModel()
{}
