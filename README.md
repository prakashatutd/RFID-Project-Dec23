# RFID-Based Inventory Control System (R-BICS)

1. [Physical setup](#physical-setup)
2. [System architecture](#system-architecture)
3. [Current project state](#current-project-state)
4. [Future work](#future-work)

## Physical setup

<img src="./images/SystemSetup.png" align="middle" width="500" />

The R-BICS system consists of the following components:

- At least two **RFID gates** which scan RFID-tagged items. An RFID gate can be configured to either scan incoming or outgoing items.
- A **server** hosting the R-BICS back-end responsible for:
  - Processing scan events coming from RFID gates
  - Managing the warehouse inventory database
  - Serving a web dashboard that display information about current inventory levels

- A **router** establishing a LAN which:
  - Enables RFID gates to communicate wirelessly with the server host
  - Allows any connected device to access the web dashboard

## System architecture

<img src="./images/SystemArchitecture.png" align="middle" width="600" />

This repository is organized into two subdirectories:

- **device** is dedicated to the RFID scanner device firmware

- **server** is dedicated to the inventory control system web dashboard and back-end

## Current project state

Currently, the project has implemented the following functionality:

- Two RFID gates constructed, capable of scanning tags and displaying tag data via debug interface
- Beginning of back-end REST API, with inventory and scan history API endpoints
- Inventory web dashboard page
- Scan history web dashboard page

## Future work

### High priority tasks

1. Implement a communication protocol between RFID gates and back-end
2. Implement back-end processing of RFID gate scan events and updating of inventory database
3. Implement real-time web dashboard updates (in response to RFID gate scan events)
4. Add web dashboard page to view inventory levels over time (Trends)
5. Add web dashboard page to view status of connected RFID gates (Gates)
6. Improve existing web dashboard pages to show more information about products

### Medium priority tasks

1. Migrate SQLite database to something more production-ready (e.g. MySQL)
2. Migrate Django debug server to something more production-ready (e.g. Apache)
3. Complete Dockerization of back-end
4. Create enclosure for RFID gate controller and/or create more robust RFID gate prototype

### Everything else

- Add authentication to web dashboard
- Convert web dashboard to mobile app
- Possibly move to a cloud hosting service (e.g. AWS or GCP)

