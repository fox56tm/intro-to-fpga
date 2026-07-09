IVERILOG ?= iverilog
VVP ?= vvp
FLAGS = -g2012
EXERCISES := $(wildcard *)

.PHONY: all clean $(MODULES)

all: $(MODULES)

$(MODULES):
	mkdir -p build
	$(IVERILOG) $(FLAGS) -s ${@} \
	 -o build/${@}.out \
	 exercises/${@}.sv 
	$(VVP) build/${@}.out

clean:
	rm -rf build
