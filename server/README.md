# Inventory Control System

This directory contains the source code for the inventory control system (ICS) back-end and web dashboard.

## Building

### Prerequisites

- Install [Flutter](https://docs.flutter.dev/get-started/install) for the web dashboard front-end
- Install [Docker](https://docs.docker.com/get-docker/) to run the server in a container (optional for development)
- Install required Python packages via:

```bash
python -m pip install -r requirements.txt
```

### Development build

Simply run the `run.sh` (Mac and Unix-like systems) or `run.cmd` (Windows) script in your terminal to build the web dashboard and run the server locally.

You can also manually build the dashboard:

```bash
# Working directory should be server/dashboard
flutter build web
```

. . . and manually start the server:


```bash
# Working directory should be server
python ics/manage.py runserver
```

Navigate to:
- `127.0.0.1:8000/admin` to access the admin page (username and password are both `admin`)
- `127.0.0.1:8000/api` to access the backend API
- `127.0.0.1:8000/dashboard` to access the dashboard

Use Ctrl-C to stop the server.

## Development

### Prerequisites

We use [Flutter](https://flutter.dev/) for the front-end and [Django](https://www.djangoproject.com/) with the [REST framework](https://www.django-rest-framework.org/) for the back-end. It is recommended to complete, at a minimum, (most of) the [Django tutorial](https://docs.djangoproject.com/en/5.0/intro/tutorial01/) and [REST framework tutorial](https://www.django-rest-framework.org/tutorial/1-serialization/) before beginning development.

### Code Structure

```
server
├── dashboard
│   ├── build
|   |   └── web
│   ├── lib
│   ├── test
│   └── web
├── dockerfile
└── ics
    ├── dashboard
    ├── ics
    ├── manage.py
    └── media
```

#### Flutter project

`server/dashboard` is the base directory of the Flutter project, with source code files living in `lib` and build output in `build`. When the Django application is run, it serves the `build/web` directory.

#### Django application

`server/ics` is the base directory of the Django app.

## Containerized deployment

We will deploy our server application in a Docker container. To build the container, first ensure that Docker Desktop is running and then run:

```bash
# Working directory should be server
docker build -t rfidserver .
```

You will need to rebuild the container image every time you make changes to the dashboard or back-end.


#### Run container

Run the server Docker container on a port of your choosing (the following examples use port 8000):

 ```bash
 docker run --name rfid-ics -dp 8000:8000 rfidserver
 ```

The container will run in the background. Open `127.0.0.1:8000` in a browser to access the web dashboard.

#### List containers

Use `docker container ls -a` to view a list of containers:

```
CONTAINER ID   IMAGE        COMMAND                  CREATED          STATUS    PORTS     NAMES
2c7ff2d4baaf   rfidserver   "python ics/manage.p…"   40 seconds ago   Created             rfid-ics
```

#### Stop container

```bash
docker stop <container_name>

# Example
docker stop rfid-ics
```

#### Start container

```bash
docker start <container_name>
docker start -i <container_name> # interactive mode, will output stdout to console

# Example
docker start rfid-ics
```

#### Remove container

```bash
docker rm <container_name>

# Example
docker rm <rfid-ics>
```

Note that after removing a container you will need to create a container using `docker run` to run it again.