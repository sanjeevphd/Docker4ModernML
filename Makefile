# Makefile for building Docker images and running Docker containers
#

# Note: Update the image version if the Dockerfile changes
image_version = "latest"
image_tag = "puppydog:${image_version}"
python_version = 3.9.13
dockerfile = Dockerfile

# The all-in-one image with pyenv, pdm, python, Jupyter, PyData Stack, etc.
docker-build:
	docker build --build-arg python_version=${python_version} -t ${image_tag} -f ${dockerfile} .

# Host volume to mount
host_volume ?= ${PWD}

# Note: delete the --rm option, if you plan to keep the container around after exiting it (may be to call docker commit).
docker-run:
	docker run -it --init --rm -v "${host_volume}:/root/work" ${image_tag}

docker-run-jupyter:
	docker run -it --init --rm -p 8888:8888 -v "${host_volume}:/root/work" ${image_tag}
