dockerfiles := $(shell find ./containers -type f -maxdepth 3 -name Dockerfile)
image_dirs  := $(shell find ./containers -type f -maxdepth 3 -name Dockerfile | xargs -n 1 dirname)
images      := $(patsubst ./containers/%, %, $(image_dirs))
images2     := $(subst /,-,$(images))


clobber:
	find ./containers/ -type d -name extras | xargs -n 1 rm -rf
	find ./containers/ -type l -name extras | xargs -n 1 rm

echo:
	echo "dockerfiles : " $(dockerfiles)
	echo "image_dirs  : " $(image_dirs)
	echo "images      : " $(images)
	echo "images2     : " $(images2)
