import QtQuick 2.14
import QtQuick.Window 2.14
import QtSensors 5.12
import QtQuick3D 1.15

Window {
    // @disable-check M16
    // @disable-check M16
    // @disable-check M16
    visible: true
    property alias joynext: joynext
    property alias mainWindow: mainWindow
    // @disable-check M16
    title: qsTr("Hello World")

    Rectangle {
        id: mainWindow
        color: "#ffffff"
        anchors.fill: parent

        Joynext {
            id: joynext
            x: joynext.centerX - joynextCenter
            y: joynext.centerY - joynextCenter
            joynextCenter: joynext.width /2
            centerX: mainWindow.width /2
            centerY: mainWindow.height /2
        }
    }

    Accelerometer {
       id: accel
       dataRate: 100
       active: true
       readonly property double radians_to_degrees: 180 / Math.PI

       }

    function calcPitch(x,y,z) {
        return -Math.atan2(y, Math.hypot(x, z)) * accel.radians_to_degrees;
    }

    function calcRoll(x,y,z) {
        return -Math.atan2(x, Math.hypot(y, z)) * accel.radians_to_degrees;
    }

    // @disable-check M16
    onReadingChanged: {
        var newX = (joynext.x + calcRoll(accel.reading.x, accel.reading.y, accel.reading.z) * 0.1)
        var newY = (joynext.y - calcPitch(accel.reading.x, accel.reading.y, accel.reading.z) * 0.1)

        if (isNaN(newX) || isNaN(newY))
            return;

        if (newX < 0)
            newX = 0

        if (newX > mainWindow.width - joynext.width)
            newX = mainWindow.width - joynext.width

        if (newY < 18)
            newY = 18

        if (newY > mainWindow.height - bubble.height)
            newY = mainWindow.height - bubble.height

        joynext.x = newX
        joynext.y = newY
    }

    // @disable-check M16
    Behavior on y {
        SmoothedAnimation {
            easing.type: Easing.Linear
            duration: 100
        }
    }

    // @disable-check M16
    Behavior on x {
        SmoothedAnimation {
            easing.type: Easing.Linear
            duration: 100
        }
    }

}
