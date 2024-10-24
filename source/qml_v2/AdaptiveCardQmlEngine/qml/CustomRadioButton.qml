import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

RadioButton {
    id: customRadioButton
    
    property var consumer
    property var adaptiveCard
    property string rbValueOn: ""
    property bool rbIsChecked
    property bool rbisWrap
    property string rbTitle
    property string value: "true" ? rbValueOn : ""
    property var indicatorItem: customRadioButtonOuterRectancle
    property var toggleButtonConstants: CardConstants.toggleButtonConstants
    
    signal selectionChanged()
    
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
    
    checked: rbIsChecked
    width: parent.width
    font.pixelSize: toggleButtonConstants.pixelSize
    Keys.onReturnPressed: onButtonClicked()
    onPressed: customRadioButton.colorChange(customRadioButton, true)
    onReleased: customRadioButton.colorChange(customRadioButton, false)
    onHoveredChanged: customRadioButton.colorChange(customRadioButton, false)
    Component.onCompleted: {
        customRadioButton.colorChange(customRadioButton, false);
    }
    
    indicator: Rectangle {
    }
    
    contentItem: RowLayout {
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
            
            WCustomFocusItem {
                visible: customRadioButton.activeFocus
                designatedParent: parent
            }
            
        }
        
        CardGenericTextElement {
            id: customRadioButtonTitle
            
            text: rbTitle
            adaptiveCard: customRadioButton.adaptiveCard
            wrapMode: rbisWrap ? Text.Wrap : Text.NoWrap
            Layout.fillWidth: true
            Component.onCompleted: {
                onTextElementClicked.connect(customRadioButton.onButtonClicked);
            }
        }
    }
}
