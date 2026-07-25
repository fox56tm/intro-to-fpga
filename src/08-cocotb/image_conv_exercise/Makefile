EXERCISES := $(wildcard tests/*/.)

.PHONY: all clean $(EXERCISES)

all: $(EXERCISES)

$(EXERCISES):
	@$(MAKE) -C $@

clean:
	for dir in $(EXERCISES); do \
		$(MAKE) -C $$dir clean; \
	done

ci: all
