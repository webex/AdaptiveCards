import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15

/* currently Handling only for RendererQml::CheckBoxType::Toggle type */
CheckBox {

        readonly property string valueOn: _cbValueOn
        readonly property string valueOff:_cbValueOff
        property string value: checked ? valueOn : valueOff
        width: parent.width
        text: _cbText
        font.pixelSize: CardConstants.toggleButtonConstants.pixelSize
        indicator:Rectangle{}
        Keys.onReturnPressed:onButtonClicked()
        property var indicatorItem:_input_toggle_inputToggle_button
        contentItem:RowLayout{
            height: CardConstants.toggleButtonConstants.rowHeight
            width:_input_toggle_inputToggle.width
            spacing: CardConstants.toggleButtonConstants.rowSpacing
            Rectangle{
                id:_input_toggle_inputToggle_button
                width: CardConstants.toggleButtonConstants.radioButtonOuterCircleSize
                height: CardConstants.toggleButtonConstants.radioButtonOuterCircleSize
                y: CardConstants.toggleButtonConstants.indicatorTopPadding
                radius: CardConstants.toggleButtonConstants.checkBoxBorderRadius
                border.width:parent.checked ? 0 : CardConstants.toggleButtonConstants.borderWidth
                Button{
                    anchors.centerIn:parent
                    width:parent.width - 3
                    height:parent.height - 3
                    verticalPadding:0
                    horizontalPadding:0
                    enabled:false
                    background:Rectangle{color:'transparent'}
                    icon.width:width
                    icon.height:height
                    icon.color: CardConstants.toggleButtonConstants.checkBoxIconColorOnChecked
                    icon.source:"data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+YWxlcnRzLWFuZC1ub3RpZmljYXRpb25zL2NoZWNrXzEyX3c8L3RpdGxlPjxwYXRoIGQ9Ik00LjUwMjQgOS41Yy0uMTMzIDAtLjI2LS4wNTMtLjM1NC0uMTQ3bC0zLjAwMi0zLjAwN2MtLjE5NS0uMTk2LS4xOTUtLjUxMi4wMDEtLjcwNy4xOTQtLjE5NS41MTEtLjE5Ni43MDcuMDAxbDIuNjQ4IDIuNjUyIDUuNjQyLTUuNjQ2Yy4xOTUtLjE5NS41MTEtLjE5NS43MDcgMCAuMTk1LjE5NS4xOTUuNTEyIDAgLjcwOGwtNS45OTUgNmMtLjA5NC4wOTMtLjIyMS4xNDYtLjM1NC4xNDYiIGZpbGw9IiNGRkYiIGZpbGwtcnVsZT0iZXZlbm9kZCIvPjwvc3ZnPg=="
                    visible:_input_toggle_inputToggle.checked
                }
            }
            TextEdit{
                clip:true
                textFormat:Text.RichText
                horizontalAlignment:Text.AlignLeft
                verticalAlignment:Text.AlignVCenter
                font.pixelSize: CardConstants.toggleButtonConstants.pixelSize
                color: CardConstants.toggleButtonConstants.textColor
                Layout.fillWidth:true
                id:_input_toggle_inputToggle_title
                wrapMode: _cbisWrap ? Text.Wrap : Text.NoWrap
                text: _cbTitle
                onLinkActivated:{_adaptiveCard.buttonClicked("", "Action.OpenUrl", link);console.log(link);}
                property string accessibleText:getText(0, length)
                property string link:""
                activeFocusOnTab:true
                Accessible.name:accessibleText
                readOnly:true
                selectByMouse:true
                selectByKeyboard:true
                selectionColor :CardConstants.cardConstants.textHighlightBackground
                selectedTextColor :color
                Keys.onPressed:{if (event.key === Qt.Key_Tab) {event.accepted = selectLink(this, true);}else if (event.key === Qt.Key_Backtab) {event.accepted = selectLink(this, false);} else if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter || event.key == Qt.Key_Space) { if (link) {linkActivated(link);} event.accepted = true;}}
                onSelectedTextChanged:{if (link) { accessibleText = selectedText + ' has link,' + link + '. To activate press space bar.';}else {accessibleText = ''}}
                onActiveFocusChanged:{if (activeFocus) { textEditFocussed(_input_toggle_inputToggle_title); accessibleText = getText(0,length);}}
                function getSelectedRichText() {return activeFocus ? selectedText : "";}
                function getExternalLinkUnderCursor() {if(!activeFocus) return "";const possibleLinkPosition = selectionEnd > cursorPosition ? cursorPosition + 1 : cursorPosition;let rectangle = positionToRectangle(possibleLinkPosition);let correctedX = (rectangle.x > 0 ? rectangle.x - 1 : 0);return linkAt(correctedX, rectangle.y);}
                MouseArea{
                    anchors.fill:parent
                    hoverEnabled:true
                    preventStealing:true
                    id:_input_toggle_inputToggle_title_mouseArea
                    cursorShape:parent.hoveredLink ? Qt.PointingHandCursor : Qt.IBeamCursor;
                    acceptedButtons:Qt.RightButton | Qt.LeftButton
                    onPressed : {mouse.accepted = false;const mouseGlobal = mapToGlobal(mouseX, mouseY);const posAtMessage = mapToItem(_adaptiveCard, mouse.x, mouse.y);if (mouse.button === Qt.RightButton){openContextMenu(mouseGlobal, _input_toggle_inputToggle_title.selectedText, parent.linkAt(mouse.x, mouse.y));mouse.accepted = true;}else if (mouse.button === Qt.LeftButton){parent.cursorPosition = parent.positionAt(posAtMessage.x, posAtMessage.y);parent.forceActiveFocus();if (!parent.linkAt(mouse.x, mouse.y)) { onButtonClicked();}}}
                    onPositionChanged : {const mouseGlobal = mapToGlobal(mouse.x, mouse.y);if (mouse.buttons & Qt.LeftButton)parent.moveCursorSelection(parent.positionAt(mouse.x, mouse.y));var link = parent.linkAt(mouse.x, mouse.y);_adaptiveCard.showToolTipifNeeded(link, mouseGlobal);if (link){cursorShape = Qt.PointingHandCursor;}else{cursorShape = Qt.IBeamCursor;}mouse.accepted = true;}
                }
                Rectangle{
                    anchors.fill:parent
                    color:"transparent"
                    border.width:parent.activeFocus ? 1 : 0
                    border.color:parent.activeFocus ? CardConstants.toggleButtonConstants.focusRectangleColor : 'transparent'
                }
            }
        }

        visible: _cbIsVisible
        onPressed:_input_toggle_inputToggle.colorChange(_input_toggle_inputToggle, true)
        onReleased:_input_toggle_inputToggle.colorChange(_input_toggle_inputToggle, false)
        onHoveredChanged:_input_toggle_inputToggle.colorChange(_input_toggle_inputToggle, false)
        onCheckedChanged:_input_toggle_inputToggle.colorChange(_input_toggle_inputToggle, false)
        onActiveFocusChanged:{_input_toggle_inputToggle.colorChange(_input_toggle_inputToggle, false);if(activeFocus){Accessible.name = getAccessibleName() + text}}
        Component.onCompleted:{
            _input_toggle_inputToggle.colorChange(_input_toggle_inputToggle, false);}

        function onButtonClicked(){checked = !checked;}
        function getContentText(){ return _input_toggle_inputToggle_title.getText(0, _input_toggle_inputToggle_title.length);}
        function colorChange(item,isPressed){
            if (isPressed) item.indicatorItem.color = item.checked ? CardConstants.toggleButtonConstants.colorOnCheckedAndPressed : CardConstants.toggleButtonConstants.colorOnUncheckedAndPressed;
            else  item.indicatorItem.color = item.hovered ? (item.checked ? CardConstants.toggleButtonConstants.colorOnCheckedAndHovered : CardConstants.toggleButtonConstants.colorOnUncheckedAndHovered) : (item.checked ? CardConstants.toggleButtonConstants.colorOnChecked : CardConstants.toggleButtonConstants.colorOnUnchecked)
            if (isPressed) item.indicatorItem.border.color = item.checked ? CardConstants.toggleButtonConstants.borderColorOnCheckedAndPressed : CardConstants.toggleButtonConstants.borderColorOnUncheckedAndPressed;
            else  item.indicatorItem.border.color = item.hovered ? (item.checked ? CardConstants.toggleButtonConstants.borderColorOnCheckedAndHovered : CardConstants.toggleButtonConstants.borderColorOnUncheckedAndHovered) : (item.checked ? CardConstants.toggleButtonConstants.borderColorOnChecked : CardConstants.toggleButtonConstants.borderColorOnUnchecked)
        }          
}// Chcek Box ends

