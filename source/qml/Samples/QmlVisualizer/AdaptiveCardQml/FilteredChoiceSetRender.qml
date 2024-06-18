import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import AdaptiveCards 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3


ComboBox {
    id: comboBox
    
    property var _adaptiveCard
    property var _consumer
    property var _model
    property int _currentIndex
    property string _mEscapedPlaceholderString
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var comboBoxConstants: CardConstants.comboBoxConstants
    property var cardConstants: CardConstants.cardConstants
    property var _filteredModel: _model
    property int choiceWidth: 0
    
    
    onActivated: selectOption(currentText)
    
    
    signal selectionChanged()
    
    function colorChange(isPressed) {
        if (isPressed)
            background.color = inputFieldConstants.backgroundColorOnPressed;
        else
            background.color = activeFocus ? inputFieldConstants.backgroundColorOnPressed : hovered ? inputFieldConstants.backgroundColorOnHovered : inputFieldConstants.backgroundColorNormal;
    }
    
    function getAccessibleName() {
        let accessibleName = _consumer.getAccessibleName() + ' ';
        if (comboBox.currentIndex !== -1)
            accessibleName += (comboBox.displayText + '. ');
        else if (_mEscapedPlaceholderString)
            accessibleName += _mEscapedPlaceholderString + '. ';
        else
            accessibleName += 'Choice Set';
        return accessibleName;
    }
    
    function openPopout() {
        setFocusBackOnClose(comboBox);
        comboBox.popup.open();
    }
    
    function selectOption(option) {
        textField.text = option
        comboBox.popup.close();       
    }
    
    function filterOptions() {
        var filterText = textField.text.toLowerCase();
        _filteredModel = _model.filter(function(entry) {
            return entry.text.toLowerCase().includes(filterText);
        });
    }
    
    textRole: 'text'
    valueRole: 'valueOn'
    width: parent.width
    height: inputFieldConstants.height
    model: _filteredModel
    currentIndex: _currentIndex
    displayText: currentIndex === -1 ? _mEscapedPlaceholderString : currentText
    onPressedChanged: {
        if (pressed)
            colorChange(true);
        else
            colorChange(false);
    }
    onActiveFocusChanged: {
        colorChange(false);
        if (activeFocus)
            Accessible.name = getAccessibleName();        
    }
    onHoveredChanged: {
        colorChange(false);
        if (hovered)
            _adaptiveCard.showToolTipOnElement(hovered, displayText, comboBox);       
    }
    onCurrentValueChanged: {
        Accessible.name = displayText;
        selectionChanged();
    }
    Keys.onReturnPressed: openPopout()
    Keys.onSpacePressed: openPopout()
    
    WCustomFocusItem {
        isRectangle: true
    }
    
    indicator: Button {
        id: comboboxArrowIcon
        width: comboBoxConstants.indicatorWidth
        horizontalPadding: comboBoxConstants.arrowIconHorizontalPadding
        verticalPadding: comboBoxConstants.arrowIconVerticalPadding
        icon.width: comboBoxConstants.arrowIconWidth
        icon.height: comboBoxConstants.arrowIconHeight
        focusPolicy: Qt.NoFocus
        icon.color: comboBoxConstants.arrowIconColor
        icon.source: textField.text.length > 0 ? "data:image/svg+xml;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACAAgMAAAC+UIlYAAAAA3NCSVQICAjb4U/gAAAACXBIWXMAAAoNAAAKDQFKsqGvAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAAAxQTFRF////AAAAAAAAAAAA+IwCTQAAAAN0Uk5TAHCPqE4jmQAAAe9JREFUWMOd2MHRqzAMRlGFTRYUkRJogc5CZ7RACRSRBRvyvQXDk20pvjN/VrGGmBMDloSZmdljsfAZ5mLw3OMB41YMXkc8YPoUg/c3HrCe/v0hBcQgOeIpBcQoOeIlBcQkOeItBcQqnQUhIAbJEU8pIEbJES8pICbJEW8pIFbpP+IhBcRwxWYnNIjxim1OaBDTFfs4oUGsV+wsCBViuGOzEyrEeMc2J1SI6Y59nFAh1jt2FoQCMXhsdkKBGD22OaFATB77OKFArB47y8GNKAj6ltPdiIKgoxm1BO3NfC1Bi0VE+5OAaE8aEO0vAiKcswlEdTNl/N9NJK5cM2ey9lUoWbh60mTpa0Ry8WpEQqgRCaFGJIQakRBqREb4gfia9RGHWR+xm/URS7Jh/CKkiMOsj9jN+ogl2Th/ExLEYdZH7GZ9xJIkkB4hIGKeHPuEgEhy9donNIgkVdeIJNnXiOUvB+ApEEl/ExcKlxovFl1uvGHwlsOblm57fHDw0cOHlx5/3EBwC8JNjLZB3EhxK8bNnNIBJhRMSZjUKC1iYsXUjMmdygMsMLBEwSKHyiQstLBUw2IPy0UsOLFkxaIXy2YsvLl0x+If2wdsQLiFwSYI2yhsxLiVw2YQ20lsSLmlxaYY22pszLm1x5cDndcL/wA9JaEl0OukTwAAAABJRU5ErkJggg==" : "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTQiIGhlaWdodD0iOCIgdmlld0JveD0iMCAwIDE0IDgiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxwYXRoIGQ9Ik0xMy4zNTM3IDAuNjQ2NTRDMTMuMjYgMC41NTI3ODkgMTMuMTMyOCAwLjUwMDEyMiAxMy4wMDAyIDAuNTAwMTIyQzEyLjg2NzYgMC41MDAxMjIgMTIuNzQwNSAwLjU1Mjc4OSAxMi42NDY3IDAuNjQ2NTRMNi45OTk5OSA2LjI5MzA0TDEuMzUzNDkgMC42NDY1NEMxLjI1OTI1IDAuNTU1MTI5IDEuMTMyODQgMC41MDQ0NTQgMS4wMDE1NSAwLjUwNTQ1N0MwLjg3MDI2NCAwLjUwNjQ2IDAuNzQ0NjM5IDAuNTU5MDYxIDAuNjUxODA1IDAuNjUxOTAxQzAuNTU4OTcyIDAuNzQ0NzQxIDAuNTA2Mzc5IDAuODcwMzcgMC41MDUzODUgMS4wMDE2NkMwLjUwNDM5MiAxLjEzMjk0IDAuNTU1MDc2IDEuMjU5MzYgMC42NDY0OTQgMS4zNTM1OUw2LjY0NjQ5IDcuMzUzNTlDNi43NDAyNiA3LjQ0NzMzIDYuODY3NDEgNy40OTk5OCA2Ljk5OTk5IDcuNDk5OThDNy4xMzI1OCA3LjQ5OTk4IDcuMjU5NzMgNy40NDczMyA3LjM1MzUgNy4zNTM1OUwxMy4zNTM1IDEuMzUzNTlDMTMuNDQ3MyAxLjI1OTg2IDEzLjUgMS4xMzI3MSAxMy41IDEuMDAwMTJDMTMuNTAwMSAwLjg2NzUyMyAxMy40NDc1IDAuNzQwMzM5IDEzLjM1MzcgMC42NDY1NFoiIGZpbGw9ImJsYWNrIiBmaWxsLW9wYWNpdHk9IjAuOTUiLz4KPC9zdmc+Cg=="
        enabled: textField.text.length > 0 || comboBox.popup.visible
        
        onClicked: {
            if (textField.text.length > 0) {           
                textField.clear();
                comboBox.currentIndex = -1;
                _filteredModel = _model; 
                comboBox.popup.close();
            } else  {           
                comboBox.popup.open();
            }
        }
        
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        
        background: Rectangle {
            color: 'transparent'
            width: parent.width
            height: parent.height
        }	
    }
    
    contentItem: TextInput {
        id: textField
        text: ""
        color:  inputFieldConstants.textColor
        leftPadding: inputFieldConstants.textHorizontalPadding
        rightPadding: inputFieldConstants.textHorizontalPadding
        topPadding: inputFieldConstants.textVerticalPadding + 3.5
        bottomPadding: inputFieldConstants.textVerticalPadding
        
        onFocusChanged: {
            // Open the dropdown when the TextField gets focus
            if (focus) {
                comboBox.popup.open();
            }
        }
        onTextChanged: {
            // Open the dropdown when the user types anything
            comboBox.popup.open();
            comboBox.filterOptions();	
        }          
    }
    
    delegate: ItemDelegate {
        id: comboBoxItemDelegate
        width: Math.max(comboBox.choiceWidth, parent.width)
        height: comboBoxConstants.dropDownElementHeight
        verticalPadding: comboBoxConstants.dropDownElementVerticalPadding
        horizontalPadding: comboBoxConstants.dropDownElementHorizontalPadding
        highlighted: ListView.isCurrentItem
        Accessible.name: modelData.text
        
        background: Rectangle {
            x: parent.highlighted ? comboBoxConstants.popoutDelegateCordinates : 0
            y: parent.highlighted ? comboBoxConstants.popoutDelegateCordinates : 0
            width: parent.highlighted ? parent.width - comboBoxConstants.focusRingSize : parent.width
            height: parent.highlighted ? parent.height - comboBoxConstants.focusRingSize : parent.height
            color: comboBoxItemDelegate.pressed ? comboBoxConstants.dropDownElementColorPressed : comboBoxItemDelegate.highlighted ? comboBoxConstants.dropDownElementColorHovered : comboBoxConstants.dropDownElementColorNormal
            radius: comboBoxConstants.dropDownElementRadius 
            
            WCustomFocusItem {
                visible: highlighted
                isRectangle: true
                designatedParent: parent
            }
        }  
        
        contentItem: Text {
            text: modelData.text
            font.family: "Segeo UI"
            font.pixelSize:  inputFieldConstants.pixelSize
            color: inputFieldConstants.textColor
            elide: Text.ElideRight
            onImplicitWidthChanged: {
                var maxWidth = implicitWidth > comboBoxConstants.maxDropDownWidth ? comboBoxConstants.maxDropDownWidth : implicitWidth;
                comboBox.choiceWidth = Math.max(maxWidth, comboBox.choiceWidth);
            }
        }
        
        onClicked: {
            comboBox.currentIndex = index
            comboBox.popup.close()
        }
    }
        
    popup: Popup {
        y: comboBox.height + 5
        width: Math.max(comboBox.choiceWidth, comboBox.width)
        padding: comboBoxConstants.dropDownPadding       
        height: comboBoxListView.contentHeight + (2 * padding) > comboBoxConstants.dropDownHeight ? comboBoxConstants.dropDownHeight : comboBoxListView.contentHeight + (2 * padding)
        onOpened: {
            comboBoxListView.forceActiveFocus();
            if (comboBoxListView.currentIndex === -1)
                comboBoxListView.currentIndex = 0;            
        }
        
        onClosed: {
            comboBox.forceActiveFocus();
        }
        
        background: Rectangle {
            height: comboBox.delegateModel.count === 0 ? comboBoxConstants.dropDownHeight : comboBoxListView.height + 16
            color: comboBoxConstants.dropDownBackgroundColor
            border.color: comboBoxConstants.dropDownBorderColor
            radius: comboBoxConstants.dropDownRadius
        } 
               
        contentItem: Item {
            height: comboBox.delegateModel.count === 0 ? comboBoxConstants.dropDownHeight : comboBoxListView.height
            
            ListView {
                id: comboBoxListView               
                anchors.fill: parent
                clip: true
                model: comboBox.delegateModel	               
                currentIndex: comboBox.highlightedIndex
                
                Keys.onReturnPressed: {
                    comboBox.currentIndex = comboBoxListView.currentIndex;
                    popup.close();
                }
                
                ScrollBar.vertical: ScrollBar {
                    width: comboBoxConstants.scrollbarWidth
                    policy: comboBoxListView.contentHeight > comboBoxConstants.dropDownHeight ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                }
                               
                Text {                      
                    visible: comboBox.delegateModel.count === 0
                    text: "We can't find anything that matches your search"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter                        
                    font.family: "Segeo UI"
                    font.pixelSize: inputFieldConstants.pixelSize
                    color: inputFieldConstants.textColor
                } 

                Image {
                    visible: false
                    source: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzYiIGhlaWdodD0iMzYiIHZpZXdCb3g9IjAgMCAzNiAzNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTMyLjYyNSAxOS4xMjVDMzIuNDc3MiAxOS4xMjUxIDMyLjMzMDkgMTkuMDk2IDMyLjE5NDQgMTkuMDM5NUMzMi4wNTc5IDE4Ljk4MyAzMS45MzM4IDE4LjkwMDIgMzEuODI5MyAxOC43OTU3QzMxLjcyNDggMTguNjkxMiAzMS42NDIgMTguNTY3MiAzMS41ODU1IDE4LjQzMDZDMzEuNTI5IDE4LjI5NDEgMzEuNDk5OSAxOC4xNDc4IDMxLjUgMThDMzEuNSAyMC42NyAzMC43MDgyIDIzLjI4MDEgMjkuMjI0OCAyNS41MDAyQzI3Ljc0MTQgMjcuNzIwMyAyNS42MzMgMjkuNDUwNiAyMy4xNjYyIDMwLjQ3MjRDMjAuNjk5NCAzMS40OTQyIDE3Ljk4NSAzMS43NjE1IDE1LjM2NjMgMzEuMjQwNkMxMi43NDc1IDMwLjcxOTcgMTAuMzQyMSAyOS40MzQgOC40NTQwNyAyNy41NDU5QzYuNTY2MDYgMjUuNjU3OSA1LjI4MDMxIDIzLjI1MjUgNC43NTk0MSAyMC42MzM3QzQuMjM4NTEgMTguMDE1IDQuNTA1ODUgMTUuMzAwNiA1LjUyNzYzIDEyLjgzMzhDNi41NDk0MiAxMC4zNjcgOC4yNzk3NSA4LjI1ODU2IDEwLjQ5OTggNi43NzUxNkMxMi43MTk5IDUuMjkxNzYgMTUuMzMgNC41IDE4IDQuNUMxNy43MDE2IDQuNSAxNy40MTU1IDQuMzgxNDcgMTcuMjA0NSA0LjE3MDVDMTYuOTkzNSAzLjk1OTUyIDE2Ljg3NSAzLjY3MzM3IDE2Ljg3NSAzLjM3NUMxNi44NzUgMy4wNzY2MyAxNi45OTM1IDIuNzkwNDggMTcuMjA0NSAyLjU3OTVDMTcuNDE1NSAyLjM2ODUzIDE3LjcwMTYgMi4yNSAxOCAyLjI1QzE0Ljg4NSAyLjI1IDExLjgzOTggMy4xNzM3MiA5LjI0OTc4IDQuOTA0MzVDNi42NTk3IDYuNjM0OTkgNC42NDA5OCA5LjA5NDggMy40NDg5IDExLjk3MjdDMi4yNTY4MiAxNC44NTA3IDEuOTQ0OTIgMTguMDE3NSAyLjU1MjY0IDIxLjA3MjdDMy4xNjAzNiAyNC4xMjc5IDQuNjYwNCAyNi45MzQzIDYuODYzMDcgMjkuMTM2OUM5LjA2NTc1IDMxLjMzOTYgMTEuODcyMSAzMi44Mzk3IDE0LjkyNzMgMzMuNDQ3NEMxNy45ODI1IDM0LjA1NTEgMjEuMTQ5MyAzMy43NDMyIDI0LjAyNzMgMzIuNTUxMUMyNi45MDUyIDMxLjM1OSAyOS4zNjUgMjkuMzQwMyAzMS4wOTU3IDI2Ljc1MDJDMzIuODI2MyAyNC4xNjAyIDMzLjc1IDIxLjExNTEgMzMuNzUgMThDMzMuNzUwMSAxOC4xNDc4IDMzLjcyMTEgMTguMjk0MSAzMy42NjQ1IDE4LjQzMDZDMzMuNjA4IDE4LjU2NzIgMzMuNTI1MiAxOC42OTEyIDMzLjQyMDcgMTguNzk1N0MzMy4zMTYyIDE4LjkwMDIgMzMuMTkyMiAxOC45ODMgMzMuMDU1NiAxOS4wMzk1QzMyLjkxOTEgMTkuMDk2IDMyLjc3MjggMTkuMTI1MSAzMi42MjUgMTkuMTI1WiIgZmlsbD0iIzhGOEY4RiIvPgo8cGF0aCBkPSJNMTYuODc1IDMuMzc1QzE2Ljg3NDkgMy41MjI3NiAxNi45MDQgMy42NjkwOSAxNi45NjA1IDMuODA1NjJDMTcuMDE3IDMuOTQyMTUgMTcuMDk5OCA0LjA2NjIgMTcuMjA0MyA0LjE3MDY5QzE3LjMwODggNC4yNzUxNyAxNy40MzI5IDQuMzU4MDMgMTcuNTY5NCA0LjQxNDU0QzE3LjcwNTkgNC40NzEwNSAxNy44NTIyIDQuNTAwMDkgMTggNC41QzIxLjU3OTIgNC41MDM5MSAyNS4wMTA3IDUuOTI3NDggMjcuNTQxNiA4LjQ1ODM3QzMwLjA3MjUgMTAuOTg5MyAzMS40OTYxIDE0LjQyMDggMzEuNSAxOEMzMS41IDE4LjI5ODQgMzEuNjE4NSAxOC41ODQ1IDMxLjgyOTUgMTguNzk1NUMzMi4wNDA1IDE5LjAwNjUgMzIuMzI2NiAxOS4xMjUgMzIuNjI1IDE5LjEyNUMzMi45MjM0IDE5LjEyNSAzMy4yMDk1IDE5LjAwNjUgMzMuNDIwNSAxOC43OTU1QzMzLjYzMTUgMTguNTg0NSAzMy43NSAxOC4yOTg0IDMzLjc1IDE4QzMzLjc0NTMgMTMuODI0MyAzMi4wODQ0IDkuODIwOTMgMjkuMTMxOCA2Ljg2ODI0QzI2LjE3OTEgMy45MTU1NiAyMi4xNzU3IDIuMjU0NjkgMTggMi4yNUMxNy44NTIyIDIuMjQ5OTEgMTcuNzA1OSAyLjI3ODk1IDE3LjU2OTQgMi4zMzU0NkMxNy40MzI5IDIuMzkxOTcgMTcuMzA4OCAyLjQ3NDgzIDE3LjIwNDMgMi41NzkzMUMxNy4wOTk4IDIuNjgzOCAxNy4wMTcgMi44MDc4NSAxNi45NjA1IDIuOTQ0MzhDMTYuOTA0IDMuMDgwOTEgMTYuODc0OSAzLjIyNzI0IDE2Ljg3NSAzLjM3NVoiIGZpbGw9IiMxMTcwQ0YiLz4KPC9zdmc+Cg=="
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    RotationAnimator on rotation {
                        running: true
                        loops: Animation.Infinite
                        from: 0
                        to: 360
                        duration: 1500
                    }
                }    
            }
        }
    }
    
    background: Rectangle {
        radius: inputFieldConstants.borderRadius
        color: inputFieldConstants.backgroundColorNormal
        border.color: inputFieldConstants.borderColorNormal
        border.width: inputFieldConstants.borderWidth
    }     
}

