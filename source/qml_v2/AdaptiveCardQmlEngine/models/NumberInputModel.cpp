#include "NumberInputModel.h"
#include "SharedAdaptiveCard.h"
#include <QDebug.h>
#include "Utils.h"
#include "MarkDownParser.h"

NumberInputModel::NumberInputModel(std::shared_ptr<AdaptiveCards::NumberInput> numberInput, QObject* parent) :
    QObject(parent), mInput(numberInput)

{
    initialize();
    createInputLabel();
    createErrorMessage();
}

void NumberInputModel::initialize()
{
    const auto hostConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig();

    mVisible = mInput->GetIsVisible();
    mPlaceholder = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(mInput->GetPlaceholder()));

    if (mInput->GetValue().has_value())
    {
        mValue = mInput->GetValue().value();
        mDefaultValue = "true";
    }
    mMinValue = mInput->GetMin().value_or(-DBL_MAX);
    mMaxValue = mInput->GetMax().value_or(DBL_MAX);

    if (mInput->GetIsRequired() || mInput->GetMin().has_value() || mInput->GetMax().has_value())
    {
        mIsRequired = mInput->GetIsRequired();
        mValidationRequired = mInput->GetIsRequired();
    }
}

void NumberInputModel::createInputLabel()
{
    if (!mInput->GetLabel().empty())
    {
        AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().addHeightEstimate(AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getEstimatedTextHeight(mInput->GetLabel()));
        mEscapedLabelString = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(mInput->GetLabel()));
    }
    else
    {
        if (mInput->GetIsRequired())
        {
            AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().addWarning(AdaptiveCardQmlEngine::AdaptiveWarning(AdaptiveCardQmlEngine::Code::RenderException, "isRequired is not supported without labels"));
        }
    }
}

void NumberInputModel::createErrorMessage()
{
    if (!mInput->GetErrorMessage().empty())
    {
        mEscapedErrorString = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(mInput->GetErrorMessage()));
    }
    else
    {
        if (mInput->GetIsRequired())
        {
            AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().addWarning(AdaptiveCardQmlEngine::AdaptiveWarning(AdaptiveCardQmlEngine::Code::RenderException, "isRequired is not supported without error message"));
        }
    }
}

NumberInputModel::~NumberInputModel()
{
}
