import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

Popup {
    id: timeInputPopout
    
    property var timeInputField
    property var timeInputElement
    property int selectedHours
    property int selectedMinutes
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputTimeConstants: CardConstants.inputTimeConstants
    
    function updateTime() {
        selectedMinutes = timeInputElement.currMinute = timeMinutes.currentIndex;
        selectedHours = timeHours.currentIndex;
        if (timeInputModel.is12Hour) {
            if (timeHours.currentIndex === 11 && timeAMPM.currentIndex === 0)
                selectedHours = 0;
            else if (timeHours.currentIndex === 11 && timeAMPM.currentIndex === 1)
                selectedHours = 12;
            else
                selectedHours = (timeHours.currentIndex + 1) + (timeAMPM.currentIndex === 0 ? 0 : 12);
        }
        timeInputElement.currHour = selectedHours;
        timeInputField.text = AdaptiveCardUtils.getTimeFieldString(timeInputElement.currHour, timeInputElement.currMinute, timeInputElement._is12Hour);
    } 
    
    width: contentWidth + (2 * inputFieldConstants.clearIconHorizontalPadding)
    height: inputTimeConstants.timePickerHeight
    y: timeInputField.height + inputTimeConstants.timePickerSpacing
    x: -inputFieldConstants.clearIconSize - inputFieldConstants.clearIconHorizontalPadding
    onOpened: {
        timeHours.forceActiveFocus();
        if (timeInputElement.currHour !== -1 && timeInputElement.currMinute !== -1) {
            selectedHours = timeInputElement.currHour;
            selectedMinutes = timeInputElement.currMinute;
        } else {
            let date = new Date();
            selectedHours = date.getHours();
            selectedMinutes = date.getMinutes();
        }
        if (timeInputElement.timeInputModel.is12Hour) {
            timeHours.currentIndex = ((selectedHours - 1) % 12);
            timeAMPM.currentIndex = selectedHours < 12 ? 0 : 1;
        } else {
            timeHours.currentIndex = selectedHours;
        }
        timeMinutes.currentIndex = selectedMinutes;
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
                model: timeInputModel.is12Hour ? 12 : 24
            }
            
            TimePickerListView {
                id: timeMinutes
                
                listType: "minutes"
                model: 60
            }
            
            TimePickerListView {
                id: timeAMPM
                
                listType: "AMPM"
                visible: false
                
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