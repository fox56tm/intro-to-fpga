IVERILOG ?= iverilog
VVP ?= vvp
FLAGS = -g2012
SBY ?= sby

MODULES = implication not_implication peirce_arrow sheffer_stroke
SBY_TARGETS = peirce_arrow_bmc peirce_arrow_cover

.PHONY: all clean $(MODULES) $(SBY_TARGETS)

all: $(MODULES) formal

$(MODULES):
	mkdir -p build
	$(IVERILOG) $(FLAGS) -s ${@}_tb \
	 -o build/${@}.out \
	 exercises/${@}.sv testbenches_for_exer/${@}_tb.sv
	$(VVP) build/${@}.out

formal: $(SBY_TARGETS)

$(SBY_TARGETS):
	$(SBY) -f formal-verification/${@}.sby

clean:
	rm -rf build
	rm -rf *_bmc *_cover
