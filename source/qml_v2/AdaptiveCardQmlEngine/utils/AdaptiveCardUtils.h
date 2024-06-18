#include "SharedAdaptiveCard.h"

#include <iostream>

namespace AdaptiveCardUtils
{
    std::string GetForegroundColorFromStyle(AdaptiveCards::ContainerStyle foregroundStyle);
    bool EndsWith(const std::string& str, const std::string& end);
    bool TryParse(const std::string& str, int& value);
}
