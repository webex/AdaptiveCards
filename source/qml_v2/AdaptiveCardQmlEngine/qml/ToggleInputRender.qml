import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

Column {
    id: toggleInput
    
    property var toggleInputModel:model.toggleInputRole
    
    property var adaptiveCard
    property bool isChecked: customCheckBox.checked
    property var value: customCheckBox.value
    property bool showErrorMessage: false
    property int minWidth: customCheckBox.implicitWidth
    property alias checkBox: customCheckBox
    
    width: parent.width
    onActiveFocusChanged: {
        if (activeFocus)
            customCheckBox.forceActiveFocus();
        
    }
    onIsCheckedChanged: validate()
    visible:toggleInputModel.visible
    InputLabel {
        id: inputToggleLabel
        
        label: toggleInputModel.escapedLabelString
        required: toggleInputModel.isRequired
        visible: label.length
    }
    
    CustomCheckBox {
        id: customCheckBox
        
        adaptiveCard: toggleInput.adaptiveCard
        consumer: toggleInput
    }
    
    InputErrorMessage {
        id: inputToggleErrorMessage
        visible: showErrorMessage
    }
    
}
