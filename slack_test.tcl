define_corners ff tt ss
read_liberty -corner tt pdk_files/sky130_fd_sc_hd__tt_025C_1v80.lib
read_liberty -corner ss pdk_files/sky130_fd_sc_hd__ss_n40C_1v76.lib
read_liberty -corner ff pdk_files/sky130_fd_sc_hd__ff_n40C_1v76.lib


read_verilog  src/tt_um_revenantx86_tinytpu.v
link_design tt_um_revenantx86_tinytpu
read_spef src/tt_um_revenantx86_tinytpu.nom.spef


#In Nano Seconds
create_clock -name clk -period 10 {clk}

set_clock_uncertainty 0.1 [all_clocks]
set_clock_transition  0.1 [all_clocks]

set_input_delay  -min  0.5 -clock [all_clocks]  [all_inputs]
set_input_delay  -max  0.5 -clock [all_clocks]  [all_inputs]

set_output_delay -min -2.5 -clock [all_clocks] [all_outputs]
set_output_delay -max -2.5 -clock [all_clocks] [all_outputs]

set_propagated_clock [all_clocks]

puts "Marker A"

#report_check_types -violators

#report_checks -sort_by_slack -path_delay min -fields {slew cap input nets fanout} -format full_clock_expanded -group_count 1000 

#report_checks -unconstrained -fields {slew cap input nets fanout} -format full_clock_expanded 

report_clock_skew -hold 
report_annotated_check -hold 

#report_parasitic_annotation -report_unannotated 

#report_checks -path_delay min -format full_clock_expanded 

#report_annotated_delay -net -list_not_annotated

#report_worst_slack -min
report_checks -path_delay min_max
report_checks -corner tt