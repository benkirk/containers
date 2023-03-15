dockerfiles := $(shell find ./containers -maxdepth 3 -type f -name Dockerfile)
image_dirs  := $(shell find ./containers -maxdepth 3 -type f -name Dockerfile | xargs -n 1 dirname)
images      := $(patsubst ./containers/%, %, $(image_dirs))
images2     := $(subst /,-,$(images))

clean:
	rm -f *~ TAGS

echo:
	@echo "dockerfiles : " $(dockerfiles)
	@echo "image_dirs  : " $(image_dirs)
	@echo "images      : " $(images)
	@echo "images2     : " $(images2)
	for image_dir in $(images) ; do \
	  echo "(Not) recursing into $${image_dir}" ; \
	done

tags TAGS etags:
	if [ "x$(STR)" != "x" ]; then \
	  echo "Tagging files containing $(STR)" ; \
	  git grep -l $(STR) ; \
	  etags $$(git grep -l $(STR)) ; \
	else \
	  echo "Tagging all git managed files:" ; \
	  git ls-tree -r HEAD --name-only ; \
	  etags $$(git ls-tree -r HEAD --name-only) ; \
	fi

clobber:
	git clean -xdi . --exclude=shared_volume

# any other rule, if not specified here, run on each container
%:
	for image_dir in $(images) ; do \
	  echo "Running $(MAKE) $(MAKECMDGOALS) in ./containers/$${image_dir}..." ; \
	  $(MAKE) -C ./containers/$${image_dir} $(MAKECMDGOALS) ; \
	done
