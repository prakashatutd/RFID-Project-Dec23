# Inventory Control System

This directory contains the source code for the inventory control system (ICS) backed and web dashboard.

## Prerequisites

- Install [Docker](https://docs.docker.com/get-docker/)
- Install [Flutter](https://docs.flutter.dev/get-started/install)

## Building Web Dashboard

In the `dashboard` directory, run

```
flutter build web --base-href=/build/web/
```

## Building Server Container

Ensure that Docker Desktop is running. In the `server` directory, run

```
docker build -t rfidserver .
```

You will need to rebuild the container every time you make changes to the dashboard or backend.


## Running the server container

Run the server Docker container on a port of your choosing (the following examples use port 8000):

 ```
 docker run --name rfid-ics -dp 8000:8000 rfidserver
 ```

The container will run in the background. Open 127.0.0.1:8000/dashboard in a browser to access the web dashboard. Use Ctrl-C to stop the container.

## Stopping and restarting the container

Use `docker container ls -a` to view a list of containers.

```
CONTAINER ID   IMAGE        COMMAND                  CREATED          STATUS    PORTS     NAMES
2c7ff2d4baaf   rfidserver   "python ics/manage.p…"   40 seconds ago   Created             rfid-ics
```

To stop the container, use `docker stop rfid-ics`. To start it again, use `docker start rfid-ics`. To remove the container, use `docker rm rfid-ics`. After removal you will need to use `docker run` to create and run it again.