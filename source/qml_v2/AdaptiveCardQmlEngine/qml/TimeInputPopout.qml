import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

Popup {
    id: timeInputPopout
    
    property var timeInputField
    property var timeInputElement
    property bool is12Hour: timeInputElement.is12Hour
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputTimeConstants: CardConstants.inputTimeConstants
    
    
    width: contentWidth + (2 * inputFieldConstants.clearIconHorizontalPadding)
    height: inputTimeConstants.timePickerHeight
    y: timeInputField.height + inputTimeConstants.timePickerSpacing
    x: -inputFieldConstants.clearIconSize - inputFieldConstants.clearIconHorizontalPadding
    onOpened: {
        timeHours.forceActiveFocus();
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
                model: is12Hour ? 12 : 24
            }
            
            TimePickerListView {
                id: timeMinutes
                
                listType: "minutes"
                model: 60
            }
            
            TimePickerListView {
                id: timeAMPM
                
                listType: "AMPM"
                visible: is12Hour
                
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
