import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Window 2.15
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.15

// Exposed from the AdaptiveCardQmlEngine module
import AdaptiveCardQmlEngine 1.0

// JS Utils
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils;

// Root of the card
Rectangle {
    id: adaptiveCard

    // Main controller instantiated for the AdaptiveCard
    AdaptiveCardController{
        id: adaptiveCardController
    }

    // Card root model -----
    property var cardRootModel: adaptiveCardController.adaptiveCardModel
    
    // Card body model -----
    property var cardBodyModel: cardRootModel.cardBodyModel
    
    // Properties for the main card -----
    property string cardJSON
    property int cardTheme
    
    width: parent.width
    border.width: 1

    radius: 8
    color : cardRootModel.backgroundColor

    Image {
        id: backGroundImage

        width: parent.width
        height: parent.height

        visible : false
        source: ""
    }

    Component.onCompleted: {
        CardConstants.isDarkTheme = true
    }

    // Collection of all the items in the card -----
    CollectionItem {
        id: collectionItem
    
        height: Math.max(implicitHeight, cardRootModel.minHeight, 12)
        clip: true

        collectionItemModel: cardBodyModel
        onHeightChanged: {
			adaptiveCard.height = height
		}

        onWidthChanged: {
            adaptiveCard.width = width
        }
    }

    // Passing properties to the AdaptiveCardController
    onCardJSONChanged: {
		adaptiveCardController.setCardTheme(cardTheme)
        adaptiveCardController.setCardJSON(cardJSON)
	}

    onCardThemeChanged: {
        adaptiveCardController.setCardTheme(cardTheme)
        adaptiveCardController.setCardJSON(cardJSON)
	}
}
