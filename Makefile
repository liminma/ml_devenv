image_tag = liminma/ml_devenv

uid = $(shell id -u)
uname = devuser
gid = $(shell id -g)
gname = devuser

container_name = devenv
disable_jupyter_auth = yes

build:
	docker build \
	--build-arg USER_ID=$(uid) \
	--build-arg USER_NAME=$(uname) \
	--build-arg GROUP_ID=$(uid) \
	--build-arg GROUP_NAME=$(gname) \
	--build-arg DISABLE_JUPYTER_AUTH=$(disable_jupyter_auth) \
	--tag $(image_tag) \
	./src

debug:
	docker exec -it $(container_name) bash

start:
	docker run -d --init \
	-p 8888:8888 \
	--env NOTEBOOK_FOLDER=workspace/notebooks \
	--user $(uname):$(gname) \
	--gpus all \
	--name devenv \
	--volume $(project_folder):/home/$(uname)/workspace \
	--volume $(data_folder):/home/$(uname)/data \
	$(image_tag)

stop:
	docker stop $(container_name)

remove:
	docker rm $(container_name)

restart: stop remove start

logs:
	docker logs -f $(container_name)
