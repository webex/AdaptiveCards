import QtQuick 2.15;
import QtQuick.Layouts 1.3;

ColumnLayout{
    id: cardComponent
    Component.onCompleted: Qt.createQmlObject("import QtQuick 2.15; import QtQuick.Layouts 1.3; Item{ id:adaptiveCard; implicitHeight: adaptiveCardLayout.implicitHeight;width: 600; ColumnLayout{ id: adaptiveCardLayout; width: adaptiveCard.width; Rectangle{ id: adaptiveCardRectangle; color:Qt.rgba(255, 255, 255, 1.00); Layout.margins: 15; Layout.fillWidth:true; Layout.preferredHeight:400; } } }",
                                              cardComponent, "card")
}
