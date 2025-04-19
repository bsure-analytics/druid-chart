.DEFAULT_GOAL := upgrade

.PHONY: %
%:
	$(MAKE) --directory=charts/druid-dev $*
