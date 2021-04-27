import QtQuick 2.15
import QtQuick.Controls 2.15

CheckBox{
    id:acceptterms
	property alias textcolor: text_contentItem.color
	property alias wrapMode: text_contentItem.wrapMode
    property string valueOn:"true"
    property string valueOff:"false"
    property string value:checked ? valueOn : valueOff
    width:100
    text:""
    font.pixelSize:14
    indicator:Rectangle{
        width:parent.font.pixelSize
        height:parent.font.pixelSize
        y:parent.topPadding + (parent.availableHeight - height) / 2
        radius:3
        border.color:acceptterms.checked ? '#0075FF' : '767676'
        color:acceptterms.checked ? '#0075FF' : '#ffffff'
        Image{
            anchors.centerIn:parent
            width:parent.width - 3
            height:parent.height - 3
            visible:acceptterms.checked
            source:"data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+YWxlcnRzLWFuZC1ub3RpZmljYXRpb25zL2NoZWNrXzEyX3c8L3RpdGxlPjxwYXRoIGQ9Ik00LjUwMjQgOS41Yy0uMTMzIDAtLjI2LS4wNTMtLjM1NC0uMTQ3bC0zLjAwMi0zLjAwN2MtLjE5NS0uMTk2LS4xOTUtLjUxMi4wMDEtLjcwNy4xOTQtLjE5NS41MTEtLjE5Ni43MDcuMDAxbDIuNjQ4IDIuNjUyIDUuNjQyLTUuNjQ2Yy4xOTUtLjE5NS41MTEtLjE5NS43MDcgMCAuMTk1LjE5NS4xOTUuNTEyIDAgLjcwOGwtNS45OTUgNmMtLjA5NC4wOTMtLjIyMS4xNDYtLjM1NC4xNDYiIGZpbGw9IiNGRkYiIGZpbGwtcnVsZT0iZXZlbm9kZCIvPjwvc3ZnPg=="
        }
    }

    contentItem:Text{
		id: text_contentItem
        text:parent.text
        font:parent.font
        horizontalAlignment:Text.AlignLeft
        verticalAlignment:Text.AlignVCenter
        leftPadding:parent.indicator.width + parent.spacing
        color:'#171B1F'
        elide:Text.ElideRight
    }
}
