#!/usr/bin/env quickshell
# OpenClaw Widget (Gruvbox theme)

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

Window {
    visible: true
    width: 300
    height: 200
    title: "OpenClaw Widget"
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
            text: "OpenClaw Status"
            font.pixelSize: 18
            color: "#fabd2f"  // Gruvbox yellow
            Layout.alignment: Qt.AlignHCenter
        }

        // Статус OpenClaw
        Rectangle {
            Layout.fillWidth: true
            height: 40
            color: "#3c3836"  // Gruvbox dark
            radius: 5
            border.color: "#fabd2f"

            Label {
                anchors.centerIn: parent
                text: openclawStatus.text
                color: openclawStatus.active ? "#b8bb26" : "#fb4934"  // Gruvbox green/red
            }

            Connections {
                target: openclawStatus
                onActiveChanged: {
                    openclawStatus.text = openclawStatus.active ? "✓ Active" : "✗ Inactive"
                }
            }
        }

        // Погода
        Rectangle {
            Layout.fillWidth: true
            height: 40
            color: "#3c3836"
            radius: 5
            border.color: "#83a598"  // Gruvbox blue

            Label {
                anchors.centerIn: parent
                text: weather.text
                color: "#83a598"
            }

            Connections {
                target: weather
                onWeatherChanged: {
                    weather.text = "Погода: " + weather.data
                }
            }
        }

        // Последние команды
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#3c3836"
            radius: 5
            border.color: "#d3869b"  // Gruvbox purple

            ListView {
                anchors.fill: parent
                model: commandHistory
                delegate: Label {
                    text: modelData
                    color: "#d3869b"
                    font.pixelSize: 12
                }
            }
        }
    }

    // Данные
    OpenClawStatus {
        id: openclawStatus
        active: true  // Заменить на реальную проверку
    }

    Weather {
        id: weather
        city: "Москва"
        onWeatherChanged: {
            weather.data = getWeather(city)
        }
    }

    CommandHistory {
        id: commandHistory
        limit: 5
    }

    // Функции
    function getWeather(city) {
        // Запрос погоды через curl
        var result = Qt.callLater("curl -s 'https://wttr.in/" + city + "?format=%C+%t'")
        return result.stdout.trim()
    }
}