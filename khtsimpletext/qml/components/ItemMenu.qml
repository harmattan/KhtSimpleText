import QtQuick 1.1
import com.nokia.meego 1.0
//import '../common.js' as Common

Menu {
    id: itemMenu
    visualParent: pageStack

    property string filePath
    property string fileName
  
    MenuLayout {
        MenuItem {
            text: qsTr("Copy")
            onClicked: pageStack.push(copyFilePage, { filePath: filePath, fileName: fileName });
        }
        MenuItem {
            text: qsTr("Move")
            onClicked: pageStack.push(moveFilePage, { filePath: filePath, fileName: fileName });
        }
        MenuItem {
            text: qsTr("Rename")
            onClicked: pageStack.push(renameFilePage, { filePath: filePath, fileName: fileName });
        }
        MenuItem {
            text: qsTr("Delete")
            onClicked: {
              deleteQueryDialog.filepath = filePath;
              deleteQueryDialog.open();
            }
        }
    }
}