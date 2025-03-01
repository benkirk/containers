#DOCKER_BUILD_ARCH := --platform linux/amd64,linux/aarch64
#BUILDX_BUILDER    := cloud-ncarcisl-benkirk
#DOCKER_BUILDCLOUD := --builder $(BUILDX_BUILDER) --push
#DOCKER_BUILD_ARGS := --progress=auto $(DOCKER_BUILDCLOUD)

# include common rules for all containers
include $(shell git rev-parse --show-toplevel)/containers/Make.common
