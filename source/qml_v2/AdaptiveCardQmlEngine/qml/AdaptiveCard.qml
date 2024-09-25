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

    // Background image container rect. 
    Rectangle {
       id: imageRect

       width: parent.width
       height: parent.height
       visible : cardRootModel.hasBackgroundImage

       color: "transparent"

       Image {
            id: backGroundImage
   
            anchors.fill: parent 

            visible: parent.visible
            source: cardRootModel.backgroundImageSource

            fillMode: cardRootModel.fillMode == "Cover" ? Image.PreserveAspectCrop : cardRootModel.fillMode == "Tile" ? Image.Tile : cardRootModel.fillMode == "TileHorizontally" ? Image.TileHorizontally : cardRootModel.fillMode == "TileVertically" ?  Image.TileVertically : Image.PreserveAspectFit

            anchors {
                top :  cardRootModel.imageVerticalAlignment == "top" ?  parent.top : undefined
                verticalCenter : cardRootModel.imageVerticalAlignment == "center" ? parent.verticalCenter : undefined
                bottom : cardRootModel.imageVerticalAlignment == "bottom" ? parent.bottom : undefined
                left : cardRootModel.imageHorizontalAlignment == "left" ? parent.left : undefined
                horizontalCenter : cardRootModel.imageHorizontalAlignment == "center" ? parent.horizontalCenter : undefined
                right : cardRootModel.imageHorizontalAlignment == "right" ? parent.right : undefined
            }    
        }
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
         // Update the card theme
        if (cardTheme == 0) {
                CardConstants.isDarkTheme = true
        } else {
                CardConstants.isDarkTheme = false
        }
	}
}
