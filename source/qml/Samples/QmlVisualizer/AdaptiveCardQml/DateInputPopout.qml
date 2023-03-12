import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import Qt.labs.calendar 1.0
import Qt.labs.qmlmodels 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Popup {
    id: dateInputPopout

    property var dateInputElement
    property var dateInputField
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputDateConstants: CardConstants.inputDateConstants
    property date selectedDate: getSelectedDate()

    function setGlobalDate(date) {
        if (date) {
            dateInputElement._currentDate = date;
            dateInputField.setTextFromDate(date);
            dateInputField.forceActiveFocus();
            dateInputPopout.close();
        }
    }

    function getDateForSR() {
        var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
        var d = selectedDate.getDate();
        var m = months[selectedDate.getMonth()];
        var y = selectedDate.getFullYear();
        monthBodyGridLayout.dateForSR = m + ' ' + d + ' ' + y;
    }

    function getSelectedDate() {
        let date = dateInputElement._currentDate ? dateInputElement._currentDate : AdaptiveCardUtils.getTodayDate();
        if (date <= dateInputElement._minDate)
            date = new Date(dateInputElement._minDate.getFullYear(), dateInputElement._minDate.getMonth(), dateInputElement._minDate.getDate() + 1);

        if (date >= dateInputElement._maxDate)
            date = new Date(dateInputElement._maxDate.getFullYear(), dateInputElement._maxDate.getMonth(), dateInputElement._maxDate.getDate() - 1);

        return date;
    }

    onSelectedDateChanged: {
        getDateForSR();
    }
    y: dateInputField.height + 2
    x: (-inputFieldConstants.clearIconSize - inputDateConstants.dateIconHorizontalPadding)
    width: inputDateConstants.calendarWidth
    height: inputDateConstants.calendarHeight
    bottomInset: 0
    topInset: 0
    rightInset: 0
    leftInset: 0
    onOpened: {
        selectedDate = getSelectedDate();
        monthBodyGridLayout.forceActiveFocus();
    }
    onClosed: {
        dateInputField.forceActiveFocus();
    }

    background: Rectangle {
        radius: inputDateConstants.calendarBorderRadius
        border.color: inputDateConstants.calendarBorderColor
        color: inputDateConstants.calendarBackgroundColor
    }

    contentItem: Rectangle {
        id: datePopoutContentItem

        radius: inputDateConstants.calendarBorderRadius
        color: inputDateConstants.calendarBackgroundColor

        ColumnLayout {
            id: calendarColumnLayout

            anchors.fill: parent

            Rectangle {
                id: monthHeader

                Layout.row: 0
                Layout.column: 1
                Layout.fillWidth: true
                height: inputDateConstants.arrowIconSize
                color: inputDateConstants.calendarBackgroundColor

                RowLayout {
                    id: monthHeaderRowLayout

                    anchors.fill: parent

                    Text {
                        id: calendarViewHeader

                        color: inputFieldConstants.textColor
                        text: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'][monthBodyGridLayout.month] + ' ' + monthBodyGridLayout.year
                        font.pixelSize: inputFieldConstants.pixelSize
                    }

                    RowLayout {
                        id: bottomSaveAndCancelComponentLayout

                        Layout.alignment: Qt.AlignRight
                        spacing: 10

                        Button {
                            id: prevMonthButton

                            width: icon.width
                            padding: 0
                            icon.width: inputDateConstants.arrowIconSize
                            icon.height: inputDateConstants.arrowIconSize
                            focusPolicy: Qt.NoFocus
                            icon.color: inputDateConstants.monthChangeButtonColor
                            height: icon.height
                            Keys.onReturnPressed: onReleased()
                            Accessible.role: Accessible.Button
                            icon.source: CardConstants.calendarLeftArrowIcon
                            Accessible.name: 'Previous Month'
                            Accessible.ignored: true
                            enabled: (monthBodyGridLayout.year > dateInput._minDate.getFullYear() || (monthBodyGridLayout.year === dateInput._minDate.getFullYear() && monthBodyGridLayout.month > dateInput._minDate.getMonth()))
                            onReleased: {
                                prevMonthButton.forceActiveFocus();
                                selectedDate = new Date(selectedDate.getFullYear(), selectedDate.getMonth() - 1, 1);
                            }
                            KeyNavigation.tab: nextMonthButton
                            KeyNavigation.backtab: monthBodyGridLayout

                            background: Rectangle {
                                color: (prevMonthButton.hovered || prevMonthButton.activeFocus) ? inputDateConstants.dateElementColorOnHover : inputDateConstants.calendarBackgroundColor
                                radius: width / 2

                                WCustomFocusItem {
                                    visible: prevMonthButton.activeFocus
                                    designatedParent: parent
                                }

                            }

                        }

                        Button {
                            id: nextMonthButton

                            width: icon.width
                            padding: 0
                            icon.width: inputDateConstants.arrowIconSize
                            icon.height: inputDateConstants.arrowIconSize
                            focusPolicy: Qt.NoFocus
                            icon.color: inputDateConstants.monthChangeButtonColor
                            height: icon.height
                            Keys.onReturnPressed: onReleased()
                            Accessible.role: Accessible.Button
                            icon.source: CardConstants.calendarRightArrowIcon
                            Accessible.name: 'Next Month'
                            Accessible.ignored: true
                            enabled: (monthBodyGridLayout.year < dateInput._maxDate.getFullYear() || (monthBodyGridLayout.year === dateInput._maxDate.getFullYear() && monthBodyGridLayout.month < dateInput._maxDate.getMonth()))
                            onReleased: {
                                nextMonthButton.forceActiveFocus();
                                selectedDate = new Date(selectedDate.getFullYear(), selectedDate.getMonth() + 1, 1);
                            }
                            KeyNavigation.tab: monthBodyGridLayout
                            KeyNavigation.backtab: prevMonthButton

                            background: Rectangle {
                                color: (nextMonthButton.hovered || nextMonthButton.activeFocus) ? inputDateConstants.dateElementColorOnHover : inputDateConstants.calendarBackgroundColor
                                radius: width / 2

                                WCustomFocusItem {
                                    visible: nextMonthButton.activeFocus
                                    designatedParent: parent
                                }

                            }

                        }

                    }

                }

            }

            DayOfWeekRow {
                id: weekHeader

                Layout.row: 1
                Layout.column: 1
                Layout.fillWidth: true
                implicitHeight: inputDateConstants.dateElementSize

                delegate: Text {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: model.shortName
                    font.weight: Font.Medium
                    font.pixelSize: inputDateConstants.calendarDateTextSize
                    color: inputDateConstants.dateElementTextColorNormal
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

            }

            GridLayout {
                Layout.preferredWidth: datePopoutContentItem.width
                Layout.preferredHeight: datePopoutContentItem.width
                Layout.alignment: Qt.AlignHCenter
                columns: 1
                rows: 1

                MonthGrid {
                    id: monthBodyGridLayout

                    property string accessibilityPrefix: 'Date Picker. The current date is'
                    property string dateForSR: ""

                    year: selectedDate.getFullYear()
                    month: selectedDate.getMonth()
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 1
                    Keys.onPressed: {
                        if (event.key === Qt.Key_Right) {
                            let tempDate = new Date(selectedDate.getFullYear(), selectedDate.getMonth(), selectedDate.getDate() + 1);
                            selectedDate = AdaptiveCardUtils.isDateinRange(tempDate, dateInput._minDate, dateInput._maxDate) ? tempDate : dateInput._maxDate;
                        }
                        if (event.key === Qt.Key_Left) {
                            let tempDate = new Date(selectedDate.getFullYear(), selectedDate.getMonth(), selectedDate.getDate() - 1);
                            selectedDate = AdaptiveCardUtils.isDateinRange(tempDate, dateInput._minDate, dateInput._maxDate) ? tempDate : dateInput._minDate;
                        }
                        if (event.key === Qt.Key_Up) {
                            let tempDate = new Date(selectedDate.getFullYear(), selectedDate.getMonth(), selectedDate.getDate() - 7);
                            selectedDate = AdaptiveCardUtils.isDateinRange(tempDate, dateInput._minDate, dateInput._maxDate) ? tempDate : dateInput._minDate;
                        }
                        if (event.key === Qt.Key_Down) {
                            let tempDate = new Date(selectedDate.getFullYear(), selectedDate.getMonth(), selectedDate.getDate() + 7);
                            selectedDate = AdaptiveCardUtils.isDateinRange(tempDate, dateInput._minDate, dateInput._maxDate) ? tempDate : dateInput._maxDate;
                        }
                        monthBodyGridLayout.accessibilityPrefix = '';
                        event.accepted = true;
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onWheel: {
                            if (wheel.angleDelta.y > 0 && prevMonthButton.enabled)
                                selectedDate = new Date(selectedDate.getFullYear(), selectedDate.getMonth() - 1, 1);
                            else if (wheel.angleDelta.y < 0 && nextMonthButton.enabled)
                                selectedDate = new Date(selectedDate.getFullYear(), selectedDate.getMonth() + 1, 1);
                            else
                                wheel.accepted = false;
                        }
                    }

                    delegate: Button {
                        id: dateButton

                        property bool isCurrentSelectedDate: AdaptiveCardUtils.datesAreEqual(model.date, selectedDate)
                        property bool isInThisMonth: model.date.getMonth() === monthBodyGridLayout.month
                        property int date: model.date.getDate()

                        width: dateButtonBg.width
                        height: dateButtonBg.height
                        enabled: AdaptiveCardUtils.isDateinRange(model.date, dateInput._minDate, dateInput._maxDate)
                        focus: isCurrentSelectedDate ? true : false
                        focusPolicy: isCurrentSelectedDate ? Qt.StrongFocus : Qt.NoFocus
                        KeyNavigation.tab: prevMonthButton
                        KeyNavigation.backtab: nextMonthButton
                        onReleased: setGlobalDate(model.date)
                        Keys.onReturnPressed: setGlobalDate(model.date)
                        Accessible.name: monthBodyGridLayout.accessibilityPrefix + monthBodyGridLayout.dateForSR
                        Accessible.role: Accessible.NoRole
                        Accessible.ignored: !activeFocus

                        background: Rectangle {
                            id: dateButtonBg

                            width: inputDateConstants.dateElementSize
                            height: inputDateConstants.dateElementSize
                            color: isCurrentSelectedDate ? inputDateConstants.dateElementColorOnFocus : (dateButton.hovered) ? inputDateConstants.dateElementColorOnHover : "transparent"
                            radius: 0.5 * width
                            border.color: inputDateConstants.calendarBorderColor
                            border.width: model.today

                            Text {
                                id: dateButtonText

                                anchors.centerIn: parent
                                font.pixelSize: inputDateConstants.calendarDateTextSize
                                color: isCurrentSelectedDate ? "white" : dateButton.enabled ? inputDateConstants.dateElementTextColorNormal : inputDateConstants.notAvailabledateElementTextColor
                                text: model.day
                                font.weight: day < 0 ? Font.Medium : model.date.getMonth() === month ? Font.Normal : Font.Light
                            }

                            WCustomFocusItem {
                                visible: monthBodyGridLayout.activeFocus && isCurrentSelectedDate
                                designatedParent: dateButtonBg
                                isRectangle: false
                            }

                        }

                    }

                }

            }

        }

    }

}
