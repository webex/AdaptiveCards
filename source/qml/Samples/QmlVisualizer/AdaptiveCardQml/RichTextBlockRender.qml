import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15

TextEdit {
    id: richTextBlock

    property var _adaptiveCard
    property int _width: parent.width
    property bool _visible: true
    property string _text: ""
    property string _horizontalAlignment: ""
    property string _accessibleText: getText(0, length)
    property string _link: ""
    property string _selectionColor: ""
    property string _paramStr: ""
    property bool _is1_3Enabled: false
    property var _toggleVisibilityTarget: null

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
    visible: _visible
    text: _text
    wrapMode: Text.Wrap
    horizontalAlignment: AdaptiveCardUtils.getHorizontalAlignment(_horizontalAlignment)
    onLinkActivated: {
        if (_link.startsWith('textRunToggleVisibility_')) {
            AdaptiveCardUtils.handleToggleVisibilityAction(_toggleVisibilityTarget[_link]);
            return ;
        } else if (_link.startsWith('Action.Submit')) {
            const hasAssociatedInputs = _link.endsWith("auto");
            AdaptiveCardUtils.handleSubmitAction(_paramStr, _adaptiveCard, hasAssociatedInputs);
            return ;
        } else {
            _adaptiveCard.buttonClicked("", "Action.OpenUrl", _link);
            return ;
        }
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
        if (_link) {
            var selectActionText = '';
            if (_link.startsWith('textRunToggleVisibility_'))
                selectActionText = 'Action.ToggleVisibility';
            else if (_link === 'Action.Submit')
                selectActionText = 'Action.Submit';
            else
                selectActionText = _link;
            _accessibleText = selectedText + ' has link,' + selectActionText + '. To activate press space bar.';
        } else {
            _accessibleText = '';
        }
    }
    onActiveFocusChanged: {
        if (activeFocus) {
            _adaptiveCard.textEditFocussed(richTextBlock.id);
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
            if (_link.startsWith('textRunToggleVisibility_'))
                _adaptiveCard.showToolTipifNeeded('Action.ToggleVisibility', mouseGlobal);
            else if (_link.startsWith('Action.Submit'))
                _adaptiveCard.showToolTipifNeeded('Action.Submit', mouseGlobal);
            else
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
