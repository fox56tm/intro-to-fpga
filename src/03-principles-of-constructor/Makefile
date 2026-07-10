IVERILOG ?= iverilog
VVP ?= vvp
FLAGS = -g2012
SBY ?= sby

EX1 = $(wildcard 1_exercise/*.sv)
EX2 = $(wildcard 2_exercise/*.sv)

.PHONY: all clean test formal

all: test

test:
	mkdir -p build
	$(IVERILOG) $(FLAGS) -s test_all_tb \
		-o build/test_all.out \
		3_exercise/test_all_tb.sv \
		../02-combination-logic/exercises/peirce_arrow.sv \
		 ../02-combination-logic/exercises/sheffer_stroke.sv \
		$(EX1) $(EX2)
	$(VVP) build/test_all.out

formal:
	$(SBY) -f 4_exercise/peirce_and_sheffer.sby

clean:
	rm -rf build
	rm -rf *_bmc *_cover
