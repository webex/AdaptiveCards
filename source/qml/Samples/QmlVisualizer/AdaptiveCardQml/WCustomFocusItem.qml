import QtQuick 2.15
import AdaptiveCards 1.0

Rectangle{
    id: focusItem

    property var designatedParent: parent;
    property bool isRectangle: true
    property int customRadius: 8
    property int totalOffset: 6;
    property int halfOffset: 3;

    color: "transparent"
    x: designatedParent.x - halfOffset
    y: designatedParent.y - halfOffset
    width: designatedParent.width + totalOffset;
    height: designatedParent.height + totalOffset;
    radius: designatedParent.radius ? designatedParent.radius : customRadius

    //anchors.fill: isRectangle ? undefined : designatedParent

    border.width: 2
    border.color: CardConstants.inputFieldConstants.borderColorOnFocus
    visible: designatedParent.activeFocus
    z: 1000
}
