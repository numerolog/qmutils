#!/usr/bin/env qml

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1

ApplicationWindow
{
    visible: true
    width: 1280
    height: 800
    title: "Simple code formatter (v0.1.0a1-051124)"
    color: "#2E2E2E" // Dark background for the window
    
    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        RowLayout
        {
            spacing: 10
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            // Left part for text input
            ColumnLayout
            {
                spacing: 10
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                Rectangle
                {
                    id: textAreaBackground
                    color: "#3E3E3E" // Background color of the text area
                    radius: 8 // Optional: rounded corners
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    MouseArea
                    {
                        anchors.fill: parent
                        enabled: false // Disable MouseArea to allow interaction with TextArea
                    }
                    ScrollView
                    {
                        anchors.fill: parent
                        TextArea
                        {
                            focus: true
                            id: inputTextArea
                            anchors.fill: parent
                            placeholderText: "Enter text here..."
                            color: "white" // Text color
                            onTextChanged:
                            {
                                outputTextArea.text = formatCode(inputTextArea.text)
                            }
                            Keys.onPressed:
                            {
                                if (event.key === Qt.Key_Escape)
                                {
                                    Qt.quit();
                                }
                            }
                            //:CLOWN:
                            selectByMouse: true
                            MouseArea
                            {
                                anchors.fill: parent
                                cursorShape: Qt.IBeamCursor
                                acceptedButtons: Qt.NoButton
                            }
                        }
                    }
                }
            }
            
            ColumnLayout
            {
                spacing: 10
                Layout.fillWidth: true
                Layout.fillHeight: true
                // Right part for displaying errors
                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#3E3E3E" // Background color of the list
                    radius: 8 // Optional: rounded corners
                    id: resultListBackground
                    ScrollView
                    {
                        anchors.fill: parent
                        TextArea
                        {
                            id: outputTextArea
                            anchors.fill: parent
                            placeholderText: "Formated code here..."
                            color: "white" // Text color
                            Keys.onPressed:
                            {
                                if (event.key === Qt.Key_Escape)
                                {
                                    Qt.quit();
                                }
                            }
                            //:CLOWN:
                            selectByMouse: true
                            
                            /*
                            MouseArea
                            {
                                anchors.fill: parent
                                cursorShape: Qt.IBeamCursor
                                acceptedButtons: Qt.NoButton
                            }*/
                        }
                    }
                }
            }}
            
            Text
            {
                Layout.fillWidth: true
                text: "Insert in left side formatting text, and press <esc> in left/right side for exit."
                color: "white"
            }
        }
        
        function moveBracesToNewLine(code)
        {
            var lines = code.split("\n").map(function(line)
            {
                return line.trim();
            });
            
            var modifiedLines = [];
            var inString = false;
            
            for (var i = 0; i < lines.length; i++)
            {
                var line = lines[i];
                var newLine = "";
                
                for (var j = 0; j < line.length; j++)
                {
                    var c = line[j];
                    
                    if (c === '"' || c === "'")
                    {
                        inString = !inString;
                    }
                    
                    if (c === "{" && !inString)
                    {
                        newLine = newLine.trim() + "\n{";
                    } else
                    {
                        newLine += c;
                    }
                }
                
                modifiedLines.push(newLine.trim());
            }
            return modifiedLines.join("\n");
        }
        function formatCode(text)
        {
            var code = text;
            code = moveBracesToNewLine(code);
            
            // Удаляем лишние пробелы и разбиваем на строки
            var lines = code.split("\n").map(function(line)
            {
                return line.trim(); // Убираем пробелы в начале и конце строки
            });
            
            var formattedLines = [];
            var indentLevel = 0;
            var indentString = "    "; // 4 пробела для отступа
            
            for (var i = 0; i < lines.length; i++)
            {
                var line = lines[i];
                
                // Обрабатываем открывающую фигурную скобку
                if (line.endsWith("{"))
                {
                    formattedLines.push(indentString.repeat(indentLevel) + line);
                    indentLevel++;
                }
                // Обрабатываем закрывающую фигурную скобку
                else if (line.startsWith("}"))
                {
                    indentLevel--;
                    if(indentLevel<0)
                    indentLevel = 0;
                    formattedLines.push(indentString.repeat(indentLevel) + line);
                }
                // Обрабатываем обычные строки
                else
                {
                    formattedLines.push(indentString.repeat(indentLevel) + line);
                }
            }
            
            // Объединяем отформатированные строки обратно в текст
            return formattedLines.join("\n");
        }
    }
    
