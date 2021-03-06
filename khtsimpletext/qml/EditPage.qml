import QtQuick 1.1
import com.nokia.meego 1.0
import 'components'
import 'common.js' as Common

Page {
    tools: editTools
    id: editPage

    property int index
    property bool modified;

    function exitFile() {
        modified = false;
        pageStack.pop();
    }

    function recolorIt() {
        var index = textEditor.cursorPosition;
        Document.recolorIt(textEditor.text);
        textEditor.cursorPosition = index;    
    }
    
    function saveFile() {
        Document.write(textEditor.text);
    }

    QueryDialog {
                id:unsavedDialog
                titleText:"Unsaved"
                icon: Qt.resolvedUrl('../icons/khtsimpletext.png')
                message:"Did you want to save file before closing it ?";
                acceptButtonText: 'Save';
                rejectButtonText: 'Close';
                onRejected: { exitFile(); }
                onAccepted: { saveFile();exitFile(); }
                }

        PageHeader {
         id: header
         title: 'KhtSimpleText'
         subtitle: Common.beautifulPath(Document.filepath);
    }

     BusyIndicator {
        id: busyindicator
        platformStyle: BusyIndicatorStyle { size: "large" }
        running: Document.ready ? false : true;
        opacity: Document.ready ? 0.0 : 1.0;
        anchors.centerIn: parent
    }

    Flickable {
         id: flick
         opacity: Document.ready ? 1.0 : 0.0
         flickableDirection: Flickable.HorizontalAndVerticalFlick
         //boundsBehavior: Flickable.DragOverBounds
         anchors.top: header.bottom
         anchors.left: parent.left
         anchors.leftMargin: -2
         anchors.right: parent.right
         anchors.rightMargin: -2
         anchors.bottom: parent.bottom
         anchors.bottomMargin: -2
         anchors.topMargin: -2
         clip: true

         contentWidth: textEditor.width
         contentHeight: textEditor.height
         pressDelay: 200


             KhtTextArea {
                 id: textEditor
                 anchors.top: parent.top
                 anchors.left: parent.left
                 text: Document.data
                 height: Math.max(paintedHeight + 28, flick.height)
                 width: Math.max(paintedWidth + 28, flick.width)
                 wrapMode: TextEdit.NoWrap
                 inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                 textFormat: TextEdit.AutoText
                 font { bold: false; family: Settings.fontFamily; pixelSize: Settings.fontSize;}
                 onTextChanged: { modified = true; /*autoTimer.restart();*/ }
                 opacity: 1.0
         }
         /*Timer { //Too slow to be used
            id: autoTimer
            interval: 10000
            onTriggered:{
                var index = textEditor.cursorPosition;
                Document.recolorIt(textEditor.text);
                textEditor.cursorPosition = index;
            } 
            
         }*/

         
         onOpacityChanged: {
           if (flick.opacity == 1.0) modified = false;
         }
     }

    ScrollDecorator {
        flickableItem: flick
        platformStyle: ScrollDecoratorStyle {
        }}

    Menu {
        id: editMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: qsTr("About"); onClicked: pushAbout()}
            MenuItem { text: qsTr("MarkDown Preview"); onClicked: {
                var atext = Document.previewMarkdown(textEditor.text);
                var previewPage = Qt.createComponent(Qt.resolvedUrl("PreviewPage.qml"));
                pageStack.push(previewPage, {atext:atext}); }
            }
            MenuItem { text: qsTr("ReHighlight Text"); onClicked:{ 
                recolorIt();    
                }
            }
            MenuItem { text: qsTr("Save"); onClicked: {
                saveFile();
                recolorIt;
                }
            }
            /*MenuItem { text: qsTr("Preferences"); onClicked: notYetAvailableBanner.show(); }*/
        }
    }

    ToolBarLayout {
        id: editTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: {
                   if (modified == true ) unsavedDialog.open();
                   else exitFile();
                   }
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (editMenu.status === DialogStatus.Closed) ? editMenu.open() : editMenu.close()
        }
    }
}


