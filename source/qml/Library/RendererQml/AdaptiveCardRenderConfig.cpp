#include "AdaptiveCardRenderConfig.h"

namespace RendererQml
{
   
    AdaptiveCardRenderConfig::AdaptiveCardRenderConfig(bool isDarkMode)
    {
        isDark = isDarkMode;
    }

    const bool AdaptiveCardRenderConfig::isDarkMode()
    {
        return isDark;
    }

    InputTextConfig AdaptiveCardRenderConfig::getInputTextConfig()
    {
        return textInputConfig;
    }

    void AdaptiveCardRenderConfig::setInputTextConfig(InputTextConfig config)
    {
        textInputConfig = config;
    }
}
