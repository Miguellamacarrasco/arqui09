all: compile execute

compile:
	iverilog testbench.v ALU.v arithmetic.v gates.v logical.v mipsmem.v mipsmulti.v sign_extend.v topmulti.v

execute:
	./a.out