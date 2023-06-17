RELEASE_VERSION :=$(shell cat .version)

## Variable assertions
ifndef RELEASE_VERSION
	$(error RELEASE_VERSION is not set)
endif

all: help

.PHONY: version
version: ## Prints the current version
	@echo $(RELEASE_VERSION)

.PHONY: init
init: ## Runs terraform fmt on all terraform files
	terraform -chdir=./deployments init

.PHONY: lint
lint: ## Runs terraform fmt on all terraform files
	terraform -chdir=./deployments fmt

.PHONY: valid
valid: ## Applies Terraform
	terraform -chdir=./deployments validate

.PHONY: apply
apply: ## Applies Terraform
	terraform -chdir=./deployments apply -auto-approve

.PHONY: refresh
refresh: ## Destroy Terraform
	terraform -chdir=./deployments refresh

.PHONY: destroy
destroy: ## Destroy Terraform
	terraform -chdir=./deployments destroy

.PHONY: tag
tag: ## Creates release tag 
	git tag -s -m "release $(RELEASE_VERSION)" $(RELEASE_VERSION)
	git push origin $(RELEASE_VERSION)

.PHONY: tagless
tagless: ## Delete the current release tag 
	git tag -d $(RELEASE_VERSION)
	git push --delete origin $(RELEASE_VERSION)

.PHONY: help
help: ## Display available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk \
		'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
