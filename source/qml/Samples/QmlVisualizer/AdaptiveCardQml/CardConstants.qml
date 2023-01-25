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
        readonly property int iconPadding: 4
        readonly property int columnSpacing: 3
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
        readonly property int numberInputMinWidth: 200
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
        readonly property int timePickerElementHeight: 32
        readonly property int timePickerMargins: 16
        readonly property int timePickerSpacing: 4
        readonly property int timePickerElementRadius: 4
        readonly property int timeIconButtonSize: 18
        readonly property int timeIconSize: 16
        readonly property int timeInputMinWidth: 300
        readonly property color timeIconColorNormal: AdaptiveCardUtils.getColorSet("textinput-text", "normal", isDarkTheme)
        readonly property color timeIconColorOnFocus: AdaptiveCardUtils.getColorSet("textinput-border", "focused", isDarkTheme)
        readonly property color timeIconColorOnError: AdaptiveCardUtils.getColorSet("textinput-error-border", "focused", isDarkTheme)
        readonly property color timePickerBorderColor: AdaptiveCardUtils.getColorSet("textinput-border", "normal", isDarkTheme)
        readonly property color timePickerBackgroundColor: AdaptiveCardUtils.getColorSet("textinput-background", "normal", isDarkTheme)
        readonly property color timePickerElementColorNormal: AdaptiveCardUtils.getColorSet("textinput-background", "normal", isDarkTheme)
        readonly property color timePickerElementColorOnHover: AdaptiveCardUtils.getColorSet("textinput-background", "hovered", isDarkTheme)
        readonly property color timePickerElementColorOnFocus: AdaptiveCardUtils.getColorSet("checkbox-checked-border", "pressed", isDarkTheme)
        readonly property color timePickerElementTextColorNormal: AdaptiveCardUtils.getColorSet("textinput-text", "normal", isDarkTheme)
        readonly property color timePickerElementTextColorHighlighted: AdaptiveCardUtils.getColorSet("textinput-text", "focused", isDarkTheme)
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
        readonly property int dateIconButtonSize: 18
        readonly property int dateIconSize: 16
        readonly property int dateInputMinWidth: 300
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
        readonly property color monthChangeButtonColor: AdaptiveCardUtils.getColorSet("button-primary-background", "normal", isDarkTheme)
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
        readonly property int indicatorWidth: 35
        readonly property int scrollbarWidth: 10
        readonly property int choiceSetMinWidth: 200
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
    readonly property string clearIconImage: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAiIGhlaWdodD0iMTAiIHZpZXdCb3g9IjAgMCAxMCAxMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+Y29tbW9uLWFjdGlvbnMvY2FuY2VsXzEwPC90aXRsZT48cGF0aCBkPSJNNS43MDcyNSA1LjAwMDI1bDIuNjQ2LTIuNjQ2Yy4xOTYtLjE5Ni4xOTYtLjUxMiAwLS43MDgtLjE5NS0uMTk1LS41MTEtLjE5NS0uNzA3IDBsLTIuNjQ2IDIuNjQ3LTIuNjQ3LTIuNjQ3Yy0uMTk1LS4xOTUtLjUxMS0uMTk1LS43MDcgMC0uMTk1LjE5Ni0uMTk1LjUxMiAwIC43MDhsMi42NDcgMi42NDYtMi42NDcgMi42NDZjLS4xOTUuMTk2LS4xOTUuNTEyIDAgLjcwOC4wOTguMDk3LjIyNi4xNDYuMzU0LjE0Ni4xMjggMCAuMjU2LS4wNDkuMzUzLS4xNDZsMi42NDctMi42NDcgMi42NDYgMi42NDdjLjA5OC4wOTcuMjI2LjE0Ni4zNTQuMTQ2LjEyOCAwIC4yNTYtLjA0OS4zNTMtLjE0Ni4xOTYtLjE5Ni4xOTYtLjUxMiAwLS43MDhsLTIuNjQ2LTIuNjQ2eiIgZmlsbC1ydWxlPSJldmVub2RkIi8+PC9zdmc+"
    readonly property string numberInputUpDownArrowImage: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTQiIGhlaWdodD0iMTQiIHZpZXdCb3g9IjAgMCAxNCAxNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEzLjQ0NzQgOS43NzYzOEMxMy40MTggOS43MTc2MyAxMy4zNzc0IDkuNjY1MjUgMTMuMzI3OCA5LjYyMjIyQzEzLjI3ODIgOS41NzkxOCAxMy4yMjA2IDkuNTQ2MzUgMTMuMTU4MyA5LjUyNTU4QzEzLjA5NiA5LjUwNDgxIDEzLjAzMDIgOS40OTY1MiAxMi45NjQ3IDkuNTAxMThDMTIuODk5MiA5LjUwNTgzIDEyLjgzNTIgOS41MjMzNSAxMi43NzY1IDkuNTUyNzNMNy4wMDAwNCAxMi40NDA5TDEuMjIzNzkgOS41NTI3M0MxLjEwNTE2IDkuNDkzNDEgMC45Njc4MzIgOS40ODM2NSAwLjg0MjAwOSA5LjUyNTU5QzAuNzE2MTg2IDkuNTY3NTIgMC42MTIxNzYgOS42NTc3MyAwLjU1Mjg2MSA5Ljc3NjM1QzAuNDkzNTQ1IDkuODk0OTggMC40ODM3ODIgMTAuMDMyMyAwLjUyNTcyIDEwLjE1ODFDMC41Njc2NTggMTAuMjg0IDAuNjU3ODYxIDEwLjM4OCAwLjc3NjQ4NiAxMC40NDczTDYuNzc2NDkgMTMuNDQ3M0M2Ljg0NTk0IDEzLjQ4MiA2LjkyMjUgMTMuNSA3LjAwMDE0IDEzLjVDNy4wNzc3NyAxMy41IDcuMTU0MzQgMTMuNDgyIDcuMjIzNzkgMTMuNDQ3M0wxMy4yMjM4IDEwLjQ0NzNDMTMuMjgyNSAxMC40MTc5IDEzLjMzNDkgMTAuMzc3MyAxMy4zNzc5IDEwLjMyNzdDMTMuNDIxIDEwLjI3OCAxMy40NTM4IDEwLjIyMDQgMTMuNDc0NiAxMC4xNTgxQzEzLjQ5NTMgMTAuMDk1OCAxMy41MDM2IDEwLjAzMDEgMTMuNDk4OSA5Ljk2NDU2QzEzLjQ5NDMgOS44OTkwNSAxMy40NzY4IDkuODM1MTEgMTMuNDQ3NCA5Ljc3NjM4WiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8cGF0aCBkPSJNMTMuMjIzOSAzLjU1MjcyTDcuMjIzNjkgMC41NTI3MjRDNy4xNTQyNCAwLjUxODA1IDcuMDc3NjggMC41IDcuMDAwMDYgMC41QzYuOTIyNDQgMC41IDYuODQ1ODggMC41MTgwNSA2Ljc3NjQ0IDAuNTUyNzI0TDAuNzc2NDM4IDMuNTUyNzJDMC42NTc4MTMgMy42MTIwMyAwLjU2NzYwOCAzLjcxNjA0IDAuNTI1NjY1IDMuODQxODZDMC41MDQ4OTcgMy45MDQxNSAwLjQ5NjYwNCAzLjk2OTkzIDAuNTAxMjU3IDQuMDM1NDRDMC41MDU5MTEgNC4xMDA5NCAwLjUyMzQyMSA0LjE2NDg5IDAuNTUyNzg4IDQuMjIzNjJDMC41ODIxNTUgNC4yODIzNiAwLjYyMjgwMyA0LjMzNDc0IDAuNjcyNDEzIDQuMzc3NzdDMC43MjIwMjIgNC40MjA3OSAwLjc3OTYyIDQuNDUzNjMgMC44NDE5MTkgNC40NzQ0QzAuOTY3NzM3IDQuNTE2MzQgMS4xMDUwNiA0LjUwNjU4IDEuMjIzNjkgNC40NDcyN0w3LjAwMDA5IDEuNTU5MDdMMTIuNzc2NyA0LjQ0NzI3QzEyLjg5NTMgNC41MDY1OCAxMy4wMzI2IDQuNTE2MzQgMTMuMTU4NSA0LjQ3NDRDMTMuMjIwOCA0LjQ1MzYzIDEzLjI3ODQgNC40MjA3OSAxMy4zMjggNC4zNzc3N0MxMy4zNzc2IDQuMzM0NzQgMTMuNDE4MiA0LjI4MjM2IDEzLjQ0NzYgNC4yMjM2MkMxMy40NzcgNC4xNjQ4OSAxMy40OTQ1IDQuMTAwOTQgMTMuNDk5MSA0LjAzNTQ0QzEzLjUwMzggMy45Njk5MyAxMy40OTU1IDMuOTA0MTUgMTMuNDc0NyAzLjg0MTg2QzEzLjQ1MzkgMy43Nzk1NiAxMy40MjExIDMuNzIxOTYgMTMuMzc4MSAzLjY3MjM1QzEzLjMzNTEgMy42MjI3NCAxMy4yODI3IDMuNTgyMDkgMTMuMjIzOSAzLjU1MjcyWiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8L3N2Zz4K"
    readonly property string calendarRightArrowIcon: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjgiIGhlaWdodD0iMjgiIHZpZXdCb3g9IjAgMCAyOCAyOCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4NCjxwYXRoIGQ9Ik0xNy4zNTM1IDEzLjY0NjZMMTEuMzUzNSA3LjY0NjZDMTEuMzA3MyA3LjU5OTAyIDExLjI1MjIgNy41NjEwOCAxMS4xOTEyIDcuNTM1MDJDMTEuMTMwMiA3LjUwODk1IDExLjA2NDcgNy40OTUyNyAxMC45OTg0IDcuNDk0NzdDMTAuOTMyMSA3LjQ5NDI2IDEwLjg2NjQgNy41MDY5NSAxMC44MDUgNy41MzIwOUMxMC43NDM3IDcuNTU3MjMgMTAuNjg3OSA3LjU5NDMzIDEwLjY0MTEgNy42NDEyMUMxMC41OTQyIDcuNjg4MDkgMTAuNTU3MSA3Ljc0MzgzIDEwLjUzMiA3LjgwNTE4QzEwLjUwNjggNy44NjY1MyAxMC40OTQxIDcuOTMyMjcgMTAuNDk0NiA3Ljk5ODU3QzEwLjQ5NTIgOC4wNjQ4NyAxMC41MDg4IDguMTMwNDEgMTAuNTM0OSA4LjE5MTM3QzEwLjU2MSA4LjI1MjMzIDEwLjU5ODkgOC4zMDc0OSAxMC42NDY1IDguMzUzNjVMMTYuMjkzIDE0TDEwLjY0NjUgMTkuNjQ2NkMxMC41OTg5IDE5LjY5MjggMTAuNTYxIDE5Ljc0NzkgMTAuNTM0OSAxOS44MDg5QzEwLjUwODggMTkuODY5OSAxMC40OTUyIDE5LjkzNTQgMTAuNDk0NiAyMC4wMDE3QzEwLjQ5NDEgMjAuMDY4IDEwLjUwNjggMjAuMTMzNyAxMC41MzIgMjAuMTk1MUMxMC41NTcxIDIwLjI1NjQgMTAuNTk0MiAyMC4zMTIyIDEwLjY0MTEgMjAuMzU5QzEwLjY4NzkgMjAuNDA1OSAxMC43NDM3IDIwLjQ0MyAxMC44MDUgMjAuNDY4MkMxMC44NjY0IDIwLjQ5MzMgMTAuOTMyMSAyMC41MDYgMTAuOTk4NCAyMC41MDU1QzExLjA2NDcgMjAuNTA1IDExLjEzMDIgMjAuNDkxMyAxMS4xOTEyIDIwLjQ2NTJDMTEuMjUyMiAyMC40MzkyIDExLjMwNzMgMjAuNDAxMiAxMS4zNTM1IDIwLjM1MzdMMTcuMzUzNSAxNC4zNTM3QzE3LjQ0NzMgMTQuMjU5OSAxNy40OTk5IDE0LjEzMjcgMTcuNDk5OSAxNC4wMDAxQzE3LjQ5OTkgMTMuODY3NSAxNy40NDczIDEzLjc0MDQgMTcuMzUzNSAxMy42NDY2WiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPg0KPC9zdmc+DQo="
    readonly property string calendarLeftArrowIcon: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjgiIGhlaWdodD0iMjgiIHZpZXdCb3g9IjAgMCAyOCAyOCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4NCjxwYXRoIGQ9Ik0xMS43MDc1IDE0TDE3LjM1MzkgOC4zNTM2NEMxNy40NDUzIDguMjU5NDEgMTcuNDk2IDguMTMzIDE3LjQ5NSA4LjAwMTcxQzE3LjQ5NCA3Ljg3MDQyIDE3LjQ0MTQgNy43NDQ3OSAxNy4zNDg2IDcuNjUxOTVDMTcuMjU1OCA3LjU1OTExIDE3LjEzMDEgNy41MDY1MSAxNi45OTg5IDcuNTA1NTFDMTYuODY3NiA3LjUwNDUgMTYuNzQxMSA3LjU1NTE4IDE2LjY0NjkgNy42NDY1OUwxMC42NDY5IDEzLjY0NjZDMTAuNTUzMiAxMy43NDA0IDEwLjUwMDUgMTMuODY3NSAxMC41MDA1IDE0LjAwMDFDMTAuNTAwNSAxNC4xMzI3IDEwLjU1MzIgMTQuMjU5OSAxMC42NDY5IDE0LjM1MzZMMTYuNjQ2OSAyMC4zNTM2QzE2LjY5MzEgMjAuNDAxMiAxNi43NDgyIDIwLjQzOTIgMTYuODA5MiAyMC40NjUyQzE2Ljg3MDIgMjAuNDkxMyAxNi45MzU3IDIwLjUwNSAxNy4wMDIgMjAuNTA1NUMxNy4wNjgzIDIwLjUwNiAxNy4xMzQgMjAuNDkzMyAxNy4xOTU0IDIwLjQ2ODJDMTcuMjU2NyAyMC40NDMgMTcuMzEyNSAyMC40MDU5IDE3LjM1OTQgMjAuMzU5QzE3LjQwNjIgMjAuMzEyMiAxNy40NDMzIDIwLjI1NjQgMTcuNDY4NSAyMC4xOTUxQzE3LjQ5MzYgMjAuMTMzNyAxNy41MDYzIDIwLjA2OCAxNy41MDU4IDIwLjAwMTdDMTcuNTA1MyAxOS45MzU0IDE3LjQ5MTYgMTkuODY5OCAxNy40NjU1IDE5LjgwODlDMTcuNDM5NCAxOS43NDc5IDE3LjQwMTUgMTkuNjkyOCAxNy4zNTM5IDE5LjY0NjZMMTEuNzA3NSAxNFoiIGZpbGw9ImJsYWNrIiBmaWxsLW9wYWNpdHk9IjAuOTUiLz4NCjwvc3ZnPg0K"
    readonly property string calendarIcon: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTQiIHZpZXdCb3g9IjAgMCAxMiAxNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTUuOTk5OTkgNS4xMjUwMkM2LjM0NTE3IDUuMTI1MDIgNi42MjQ5OSA0Ljg0NTIgNi42MjQ5OSA0LjUwMDAyQzYuNjI0OTkgNC4xNTQ4NCA2LjM0NTE3IDMuODc1MDIgNS45OTk5OSAzLjg3NTAyQzUuNjU0ODEgMy44NzUwMiA1LjM3NDk5IDQuMTU0ODQgNS4zNzQ5OSA0LjUwMDAyQzUuMzc0OTkgNC44NDUyIDUuNjU0ODEgNS4xMjUwMiA1Ljk5OTk5IDUuMTI1MDJaIiBmaWxsPSJibGFjayIgZmlsbC1vcGFjaXR5PSIwLjk1Ii8+CjxwYXRoIGQ9Ik01Ljk5OTk5IDguMTI1MDJDNi4zNDUxNyA4LjEyNTAyIDYuNjI0OTkgNy44NDUyIDYuNjI0OTkgNy41MDAwMkM2LjYyNDk5IDcuMTU0ODQgNi4zNDUxNyA2Ljg3NTAyIDUuOTk5OTkgNi44NzUwMkM1LjY1NDgxIDYuODc1MDIgNS4zNzQ5OSA3LjE1NDg0IDUuMzc0OTkgNy41MDAwMkM1LjM3NDk5IDcuODQ1MiA1LjY1NDgxIDguMTI1MDIgNS45OTk5OSA4LjEyNTAyWiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8cGF0aCBkPSJNNS45OTk5OSAxMS4xMjVDNi4zNDUxNyAxMS4xMjUgNi42MjQ5OSAxMC44NDUyIDYuNjI0OTkgMTAuNUM2LjYyNDk5IDEwLjE1NDggNi4zNDUxNyA5Ljg3NDk5IDUuOTk5OTkgOS44NzQ5OUM1LjY1NDgxIDkuODc0OTkgNS4zNzQ5OSAxMC4xNTQ4IDUuMzc0OTkgMTAuNUM1LjM3NDk5IDEwLjg0NTIgNS42NTQ4MSAxMS4xMjUgNS45OTk5OSAxMS4xMjVaIiBmaWxsPSJibGFjayIgZmlsbC1vcGFjaXR5PSIwLjk1Ii8+CjxwYXRoIGQ9Ik0yLjk5OTk5IDUuMTI1MDJDMy4zNDUxNyA1LjEyNTAyIDMuNjI0OTkgNC44NDUyIDMuNjI0OTkgNC41MDAwMkMzLjYyNDk5IDQuMTU0ODQgMy4zNDUxNyAzLjg3NTAyIDIuOTk5OTkgMy44NzUwMkMyLjY1NDgxIDMuODc1MDIgMi4zNzQ5OSA0LjE1NDg0IDIuMzc0OTkgNC41MDAwMkMyLjM3NDk5IDQuODQ1MiAyLjY1NDgxIDUuMTI1MDIgMi45OTk5OSA1LjEyNTAyWiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8cGF0aCBkPSJNOS41IDEuNDk5NzRWMC41MDAyNDRDOS41IDAuMzY3NjM2IDkuNDQ3MzIgMC4yNDA0NTkgOS4zNTM1NSAwLjE0NjY5MUM5LjI1OTc5IDAuMDUyOTIyNyA5LjEzMjYxIDAuMDAwMjQ0MTQxIDkgMC4wMDAyNDQxNDFDOC44NjczOSAwLjAwMDI0NDE0MSA4Ljc0MDIxIDAuMDUyOTIyNyA4LjY0NjQ1IDAuMTQ2NjkxQzguNTUyNjggMC4yNDA0NTkgOC41IDAuMzY3NjM2IDguNSAwLjUwMDI0NFYxLjQ5OTc0SDMuNVYwLjUwMDI0NEMzLjUgMC4zNjc2MzYgMy40NDczMiAwLjI0MDQ1OSAzLjM1MzU1IDAuMTQ2NjkxQzMuMjU5NzkgMC4wNTI5MjI3IDMuMTMyNjEgMC4wMDAyNDQxNDEgMyAwLjAwMDI0NDE0MUMyLjg2NzM5IDAuMDAwMjQ0MTQxIDIuNzQwMjEgMC4wNTI5MjI3IDIuNjQ2NDUgMC4xNDY2OTFDMi41NTI2OCAwLjI0MDQ1OSAyLjUgMC4zNjc2MzYgMi41IDAuNTAwMjQ0VjEuNDk5NzRDMS44MzcyIDEuNTAwNTIgMS4yMDE3NyAxLjc2NDE3IDAuNzMzMDk0IDIuMjMyODRDMC4yNjQ0MjIgMi43MDE1MSAwLjAwMDc3OTQwNCAzLjMzNjk0IDAgMy45OTk3NFYxMC45OTk3QzAuMDAwNzc5NDA0IDExLjY2MjUgMC4yNjQ0MjIgMTIuMjk4IDAuNzMzMDk0IDEyLjc2NjdDMS4yMDE3NyAxMy4yMzUzIDEuODM3MiAxMy40OTkgMi41IDEzLjQ5OTdIOS41QzEwLjE2MjggMTMuNDk5IDEwLjc5ODIgMTMuMjM1MyAxMS4yNjY5IDEyLjc2NjdDMTEuNzM1NiAxMi4yOTggMTEuOTk5MiAxMS42NjI1IDEyIDEwLjk5OTdWMy45OTk3NEMxMS45OTkyIDMuMzM2OTQgMTEuNzM1NiAyLjcwMTUxIDExLjI2NjkgMi4yMzI4NEMxMC43OTgyIDEuNzY0MTcgMTAuMTYyOCAxLjUwMDUyIDkuNSAxLjQ5OTc0Wk0xMSAxMC45OTk3QzEwLjk5OTYgMTEuMzk3NCAxMC44NDE0IDExLjc3ODcgMTAuNTYwMiAxMi4wNTk5QzEwLjI3OSAxMi4zNDExIDkuODk3NjkgMTIuNDk5MyA5LjUgMTIuNDk5N0gyLjVDMi4xMDIzMSAxMi40OTkzIDEuNzIxMDMgMTIuMzQxMSAxLjQzOTgyIDEyLjA1OTlDMS4xNTg2MSAxMS43Nzg3IDEuMDAwNDMgMTEuMzk3NCAxIDEwLjk5OTdWMy45OTk3NEMxLjAwMDQ0IDMuNjAyMDUgMS4xNTg2MSAzLjIyMDc4IDEuNDM5ODIgMi45Mzk1NkMxLjcyMTAzIDIuNjU4MzUgMi4xMDIzMSAyLjUwMDE4IDIuNSAyLjQ5OTc0SDkuNUM5Ljg5NzY5IDIuNTAwMTggMTAuMjc5IDIuNjU4MzUgMTAuNTYwMiAyLjkzOTU2QzEwLjg0MTQgMy4yMjA3NyAxMC45OTk2IDMuNjAyMDUgMTEgMy45OTk3NFYxMC45OTk3WiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8cGF0aCBkPSJNMi45OTk5OSA4LjEyNTAyQzMuMzQ1MTcgOC4xMjUwMiAzLjYyNDk5IDcuODQ1MiAzLjYyNDk5IDcuNTAwMDJDMy42MjQ5OSA3LjE1NDg0IDMuMzQ1MTcgNi44NzUwMiAyLjk5OTk5IDYuODc1MDJDMi42NTQ4MSA2Ljg3NTAyIDIuMzc0OTkgNy4xNTQ4NCAyLjM3NDk5IDcuNTAwMDJDMi4zNzQ5OSA3Ljg0NTIgMi42NTQ4MSA4LjEyNTAyIDIuOTk5OTkgOC4xMjUwMloiIGZpbGw9ImJsYWNrIiBmaWxsLW9wYWNpdHk9IjAuOTUiLz4KPHBhdGggZD0iTTIuOTk5OTkgMTEuMTI1QzMuMzQ1MTcgMTEuMTI1IDMuNjI0OTkgMTAuODQ1MiAzLjYyNDk5IDEwLjVDMy42MjQ5OSAxMC4xNTQ4IDMuMzQ1MTcgOS44NzQ5OSAyLjk5OTk5IDkuODc0OTlDMi42NTQ4MSA5Ljg3NDk5IDIuMzc0OTkgMTAuMTU0OCAyLjM3NDk5IDEwLjVDMi4zNzQ5OSAxMC44NDUyIDIuNjU0ODEgMTEuMTI1IDIuOTk5OTkgMTEuMTI1WiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8cGF0aCBkPSJNOC45OTk5OSA1LjEyNTAyQzkuMzQ1MTcgNS4xMjUwMiA5LjYyNDk5IDQuODQ1MiA5LjYyNDk5IDQuNTAwMDJDOS42MjQ5OSA0LjE1NDg0IDkuMzQ1MTcgMy44NzUwMiA4Ljk5OTk5IDMuODc1MDJDOC42NTQ4MSAzLjg3NTAyIDguMzc0OTkgNC4xNTQ4NCA4LjM3NDk5IDQuNTAwMDJDOC4zNzQ5OSA0Ljg0NTIgOC42NTQ4MSA1LjEyNTAyIDguOTk5OTkgNS4xMjUwMloiIGZpbGw9ImJsYWNrIiBmaWxsLW9wYWNpdHk9IjAuOTUiLz4KPHBhdGggZD0iTTguOTk5OTkgOC4xMjUwMkM5LjM0NTE3IDguMTI1MDIgOS42MjQ5OSA3Ljg0NTIgOS42MjQ5OSA3LjUwMDAyQzkuNjI0OTkgNy4xNTQ4NCA5LjM0NTE3IDYuODc1MDIgOC45OTk5OSA2Ljg3NTAyQzguNjU0ODEgNi44NzUwMiA4LjM3NDk5IDcuMTU0ODQgOC4zNzQ5OSA3LjUwMDAyQzguMzc0OTkgNy44NDUyIDguNjU0ODEgOC4xMjUwMiA4Ljk5OTk5IDguMTI1MDJaIiBmaWxsPSJibGFjayIgZmlsbC1vcGFjaXR5PSIwLjk1Ii8+CjxwYXRoIGQ9Ik04Ljk5OTk5IDExLjEyNUM5LjM0NTE3IDExLjEyNSA5LjYyNDk5IDEwLjg0NTIgOS42MjQ5OSAxMC41QzkuNjI0OTkgMTAuMTU0OCA5LjM0NTE3IDkuODc0OTkgOC45OTk5OSA5Ljg3NDk5QzguNjU0ODEgOS44NzQ5OSA4LjM3NDk5IDEwLjE1NDggOC4zNzQ5OSAxMC41QzguMzc0OTkgMTAuODQ1MiA4LjY1NDgxIDExLjEyNSA4Ljk5OTk5IDExLjEyNVoiIGZpbGw9ImJsYWNrIiBmaWxsLW9wYWNpdHk9IjAuOTUiLz4KPC9zdmc+Cg=="
    readonly property string clockIcon: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjgiIGhlaWdodD0iMjgiIHZpZXdCb3g9IjAgMCAyOCAyOCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTE0Ljc1MDUgMTMuNjkwN1Y2LjAwMDNDMTQuNzUwNSA1LjgwMTM5IDE0LjY3MTUgNS42MTA2MiAxNC41MzA4IDUuNDY5OTdDMTQuMzkwMiA1LjMyOTMyIDE0LjE5OTQgNS4yNTAzIDE0LjAwMDUgNS4yNTAzQzEzLjgwMTYgNS4yNTAzIDEzLjYxMDggNS4zMjkzMiAxMy40NzAyIDUuNDY5OTdDMTMuMzI5NSA1LjYxMDYyIDEzLjI1MDUgNS44MDEzOSAxMy4yNTA1IDYuMDAwM1YxNC4wMDAzQzEzLjI1NDMgMTQuMjA0IDEzLjMzNjkgMTQuMzk4MiAxMy40ODEgMTQuNTQyM0wxOC40NzAyIDE5LjUzMDZDMTguNjEwOSAxOS42NzEyIDE4LjgwMTYgMTkuNzUwMiAxOS4wMDA1IDE5Ljc1MDJDMTkuMTk5NCAxOS43NTAyIDE5LjM5MDEgMTkuNjcxMiAxOS41MzA4IDE5LjUzMDZDMTkuNjcxNCAxOS4zODk5IDE5Ljc1MDQgMTkuMTk5MiAxOS43NTA0IDE5LjAwMDNDMTkuNzUwNCAxOC44MDE0IDE5LjY3MTQgMTguNjEwNiAxOS41MzA4IDE4LjQ3TDE0Ljc1MDUgMTMuNjkwN1oiIGZpbGw9IiMwRjBGMEYiLz4KPHBhdGggZD0iTTE0LjAwMDUgMC4yNTAzMDFDMTEuMjgxIDAuMjUwMzAxIDguNjIyNTggMS4wNTY3MiA2LjM2MTQgMi41Njc1OUM0LjEwMDIzIDQuMDc4NDYgMi4zMzc4NiA2LjIyNTkyIDEuMjk3MTUgOC43Mzg0QzAuMjU2NDQ2IDExLjI1MDkgLTAuMDE1ODQ5OSAxNC4wMTU2IDAuNTE0Njk3IDE2LjY4MjhDMS4wNDUyNCAxOS4zNSAyLjM1NDggMjEuOCA0LjI3Nzc4IDIzLjcyM0M2LjIwMDc1IDI1LjY0NiA4LjY1MDc2IDI2Ljk1NTYgMTEuMzE4IDI3LjQ4NjFDMTMuOTg1MiAyOC4wMTY2IDE2Ljc0OTkgMjcuNzQ0NCAxOS4yNjI0IDI2LjcwMzZDMjEuNzc0OSAyNS42NjI5IDIzLjkyMjMgMjMuOTAwNiAyNS40MzMyIDIxLjYzOTRDMjYuOTQ0MSAxOS4zNzgyIDI3Ljc1MDUgMTYuNzE5OCAyNy43NTA1IDE0LjAwMDNDMjcuNzQ2NSAxMC4zNTQ4IDI2LjI5NjUgNi44NTk3OSAyMy43MTg4IDQuMjgyMDRDMjEuMTQxIDEuNzA0MjkgMTcuNjQ2IDAuMjU0MzM1IDE0LjAwMDUgMC4yNTAzMDFaTTE0LjAwMDUgMjYuMjUwM0MxMS41Nzc3IDI2LjI1MDMgOS4yMDkyNiAyNS41MzE5IDcuMTk0NzYgMjQuMTg1OEM1LjE4MDI2IDIyLjgzOTggMy42MTAxNCAyMC45MjY2IDIuNjgyOTcgMTguNjg4MkMxLjc1NTggMTYuNDQ5OCAxLjUxMzIxIDEzLjk4NjcgMS45ODU4NyAxMS42MTA0QzIuNDU4NTQgOS4yMzQxOCAzLjYyNTI0IDcuMDUxNDQgNS4zMzg0NCA1LjMzODI0QzcuMDUxNjMgMy42MjUwNSA5LjIzNDM3IDIuNDU4MzUgMTEuNjEwNiAxLjk4NTY4QzEzLjk4NjkgMS41MTMwMSAxNi40NSAxLjc1NTYgMTguNjg4NCAyLjY4Mjc4QzIwLjkyNjggMy42MDk5NSAyMi44NCA1LjE4MDA2IDI0LjE4NiA3LjE5NDU3QzI1LjUzMiA5LjIwOTA3IDI2LjI1MDUgMTEuNTc3NSAyNi4yNTA1IDE0LjAwMDNDMjYuMjQ2OSAxNy4yNDgxIDI0Ljk1NTEgMjAuMzYxOCAyMi42NTg2IDIyLjY1ODRDMjAuMzYyIDI0Ljk1NDkgMTcuMjQ4MyAyNi4yNDY3IDE0LjAwMDUgMjYuMjUwM1oiIGZpbGw9IiMwRjBGMEYiLz4KPC9zdmc+Cg=="
}
