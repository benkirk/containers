bundle_dir = "/my/awesome/app"

DOCKER_BUILD_ARGS := --progress=plain --build-arg APP_STAGE_PATH=$(bundle_dir)

DOCKER_RUN_ARGS := --mount source=demo_libmesh_app,target=$(bundle_dir)

# include common rules for all containers
include $(shell git rev-parse --show-toplevel)/containers/Make.common
