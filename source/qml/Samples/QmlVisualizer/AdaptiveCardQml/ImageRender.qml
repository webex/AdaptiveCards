import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtGraphicalEffects 1.15
import QtQuick 2.15

Rectangle {
    id: imageRender

    property var _adaptiveCard
    property color _bgColorRect : 'transparent'
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
    property string _selectActionId: ""
    property bool _hoverEnabled: false
    property int aspectWidth: image.implicitWidth / image.implicitHeight * height
    property string _actionHoverColor: "transparent"
    property var _toggleVisibilityTarget: null
    property bool _hasAssociatedInputs: false

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
            if (_selectActionId === 'Action.ToggleVisibility') {
                AdaptiveCardUtils.handleToggleVisibilityAction(_toggleVisibilityTarget);
                return ;
            } else if (_selectActionId === 'Action.Submit') {
                AdaptiveCardUtils.handleSubmitAction(_paramStr, _adaptiveCard, _hasAssociatedInputs);
                return ;
            } else if(_selectActionId === 'Action.OpenUrl'){
                _adaptiveCard.buttonClicked('', 'Action.OpenUrl', _selectActionId);
                return ;
            }
        }

        function getAccessibleName() {
            var accessibleName = 'Image has ';
            accessibleName +=  (_selectActionId === 'Action.Submit' || _selectActionId === 'Action.ToggleVisibility') ? _selectActionId : ('Action.OpenUrl ' + _selectActionId);
            accessibleName += '. To activate press space bar.';
            return accessibleName;
        }

        function handleBgColor() {
            imageRender.color = (hoverEnabled && (containsMouse || activeFocus)) ? _actionHoverColor : _bgColorRect
        }

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        hoverEnabled: _hoverEnabled
        activeFocusOnTab: _hoverEnabled
        Accessible.name: getAccessibleName()
        onContainsMouseChanged: handleBgColor()
        onActiveFocusChanged: handleBgColor()
        cursorShape: hoverEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            handleMouseAreaClick();
        }
        Keys.onPressed: {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
                handleMouseAreaClick();
                event.accepted = true;
            }
        }

        WCustomFocusItem{
            isRectangle: true
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
