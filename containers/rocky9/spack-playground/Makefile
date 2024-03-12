DOCKER_RUN_ARGS := --mount source=rocky9_testbed,target="/pv" \
	           --mount source=rocky9_home,target="/home" \
	           --mount source=spack_cache,target="/cache-spack" \
	           --mount source=rocky9_tmpspack,target="/tmp-spack"

# include common rules for all containers
include $(shell git rev-parse --show-toplevel)/containers/Make.common
