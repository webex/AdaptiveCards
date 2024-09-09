#include "NumberInputModel.h"
#include "SharedAdaptiveCard.h"
#include <QDebug.h>
#include "Utils.h"
#include "MarkDownParser.h"

NumberInputModel::NumberInputModel(std::shared_ptr<AdaptiveCards::NumberInput> numberInput, QObject* parent) :
    QObject(parent), mInput(numberInput)

{
    const auto hostConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig();
    const auto rendererConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getCardConfig();

    mVisible = mInput->GetIsVisible();
    //mPlaceholder = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(mInput->GetPlaceholder()) + "`");

    createInputLabel();

    if (mInput->GetValue().has_value())
    {
        mValue = mInput->GetValue().value();
        mDefaultValue = true;
    }

    mMinValue = numberInput->GetMin().value_or(-DBL_MAX);
    mMaxValue = numberInput->GetMax().value_or(DBL_MAX);

    if (numberInput->GetIsRequired() || numberInput->GetMin().has_value() || numberInput->GetMax().has_value())
    {
    }
}
void NumberInputModel::createInputLabel()
{
    if (!mInput->GetLabel().empty())
    {
        // mContext->addHeightEstimate(mContext->getEstimatedTextHeight(mInput->GetLabel()));
        //mEscapedLabelString = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(mInput->GetLabel()) + "`");
    }
    else
    {
        if (mInput->GetIsRequired())
        {
            //  mContext->AddWarning(RendererQml::AdaptiveWarning(RendererQml::Code::RenderException, "isRequired is not supported without labels"));
        }
    }
}

NumberInputModel::~NumberInputModel()
{
}
