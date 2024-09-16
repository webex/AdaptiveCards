#include "TextInputModel.h"
#include "SharedAdaptiveCard.h"
#include <QDebug.h>
#include "Utils.h"
#include "MarkDownParser.h"
#include "AdaptiveWarning.h"

TextInputModel::TextInputModel(std::shared_ptr<AdaptiveCards::TextInput> input, QObject* parent) : QObject(parent)
{
    const auto hostConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig();
    const auto rendererConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getCardConfig();

    const auto textConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getCardConfig()->getInputTextConfig();
    AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().addHeightEstimate(AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getEstimatedTextHeight(input->GetLabel()));

    std::string mOriginalElementId = input->GetId();
  
    mIsVisible = input->GetIsVisible() ? true : false;
    mIsRequired = input->GetIsRequired() == true ? true : false;

    mLabel = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(input->GetLabel()));
    mErrorMessage = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(input->GetErrorMessage()));

    mPlaceHolder = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(input->GetPlaceholder()));
    mValue = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(input->GetValue()));

    auto spacing = AdaptiveCardQmlEngine::Utils::GetSpacing(AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig()->GetSpacing(), AdaptiveCards::Spacing::Small);
    QString color = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getColor(AdaptiveCards::ForegroundColor::Default, false, false);

    if (input->GetRegex() != "")
    {
        mRegex = QString::fromStdString(input->GetRegex());
    }

    mMaxLength = input->GetMaxLength();

    if (input->GetLabel().empty())
    {
        if (input->GetIsRequired())
        {
            AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().AddWarning(AdaptiveCardQmlEngine::AdaptiveWarning(AdaptiveCardQmlEngine::Code::RenderException, "isRequired is not supported without labels"));
        }
    }

    if (input->GetHeight() == AdaptiveCards::HeightType::Stretch)
    {
        mHeightStreched = input->GetHeight() == AdaptiveCards::HeightType::Stretch ? "true" : "false";
    }
}

TextInputModel::~TextInputModel()
{}
