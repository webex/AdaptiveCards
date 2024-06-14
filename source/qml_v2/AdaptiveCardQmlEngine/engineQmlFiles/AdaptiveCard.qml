import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import AdaptiveCards 1.0

Rectangle{
    id: adaptiveCard
    border.width: 1
    height: collectionItem.height
    width: parent.width
    radius: 8

    property var cardModel: adaptiveCardController.adaptiveCardModel
    property var cardBodyModel: cardModel.cardBodyModel

    AdaptiveCardController{
        id: adaptiveCardController
    }
}
