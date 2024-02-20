# Copyright 2023 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
#
# Author: Michael Rogenmoser (michaero@iis.ee.ethz.ch)

transcript quietly

if { [info exists ::env(FAULT_INJECTION)] } {

    set script_path [file normalize [info script]]
    set script_dir  [file dirname $script_path]

    # Source generic netlist extraction procs
    source $script_dir/extract_nets.tcl

    set verbosity 3
    set log_injections 1
    set seed 12345

    set top_level_path "pulp_cluster_tb/cluster_i"

    set inject_start_time 250856000000ps
    set inject_stop_time 413000000000ps
    set injection_clock "$top_level_path/clk_i"
    set injection_clock_trigger 0
    set fault_period 500
    set rand_initial_injection_phase 0
    set max_num_fault_inject 20
    set signal_fault_duration 20ns
    set register_fault_duration 0ns

    set allow_multi_bit_upset 1
    set use_bitwidth_as_weight 0
    set check_core_output_modification 0
    set check_core_next_state_modification 0
    set reg_to_sig_ratio 1

    proc base_path {core} {return "$::top_level_path/CORE\[$core\]/core_region_i"}
    set inject_register_netlist []

    set inject_signals_netlist []
    # Add cluster cores
    for {set idx 0} {$idx < 8} {incr idx} {
        set output [extract_netlists [find nets [base_path $idx]/*]]
        set inject_signals_netlist [list {*}$inject_signals_netlist {*}$output]
    }

    set output_netlist []
    set next_state_netlist []
    set assertion_disable_list []

    source "$script_dir/inject_fault.tcl"

}
