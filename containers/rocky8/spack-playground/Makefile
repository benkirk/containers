DOCKER_RUN_ARGS := --mount source=rocky8_testbed,target="/pv" \
	           --mount source=rocky8_home,target="/home" \
	           --mount source=spack_cache,target="/cache-spack" \
	           --mount source=rocky8_tmpspack,target="/tmp-spack"

# include common rules for all containers
include $(shell git rev-parse --show-toplevel)/containers/Make.common
