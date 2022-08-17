import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtGraphicalEffects 1.15
import QtQuick 2.15

Rectangle {
    id: imageRender

    property var _adaptiveCard
    property string _bgColorRect
    property bool _isImage: true
    property string _sourceImage
    property bool _stretchRect: false
    property bool _visibleRect: false
    property string _layerEffect
    property bool _layerEnabled: false
    property int _radius
    property bool _anchorCenter: false
    property bool _anchorRight: false
    property int _imageWidth
    property string _paramStr: ""
    property bool _is1_3Enabled: false
    property string _selectActionId: ""
    property bool _hoverEnabled: false
    property int aspectWidth: image.implicitWidth / image.implicitHeight * height
    property string _actionHoverColor: "transparent"
    property var _toggleVisibilityTarget: null

    visible: _visibleRect
    width: (parent.width > 0 && parent.width < _imageWidth) ? parent.width : _imageWidth
    implicitHeight: image.implicitHeight / image.implicitWidth * width
    color: _bgColorRect
    implicitWidth: image.implicitWidth
    anchors.horizontalCenter: _anchorCenter ? parent.horizontalCenter : undefined
    anchors.right: _anchorRight ? parent.right : undefined
    layer.enabled: _layerEnabled
    radius: _radius

    Image {
        id: image

        property bool isImage: _isImage

        source: _sourceImage
        cache: false
        anchors.fill: parent
        visible: parent.visible
    }

    MouseArea {
        id: mouseArea

        function handleMouseAreaClick() {
            if(_selectActionId ===  'Action.ToggleVisibility') {
                AdaptiveCardUtils.handleToggleVisibilityAction(_toggleVisibilityTarget);
                return ;
            } else if (_selectActionId === 'Action.Submit') {
                AdaptiveCardUtils.handleSubmitAction(_paramStr, _adaptiveCard, _is1_3Enabled);
                return ;
            } else {
                _adaptiveCard.buttonClicked('', 'Action.OpenUrl', _selectActionId);
                return ;
            }
        }

        function getAccessibleName() {
            var accessibleName = 'Image ';
            accessibleName += (_selectActionId === 'Action.Submit' || _selectActionId === 'Action.ToggleVisibility') ? _selectActionId : ('Action.OpenUrl');
            return accessibleName;
        }

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        hoverEnabled: _hoverEnabled
        activeFocusOnTab: _hoverEnabled
        Accessible.name: getAccessibleName()
        onEntered: {
            imageRender.color = hoverEnabled ? _actionHoverColor : undefined;
        }
        onExited: {
            imageRender.color = hoverEnabled ? 'transparent' : undefined;
        }
        onClicked: {
            handleMouseAreaClick();
        }
        Keys.onPressed: {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
                handleMouseAreaClick();
                event.accepted = true;
            }
        }
        onActiveFocusChanged: {
            activeFocus ? mouseArea.entered() : mouseArea.exited();
        }
    }

    layer.effect: OpacityMask {
        readonly property bool isOpacityMask: _layerEnabled

        maskSource: Rectangle {
            x: imageRender.x
            y: imageRender.y
            width: imageRender.width
            height: imageRender.height
            radius: imageRender.radius
        }

    }

}
