HELM_NAMESPACE ?= $(NAMESPACE)
HELM_OPTS ?= $(OPTS)
HELM_RELEASE ?= $(RELEASE)
NAMESPACE ?= druid
RELEASE ?= $(NAMESPACE)

.DEFAULT_GOAL := upgrade

.values.yaml:
	touch $@

.PHONY: diff
diff: .values.yaml
	helm diff upgrade $(HELM_RELEASE) . \
		--namespace $(HELM_NAMESPACE) \
		--values .values.yaml \
		$(HELM_OPTS)

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
