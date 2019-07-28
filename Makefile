SHELL := /bin/bash

LOCAL_CONTAINER = abatilo/blog-builder
CONTAINER_NAME = blog
TAG = $(shell cat version.txt)
FULL_TAG = $(REGISTRY_URL)/$(CONTAINER_NAME):$(TAG)

.PHONY: help
help: ## View help information
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: login
login:
	echo $(REGISTRY_PASS) | docker login $(REGISTRY_URL) -u $(REGISTRY_USER) --password-stdin

.PHONY: build
build: ## Build the nginx container for serving my resume
	docker build -t $(FULL_TAG) .

.PHONY: push
push: login build ## Push the container to the configured docker registry
	docker push $(FULL_TAG)

.PHONY: run
run: build ## Run nginx container
	docker run -p8000:80 $(FULL_TAG)
