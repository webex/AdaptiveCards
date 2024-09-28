#include "TextInputModel.h"
#include "SharedAdaptiveCard.h"
#include <QDebug.h>
#include "Utils.h"
#include "MarkDownParser.h"
#include "AdaptiveWarning.h"

TextInputModel::TextInputModel(std::shared_ptr<AdaptiveCards::TextInput> input, QObject* parent) : QObject(parent)
{
    const auto rendererConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getCardConfig();

    const auto textConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getCardConfig()->getInputTextConfig();
    AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().addHeightEstimate(AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getEstimatedTextHeight(input->GetLabel()));
    AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().addHeightEstimate(input->GetIsMultiline() ? textConfig.multiLineTextHeight : textConfig.height);

    mIsVisible = input->GetIsVisible() ? true : false;
    mIsRequired = input->GetIsRequired() == true ? true : false;

    setVisualProperties(input);
}

void TextInputModel::setVisualProperties(const std::shared_ptr<AdaptiveCards::TextInput>& input)
{
    mLabel = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(input->GetLabel()));
    mErrorMessage = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(input->GetErrorMessage()));

    mPlaceHolder = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(input->GetPlaceholder()));
    mValue = QString::fromStdString(AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(input->GetValue()));

    auto spacing = AdaptiveCardQmlEngine::Utils::getSpacing(AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig()->GetSpacing(), AdaptiveCards::Spacing::Small);
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
            AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().addWarning(AdaptiveCardQmlEngine::AdaptiveWarning(
                AdaptiveCardQmlEngine::Code::RenderException, "isRequired is not supported without labels"));
        }
    }

    if (input->GetHeight() == AdaptiveCards::HeightType::Stretch)
    {
        mHeightStreched = input->GetHeight() == AdaptiveCards::HeightType::Stretch ? "true" : "false";
    }

    if (input->GetIsMultiline())
    {
        mIsMultiLineText = true;
    }
    else
    {
        mIsMultiLineText = false;
    }
}

TextInputModel::~TextInputModel()
{}
