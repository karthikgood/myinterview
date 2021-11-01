Docker

docker save -o fedora-all.tar fedora
docker load -i file_name.tar
docker cp source_path containerid:destination_path

docker build .
docker build -f text1.text1
docker build  -t test:1.20.1
docker build --no-cache
docker build --build-arg a =5

         Dockerfile <br />
         
         from busybox
         run echo "test"
         ARG a
         run echo "$a"

docker build --compress . 
--force-rm --> Always remove intermediate containers
--quiet , -q --> Suppress the build output and print image ID on success
--rm true --> Remove intermediate containers after a successful build 


    docker history shows history of image.
    docker tag tags an image to a name (local or registry).


Docker basic commands

    docker info —>info about how many containers,images e.t.c
    docker —>docker command format , older way is - -docker ((both works)
    docker container run --publish 80:80 --detach nginx —> to start container in background
    docker container ls. —> list of containers(use -a to list all containers)
    docker container stop {container_id} -> to stop a container
    docker container logs {containerName} to see the logs
    docker container top {container Name) —> list the processes running in docker container
    docker container rm -f(to forcibly remove a container even if it is running)
    docker container inspect — details and configuration of a container
    docker container stats — live performance statistics of a container
    docker container update --help —> Update configuration of one or more containers even if they are running

Docker shell commands:

    docker container run -it —> start new container interactively
    docker container run exec -it —> run additional commands inside container (exec runs only inside a cotainer which is already started)
    docker container run --rm -it --name ununtu ubuntu:14.04 bash(to run bash command at the time of container creation, exec works only on already running/stopped containers)
    docker container run -it --name nginx nginx bash -> to run bash shell without SSH
    docker container start -ai {containerName} —> to start container in shell mode if it is stopped
    docker container exec -it {containerId} bash—>Run a command in a running container —> when we exit from this shell, container wont stop bcz exec will start additional process and it wont effect existing one

Docker Networking:

    docker container port {container} —> to get the port number on which we are mapping the traffic
    docker container inspect --format '{{ .NetworkSettings.IPAddress }}' {conainerId} —> to get IP address of a container
    docker network ls - to get the list of N/W’s
    docker network inspect {networkName} —> we can see images in this command output id they r mapped
    docker network create {networkName} —> to create a network, which will create with default driver bridge, we can use —driver to specify the driver, otherwise default option it will take(bridge)
    docker container run -p 81:80 --name nginx2 --network {networkName} -d nginx (to create with specific network}
    docker network connect {netwrokId} {containerId}, use disconnect in place of connect to disconnect from a network

Docker networkd:DNS

    docker exec -it {containerName} ping {anotherContainer}— using this we can ping another a container from other container(prerequistie: they both should be in same network) using built in DNS network
    docker container run --network-alias search --net test -d elasticsearch:2 —> to create a container with DNS alias(—network-alias) and with network test
    docker container run --rm --net test alpine nslookup search —> it will search for nslookup DNS entry “search” inside that n/w
    If we run “docker container run --rm --net test centos curl -s search:9200” it will give different different outputs between two DNS servers

Docker Images:

    docker image history {image_name} —> will list the changes in a image..not changes in container, whatver we do a change on a image it will create a new layer
    docker image inspect nginx —> returns the metadata of that image
    docker image tag mongo (new name ex:deekshith:mango} —> to tag an existing image with different name
    cat ~/.docker/config.json —this file will have all the credentials(In Mac it will store in keychain)
    docker image push {imageName} —> to push to docker hub after login using “docker login” command

DockerFIle:

    docker image build -t customnginx .

Docker Volumes:

    docker volume prune —> to cleanup unused volumes
    docker image inspect mysql
    docker volume ls —> will list the volumes
    docker volume inspect {volumeName} —> will give info about that volume
    docker container run -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=True -v mysql-db:/var/lib/mysql mysql(named volume)
    docker volume create —> required to do this before “docker run” to use custom drivers and labels

Bind Mount:

    docker container run -d --name nginx -p 80:80 -v $(pwd):/usr/share/nginx/html nginx —> mounting a directory

Docker Compose:

    docker-compose up —> to start (use docker-compose -d to start the service in background)
    docker-compose down —> to stop
    docker-compose logs —> to see the logs
    docker-compose top -> to see the list of processes
    docker-compose down -v —> to remove named volumes
    docker-compose down —rmi —> Iyt will remove the image at the time of removing compose
    docker-compose up -d --scale database=4

Docker System:

    docker system df —> will tell you the space used by images,container,local volumes
    docker system prune —> will remove all the things except the running container and its volumes.
    docker image prune, docker container prune …we can use this also
    docker system prune -a —>Remove all unused images not just dangling ones



    .dockerignore
    FROM Sets the Base Image for subsequent instructions.
    MAINTAINER (deprecated - use LABEL instead) Set the Author field of the generated images.
    RUN execute any commands in a new layer on top of the current image and commit the results.
    CMD provide defaults for an executing container.
    EXPOSE informs Docker that the container listens on the specified network ports at runtime. NOTE: does not actually make ports accessible.
    ENV sets environment variable.
    ADD copies new files, directories or remote file to container. Invalidates caches. Avoid ADD and use COPY instead.
    COPY copies new files or directories to container. Note that this only copies as root, so you have to chown manually regardless of your USER / WORKDIR setting, as same as ADD. See https://github.com/moby/moby/issues/30110
    ENTRYPOINT configures a container that will run as an executable.
    VOLUME creates a mount point for externally mounted volumes or other containers.
    USER sets the user name for following RUN / CMD / ENTRYPOINT commands.
    WORKDIR sets the working directory.
    ARG defines a build-time variable.
    ONBUILD adds a trigger instruction when the image is used as the base for another build.
    STOPSIGNAL sets the system call signal that will be sent to the container to exit.
    LABEL apply key/value metadata to your images, containers, or daemons.

SECURITY
docker run --pids-limit=64
docker -d --icc=false --iptables
docker run --read-only
docker run -v $(pwd)/secrets:/secrets:ro debian

Prune

The new Data Management Commands have landed as of Docker 1.13:

    docker system prune
    docker volume prune
    docker network prune
    docker container prune
    docker image prune

docker inspect $(dl) | grep -wm1 IPAddress | cut -d '"' -f 4
Get Environment Settings

docker run --rm ubuntu env

Kill running containers

docker kill $(docker ps -q)

Delete all containers (force!! running or stopped containers)

docker rm -f $(docker ps -qa)

Delete old containers

docker ps -a | grep 'weeks ago' | awk '{print $1}' | xargs docker rm

Delete stopped containers

docker rm -v $(docker ps -a -q -f status=exited)

Delete containers after stopping

docker stop $(docker ps -aq) && docker rm -v $(docker ps -aq)

Delete dangling images

docker rmi $(docker images -q -f dangling=true)

Delete all images

docker rmi $(docker images -q)

Delete dangling volumes

As of Docker 1.9:

docker volume rm $(docker volume ls -q -f dangling=true)

/var/lib/docker/volumes/