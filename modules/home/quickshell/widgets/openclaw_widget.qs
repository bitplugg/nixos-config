#!/usr/bin/env quickshell
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

Window {
    visible: true
    width: 400
    height: 500
    title: "OpenClaw Widget"
    color: "#282828"  // Gruvbox dark

    // Темы
    property var themes: {
        "Gruvbox": {
            bg: "#282828", fg: "#ebdbb2",
            yellow: "#fabd2f", blue: "#83a598",
            purple: "#d3869b", green: "#b8bb26"
        },
        "Dracula": {
            bg: "#282a36", fg: "#f8f8f2",
            yellow: "#f1fa8c", blue: "#8be9fd",
            purple: "#bd93f9", green: "#50fa7b"
        }
    }
    property string currentTheme: "Gruvbox"

    // Применение темы
    function applyTheme(theme) {
        currentTheme = theme
        container.color = themes[theme].bg
        titleLabel.color = themes[theme].yellow
    }

    ColumnLayout {
        id: container
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Заголовок
        Label {
            id: titleLabel
            text: "OpenClaw"
            font.pixelSize: 20
            color: "#fabd2f"
            Layout.alignment: Qt.AlignHCenter
        }

        // Переключатель тем
        ComboBox {
            model: Object.keys(themes)
            currentIndex: find(currentTheme, currentText)
            onActivated: applyTheme(currentText)
            Layout.fillWidth: true
        }

        // Чат с OpenClaw
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#3c3836"
            radius: 5
            border.color: "#83a598"

            ColumnLayout {
                anchors.fill: parent
                spacing: 5

                // История сообщений
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: chatModel
                    delegate: Label {
                        text: modelData
                        color: "#ebdbb2"
                        font.pixelSize: 12
                    }
                }

                // Поле ввода
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 5

                    TextField {
                        id: messageField
                        placeholderText: "Введите сообщение..."
                        Layout.fillWidth: true
                        onAccepted: {
                            chatModel.append("You: " + messageField.text)
                            // Отправка сообщения в OpenClaw
                            Qt.callLater("echo", [messageField.text, "|", "openclaw", "send"])
                            messageField.clear()
                        }
                    }

                    Button {
                        text: "Отправить"
                        onClicked: messageField.accepted()
                    }
                }
            }
        }
    }

    // Модель чата
    ListModel {
        id: chatModel
        Component.onCompleted: {
            append("OpenClaw: Привет! Как я могу помочь?")
        }
    }
}