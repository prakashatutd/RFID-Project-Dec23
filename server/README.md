# Inventory Control Server

## Prerequisites

The server runs in a Docker container. Install Docker Desktop by following the instructions [here](https://docs.docker.com/get-docker/). **Docker Desktop must be running for the following steps to work.**

## Setup

Ensure that your working directory is `server` and build the Docker container image:

```
docker build -t rfidserver .
```
## Running the server

Run the Docker container on a port of your choosing (the following examples use port 8000):

 ```
 docker run -p 8000:8000 rfidserver
 ```

Open https://localhost:8000 in a browser to access the web app. Use Ctrl-C to stop the container.