#include "Utils.h"
#include <time.h>

#include "MarkDownParser.h"
#include "AdaptiveCardContext.h" 

namespace AdaptiveCardQmlEngine
{
    const QString Utils::getWeightString(AdaptiveCards::TextWeight weight) 
    {
        switch (weight)
        {
        case AdaptiveCards::TextWeight::Lighter:
            return "extraLight";
        case AdaptiveCards::TextWeight::Bolder:
            return "bold";
        default:
            return "normal";
        }
    }

    const std::string Utils::parseMarkDown(const std::string& text)
    {
        std::string parsedText = text;

        auto markdownParser = std::make_shared<AdaptiveCards::MarkDownParser>(parsedText);
        parsedText = markdownParser->TransformToHtml();
        parsedText = handleEscapeSequences(parsedText);

        const auto linkColor = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getColor(AdaptiveCards::ForegroundColor::Accent, false, false, true);
        const auto textDecoration = "none";

        parsedText = formatHtmlUrl(parsedText, linkColor.toStdString(), textDecoration);

        return parsedText;
	}

    const std::string Utils::handleEscapeSequences(std::string& text)
    {
        text = replace(text, "\n", "<br />");
        text = replace(text, "\r", "<br />");

        // Handles tab space in RichText, works for MarkdownText as well
        text = replace(text, "\t", "<span style='white-space:pre'>\t</span>");
        text = replace(text, "'", "&#39;");
        text = replace(text, "\"", "&quot;");
        text = replace(text, "\\", "&#92;");

        return text;
    }

    const std::string& Utils::replace(std::string& str, const std::string& what, const std::string& with)
    {
        if (!what.empty())
        {
            size_t start = 0;
            while ((start = str.find(what, start)) != std::string::npos)
            {
                str.replace(start, what.length(), with);
                start += with.length();
            }
        }
        return str;
    }

    const std::string Utils::formatHtmlUrl(std::string& text, const std::string& linkColor, const std::string& textDecoration)
    {
        std::regex re("<a href=&quot;([^\\<]*)&quot;>([^\\<]*)<\\/a>");
        std::string replacement = Formatter() << "<a href=\\\"$1\\\" style=\\\"color:" << linkColor
                                              << "; text-decoration: " << textDecoration << ";\\\">$2</a>";
        text = std::regex_replace(text, re, replacement);

        return text;
    }

    std::vector<std::string> Utils::splitString(const std::string& string, char delimiter)
    {
        std::vector<std::string> splitElements;
        std::stringstream ss(string);
        while (ss.good())
        {
            std::string substr;
            getline(ss, substr, delimiter);
            splitElements.push_back(substr);
        }
        return splitElements;
    }

    std::string Utils::GetHorizontalAlignment(std::string alignType)
    {
        if (alignType.compare("center") == 0)
            return "Qt.AlignHCenter";
        else if (alignType.compare("right") == 0)
            return "Qt.AlignRight";
        else
            return "Qt.AlignLeft";
    }

    std::string Utils::GetVerticalAlignment(std::string alignType)
    {
        if (alignType.compare("center") == 0)
            return "Qt.AlignVCenter";
        else if (alignType.compare("bottom") == 0)
            return "Qt.AlignBottom";
        else
            return "Qt.AlignTop";
    }

} // namespace AdaptiveCardQmlEngine


