.pragma library
.import "ThemeUtils.js" as ThemeUtils

function getHorizontalAlignment(_horizontalAlignment) {
    if (_horizontalAlignment === "center")
        return Qt.AlignHCenter;
    else if (_horizontalAlignment === "right")
        return Qt.AlignRight;
    else
        return Qt.AlignLeft;
}

function getWeight(_weight, _font) {
    if (_weight === "extraLight")
        return _font.ExtraLight;
    else if (_weight === "bold")
        return _font.Bold;
    else
        return _font.Normal;
}

function selectLink(element, next) {
    let start, end;
    if (next) {
        element.cursorPosition = element.selectionEnd + 1;
        element.deselect();

        while (element.cursorPosition < element.length && element.linkAt(element.cursorRectangle.x, (element.cursorRectangle.y + element.cursorRectangle.height / 2)) === "") {
            element.cursorPosition++;
        }

        if (element.cursorPosition !== element.length) {
            start = element.selectionEnd - 1;
            element._link = element.linkAt(element.cursorRectangle.x, (element.cursorRectangle.y + element.cursorRectangle.height / 2));

            while (element.cursorPosition < element.length && element.linkAt(element.cursorRectangle.x, (element.cursorRectangle.y + element.cursorRectangle.height / 2)) === element._link) {
                element.cursorPosition++;
            }

            if (element.cursorPosition <= element.length) {
                element.cursorPosition--;

                if (element.linkAt(element.cursorRectangle.x + 1, (element.cursorRectangle.y + element.cursorRectangle.height / 2)) === element._link) {
                    element.cursorPosition++;
                }

                end = element.cursorPosition;
                element.select(start, end);
                return true;
            }
        }
    } else {
        element.cursorPosition = element.selectionStart - 1;
        element.deselect();

        while (element.cursorPosition > 0 && element.linkAt(element.cursorRectangle.x + 1, (element.cursorRectangle.y + element.cursorRectangle.height / 2)) === "") {
            element.cursorPosition--;
        }

        if (element.cursorPosition !== 0) {
            end = element.selectionStart + 1;
            element._link = element.linkAt(element.cursorRectangle.x, (element.cursorRectangle.y + element.cursorRectangle.height / 2));

            while (element.cursorPosition > 0 && element.linkAt(element.cursorRectangle.x, (element.cursorRectangle.y + element.cursorRectangle.height / 2)) === element._link) {
                element.cursorPosition--;
            }

            if (element.cursorPosition >= 0) {
                start = element.cursorPosition;
                element.select(end, start);
                return true;
            }
        }
    }

    element._accessibleText = element.cursorPosition === 0 ? element.getText(0, element.length) : ""
    element._link = ""
    return false;
}

function handleSubmitAction(paramStr, adaptiveCard, is1_3Enabled) {
    var paramJson = {};
    if (paramStr.startsWith('{') && paramStr.endsWith('}')) {
        paramJson = JSON.parse(paramStr);
    }
    else {
        if (paramStr && paramStr != "null") {
            paramJson["data"] = paramStr;
        }
    }

    var requiredElements = adaptiveCard.requiredElements;
    var submitElements = adaptiveCard.submitElements;
    var firstElement = undefined;
    var isNotSubmittable = false;

    for (var i = 0; i < requiredElements.length; i++) {
        requiredElements[i].showErrorMessage = requiredElements[i].validate();
        isNotSubmittable |= requiredElements[i].showErrorMessage;
        if (firstElement === undefined && requiredElements[i].showErrorMessage && requiredElements[i].visible) {
            firstElement = requiredElements[i];
        }
    }
    if (isNotSubmittable && is1_3Enabled) {
        if (firstElement !== undefined) {
            if (firstElement.isButtonGroup !== undefined) {
                firstElement.focusFirstButton();
            }
            else {
                firstElement.forceActiveFocus();
            }
        }
    }
    else {
        var elements = Object.assign(paramJson, submitElements)
        var paramslist = JSON.stringify(elements);
        adaptiveCard.buttonClicked("Submit action", "Action.Submit", paramslist);
    }
    return;
}


function handleToggleVisibilityAction(targetElements) {
    for (var i = 0; i < targetElements.length; i++) {
        var element = targetElements[i]["element"]
        var value = targetElements[i]["value"]
        if (value === null) {
            element.visible = !element.visible;
        } else {
            element.visible = value;
        }
    }
}

function getColorSet(colorSet, state, isDarkTheme) {
    return ThemeUtils.getColorSet(colorSet, state, isDarkTheme)
}

