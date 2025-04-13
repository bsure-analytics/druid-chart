GITHUB_REPOSITORY ?= $(shell git config --get remote.origin.url | sed -E 's/.*github.com[:\/](.*)\.git/\1/')
GITHUB_REPOSITORY_OWNER ?= $(shell echo $(GITHUB_REPOSITORY) | cut -d/ -f1)
GITHUB_REPOSITORY_NAME ?= $(shell echo $(GITHUB_REPOSITORY) | cut -d/ -f2)
HELM_NAMESPACE ?= $(NAMESPACE)
HELM_OPTS ?= $(OPTS)
HELM_RELEASE ?= $(RELEASE)
NAMESPACE ?= druid
RELEASE ?= $(NAMESPACE)
REPO_URL ?= https://$(GITHUB_REPOSITORY_OWNER).github.io/$(GITHUB_REPOSITORY_NAME)

.DEFAULT_GOAL := upgrade

.values.yaml:
	touch $@

.PHONY: diff
diff: .values.yaml
	helm diff upgrade $(HELM_RELEASE) . \
		--namespace $(HELM_NAMESPACE) \
		--values .values.yaml \
		$(HELM_OPTS)

.PHONY: dist
dist:
	helm package . --destination dist
	curl --fail --output-dir dist --remote-name --silent $(REPO_URL)/index.yaml || true
	helm repo index dist --merge dist/index.yaml --url $(REPO_URL)

.PHONY: template
template: .values.yaml
	helm template $(HELM_RELEASE) . \
		--namespace $(HELM_NAMESPACE) \
		--values .values.yaml \
		$(HELM_OPTS)

.PHONY: test
test: .values.yaml
	helm test $(HELM_RELEASE) \
		--namespace $(HELM_NAMESPACE) \
		--timeout 10m \
		--values .values.yaml \
		$(HELM_OPTS)

.PHONY: uninstall down
uninstall down:
	helm uninstall $(HELM_RELEASE) \
		--namespace $(HELM_NAMESPACE) \
		$(HELM_OPTS)

.PHONY: upgrade up
upgrade up: .values.yaml
	helm upgrade $(HELM_RELEASE) . \
		--create-namespace \
		--install \
		--namespace $(HELM_NAMESPACE) \
		--values .values.yaml \
		$(HELM_OPTS)
