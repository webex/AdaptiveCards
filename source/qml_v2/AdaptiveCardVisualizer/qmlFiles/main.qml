import QtQuick 2.3
import CardVisualizer 1.0
import SampleCards 1.0
import QtQuick.Controls 2.2
import AdaptiveCardQmlEngine 1.0

Rectangle {
    id: root

    width: 1200
    height: 600

    function setCardJSON(jsonString)
    {
        cardEditor.text = jsonString;
        cardViewer.cardJSON = jsonString;
    }

    function cardThemeSelected(currentIndex)
	{
		cardViewer.cardThemeSelectionFromUI = currentIndex;
	}

    // Card Theme ComboBox ----------
	ComboBox {
		id: comboBox

        width: parent.width * 0.2
        height: 40

		anchors.left : parent.left
        anchors.top: parent.top
        anchors.margins: 10

		model: ["Dark Theme", "Light Theme"]
		currentIndex: 0

		onCurrentIndexChanged: {
		    cardThemeSelected(comboBox.currentIndex);
		}
	}

    // Card List View ----------
    SampleCardListView {
		id: cardListView

		width: parent.width * 0.2
		height: parent.height 

		anchors.top: parent.top
        anchors.topMargin: 60
		anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.bottom: parent.bottom
		anchors.bottomMargin: 10
	}

    // Card JSON Editor ----------
    CardEditor {
        id: cardEditor

        width: parent.width * 0.3
		height: parent.height
	
        anchors.left: cardListView.right
		anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 10
    }
    
    // Card Viewer ----------
    CardViewer {
		id: cardViewer

		width: parent.width * 0.5
        height: implicitHeight

        anchors.left : cardEditor.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 10

        cardJSON: ""
        cardThemeSelectionFromUI: 0
    }

    Component.onCompleted: {
		cardListView.listItemClicked.connect(setCardJSON)
        cardEditor.renderButtonClicked.connect(setCardJSON)
	}
}
