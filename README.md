# RFID-Based Inventory Control System

## Physical Setup

<img src="./images/SystemSetup.png" width="500" />

The R-BICS system consists of the following components:

- At least two **RFID gates** which scan incoming and outgoing RFID-tagged items. An RFID gate can be an *incoming* or an *outgoing* gate.
- A **server host** which hosts the R-BICS back-end. The back-end processes item scan events coming from the RFID gates and serves a web dashboard which displays information about current inventory levels.
- A **router** that creates a LAN which allows the RFID gates to communicate wirelessly with the server host. Any machine that is connected to the LAN can access the web dashboard.

## System Architecture

<img src="./images/SystemArchitecture.png" width="600" />

## Code Structure

This repository is organized into several subdirectories:

- **device** is dedicated to the RFID scanner device firmware

- **server** is dedicated to the inventory control system web dashboard and backend