function onSelectionChanged(buttonGroup, isMultiSelect) {
    var values = "";
    for (var i = 0; i < buttonGroup.buttons.length; ++i) {
        if (buttonGroup.buttons[i].checked && values !== "") {
            values += ",";
        }

        if (buttonGroup.buttons[i].checked) {
            values += buttonGroup.buttons[i].value;

            if (!isMultiSelect)
                break;
        }
    }
    return values;
}


function generateStretchHeight(childrens,minHeight){
    var n = childrens.length
    var implicitHt = 0;
    var stretchCount = 0;
    var stretchMinHeight = 0;
    for(var i=0;i<childrens.length;i++)
    {
        if(typeof childrens[i].seperator !== 'undefined')
        {
            implicitHt += childrens[i].height;
            stretchMinHeight += childrens[i].height;
        }
        else
        {
            implicitHt += childrens[i].implicitHeight;
            if(typeof childrens[i].stretch !== 'undefined')
            {
                stretchCount++;
            }
            else
            {
                stretchMinHeight += childrens[i].implicitHeight;
            }
        }
    }
    stretchMinHeight = (minHeight - stretchMinHeight)/stretchCount
    for(i=0;(i<childrens.length);i++)
    {
        if(typeof childrens[i].seperator === 'undefined')
        {
            if(typeof childrens[i].stretch !== 'undefined' && typeof childrens[i].minHeight !== 'undefined')
            {
                childrens[i].minHeight = Math.max(childrens[i].minHeight,stretchMinHeight)
            }
        }
    }
    if(stretchCount > 0 && implicitHt < minHeight)
    {
        var stretctHeight = (minHeight - implicitHt)/stretchCount
        for(i=0;i<childrens.length;i++)
        {
            if(typeof childrens[i].seperator === 'undefined')
            {
                if(typeof childrens[i].stretch !== 'undefined')
                {
                    childrens[i].height = childrens[i].implicitHeight + stretctHeight
                }
            }
        }
    }
    else
    {
        for(i=0;i<childrens.length;i++)
        {
            if(typeof childrens[i].seperator === 'undefined')
            {
                if(typeof childrens[i].stretch !== 'undefined')
                {
                    childrens[i].height = childrens[i].implicitHeight
                }
            }
        }
    }
}

function generateStretchWidth(childrens,width){
    var implicitWid = 0
    var autoWid = 0
    var autoCount = 0
    var weightSum = 0
    var stretchCount = 0
    var weightPresent = 0
    for(var i=0;i<childrens.length;i++)
    {
        if(typeof childrens[i].seperator !== 'undefined')
        {
            implicitWid += childrens[i].width
        }
        else
        {
            if(childrens[i].widthProperty.endsWith("px"))
            {
                childrens[i].width = parseInt(childrens[i].widthProperty.slice(0,-2))
                implicitWid += childrens[i].width
            }
            else
            {
                if(childrens[i].widthProperty === "auto")
                {
                    autoCount++
                }
                else if(childrens[i].widthProperty === "stretch")
                {
                    stretchCount++
                    implicitWid += 50;
                }
                else
                {
                    weightPresent = 1
                    weightSum += parseInt(childrens[i].widthProperty)
                }
            }
        }
    }
    autoWid = (width - implicitWid)/(weightPresent + autoCount)
    var flags = new Array(childrens.length).fill(0)
    for(i=0;i<childrens.length;i++)
    {
        if(typeof childrens[i].seperator === 'undefined')
        {
            if(childrens[i].widthProperty === "auto")
            {
                if(childrens[i].minWidth < autoWid)
                {
                    childrens[i].width = childrens[i].minWidth
                    implicitWid += childrens[i].width
                    flags[i] = 1;
                    autoCount--;
                    autoWid = (width - implicitWid)/(weightPresent + autoCount)
                }
            }
        }
    }
    for(i=0;i<childrens.length;i++)
    {
        if(typeof childrens[i].seperator === 'undefined')
        {
            if(childrens[i].widthProperty === "auto")
            {
                if(flags[i] === 0)
                {
                    childrens[i].width = autoWid
                    implicitWid += childrens[i].width
                }
            }
            else if(childrens[i].widthProperty !== "stretch" && !childrens[i].widthProperty.endsWith("px"))
            {
                if(weightSum !== 0)
                {
                    childrens[i].width = ((parseInt(childrens[i].widthProperty)/weightSum) * autoWid)
                    implicitWid += childrens[i].width
                }
            }
        }
    }
    var stretchWidth = (width - implicitWid)/stretchCount
    for(i=0;i<childrens.length;i++)
    {
        if(typeof childrens[i].seperator === 'undefined')
        {
            if(childrens[i].widthProperty === 'stretch')
            {
                childrens[i].width = 50+stretchWidth
            }
        }
    }
}

