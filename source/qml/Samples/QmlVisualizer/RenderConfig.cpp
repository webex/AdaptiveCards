#include "RenderConfig.h"

RenderConfig::RenderConfig(bool isDark)
{
    this->isDark = isDark;
    this->textInputConfig = InputTextConfig::getInputTextConfig(isDark);
}

std::shared_ptr<InputTextConfig> InputTextConfig::getInputTextConfig(bool isDark)
{
    auto textInputConfig = std::make_shared<InputTextConfig>();
    textInputConfig->height = "16";
    textInputConfig->leftPadding = "16";
    textInputConfig->rightPadding = "16";
    textInputConfig->radius = "16";

    return textInputConfig;
}
