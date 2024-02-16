envs ?= gcc intel nvhpc

all:
	@echo "Building envs: $(envs)"

image tag:
	@echo "Building $@ in envs: $(envs)"
	make -C base $@
	for env in $(envs); do \
	  make -C $${env}-build-environment $@; \
	done
	for env in $(envs); do \
	  make -C $${env} $@; \
	done

# don't push base
push:
	@echo "Pushing $@ in envs: $(envs)"
	for env in $(envs); do \
	  make -C $${env}-build-environment $@; \
	done
	for env in $(envs); do \
	  make -C $${env} $@; \
	done
