CHART_VERSION ?= $(shell yq '.version' ../druid/Chart.yaml)
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

.PHONY: dependency-update init
dependency-update init:
	CHART_VERSION="$(CHART_VERSION)" \
		yq -i \
		'.version = strenv(CHART_VERSION) | (.dependencies[] | select(.name == "druid")).version = "^" + strenv(CHART_VERSION)' \
		Chart.yaml
	[[ "$(CHART_VERSION)" =~ -SNAPSHOT$$ ]] || \
		REPO_URL="$(REPO_URL)" \
		    yq -i \
	        '(.dependencies[] | select(.name == "druid")).repository = strenv(REPO_URL)' \
	        Chart.yaml
	helm dependency update

.PHONY: diff
diff:
	helm diff upgrade $(HELM_RELEASE) . \
		--context 3 \
		--namespace $(HELM_NAMESPACE) \
		$(HELM_OPTS)

.PHONY: template
template:
	helm template $(HELM_RELEASE) . \
		--namespace $(HELM_NAMESPACE) \
		$(HELM_OPTS)

.PHONY: test
test:
	helm test $(HELM_RELEASE) \
		--namespace $(HELM_NAMESPACE) \
		--timeout 10m \
		$(HELM_OPTS)

.PHONY: uninstall down
uninstall down:
	helm uninstall $(HELM_RELEASE) \
		--namespace $(HELM_NAMESPACE) \
		$(HELM_OPTS)

.PHONY: upgrade up
upgrade up:
	helm upgrade $(HELM_RELEASE) . \
		--create-namespace \
		--install \
		--namespace $(HELM_NAMESPACE) \
		$(HELM_OPTS)
