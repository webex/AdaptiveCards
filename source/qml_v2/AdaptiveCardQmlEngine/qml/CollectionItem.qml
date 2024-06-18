import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0

ColumnLayout {
    id: collectionItem
    
    width: parent.width
    
    property var collectionItemModel

    Repeater {
        model: collectionItemModel
        delegate: CollectionItemDelegate {
            Layout.fillWidth: true
            Layout.margins: 12
        }
    }
}
