import QtQuick 2.15
import QtQuick.Controls 2.15
import SampleCards 1.0

Rectangle {
	id: root

	width:  400
	height: 800

	color: "gray"

    property int defaultCardIndex: 0
    property string defaultCardJSON: ""

    signal listItemClicked(var cardJson)

    SampleCardController {
        id: sampleCardController 
    }

    ListView {
        id: cardListView

        width: parent.width
        height: parent.height

        focus: true

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10

        spacing: 5
        clip: true
        model: sampleCardController.cardListModel
        
        delegate: Button {
            id: cardDelegate

		    width: cardListView.width
		    height: cardListView.height * 0.1

            background: Rectangle {
				color: cardListView.currentIndex === index ? 'orange' : 'white'
				border.width: 1
				border.color: 'black'

                radius: 5
			}

		    text: model.CardDisplayName
		    onClicked: {
			    cardListView.currentIndex = index;
                listItemClicked(model.CardJSON);
		    }
                
            onTextChanged: {
                if(model.CardDisplayName === "Empty card") {
                    defaultCardIndex = index;
                    defaultCardJSON = model.CardJSON;
                }
            }

            onActiveFocusChanged: {
				if(activeFocus) {
					listItemClicked(model.CardJSON);
				}
			}
		}

        Component.onCompleted: {
            cardListView.currentIndex = defaultCardIndex;
            listItemClicked(defaultCardJSON);
        }
    }
}

