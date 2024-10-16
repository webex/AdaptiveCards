#include "ToggleInputModel.h"
#include "SharedAdaptiveCard.h"
#include <QDebug.h>
#include "Utils.h"
#include "MarkDownParser.h"

ToggleInputModel::ToggleInputModel(std::shared_ptr<AdaptiveCards::ToggleInput> toggleInput, QObject* parent) :
    QObject(parent), mToggleInput(toggleInput)
{
    initialize();
    addInputLabel();
    addCheckBox();
}

ToggleInputModel::~ToggleInputModel()
{
}
void ToggleInputModel::initialize()
{

    mEscapedLabelString =
        QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(mToggleInput->GetLabel()));
    mEscapedErrorString = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(mToggleInput->GetErrorMessage()));
    mSpacing = AdaptiveCardQmlEngine::Utils::getSpacing(AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig()->GetSpacing(), AdaptiveCards::Spacing::Small);
    mVisible = mToggleInput->GetIsVisible();
}

void ToggleInputModel::addCheckBox()
{
    const auto rendererConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getCardConfig();

    const auto valueOn = !mToggleInput->GetValueOn().empty() ? mToggleInput->GetValueOn() : "true";
    const auto valueOff = !mToggleInput->GetValueOff().empty() ? mToggleInput->GetValueOff() : "false";
    const bool isChecked = mToggleInput->GetValue().compare(valueOn) == 0 ? true : false;
    if (mToggleInput->GetIsVisible())
    {
        AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().addHeightEstimate(
            rendererConfig->getToggleButtonConfig().rowHeight);
    }
    const AdaptiveCardQmlEngine::Checkbox mCheckBox = AdaptiveCardQmlEngine::Checkbox(
        mToggleInput->GetId() + "inputToggle",
        AdaptiveCardQmlEngine::CheckBoxType::Toggle,
        mToggleInput->GetTitle(),
        mToggleInput->GetValue(),
        valueOn,
        valueOff,
        mToggleInput->GetWrap(),
        mToggleInput->GetIsVisible(),
        isChecked);
    mEscapedValueOn = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(mCheckBox.valueOn));
    mEscapedValueOff = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(mCheckBox.valueOff));
    mText = QString::fromStdString(AdaptiveCardQmlEngine::Utils::parseMarkDown(mCheckBox.text));
    mCbIsChecked = mCheckBox.isChecked;
    mCbisWrap = mCheckBox.isWrap == true ? "true" : "false";
}
void ToggleInputModel::addInputLabel()
{
    const auto hostConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig();
    if (!mToggleInput->GetLabel().empty())
    {
        if (mToggleInput->GetIsVisible())
        {
            AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().addHeightEstimate(
                AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getEstimatedTextHeight(mToggleInput->GetLabel()));
        }
        const QString color = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getColor(AdaptiveCards::ForegroundColor::Default, false, false);
        mIsRequired = mToggleInput->GetIsRequired();
        mEscapedLabelString = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(mToggleInput->GetLabel()));
    } 
    else
    {
        if (mToggleInput->GetIsRequired())
        {
            AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().addWarning(AdaptiveCardQmlEngine::AdaptiveWarning(AdaptiveCardQmlEngine::Code::RenderException, "isRequired is not supported without labels"));
        }
    }
}
