transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Quartus\ II\ Project/TEST/rtl {D:/Quartus II Project/TEST/rtl/debounce.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II\ Project/TEST/rtl {D:/Quartus II Project/TEST/rtl/test.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II\ Project/TEST/rtl {D:/Quartus II Project/TEST/rtl/picture.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II\ Project/TEST/rtl {D:/Quartus II Project/TEST/rtl/clk_divide.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II\ Project/TEST/rtl {D:/Quartus II Project/TEST/rtl/cnt_10s.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II\ Project/TEST/rtl {D:/Quartus II Project/TEST/rtl/num.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II\ Project/TEST/rtl {D:/Quartus II Project/TEST/rtl/cnt_5s.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II\ Project/TEST/rtl {D:/Quartus II Project/TEST/rtl/breath led.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II\ Project/TEST/rtl {D:/Quartus II Project/TEST/rtl/clk_halfsecond.v}

vlog -vlog01compat -work work +incdir+D:/Quartus\ II\ Project/TEST/prj/../testbench {D:/Quartus II Project/TEST/prj/../testbench/clk_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L maxii_ver -L rtl_work -L work -voptargs="+acc"  clk_tb

add wave *
view structure
view signals
run -all
