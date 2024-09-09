import QtQuick 2.15
import QtQuick.Controls 2.0
import AdaptiveCardQmlEngine 1.0

Loader {
    id: delegateSource

    property var parentCardItem

 //   source: "qrc:qml/TextInputRender.qml"

     Component.onCompleted :{
        if (model.delegateType == AdaptiveCardEnums.CardElementType.TextBlock)
            source = "TextBlockRender.qml"
        else if (model.delegateType == AdaptiveCardEnums.CardElementType.RichTextBlock)
            source = "RichTextBlockRender.qml"
        else if (model.delegateType == AdaptiveCardEnums.CardElementType.TextInput)
            source = "TextInputRender.qml"       
        }

    /*
    {
        switch (delegateType) {
        case AdaptiveCardEnums.CardElementType.TextBlock:
            return "TextBlockRender.qml"
        case AdaptiveCardEnums.CardElementType.Container:
            return "ContainerRender.qml"
        case AdaptiveCardEnums.CardElementType.ColumnSet:
            return "ColumnSetRender.qml"
        case AdaptiveCardEnums.CardElementType.Column:
            return "ColumnRender.qml"
        case AdaptiveCardEnums.CardElementType.ToggleInput:
            return "ToggleInputRender.qml"
        case AdaptiveCardEnums.CardElementType.ActionSet:
            return "ActionSetRender.qml"
        }
    }
    */
}
