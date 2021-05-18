/*
Example Usage:

ActionButtonColumn{
    id:button_auto_1
    text:"Action.OpenUrl"
    textfont.pixelSize:14
    bgrborder.color:button_auto_1.pressed ? '#0A5E7D' : '#007EA8'
    bgrcolor:button_auto_1.pressed ? '#0A5E7D' : button_auto_1.hovered ? '#007EA8' : 'white'
    textcolor:button_auto_1.hovered ? '#FFFFFF' : '#007EA8'
    onClicked:{
        adaptiveCard.buttonClicked("Action.OpenUrl", "Action.OpenUrl", "https://adaptivecards.io");
        console.log("https://adaptivecards.io");
    }
}
*/
import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Button{
    property bool hasIconUrl: false
    property var imgSource
    property bool isIconLeftOfTitle: true

    property bool isShowCard: false
    property bool showCard: false
    property alias showCardIconSource: button_auto_1_icon.source

    property alias bgrborder: button_id_bg.border
    property alias bgrcolor: button_id_bg.color

    property alias textcolor: text_id.color
    property alias textfont: text_id.font
    text: ""

    id: button_id
    
    background:Rectangle{
        id: button_id_bg
        anchors.fill: parent
        radius: button_id.height / 2
        border.width: 1
        border.color: button_id.pressed ? '#0A5E7D' : '#007EA8'
        color: button_id.pressed ? '#0A5E7D' : button_id.hovered ? '#007EA8' : 'white'
    }

    contentItem:Item{
        id: item_id

        implicitHeight: column_id.implicitHeight
        implicitWidth: column_id.implicitWidth
        
        Column{
            id: column_id
            spacing: 5
            leftPadding: 5
            rightPadding: 5
            
            Image{
                id: button_auto_4_img
                cache: false
                visible: button_id.hasIconUrl
                height: button_id.textfont.pixelSize
                width: button_id.textfont.pixelSize
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                source: button_id.hasIconUrl?button_id.imgSource:""
            }
            Row{
                spacing: 5
                
                Text{
                    id: text_id
                    text: button_id.text
                    font: button_id.textfont
                    color: button_id.hovered ? '#FFFFFF' : '#007EA8'
                }
                
                Item{
                    height: button_id.textfont.pixelSize
                    width: button_id.textfont.pixelSize
                    visible: button_id.isShowCard
                    
                    Image{
                        id: button_auto_1_icon
                        anchors.fill: parent
                        cache: false
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        anchors.verticalCenter: parent.verticalCenter
                        source: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+bmF2aWdhdGlvbi9hcnJvdy1kb3duXzEyPC90aXRsZT48cGF0aCBkPSJNMS4wMDA0MSAzLjQ5OTc0ODc2NGMwLS4xMzcuMDU2LS4yNzMuMTY1LS4zNzIuMjA2LS4xODUwMDAwMDAxLjUyMi0uMTY4MDAwMDAwMS43MDcuMDM3bDQuMTI4IDQuNTg2OTk5OTk2IDQuMTI4LTQuNTg2OTk5OTk2Yy4xODUtLjIwNTAwMDAwMDEuNTAxLS4yMjIwMDAwMDAxLjcwNy0uMDM3LjIwNC4xODUuMjIxLjUwMS4wMzcuNzA2bC00LjUgNC45OTk5OTk5OTZjLS4wOTYuMTA2LS4yMy4xNjYtLjM3Mi4xNjYtLjE0MiAwLS4yNzYtLjA2LS4zNzItLjE2NmwtNC41LTQuOTk5OTk5OTk2Yy0uMDg2LS4wOTUtLjEyOC0uMjE1LS4xMjgtLjMzNCIgZmlsbD0iIzAwMCIgZmlsbC1ydWxlPSJldmVub2RkIi8+PC9zdmc+"
                    }

                    ColorOverlay{
                        anchors.fill: button_auto_1_icon
                        source: button_auto_1_icon
                        color: text_id.color
                    }
                }
            }
        }
    }
    onClicked: {
        showCard = !showCard
        showCardIconSource = showCard ? "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+bmF2aWdhdGlvbi9hcnJvdy11cF8xMjwvdGl0bGU+PHBhdGggZD0iTTEuMDAwNDEgOC41MDAyNTEyMzZjMCAuMTM3LjA1Ni4yNzMuMTY1LjM3Mi4yMDYuMTg1MDAwMDAwMS41MjIuMTY4MDAwMDAwMS43MDctLjAzN2w0LjEyOC00LjU4Njk5OTk5NiA0LjEyOCA0LjU4Njk5OTk5NmMuMTg1LjIwNTAwMDAwMDEuNTAxLjIyMjAwMDAwMDEuNzA3LjAzNy4yMDQtLjE4NS4yMjEtLjUwMS4wMzctLjcwNmwtNC41LTQuOTk5OTk5OTk2Yy0uMDk2LS4xMDYtLjIzLS4xNjYtLjM3Mi0uMTY2LS4xNDIgMC0uMjc2LjA2LS4zNzIuMTY2bC00LjUgNC45OTk5OTk5OTZjLS4wODYuMDk1LS4xMjguMjE1LS4xMjguMzM0IiBmaWxsPSIjMDAwIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiLz48L3N2Zz4=":"data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+bmF2aWdhdGlvbi9hcnJvdy1kb3duXzEyPC90aXRsZT48cGF0aCBkPSJNMS4wMDA0MSAzLjQ5OTc0ODc2NGMwLS4xMzcuMDU2LS4yNzMuMTY1LS4zNzIuMjA2LS4xODUwMDAwMDAxLjUyMi0uMTY4MDAwMDAwMS43MDcuMDM3bDQuMTI4IDQuNTg2OTk5OTk2IDQuMTI4LTQuNTg2OTk5OTk2Yy4xODUtLjIwNTAwMDAwMDEuNTAxLS4yMjIwMDAwMDAxLjcwNy0uMDM3LjIwNC4xODUuMjIxLjUwMS4wMzcuNzA2bC00LjUgNC45OTk5OTk5OTZjLS4wOTYuMTA2LS4yMy4xNjYtLjM3Mi4xNjYtLjE0MiAwLS4yNzYtLjA2LS4zNzItLjE2NmwtNC41LTQuOTk5OTk5OTk2Yy0uMDg2LS4wOTUtLjEyOC0uMjE1LS4xMjgtLjMzNCIgZmlsbD0iIzAwMCIgZmlsbC1ydWxlPSJldmVub2RkIi8+PC9zdmc+"

    }
}
