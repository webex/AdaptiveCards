#include "AdaptiveCardUtils.h"

std::string AdaptiveCardUtils::GetForegroundColorFromStyle(AdaptiveCards::ContainerStyle foregroundStyle)
{
    switch (foregroundStyle)
    {
    case AdaptiveCards::ContainerStyle::Accent:
        return "#DBF0FF";
    case AdaptiveCards::ContainerStyle::Attention:
        return "#FFE8EA";
    case AdaptiveCards::ContainerStyle::Good:
        return "#CEF5EB";
    case AdaptiveCards::ContainerStyle::Warning:
        return "#FFEBC2";
    case AdaptiveCards::ContainerStyle::Emphasis:
        return "#EDEDED";
    case AdaptiveCards::ContainerStyle::Default:
        return "#FFFFFF";
    default:
       return "transparent";
    }
}

bool AdaptiveCardUtils::EndsWith(const std::string& str, const std::string& end)
{
    if (end.size() > str.size())
    {
        return false;
    }
    return str.compare(str.length() - end.length(), end.length(), end) == 0;
}

bool AdaptiveCardUtils::TryParse(const std::string& str, int& value)
{
    try
    {
        std::string::size_type sz;
        value = std::stoi(str, &sz);
        return sz == str.size();
    }
    catch (const std::exception&)
    {
        return false;
    }
}