import QtQuick 2.15
import "JSUtils/DrawUtils.js" as DrawUtils
import AdaptiveCardQmlEngine 1.0

Item {
    id: hostItem

    enum RectangularCorner {
        None = 0,
        TopLeft = 1,
        TopRight = 2,
        BottomLeft = 4,
        BottomRight = 8
    }

    property var innerFocusBorder: false
    readonly property var extraSpace: innerFocusBorder ? 0 : 5
    property var designatedParent
    property bool isRectangle: false
    property int cornerRadius: 8 // used for rectangles with rounded corners
    property var isExtraSmall // not setting this will leave the radius value to cornerRadius for rectangles with rounded corners
    property bool isSemicircle: !isRectangle
    property rect customRect: Qt.rect(0, 0, 0, 0)
    readonly property bool isCustomRect: customRect != Qt.rect(0, 0, 0, 0)
    property int rectangularCornerMask: WCustomFocusItem.RectangularCorner.None

    property var themeType: typeof (themeMode) !== "undefined" ? themeMode : "global"
    property point globalCoords
    property Item topmostParent

    function topParent(n) {
        var ret = n;
        while (ret.parent !== null)ret = ret.parent
        return ret;
    }

    function refreshCanvas(globalCoordinates) {
        topmostParent = topParent(this);
        if (designatedParent !== undefined)
            canvas.parent = designatedParent;
        else
            canvas.parent = topmostParent;
        canvas.width = width + 2 * extraSpace;
        canvas.height = height + 2 * extraSpace;
        var remappedCoords = topmostParent.mapFromGlobal(globalCoordinates);
        if (designatedParent !== undefined)
            remappedCoords = designatedParent.mapFromGlobal(globalCoordinates);

        canvas.x = remappedCoords.x - extraSpace;
        canvas.y = remappedCoords.y - extraSpace;
    }

    x: isCustomRect ? customRect.x : x
    y: isCustomRect ? customRect.y : y
    width: isCustomRect ? customRect.width : width
    height: isCustomRect ? customRect.height : height
    anchors.fill: isCustomRect ? undefined : parent
    visible: parent && parent.activeFocus
    Component.onCompleted: {
        globalCoords = Qt.binding(function() {
            var element = hostItem;
            var x = element.x;
            var y = element.y;
            while (element.parent) {
                element = element.parent;
                x += element.x;
                y += element.y;
            }
            x += element.x;
            y += element.y;
            return mapToGlobal(hostItem.x, hostItem.y);
        });
    }
    onWidthChanged: {
        refreshCanvas(globalCoords);
    }
    onHeightChanged: {
        refreshCanvas(globalCoords);
    }
    onGlobalCoordsChanged: {
        refreshCanvas(globalCoords);
    }
    onVisibleChanged: {
        if (visible) {
            canvas.visible = true;
            var gCoords = parent.mapToGlobal(this.x, this.y);
            refreshCanvas(gCoords);
        } else {
            canvas.visible = false;
        }
    }

    Canvas {
        id: canvas

        readonly property var focusOutlineMiddleColor: CardConstants.cardConstants.focusOutlineMiddleColor
        readonly property var focusOutlineOuterColor: CardConstants.cardConstants.focusOutlineOuterColor
        readonly property var focusOutlineInnerColor: CardConstants.cardConstants.focusOutlineInnerColor
        readonly property int lineThickness: 2
        readonly property int outerLineThickness: 1
        readonly property int smallRadius: 4
        readonly property int extraSmallRadius: 2
        readonly property bool isRTLEnabled: Qt.application.layoutDirection === Qt.RightToLeft

        function drawRoundedFocusOutline(ctx) {
            var innerOffset = innerFocusBorder ? -5 : 0;
            var middleOffset = innerFocusBorder ? -3 : 2;
            var outerOffset = innerFocusBorder ? -1 : 4;
            var radius = height / 2;
            if (isRectangle) {
                radius = (isExtraSmall === undefined) ? cornerRadius : (isExtraSmall ? extraSmallRadius : smallRadius);
                DrawUtils.drawRoundedCornerRectangleOutline(ctx, height, width, extraSpace, lineThickness, innerOffset, focusOutlineInnerColor, radius - outerOffset);
                DrawUtils.drawRoundedCornerRectangleOutline(ctx, height, width, extraSpace, lineThickness, middleOffset, focusOutlineMiddleColor, radius - middleOffset);
                DrawUtils.drawRoundedCornerRectangleOutline(ctx, height, width, extraSpace, outerLineThickness, outerOffset, focusOutlineOuterColor, radius - innerOffset);
            } else if (rectangularCornerMask !== WCustomFocusItem.RectangularCorner.None) {
                if (!isSemicircle)
                    radius = (isExtraSmall === undefined) ? cornerRadius : (isExtraSmall ? extraSmallRadius : smallRadius);

                const adjustedCorners = isRTLEnabled ? DrawUtils.swapRectangularCornersLeftRight(rectangularCornerMask) : rectangularCornerMask;
                DrawUtils.drawRectangularAndRoundCornerOutline(ctx, height, width, extraSpace, lineThickness, innerOffset, focusOutlineInnerColor, radius, adjustedCorners);
                DrawUtils.drawRectangularAndRoundCornerOutline(ctx, height, width, extraSpace, lineThickness, middleOffset, focusOutlineMiddleColor, radius - middleOffset, adjustedCorners);
                DrawUtils.drawRectangularAndRoundCornerOutline(ctx, height, width, extraSpace, outerLineThickness, outerOffset, focusOutlineOuterColor, radius - innerOffset - 2, adjustedCorners);
            } else {
                DrawUtils.drawRoundedSidesOutline(ctx, height, width, extraSpace, lineThickness, innerOffset, focusOutlineInnerColor);
                DrawUtils.drawRoundedSidesOutline(ctx, height, width, extraSpace, lineThickness, middleOffset, focusOutlineMiddleColor);
                DrawUtils.drawRoundedSidesOutline(ctx, height, width, extraSpace, outerLineThickness, outerOffset, focusOutlineOuterColor);
            }
        }

        onPaint: {
            var ctx = canvas.getContext('2d');
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            drawRoundedFocusOutline(ctx);
        }
        onVisibleChanged: {
            if (visible)
                requestPaint();
            else
                canvas.markDirty(Qt.rect(0, 0, canvas.width, canvas.height));
        }
    }
}
