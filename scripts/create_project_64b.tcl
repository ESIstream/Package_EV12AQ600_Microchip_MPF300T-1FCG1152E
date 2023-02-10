#-------------------------------------------------------------------------------
#-- This is free and unencumbered software released into the public domain.
#--
#-- Anyone is free to copy, modify, publish, use, compile, sell, or distribute
#-- this software, either in source code form or as a compiled bitstream, for 
#-- any purpose, commercial or non-commercial, and by any means.
#--
#-- In jurisdictions that recognize copyright laws, the author or authors of 
#-- this software dedicate any and all copyright interest in the software to 
#-- the public domain. We make this dedication for the benefit of the public at
#-- large and to the detriment of our heirs and successors. We intend this 
#-- dedication to be an overt act of relinquishment in perpetuity of all present
#-- and future rights to this software under copyright law.
#--
#-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
#-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABIqLITY, 
#-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#-- AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN 
#-- ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
#-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#--
#-- THIS DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES. 
#-------------------------------------------------------------------------------
set Proj "esistream_txrx_64b"
set family "PolarFire"
set die "MPF300T"
set package "FCG1152"
set hdl "VHDL"
set speed -1
set die_voltage 1.0
set OS     $tcl_platform(os)
set err     {0}
set Msg {Errors :0}

set ls_ch [open "project_check_status.txt" w+]

proc grepPattern { ex dumped_file } \
{
    set f_id [open $dumped_file]
    while {[eof $f_id]==0} \
    {
        set line_tokens [gets $f_id]
        if {[regexp $ex "$line_tokens"]==1} \
        {
            puts "Pattern $ex found"
            close $f_id
            return 1
        }
    }
    puts "Pattern $ex not found"
    close $f_id
    return 0
}


file delete -force ./../$Proj

new_project     -instantiate_in_smartdesign 1 \
                -ondemand_build_dh 1 \
                -use_enhanced_constraint_flow 1 \
                -location "./../$Proj" \
                -name $Proj \
                -hdl $hdl \
                -family $family \
                -die $die \
                -package $package \
                -speed $speed \
                -die_voltage $die_voltage

create_links \
         -convert_EDN_to_HDL 0 \
         -library {work} \
         -hdl_source {./../src/src_uart/clock_gen.vhd} \
         -hdl_source {./../src/src_uart/components.vhd} \
         -hdl_source {./../src/src_uart/coreuart_pkg.vhd} \
         -hdl_source {./../src/src_uart/CoreUART_C0.vhd} \
         -hdl_source {./../src/src_uart/CoreUART.vhd} \
         -hdl_source {./../src/src_uart/fifo_256x8_g5.vhd} \
         -hdl_source {./../src/src_uart/Rx_async.vhd} \
         -hdl_source {./../src/src_uart/Tx_async.vhd} \
         -hdl_source {./../src/src_common/spi_dual_master_fsm.vhd} \
         -hdl_source {./../src/src_common/spi_dual_master.vhd} \
         -hdl_source {./../src/src_common/spi_fifo.vhd} \
         -hdl_source {./../src/src_common/spi_refclk.vhd} \
         -hdl_source {./../src/src_common/axi4_lite_master.vhd} \
         -hdl_source {./../src/src_common/fifo_dc.vhd} \
         -hdl_source {./../src/src_common/ram_dual_clock.vhd} \
         -hdl_source {./../src/src_common/add_u12.vhd} \
         -hdl_source {./../src/src_common/delay.vhd} \
         -hdl_source {./../src/src_common/debouncer.vhd} \
         -hdl_source {./../src/src_common/meta.vhd} \
         -hdl_source {./../src/src_common/meta_re.vhd} \
         -hdl_source {./../src/src_common/register_map.vhd} \
         -hdl_source {./../src/src_common/register_map_fsm.vhd} \
         -hdl_source {./../src/src_common/risingedge.vhd} \
         -hdl_source {./../src/src_common/sysreset.vhd} \
         -hdl_source {./../src/src_common/timer.vhd} \
         -hdl_source {./../src/src_common/axi_uart_microsemi.vhd} \
         -hdl_source {./../src/src_common/uart_wrapper.vhd} \
         -hdl_source {./../src/src_common/tx_emu_data_gen_top.vhd} \
         -hdl_source {./../src/src_common/tx_emu_data_gen.vhd} \
         -hdl_source {./../src/src_common/txrx_frame_checking.vhd} \
         -hdl_source {./../src/src_common/component_pkg_64.vhd} \
         -hdl_source {./../src/src_esistream/esistream_pkg_64b.vhd} \
         -hdl_source {./../src/src_esistream/rx_control.vhd} \
         -hdl_source {./../src/src_esistream/rx_decoding.vhd} \
         -hdl_source {./../src/src_esistream/rx_esistream.vhd} \
         -hdl_source {./../src/src_esistream/rx_frame_alignment.vhd} \
         -hdl_source {./../src/src_esistream/rx_lane_decoding.vhd} \
         -hdl_source {./../src/src_esistream/rx_lfsr_init.vhd} \
         -hdl_source {./../src/src_esistream/rx_output_buffer_wrapper.vhd} \
         -hdl_source {./../src/src_esistream/tx_control.vhd} \
         -hdl_source {./../src/src_esistream/tx_disparity.vhd} \
         -hdl_source {./../src/src_esistream/tx_disparity_word_16b.vhd} \
         -hdl_source {./../src/src_esistream/tx_encoding.vhd} \
         -hdl_source {./../src/src_esistream/tx_esistream.vhd} \
         -hdl_source {./../src/src_esistream/tx_lfsr.vhd} \
         -hdl_source {./../src/src_esistream/tx_scrambling.vhd} \
         -hdl_source {./../src/src_esistream/tx_rx_esistream_with_xcvr.vhd} \
         -hdl_source {./../src/src_esistream/tx_rx_xcvr_wrapper_64b.vhd} \
         -hdl_source {./../src/src_top_txrx/src_top/tx_rx_esistream_top.vhd} \
         -stimulus {./../src/src_top_txrx/src_tb_top/tb_pkg.vhd} \
         -stimulus {./../src/src_top_txrx/src_tb_top/tb_tx_rx_esistream_top.vhd} \
         -io_pdc {./../src/src_top_txrx/constraints/constraints.pdc}\
         -fp_pdc {./../src/src_top_txrx/constraints/fp_64.pdc}\
         -sdc {./../src/src_top_txrx/constraints/timing_constraints_64.sdc}
         
