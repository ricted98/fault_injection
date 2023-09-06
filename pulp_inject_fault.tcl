# Copyright 2023 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
#
# Authors: Michael Rogenmoser (michaero@iis.ee.ethz.ch)
#          Riccardo Tedeschi  (riccardo.tedeschi4@studio.unibo.it)

transcript quietly

source tcl_files/fault_injection/extract_nets.tcl

set verbosity 3
set log_injections 1
set seed 12345

set inject_start_time 1411649098ps
set inject_stop_time 2596675306ps
set injection_clock "sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/clk_i"
set injection_clock_trigger 0
set fault_period 1000
set rand_initial_injection_phase 0
set max_num_fault_inject 10
set signal_fault_duration 19ns
set register_fault_duration 0ns

set allow_multi_bit_upset 1
set use_bitwidth_as_weight 0
set check_core_output_modification 0
set check_core_next_state_modification 0
set reg_to_sig_ratio 1

proc base_path {core} {return "sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top"} 

set inject_register_netlist []
set inject_signals_netlist  [concat {sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/if_stage_i/instr_out} \
                                    {sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/if_stage_i/instr_err_out} \
                                    {sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/if_stage_i/if_instr_err_plus2} \
                                    {sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/if_stage_i/if_instr_rdata} \
                                    {sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/if_stage_i/instr_is_compressed_out} \
                                    {sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/if_stage_i/illegal_c_instr_out} \
                                    {sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/if_stage_i/pc_if_o} \
                                    {sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/rf_in_raw.waddr} \
                                    {sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/rf_in_raw.wdata} \
                                    {sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/lsu_mem_raw.data_addr} \
                                    {sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/lsu_mem_raw.data_wdata} \
                                    {sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/lsu_mem_raw.data_be} \
                                    {sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/csr_in_raw.addr} \
                                    {sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/csr_in_raw.wdata} \
                            ]
set output_netlist []
set next_state_netlist []
set assertion_disable_list []

set core_signals [ extract_netlists [ concat    [ find nets -ports sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/data_* ] \
                                                [ find nets -ports sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/instr_* ] \
                                                [ find nets -ports sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/rf_* ] \
                                                [ find nets -internal sim:/tb_pulp/i_dut/soc_domain_i/pulp_soc_i/fc_subsystem_i/FC_CORE/lFC_CORE/u_ibex_top/u_ibex_core/pc_i? ] \
                                     ] ]

source tcl_files/fault_injection/inject_fault.tcl
