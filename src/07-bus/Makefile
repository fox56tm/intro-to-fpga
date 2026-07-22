IVERILOG ?= iverilog
VVP ?= vvp
FLAGS = -g2012

.PHONY: all clean

all: | build
	$(IVERILOG) $(FLAGS) -o build/test1.out 1_exercise/*.sv && $(VVP) build/test1.out
	$(IVERILOG) $(FLAGS) -o build/build2 2_exercise/*.sv
	$(IVERILOG) $(FLAGS) -o build/build3 3_exercise/*.sv
	$(IVERILOG) $(FLAGS) -o build/build4 4_exercise/*.sv
	$(IVERILOG) $(FLAGS) -o build/build5 5_exercise/*.sv ../05-types/4_exercise/scalar_product.sv\
	 4_exercise/windowed.sv ../05-types/3_exercise/float_mult_byte_modified.sv 
	

build:
	mkdir -p build

clean:
	rm -rf build
