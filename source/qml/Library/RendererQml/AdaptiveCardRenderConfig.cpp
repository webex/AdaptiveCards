#include "AdaptiveCardRenderConfig.h"

namespace RendererQml
{
   
    AdaptiveCardRenderConfig::AdaptiveCardRenderConfig(bool isDarkMode)
        : m_isDark(isDarkMode)
    {
    }

    bool AdaptiveCardRenderConfig::isDarkMode() const
    {
        return m_isDark;
    }

    InputTextConfig AdaptiveCardRenderConfig::getInputTextConfig() const
    {
        return m_textInputConfig;
    }

    void AdaptiveCardRenderConfig::setInputTextConfig(InputTextConfig config)
    {
        m_textInputConfig = config;
    }

    InputNumberConfig AdaptiveCardRenderConfig::getInputNumberConfig() const
    {
        return m_numberInputConfig;
    }

    void AdaptiveCardRenderConfig::setInputNumberConfig(InputNumberConfig config)
    {
        m_numberInputConfig = config;
    }

    InputTimeConfig AdaptiveCardRenderConfig::getInputTimeConfig() const
    {
        return m_timeInputConfig;
    }

    void AdaptiveCardRenderConfig::setInputTimeConfig(InputTimeConfig config)
    {
        m_timeInputConfig = config;
    }

    InputChoiceSetDropDownConfig AdaptiveCardRenderConfig::getInputChoiceSetDropDownConfig() const
    {
        return m_choiceSetDropdownInputConfig;
    }

    void AdaptiveCardRenderConfig::setInputChoiceSetDropDownConfig(InputChoiceSetDropDownConfig config)
    {
        m_choiceSetDropdownInputConfig = config;
    }

    CheckBoxConfig AdaptiveCardRenderConfig::getCheckBoxConfig() const
    {
        return m_checkBoxConfig;
    }

    void AdaptiveCardRenderConfig::setCheckBoxConfig(CheckBoxConfig config)
    {
        m_checkBoxConfig = config;
    }

    RadioButtonConfig AdaptiveCardRenderConfig::getRadioButtonConfig() const
    {
        return m_radioButtonConfig;
    }

    void AdaptiveCardRenderConfig::setRadioButtonConfig(RadioButtonConfig config)
    {
        m_radioButtonConfig = config;
    }

    InputDateConfig AdaptiveCardRenderConfig::getInputDateConfig() const
    {
        return m_dateInputConfig;
    }

    void AdaptiveCardRenderConfig::setInputDateConfig(InputDateConfig config)
    {
        m_dateInputConfig = config;
    }

    ActionButtonsConfig AdaptiveCardRenderConfig::getActionButtonsConfig() const
    {
        return m_actionButtonsConfig;
    }

    void AdaptiveCardRenderConfig::setActionButtonsConfig(ActionButtonsConfig config)
    {
        m_actionButtonsConfig = config;
    }
}
