pragma Singleton
import QtQuick 2.15

QtObject {
    readonly property QtObject comboBoxConstants: QtObject{
        readonly property int arrowIconHorizontalPadding: 9.5
        readonly property int arrowIconVerticalPadding: 8
        readonly property int arrowIconWidth: 13
        readonly property int arrowIconHeight: 7
        readonly property int textHorizontalPadding: 12
        readonly property int dropDownElementHeight: 40
        readonly property int dropDownElementHorizontalPadding: 12
        readonly property int dropDownElementVerticalPadding: 8
        readonly property int dropDownElementRadius: 8
        readonly property int dropDownElementTextHorizontalPadding: 12
        readonly property int dropDownRadius: 12
        readonly property int dropDownPadding: 8
        readonly property int dropDownHeight: 216
        readonly property int maxDropDownWidth: 800
    }
}
