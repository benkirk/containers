DOCKER_RUN_ARGS := --mount source=opensuse15_testbed,target="/pv" \
	           --mount source=opensuse15_home,target="/home" \
	           --mount source=spack_cache,target="/cache-spack" \
	           --mount source=opensuse15_tmpspack,target="/tmp-spack"

# include common rules for all containers
include $(shell git rev-parse --show-toplevel)/containers/Make.common
