#!/usr/bin/env quickshell
# Kew Widget (Gruvbox theme)

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

Window {
    visible: true
    width: 350
    height: 400
    title: "Kew Widget"
    color: "#282828"  // Gruvbox dark background

    // Анимации
    PropertyAnimation {
        target: container
        property: "opacity"
        from: 0
        to: 1
        duration: 500
    }

    ColumnLayout {
        id: container
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Заголовок
        Label {
            text: "Kew Player"
            font.pixelSize: 18
            color: "#fabd2f"  // Gruvbox yellow
            Layout.alignment: Qt.AlignHCenter
        }

        // Кнопки управления
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Button {
                text: "Kew Audio"
                Layout.fillWidth: true
                background: Rectangle {
                    color: "#458588"  // Gruvbox blue
                    radius: 5
                }
                onClicked: {
                    Qt.callLater("kew")
                }
            }

            Button {
                text: "Kew Video"
                Layout.fillWidth: true
                background: Rectangle {
                    color: "#b16286"  // Gruvbox purple
                    radius: 5
                }
                onClicked: {
                    Qt.callLater("kew-video --playlist")
                }
            }
        }

        // Поле поиска
        TextField {
            id: searchField
            placeholderText: "Поиск видео..."
            Layout.fillWidth: true
            background: Rectangle {
                color: "#3c3836"
                radius: 5
                border.color: "#fabd2f"
            }
            onAccepted: {
                Qt.callLater("kew-video --search '" + searchField.text + "'")
            }
        }

        // Плейлист
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#3c3836"
            radius: 5
            border.color: "#8ec07c"  // Gruvbox green

            ListView {
                anchors.fill: parent
                model: playlistModel
                delegate: Item {
                    height: 30
                    width: parent.width
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Qt.callLater("mpv", [modelData])
                        }
                    }
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.split("/").pop()
                        color: "#ebdbb2"  // Gruvbox light
                        font.pixelSize: 12
                    }
                }
            }
        }
    }

    // Модель плейлиста
    ListModel {
        id: playlistModel
        Component.onCompleted: {
            var result = Qt.callLater("find ~/Music -name '*.mp4'")
            result.stdout.trim().split("\n").forEach(function(file) {
                playlistModel.append({"file": file})
            })
        }
    }
}