#!/usr/bin/env quickshell
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    visible: true
    width: 500
    height: 600
    title: "Wallpaper Widget"
    color: "#282828"  // Gruvbox dark

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Заголовок
        Label {
            text: "Обои"
            font.pixelSize: 20
            color: "#fabd2f"
            Layout.alignment: Qt.AlignHCenter
        }

        // Поиск обоев
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            TextField {
                id: searchField
                placeholderText: "Тема обоев..."
                Layout.fillWidth: true
            }

            ComboBox {
                id: sourceCombo
                model: ["Unsplash", "Wallpaper Bank"]
                currentIndex: 0
            }

            Button {
                text: "Скачать"
                onClicked: {
                    var source = sourceCombo.currentText.toLowerCase().replace(" ", "_")
                    Qt.callLater("python3", [
                        "/home/bitplugg/nixos-config/modules/home/quickshell/scripts/wallpaper_downloader.py",
                        searchField.text
                    ])
                    loadWallpapers()
                }
            }
        }

        // Просмотр обоев
        GridView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: 150
            cellHeight: 150
            model: wallpaperModel
            delegate: Image {
                width: 150
                height: 150
                source: modelData
                fillMode: Image.PreserveAspectCrop
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.callLater("swww", ["img", modelData])
                }
            }
        }
    }

    // Модель обоев
    ListModel { id: wallpaperModel }

    // Загрузка обоев
    function loadWallpapers() {
        wallpaperModel.clear()
        var result = Qt.callLater("find", ["~/Pictures/Wallpapers", "-type", "f", "-name", "*.jpg", "-o", "-name", "*.png"])
        result.stdout.trim().split("\n").forEach(function(file) {
            wallpaperModel.append(file)
        })
    }

    Component.onCompleted: loadWallpapers()
}