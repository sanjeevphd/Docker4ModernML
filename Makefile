###############################################################################
# Makefile for building Docker images and running Docker containers 
# with pyenv, pdm, PyData Stack, JupyterLab + more
# See documentation in Dockerfile for more information.
#
# Maintainer: Goopy Flux <goopy.flux@gmail.com>
###############################################################################

# Note: Update the image tag if the Dockerfile changes
# Local Image
image_name = puppydog
image_tag = latest
local_image = ${image_name}:${image_tag}

# Remote Repository on Docker Hub
docker_hub_repo = goopyflux/puppydog
remote_image = ${docker_hub_repo}:${image_tag}

python_version = 3.9.13
dockerfile = Dockerfile

# #############
# make commands
# #############

## Build the Docker image. Use python_version to specify Python version.
## (Ex. make docker-build python_version=3.10.5)
docker-build:
	docker build --build-arg python_version=${python_version} -t ${local_image} -f ${dockerfile} .

# Host volume to mount
host_volume ?= ${PWD}

# Note: delete the --rm option, if you wish to persist the container upon exit.
# Ex. may be to call `docker commit` to save the container as a new image.
## Run the JupyterLab Docker container. Use host_volume to specify local folder.
## (Ex. make docker-run host_volume=/home/user/work)
docker-run:
	docker run -it --init --rm -p 8888:8888 -v "${host_volume}:/root/work" ${local_image}

## Push the latest stable image to Docker Hub
docker-push:
	docker tag ${local_image} ${remote_image}
	docker push ${remote_image}

## Push the latest commits to remote GitHub repo (assumed to be setup).
git-push:
	git push -u origin main

#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
.PHONY: help
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')

