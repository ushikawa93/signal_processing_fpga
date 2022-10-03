# Archivo de temporización básico

create_clock -name "clock_50" -period 20.000ns [get_ports {clk}]
create_clock -name CLK_CUSTOM -period 15.000ns [get_registers {clk_custom}]

derive_pll_clocks
derive_clock_uncertainty

update_timing_netlist

set_false_path -from [get_clocks {clock_50}] -to [get_clocks {nios|nios2|pll|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}]
set_false_path -from [get_clocks {nios|nios2|pll|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -to [get_clocks {clock_50}]
