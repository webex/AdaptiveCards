import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

Button {
    id: inputFieldClearIcon

    width: 16//CardConstants.inputFieldConstants.clearIconSize
    horizontalPadding: 0
    verticalPadding: 0
    icon.width: 16//CardConstants.inputFieldConstants.clearIconSize
    icon.height:16// CardConstants.inputFieldConstants.clearIconSize
    icon.color: "black"//CardConstants.inputFieldConstants.clearIconColorNormal
    icon.source:  "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAiIGhlaWdodD0iMTAiIHZpZXdCb3g9IjAgMCAxMCAxMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+Y29tbW9uLWFjdGlvbnMvY2FuY2VsXzEwPC90aXRsZT48cGF0aCBkPSJNNS43MDcyNSA1LjAwMDI1bDIuNjQ2LTIuNjQ2Yy4xOTYtLjE5Ni4xOTYtLjUxMiAwLS43MDgtLjE5NS0uMTk1LS41MTEtLjE5NS0uNzA3IDBsLTIuNjQ2IDIuNjQ3LTIuNjQ3LTIuNjQ3Yy0uMTk1LS4xOTUtLjUxMS0uMTk1LS43MDcgMC0uMTk1LjE5Ni0uMTk1LjUxMiAwIC43MDhsMi42NDcgMi42NDYtMi42NDcgMi42NDZjLS4xOTUuMTk2LS4xOTUuNTEyIDAgLjcwOC4wOTguMDk3LjIyNi4xNDYuMzU0LjE0Ni4xMjggMCAuMjU2LS4wNDkuMzUzLS4xNDZsMi42NDctMi42NDcgMi42NDYgMi42NDdjLjA5OC4wOTcuMjI2LjE0Ni4zNTQuMTQ2LjEyOCAwIC4yNTYtLjA0OS4zNTMtLjE0Ni4xOTYtLjE5Ni4xOTYtLjUxMiAwLS43MDhsLTIuNjQ2LTIuNjQ2eiIgZmlsbC1ydWxlPSJldmVub2RkIi8+PC9zdmc+"//CardConstants.clearIconImage
    Accessible.name: qsTr("Clear Input")
    Accessible.role: Accessible.Button

    background: Rectangle {
        color: 'transparent'
        radius:8 //CardConstants.inputFieldConstants.borderRadius

       /* WCustomFocusItem {
            isRectangle: true
            visible: inputFieldClearIcon.activeFocus
            designatedParent: parent
        }*/

    }

}
