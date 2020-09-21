# Docker 101

## Docker Breakdown

Main docker components:
* Images
* Containers
* Volumes
* Networks

Images are snapshots of a system including OS, dependencies, and sometimes source code.
- Can be sourced from a registry or built “ad-hoc”
- Registries
    - Docker Hub
    - ECR
    - Something proprietary
    - Local
- Built using a Dockerfile
- All Dockerfiles start with the FROM directive
    - This directive specifies the base image for the Dockerfile to build off of
- Other Dockerfile directives ADD, COPY, RUN, WORKDIR, VOLUME, CMD, ENTRYPOINT, ARG, ENV, EXPOSE
    - ADD, COPY, RUN, and WORKDIR are the most common
    - VOLUME is largely symbolic because a host machine’s directory can’t be mounted into an image
    - EXPOSE is entirely symbolic and is used to document which ports _should_ be published to the host machine
    - ARG is a neat parameter for making a Docker image configurable
        - A frequent use of mine (include arg example)
    - ENV is for setting environment variables
    - CMD specifies the default command to run when the container starts b

### Images

Example

        FROM python:3.7.8
        
        # by default the WORKDIR is /
        
        ENV HOST='0.0.0.0'
        
        RUN apt-get update && apt-get install -y vim
        
        ADD https://unpkg.com/react@16/umd/react.development.js /app/react.dev.js
        
        COPY ./requirements.txt /app/requirements.txt
        
        COPY ./ /app  # this is the thing my last job did
        
        COPY ./app.py /app/app.py
        
        WORKDIR /app
        
        RUN pip install -r requirements.txt
        
        EXPOSE 5000
        
        CMD ["python", "app.py"]

The above Dockerfile breaksdown as follows:
1. Start from the Python 3.7.8 Docker image
1. Update apt-get repos and install vim
1. Add the remote file `https://unpkg.com/react@16/umd/react.development.js` file into the image as `/app/react.dev.js` at the cwd
1. Copy the `requirements.txt` file in the cwd into the image as `/app/requirements.txt` at the cwd
1. Copy the `app.py` file in the cwd into the image as `/app/app.py` at the cwd
1. Document the port that should be exposed
1. Run the command `pip install -r requirements.txt` from the images cwd
1. Declare what the default command is

Note: ADD and COPY are identical except ADD also allows copying files from remote locations.

To build the image:

        docker build -t docker101 .

### Containers

Containers are running instances of images with lifecycles. They are lightweight abstractions that allow
a user to start multiple instances of the same image.

Example that expands on the previous

        docker run -p 127.0.0.1:5000:5000 docker101

### Volumes

Volumes are Docker’s way of maintaining state between container lifecycles and mounting files on the host machine into the container
- Volumes can be named or directly mounted from the host machine
- Named volumes are great for maintaining state for databases between container lifecycles
- Host machine directories are primarily used for sharing source code with the container

### Networks

Networks are for connecting containers to each other and the host machine. They are not something you’ll 
encounter or use often, but it adds an additional layer of configurability.

## Docker Compose Breakdown

Docker Compose is a basic container orchestration tool that sits on top of Docker.
Docker Compose uses a yaml file to programmatically specify what an application’s running state should look like. 
The yaml file is typically named docker-compose.yaml.

Main Docker Compose Components:
* Version
* Services
  * Ports
  * Environment
* Volumes
* Networks

Example:

        version: "3.8"
        services:
          flask:
            build:
              context: .
            image: 'docker101'
            command: "python app.py"
            ports:
            - 5000:5000
            volumes:
              - ./:/app

Version is important because it determines which features of Docker Compose are available to the file

Services are the components of the running application state. The services dict might specify a mysql database, a web gateway, and a python application.

Ports and Environment are important settings of services that allow the end-user to specify custom directives that
a container will use during runtime.

Volumes and Networks are extensions of the respective features in Docker exposed via an easy-to-use interface.

Additional Reading:

Dockerfile reference - https://docs.docker.com/engine/reference/builder/

Docker Compose file reference - https://docs.docker.com/compose/compose-file/
