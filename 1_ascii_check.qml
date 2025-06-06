#!/usr/bin/env qml

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1

ApplicationWindow
{
    visible: true
    width: 1280
    height: 800
    title: "ASCII Checker (v0.1.0a1-051124)"
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
                            id: inputTextArea
                            anchors.fill: parent
                            placeholderText: "Enter text here..."
                            color: "white" // Text color
                            onTextChanged:
                            {
                                checkAscii(inputTextArea.text)
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
                    ListView
                    {
                        id: resultListView
                        anchors.fill: parent
                        anchors.margins: 10
                        model: ListModel
                        {}
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        
                        delegate: Item
                        {
                            width: resultListView.width
                            height: 45
                            Text
                            {
                                text: model.text
                                height: 45
                                color: "white" // Text color
                            }
                        }
                    }
                }
            }
        }
        
        Text
        {
            Layout.fillWidth: true
            text: "Insert in left side testing text, and press <esc> in left side for exit."
            color: "white"
        }
    }
    function checkAscii(text)
    {
        resultListView.model.clear()
        var nonAsciiChars = []
        var kyrRegexp = /[a-яА-ЯЁё]/;
        
        for (var i = 0; i < text.length; i++)
        {
            var charCode = text.charCodeAt(i);
            if (!kyrRegexp.test(String.fromCharCode(charCode)))
            if (charCode > 127)
            {
                nonAsciiChars.push(text[i] + " (code: 0x" + charCode.toString(16) + ")\n")
            }
        }
        
        if (nonAsciiChars.length > 0)
        {
            for (var j = 0; j < nonAsciiChars.length; j++)
            {
                resultListView.model.append(
                { text: nonAsciiChars[j] })
            }
            resultListBackground.color = "#5E3E3E"
        } else
        {
            resultListBackground.color = "#3E5E3E"
            resultListView.model.append(
            { text: "All characters are ASCII." })
        }
    }
}

