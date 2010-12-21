import Qt 4.7

Rectangle {
    id: helpScreen

    signal linkActivated(variant link)

    width: 500; height: 360
    radius: 5
    color: "#999999"
    clip: true

    Flickable {
        id: flickable

        anchors.fill: parent
        anchors.margins: 20
        contentHeight: column.height

        Column {
            id: column

            x: 10
            width: parent.width - 20

            Text {
                id: projectInfo

                color: "white"
                width: parent.width
                wrapMode: Text.WordWrap
                textFormat: Text.RichText

                text: "<b><h2>Dj Turntable</b></h2>" +
                      "Dj Turntable is a Forum Nokia example that demonstrates integrating a Qt Quick application to Qt audio interface. " +
                      "See more information about the project at " +
                      "<a href=\"https://projects.forum.nokia.com/turntable\">https://projects.forum.nokia.com/turntable</a>.<br>"
            }

            Text {
                id: features

                color: "white"
                width: parent.width
                wrapMode: Text.WordWrap
                textFormat: Text.RichText

                text: "<b><h3>Turntable</h3></b>" +
                      "Play the looping sample with a realistic turntable. " +
                      "The sample can be scratched with finger, played faster, slower and backwards. " +
                      "The speed of the disk can be adjusted with the speed slider, the default 1x speed can be " +
                      "obtained by double clicking the speed slider knob. Dj Turntable offers Cutoff and Resonance " +
                      "to alternate the sample in real time. The knobs are rotated by moving the finger up and down " +
                      "on top of the knobs." +
                      "<b><h3>Drum machine</h3></b>" +
                      "Play and edit the drum beats. There are three predefined beats which can be played and edited but the " +
                      "edits are not stored. For the user there are three beats that are saved to the devices memory " +
                      "whenever they are edited. Use the beat selector buttons on the bottom of the view to " +
                      "switch between the beats. All the beats are 32 ticks long and they contain 6 different " +
                      "drum samples: hi-hat, hi-hat open, bass drum, snare, cymbal and cow bell.<br>"
            }

            Text {
                id: keyboardHelp

                color: "white"
                width: parent.width
                wrapMode: Text.WordWrap
                textFormat: Text.RichText

                text: "<b><h3>Keyboard shortcuts</h3></b>" +
                      "The following keyboard shortcuts exist:<br><br>" +
                      "Camera zoom up = Volume up<br>" +
                      "Camera zoom down = Volume down<br>" +
                      "Space = Start / stop the turntable<br>" +
                      "Return = Start / stop the drum machine<br>" +
                      "Key up = Go to the turntable view<br>" +
                      "Key down = Go to the drum machine view<br>" +
                      "Key left = View the 1st tick group in the drum machine<br>" +
                      "Key right = View the 2nd tick group in the drum machine<br>" +
                      "Key i = Go to the info view<br>"
            }

            Text {
                id: freesoundlicense

                color: "white"
                width: parent.width
                wrapMode: Text.WordWrap
                textFormat: Text.RichText

                text: "<b><h3>Samples</h3></b>" +
                      "The turntable melody sample <i>ivory.wav</i> was created by nick <i>Flick3r</i> " +
                      "and it was downloaded from <a href=\"http://www.freesound.org\">freesound.org</a>. The sample follows the " +
                      "<a href=\"http://creativecommons.org/licenses/sampling+/1.0/\">Creative Commons Sampling Plus 1.0 license</a>.<br>"

                onLinkActivated: helpScreen.linkActivated(link)
            }
        }
    }
}