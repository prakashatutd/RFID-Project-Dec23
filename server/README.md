# Inventory Control System

This directory contains the source code for the inventory control system (ICS) backed and web dashboard.

## Prerequisites

- Install [Docker](https://docs.docker.com/get-docker/)
- Install [Flutter](https://docs.flutter.dev/get-started/install)

Install required Python packages via:

```bash
python -m pip install -r requirements.txt
```

## Build web dashboard

In the `dashboard` directory, run

```bash
flutter build web
```

## Run server locally

For testing purposes, you can run the server locally without building a Docker container. To do so, navigate to the `ics` directory and run:

```bash
python manage.py runserver 0.0.0.0:8000
```

Open 127.0.0.1:8000 in a browser to access the web dashboard. Use Ctrl-C to stop the server.

## Build server container image

Ensure that Docker Desktop is running. In the `server` directory, run

```bash
docker build -t rfidserver .
```

You will need to rebuild the container image every time you make changes to the dashboard or backend.


## Run server container

Run the server Docker container on a port of your choosing (the following examples use port 8000):

 ```bash
 docker run --name rfid-ics -dp 8000:8000 rfidserver
 ```

The container will run in the background. Open 127.0.0.1:8000 in a browser to access the web dashboard.

## List containers

Use `docker container ls -a` to view a list of containers.

```
CONTAINER ID   IMAGE        COMMAND                  CREATED          STATUS    PORTS     NAMES
2c7ff2d4baaf   rfidserver   "python ics/manage.p…"   40 seconds ago   Created             rfid-ics
```

### Stop container

```bash
docker stop <container_name>

# Example
docker stop rfid-ics
```

### Start container

```bash
docker start <container_name>
docker start -i <container_name> # interactive mode, will output stdout to console

# Example
docker start rfid-ics
```

### Remove container

```bash
docker rm <container_name>

# Example
docker rm <rfid-ics>
```

Note that after removing a container you will need to create a container using `docker run` to run it again.