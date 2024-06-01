import QtQuick 2.3
import CardVisualizer 1.0
import SampleCards 1.0

Rectangle {
    id: root

    width: 1200
    height: 600

    function setJSON(jsonString)
    {
        cardEditor.text = jsonString;
    }

    SampleCardListView {
		id: cardListView

		width: parent.width * 0.2
		height: parent.height 

		anchors.top: parent.top
		anchors.left: parent.left
        anchors.bottom: parent.bottom
		anchors.margins: 10
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
        height: parent.height 

        anchors.left : cardEditor.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 10
    }

    Component.onCompleted: {
		cardListView.listItemClicked.connect(setJSON)
	}
}
