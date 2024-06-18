#include "AdaptiveCardConfig.h"

namespace AdaptiveCardQmlEngine
{
   
    AdaptiveCardConfig::AdaptiveCardConfig(bool isDarkMode, std::map<std::string, bool> featureToggleMap)
        : m_isDark(isDarkMode), mFeatureToggleMap(featureToggleMap)
    {
    }

    bool AdaptiveCardConfig::isDarkMode() const
    {
        return m_isDark;
    }

    bool  AdaptiveCardConfig::isAdaptiveCards1_3SchemaEnabled() const
    {
        const auto feature = mFeatureToggleMap.find("FEATURE_1_3");
        return ( feature != mFeatureToggleMap.end() && feature->second);
    }

    CardConfig AdaptiveCardConfig::getCardConfig() const
    {
        return m_cardConfig;
    }

    void AdaptiveCardConfig::setCardConfig(CardConfig config)
    {
        m_cardConfig = config;
    }

    InputTextConfig AdaptiveCardConfig::getInputTextConfig() const
    {
        return m_textInputConfig;
    }

    void AdaptiveCardConfig::setInputTextConfig(InputTextConfig config)
    {
        m_textInputConfig = config;
    }

    InputNumberConfig AdaptiveCardConfig::getInputNumberConfig() const
    {
        return m_numberInputConfig;
    }

    void AdaptiveCardConfig::setInputNumberConfig(InputNumberConfig config)
    {
        m_numberInputConfig = config;
    }

    InputTimeConfig AdaptiveCardConfig::getInputTimeConfig() const
    {
        return m_timeInputConfig;
    }

    void AdaptiveCardConfig::setInputTimeConfig(InputTimeConfig config)
    {
        m_timeInputConfig = config;
    }

    InputChoiceSetDropDownConfig AdaptiveCardConfig::getInputChoiceSetDropDownConfig() const
    {
        return m_choiceSetDropdownInputConfig;
    }

    void AdaptiveCardConfig::setInputChoiceSetDropDownConfig(InputChoiceSetDropDownConfig config)
    {
        m_choiceSetDropdownInputConfig = config;
    }

    ToggleButtonConfig AdaptiveCardConfig::getToggleButtonConfig() const
    {
        return m_toggleButtonConfig;
    }

    void AdaptiveCardConfig::setToggleButtonConfig(ToggleButtonConfig config)
    {
        m_toggleButtonConfig = config;
    }

    InputDateConfig AdaptiveCardConfig::getInputDateConfig() const
    {
        return m_dateInputConfig;
    }

    void AdaptiveCardConfig::setInputDateConfig(InputDateConfig config)
    {
        m_dateInputConfig = config;
    }

    ActionButtonsConfig AdaptiveCardConfig::getActionButtonsConfig() const
    {
        return m_actionButtonsConfig;
    }

    void AdaptiveCardConfig::setActionButtonsConfig(ActionButtonsConfig config)
    {
        m_actionButtonsConfig = config;
    }
}
