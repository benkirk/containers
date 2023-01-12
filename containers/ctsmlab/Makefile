all: images

images:
	$(MAKE) image

image clean clobber push pull echo foo:
	for subdir in mpich-base deps esmf cesm postproc; do \
	  echo "Running $(MAKE) $(MAKECMDGOALS) for $${subdir} layer..." ; \
	  $(MAKE) -C $${subdir} $(MAKECMDGOALS) ; \
	done
