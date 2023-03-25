import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

ListView {
    id: timePickerListView

    property string listType
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputTimeConstants: CardConstants.inputTimeConstants
    property var listViewItem: timePickerListView.view

    width: inputTimeConstants.timePickerListViewWidth
    height: parent.height - inputTimeConstants.timePickerColumnSpacing
    spacing: inputTimeConstants.timePickerSpacing
    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.StopAtBounds
    clip: true
    Keys.onReturnPressed: timeInputPopout.close()
    activeFocusOnTab: true
    Keys.onPressed: {
        if (event.key === Qt.Key_Right)
            nextItemInFocusChain().forceActiveFocus();
        else if (event.key === Qt.Key_Left)
            nextItemInFocusChain(false).forceActiveFocus();
        else if (event.key === Qt.Key_Tab)
            event.accepted = true;
    }
    topMargin: inputTimeConstants.timePickerListViewMargins
    bottomMargin: inputTimeConstants.timePickerListViewMargins
    leftMargin: inputTimeConstants.timePickerListViewMargins
    rightMargin: inputTimeConstants.timePickerListViewMargins

    delegate: Rectangle {
        id: listViewDelegateRect

        function getText() {
            switch (listType) {
            case "hours":
                return String(_is12Hour ? index + 1 : index).padStart(2, '0');
            case "minutes":
                return String(index).padStart(2, '0');
            case "AMPM":
                return model.name;
            }
            return '';
        }

        width: inputTimeConstants.timePickerHoursAndMinutesTagWidth
        height: inputTimeConstants.timePickerElementHeight
        radius: inputTimeConstants.timePickerElementRadius
        color: timePickerListView.currentIndex == index ? inputTimeConstants.timePickerElementColorOnFocus : timePickerListViewmouseArea.containsMouse ? inputTimeConstants.timePickerElementColorOnHover : inputTimeConstants.timePickerElementColorNormal
        Accessible.name: listType + ' selector ' + timePickerDelegateText.text
        Accessible.role: Accessible.StaticText
        Accessible.ignored: true

        MouseArea {
            id: timePickerListViewmouseArea

            anchors.fill: parent
            enabled: true
            hoverEnabled: true
            onClicked: {
                forceActiveFocus();
                timePickerListView.currentIndex = index;
                updateTime();
            }
        }

        Text {
            id: timePickerDelegateText

            text: getText()
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: inputFieldConstants.pixelSize
            color: index === timePickerListView.currentIndex ? inputTimeConstants.timePickerElementTextColorHighlighted : inputTimeConstants.timePickerElementTextColorNormal
        }

        WCustomFocusItem {
            visible: listViewDelegateRect.activeFocus
            designatedParent: parent
            isRectangle: true
        }

    }

}