source ./../src/src_ip/PF_TX_PLL_C0.tcl
source ./../src/src_ip/PF_TX_PLL_C1.tcl
source ./../src/src_ip/PF_CCC_C0.tcl
source ./../src/src_ip/PF_XCVR_ERM_C2.tcl
source ./../src/src_ip/PF_XCVR_ERM_C3.tcl
source ./../src/src_ip/PF_XCVR_REF_CLK_C0.tcl

generate_component -component_name {PF_TX_PLL_C0}
generate_component -component_name {PF_TX_PLL_C1}
generate_component -component_name {PF_CCC_C0}
generate_component -component_name {PF_XCVR_ERM_C2}
generate_component -component_name {PF_XCVR_ERM_C3}
generate_component -component_name {PF_XCVR_REF_CLK_C0}


build_design_hierarchy 
set_root -module {tx_rx_esistream_top::work} 

open_project -file {./../esistream_txrx_64b/esistream_txrx_64b.prjx}

organize_tool_files -tool {SYNTHESIZE} \
                    -file {./../src/src_top_txrx/constraints/timing_constraints_64.sdc} \
                    -input_type {constraint}

organize_tool_files -tool {PLACEROUTE} \
                    -file {./../src/src_top_txrx/constraints/constraints.pdc} \
                    -file {./../src/src_top_txrx/constraints/timing_constraints_64.sdc} \
                    -file {./../src/src_top_txrx/constraints/fp_64.pdc} \
                    -input_type {constraint}
organize_tool_files \
         -tool {VERIFYTIMING} \
         -file {./../src/src_top_txrx/constraints/timing_constraints_64.sdc} \
         -input_type {constraint}

associate_stimulus  -file {./../src/src_top_txrx/src_tb_top/tb_tx_rx_esistream_top.vhd} \
                    -mode new \
                    -module {tx_rx_esistream_top::work} 
					
build_design_hierarchy 
set_modelsim_options \
                   -sim_runtime {70 us} \
                   -tb_module_name {tb_tx_rx_esistream_top} \
                   -tb_top_level_name {tx_rx_esistream_top_1} \
                   -log_all_signals {TRUE} 

puts $ls_ch "PROJECT CREATED"



save_project
# close_project
