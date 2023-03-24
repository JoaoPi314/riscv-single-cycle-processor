all: run dump wave

run:
	@iverilog -g2012 ../sv/riscv* top.sv

dump:
	@vvp a.out

wave:
	@gtkwave waves.vcd
