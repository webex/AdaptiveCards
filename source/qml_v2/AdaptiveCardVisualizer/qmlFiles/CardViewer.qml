import QtQuick 2.15
import QtQuick.Controls 2.15

import AdaptiveCardQmlEngine 1.0

Rectangle {
	id: root

	width : 800
	height: 200

	property alias cardJSON: adaptiveCard.cardJSON
	property int cardThemeSelectionFromUI

	color: "black"
	border.color: "white"

	clip: true

	Flickable {
		id: flickable

		width: parent.width * 0.95
		height: parent.height * 0.95

		anchors.centerIn: parent

		clip: true

		contentWidth: adaptiveCard.width
		contentHeight: adaptiveCard.height

		ScrollBar.vertical: ScrollBar {
			policy: ScrollBar.WhenNeeded
		}

		ScrollBar.horizontal: ScrollBar {
			policy: ScrollBar.WhenNeeded
		}

		boundsBehavior: Flickable.StopAtBounds
		
		onContentHeightChanged: {
			contentY = 0
		}

		AdaptiveCard {
			id: adaptiveCard

			cardJSON: ""
			cardTheme: 0

			width: parent.width
			height: implicitHeight

			anchors.margins: 40
		}
	}

	onCardThemeSelectionFromUIChanged: {
		adaptiveCard.cardTheme = cardThemeSelectionFromUI
	}
}
