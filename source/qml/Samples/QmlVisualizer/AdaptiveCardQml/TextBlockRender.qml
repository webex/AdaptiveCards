import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15

TextEdit {
    id: textBlock

    property var _adaptiveCard
    property var _color
    property int _width: parent.width
    property int _pixelSize
    property bool _visible: true
    property bool _wrapMode: true
    property string _fontWeight: ""
    property string _fontFamily: ""
    property string _text: ""
    property string _horizontalAlignment: ""
    property string _accessibleText: getText(0, length)
    property string _link: ""
    property string _selectionColor: ""

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

    width: _width
    textFormat: Text.RichText
    clip: true
    visible: _visible
    text: _text
    color: _color
    font.pixelSize: _pixelSize
    font.weight: AdaptiveCardUtils.getWeight(_fontWeight, Font)
    horizontalAlignment: AdaptiveCardUtils.getHorizontalAlignment(_horizontalAlignment)
    Component.onCompleted: {
        if (_wrapMode)
            wrapMode = Text.Wrap;

        if (_fontFamily !== "")
            font.family = _fontFamily;

    }
    onLinkActivated: {
        _adaptiveCard.buttonClicked("", "Action.OpenUrl", _link);
    }
    // --start-- Accessibility
    activeFocusOnTab: true
    Accessible.name: _accessibleText
    readOnly: true
    selectByMouse: true
    selectByKeyboard: true
    selectionColor: _selectionColor
    selectedTextColor: color
    Keys.onPressed: {
        if (event.key === Qt.Key_Tab) {
            event.accepted = AdaptiveCardUtils.selectLink(this, true);
        } else if (event.key === Qt.Key_Backtab) {
            event.accepted = AdaptiveCardUtils.selectLink(this, false);
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            if (_link)
                linkActivated(_link);

            event.accepted = true;
        }
    }
    onSelectedTextChanged: {
        if (_link)
            _accessibleText = selectedText + ' has link,' + _link + '. To activate press space bar.';
        else
            _accessibleText = '';
    }
    onActiveFocusChanged: {
        if (activeFocus) {
            _adaptiveCard.textEditFocussed(textBlock.id);
            _accessibleText = getText(0, length);
        }
    }

    // --start-- Mouse area start
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
                _adaptiveCard.openContextMenu(mouseGlobal, parent.selectedText, parent.linkAt(mouse.x, mouse.y));
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
            _link = parent.linkAt(mouse.x, mouse.y);
            _adaptiveCard.showToolTipifNeeded(_link, mouseGlobal);
            if (_link)
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
