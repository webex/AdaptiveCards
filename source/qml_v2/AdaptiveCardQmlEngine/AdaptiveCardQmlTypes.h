#include <QQmlEngine>
#include "controllers/AdaptiveCardController.h"
#include "models/AdaptiveCardModel.h"
#include "models/CollectionItemModel.h"
#include "utils/AdaptiveCardEnums.h"

namespace AdaptiveCardQmlEngine
{
    void registerAdaptiveCardTypes()
    {
        // Enums Class (Declare all the enums here itself)
        qmlRegisterUncreatableMetaObject(AdaptiveCardEnums::staticMetaObject, "AdaptiveCardQmlEngine", 1, 0, "AdaptiveCardEnums", "Error: only enums");
        
        // Controllers REGISTER ALPHABETICALLY
        qmlRegisterType<AdaptiveCardController>("AdaptiveCardQmlEngine", 1, 0, "AdaptiveCardController");
        
        // Qml Files REGISTER ALPHABETICALLY
        qmlRegisterType(QUrl("qrc:qml/AdaptiveCard.qml"), "AdaptiveCardQmlEngine", 1, 0, "AdaptiveCard");
        qmlRegisterType(QUrl("qrc:qml/AdaptiveCardItem.qml"), "AdaptiveCardQmlEngine", 1, 0, "AdaptiveCardItem");
        qmlRegisterType(QUrl("qrc:qml/CollectionItem.qml"), "AdaptiveCardQmlEngine", 1, 0, "CollectionItem");
        qmlRegisterType(QUrl("qrc:qml/CollectionItemDelegate.qml"), "AdaptiveCardQmlEngine", 1, 0, "CollectionItemDelegate");
        qmlRegisterType(QUrl("qrc:qml/WCustomFocusItem.qml"), "AdaptiveCardQmlEngine", 1, 0, "WCustomFocusItem");
        qmlRegisterSingletonType(QUrl("qrc:qml/CardConstants.qml"), "AdaptiveCardQmlEngine", 1, 0, "CardConstants");
        
        qmlRegisterType(QUrl("qrc:qml/TextBlockRender.qml"), "AdaptiveCardQmlEngine", 1, 0, "TextBlockRender");
        qmlRegisterType(QUrl("qrc:qml/DateInputRender.qml"), "AdaptiveCardQmlEngine", 1, 0, "DateInputRender");
        qmlRegisterType(QUrl("qrc:qml/DateInputTextField.qml"), "AdaptiveCardQmlEngine", 1, 0, "DateInputTextField");
        qmlRegisterType(QUrl("qrc:qml/DateInputPopout.qml"), "AdaptiveCardQmlEngine", 1, 0, "DateInputPopout");
        qmlRegisterType(QUrl("qrc:qml/ImageRender.qml"), "AdaptiveCardQmlEngine", 1, 0, "ImageRender");
        qmlRegisterType(QUrl("qrc:qml/RichTextBlockRender.qml"), "AdaptiveCardQmlEngine", 1, 0, "RichTextBlockRender");
        qmlRegisterType(QUrl("qrc:qml/DateInputRender.qml"), "AdaptiveCardQmlEngine", 1, 0, "DateInputRender");
        qmlRegisterType(QUrl("qrc:qml/DateInputTextField.qml"), "AdaptiveCardQmlEngine", 1, 0, "DateInputTextField");
        qmlRegisterType(QUrl("qrc:qml/DateInputPopout.qml"), "AdaptiveCardQmlEngine", 1, 0, "DateInputPopout");
        qmlRegisterType(QUrl("qrc:qml/NumberInputRender.qml"), "AdaptiveCardQmlEngine", 1, 0, "NumberInputRender");
        qmlRegisterType(QUrl("qrc:qml/InputFieldClearIcon.qml"), "AdaptiveCardQmlEngine", 1, 0, "InputFieldClearIcon");
        qmlRegisterType(QUrl("qrc:qml/InputLabel.qml"), "AdaptiveCardQmlEngine", 1, 0, "InputLabel");
        qmlRegisterType(QUrl("qrc:qml/InputErrorMessage.qml"), "AdaptiveCardQmlEngine", 1, 0, "InputErrorMessage");
        qmlRegisterType(QUrl("qrc:qml/TextInputRender.qml"), "AdaptiveCardQmlEngine", 1, 0, "TextInputRender");
        qmlRegisterType(QUrl("qrc:qml/SingleLineTextInputRender.qml"), "AdaptiveCardQmlEngine", 1, 0, "SingleLineTextInputRender");
        qmlRegisterType(QUrl("qrc:qml/MultiLineTextInputRender.qml"), "AdaptiveCardQmlEngine", 1, 0, "MultiLineTextInputRender");
        qmlRegisterType(QUrl("qrc:qml/TimeInputRender.qml"), "AdaptiveCardQmlEngine", 1, 0, "TimeInputRender");
        qmlRegisterType(QUrl("qrc:qml/TimeInputPopout.qml"), "AdaptiveCardQmlEngine", 1, 0, "TimeInputPopout");
        qmlRegisterType(QUrl("qrc:qml/TimeInputTextField.qml"), "AdaptiveCardQmlEngine", 1, 0, "TimeInputTextField");
        qmlRegisterType(QUrl("qrc:qml/TimePickerListView.qml"), "AdaptiveCardQmlEngine", 1, 0, "TimePickerListView");
    }
} // namespace RendererQml
