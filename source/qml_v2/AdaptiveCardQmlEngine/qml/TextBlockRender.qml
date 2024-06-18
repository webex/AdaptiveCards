import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

TextEdit {
    id: "textBlock"    
    
    property var textBlockModel:  model.textBlockRole
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

    width: implicitWidth
    height: implicitHeight

    padding: 0
    clip: true
    
    visible: textBlockModel.isVisible
    text: textBlockModel.text
    textFormat: Text.RichText

    wrapMode: textBlockModel.textWrap ? Text.Wrap : Text.NoWrap 
    
    horizontalAlignment : textBlockModel.horizontalAlignment === 0 ? Text.AlignLeft :
                          textBlockModel.horizontalAlignment === 1 ? Text.AlignHCenter : Text.AlignRight  

    color: textBlockModel.color

    font.pixelSize: textBlockModel.fontPixelSize
    font.weight: textBlockModel.fontWeight === "extraLight" ? Font.ExtraLight :
				 textBlockModel.fontWeight === "bold" ? Font.Bold : Font.Normal
    font.family: textBlockModel.fontFamily

    // Accessibility properties -----
    activeFocusOnTab: textBlockModel.isInTabOrder
    Accessible.name: text
    Accessible.role: Accessible.StaticText
    readOnly: true
    selectByMouse: true
    selectByKeyboard: true
    selectionColor: textBlockModel.selectionColor

    Keys.onPressed: {
        if (event.key === Qt.Key_Tab) {
            event.accepted = AdaptiveCardUtils.selectLink(this, true);
        } else if (event.key === Qt.Key_Backtab) {
            event.accepted = AdaptiveCardUtils.selectLink(this, false);
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            if (link)
                linkActivated(link);

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
                // adaptiveCard.textEditFocussed(textBlock.id);
                // accessibleText = getText(0, length);
        }
    }

    // MouseArea to handle click events
    MouseArea {
        id: mouseArea

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
                //_adaptiveCard.openContextMenu(mouseGlobal, parent.selectedText, parent.linkAt(mouse.x, mouse.y));
                mouse.accepted = true;
            } else if (mouse.button === Qt.LeftButton) {
                parent.cursorPosition = parent.positionAt(posAtMessage.x, posAtMessage.y);
                parent.forceActiveFocus();
            }
        }

        onPositionChanged: {
            if (mouse.buttons & Qt.LeftButton)
                parent.moveCursorSelection(parent.positionAt(mouse.x, mouse.y));

            const mouseGlobal = mapToGlobal(mouse.x, mouse.y);
            link = parent.linkAt(mouse.x, mouse.y);
            //_adaptiveCard.showToolTipifNeeded(link, mouseGlobal);
            if (link)
                cursorShape = Qt.PointingHandCursor;
            else
                cursorShape = Qt.IBeamCursor;
            mouse.accepted = true;
        }
    }

    WCustomFocusItem {
        isRectangle: true
    }
}