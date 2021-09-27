#include "RenderConfig.h"

RenderConfig::RenderConfig(bool isDark)
{
    this->isDark = isDark;
    this->textInputConfig = std::make_shared<InputTextConfig>(isDark);
}

InputFieldConfig::InputFieldConfig(bool isDark)
{
    this->isDark = isDark;
    //Sample values filled, will be changed
    this->height = "16";
    this->leftPadding = "16";
    this->rightPadding = "16";
    this->radius = "16";
}

InputTextConfig::InputTextConfig(bool isDark)
    :InputFieldConfig(isDark)
{
    //Sample value
    this->multiLineTextHeight = "20";
}
