# Container Build Infrastructure through GNU Make
Heavily Inspired by https://github.com/TACC/tacc-containers

## Usage
In the examples below, `host$` indicates commands intended to be run on your host (container builder) machine, `container$` indicates commands run inside a running container.

### Building & Running Specific Containers
#### Minimal example
```bash
# build a minimal CentOS 7 container, run it as root
host$ cd ./containers/centos7/base/
host$ make image
host$ make run

# enter the container and do something.
# this will will occur in the temporary overlay layer, and as such will not persist 
# when you exit the container and later restart
container$ yum -y install which gcc
container$ which gcc && gcc --version
/usr/bin/gcc
gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-44)
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

#### Passing optional parameters to the container runtime
```bash
# build an OpenHPC-2 image on top of OpenSUSE.
host$ cd containers/opensuse15/OpenHPC
host$ make image

# run the container (will be the 'plainuser' account added in the container definition Dockerfile):
host$ make run
container$ whoami
plainuser

# use the DOCKER_RUN_ARGS to pass any desired arguments to 'docker run' ; in this
# case we specify --user to select a different user than default.
# see 'docker run --help for other options.'
host$ DOCKER_RUN_ARGS="--user root" make run
container$ whoami
root
```

#### Layered Containers
We can build complex containers as a sequence of layers.  This is useful for example when an intermediate layer could be useful for multiple derived containers, or in its own right.  In the example below we create a fully featured Rocky 9 container, including some application dependencies compiled from source, then use that as a base layer to install an application environment.
```bash
# Build the Rocky 9 image, containing some scientific libraries of interest:
host$ cd containers/rocky9/libmesh-prereqs/
host$ make image

# Builld a derived container on top of the previous, 
# installing the libMesh finite element library:
host$ cd ../libmesh
host$ make image
host$ make run

container$ find /opt/local/libmesh
```  

### Interacting with DockerHub
We support publishing tagged versions of a container to [DockerHub](https://hub.docker.com/) for sharing.

#### Publishing a container with `docker push`
```bash
cd containers/rocky9/libmesh

make image
make push
```

#### Pulling a previously published container
```bash
cd containers/rocky9/libmesh

make pull
make run
```

#### Micromanaging the image `tag`
```bash
cd containers/rocky9/libmesh
 
# print some metadata used to tag the image, inferred from the environment
make echo
# -------------------------------------------------------------
# docker program:	 /usr/local/bin/docker
# dockerhub root:	 benjaminkirk
# top_dir:		 /Users/benkirk/codes/benkirk-containers
# this_dir:		 /Users/benkirk/codes/benkirk-containers/containers/rocky9/libmesh
# label:		 rocky9-libmesh
# version:		 0.0.1
# image tag:		 benjaminkirk/rocky9-libmesh:0.0.1
# -------------------------------------------------------------


# specifically, the tag that will be attached to the image:
make echo_tag
benjaminkirk/rocky9-libmesh:0.0.1

# different components of the tag can be overridden:
make echo_tag dockerhubroot="my/special/project"
my/special/project/rocky9-libmesh:0.0.1

# the version simply defaults to 0.0.1
# optionally, if the file ./Version exists, its contents will be used.
# or, the version can be specified manually
make echo_tag version="3.14159"
benjaminkirk/rocky9-libmesh:3.14159

# or the whole tag altogether:
make echo_tag image_tag="oneoff_donotuse:0.0.0"
oneoff_donotuse:0.0.0

# make the image and push, using specified tag components
make image version="3.14159" dockerhubroot="my/special/project"
make push version="3.14159" dockerhubroot="my/special/project"
```
