bundle_dir = "/container"

DOCKER_BUILD_ARGS := --progress=plain --build-arg BUILD_STAGE_PATH=$(bundle_dir)

DOCKER_RUN_ARGS := --mount source=WRF_build_support,target=$(bundle_dir)

# include common rules for all containers
include $(shell git rev-parse --show-toplevel)/containers/Make.common
