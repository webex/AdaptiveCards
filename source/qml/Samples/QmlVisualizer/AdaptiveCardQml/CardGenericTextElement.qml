import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import AdaptiveCards 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

TextEdit {
    id: textElement

    property string accessibleText: getText(0, length)
    property string link: ""

    signal onTextElementClicked()

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
    font.pixelSize: CardConstants.toggleButtonConstants.pixelSize
    color: CardConstants.toggleButtonConstants.textColor
    wrapMode: Text.Wrap
    text: ""
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
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            if (link)
                linkActivated(link);

            event.accepted = true;
        } else if (event.key === Qt.Key_Up || event.key === Qt.Key_Down) {
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
            textEditFocussed(textElement);
            accessibleText = getText(0, length);
        }
    }

    MouseArea {
        id: textElementMouseArea

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
                openContextMenu(mouseGlobal, textElement.selectedText, parent.linkAt(mouse.x, mouse.y));
                mouse.accepted = true;
            } else if (mouse.button === Qt.LeftButton) {
                parent.cursorPosition = parent.positionAt(posAtMessage.x, posAtMessage.y);
                parent.forceActiveFocus();
                if (!parent.linkAt(mouse.x, mouse.y))
                    onTextElementClicked();

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

    Rectangle{
        anchors.fill: parent
        color: 'transparent'
        border.width : parent.activeFocus ? 1 : 0
        border.color : parent.activeFocus ? 'black' : 'transparent'
    }

}
