import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

Item {
    id: imageRender
    property var imageModel: model.imageRole
    
    width: imageRect.width
    height: imageRect.height
 
    Rectangle {
        id: imageRect
	
        activeFocusOnTab: true

        width: imageModel.imageWidth != 0 ? imageModel.imageWidth : parent.width
        height: imageModel.imageHeight != 0 ? imageModel.imageHeight : parent.width
        
        color: imageModel.bgColor != "" ? imageModel.bgColor : "transparent"
        radius: imageModel.radius

        visible: imageModel.visibleRect

        anchors {
            left: imageModel.anchorLeft ? parent.left : undefined
            horizontalCenter: imageModel.anchorCenter ? parent.horizontalCenter : undefined
            right: imageModel.anchorRight ? parent.right : undefined
        }

        clip: true
        layer.enabled: true

        layer.effect: OpacityMask {
            readonly property bool isOpacityMask: true

            maskSource: Rectangle {
                x: imageRender.x
                y: imageRender.y
            
                width: imageRender.width
                height: imageRender.height

                radius: imageRender.radius
            }
        }
        
        Image {
            id: image

            source:imageModel.sourceImage
            anchors.fill: parent

            cache: false
            visible: parent.visible
        }

        MouseArea {
            id: mouseArea

            function handleMouseAreaClick() {
                if (model.actionType === "Action.ToggleVisibility") {
                    return ;
                } else if (model.actionType === "Action.Submit") {
                    return ;
                } else if(model.actionType === "Action.OpenUrl") {
                    return ;
                }
            }

            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            hoverEnabled: model.isHoverEnabled
            cursorShape: model.isHoverEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        
            onClicked: {
                handleMouseAreaClick();
            }

            Keys.onPressed: {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
                    handleMouseAreaClick();
                    event.accepted = true;
                }
            }
        }
    }
}

