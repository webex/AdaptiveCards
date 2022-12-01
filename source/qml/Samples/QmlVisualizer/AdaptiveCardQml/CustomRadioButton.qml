import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

RadioButton {
    id: customRadioButton

    property var _consumer
    property var _adaptiveCard
    property string _rbValueOn: ""
    property bool _rbIsChecked
    property bool _rbisWrap
    property string _rbTitle
    property string value: checked ? _rbValueOn : ""
    property var indicatorItem: customRadioButtonOuterRectancle
    property var toggleButtonConstants: CardConstants.toggleButtonConstants

    signal selectionChanged()

    function onButtonClicked() {
        checked = true;
    }

    function getContentText() {
        return customRadioButtonTitle.getText(0, customRadioButtonTitle.length);
    }

    function colorChange(item, isPressed) {
        if (isPressed)
            item.indicatorItem.color = item.checked ? toggleButtonConstants.colorOnCheckedAndPressed : toggleButtonConstants.colorOnUncheckedAndPressed;
        else
            item.indicatorItem.color = item.hovered ? (item.checked ? toggleButtonConstants.colorOnCheckedAndHovered : toggleButtonConstants.colorOnUncheckedAndHovered) : (item.checked ? toggleButtonConstants.colorOnChecked : toggleButtonConstants.colorOnUnchecked);
        if (isPressed)
            item.indicatorItem.border.color = item.checked ? toggleButtonConstants.borderColorOnCheckedAndPressed : toggleButtonConstants.borderColorOnUncheckedAndPressed;
        else
            item.indicatorItem.border.color = item.hovered ? (item.checked ? toggleButtonConstants.borderColorOnCheckedAndHovered : toggleButtonConstants.borderColorOnUncheckedAndHovered) : (item.checked ? toggleButtonConstants.borderColorOnChecked : toggleButtonConstants.borderColorOnUnchecked);
    }

    checked: _rbIsChecked
    activeFocusOnTab: false
    width: parent.width
    font.pixelSize: toggleButtonConstants.pixelSize
    Keys.onReturnPressed: onButtonClicked()
    onPressed: customRadioButton.colorChange(customRadioButton, true)
    onReleased: customRadioButton.colorChange(customRadioButton, false)
    onHoveredChanged: customRadioButton.colorChange(customRadioButton, false)
    onCheckedChanged: {
        customRadioButton.colorChange(customRadioButton, false);
        value = checked ? _rbValueOn : "";
        selectionChanged();
    }
    onActiveFocusChanged: {
        customRadioButton.colorChange(customRadioButton, false);
        if (activeFocus)
            Accessible.name = _consumer.getAccessibleName() + getContentText();

    }
    Component.onCompleted: {
        customRadioButton.colorChange(customRadioButton, false);
    }

    indicator: Rectangle {
    }

    contentItem: Row {
        height: toggleButtonConstants.rowHeight
        width: customRadioButton.width
        spacing: toggleButtonConstants.rowSpacing

        Rectangle {
            id: customRadioButtonOuterRectancle

            width: toggleButtonConstants.radioButtonOuterCircleSize
            height: toggleButtonConstants.radioButtonOuterCircleSize
            y: toggleButtonConstants.indicatorTopPadding
            radius: height / 2
            border.width: parent.checked ? 0 : toggleButtonConstants.borderWidth

            Rectangle {
                width: toggleButtonConstants.radioButtonInnerCircleSize
                height: toggleButtonConstants.radioButtonInnerCircleSize
                x: (parent.width - width) / 2
                y: (parent.height - height) / 2
                radius: height / 2
                color: customRadioButton.checked ? toggleButtonConstants.radioButtonInnerCircleColorOnChecked : 'transparent'
                visible: customRadioButton.checked
            }

        }

        CardGenericTextElement {
            id: customRadioButtonTitle

            text: _rbTitle
            wrapMode: _rbisWrap ? Text.Wrap : Text.NoWrap
            width: parent.width - customRadioButtonOuterRectancle.width - spacing
            Component.onCompleted: {
                onTextElementClicked.connect(customRadioButton.onButtonClicked);
            }
        }

    }

}
