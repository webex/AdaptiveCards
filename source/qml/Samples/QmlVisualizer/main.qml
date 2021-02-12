import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0

Rectangle{
    id: root
    height: 800
    width: 800

    ListModel{
        id: cardModel
        ListElement { cardString: "import QtQuick 2.15; import QtQuick.Layouts 1.3; Item{ id:adaptiveCard; height: adaptiveCardRectangle.height + 30; width: parent.width; ColumnLayout{ id: adaptiveCardLayout; anchors.fill:parent; Rectangle{ id: adaptiveCardRectangle; color:'red'; Layout.margins:15; Layout.fillWidth:true; Layout.preferredHeight:40; } } }" }
    }

    Component{
        id: delegate
        Loader{
            id: loader
            source: "AdaptiveCardItemDelegate.qml"
        }
    }

    ListView{
        id: cardsList
        anchors.fill: parent
        cacheBuffer: 10000
        delegate: delegate
        model: cardModel
        clip: true
    }
}
