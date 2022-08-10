import QtQuick 2.15

Rectangle {
    id: separator

    readonly property bool seperator: true
    property bool _isColElement: false
    property bool _lineVisible: false
    property int _height: 1
    property int _lineThickness: 1
    property string _lineColor: "#B2000000"
    property var _visible: true

    width: parent.width
    height: _height
    color: "transparent"
    visible: _visible
    Component.onCompleted: {
        if (_isColElement) {
            width = _height;
            height = parent.height;
        }
    }

    Rectangle {
        width: parent.width
        height: _lineThickness
        anchors.centerIn: parent
        color: _lineColor
        visible: _lineVisible
        Component.onCompleted: {
            if (_isColElement) {
                width = _lineThickness;
                height = parent.height;
            }
        }
    }

}
