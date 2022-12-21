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

    readonly property string clearIconImage: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAiIGhlaWdodD0iMTAiIHZpZXdCb3g9IjAgMCAxMCAxMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+Y29tbW9uLWFjdGlvbnMvY2FuY2VsXzEwPC90aXRsZT48cGF0aCBkPSJNNS43MDcyNSA1LjAwMDI1bDIuNjQ2LTIuNjQ2Yy4xOTYtLjE5Ni4xOTYtLjUxMiAwLS43MDgtLjE5NS0uMTk1LS41MTEtLjE5NS0uNzA3IDBsLTIuNjQ2IDIuNjQ3LTIuNjQ3LTIuNjQ3Yy0uMTk1LS4xOTUtLjUxMS0uMTk1LS43MDcgMC0uMTk1LjE5Ni0uMTk1LjUxMiAwIC43MDhsMi42NDcgMi42NDYtMi42NDcgMi42NDZjLS4xOTUuMTk2LS4xOTUuNTEyIDAgLjcwOC4wOTguMDk3LjIyNi4xNDYuMzU0LjE0Ni4xMjggMCAuMjU2LS4wNDkuMzUzLS4xNDZsMi42NDctMi42NDcgMi42NDYgMi42NDdjLjA5OC4wOTcuMjI2LjE0Ni4zNTQuMTQ2LjEyOCAwIC4yNTYtLjA0OS4zNTMtLjE0Ni4xOTYtLjE5Ni4xOTYtLjUxMiAwLS43MDhsLTIuNjQ2LTIuNjQ2eiIgZmlsbC1ydWxlPSJldmVub2RkIi8+PC9zdmc+"
    readonly property string numberInputUpDownArrowImage: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTQiIGhlaWdodD0iMTQiIHZpZXdCb3g9IjAgMCAxNCAxNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEzLjQ0NzQgOS43NzYzOEMxMy40MTggOS43MTc2MyAxMy4zNzc0IDkuNjY1MjUgMTMuMzI3OCA5LjYyMjIyQzEzLjI3ODIgOS41NzkxOCAxMy4yMjA2IDkuNTQ2MzUgMTMuMTU4MyA5LjUyNTU4QzEzLjA5NiA5LjUwNDgxIDEzLjAzMDIgOS40OTY1MiAxMi45NjQ3IDkuNTAxMThDMTIuODk5MiA5LjUwNTgzIDEyLjgzNTIgOS41MjMzNSAxMi43NzY1IDkuNTUyNzNMNy4wMDAwNCAxMi40NDA5TDEuMjIzNzkgOS41NTI3M0MxLjEwNTE2IDkuNDkzNDEgMC45Njc4MzIgOS40ODM2NSAwLjg0MjAwOSA5LjUyNTU5QzAuNzE2MTg2IDkuNTY3NTIgMC42MTIxNzYgOS42NTc3MyAwLjU1Mjg2MSA5Ljc3NjM1QzAuNDkzNTQ1IDkuODk0OTggMC40ODM3ODIgMTAuMDMyMyAwLjUyNTcyIDEwLjE1ODFDMC41Njc2NTggMTAuMjg0IDAuNjU3ODYxIDEwLjM4OCAwLjc3NjQ4NiAxMC40NDczTDYuNzc2NDkgMTMuNDQ3M0M2Ljg0NTk0IDEzLjQ4MiA2LjkyMjUgMTMuNSA3LjAwMDE0IDEzLjVDNy4wNzc3NyAxMy41IDcuMTU0MzQgMTMuNDgyIDcuMjIzNzkgMTMuNDQ3M0wxMy4yMjM4IDEwLjQ0NzNDMTMuMjgyNSAxMC40MTc5IDEzLjMzNDkgMTAuMzc3MyAxMy4zNzc5IDEwLjMyNzdDMTMuNDIxIDEwLjI3OCAxMy40NTM4IDEwLjIyMDQgMTMuNDc0NiAxMC4xNTgxQzEzLjQ5NTMgMTAuMDk1OCAxMy41MDM2IDEwLjAzMDEgMTMuNDk4OSA5Ljk2NDU2QzEzLjQ5NDMgOS44OTkwNSAxMy40NzY4IDkuODM1MTEgMTMuNDQ3NCA5Ljc3NjM4WiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8cGF0aCBkPSJNMTMuMjIzOSAzLjU1MjcyTDcuMjIzNjkgMC41NTI3MjRDNy4xNTQyNCAwLjUxODA1IDcuMDc3NjggMC41IDcuMDAwMDYgMC41QzYuOTIyNDQgMC41IDYuODQ1ODggMC41MTgwNSA2Ljc3NjQ0IDAuNTUyNzI0TDAuNzc2NDM4IDMuNTUyNzJDMC42NTc4MTMgMy42MTIwMyAwLjU2NzYwOCAzLjcxNjA0IDAuNTI1NjY1IDMuODQxODZDMC41MDQ4OTcgMy45MDQxNSAwLjQ5NjYwNCAzLjk2OTkzIDAuNTAxMjU3IDQuMDM1NDRDMC41MDU5MTEgNC4xMDA5NCAwLjUyMzQyMSA0LjE2NDg5IDAuNTUyNzg4IDQuMjIzNjJDMC41ODIxNTUgNC4yODIzNiAwLjYyMjgwMyA0LjMzNDc0IDAuNjcyNDEzIDQuMzc3NzdDMC43MjIwMjIgNC40MjA3OSAwLjc3OTYyIDQuNDUzNjMgMC44NDE5MTkgNC40NzQ0QzAuOTY3NzM3IDQuNTE2MzQgMS4xMDUwNiA0LjUwNjU4IDEuMjIzNjkgNC40NDcyN0w3LjAwMDA5IDEuNTU5MDdMMTIuNzc2NyA0LjQ0NzI3QzEyLjg5NTMgNC41MDY1OCAxMy4wMzI2IDQuNTE2MzQgMTMuMTU4NSA0LjQ3NDRDMTMuMjIwOCA0LjQ1MzYzIDEzLjI3ODQgNC40MjA3OSAxMy4zMjggNC4zNzc3N0MxMy4zNzc2IDQuMzM0NzQgMTMuNDE4MiA0LjI4MjM2IDEzLjQ0NzYgNC4yMjM2MkMxMy40NzcgNC4xNjQ4OSAxMy40OTQ1IDQuMTAwOTQgMTMuNDk5MSA0LjAzNTQ0QzEzLjUwMzggMy45Njk5MyAxMy40OTU1IDMuOTA0MTUgMTMuNDc0NyAzLjg0MTg2QzEzLjQ1MzkgMy43Nzk1NiAxMy40MjExIDMuNzIxOTYgMTMuMzc4MSAzLjY3MjM1QzEzLjMzNTEgMy42MjI3NCAxMy4yODI3IDMuNTgyMDkgMTMuMjIzOSAzLjU1MjcyWiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8L3N2Zz4K"
}
