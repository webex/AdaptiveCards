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
        qmlRegisterType(QUrl("qrc:qml/CardConstants.qml"), "AdaptiveCardQmlEngine", 1, 0, "CardConstants");

        qmlRegisterType(QUrl("qrc:qml/TextBlockRender.qml"), "AdaptiveCardQmlEngine", 1, 0, "TextBlockRender");
        qmlRegisterType(QUrl("qrc:qml/SingleLineTextInputRender.qml"), "AdaptiveCardQmlEngine", 1, 0, "SingleLineTextInputRender");
        qmlRegisterType(QUrl("qrc:qml/InputLabel.qml"), "AdaptiveCardQmlEngine", 1, 0, "InputLabel");
        qmlRegisterType(QUrl("qrc:qml/InputErrorMessage.qml"), "AdaptiveCardQmlEngine", 1, 0, "InputErrorMessage");
        qmlRegisterType(QUrl("qrc:qml/InputFieldClearIcon.qml"), "AdaptiveCardQmlEngine", 1, 0, "InputFieldClearIcon");

    }
} // namespace RendererQml
