IVERILOG ?= iverilog
VVP ?= vvp
FLAGS = -g2012

MODULES = implication not_implication peirce_arrow sheffer_stroke

.PHONY: all clean $(MODULES)

all: $(MODULES)

$(MODULES):
	mkdir -p build
	$(IVERILOG) $(FLAGS) -s ${@}_tb \
	 -o build/${@}.out \
	 exercises/${@}.sv testbenches_for_exer/${@}_tb.sv
	$(VVP) build/${@}.out

clean:
	rm -rf build
