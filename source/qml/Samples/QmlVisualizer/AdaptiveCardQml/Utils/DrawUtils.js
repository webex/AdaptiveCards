.pragma library

function drawRoundedSidesOutline(ctx, height, width, extraSpace, lineThickness, offset, color) {
    if (height > width)
    {
        drawRoundedCornerRectangleOutline(ctx, height, width, extraSpace, lineThickness, offset, color, 4);
        return;
    }
    const originalHeight = height - 2 * extraSpace;
    const outlineArcRadius = originalHeight / 2 + offset + lineThickness / 2;
    const bordersOffset = extraSpace - offset - lineThickness / 2; 
    const yCoordinates = height / 2;
    ctx.beginPath();
    ctx.strokeStyle = color;
    ctx.moveTo(yCoordinates, bordersOffset);
    ctx.lineTo(width - yCoordinates, bordersOffset);
    ctx.arc(width - yCoordinates, yCoordinates, outlineArcRadius, 1.5 * Math.PI, 0.5 * Math.PI, false);
    ctx.lineTo(yCoordinates, extraSpace + originalHeight + offset + lineThickness / 2);
    ctx.arc(yCoordinates, yCoordinates, outlineArcRadius, 0.5 * Math.PI, 1.5 * Math.PI, false);
    ctx.lineWidth = lineThickness;
    ctx.stroke();
}

function drawRoundedCornerRectangleOutline(ctx, height, width, extraSpace, lineThickness, offset, color, radius) {
    radius = radius < 0 ? 0 : radius;
    const bordersOffset = extraSpace - offset - lineThickness / 2;
    const radiusOffset = radius + bordersOffset;
    const rightXCoordinates = width - radius - bordersOffset;
    const rightYCoordinates = height - radius - bordersOffset;
    ctx.beginPath();
    ctx.strokeStyle = color;
    ctx.moveTo(radiusOffset, bordersOffset);
    ctx.lineTo(rightXCoordinates, bordersOffset);
    ctx.arc(rightXCoordinates, radiusOffset, radius, 1.5 * Math.PI, 0, false);
    ctx.lineTo(width - bordersOffset, rightYCoordinates);
    ctx.arc(rightXCoordinates, rightYCoordinates, radius, 0, 0.5 * Math.PI, false);
    ctx.lineTo(radiusOffset, height - bordersOffset);
    ctx.arc(radiusOffset, rightYCoordinates, radius, 0.5 * Math.PI, Math.PI, false);
    ctx.lineTo(bordersOffset, radiusOffset);
    ctx.arc(radiusOffset, radiusOffset, radius, Math.PI, 1.5 * Math.PI, false);
    ctx.lineWidth = lineThickness;
    ctx.stroke();
}

const RectangularCorners = {
    None: 0,
    TopLeft: 1,
    TopRight: 2,
    BottomLeft: 4,
    BottomRight: 8
}

function swapRectangularCornersLeftRight(corners) {
    var reversedCorners = RectangularCorners.None;

    if (corners & RectangularCorners.TopLeft) {
        reversedCorners |= RectangularCorners.TopRight;
    }
    if (corners & RectangularCorners.TopRight) {
        reversedCorners |= RectangularCorners.TopLeft;
    }
    if (corners & RectangularCorners.BottomLeft) {
        reversedCorners |= RectangularCorners.BottomRight;
    }
    if (corners & RectangularCorners.BottomRight) {
        reversedCorners |= RectangularCorners.BottomLeft;
    }

    return reversedCorners;
}

function drawRectangularAndRoundCornerOutline(ctx, height, width, extraSpace, lineThickness, offset, color, radius, corners)
{
    const bordersOffset = extraSpace - offset - lineThickness / 2;
    radius -= bordersOffset;
    radius = radius < 0 ? 0 : radius;
    const radiusOffset = radius + bordersOffset;
    const rightXCoordinates = width - radius - bordersOffset;
    const rightYCoordinates = height - radius - bordersOffset;
    ctx.beginPath();
    ctx.strokeStyle = color;

    if (corners & RectangularCorners.TopLeft)
    {
        ctx.moveTo(bordersOffset, bordersOffset);
    }
    else
    {
        ctx.moveTo(radiusOffset, bordersOffset);       
    }  


    if (corners & RectangularCorners.TopRight)
    {
        ctx.lineTo(width - bordersOffset, bordersOffset);
    }
    else
    {
        ctx.lineTo(rightXCoordinates, bordersOffset);
        ctx.arc(rightXCoordinates, radiusOffset, radius, 1.5 * Math.PI, 0, false);
    }

    if (corners & RectangularCorners.BottomRight)
    {
        ctx.lineTo(width - bordersOffset, height - bordersOffset);
    }
    else
    {
        ctx.lineTo(width - bordersOffset, rightYCoordinates);
        ctx.arc(rightXCoordinates, rightYCoordinates, radius, 0, 0.5 * Math.PI, false);
    }

    if (corners & RectangularCorners.BottomLeft)
    {
        ctx.lineTo(bordersOffset, height-bordersOffset);
    }
    else
    {
        ctx.lineTo(radiusOffset, height - bordersOffset);
        ctx.arc(radiusOffset, rightYCoordinates, radius, 0.5 * Math.PI, Math.PI, false);
    }

    if (corners & RectangularCorners.TopLeft)
    {
        ctx.lineTo(bordersOffset, bordersOffset);
    }
    else
    {
        ctx.lineTo(bordersOffset, radiusOffset);
        ctx.arc(radiusOffset, radiusOffset, radius, Math.PI, 1.5 * Math.PI, false);
    }

    ctx.lineWidth = lineThickness;
    ctx.stroke(); 
}
