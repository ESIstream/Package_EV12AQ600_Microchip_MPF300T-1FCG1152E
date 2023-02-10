# Microsemi Corp.
# Date: 2022-Nov-24 16:35:58
# This file was generated based on the following SDC source files:
#   C:/Users/bahri/Desktop/e2v_esistream/FPGA/project/esistream_txrx_64b/component/work/PF_CCC_C0/PF_CCC_C0_0/PF_CCC_C0_PF_CCC_C0_0_PF_CCC.sdc
#   C:/Users/bahri/Desktop/e2v_esistream/FPGA/project/esistream_txrx_64b/component/work/PF_TX_PLL_C0/PF_TX_PLL_C0_0/PF_TX_PLL_C0_PF_TX_PLL_C0_0_PF_TX_PLL.sdc
#   C:/Users/bahri/Desktop/e2v_esistream/FPGA/project/esistream_txrx_64b/component/work/PF_TX_PLL_C1/PF_TX_PLL_C1_0/PF_TX_PLL_C1_PF_TX_PLL_C1_0_PF_TX_PLL.sdc
#   C:/Users/bahri/Desktop/e2v_esistream/FPGA/project/esistream_txrx_64b/component/work/PF_XCVR_ERM_C2/I_XCVR/PF_XCVR_ERM_C2_I_XCVR_PF_XCVR.sdc
#   C:/Users/bahri/Desktop/e2v_esistream/FPGA/project/esistream_txrx_64b/component/work/PF_XCVR_ERM_C3/I_XCVR/PF_XCVR_ERM_C3_I_XCVR_PF_XCVR.sdc
#
create_clock -name {CLK_50MHZ_I} -period 20 [ get_ports { CLK_50MHZ_I } ]
create_clock -name {sso_p} -period 6.4 [ get_ports { sso_p } ]
create_clock -name {TX_CLK_L0_1} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_1/I_XCVR/LANE0/TX_CLK_R } ]
create_clock -name {RX_CLK_L0_1} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_1/I_XCVR/LANE0/RX_CLK_R } ]
create_clock -name {TX_CLK_L1_1} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_1/I_XCVR/LANE1/TX_CLK_R } ]
create_clock -name {RX_CLK_L1_1} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_1/I_XCVR/LANE1/RX_CLK_R } ]
create_clock -name {TX_CLK_L2_1} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_1/I_XCVR/LANE2/TX_CLK_R } ]
create_clock -name {RX_CLK_L2_1} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_1/I_XCVR/LANE2/RX_CLK_R } ]
create_clock -name {TX_CLK_L3_1} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_1/I_XCVR/LANE3/TX_CLK_R } ]
create_clock -name {RX_CLK_L3_1} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_1/I_XCVR/LANE3/RX_CLK_R } ]
create_clock -name {TX_CLK_L0_2} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_2/I_XCVR/LANE0/TX_CLK_R } ]
create_clock -name {RX_CLK_L0_2} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_2/I_XCVR/LANE0/RX_CLK_R } ]
create_clock -name {TX_CLK_L1_2} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_2/I_XCVR/LANE1/TX_CLK_R } ]
create_clock -name {RX_CLK_L1_2} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_2/I_XCVR/LANE1/RX_CLK_R } ]
create_clock -name {TX_CLK_L2_2} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_2/I_XCVR/LANE2/TX_CLK_R } ]
create_clock -name {RX_CLK_L2_2} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_2/I_XCVR/LANE2/RX_CLK_R } ]
create_clock -name {TX_CLK_L3_2} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_2/I_XCVR/LANE3/TX_CLK_R } ]
create_clock -name {RX_CLK_L3_2} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_2/I_XCVR/LANE3/RX_CLK_R } ]
#
create_clock -name {TX_CLK_G} -period 6.4 [ get_pins { gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/i_txrx_4lanes_64b_2/I_XCVR/LANE1_TX_IcbClkDiv/Y_DIV } ]
create_generated_clock -name {CLK_50MHz} -multiply_by 1 -source [ get_pins { i_pll_sys/PF_CCC_C0_0/pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { i_pll_sys/PF_CCC_C0_0/pll_inst_0/OUT0 } ]
create_generated_clock -name {CLK_100MHz} -multiply_by 2 -source [ get_pins { i_pll_sys/PF_CCC_C0_0/pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { i_pll_sys/PF_CCC_C0_0/pll_inst_0/OUT1 } ]
create_generated_clock -name {CLK_150MHz} -multiply_by 3 -source [ get_pins { i_pll_sys/PF_CCC_C0_0/pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { i_pll_sys/PF_CCC_C0_0/pll_inst_0/OUT2 } ]
create_generated_clock -name {CLK_300MHz} -multiply_by 6 -source [ get_pins { i_pll_sys/PF_CCC_C0_0/pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { i_pll_sys/PF_CCC_C0_0/pll_inst_0/OUT3 } ]
#
set_false_path -from [get_clocks sso_p] -to [get_clocks CLK_100MHz]
set_false_path -from [get_clocks CLK_100MHz] -to [get_clocks TX_CLK_G]
set_false_path -from [get_clocks CLK_100MHz] -to [get_clocks TX_CLK_L*]
set_false_path -from [get_clocks CLK_100MHz] -to [get_clocks RX_CLK_L*]
set_false_path -from [get_clocks CLK_100MHz] -to [get_clocks sso_p]
set_false_path -from [get_clocks CLK_50MHZ_I] -to [get_clocks TX_CLK_G]
set_false_path -from [get_clocks CLK_50MHZ_I] -to [get_clocks TX_CLK_L*]
set_false_path -from [get_clocks CLK_50MHZ_I] -to [get_clocks RX_CLK_L*]
set_false_path -from [get_clocks CLK_50MHZ_I] -to [get_clocks sso_p]
set_false_path -from [get_clocks sso_p] -to [get_clocks CLK_100MHz]
set_false_path -from [get_clocks sso_p] -to [get_clocks RX_CLK_L*]
set_false_path -from [get_clocks RX_CLK_L*] -to [get_clocks sso_p]
set_false_path -from [get_clocks RX_CLK_L*] -to [get_clocks TX_CLK_L*]
set_false_path -from [get_clocks TX_CLK_L*] -to [get_clocks CLK_100MHz]
#
set_clock_groups -asynchronous -group {CLK_100MHz} \
                               -group {CLK_50MHZ_I} 