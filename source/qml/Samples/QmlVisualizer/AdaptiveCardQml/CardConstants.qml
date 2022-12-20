import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15
pragma Singleton

QtObject {
    property bool isDarkTheme: false
    readonly property QtObject
    cardConstants: QtObject {
        readonly property int cardRadius: 8
        readonly property int cardWidth: 432
        readonly property int averageCharHeight: 14
        readonly property int averageCharWidth: 6
        readonly property int averageSpacing: 4
        readonly property color cardBorderColor: AdaptiveCardUtils.getColorSet("card-disabled-border", "normal", isDarkTheme)
        readonly property color focusRectangleColor: AdaptiveCardUtils.getColorSet("textinput-border", "normal", isDarkTheme)
        readonly property color textHighlightBackground: AdaptiveCardUtils.getColorSet("text-highlight", "normal", isDarkTheme)
    }

    readonly property QtObject
    inputFieldConstants: QtObject {
        readonly property int height: 32
        readonly property int pixelSize: 16
        readonly property int maxChoiceWidth: 800
        readonly property int labelPixelSize: 14
        readonly property int borderRadius: 8
        readonly property int borderWidth: 1
        readonly property int clearIconSize: 16
        readonly property int clearIconHorizontalPadding: 12
        readonly property int textHorizontalPadding: 12
        readonly property int textVerticalPadding: 4
        readonly property color backgroundColorNormal: AdaptiveCardUtils.getColorSet("textinput-background", "normal", isDarkTheme)
        readonly property color backgroundColorOnHovered: AdaptiveCardUtils.getColorSet("textinput-background", "hovered", isDarkTheme)
        readonly property color backgroundColorOnPressed: AdaptiveCardUtils.getColorSet("textinput-background", "pressed", isDarkTheme)
        readonly property color backgroundColorOnError: AdaptiveCardUtils.getColorSet("textinput-error-background", "normal", isDarkTheme)
        readonly property color borderColorNormal: AdaptiveCardUtils.getColorSet("textinput-border", "normal", isDarkTheme)
        readonly property color borderColorOnFocus: AdaptiveCardUtils.getColorSet("textinput-border", "focused", isDarkTheme)
        readonly property color borderColorOnError: AdaptiveCardUtils.getColorSet("textinput-error-border", "normal", isDarkTheme)
        readonly property color placeHolderColor: AdaptiveCardUtils.getColorSet("textinput-placeholder-text", "normal", isDarkTheme)
        readonly property color textColor: AdaptiveCardUtils.getColorSet("textinput-text", "normal", isDarkTheme)
        readonly property color errorMessageColor: AdaptiveCardUtils.getColorSet("label-error-text", "normal", isDarkTheme)
        readonly property color clearIconColorNormal: AdaptiveCardUtils.getColorSet("textinput-placeholder-text", "normal", isDarkTheme)
        readonly property color clearIconColorOnFocus: AdaptiveCardUtils.getColorSet("textinput-border", "focused", isDarkTheme)
    }

    readonly property QtObject
    inputTextConstants: QtObject {
        readonly property int multiLineTextHeight: 96
        readonly property int multiLineTextTopPadding: 7
        readonly property int multiLineTextBottomPadding: 4
    }

    readonly property QtObject
    inputNumberConstants: QtObject {
        readonly property int upDownButtonWidth: 31
        readonly property int upDownIconSize: 16
        readonly property color upDownIconColor: AdaptiveCardUtils.getColorSet("textinput-text", "normal", isDarkTheme)
    }

    readonly property QtObject
    inputTimeConstants: QtObject {
        readonly property int timeIconHorizontalPadding: 12
        readonly property int timePickerBorderRadius: 12
        readonly property int timePickerWidth12Hour: 200
        readonly property int timePickerWidth24Hour: 134
        readonly property int timePickerHeight: 280
        readonly property int timePickerColumnSpacing: 16
        readonly property int timePickerHoursAndMinutesTagWidth: 43
        readonly property int timePickerAMPMTagWidth: 50
        readonly property int timePickerElementHeight: 32
        readonly property int timePickerMargins: 16
        readonly property int timePickerSpacing: 4
        readonly property int timePickerElementRadius: 4
        readonly property color timeIconColorNormal: AdaptiveCardUtils.getColorSet("textinput-text", "normal", isDarkTheme)
        readonly property color timeIconColorOnFocus: AdaptiveCardUtils.getColorSet("textinput-border", "focused", isDarkTheme)
        readonly property color timeIconColorOnError: AdaptiveCardUtils.getColorSet("textinput-error-border", "focused", isDarkTheme)
        readonly property color timePickerBorderColor: AdaptiveCardUtils.getColorSet("textinput-border", "normal", isDarkTheme)
        readonly property color timePickerBackgroundColor: AdaptiveCardUtils.getColorSet("textinput-background", "normal", isDarkTheme)
        readonly property color timePickerElementColorNormal: AdaptiveCardUtils.getColorSet("textinput-background", "normal", isDarkTheme)
        readonly property color timePickerElementColorOnHover: AdaptiveCardUtils.getColorSet("textinput-background", "hovered", isDarkTheme)
        readonly property color timePickerElementColorOnFocus: AdaptiveCardUtils.getColorSet("checkbox-checked-border", "pressed", isDarkTheme)
        readonly property color timePickerElementTextColorNormal: AdaptiveCardUtils.getColorSet("textinput-text", "normal", isDarkTheme)
    }

    readonly property QtObject
    inputDateConstants: QtObject {
        readonly property int dateElementSize: 32
        readonly property int dateIconHorizontalPadding: 12
        readonly property int calendarBorderRadius: 12
        readonly property int calendarWidth: 248
        readonly property int calendarHeight: 293
        readonly property int calendarHeaderTextSize: 16
        readonly property int dateGridTopMargin: 14
        readonly property int calendarDayTextSize: 16
        readonly property int calendarDateTextSize: 16
        readonly property int arrowIconSize: 28
        readonly property color dateIconColorNormal: AdaptiveCardUtils.getColorSet("textinput-text", "normal", isDarkTheme)
        readonly property color dateIconColorOnFocus: AdaptiveCardUtils.getColorSet("textinput-border", "focused", isDarkTheme)
        readonly property color dateIconColorOnError: AdaptiveCardUtils.getColorSet("textinput-error-border", "focused", isDarkTheme)
        readonly property color calendarBorderColor: AdaptiveCardUtils.getColorSet("textinput-border", "normal", isDarkTheme)
        readonly property color calendarBackgroundColor: AdaptiveCardUtils.getColorSet("textinput-background", "normal", isDarkTheme)
        readonly property color dateElementColorNormal: AdaptiveCardUtils.getColorSet("textinput-background", "normal", isDarkTheme)
        readonly property color dateElementColorOnHover: AdaptiveCardUtils.getColorSet("textinput-background", "hovered", isDarkTheme)
        readonly property color dateElementColorOnFocus: AdaptiveCardUtils.getColorSet("checkbox-checked-border", "pressed", isDarkTheme)
        readonly property color dateElementTextColorNormal: AdaptiveCardUtils.getColorSet("textinput-text", "normal", isDarkTheme)
        readonly property color notAvailabledateElementTextColor: AdaptiveCardUtils.getColorSet("textinput-placeholder-text", "normal", isDarkTheme)
    }

    readonly property QtObject
    comboBoxConstants: QtObject {
        readonly property int arrowIconHorizontalPadding: 9
        readonly property int arrowIconVerticalPadding: 8
        readonly property int arrowIconWidth: 13
        readonly property int arrowIconHeight: 7
        readonly property int textHorizontalPadding: 12
        readonly property int dropDownElementHeight: 40
        readonly property int dropDownElementHorizontalPadding: 12
        readonly property int dropDownElementVerticalPadding: 8
        readonly property int dropDownElementRadius: 8
        readonly property int dropDownElementTextHorizontalPadding: 12
        readonly property int dropDownRadius: 12
        readonly property int dropDownPadding: 8
        readonly property int dropDownHeight: 216
        readonly property int maxDropDownWidth: 800
        readonly property int indicatorWidth : 35
        readonly property int scrollbarWidth : 10
        readonly property int choiceSetMinWidth : 200
        readonly property color arrowIconColor: AdaptiveCardUtils.getColorSet("textinput-text", "normal", isDarkTheme)
        readonly property color dropDownElementColorPressed: AdaptiveCardUtils.getColorSet("textinput-background", "pressed", isDarkTheme)
        readonly property color dropDownElementColorHovered: AdaptiveCardUtils.getColorSet("textinput-background", "hovered", isDarkTheme)
        readonly property color dropDownElementColorNormal: AdaptiveCardUtils.getColorSet("textinput-background", "normal", isDarkTheme)
        readonly property color dropDownBorderColor: AdaptiveCardUtils.getColorSet("textinput-border", "normal", isDarkTheme)
        readonly property color dropDownBackgroundColor: AdaptiveCardUtils.getColorSet("textinput-background", "normal", isDarkTheme)
    }

    readonly property QtObject
    toggleButtonConstants: QtObject {
        readonly property int radioButtonOuterCircleSize: 16
        readonly property int radioButtonInnerCircleSize: 6
        readonly property int checkBoxSize: 16
        readonly property int checkBoxBorderRadius: 2
        readonly property int pixelSize: 16
        readonly property int labelSize: 14
        readonly property int borderWidth: 1
        readonly property int rowSpacing: 8
        readonly property int rowHeight: 24
        readonly property int indicatorTopPadding: 4
        readonly property color colorOnCheckedAndPressed: AdaptiveCardUtils.getColorSet("checkbox-checked-background", "pressed", isDarkTheme)
        readonly property color colorOnCheckedAndHovered: AdaptiveCardUtils.getColorSet("checkbox-checked-background", "hovered", isDarkTheme)
        readonly property color colorOnChecked: AdaptiveCardUtils.getColorSet("checkbox-checked-background", "normal", isDarkTheme)
        readonly property color colorOnUncheckedAndPressed: AdaptiveCardUtils.getColorSet("checkbox-unchecked-background", "pressed", isDarkTheme)
        readonly property color colorOnUncheckedAndHovered: AdaptiveCardUtils.getColorSet("checkbox-unchecked-background", "hovered", isDarkTheme)
        readonly property color colorOnUnchecked: AdaptiveCardUtils.getColorSet("checkbox-unchecked-background", "normal", isDarkTheme)
        readonly property color borderColorOnCheckedAndPressed: AdaptiveCardUtils.getColorSet("checkbox-checked-border", "pressed", isDarkTheme)
        readonly property color borderColorOnCheckedAndHovered: AdaptiveCardUtils.getColorSet("checkbox-checked-border", "hovered", isDarkTheme)
        readonly property color borderColorOnChecked: AdaptiveCardUtils.getColorSet("checkbox-checked-border", "normal", isDarkTheme)
        readonly property color borderColorOnUncheckedAndPressed: AdaptiveCardUtils.getColorSet("checkbox-unchecked-background", "pressed", isDarkTheme)
        readonly property color borderColorOnUncheckedAndHovered: AdaptiveCardUtils.getColorSet("checkbox-unchecked-background", "hovered", isDarkTheme)
        readonly property color borderColorOnUnchecked: AdaptiveCardUtils.getColorSet("checkbox-unchecked-background", "normal", isDarkTheme)
        readonly property color textColor: AdaptiveCardUtils.getColorSet("textinput-text", "normal", isDarkTheme)
        readonly property color errorMessageColor: AdaptiveCardUtils.getColorSet("label-error-text", "normal", isDarkTheme)
        readonly property color radioButtonInnerCircleColorOnChecked: AdaptiveCardUtils.getColorSet("checkbox-checked-icon", "normal", isDarkTheme)
        readonly property color checkBoxIconColorOnChecked: AdaptiveCardUtils.getColorSet("checkbox-checked-icon", "normal", isDarkTheme)
        readonly property color focusRectangleColor: AdaptiveCardUtils.getColorSet("textinput-border", "normal", isDarkTheme)
    }

    readonly property QtObject
    actionButtonConstants: QtObject {
        readonly property int buttonRadius: 16
        readonly property int horizotalPadding: 10
        readonly property int verticalPadding: 5
        readonly property int buttonHeight: 28
        readonly property int iconWidth: 14
        readonly property int iconHeight: 14
        readonly property int imageSize: 14
        readonly property int iconTextSpacing: 5
        readonly property int pixelSize: 14
        readonly property int fontWeight: Font.DemiBold 
    }

    readonly property QtObject
    primaryButtonColors: QtObject {
        readonly property color buttonColorNormal: AdaptiveCardUtils.getColorSet("button-primary-background", "normal", isDarkTheme)
        readonly property color buttonColorHovered: AdaptiveCardUtils.getColorSet("button-primary-background", "hovered", isDarkTheme)
        readonly property color buttonColorPressed: AdaptiveCardUtils.getColorSet("button-primary-background", "pressed", isDarkTheme)
        readonly property color borderColorNormal: AdaptiveCardUtils.getColorSet("button-primary-border", "normal", isDarkTheme)
        readonly property color borderColorHovered: AdaptiveCardUtils.getColorSet("button-primary-border", "hovered", isDarkTheme)
        readonly property color borderColorPressed: AdaptiveCardUtils.getColorSet("button-primary-border", "pressed", isDarkTheme)
        readonly property color borderColorFocussed: AdaptiveCardUtils.getColorSet("textinput-border", "focused", isDarkTheme)
        readonly property color textColorNormal: AdaptiveCardUtils.getColorSet("button-primary-text", "normal", isDarkTheme)
        readonly property color textColorHovered: AdaptiveCardUtils.getColorSet("button-primary-text", "hovered", isDarkTheme)
        readonly property color textColorPressed: AdaptiveCardUtils.getColorSet("button-primary-text", "pressed", isDarkTheme)
        readonly property color buttonColorDisabled: AdaptiveCardUtils.getColorSet("button-secondary-background", "pressed", isDarkTheme)
        readonly property color textColorDisabled: AdaptiveCardUtils.getColorSet("button-secondary-text", "disabled", isDarkTheme)
        readonly property color focusRectangleColor: AdaptiveCardUtils.getColorSet("textinput-border", "normal", isDarkTheme)
    }

    readonly property QtObject
    secondaryButtonColors: QtObject {
        readonly property color buttonColorNormal: AdaptiveCardUtils.getColorSet("button-secondary-background", "normal", isDarkTheme)
        readonly property color buttonColorHovered: AdaptiveCardUtils.getColorSet("button-secondary-background", "hovered", isDarkTheme)
        readonly property color buttonColorPressed: AdaptiveCardUtils.getColorSet("button-secondary-background", "pressed", isDarkTheme)
        readonly property color borderColorNormal: AdaptiveCardUtils.getColorSet("button-secondary-border", "normal", isDarkTheme)
        readonly property color borderColorHovered: AdaptiveCardUtils.getColorSet("button-secondary-border", "hovered", isDarkTheme)
        readonly property color borderColorPressed: AdaptiveCardUtils.getColorSet("button-secondary-border", "pressed", isDarkTheme)
        readonly property color borderColorFocussed: AdaptiveCardUtils.getColorSet("textinput-border", "focused", isDarkTheme)
        readonly property color textColorNormal: AdaptiveCardUtils.getColorSet("button-secondary-text", "normal", isDarkTheme)
        readonly property color textColorHovered: AdaptiveCardUtils.getColorSet("button-secondary-text", "hovered", isDarkTheme)
        readonly property color textColorPressed: AdaptiveCardUtils.getColorSet("button-secondary-text", "pressed", isDarkTheme)
        readonly property color buttonColorDisabled: AdaptiveCardUtils.getColorSet("button-secondary-background", "pressed", isDarkTheme)
        readonly property color textColorDisabled: AdaptiveCardUtils.getColorSet("button-secondary-text", "disabled", isDarkTheme)
        readonly property color focusRectangleColor: AdaptiveCardUtils.getColorSet("textinput-border", "normal", isDarkTheme)
    }

    readonly property QtObject
    positiveButtonColors: QtObject {
        readonly property color buttonColorNormal: AdaptiveCardUtils.getColorSet("button-join-outline-background", "normal", isDarkTheme)
        readonly property color buttonColorHovered: AdaptiveCardUtils.getColorSet("button-join-outline-background", "hovered", isDarkTheme)
        readonly property color buttonColorPressed: AdaptiveCardUtils.getColorSet("button-join-outline-background", "pressed", isDarkTheme)
        readonly property color borderColorNormal: AdaptiveCardUtils.getColorSet("button-join-outline-border", "normal", isDarkTheme)
        readonly property color borderColorHovered: AdaptiveCardUtils.getColorSet("button-join-outline-border", "hovered", isDarkTheme)
        readonly property color borderColorPressed: AdaptiveCardUtils.getColorSet("button-join-outline-border", "pressed", isDarkTheme)
        readonly property color borderColorFocussed: AdaptiveCardUtils.getColorSet("textinput-border", "focused", isDarkTheme)
        readonly property color textColorNormal: AdaptiveCardUtils.getColorSet("button-join-outline-text", "normal", isDarkTheme)
        readonly property color textColorHovered: AdaptiveCardUtils.getColorSet("button-join-outline-text", "hovered", isDarkTheme)
        readonly property color textColorPressed: AdaptiveCardUtils.getColorSet("button-join-outline-text", "pressed", isDarkTheme)
        readonly property color buttonColorDisabled: AdaptiveCardUtils.getColorSet("button-secondary-background", "pressed", isDarkTheme)
        readonly property color textColorDisabled: AdaptiveCardUtils.getColorSet("button-secondary-text", "disabled", isDarkTheme)
        readonly property color focusRectangleColor: AdaptiveCardUtils.getColorSet("textinput-border", "normal", isDarkTheme)
    }

    readonly property QtObject
    destructiveButtonColors: QtObject {
        readonly property color buttonColorNormal: AdaptiveCardUtils.getColorSet("button-cancel-outline-background", "normal", isDarkTheme)
        readonly property color buttonColorHovered: AdaptiveCardUtils.getColorSet("button-cancel-outline-background", "hovered", isDarkTheme)
        readonly property color buttonColorPressed: AdaptiveCardUtils.getColorSet("button-cancel-outline-background", "pressed", isDarkTheme)
        readonly property color borderColorNormal: AdaptiveCardUtils.getColorSet("button-cancel-outline-border", "normal", isDarkTheme)
        readonly property color borderColorHovered: AdaptiveCardUtils.getColorSet("button-cancel-outline-border", "hovered", isDarkTheme)
        readonly property color borderColorPressed: AdaptiveCardUtils.getColorSet("button-cancel-outline-border", "pressed", isDarkTheme)
        readonly property color borderColorFocussed: AdaptiveCardUtils.getColorSet("textinput-border", "focused", isDarkTheme)
        readonly property color textColorNormal: AdaptiveCardUtils.getColorSet("button-cancel-outline-text", "normal", isDarkTheme)
        readonly property color textColorHovered: AdaptiveCardUtils.getColorSet("button-cancel-outline-text", "hovered", isDarkTheme)
        readonly property color textColorPressed: AdaptiveCardUtils.getColorSet("button-cancel-outline-text", "pressed", isDarkTheme)
        readonly property color buttonColorDisabled: AdaptiveCardUtils.getColorSet("button-secondary-background", "pressed", isDarkTheme)
        readonly property color textColorDisabled: AdaptiveCardUtils.getColorSet("button-secondary-text", "disabled", isDarkTheme)
        readonly property color focusRectangleColor: AdaptiveCardUtils.getColorSet("textinput-border", "normal", isDarkTheme)
    }

    readonly property string showCardArrowDownImage: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+bmF2aWdhdGlvbi9hcnJvdy1kb3duXzEyPC90aXRsZT48cGF0aCBkPSJNMS4wMDA0MSAzLjQ5OTc0ODc2NGMwLS4xMzcuMDU2LS4yNzMuMTY1LS4zNzIuMjA2LS4xODUwMDAwMDAxLjUyMi0uMTY4MDAwMDAwMS43MDcuMDM3bDQuMTI4IDQuNTg2OTk5OTk2IDQuMTI4LTQuNTg2OTk5OTk2Yy4xODUtLjIwNTAwMDAwMDEuNTAxLS4yMjIwMDAwMDAxLjcwNy0uMDM3LjIwNC4xODUuMjIxLjUwMS4wMzcuNzA2bC00LjUgNC45OTk5OTk5OTZjLS4wOTYuMTA2LS4yMy4xNjYtLjM3Mi4xNjYtLjE0MiAwLS4yNzYtLjA2LS4zNzItLjE2NmwtNC41LTQuOTk5OTk5OTk2Yy0uMDg2LS4wOTUtLjEyOC0uMjE1LS4xMjgtLjMzNCIgZmlsbD0iIzAwMCIgZmlsbC1ydWxlPSJldmVub2RkIi8+PC9zdmc+";
    readonly property string showCardArrowUpImage: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+bmF2aWdhdGlvbi9hcnJvdy11cF8xMjwvdGl0bGU+PHBhdGggZD0iTTEuMDAwNDEgOC41MDAyNTEyMzZjMCAuMTM3LjA1Ni4yNzMuMTY1LjM3Mi4yMDYuMTg1MDAwMDAwMS41MjIuMTY4MDAwMDAwMS43MDctLjAzN2w0LjEyOC00LjU4Njk5OTk5NiA0LjEyOCA0LjU4Njk5OTk5NmMuMTg1LjIwNTAwMDAwMDEuNTAxLjIyMjAwMDAwMDEuNzA3LjAzNy4yMDQtLjE4NS4yMjEtLjUwMS4wMzctLjcwNmwtNC41LTQuOTk5OTk5OTk2Yy0uMDk2LS4xMDYtLjIzLS4xNjYtLjM3Mi0uMTY2LS4xNDIgMC0uMjc2LjA2LS4zNzIuMTY2bC00LjUgNC45OTk5OTk5OTZjLS4wODYuMDk1LS4xMjguMjE1LS4xMjguMzM0IiBmaWxsPSIjMDAwIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiLz48L3N2Zz4=";

}
