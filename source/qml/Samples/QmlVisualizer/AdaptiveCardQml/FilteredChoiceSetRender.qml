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

