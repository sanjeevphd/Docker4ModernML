# Makefile for building Docker images and running Docker containers
#

# Note: Update the image version if the Dockerfile changes
image_version = "latest"
image_tag = "puppydog:${image_version}"
python_version = 3.9.13
dockerfile = Dockerfile
docker_hub_repo = "goopyflux/puppydog" # Remote Repository on Docker Hub
remote_image_tag = "${docker_hub_repo}:${image_version}"

# The all-in-one image with pyenv, pdm, python, Jupyter, PyData Stack, etc.
docker-build:
	docker build --build-arg python_version=${python_version} -t ${image_tag} -f ${dockerfile} .

# Host volume to mount
host_volume ?= ${PWD}

# Note: delete the --rm option, if you wish to persist the container upon exit.
# Ex. may be to call `docker commit` to save the container as a new image.
docker-run:
	docker run -it --init --rm -p 8888:8888 -v "${host_volume}:/root/work" ${image_tag}

docker-push:
	docker tag "${image_tag}" "${remote_image_tag}"
	docker push "${remote_image_tag}"

