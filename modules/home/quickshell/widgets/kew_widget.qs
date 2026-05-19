pragma Singleton
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3
import QtQml 2.15

QtObject {
    id: root
    
    // Регистрируем тип KewWidget
    QtObject {
        id: internal
        property alias window: window
    }
    
    Window {
    visible: true
    width: 400
    height: 500
    title: "Kew Widget"
    color: "#282828"  // Gruvbox dark

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Заголовок
        Label {
            text: "Kew Player"
            font.pixelSize: 20
            color: "#fabd2f"
            Layout.alignment: Qt.AlignHCenter
        }

        // Вкладки
        TabBar {
            id: tabBar
            Layout.fillWidth: true
            currentIndex: 0

            TabButton { text: "Kew Audio" }
            TabButton { text: "Kew Video" }
            TabButton { text: "Обои" }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            // Вкладка Kew Audio
            ColumnLayout {
                spacing: 10

                Button {
                    text: "Запустить Kew"
                    Layout.fillWidth: true
                    onClicked: Qt.callLater("kew")
                }
            }

            // Вкладка Kew Video
            ColumnLayout {
                spacing: 10

                TextField {
                    id: searchField
                    placeholderText: "Поиск видео..."
                    Layout.fillWidth: true
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Button {
                        text: "Поиск"
                        onClicked: {
                            Qt.callLater("kew-video", ["--search", searchField.text])
                        }
                    }

                    Button {
                        text: "Плейлист"
                        onClicked: Qt.callLater("kew-video", ["--playlist"])
                    }
                }

                // Предпросмотр видео
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: videoModel
                    delegate: Item {
                        height: 50
                        width: parent.width
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Qt.callLater("mpv", [modelData])
                        }
                        Label {
                            text: modelData.split("/").pop()
                            color: "#ebdbb2"
                        }
                    }
                }
            }

            // Вкладка Обои
            ColumnLayout {
                spacing: 10

                Button {
                    text: "Скачать обои"
                    Layout.fillWidth: true
                    onClicked: wallpaperDialog.open()
                }

                // Просмотр обоев
                GridView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    cellWidth: 100
                    cellHeight: 100
                    model: wallpaperModel
                    delegate: Image {
                        width: 100
                        height: 100
                        source: modelData
                        fillMode: Image.PreserveAspectCrop
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Qt.callLater("swww", ["img", modelData])
                        }
                    }
                }
            }
        }
    }

    // Диалог выбора обоев
    FileDialog {
        id: wallpaperDialog
        title: "Выберите обои"
        folder: "~/Pictures/Wallpapers"
        nameFilters: ["Image files (*.jpg *.png *.jpeg)"]
        onAccepted: {
            wallpaperModel.append(fileUrl)
        }
    }

    // Модели
    ListModel { id: videoModel }
    ListModel { id: wallpaperModel }

    Component.onCompleted: {
        // Загрузка видео из ~/Music
        var result = Qt.callLater("find", ["~/Music", "-name", "*.mp4"])
        result.stdout.trim().split("\n").forEach(function(file) {
            videoModel.append(file)
        })
    }
    
    // Экспортируем тип
    Component {
        id: kewWidgetComponent
        KewWidget {}
    }
}