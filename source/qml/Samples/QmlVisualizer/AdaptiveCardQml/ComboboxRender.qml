import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import AdaptiveCards 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

ComboBox {
    id: comboBox

    property var _consumer
    property var _model
    property int _currentIndex
    property string _mEscapedPlaceholderString
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var comboBoxConstants: CardConstants.comboBoxConstants
    property var cardConstants: CardConstants.cardConstants
    property int choiceWidth: 0

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

    textRole: 'text'
    valueRole: 'valueOn'
    width: parent.width
    height: inputFieldConstants.height
    model: _model
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
    onHoveredChanged: colorChange(false)
    onCurrentValueChanged: {
        Accessible.name = displayText;
        selectionChanged();
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
        icon.source: comboBox.popup.visible ? "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTQiIGhlaWdodD0iOCIgdmlld0JveD0iMCAwIDE0IDgiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxwYXRoIGQ9Ik0xMy4zNTM2IDYuNjQ2NTRMNy4zNTM2MSAwLjY0NjU0QzcuMjU5ODUgMC41NTI3ODkgNy4xMzI2OCAwLjUwMDEyMiA3LjAwMDA5IDAuNTAwMTIyQzYuODY3NDkgMC41MDAxMjIgNi43NDAzMyAwLjU1Mjc4OSA2LjY0NjU2IDAuNjQ2NTRMMC42NDY1NjEgNi42NDY1NEMwLjU5OTE2NSA2LjY5Mjc1IDAuNTYxNDE3IDYuNzQ3OTEgMC41MzU1MDUgNi44MDg4MkMwLjUwOTU5NCA2Ljg2OTczIDAuNDk2MDM1IDYuOTM1MTggMC40OTU2MTYgNy4wMDEzOEMwLjQ5NTE5NiA3LjA2NzU3IDAuNTA3OTI0IDcuMTMzMTkgMC41MzMwNjIgNy4xOTQ0MkMwLjU1ODE5OSA3LjI1NTY2IDAuNTk1MjQ2IDcuMzExMjkgMC42NDIwNTIgNy4zNTgxQzAuNjg4ODU4IDcuNDA0OTEgMC43NDQ0OTMgNy40NDE5NSAwLjgwNTcyOCA3LjQ2NzA5QzAuODY2OTY0IDcuNDkyMjMgMC45MzI1ODEgNy41MDQ5NiAwLjk5ODc3NCA3LjUwNDU0QzEuMDY0OTcgNy41MDQxMiAxLjEzMDQyIDcuNDkwNTYgMS4xOTEzMyA3LjQ2NDY1QzEuMjUyMjQgNy40Mzg3MyAxLjMwNzQgNy40MDA5OSAxLjM1MzYxIDcuMzUzNTlMNy4wMDAwNiAxLjcwNzA5TDEyLjY0NjYgNy4zNTM1OUMxMi42OTI4IDcuNDAwOTkgMTIuNzQ3OSA3LjQzODczIDEyLjgwODggNy40NjQ2NUMxMi44Njk4IDcuNDkwNTYgMTIuOTM1MiA3LjUwNDEyIDEzLjAwMTQgNy41MDQ1NEMxMy4wNjc2IDcuNTA0OTYgMTMuMTMzMiA3LjQ5MjIzIDEzLjE5NDQgNy40NjcwOUMxMy4yNTU3IDcuNDQxOTUgMTMuMzExMyA3LjQwNDkxIDEzLjM1ODEgNy4zNTgxQzEzLjQwNDkgNy4zMTEyOSAxMy40NDIgNy4yNTU2NiAxMy40NjcxIDcuMTk0NDJDMTMuNDkyMiA3LjEzMzE5IDEzLjUwNSA3LjA2NzU3IDEzLjUwNDYgNy4wMDEzOEMxMy41MDQxIDYuOTM1MTggMTMuNDkwNiA2Ljg2OTczIDEzLjQ2NDcgNi44MDg4MkMxMy40Mzg4IDYuNzQ3OTEgMTMuNDAxIDYuNjkyNzUgMTMuMzUzNiA2LjY0NjU0WiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8L3N2Zz4K" : "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTQiIGhlaWdodD0iOCIgdmlld0JveD0iMCAwIDE0IDgiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxwYXRoIGQ9Ik0xMy4zNTM3IDAuNjQ2NTRDMTMuMjYgMC41NTI3ODkgMTMuMTMyOCAwLjUwMDEyMiAxMy4wMDAyIDAuNTAwMTIyQzEyLjg2NzYgMC41MDAxMjIgMTIuNzQwNSAwLjU1Mjc4OSAxMi42NDY3IDAuNjQ2NTRMNi45OTk5OSA2LjI5MzA0TDEuMzUzNDkgMC42NDY1NEMxLjI1OTI1IDAuNTU1MTI5IDEuMTMyODQgMC41MDQ0NTQgMS4wMDE1NSAwLjUwNTQ1N0MwLjg3MDI2NCAwLjUwNjQ2IDAuNzQ0NjM5IDAuNTU5MDYxIDAuNjUxODA1IDAuNjUxOTAxQzAuNTU4OTcyIDAuNzQ0NzQxIDAuNTA2Mzc5IDAuODcwMzcgMC41MDUzODUgMS4wMDE2NkMwLjUwNDM5MiAxLjEzMjk0IDAuNTU1MDc2IDEuMjU5MzYgMC42NDY0OTQgMS4zNTM1OUw2LjY0NjQ5IDcuMzUzNTlDNi43NDAyNiA3LjQ0NzMzIDYuODY3NDEgNy40OTk5OCA2Ljk5OTk5IDcuNDk5OThDNy4xMzI1OCA3LjQ5OTk4IDcuMjU5NzMgNy40NDczMyA3LjM1MzUgNy4zNTM1OUwxMy4zNTM1IDEuMzUzNTlDMTMuNDQ3MyAxLjI1OTg2IDEzLjUgMS4xMzI3MSAxMy41IDEuMDAwMTJDMTMuNTAwMSAwLjg2NzUyMyAxMy40NDc1IDAuNzQwMzM5IDEzLjM1MzcgMC42NDY1NFoiIGZpbGw9ImJsYWNrIiBmaWxsLW9wYWNpdHk9IjAuOTUiLz4KPC9zdmc+Cg=="
        enabled: false

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

    contentItem: Text {
        text: parent.displayText
        font.pixelSize: inputFieldConstants.pixelSize
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        color: inputFieldConstants.textColor
        leftPadding: inputFieldConstants.textHorizontalPadding
        rightPadding: inputFieldConstants.textHorizontalPadding
        topPadding: inputFieldConstants.textVerticalPadding
        bottomPadding: inputFieldConstants.textVerticalPadding
    }

    delegate: ItemDelegate {
        id: comboBoxItemDelegate

        width: Math.max(comboBox.choiceWidth, comboBox.width)
        height: comboBoxConstants.dropDownElementHeight
        verticalPadding: comboBoxConstants.dropDownElementVerticalPadding
        horizontalPadding: comboBoxConstants.dropDownElementHorizontalPadding
        highlighted: ListView.isCurrentItem
        Accessible.name: modelData.text

        background: Rectangle {
            color: comboBoxItemDelegate.pressed ? comboBoxConstants.dropDownElementColorPressed : comboBoxItemDelegate.highlighted ? comboBoxConstants.dropDownElementColorHovered : comboBoxConstants.dropDownElementColorNormal
            radius: comboBoxConstants.dropDownElementRadius
        }

        contentItem: Text {
            text: modelData.text
            font.family: "Segeo UI"
            font.pixelSize: inputFieldConstants.pixelSize
            color: inputFieldConstants.textColor
            elide: Text.ElideRight
            onImplicitWidthChanged: {
                var maxWidth = implicitWidth > comboBoxConstants.maxDropDownWidth ? comboBoxConstants.maxDropDownWidth : implicitWidth;
                comboBox.choiceWidth = Math.max(maxWidth, comboBox.choiceWidth);
            }
        }

    }

    popup: Popup {
        y: comboBox.height + 5
        width: Math.max(comboBox.choiceWidth, comboBox.width)
        padding: comboBoxConstants.dropDownPadding
        height: comboBoxListView.contentHeight + (2 * padding) > comboBoxConstants.dropDownHeight ? comboBoxConstants.dropDownHeight : comboBoxListView.contentHeight + (2 * padding)

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
            onCurrentIndexChanged: {
                if (currentIndex !== -1)
                    comboBox.currentIndex = currentIndex;

            }
            Keys.onReturnPressed: comboBox.accepted()

            ScrollBar.vertical: ScrollBar {
                width: comboBoxConstants.scrollbarWidth
                policy: comboBoxListView.contentHeight > comboBoxConstants.dropDownHeight ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
            }

        }

    }

    background: Rectangle {
        radius: inputFieldConstants.borderRadius
        color: inputFieldConstants.backgroundColorNormal
        border.color: (comboBox.activeFocus || comboBox.popup.visible) ? inputFieldConstants.borderColorOnFocus : inputFieldConstants.borderColorNormal
        border.width: inputFieldConstants.borderWidth
    }

}
