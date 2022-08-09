.pragma library

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
    if(paramStr.startsWith('{') && paramStr.endsWith('}')) {
        paramJson = JSON.parse(paramStr);
    }
    else {
        paramJson["data"] = paramStr;
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
