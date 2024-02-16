envs ?= gcc intel nvhpc

DOCKER_BUILD_ARGS ?= --progress=auto

all:
	@echo "Building envs: $(envs)"

image tag:
	@echo "Building $@ in envs: $(envs)"
	DOCKER_BUILD_ARGS="$(DOCKER_BUILD_ARGS)" make -C base $@
	for env in $(envs); do \
	  DOCKER_BUILD_ARGS="$(DOCKER_BUILD_ARGS)" make -C $${env}-build-environment $@; \
	done
	for env in $(envs); do \
	  DOCKER_BUILD_ARGS="$(DOCKER_BUILD_ARGS)" make -C $${env} $@; \
	done

# don't push base
push:
	@echo "Pushing $@ in envs: $(envs)"
	for env in $(envs); do \
	  DOCKER_BUILD_ARGS="$(DOCKER_BUILD_ARGS)" make -C $${env}-build-environment $@; \
	done; \
	for env in $(envs); do \
	  DOCKER_BUILD_ARGS="$(DOCKER_BUILD_ARGS)" make -C $${env} $@; \
	done
	@echo "All done on $$(date)"
