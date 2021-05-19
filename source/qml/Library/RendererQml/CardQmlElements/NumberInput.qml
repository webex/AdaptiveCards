/*
Momentum Icon Used: 
Name- arrow-up, Color-Black, Size-12
Name- arrow-down, Color-Black, Size-12

Example Usage

NumberInput{
    id:number
    width:200
    bgrcolor:'#FFFFFF'
    textfont.pixelSize:14
    textcolor:'#171B1F'
    placeholderText:"Enter a number"
    hasDefaultValue:true
    defaultValue:3
    from:1
    to:10
    value:3
}
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

SpinBox{
    id: number
    
    property alias bgrcolor: backgroundRectangle.color
    property alias textcolor: number_contentItem.color
    property alias textfont: number_contentItem.font
    property alias placeholderText: number_contentItem.placeholderText
    property bool hasDefaultValue: false
    property int defaultValue

    padding: 0
    stepSize: 1
    editable: true
    validator: DoubleValidator{}

    valueFromText: function(text, locale){
        return Number(text)
    }

    contentItem: TextField{
        id: number_contentItem
        
        font.pixelSize: 14
        anchors.left: parent.left
        selectByMouse: true
        selectedTextColor: 'white'
        readOnly: !number.editable
        validator: number.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly
        text: number.value
        placeholderText: ""
        background: Rectangle{
            color: 'transparent'
        }

        onEditingFinished:{ 
            if(text < number.from || text > number.to)
            {
                remove(0,length)
                if(number.hasDefaultValue)
                    insert(0, number.defaultValue)
                else
                    insert(0, number.from)
            }
        }
        color: '#171B1F'
    }

    background: Rectangle{
        id: backgroundRectangle
        
        radius: 5
        color: '#FFFFFF'
        border.color: number_contentItem.activeFocus? 'black' : 'grey'
        layer.enabled: number_contentItem.activeFocus ? true : false
        layer.effect: Glow{
            samples: 25
            color: 'skyblue'
        }
    }

    up.indicator: Rectangle{
        width: 20
        height: parent.height/2
        x: number.mirrored ? 0 : parent.width - width
        radius: 5
        color: number.up.pressed ? '#08000000' : 'transparent'
        
        Image{
            id: up_arrow_icon
            source: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+bmF2aWdhdGlvbi9hcnJvdy11cF8xMjwvdGl0bGU+PHBhdGggZD0iTTEuMDAwNDEgOC41MDAyNTEyMzZjMCAuMTM3LjA1Ni4yNzMuMTY1LjM3Mi4yMDYuMTg1MDAwMDAwMS41MjIuMTY4MDAwMDAwMS43MDctLjAzN2w0LjEyOC00LjU4Njk5OTk5NiA0LjEyOCA0LjU4Njk5OTk5NmMuMTg1LjIwNTAwMDAwMDEuNTAxLjIyMjAwMDAwMDEuNzA3LjAzNy4yMDQtLjE4NS4yMjEtLjUwMS4wMzctLjcwNmwtNC41LTQuOTk5OTk5OTk2Yy0uMDk2LS4xMDYtLjIzLS4xNjYtLjM3Mi0uMTY2LS4xNDIgMC0uMjc2LjA2LS4zNzIuMTY2bC00LjUgNC45OTk5OTk5OTZjLS4wODYuMDk1LS4xMjguMjE1LS4xMjguMzM0IiBmaWxsPSIjMDAwIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiLz48L3N2Zz4="
            anchors.centerIn: parent
        }

        ColorOverlay{
                anchors.fill: up_arrow_icon
                source: up_arrow_icon
                color: number.textcolor
        }
    }

    down.indicator: Rectangle{
        width: 20
        height: parent.height/2
        x: number.mirrored ? 0 : parent.width - width
        y: parent.height/2
        radius: 5
        color: number.down.pressed ? '#08000000' : 'transparent'
        
        Image{
            id: down_arrow_icon

            source: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+bmF2aWdhdGlvbi9hcnJvdy1kb3duXzEyPC90aXRsZT48cGF0aCBkPSJNMS4wMDA0MSAzLjQ5OTc0ODc2NGMwLS4xMzcuMDU2LS4yNzMuMTY1LS4zNzIuMjA2LS4xODUwMDAwMDAxLjUyMi0uMTY4MDAwMDAwMS43MDcuMDM3bDQuMTI4IDQuNTg2OTk5OTk2IDQuMTI4LTQuNTg2OTk5OTk2Yy4xODUtLjIwNTAwMDAwMDEuNTAxLS4yMjIwMDAwMDAxLjcwNy0uMDM3LjIwNC4xODUuMjIxLjUwMS4wMzcuNzA2bC00LjUgNC45OTk5OTk5OTZjLS4wOTYuMTA2LS4yMy4xNjYtLjM3Mi4xNjYtLjE0MiAwLS4yNzYtLjA2LS4zNzItLjE2NmwtNC41LTQuOTk5OTk5OTk2Yy0uMDg2LS4wOTUtLjEyOC0uMjE1LS4xMjgtLjMzNCIgZmlsbD0iIzAwMCIgZmlsbC1ydWxlPSJldmVub2RkIi8+PC9zdmc+"
            anchors.centerIn: parent    
        }

        ColorOverlay{
                anchors.fill: down_arrow_icon
                source: down_arrow_icon
                color: number.textcolor
        }
    }
}