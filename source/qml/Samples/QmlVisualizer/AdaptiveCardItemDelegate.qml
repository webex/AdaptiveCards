import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import "qrc:/"

Item {
    id: delegate
    readonly property var listView: parent.ListView.view

    signal reloadCard(var card)
    signal adaptiveCardButtonClicked(var title, var type, var data)
    signal openContextMenu(var pos, var text, var link)
    signal showToolTipifNeeded(var text, var pos)
    signal showToolTipOnElement(bool show,var text, var pos)
    signal fetchFilteredChoices(var dataSource, var text, var id)

    height: mainLayout.height
    width: listView.width

    GridLayout{
        id: mainLayout

        readonly property int margins: 0
        width: parent.width
        columns: 1

        Rectangle{
            id: frame
            color: "grey"
            radius: 8
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillWidth: true
            Layout.margins: parent.margins
            Layout.preferredHeight: cardLayout.height

            ColumnLayout{
                id: cardLayout
                width: delegate.width - 2*mainLayout.margins

                CardContent {
                    id: cardContentLoader
                    Layout.fillWidth: true
                    Layout.margins: 5
                    height: item ? item.height : 25

                    onLoaded: {
                        reloadCard.connect(item.reload)
                        item.adaptiveCardButtonClicked.connect(adaptiveCardButtonClicked)
                        item.openContextMenu.connect(openContextMenu)
                        item.showToolTipifNeeded.connect(showToolTipifNeeded)
                        item.showToolTipOnElement.connect(showToolTipOnElement)
                        item.fetchFilteredChoices.connect(fetchFilteredChoices)
                    }
                }
            }
        }
    }
}
