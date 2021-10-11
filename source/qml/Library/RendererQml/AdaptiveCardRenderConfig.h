#pragma once
#include<memory>
#include<string>

namespace RendererQml
{
    struct InputFieldConfig
    {
        std::string backgroundColorNormal{ "#FF000000" };
        std::string backgroundColorOnHovered{ "#12FFFFFF" };
        std::string backgroundColorOnPressed{ "#1CFFFFFF" };
        std::string borderColorNormal{ "#80FFFFFF" };
        std::string borderColorOnFocus{ "#FF64B4FA" };
        std::string placeHolderColor{ "#B2FFFFFF" };
        std::string textColor{ "#F2FFFFFF" };
        std::string clearIconColorNormal{ "#B2FFFFFF" };
        std::string clearIconColorOnFocus{ "#FF64B4FA" };
        std::string height{ "32" };
        std::string pixelSize{ "16" };
        std::string borderRadius{ "8" };
        std::string borderWidth{ "1" };
        std::string clearIconSize{ "16" };
        std::string clearIconHorizontalPadding{ "12" };
    };

    struct InputTextConfig : InputFieldConfig
    {
        std::string multiLineTextHeight{ "96" };
        std::string textHorizontalPadding{ "12" };
        std::string textVerticalPadding{ "4" };
        std::string multiLineTextTopPadding{ "7" };
        std::string multiLineTextBottomPadding{ "4" };
    };

    struct InputNumberConfig : InputFieldConfig
    {
        std::string upDownIconColor{ "#F2FFFFFF" };
        std::string upDownButtonWidth{ "31" };
        std::string upDownIconSize{ "16" };
    };

    struct InputTimeConfig : InputFieldConfig
    {
        std::string timeIconColorNormal{ "#F2FFFFFF" };
        std::string timeIconColorOnFocus{ "#FF64B4FA" };
        std::string timePickerBorderColor{ "#33FFFFFF" };
        std::string timePickerBackgroundColor{ "#FF000000" };
        std::string timePickerElementColorNormal{ "#FF000000" };
        std::string timePickerElementColorOnFocus{ "#FF1170CF" };
        std::string timePickerElementColorOnHover{ "#33FFFFFF" };
        std::string timePickerElementTextColorOnHighlighted{ "#F2FFFFFF" };
        std::string timePickerElementTextColorNormal{ "#F2FFFFFF" };
        std::string timeIconHorizontalPadding{ "12" };
        std::string timePickerBorderRadius{ "12" };
        std::string timePickerWidth12Hour{ "200" };
        std::string timePickerWidth24Hour{ "134" };
        std::string timePickerHeight{ "280" };
        std::string timePickerColumnSpacing{ "16" };
        std::string timePickerHoursAndMinutesTagWidth{ "43" };
        std::string timePickerAMPMTagWidth{ "50" };
        std::string timePickerElementHeight{ "32" };
        std::string timePickerMargins{ "16" };
        std::string timePickerSpacing{ "4" };
        std::string timePickerElementRadius{ "4" };
    };

    struct InputChoiceSetDropDownConfig : InputFieldConfig
    {
        std::string arrowIconColor{ "#F2FFFFFF" };
        std::string dropDownElementColorPressed{ "#4DFFFFFF" };
        std::string dropDownElementColorHovered{ "#33FFFFFF" };
        std::string dropDownElementColorNormal{ "#FF000000" };
        std::string dropDownBorderColor{ "#33FFFFFF" };
        std::string dropDownBackgroundColor{ "#FF000000" };
        std::string arrowIconHorizontalPadding{ "9.5" };
        std::string arrowIconVerticalPadding{ "8" };
        std::string arrowIconWidth{ "13" };
        std::string arrowIconHeight{ "7" };
        std::string textHorizontalPadding{ "12" };
        std::string dropDownElementHeight{ "40" };
        std::string dropDownElementHorizontalPadding{ "12" };
        std::string dropDownElementVerticalPadding{ "8" };
        std::string dropDownElementRadius{ "8" };
        std::string dropDownElementTextHorizontalPadding{ "12" };
        std::string dropDownRadius{ "12" };
        std::string dropDownPadding{ "8" };
        std::string dropDownHeight{ "216" };
    };

    struct RadioButtonConfig : InputFieldConfig
    {
        std::string buttonBorderColor{ "#80FFFFFF" };
        std::string innerCircleColorOnChecked{ "#F2000000" };
        std::string colorOnCheckedAndPressed{ "#FF1170CF" };
        std::string colorOnPressed{ "#66FFFFFF" };
        std::string colorOnCheckedAndHovered{ "#FF3492EB" };
        std::string colorOnHovered{ "#4DFFFFFF" };
        std::string colorOnCheckedNormal{ "#FF64B4FA" };
        std::string colorNormal{ "#33FFFFFF" };
        std::string outerCircleSize{ "16" };
        std::string innerCircleSize{ "6" };
    };

    struct CheckBoxConfig : InputFieldConfig
    {
        std::string buttonBorderColor{ "#80FFFFFF" };
        std::string colorOnCheckedAndPressed{ "#FF1170CF" };
        std::string colorOnPressed{ "#66FFFFFF" };
        std::string colorOnCheckedAndHovered{ "#FF3492EB" };
        std::string colorOnHovered{ "#4DFFFFFF" };
        std::string colorOnCheckedNormal{ "#FF64B4FA" };
        std::string colorNormal{ "#33FFFFFF" };
        std::string checkBoxSize{ "16" };
        std::string checkBoxBorderRadius{ "2" };
    };

