# RFID Gate

## Hardware Overview

An RFID gate consists of an **antenna assembly** and a detachable **controller unit**.

### Antenna Assembly

We use a Sparkfun [UHF RFID antenna](https://www.sparkfun.com/products/14131) mounted on a PVC pipe stand. It has a reliable read range of approximately one meter at 27 dBi (max power).

<img src="./images/Gate1.jpg" align="middle" height="400" /> <img src="./images/Gate2.jpg" align="middle" height="400" />

Because the antenna uses an RP-TNC connector, we use an [RP-TNC to RP-SMA conversion cable](https://www.sparkfun.com/products/14132) to connect it to the controller unit.

### Controller

The controller unit consists of a [Sparkfun Simultaneous RFID Reader](https://www.sparkfun.com/products/14066) (SRTR) mounted on an [Arduino UNO R4 WiFi](https://docs.arduino.cc/hardware/uno-r4-wifi/). A [U.FL to RP-SMA conversion cable](https://www.sparkfun.com/products/662) is used to connect it to the antenna.

<img src="./images/Controller.jpg" width="500" />

The controller can be powered either via USB-C or barrel jack power supply. It is recommended to use the barrel jack power supply since the 500 mA supplied by a USB-C connection will not allow the antenna to operate at full power.

To attach the controller to the antenna assembly:

1. Carefully slot the controller into the plastic holder on the side of the stand, making sure that the end with the coax cable is pointing upwards. Push down on the *edges* of the Arduino (avoid pushing the SRTR) until the controller is firmly attached.
2. Screw the RP-SMA connectors together. Be careful with the U.FL to RP-SMA cable because it is fragile.

## Firmware Overview