import QtQuick 2.15
import QtQuick.Controls 2.0
import AdaptiveCardQmlEngine 1.0

Loader {
    id: delegateSource
    
    property var parentCardItem
    
    Component.onCompleted :{
        if (model.delegateType == AdaptiveCardEnums.CardElementType.TextBlock)
            source = "TextBlockRender.qml"
        else if (model.delegateType == AdaptiveCardEnums.CardElementType.Image)
            source = "ImageRender.qml"
        else if (model.delegateType == AdaptiveCardEnums.CardElementType.RichTextBlock)
            source = "RichTextBlockRender.qml";
        else if (model.delegateType == AdaptiveCardEnums.CardElementType.DateInput)
            source = "DateInputRender.qml";
        else if (model.delegateType == AdaptiveCardEnums.CardElementType.NumberInput)
            source = "NumberInputRender.qml";
        else if (model.delegateType == AdaptiveCardEnums.CardElementType.TextInput)
            source = "TextInputRender.qml"
        else if (model.delegateType == AdaptiveCardEnums.CardElementType.TimeInput)
            source = "TimeInputRender.qml"
        else if (model.delegateType == AdaptiveCardEnums.CardElementType.ToggleInput)
            source = "ToggleInputRender.qml"
        else if (model.delegateType == AdaptiveCardEnums.CardElementType.ChoiceSetInput)
            source = "ChoiceSetRender.qml"
    }
}