function getMinWidth(childrens){
    var min = 0
    for(var j =0;j<childrens.length;j++)
    {
        if(typeof childrens[j].minWidth === 'undefined')
        {
            min = Math.max(min,Math.ceil(childrens[j].implicitWidth))
        }
        else
        {
            min = Math.max(min,Math.ceil(childrens[j].minWidth))
        }
    }
    return min
}

function getMinWidthActionSet(childrens,spacing){
    var min = 0
    for(var j =0;j<childrens.length;j++)
    {
        min += Math.ceil(childrens[j].implicitWidth)
    }
    min += ((childrens.length - 1)*spacing)
    return min
}

function getMinWidthFactSet(childrens, spacing){
    var min = 0
    for(var j=0;j<childrens.length;j+=2)
    {
        min = Math.max(min,childrens[j].implicitWidth + childrens[j+1].implicitWidth + spacing)
    }
    return min;
}

function getCardHeight(childrens){
    var cardHeight = 0
    for(var i=0;i<childrens.length;i++)
    {
        if(childrens[i].visible === true && childrens[i].isOpacityMask === undefined)
        {
            cardHeight += childrens[i].height;
        }
    }
    return cardHeight;
}

function horizontalAlignActionSet(actionSet, actionElements, rectangleElements) {
    var noElementsInCol = [];
    var colWidths = [];
    var wid = 0
    var noElements = 0;

    for (var i = 0; i < actionElements.length; i++) {
        let itemWidth = actionElements[i].width + (i == 0 ? 0 : actionSet.spacing);
        if (wid + itemWidth <= actionSet.width) {
            noElements++;
            wid += itemWidth;
        }
        else {
            noElementsInCol.push(noElements);
            colWidths.push(wid);
            noElements = 1;
            wid = itemWidth;
        }
        actionElements[i].anchors.left = undefined;
        actionElements[i].anchors.right = undefined;
        actionElements[i].anchors.horizontalCenter = undefined;
        rectangleElements[i].width = actionElements[i].width;
    }
    noElementsInCol.push(noElements);
    colWidths.push(wid);

    var itemNo = 0;
    for (i = 0; i < noElementsInCol.length; i++) {
        var itemStart = itemNo;
        var itemEnd = itemNo + noElementsInCol[i] - 1;
        if (itemStart < 0 || itemEnd < 0) {
            continue;
        }
        itemNo += noElementsInCol[i];
        if (itemStart === itemEnd) {
            rectangleElements[itemStart].width = actionSet.width;
            actionElements[itemStart].anchors.horizontalCenter = rectangleElements[itemStart].horizontalCenter;
        }
        else {
            var extraWidth = (actionSet.width - colWidths[i]) / 2;

            rectangleElements[itemStart].width = actionElements[itemStart].width + extraWidth;
            actionElements[itemStart].anchors.right = rectangleElements[itemStart].right;

            rectangleElements[itemEnd].width = actionElements[itemEnd].width + extraWidth;
            actionElements[itemEnd].anchors.left = rectangleElements[itemEnd].left;
        }
    }
}

function getDateFromString(text, dateFormat, regex) {
    if (!text.match(regex))
        return;

    var Months = {
        "Jan": 0,
        "Feb": 1,
        "Mar": 2,
        "Apr": 3,
        "May": 4,
        "Jun": 5,
        "Jul": 6,
        "Aug": 7,
        "Sep": 8,
        "Oct": 9,
        "Nov": 10,
        "Dec": 11
    };
    let d;

    switch (dateFormat) {
        case "MMM\/dd\/yyyy":
            d = new Date(text.slice(7, 11), Months[text.slice(0, 3)], text.slice(4, 6))
            break;
        case "dd\/MMM\/yyyy":
            d = new Date(text.slice(7, 11), Months[text.slice(3, 6)], text.slice(0, 2))
            break;
        case "yyyy\/MMM\/dd":
            d = new Date(text.slice(0, 4), Months[text.slice(5, 8)], text.slice(9, 11))
            break;
        case "yyyy\/dd\/MMM":
            d = new Date(text.slice(0, 4), Months[text.slice(8, 11)], text.slice(5, 7))
            break;
    }
    return d;
}

function escapeHtml(str) {
    const escapedStr = str
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
    return `<span>${escapedStr}</span>`
}
