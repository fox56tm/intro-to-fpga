EXERCISES := $(wildcard *exercise*/.)

.PHONY: all clean $(EXERCISES)

all: $(EXERCISES)

$(EXERCISES):
	@$(MAKE) -C $@

ci: all
