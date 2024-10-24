import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

Column {
    id: choiceSet
    
    property var adaptiveCard
    property string elementType:"Combobox"
    
    width: parent.width
    spacing: CardConstants.inputFieldConstants.columnSpacing
    onActiveFocusChanged: {
        if (activeFocus)
            nextItemInFocusChain().forceActiveFocus();
        
    }
    
    InputLabel {
        id: choiceSetLabel
        
        label: "Required"
        required: true
        visible: label.length
    }
    
    Loader {
        id: comboboxLoader
        
        height: item ? item.height : 0
        width: parent.width
        active: elementType === "Combobox"
        
        sourceComponent: ComboboxRender {
            id: comboBox
            
            isModel: choiceSetModel
            mEscapedPlaceholderString: "Enter your choice"
            mCurrentIndex: -1
            consumer: choiceSet
            adaptiveCard: choiceSet.adaptiveCard
            
        }
        
    }
    
    Loader {
        id: radioButtonLoader
        
        height: item ? item.height : 0
        width: parent.width
        active: elementType === "RadioButton"
        
        sourceComponent: Rectangle {
            id: radioButtonRectangle
            
            property int focusRadioIndex: 0
            
            height: radioButtonColumn.height
            width: parent.width
            color: "transparent"
            onActiveFocusChanged: {
                if (activeFocus)
                    radioButtonGroup.buttons[focusRadioIndex].forceActiveFocus();
                
            }
            
            ButtonGroup {
                id: radioButtonGroup
                
                function onSelectionChanged() {
                    choiceSet.selectedValues = AdaptiveCardUtils.onSelectionChanged(radioButtonGroup, false);
                    if (isRequired)
                        validate();
                    
                }
                
                buttons: radioButtonColumn.contentItem.children
                exclusive: true
            }
            
            Column{
                id:radioButtonColumn
                height: contentItem.height
                width: parent.width
                CustomRadioButton {
                    adaptiveCard: choiceSet.adaptiveCard
                    rbValueOn:"true"
                    rbisWrap: true
                    rbTitle: "Blue"
                    rbIsChecked: isChecked
                    consumer: choiceSet
                    
                }
                
            }
            
        }
    }
    
    Loader {
        id: checkBoxLoader
        
        height: item ? item.height : 0
        width: parent.width
        active: elementType  === "CheckBox"
        
        sourceComponent: Rectangle {
            id: checkBoxRectangle
            
            height: checkBoxColumn.height
            width: parent.width
            color: "transparent"
            
            ButtonGroup {
                id: checkBoxButtonGroup
                
                buttons: checkBoxColumn.contentItem.children
                exclusive: false
            }
            
            Column{
                
                
                id: checkBoxColumn
                height: contentItem.height
                width: parent.width
                
                CustomCheckBox {
                    adaptiveCard: choiceSet.adaptiveCard
                    cbValueOn: "true"
                    cbValueOff:"false"
                    cbisWrap: true
                    cbTitle: "Blue"
                    cbIsChecked: true
                    consumer: choiceSet
                }
                
            }
            
        }
        
    }
    
    InputErrorMessage {
        id: choiceSetErrorMessage
        
        isErrorMessage: "error"
        visible: true
    }
    
}