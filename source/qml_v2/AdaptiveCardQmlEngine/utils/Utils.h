#pragma once

#include "pch.h"
#include "HostConfig.h"
#include "Formatter.h"
#include <QString> 

namespace AdaptiveCardQmlEngine
{
	class Utils
    {
    public:
        static const QString getWeightString(AdaptiveCards::TextWeight weight);
        static const std::string parseMarkDown(const std::string& text);
        static const std::string& replace(std::string& str, const std::string& what, const std::string& with);
        static const std::string handleEscapeSequences(std::string& text);
        static const std::string formatHtmlUrl(std::string& text, const std::string& linkColor, const std::string& textDecoration);
        static std::vector<std::string> splitString(const std::string& string, char delimiter);

        static std::string GetHorizontalAlignment(std::string alignType);
        static std::string GetVerticalAlignment(std::string alignType);
		
    private:
        Utils() {}
    };

}   // namespace AdaptiveCardQmlEngine
