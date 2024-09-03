#include "RichTextBlockModel.h"
#include "SharedAdaptiveCard.h"
#include <QDebug.h>
#include "Utils.h"
#include "MarkDownParser.h"

RichTextBlockModel::RichTextBlockModel(std::shared_ptr<AdaptiveCards::RichTextBlock> richTextBlock, QObject* parent) :
    QObject(parent)
{
    const auto rendererConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getCardConfig();

    // Property values assigned for RichTextBlock
    const auto selectionColor = rendererConfig->getCardConfig().textHighlightBackground;
    const auto hAlignmentValue = richTextBlock->GetHorizontalAlignment().value_or(AdaptiveCards::HorizontalAlignment::Left);
   
    QString textrun_all = "";

    for (const auto& inlineRun : richTextBlock->GetInlines())
    {
        if (AdaptiveCardQmlEngine::Utils::IsInstanceOfSmart<AdaptiveCards::TextRun>(inlineRun))
        {
            std::string selectActionId = "";
            auto textRun = std::dynamic_pointer_cast<AdaptiveCards::TextRun>(inlineRun);
            textrun_all.append(textRunRender(textRun, selectActionId));
        }
    }

    mText = textrun_all;
    mTextHorizontalAlignment = static_cast<int>(hAlignmentValue);
}

QString RichTextBlockModel::textRunRender(const std::shared_ptr<AdaptiveCards::TextRun>& textRun, const std::string& selectaction)
{
    // Handle to Host config
    auto config = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig();

    // TextRun properties
    const auto textSize = textRun->GetTextSize().value_or(AdaptiveCards::TextSize::Default);
    const auto textColor = textRun->GetTextColor().value_or(AdaptiveCards::ForegroundColor::Default);
    const auto textIsSubtle = textRun->GetIsSubtle().value_or(false);
    const auto textWeight = textRun->GetTextWeight().value_or(AdaptiveCards::TextWeight::Default);
   
    const auto fontType = textRun->GetFontType().value_or(AdaptiveCards::FontType::Default);

    // Context & Config properties
    const QString fontFamily = QString::fromStdString(config->GetFontFamily(fontType));

    const int fontSize = config->GetFontSize(fontType, textSize);
    const int weight = config->GetFontWeight(fontType, textWeight);

    const QString color = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getColor(textColor, textIsSubtle, false, true);

    bool mTextWrap = true;

    QString uiTextRun = "<span style='";
    uiTextRun.append(QString("font-family:") + QString("\\\"") + fontFamily + QString("\\\"") + QString(";"));
    uiTextRun.append(QString("color:") + color + QString(";"));
    uiTextRun.append(QString("font-size:") + QString::number(fontSize) + QString("px") + QString(";"));
    uiTextRun.append(QString("font-weight:") + QString::number(weight) + QString(";"));

    if (textRun->GetHighlight())
    {
        uiTextRun.append("background-color:" + QString("yellow")) + ";" ; 
    }

    if (textRun->GetItalic())
    {
        uiTextRun.append("font-style:").append("italic").append(";");
    }

    if (textRun->GetUnderline())
    {
        uiTextRun.append("text-decoration:").append("underline").append(";");
    }

    if (textRun->GetStrikethrough())
    {
        uiTextRun.append("text-decoration:").append("line-through").append(";");
    }

    uiTextRun.append("'>");

    std::string text = AdaptiveCardQmlEngine::TextUtils::applyTextFunctions(textRun->GetText(), AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getLang());

    text = AdaptiveCardQmlEngine::Utils::handleEscapeSequences(text);
    const std::string linkColor = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getColor(AdaptiveCards::ForegroundColor::Accent, false, false).toStdString();

    // CSS Property for underline, striketrhough,etc
    std::string textDecoration = "none";

    text = AdaptiveCardQmlEngine::Utils::formatHtmlUrl(text, linkColor, textDecoration);

    if (textRun->GetSelectAction() != nullptr)
    {
        const QString styleString = "style=\\\"color:" + QString::fromStdString(linkColor) + ";" +
                                    "text-decoration:" + QString::fromStdString(textDecoration) + ";\\\"";
        uiTextRun.append("<a href='" + QString::fromStdString(selectaction) + "'" + styleString + " >");
        uiTextRun.append(QString::fromStdString(text));
        uiTextRun.append("</a>");
    }
    else
    {
        uiTextRun.append(QString::fromStdString(text));
    }
    uiTextRun.append("</span>");

    return uiTextRun;
}

RichTextBlockModel::~RichTextBlockModel()
{
}
