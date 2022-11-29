import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

RadioButton {
    id: customRadioButton

    signal selectionChanged()

    property var _consumer
    property var _adaptiveCard
    property string _rbValueOn : ""
    property bool _rbIsChecked
    property bool _rbisWrap
    property string _rbTitle
    property string value : checked ? _rbValueOn : ""
    property var indicatorItem: customRadioButtonOuterRectancle
    property var toggleButtonConstants : CardConstants.toggleButtonConstants

    function onButtonClicked() {
        checked = !checked;
    }

    function getContentText() {
        return customRadioButtonTitle.getText(0, customRadioButtonTitle.length);
    }

    function colorChange(item, isPressed) {
        if (isPressed)
            item.indicatorItem.color = item.checked ? toggleButtonConstants.colorOnCheckedAndPressed : toggleButtonConstants.colorOnUncheckedAndPressed;
        else
            item.indicatorItem.color = item.hovered ? (item.checked ? toggleButtonConstants.colorOnCheckedAndHovered : toggleButtonConstants.colorOnUncheckedAndHovered) : (item.checked ? toggleButtonConstants.colorOnChecked : toggleButtonConstants.colorOnUnchecked);
        if (isPressed)
            item.indicatorItem.border.color = item.checked ? toggleButtonConstants.borderColorOnCheckedAndPressed : toggleButtonConstants.borderColorOnUncheckedAndPressed;
        else
            item.indicatorItem.border.color = item.hovered ? (item.checked ? toggleButtonConstants.borderColorOnCheckedAndHovered : toggleButtonConstants.borderColorOnUncheckedAndHovered) : (item.checked ? toggleButtonConstants.borderColorOnChecked : toggleButtonConstants.borderColorOnUnchecked);
    }

    checked : _rbIsChecked
    activeFocusOnTab: false
    Layout.maximumWidth : parent.parent.parent.width
    font.pixelSize: toggleButtonConstants.pixelSize
    Keys.onReturnPressed: onButtonClicked()
    onPressed: customRadioButton.colorChange(customRadioButton, true)
    onReleased: customRadioButton.colorChange(customRadioButton, false)
    onHoveredChanged: customRadioButton.colorChange(customRadioButton, false)

    onCheckedChanged: {
        customRadioButton.colorChange(customRadioButton, false)
        value = checked ? _rbValueOn : ""
        selectionChanged()
    }

    onActiveFocusChanged: {
        customRadioButton.colorChange(customRadioButton, false);
        if (activeFocus){
            //checked = true
            Accessible.name = _consumer.getAccessibleName() + getContentText();
        }

    }

    Component.onCompleted: {
        customRadioButton.colorChange(customRadioButton, false);
    }

    indicator: Rectangle {
    }

    contentItem: RowLayout {
        height: toggleButtonConstants.rowHeight
        width: customRadioButton.width
        spacing: toggleButtonConstants.rowSpacing

        Rectangle{
            id:customRadioButtonOuterRectancle
            width: toggleButtonConstants.radioButtonOuterCircleSize
            height: toggleButtonConstants.radioButtonOuterCircleSize
            y: toggleButtonConstants.indicatorTopPadding
            radius:height/2
            border.width: parent.checked ? 0 : toggleButtonConstants.borderWidth
            Rectangle{
                width:toggleButtonConstants.radioButtonInnerCircleSize
                height:toggleButtonConstants.radioButtonInnerCircleSize
                x:(parent.width - width)/2
                y:(parent.height - height)/2
                radius:height/2
                color:customRadioButton.checked ? toggleButtonConstants.radioButtonInnerCircleColorOnChecked : 'transparent'
                visible:customRadioButton.checked
            }
        }

        TextEdit {
            id: customRadioButtonTitle

            property string accessibleText: getText(0, length)
            property string link: ""

            function getSelectedRichText() {
                return activeFocus ? selectedText : "";
            }

            function getExternalLinkUnderCursor() {
                if (!activeFocus)
                    return "";

                const possibleLinkPosition = selectionEnd > cursorPosition ? cursorPosition + 1 : cursorPosition;
                let rectangle = positionToRectangle(possibleLinkPosition);
                let correctedX = (rectangle.x > 0 ? rectangle.x - 1 : 0);
                return linkAt(correctedX, rectangle.y);
            }

            clip: true
            textFormat: Text.RichText
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: toggleButtonConstants.pixelSize
            color: toggleButtonConstants.textColor
            Layout.fillWidth: true
            wrapMode: _rbisWrap ? Text.Wrap : Text.NoWrap
            text: _rbTitle
            onLinkActivated: {
                _adaptiveCard.buttonClicked("", "Action.OpenUrl", link);
                console.log(link);
            }
            activeFocusOnTab: true
            Accessible.name: accessibleText
            readOnly: true
            selectByMouse: true
            selectByKeyboard: true
            selectionColor: CardConstants.cardConstants.textHighlightBackground
            selectedTextColor: color
            Keys.onPressed: {
                if (event.key === Qt.Key_Tab) {
                    event.accepted = selectLink(this, true);
                } else if (event.key === Qt.Key_Backtab) {
                    event.accepted = selectLink(this, false);
                } else if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter || event.key == Qt.Key_Space) {
                    if (link)
                        linkActivated(link);

                    event.accepted = true;
                } else if (event.key == Qt.Key_Up || event.key == Qt.Key_Down) {
                    event.accepted = true;
                }
            }
            onSelectedTextChanged: {
                if (link)
                    accessibleText = selectedText + ' has link,' + link + '. To activate press space bar.';
                else
                    accessibleText = '';
            }
            onActiveFocusChanged: {
                if (activeFocus) {
                    textEditFocussed(customRadioButtonTitle);
                    accessibleText = getText(0, length);
                }
            }

            MouseArea {
                id: customRadioButtonTitleMouseArea

                anchors.fill: parent
                hoverEnabled: true
                preventStealing: true
                cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.IBeamCursor
                acceptedButtons: Qt.RightButton | Qt.LeftButton
                onPressed: {
                    mouse.accepted = false;
                    const mouseGlobal = mapToGlobal(mouseX, mouseY);
                    const posAtMessage = mapToItem(_adaptiveCard, mouse.x, mouse.y);
                    if (mouse.button === Qt.RightButton) {
                        openContextMenu(mouseGlobal, customRadioButtonTitle.selectedText, parent.linkAt(mouse.x, mouse.y));
                        mouse.accepted = true;
                    } else if (mouse.button === Qt.LeftButton) {
                        parent.cursorPosition = parent.positionAt(posAtMessage.x, posAtMessage.y);
                        parent.forceActiveFocus();
                        if (!parent.linkAt(mouse.x, mouse.y))
                            onButtonClicked();

                    }
                }
                onPositionChanged: {
                    const mouseGlobal = mapToGlobal(mouse.x, mouse.y);
                    if (mouse.buttons & Qt.LeftButton)
                        parent.moveCursorSelection(parent.positionAt(mouse.x, mouse.y));

                    var link = parent.linkAt(mouse.x, mouse.y);
                    _adaptiveCard.showToolTipifNeeded(link, mouseGlobal);
                    if (link)
                        cursorShape = Qt.PointingHandCursor;
                    else
                        cursorShape = Qt.IBeamCursor;
                    mouse.accepted = true;
                }
            }

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.width: parent.activeFocus ? 1 : 0
                border.color: parent.activeFocus ? toggleButtonConstants.focusRectangleColor : 'transparent'
            }

        }

    }

}