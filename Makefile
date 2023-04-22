uid = $(shell id -u)
uname = devuser
gid = $(shell id -g)
gname = devuser

container_name = devenv
disable_jupyter_auth = yes
notebook_folder = workspace/notebooks

build_torch:
	docker build \
	--build-arg USER_ID=$(uid) \
	--build-arg USER_NAME=$(uname) \
	--build-arg GROUP_ID=$(uid) \
	--build-arg GROUP_NAME=$(gname) \
	--build-arg DISABLE_JUPYTER_AUTH=$(disable_jupyter_auth) \
	--target devenv_torch \
	--tag liminma/ml_devenv_torch \
	./src

start_torch:
		docker run -d --init \
		-p 8888:8888 \
		--gpus all \
		--env NOTEBOOK_FOLDER=workspace \
		--user $(uname):$(gname) \
		--name $(container_name) \
		--volume $(project_folder):/home/$(uname)/workspace \
		liminma/ml_devenv_torch

build_tf:
		docker build \
		--build-arg USER_ID=$(uid) \
		--build-arg USER_NAME=$(uname) \
		--build-arg GROUP_ID=$(uid) \
		--build-arg GROUP_NAME=$(gname) \
		--build-arg DISABLE_JUPYTER_AUTH=$(disable_jupyter_auth) \
		--target devenv_tf \
		--tag liminma/ml_devenv_tf \
		./src

start_tf:
	docker run -d --init \
	-p 8888:8888 \
	--gpus all \
	--env NOTEBOOK_FOLDER=$(notebook_folder) \
	--user $(uname):$(gname) \
	--name $(container_name) \
	--volume $(project_folder):/home/$(uname)/workspace \
	--volume $(data_folder):/home/$(uname)/data \
	liminma/ml_devenv_tf

debug:
	docker exec -it $(container_name) bash

stop:
	docker stop $(container_name)

remove:
	docker rm $(container_name)

force-remove:
	docker rm -f $(container_name)

restart: stop remove start

logs:
	docker logs -f $(container_name)
