import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import AdaptiveCards 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0


ComboBox {
    id: comboBox
    
    property var _adaptiveCard 
    property var _consumer
    property var _model
    property int _currentIndex
    property bool _isMultiselect
    property string _mEscapedPlaceholderString
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var comboBoxConstants: CardConstants.comboBoxConstants
    property var cardConstants: CardConstants.cardConstants
    property int choiceWidth: 0
    property var selectedChoices: []
    property var filteredModel: _model;
    
    
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
        if (_isMultiselect) {
            selectedChoices.push(filteredModel[currentIndex]);
            contentItem.buttonFlowModel = selectedChoices;
            comboBox.filterOptions();
        }
        textField.text = _isMultiselect ? "" : option;
        comboBox.popup.close();
        selectionChanged();
    }

    function clearMultiselectTile(index) {
        var removedItem = selectedChoices.splice(index, 1);
        filteredModel.push(removedItem[0]);
        var filteredModelCopy = filteredModel;
        filteredModel = filteredModelCopy;
        contentItem.buttonFlowModel = selectedChoices;
    }
    
    function filterOptions() {
        if (textField.text == "") {
            filteredModel = _model;
        }
        var filterText = textField.text.toLowerCase();

        //Filtering the main model for entered text
        filteredModel = _model.filter(function(entry) {
            return entry.text.toLowerCase().includes(filterText);
        });

        //Removing entries that are already selected
        var filteredModelCopy = filteredModel
        for (let index = 0; index < selectedChoices.length; index++) {
            var elementIndex = filteredModelCopy.findIndex(function(entry) {
                return entry.valueOn == selectedChoices[index].valueOn && entry.text == selectedChoices[index].text;
            });
            if (elementIndex != -1) {
                filteredModelCopy.splice(elementIndex, 1);
            }
        }
        filteredModel = filteredModelCopy;
    }
    
    textRole: 'text'
    valueRole: 'valueOn'
    width: parent.width
    height: {
        if (selectedChoices.length == 0) {
            return inputFieldConstants.height;                                          // Height without any multiselect tiles
        } else if (buttonFlow.implicitHeight > (inputFieldConstants.height * 2)) {
            return (inputFieldConstants.height * 2) + 8;                                // Height with too many multiselect tiles
        }
        return buttonFlow.implicitHeight + 8;                                           // Height adjusting according to number of multiselect tiles
    }
    model: filteredModel
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
        icon.width: textField.text.length > 0 ? CardConstants.inputFieldConstants.clearIconSize : comboBoxConstants.arrowIconWidth
        icon.height: textField.text.length > 0 ? CardConstants.inputFieldConstants.clearIconSize : comboBoxConstants.arrowIconHeight
        focusPolicy: Qt.NoFocus
        icon.color: comboBoxConstants.arrowIconColor
        icon.source: textField.text.length > 0 ? CardConstants.clearIconImage : "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTQiIGhlaWdodD0iOCIgdmlld0JveD0iMCAwIDE0IDgiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxwYXRoIGQ9Ik0xMy4zNTM3IDAuNjQ2NTRDMTMuMjYgMC41NTI3ODkgMTMuMTMyOCAwLjUwMDEyMiAxMy4wMDAyIDAuNTAwMTIyQzEyLjg2NzYgMC41MDAxMjIgMTIuNzQwNSAwLjU1Mjc4OSAxMi42NDY3IDAuNjQ2NTRMNi45OTk5OSA2LjI5MzA0TDEuMzUzNDkgMC42NDY1NEMxLjI1OTI1IDAuNTU1MTI5IDEuMTMyODQgMC41MDQ0NTQgMS4wMDE1NSAwLjUwNTQ1N0MwLjg3MDI2NCAwLjUwNjQ2IDAuNzQ0NjM5IDAuNTU5MDYxIDAuNjUxODA1IDAuNjUxOTAxQzAuNTU4OTcyIDAuNzQ0NzQxIDAuNTA2Mzc5IDAuODcwMzcgMC41MDUzODUgMS4wMDE2NkMwLjUwNDM5MiAxLjEzMjk0IDAuNTU1MDc2IDEuMjU5MzYgMC42NDY0OTQgMS4zNTM1OUw2LjY0NjQ5IDcuMzUzNTlDNi43NDAyNiA3LjQ0NzMzIDYuODY3NDEgNy40OTk5OCA2Ljk5OTk5IDcuNDk5OThDNy4xMzI1OCA3LjQ5OTk4IDcuMjU5NzMgNy40NDczMyA3LjM1MzUgNy4zNTM1OUwxMy4zNTM1IDEuMzUzNTlDMTMuNDQ3MyAxLjI1OTg2IDEzLjUgMS4xMzI3MSAxMy41IDEuMDAwMTJDMTMuNTAwMSAwLjg2NzUyMyAxMy40NDc1IDAuNzQwMzM5IDEzLjM1MzcgMC42NDY1NFoiIGZpbGw9ImJsYWNrIiBmaWxsLW9wYWNpdHk9IjAuOTUiLz4KPC9zdmc+Cg=="
        enabled: textField.text.length > 0 || comboBox.popup.visible
        
        onClicked: {
            if (textField.text.length > 0) {           
                textField.clear();
                comboBox.currentIndex = -1;
                filteredModel = _model; 
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
    
    contentItem: ScrollView {
        id: textFieldScroller

        property alias buttonFlowModel: comboBox.selectedChoices

        function clearMultiselectTile(index) {
            comboBox.clearMultiselectTile(index);
        }
        clip: true
        ScrollBar.vertical.policy: ScrollBar.AsNeeded
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        contentWidth: width
        contentHeight: textField.height

        MouseArea {
            id: mouseArea
        
            anchors.fill: parent
            onClicked: (mouse)=> {
                textField.forceActiveFocus();
            }
        }                

        TextInput {
            id: textField

            text: ""
            clip: true
            color:  inputFieldConstants.textColor
            font.family: "Segeo UI"
            font.pixelSize:  inputFieldConstants.pixelSize
            leftPadding: textFieldScroller.buttonFlowModel.length == 0 ?  8 : repeater.itemAt(repeater.count - 1).x + repeater.itemAt(repeater.count - 1).width + 16
            rightPadding: inputFieldConstants.textHorizontalPadding
            topPadding: textFieldScroller.buttonFlowModel.length == 0 ? 6 : repeater.itemAt(repeater.count - 1).y + 6
            bottomPadding: inputFieldConstants.textVerticalPadding
            width: parent.width
        
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
                textField.forceActiveFocus();
            }
            
            Flow {
                id: buttonFlow
                anchors.fill: parent
                anchors.topMargin: 4
                anchors.leftMargin: 8
                spacing: 10 // Adjust the spacing between buttons
                        
                Repeater {
                    id: repeater
                    model: textFieldScroller.buttonFlowModel // Set an arbitrary number of buttons
    
                    Rectangle {
                        id: buttonTile
    
                        property var label: ""
                        property var key
    
                        height: 24
                        width: (rowLayout.width + 16) > textField.width ? textField.width : rowLayout.width + 16
                        color: "transparent"
                        border.color: inputFieldConstants.borderColorNormal
                        border.width: 1
                        radius: 4
    
                        RowLayout {
                            id: rowLayout
        
                            spacing: 4
                            clip: true
                            anchors {
                                top: parent.top
                                bottom: parent.bottom
                                rightMargin: 8
                                left: parent.left
                                leftMargin: 8
                            }

                            Layout.maximumWidth: textField.width
                        
                            Text {
                                id: label
            
                                text: modelData.text
                                color: inputFieldConstants.textColor
                                font {
                                    family: "Segoe UI"
                                    pixelSize: inputFieldConstants.pixelSize
                                }
                                elide: Text.ElideRight
                            }
                        
                            InputFieldClearIcon {
                                id: clearIcon
                            
                                icon.color: inputFieldConstants.textColor
                                Layout.preferredWidth: label.font.pixelSize
                                Layout.preferredHeight: label.font.pixelSize
                            }
                        }
    
                        MouseArea {
                            id: mouseArea
        
                            anchors.fill: parent
                            onClicked: (mouse)=> {
                                textFieldScroller.clearMultiselectTile(model.index);
                                mouse.accepted = false;
            
                            }
                        }
                    }
                }
            }
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

