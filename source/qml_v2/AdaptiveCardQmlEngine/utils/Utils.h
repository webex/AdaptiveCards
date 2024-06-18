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
        
		
    private:
        Utils() {}
    };

    /*
    class TextUtils
    {
    public:
        static std::string applyTextFunctions(const std::string& text, const std::string& lang);  
        static std::locale getValidCultureInfo(const std::string& lang);
        static bool getLocalTime(const std::string& tzOffset, std::tm& tm, std::tm& lt);

    private:
        static std::regex m_textFunctionRegex;
    };
    */
}   // namespace AdaptiveCardQmlEngine
