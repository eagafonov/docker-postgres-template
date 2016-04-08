DBUSER_NAME?=dbuser
DBUSER_PASSWORD?=qwerty
POSTGRES_PASSWORD?=mysecretpassword

DBUSER_PASSWORD_CHECK?=asdfg

DOCKER_TAG?=postgres-template

VOLUMES_ROOT:=$(shell pwd)/volumes
all:

build:
	docker build -t $(DOCKER_TAG) .

run-shell:
	docker run -ti --rm  $(DOCKER_TAG) /bin/bash

run-check:
	-docker stop postgres-template-check
	-docker rm postgres-template-check
	-sudo rm -Rf $(VOLUMES_ROOT)/test

	docker run -d \
		--name postgres-template-check \
		-e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) \
		-e DBUSER_PASSWORD=$(DBUSER_PASSWORD_CHECK) \
		-e DBUSER_NAME=$(DBUSER_NAME) \
		-v $(VOLUMES_ROOT)/test:/var/lib/postgresql/data\
		$(DOCKER_TAG)

	sleep 3 # Let DB start
	echo Password is $(DBUSER_PASSWORD_CHECK)
	docker run -ti --rm --link postgres-template-check:masterdb $(DOCKER_TAG) psql --host=masterdb --user=dbuser

	docker stop postgres-template-check
	docker rm postgres-template-check

run-dev:
	docker run \
		-e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) \
		-e DBUSER_PASSWORD=$(DBUSER_PASSWORD) \
		-e DBUSER_NAME=$(DBUSER_NAME) \
		-ti --rm \
		-v $(VOLUMES_ROOT)/dev:/var/lib/postgresql/data \
		-p 127.1.0.1:5432:5432 \
		$(DOCKER_TAG)
run-default:
	docker run \
		--name postgres-template-1 \
		-e POSTGRES_PASSWORD=password \
		-ti --rm \
		-v $(VOLUMES_ROOT)/dev:/var/lib/postgresql/data \
		-p 127.1.0.1:5432:5432 \
		$(DOCKER_TAG)


