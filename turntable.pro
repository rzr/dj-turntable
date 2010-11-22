QT       += core gui declarative multimedia

maemo5 {
    QT += opengl
}

win32:!simulator {
    QT += opengl
}

TARGET   = turntable
TEMPLATE = app


SOURCES += main.cpp \
           TurnTable.cpp \
           ga_src/GEAudioBuffer.cpp \
           ga_src/GEInterfaces.cpp \
           ga_src/GEAudioOut.cpp \
           DrumMachine.cpp

OTHER_FILES += TurnTable.qml \
               SpeedSlider.qml \
               Button.qml \
               Arm.qml \
               SidePanel.qml \
               DrumMachine.qml

RESOURCES +=   resources.qrc

HEADERS +=     TurnTable.h \
               ga_src/GEAudioOut.h \
               ga_src/GEInterfaces.h \
               ga_src/GEAudioBuffer.h \
               DrumMachine.h

unix:!symbian {
    maemo5 {
        target.path = /opt/usr/bin
    } else {
        target.path = /usr/local/bin
    }
    INSTALLS += target
}


symbian {
    # To lock the application to landscape orientation
    LIBS += -lcone -leikcore -lavkon

    # For QtMobility
    TARGET.CAPABILITY = NetworkServices \
                        Location \
                        ReadUserData \
                        WriteUserData \
                        LocalServices \
                        UserEnvironment

    TARGET.EPOCHEAPSIZE = 0x100000 0x2000000
    TARGET.EPOCSTACKSIZE = 0x14000
}