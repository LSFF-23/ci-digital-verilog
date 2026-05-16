create_clock -name main_clk -period 5.000 [get_ports {clk}]
set_false_path -from [get_ports {rst}]
set_false_path -to [get_ports {leds[*]}]