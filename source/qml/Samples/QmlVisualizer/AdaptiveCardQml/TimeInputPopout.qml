import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import AdaptiveCards 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Popup {
    id: timeInputPopout

    property var timeInputField
    property var timeInputElement
    property int _selectedHours
    property int _selectedMinutes
    property bool _is12Hour: timeInputElement._is12Hour
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputTimeConstants: CardConstants.inputTimeConstants

    function updateTime() {
        _selectedMinutes = timeInputElement._currMinute = timeMinutes.currentIndex;
        _selectedHours = timeHours.currentIndex;
        if (_is12Hour) {
            if (timeHours.currentIndex === 11 && timeAMPM.currentIndex === 0)
                _selectedHours = 0;
            else if (timeHours.currentIndex === 11 && timeAMPM.currentIndex === 1)
                _selectedHours = 12;
            else
                _selectedHours = (timeHours.currentIndex + 1) + (timeAMPM.currentIndex === 0 ? 0 : 12);
        }
        timeInputElement._currHour = _selectedHours;
        timeInputField.text = AdaptiveCardUtils.getTimeFieldString(timeInputElement._currHour, timeInputElement._currMinute, timeInputElement._is12Hour);
    }

    width: contentWidth + (2 * inputFieldConstants.clearIconHorizontalPadding)
    height: inputTimeConstants.timePickerHeight
    y: timeInputField.height + inputTimeConstants.timePickerSpacing
    x: -inputFieldConstants.clearIconSize - inputFieldConstants.clearIconHorizontalPadding
    onOpened: {
        timeHours.forceActiveFocus();
        if (timeInputElement._currHour !== -1 && timeInputElement._currMinute !== -1) {
            _selectedHours = timeInputElement._currHour;
            _selectedMinutes = timeInputElement._currMinute;
        } else {
            let date = new Date();
            _selectedHours = date.getHours();
            _selectedMinutes = date.getMinutes();
        }
        if (timeInputElement._is12Hour) {
            timeHours.currentIndex = ((_selectedHours - 1) % 12);
            timeAMPM.currentIndex = _selectedHours < 12 ? 0 : 1;
        } else {
            timeHours.currentIndex = _selectedHours;
        }
        timeMinutes.currentIndex = _selectedMinutes;
    }
    onClosed: {
        updateTime();
        timeInputField.forceActiveFocus();
    }

    background: Rectangle {
        anchors.fill: parent
        border.color: inputTimeConstants.timePickerBorderColor
        radius: inputTimeConstants.timePickerBorderRadius
        color: inputTimeConstants.timePickerBackgroundColor
    }

    contentItem: Rectangle {
        id: timePickerRectangle

        height: parent.height
        implicitWidth: timePickerRLayout.implicitWidth
        color: 'transparent'
        Accessible.name: "Time Picker"

        RowLayout {
            id: timePickerRLayout

            height: parent.height
            spacing: inputTimeConstants.timePickerMargins

            TimePickerListView {
                id: timeHours

                listType: "hours"
                model: _is12Hour ? 12 : 24
            }

            TimePickerListView {
                id: timeMinutes

                listType: "minutes"
                model: 60
            }

            TimePickerListView {
                id: timeAMPM

                listType: "AMPM"
                visible: _is12Hour

                model: ListModel {
                    ListElement {
                        name: "AM"
                    }

                    ListElement {
                        name: "PM"
                    }

                }

            }

        }

    }

}
