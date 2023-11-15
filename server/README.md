# Inventory Control System

This directory contains the source code for the inventory control system (ICS) back-end and web dashboard.

## Prerequisites

- Install [Flutter](https://docs.flutter.dev/get-started/install) for the web dashboard front-end
- Install [Docker](https://docs.docker.com/get-docker/) to run the server in a container (optional)

Install required Python packages via:

```bash
python -m pip install -r requirements.txt
```

## Build and run locally

Simply run the `run.sh` (Mac and Unix-like systems) or `run.cmd` (Windows) script in your terminal to build the web dashboard and run the server locally.

You can also manually build the dashboard:

```bash
# Working directory should be server/dashboard
flutter build web
```

. . . and manually start the server:


```bash
# Working directory should be server
python ics/manage.py runserver 0.0.0.0:8000
```

Open 127.0.0.1:8000 in a browser to access the dashboard. Use Ctrl-C to stop the server.

## Build server container image

We will deploy our server application in a Docker container. To build the container, first ensure that Docker Desktop is running then run:

```bash
# Working directory should be server
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

Use `docker container ls -a` to view a list of containers:

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