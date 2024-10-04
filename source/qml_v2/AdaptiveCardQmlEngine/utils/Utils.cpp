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

    std::string& Utils::replace(std::string& str, char what, char with)
    {
        if (!with)
        {
            str.erase(std::remove(str.begin(), str.end(), what), str.end());
        }
        else
        {
            std::replace(str.begin(), str.end(), what, with);
        }
        return str;
    }

    std::regex TextUtils::mTextFunctionRegex(R"xxx(\{\{(DATE|TIME)\(([\d]{4}-[\d]{2}-[\d]{2}T[\d]{2}:[\d]{2}:[\d]{2})(Z|(?:(?:-|\+)\d{2}:\d{2}))(?:,\s*(SHORT|LONG|COMPACT)\s*)??\)\}\})xxx");

    std::string TextUtils::applyTextFunctions(const std::string& text, const std::string& lang)
    {
        std::smatch oneMatch;
        std::string result = text;
        std::string::const_iterator searchLoc(text.cbegin());
        while (std::regex_search(searchLoc, text.cend(), oneMatch, mTextFunctionRegex))
        {
            if (oneMatch[1] == "DATE" || oneMatch[1] == "TIME")
            {
                std::tm utcTm = {};
                std::stringstream tmss(oneMatch[2]);
                tmss >> std::get_time(&utcTm, "%Y-%m-%dT%H:%M:%S");

                if (!tmss.fail())
                {
                    std::tm lt = {};
                    if (getLocalTime(oneMatch[3], utcTm, lt))
                    {
                        std::string format = "%x";
                        if (oneMatch[1] == "DATE")
                        {
                            // Check if date before 1970
                            auto date_split = Utils::splitString(oneMatch[2], '-');
                            if (date_split.empty() || std::stoi(date_split[0]) < 1970)
                            {
                                return result;
                            }

                            if (oneMatch[4] == "LONG")
                            {
                                format = "%A, %B %d, %Y"; // There is no equivalent for C# "D" format in C++
                            }
                            else if (oneMatch[4] == "SHORT")
                            {
                                format = "%a, %b %d, %Y";
                            }
                            else
                            {
                                format = "%x";
                            }
                        }
                        else if (oneMatch[1] == "TIME")
                        {
                            if (oneMatch[4] != "")
                            {
                                searchLoc = oneMatch.suffix().first;
                                continue;
                            }
                            format = "%I:%M %p";
                        }

                        std::stringstream ss2;
                        ss2.imbue(getValidCultureInfo(lang));
                        ss2 << std::put_time(&lt, format.c_str());

                        result = Utils::replace(result, oneMatch[0], ss2.str());
                    }
                }
            }
            searchLoc = oneMatch.suffix().first;
        }
        return result;
    }

    std::locale TextUtils::getValidCultureInfo(const std::string& lang)
    {
        return std::locale("en_US");
    }

    bool TextUtils::getLocalTime(const std::string& tzOffset, std::tm& utcTm, std::tm& lt)
    {
        lt = {};
        std::stringstream tzss(tzOffset);
        char offsetType;
        tzss >> offsetType;

        time_t tzt = 0;
        if (offsetType != 'Z' && !tzss.fail())
        {
            std::tm tzm = {};
            tzss >> std::get_time(&tzm, "%H:%M");
            if (!tzss.fail())
            {
                tzt = (tzm.tm_hour * 60 * 60) + (tzm.tm_min * 60) + tzm.tm_sec;
                if (offsetType == '-')
                {
                    tzt = -tzt;
                }
            }
        }

        if (tzss.fail())
        {
            return false;
        }

#ifdef _WIN32
        const time_t utct = _mkgmtime(&utcTm) - tzt;
        localtime_s(&lt, &utct);
#else
        const time_t utct = timegm(&utcTm) - tzt;
        localtime_r(&utct, &lt);
#endif

        return true;
    }

    std::string AdaptiveCardQmlEngine::Utils::getBackQuoteEscapedString(std::string str)
    {
        std::string rawString = "";
        for (int i = 0; i < str.size(); i++)
        {
            if (str[i] == '`')
            {
                rawString += "${'`'}";
            }
            else
            {
                rawString += str[i];
            }
        }
        return rawString;
    }

    int Utils::getSpacing(const AdaptiveCards::SpacingConfig& spacingConfig, const AdaptiveCards::Spacing spacing)
    {
        switch (spacing)
        {
        case AdaptiveCards::Spacing::None:
            return 0;
        case AdaptiveCards::Spacing::Small:
            return spacingConfig.smallSpacing;
        case AdaptiveCards::Spacing::Medium:
            return spacingConfig.mediumSpacing;
        case AdaptiveCards::Spacing::Large:
            return spacingConfig.largeSpacing;
        case AdaptiveCards::Spacing::ExtraLarge:
            return spacingConfig.extraLargeSpacing;
        case AdaptiveCards::Spacing::Padding:
            return spacingConfig.paddingSpacing;
        default:
            return spacingConfig.defaultSpacing;
        }
    }

    std::string Utils::fetchSystemDateTime(const std::string& fetchFormat)
    {
        char dateTimeBuffer[50];
        struct tm newtime;
        time_t now = time(0);

#ifdef _WIN32
        localtime_s(&newtime, &now);
#else
        localtime_r(&now, &newtime);
#endif

        setlocale(LC_ALL, "");

        strftime(dateTimeBuffer, 50, fetchFormat.c_str(), &newtime);
        return dateTimeBuffer;
    }

    bool Utils::isSystemTime12Hour()
    {
        const std::string timeFormat = "%X";
        const std::string timeBuffer = fetchSystemDateTime(timeFormat);

        std::vector<std::string> time_split = Utils::splitString(timeBuffer, ' ');

        // If time_split vector has two elements (time and am/pm) return true else false
        if (time_split.size() == 1)
        {
            return false;
        }
        return true;
    }

    const bool Utils::isValidTime(const std::string& time)
    {
        // 24 hour format check
        try
        {
            std::vector<std::string> time_split = Utils::splitString(time, ':');
            if (time_split.size() < 2)
            {
                return false;
            }
            if (stoi(time_split[0]) >= 0 && stoi(time_split[0]) <= 23)
            {
                if (stoi(time_split[1]) >= 0 && stoi(time_split[1]) <= 59)
                    return true;
            }
            return false;
        }
        catch (...)
        {
            return false;
        }
    }
} // namespace AdaptiveCardQmlEngine


