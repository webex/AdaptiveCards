import QtQuick 2.15;
import QtQuick.Layouts 1.3;

ColumnLayout{
    id: cardComponent

    property var card
    signal adaptiveCardButtonClicked(var title, var type, var data)
    signal openContextMenu(var pos, var text, var link)
    signal showToolTipifNeeded(var text, var pos)
    signal showToolTipOnElement(bool show,var text, var pos)

    Component.onCompleted: reload(CardString);

    function reload(mCard)
    {
        if(card){
            card.destroy()
        }

        card = Qt.createQmlObject(mCard, cardComponent, "card")
        card.buttonClicked.connect(adaptiveCardButtonClicked)
        card.openContextMenu.connect(openContextMenu)
        card.showToolTipifNeeded.connect(showToolTipifNeeded)
        card.showToolTipOnElement.connect(showToolTipOnElement)
    }
}
