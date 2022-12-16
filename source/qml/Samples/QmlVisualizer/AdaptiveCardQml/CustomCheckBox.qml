import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

CheckBox {
    id: customCheckBox

    property var _adaptiveCard
    property var _consumer
    property string _cbValueOn: ""
    property string _cbValueOff: ""
    property bool _cbisWrap
    property string _cbTitle
    property bool _cbIsChecked
    property string value: checked ? _cbValueOn : _cbValueOff
    property var indicatorItem: customCheckBoxButton

    signal selectionChanged()

    function onButtonClicked() {
        checked = !checked;
    }

    function getContentText() {
        return customCheckBoxTitle.getText(0, customCheckBoxTitle.length);
    }

    function colorChange(item, isPressed) {
        if (isPressed)
            item.indicatorItem.color = item.checked ? CardConstants.toggleButtonConstants.colorOnCheckedAndPressed : CardConstants.toggleButtonConstants.colorOnUncheckedAndPressed;
        else
            item.indicatorItem.color = item.hovered ? (item.checked ? CardConstants.toggleButtonConstants.colorOnCheckedAndHovered : CardConstants.toggleButtonConstants.colorOnUncheckedAndHovered) : (item.checked ? CardConstants.toggleButtonConstants.colorOnChecked : CardConstants.toggleButtonConstants.colorOnUnchecked);
        if (isPressed)
            item.indicatorItem.border.color = item.checked ? CardConstants.toggleButtonConstants.borderColorOnCheckedAndPressed : CardConstants.toggleButtonConstants.borderColorOnUncheckedAndPressed;
        else
            item.indicatorItem.border.color = item.hovered ? (item.checked ? CardConstants.toggleButtonConstants.borderColorOnCheckedAndHovered : CardConstants.toggleButtonConstants.borderColorOnUncheckedAndHovered) : (item.checked ? CardConstants.toggleButtonConstants.borderColorOnChecked : CardConstants.toggleButtonConstants.borderColorOnUnchecked);
    }

    checked: _cbIsChecked
    width: parent.width
    Keys.onReturnPressed: onButtonClicked()
    onPressed: customCheckBox.colorChange(customCheckBox, true)
    onReleased: customCheckBox.colorChange(customCheckBox, false)
    onHoveredChanged: customCheckBox.colorChange(customCheckBox, false)
    onCheckedChanged: {
        customCheckBox.colorChange(customCheckBox, false);
        value = checked ? _cbValueOn : _cbValueOff;
        selectionChanged();
    }
    onActiveFocusChanged: {
        customCheckBox.colorChange(customCheckBox, false);
        if (activeFocus && _consumer)
            Accessible.name = _consumer.getAccessibleName() + getContentText();

    }
    Component.onCompleted: {
        customCheckBox.colorChange(customCheckBox, false);
    }

    indicator: Rectangle {
    }

    contentItem: RowLayout {
        id: customCheckBoxRLayout
        width: customCheckBox.width
        spacing: CardConstants.toggleButtonConstants.rowSpacing

        Rectangle {
            id: customCheckBoxButton

            width: CardConstants.toggleButtonConstants.radioButtonOuterCircleSize
            height: CardConstants.toggleButtonConstants.radioButtonOuterCircleSize
            y: CardConstants.toggleButtonConstants.indicatorTopPadding
            radius: CardConstants.toggleButtonConstants.checkBoxBorderRadius
            border.width: parent.checked ? 0 : CardConstants.toggleButtonConstants.borderWidth

            Button {
                anchors.centerIn: parent
                width: parent.width - 3
                height: parent.height - 3
                verticalPadding: 0
                horizontalPadding: 0
                enabled: false
                icon.width: width
                icon.height: height
                icon.color: CardConstants.toggleButtonConstants.checkBoxIconColorOnChecked
                icon.source: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+YWxlcnRzLWFuZC1ub3RpZmljYXRpb25zL2NoZWNrXzEyX3c8L3RpdGxlPjxwYXRoIGQ9Ik00LjUwMjQgOS41Yy0uMTMzIDAtLjI2LS4wNTMtLjM1NC0uMTQ3bC0zLjAwMi0zLjAwN2MtLjE5NS0uMTk2LS4xOTUtLjUxMi4wMDEtLjcwNy4xOTQtLjE5NS41MTEtLjE5Ni43MDcuMDAxbDIuNjQ4IDIuNjUyIDUuNjQyLTUuNjQ2Yy4xOTUtLjE5NS41MTEtLjE5NS43MDcgMCAuMTk1LjE5NS4xOTUuNTEyIDAgLjcwOGwtNS45OTUgNmMtLjA5NC4wOTMtLjIyMS4xNDYtLjM1NC4xNDYiIGZpbGw9IiNGRkYiIGZpbGwtcnVsZT0iZXZlbm9kZCIvPjwvc3ZnPg=="
                visible: customCheckBox.checked

                background: Rectangle {
                    color: 'transparent'
                }

            }

        }

        CardGenericTextElement {
            id: customCheckBoxTitle

            text: _cbTitle
            _adaptiveCard: customCheckBox._adaptiveCard
            wrapMode: _cbisWrap ? Text.Wrap : Text.NoWrap
            Layout.fillWidth: true
            Component.onCompleted: {
                onTextElementClicked.connect(customCheckBox.onButtonClicked);
            }
        }

    }

}
