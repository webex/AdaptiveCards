import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

TextField{
    id:time1
    selectByMouse:true
    selectedTextColor:'white'
    property string selectedTime
    property alias bgrcolor: backgroundRectangle.color
    placeholderText:""
    color:'#171B1F'
    validator:RegExpValidator { regExp: /^(--|[01][0-9|-]|2[0-3|-]):(--|[0-5][0-9|-])$/}
    text:""
    onFocusChanged:{
        if (focus===true)
            inputMask="xx:xx;-";
        if(focus===false)
        {
            z=0;
            if(text===":")
            {
                inputMask=""
            }
            if(time1_timeBox.visible===true)
            {
                time1_timeBox.visible=false
            }
        }
    }
    onTextChanged:{
        time1_hours.currentIndex=parseInt(getText(0,2))
        time1_min.currentIndex=parseInt(getText(3,5))
        if(getText(0,2) === '--' || getText(3,5) === '--')
        {
            time1.selectedTime ='';
        }
        else
        {
            time1.selectedTime =time1.text
        }
    }
    background:Rectangle{
        id:backgroundRectangle
        radius:5
        color:'#FFFFFF'
        border.color:time1.activeFocus? 'black' : 'grey'
        border.width:1
        layer.enabled:time1.activeFocus ? true : false
        layer.effect:Glow{
            samples:25
            color:'skyblue'
        }

    }

    MouseArea{
        height:parent.height
        width:height
        anchors.right:parent.right
        enabled:true
        onClicked:{time1.forceActiveFocus();
            time1_timeBox.visible=!time1_timeBox.visible;
            parent.z=time1_timeBox.visible?1:0;
            time1_hours.currentIndex=parseInt(parent.getText(0,2));
            time1_min.currentIndex=parseInt(parent.getText(3,5));
        }
        Image{
            anchors.fill:parent
            anchors.margins:5
            fillMode:Image.PreserveAspectFit
            mipmap:true
            source:"data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjxzdmcgd2lkdGg9IjMwcHgiIGhlaWdodD0iMzBweCIgdmlld0JveD0iMCAwIDMwIDMwIiB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPg0KICAgIDwhLS0gR2VuZXJhdG9yOiBTa2V0Y2ggNjAuMSAoODgxMzMpIC0gaHR0cHM6Ly9za2V0Y2guY29tIC0tPg0KICAgIDx0aXRsZT5waG9uZS9yZWNlbnRzLXByZXNlbmNlLXN0cm9rZV8zMDwvdGl0bGU+DQogICAgPGRlc2M+Q3JlYXRlZCB3aXRoIFNrZXRjaC48L2Rlc2M+DQogICAgPGcgaWQ9InBob25lL3JlY2VudHMtcHJlc2VuY2Utc3Ryb2tlXzMwIiBzdHJva2U9Im5vbmUiIHN0cm9rZS13aWR0aD0iMSIgZmlsbD0ibm9uZSIgZmlsbC1ydWxlPSJldmVub2RkIj4NCiAgICAgICAgPHBhdGggZD0iTTE1LjAwMDIsMC4wMDAxIEM2LjcyNzkxNTI1LDAuMDAwMSAwLjAwMDIsNi43Mjc4MTUyNSAwLjAwMDIsMTUuMDAwMSBDMC4wMDAyLDIzLjI3MjM4NDcgNi43Mjc5MTUyNSwzMC4wMDAxIDE1LjAwMDIsMzAuMDAwMSBDMjMuMjcyNDg0NywzMC4wMDAxIDMwLjAwMDIsMjMuMjcyMzg0NyAzMC4wMDAyLDE1LjAwMDEgQzMwLjAwMDIsNi43Mjc4MTUyNSAyMy4yNzI0ODQ3LDAuMDAwMSAxNS4wMDAyLDAuMDAwMSBaIE0xNS4wMDAyLDEuMDAwMSBDMjIuNzIwMiwxLjAwMDEgMjkuMDAwMiw3LjI4MDEgMjkuMDAwMiwxNS4wMDAxIEMyOS4wMDAyLDIyLjcyMDEgMjIuNzIwMiwyOS4wMDAxIDE1LjAwMDIsMjkuMDAwMSBDNy4yODAyLDI5LjAwMDEgMS4wMDAyLDIyLjcyMDEgMS4wMDAyLDE1LjAwMDEgQzEuMDAwMiw3LjI4MDEgNy4yODAyLDEuMDAwMSAxNS4wMDAyLDEuMDAwMSBaIE0xOS4zMjQyLDIwLjkxMjEgQzE5LjIyNjIsMjEuMDEwMSAxOS4wOTgyLDIxLjA1ODEgMTguOTcwMiwyMS4wNTgxIEMxOC44NDMyLDIxLjA1ODEgMTguNzE1MiwyMS4wMTAxIDE4LjYxNzIsMjAuOTEyMSBMMTQuODc5MiwxNy4xNzQxIEMxNC42MzgyLDE2LjkzMzEgMTQuNTAwMiwxNi42MDAxIDE0LjUwMDIsMTYuMjYwMSBMMTQuNTAwMiw3Ljg1MzEgQzE0LjUwMDIsNy41NzYxIDE0LjcyMzIsNy4zNTMxIDE1LjAwMDIsNy4zNTMxIEMxNS4yNzYyLDcuMzUzMSAxNS41MDAyLDcuNTc2MSAxNS41MDAyLDcuODUzMSBMMTUuNTAwMiwxNi4yNjAxIEMxNS41MDAyLDE2LjMzNzEgMTUuNTMxMiwxNi40MTIxIDE1LjU4NjIsMTYuNDY3MSBMMTkuMzI0MiwyMC4yMDUxIEMxOS41MTkyLDIwLjQwMDEgMTkuNTE5MiwyMC43MTcxIDE5LjMyNDIsMjAuOTEyMSIgaWQ9ImZpbGwiIGZpbGw9IiMxNzFCMUYiPjwvcGF0aD4NCiAgICA8L2c+DQo8L3N2Zz4="
            ColorOverlay{
                anchors.fill:parent
                source:parent
                color:time1.color
            }
        }
    }
    Rectangle{
        id:time1_timeBox
        anchors.topMargin:1
        anchors.left:parent.left
        anchors.top:parent.bottom
        width:105
        height:200
        visible:false
        layer.enabled:true
        layer.effect:Glow{
            samples:25
            color:'skyblue'
        }

        ListView{
            id:time1_hours
            width:45
            height:parent.height-10
            anchors.margins:5
            anchors.top:parent.top
            flickableDirection:Flickable.VerticalFlick
            boundsBehavior:Flickable.StopAtBounds
            clip:true
            anchors.left:parent.left
            model:24
            delegate:Rectangle{
                width:45
                height:45
                color:time1_hours.currentIndex==index ? "blue" : time1_hoursmouseArea.containsMouse?"lightblue":"white"
                MouseArea{
                    id:time1_hoursmouseArea
                    anchors.fill:parent
                    enabled:true
                    hoverEnabled:true
                    onClicked:{time1_hours.currentIndex=index;var x=String(index).padStart(2, '0') ;time1.insert(0,x);}
                }
                Text{
                    text:String(index).padStart(2, '0')
                    anchors.fill:parent
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    color:time1_hours.currentIndex==index ? "white" : "black"
                }
            }

        }
        ListView{
            id:time1_min
            width:45
            height:parent.height-10
            anchors.margins:5
            anchors.top:parent.top
            flickableDirection:Flickable.VerticalFlick
            boundsBehavior:Flickable.StopAtBounds
            clip:true
            anchors.left:time1_hours.right
            model:60
            delegate:Rectangle{
                width:45
                height:45
                color:time1_min.currentIndex==index ? "blue" : time1_minmouseArea.containsMouse?"lightblue":"white"
                MouseArea{
                    id:time1_minmouseArea
                    anchors.fill:parent
                    enabled:true
                    hoverEnabled:true
                    onClicked:{time1_min.currentIndex=index;var x=String(index).padStart(2, '0') ;time1.insert(2,x);}
                }
                Text{
                    text:String(index).padStart(2, '0')
                    anchors.fill:parent
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    color:time1_min.currentIndex==index ? "white" : "black"
                }
            }

        }
    }
}
