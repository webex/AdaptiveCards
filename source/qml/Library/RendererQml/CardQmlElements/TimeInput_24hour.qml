/*
Momentum Icon Used:
Name- recents-presence-stroke, Color-Black, Size-30

Example Usage

TimeInput_24hour{
    id:time2
    placeholderText:"Select time"
    color:'#171B1F'
    width:200
    text:"15:30"           //Must always set this property in hh:mm format
    selectedTime:"15:30"   //Must always set this property in hh:mm format
    bgrcolor:'#FFFFFF'
}
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "QmlHelperFunctions.js" as QmlHelperFunctions

TextField{
    id: time_ID
    
    property string selectedTime
    property alias bgrcolor: backgroundRectangle.color
    
    selectByMouse: true
    selectedTextColor: 'white'
    placeholderText: ""
    color: '#171B1F'
    validator: RegExpValidator { regExp: /^(--|[01][0-9|-]|2[0-3|-]):(--|[0-5][0-9|-])$/}
    text: ""
    onFocusChanged:{
        QmlHelperFunctions.TimeInput_24hour_onFocusChanged()
    }
    onTextChanged: {
        QmlHelperFunctions.TimeInput_24hour_onTextChanged()
    }
    background: Rectangle{
        id: backgroundRectangle
        
        radius: 5
        color: '#FFFFFF'
        border.color: time_ID.activeFocus? 'black' : 'grey'
        border.width: 1
        layer.enabled: time_ID.activeFocus ? true : false
        layer.effect: Glow{
            samples: 25
            color: 'skyblue'
        }
    }

    MouseArea{
        height: parent.height
        //Hardocded width to avoid stretching in case height of TextBlock is stretched
        width: 30
        anchors.right: parent.right
        enabled: true
        onClicked: {
            QmlHelperFunctions.TimeInput_24hour_onClicked()
        }
        
        Image{
            id: time_icon

            anchors.fill: parent
            anchors.margins: 5
            fillMode: Image.PreserveAspectFit
            mipmap: true
            source: "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjxzdmcgd2lkdGg9IjMwcHgiIGhlaWdodD0iMzBweCIgdmlld0JveD0iMCAwIDMwIDMwIiB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPg0KICAgIDwhLS0gR2VuZXJhdG9yOiBTa2V0Y2ggNjAuMSAoODgxMzMpIC0gaHR0cHM6Ly9za2V0Y2guY29tIC0tPg0KICAgIDx0aXRsZT5waG9uZS9yZWNlbnRzLXByZXNlbmNlLXN0cm9rZV8zMDwvdGl0bGU+DQogICAgPGRlc2M+Q3JlYXRlZCB3aXRoIFNrZXRjaC48L2Rlc2M+DQogICAgPGcgaWQ9InBob25lL3JlY2VudHMtcHJlc2VuY2Utc3Ryb2tlXzMwIiBzdHJva2U9Im5vbmUiIHN0cm9rZS13aWR0aD0iMSIgZmlsbD0ibm9uZSIgZmlsbC1ydWxlPSJldmVub2RkIj4NCiAgICAgICAgPHBhdGggZD0iTTE1LjAwMDIsMC4wMDAxIEM2LjcyNzkxNTI1LDAuMDAwMSAwLjAwMDIsNi43Mjc4MTUyNSAwLjAwMDIsMTUuMDAwMSBDMC4wMDAyLDIzLjI3MjM4NDcgNi43Mjc5MTUyNSwzMC4wMDAxIDE1LjAwMDIsMzAuMDAwMSBDMjMuMjcyNDg0NywzMC4wMDAxIDMwLjAwMDIsMjMuMjcyMzg0NyAzMC4wMDAyLDE1LjAwMDEgQzMwLjAwMDIsNi43Mjc4MTUyNSAyMy4yNzI0ODQ3LDAuMDAwMSAxNS4wMDAyLDAuMDAwMSBaIE0xNS4wMDAyLDEuMDAwMSBDMjIuNzIwMiwxLjAwMDEgMjkuMDAwMiw3LjI4MDEgMjkuMDAwMiwxNS4wMDAxIEMyOS4wMDAyLDIyLjcyMDEgMjIuNzIwMiwyOS4wMDAxIDE1LjAwMDIsMjkuMDAwMSBDNy4yODAyLDI5LjAwMDEgMS4wMDAyLDIyLjcyMDEgMS4wMDAyLDE1LjAwMDEgQzEuMDAwMiw3LjI4MDEgNy4yODAyLDEuMDAwMSAxNS4wMDAyLDEuMDAwMSBaIE0xOS4zMjQyLDIwLjkxMjEgQzE5LjIyNjIsMjEuMDEwMSAxOS4wOTgyLDIxLjA1ODEgMTguOTcwMiwyMS4wNTgxIEMxOC44NDMyLDIxLjA1ODEgMTguNzE1MiwyMS4wMTAxIDE4LjYxNzIsMjAuOTEyMSBMMTQuODc5MiwxNy4xNzQxIEMxNC42MzgyLDE2LjkzMzEgMTQuNTAwMiwxNi42MDAxIDE0LjUwMDIsMTYuMjYwMSBMMTQuNTAwMiw3Ljg1MzEgQzE0LjUwMDIsNy41NzYxIDE0LjcyMzIsNy4zNTMxIDE1LjAwMDIsNy4zNTMxIEMxNS4yNzYyLDcuMzUzMSAxNS41MDAyLDcuNTc2MSAxNS41MDAyLDcuODUzMSBMMTUuNTAwMiwxNi4yNjAxIEMxNS41MDAyLDE2LjMzNzEgMTUuNTMxMiwxNi40MTIxIDE1LjU4NjIsMTYuNDY3MSBMMTkuMzI0MiwyMC4yMDUxIEMxOS41MTkyLDIwLjQwMDEgMTkuNTE5MiwyMC43MTcxIDE5LjMyNDIsMjAuOTEyMSIgaWQ9ImZpbGwiIGZpbGw9IiMxNzFCMUYiPjwvcGF0aD4NCiAgICA8L2c+DQo8L3N2Zz4="    
        }

        ColorOverlay{
            anchors.fill: time_icon
            source: time_icon
            color: time_ID.color
        }
    }
    
    Rectangle{
        id: time_ID_timeBox
        
        anchors.topMargin: 1
        anchors.left: parent.left
        anchors.top: parent.bottom
        width: 105
        height: 200
        visible: false
        layer.enabled: true
        layer.effect: Glow{
            samples: 25
            color: 'skyblue'
        }

        ListView{
            id: time_ID_hours
            
            width: 45
            height: parent.height-10
            anchors.margins: 5
            anchors.top: parent.top
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            anchors.left: parent.left
            model: 24
            delegate: Rectangle{
                width: 45
                height: 45
                color: time_ID_hours.currentIndex == index ? "blue" : time_ID_hoursmouseArea.containsMouse? "lightblue" : "white"
                
                MouseArea{
                    id: time_ID_hoursmouseArea
                    
                    anchors.fill: parent
                    enabled: true
                    hoverEnabled: true
                    onClicked: {
                        time_ID_hours.currentIndex = index;
                        var x = String(index).padStart(2, '0') ;
                        time_ID.insert(0,x);
                    }
                }
                
                Text{
                    text: String(index).padStart(2, '0')
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: time_ID_hours.currentIndex == index ? "white" : "black"
                }
            }

        }
        
        ListView{
            id: time_ID_min
            
            width: 45
            height: parent.height-10
            anchors.margins: 5
            anchors.top: parent.top
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            anchors.left: time_ID_hours.right
            model: 60
            delegate: Rectangle{
                width: 45
                height: 45
                color: time_ID_min.currentIndex == index ? "blue" : time_ID_minmouseArea.containsMouse? "lightblue" : "white"
                
                MouseArea{
                    id: time_ID_minmouseArea
                    
                    anchors.fill: parent
                    enabled: true
                    hoverEnabled: true
                    onClicked:{
                        time_ID_min.currentIndex = index;
                        var x = String(index).padStart(2, '0');
                        time_ID.insert(2,x);
                    }
                }
                Text{
                    text: String(index).padStart(2, '0')
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: time_ID_min.currentIndex == index ? "white" : "black"
                }
            }
        }
    }
}
