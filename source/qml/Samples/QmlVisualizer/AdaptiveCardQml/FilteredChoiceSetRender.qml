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
	    comboBox.popup.visible = false
	
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
        icon.source: comboBox.popup.visible ? "data:image/svg+xml;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACAAgMAAAC+UIlYAAAAA3NCSVQICAjb4U/gAAAACXBIWXMAAAoNAAAKDQFKsqGvAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAAAxQTFRF////AAAAAAAAAAAA+IwCTQAAAAN0Uk5TAHCPqE4jmQAAAe9JREFUWMOd2MHRqzAMRlGFTRYUkRJogc5CZ7RACRSRBRvyvQXDk20pvjN/VrGGmBMDloSZmdljsfAZ5mLw3OMB41YMXkc8YPoUg/c3HrCe/v0hBcQgOeIpBcQoOeIlBcQkOeItBcQqnQUhIAbJEU8pIEbJES8pICbJEW8pIFbpP+IhBcRwxWYnNIjxim1OaBDTFfs4oUGsV+wsCBViuGOzEyrEeMc2J1SI6Y59nFAh1jt2FoQCMXhsdkKBGD22OaFATB77OKFArB47y8GNKAj6ltPdiIKgoxm1BO3NfC1Bi0VE+5OAaE8aEO0vAiKcswlEdTNl/N9NJK5cM2ey9lUoWbh60mTpa0Ry8WpEQqgRCaFGJIQakRBqREb4gfia9RGHWR+xm/URS7Jh/CKkiMOsj9jN+ogl2Th/ExLEYdZH7GZ9xJIkkB4hIGKeHPuEgEhy9donNIgkVdeIJNnXiOUvB+ApEEl/ExcKlxovFl1uvGHwlsOblm57fHDw0cOHlx5/3EBwC8JNjLZB3EhxK8bNnNIBJhRMSZjUKC1iYsXUjMmdygMsMLBEwSKHyiQstLBUw2IPy0UsOLFkxaIXy2YsvLl0x+If2wdsQLiFwSYI2yhsxLiVw2YQ20lsSLmlxaYY22pszLm1x5cDndcL/wA9JaEl0OukTwAAAABJRU5ErkJggg==" : "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTQiIGhlaWdodD0iOCIgdmlld0JveD0iMCAwIDE0IDgiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxwYXRoIGQ9Ik0xMy4zNTM3IDAuNjQ2NTRDMTMuMjYgMC41NTI3ODkgMTMuMTMyOCAwLjUwMDEyMiAxMy4wMDAyIDAuNTAwMTIyQzEyLjg2NzYgMC41MDAxMjIgMTIuNzQwNSAwLjU1Mjc4OSAxMi42NDY3IDAuNjQ2NTRMNi45OTk5OSA2LjI5MzA0TDEuMzUzNDkgMC42NDY1NEMxLjI1OTI1IDAuNTU1MTI5IDEuMTMyODQgMC41MDQ0NTQgMS4wMDE1NSAwLjUwNTQ1N0MwLjg3MDI2NCAwLjUwNjQ2IDAuNzQ0NjM5IDAuNTU5MDYxIDAuNjUxODA1IDAuNjUxOTAxQzAuNTU4OTcyIDAuNzQ0NzQxIDAuNTA2Mzc5IDAuODcwMzcgMC41MDUzODUgMS4wMDE2NkMwLjUwNDM5MiAxLjEzMjk0IDAuNTU1MDc2IDEuMjU5MzYgMC42NDY0OTQgMS4zNTM1OUw2LjY0NjQ5IDcuMzUzNTlDNi43NDAyNiA3LjQ0NzMzIDYuODY3NDEgNy40OTk5OCA2Ljk5OTk5IDcuNDk5OThDNy4xMzI1OCA3LjQ5OTk4IDcuMjU5NzMgNy40NDczMyA3LjM1MzUgNy4zNTM1OUwxMy4zNTM1IDEuMzUzNTlDMTMuNDQ3MyAxLjI1OTg2IDEzLjUgMS4xMzI3MSAxMy41IDEuMDAwMTJDMTMuNTAwMSAwLjg2NzUyMyAxMy40NDc1IDAuNzQwMzM5IDEzLjM1MzcgMC42NDY1NFoiIGZpbGw9ImJsYWNrIiBmaWxsLW9wYWNpdHk9IjAuOTUiLz4KPC9zdmc+Cg=="
        enabled: true

    //   visible: textField.text.length > 0 // Show only when there is text to clear
            onClicked: {
		            if (textField.text.length > 0){
			        textField.clear();
			        comboBox.currentIndex = -1;
				comboBox.popup.close();
		            } else {
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
            color: "black"

	    leftPadding: inputFieldConstants.textHorizontalPadding
            rightPadding: inputFieldConstants.textHorizontalPadding
            topPadding: inputFieldConstants.textVerticalPadding + 3.5
            bottomPadding: inputFieldConstants.textVerticalPadding
            
            onFocusChanged: {
                // Open the dropdown when the TextField gets focus
                if (focus) {
                    comboBox.popup.visible = true;
                }
            }
            onTextChanged: {
                // Open the dropdown when the user types anything
                comboBox.popup.visible = true;
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

        onHoveredChanged: {
            if(hovered)
                comboBoxListView.currentIndex = index;
        }

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
            anchors.fill: parent
            color: comboBoxConstants.dropDownBackgroundColor
            border.color: comboBoxConstants.dropDownBorderColor
            radius: comboBoxConstants.dropDownRadius
        }


        contentItem: ListView {
            id: comboBoxListView

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

        }

    }


    background: Rectangle {
        radius: inputFieldConstants.borderRadius
        color: inputFieldConstants.backgroundColorNormal
        border.color: inputFieldConstants.borderColorNormal
        border.width: inputFieldConstants.borderWidth
    }

}