    struct InputDateConfig : InputFieldConfig
    {
        std::string dateIconColorNormal{ "#F2FFFFFF" };
        std::string dateIconColorOnFocus{ "#FF64B4FA" };
        std::string calendarBorderColor{ "#33FFFFFF" };
        std::string calendarBackgroundColor{ "#FF000000" };
        std::string dateElementColorNormal{ "#FF000000" };
        std::string dateElementColorOnHover{ "#33FFFFFF" };
        std::string dateElementColorOnFocus{ "#FF1170CF" };
        std::string dateElementTextColorOnHighlighted{ "#F2FFFFFF" };
        std::string dateElementTextColorNormal{ "#F2FFFFFF" };
        std::string notAvailabledateElementTextColor{ "#B2FFFFFF" };
        std::string dateElementSize{ "32" };
        std::string dateIconHorizontalPadding{ "12" };
        std::string calendarBorderRadius{ "12" };
        std::string calendarWidth{ "248" };
        std::string calendarHeight{ "293" };
        std::string calendarHeaderTextSize{ "16" };
        std::string dateGridTopMargin{ "14" };
        std::string calendarDayTextSize{ "16" };
        std::string calendarDateTextSize{ "16" };
        std::string arrowIconSize{ "28" };

    };

    struct ActionButtonColorConfig
    {
        std::string buttonColorNormal{ "#F2FFFFFF" };
        std::string buttonColorHovered{ "#CCFFFFFF" };
        std::string buttonColorPressed{ "#B2FFFFFF" };
        std::string buttonColorDisabled{ "#33FFFFFF" };
        std::string borderColor{ "#80000000" };
        std::string borderColorFocussed{ "#FF64B4FA" };
        std::string textColorNormal{ "#F2000000" };
        std::string textColorFocused{ "#F2000000" };
        std::string textColorDisabled{ "#66FFFFFF" };
    };

    struct ActionButtonsConfig
    {
        ActionButtonColorConfig primaryColorConfig;
        ActionButtonColorConfig secondaryColorConfig;
        ActionButtonColorConfig positiveColorConfig;
        ActionButtonColorConfig destructiveColorConfig;

        ActionButtonsConfig()
        {
            secondaryColorConfig.buttonColorNormal = "#00FFFFFF";
            secondaryColorConfig.buttonColorHovered = "#12FFFFFF";
            secondaryColorConfig.buttonColorPressed = "#33FFFFFF";
            secondaryColorConfig.borderColor = "#4DFFFFFF";
            secondaryColorConfig.textColorNormal = "#F2FFFFFF";
            secondaryColorConfig.textColorFocused = "#F2FFFFFF";

            positiveColorConfig.buttonColorNormal = "#00FFFFFF";
            positiveColorConfig.buttonColorHovered = "#FF185E46";
            positiveColorConfig.buttonColorPressed = "#FF134231";
            positiveColorConfig.borderColor = "#FF3CC29A";
            positiveColorConfig.textColorNormal = "#FF3CC29A";
            positiveColorConfig.textColorFocused = "#F2FFFFFF";

            destructiveColorConfig.buttonColorNormal = "#00FFFFFF";
            destructiveColorConfig.buttonColorHovered = "#FFAB0A15";
            destructiveColorConfig.buttonColorPressed = "#FF780D13";
            destructiveColorConfig.borderColor = "#FFFC8B98";
            destructiveColorConfig.textColorNormal = "#FFFC8B98";
            destructiveColorConfig.textColorFocused = "#F2FFFFFF";
        }
    };

    //Holds references to all elements
    class AdaptiveCardRenderConfig
    {
    public:
        AdaptiveCardRenderConfig(bool isDarkMode = true);
        bool isDarkMode() const;
        InputTextConfig getInputTextConfig() const;
        void setInputTextConfig(InputTextConfig config);
        InputNumberConfig getInputNumberConfig() const;
        void setInputNumberConfig(InputNumberConfig config);
        InputTimeConfig getInputTimeConfig() const;
        void setInputTimeConfig(InputTimeConfig config);
        InputChoiceSetDropDownConfig getInputChoiceSetDropDownConfig() const;
        void setInputChoiceSetDropDownConfig(InputChoiceSetDropDownConfig config);
        CheckBoxConfig getCheckBoxConfig() const;
        void setCheckBoxConfig(CheckBoxConfig config);
        RadioButtonConfig getRadioButtonConfig() const;
        void setRadioButtonConfig(RadioButtonConfig config);
        InputDateConfig getInputDateConfig() const;
        void setInputDateConfig(InputDateConfig config);
        ActionButtonsConfig getActionButtonsConfig() const;
        void setActionButtonsConfig(ActionButtonsConfig config);

    private:
        bool m_isDark;
        InputTextConfig m_textInputConfig;
        InputNumberConfig m_numberInputConfig;
        InputTimeConfig m_timeInputConfig;
        InputChoiceSetDropDownConfig m_choiceSetDropdownInputConfig;
        CheckBoxConfig m_checkBoxConfig;
        RadioButtonConfig m_radioButtonConfig;
        InputDateConfig m_dateInputConfig;
        ActionButtonsConfig m_actionButtonsConfig;
    };
}
