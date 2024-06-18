#include "TextBlockModel.h"
#include "SharedAdaptiveCard.h"
#include <QDebug.h>
#include "Utils.h"
#include "MarkDownParser.h"

TextBlockModel::TextBlockModel(std::shared_ptr<AdaptiveCards::TextBlock> textBlock, QObject* parent) :
    QObject(parent)
{
    const auto hostConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig();
    const auto rendererConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getCardConfig();

    // Property values assigned for TextBlock
    const auto textColor = textBlock->GetTextColor().value_or(AdaptiveCards::ForegroundColor::Default);
    const auto selectionColor = rendererConfig->getCardConfig().textHighlightBackground;
    const auto textIsSubtle = textBlock->GetIsSubtle().value_or(false);
    const auto fontType = textBlock->GetFontType().value_or(AdaptiveCards::FontType::Default);
    const auto textSize = textBlock->GetTextSize().value_or(AdaptiveCards::TextSize::Default);
    const auto weight = textBlock->GetTextWeight().value_or(AdaptiveCards::TextWeight::Default);
    const auto hAlignmentValue = textBlock->GetHorizontalAlignment().value_or(AdaptiveCards::HorizontalAlignment::Left);
    const auto fontFamily = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig()->GetFontFamily(fontType);

    mText = QString::fromStdString(AdaptiveCardQmlEngine::Utils::parseMarkDown(textBlock->GetText()));
    mTextMaxLines = textBlock->GetMaxLines();
    mTextWrap = textBlock->GetWrap();

    mTextHorizontalAlignment = static_cast<int>(hAlignmentValue);
    mIsVisible = textBlock->GetIsVisible() && !textBlock->GetText().empty() ? "true" : "false";

    mColor = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getColor(textColor, textIsSubtle, false);
    mSelectionColor = QString::fromStdString(selectionColor);

    mFontFamily = QString::fromStdString(fontFamily);
    mFontPixelSize = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig()->GetFontSize(fontType, textSize);
    mFontWeight = AdaptiveCardQmlEngine::Utils::getWeightString(weight);

    mIsInTabOrder = true;
}

TextBlockModel::~TextBlockModel()
{}



