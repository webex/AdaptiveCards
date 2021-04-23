import QtQuick 2.15

Text{
	//LIMITATION: Elide and maximumLineCount property do not work for textFormat: Text.MarkdownText
    clip: true
    textFormat: Text.MarkdownText
	elide: Text.ElideRight
    horizontalAlignment: Qt.AlignLeft
}
