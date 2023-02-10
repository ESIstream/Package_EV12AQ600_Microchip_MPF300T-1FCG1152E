onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_tx_rx_esistream_top/ADC_SCLK
add wave -noupdate /tb_tx_rx_esistream_top/ADC_CS_U
add wave -noupdate /tb_tx_rx_esistream_top/CSN_PLL
add wave -noupdate /tb_tx_rx_esistream_top/ADC_MISO
add wave -noupdate /tb_tx_rx_esistream_top/ADC_MOSI
add wave -noupdate /tb_tx_rx_esistream_top/PLL_MUXOUT
add wave -noupdate /tb_tx_rx_esistream_top/RSTN
add wave -noupdate /tb_tx_rx_esistream_top/SCLK
add wave -noupdate /tb_tx_rx_esistream_top/CSN
add wave -noupdate /tb_tx_rx_esistream_top/MISO
add wave -noupdate /tb_tx_rx_esistream_top/MOSI
add wave -noupdate -group tb /tb_tx_rx_esistream_top/sso_p
add wave -noupdate -group tb /tb_tx_rx_esistream_top/sso_n
add wave -noupdate -group tb /tb_tx_rx_esistream_top/CLK_50MHZ_I
add wave -noupdate -group tb /tb_tx_rx_esistream_top/clk_100
add wave -noupdate -group tb /tb_tx_rx_esistream_top/fmc_xcvr_out_p
add wave -noupdate -group tb /tb_tx_rx_esistream_top/fmc_xcvr_out_n
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SW1
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SW2
add wave -noupdate -group tb /tb_tx_rx_esistream_top/DIP1
add wave -noupdate -group tb /tb_tx_rx_esistream_top/DIP2
add wave -noupdate -group tb /tb_tx_rx_esistream_top/DIP3
add wave -noupdate -group tb /tb_tx_rx_esistream_top/DIP4
add wave -noupdate -group tb /tb_tx_rx_esistream_top/LED
add wave -noupdate -group tb /tb_tx_rx_esistream_top/led_uart_ready
add wave -noupdate -group tb /tb_tx_rx_esistream_top/led_sync_in
add wave -noupdate -group tb /tb_tx_rx_esistream_top/led_ip_ready
add wave -noupdate -group tb /tb_tx_rx_esistream_top/led_lanes_ready
add wave -noupdate -group tb /tb_tx_rx_esistream_top/led_isrunning
add wave -noupdate -group tb /tb_tx_rx_esistream_top/led_be_status
add wave -noupdate -group tb /tb_tx_rx_esistream_top/led_cb_status
add wave -noupdate -group tb /tb_tx_rx_esistream_top/led_valid_status
add wave -noupdate -group tb /tb_tx_rx_esistream_top/tx_ip_ready
add wave -noupdate -group tb /tb_tx_rx_esistream_top/rx_ip_ready
add wave -noupdate -group tb /tb_tx_rx_esistream_top/ip_ready
add wave -noupdate -group tb /tb_tx_rx_esistream_top/tx_d_ctrl
add wave -noupdate -group tb /tb_tx_rx_esistream_top/rx_prbs_en
add wave -noupdate -group tb /tb_tx_rx_esistream_top/tx_prbs_en
add wave -noupdate -group tb /tb_tx_rx_esistream_top/tx_disp_en
add wave -noupdate -group tb /tb_tx_rx_esistream_top/tx_lss
add wave -noupdate -group tb /tb_tx_rx_esistream_top/sync
add wave -noupdate -group tb /tb_tx_rx_esistream_top/tb_rst
add wave -noupdate -group tb /tb_tx_rx_esistream_top/tb_rstn
add wave -noupdate -group tb /tb_tx_rx_esistream_top/lfsr_init
add wave -noupdate -group tb /tb_tx_rx_esistream_top/clk_bit
add wave -noupdate -group tb /tb_tx_rx_esistream_top/tx_clk
add wave -noupdate -group tb /tb_tx_rx_esistream_top/txp
add wave -noupdate -group tb /tb_tx_rx_esistream_top/txn
add wave -noupdate -group tb /tb_tx_rx_esistream_top/uart_tx
add wave -noupdate -group tb /tb_tx_rx_esistream_top/uart_rx
add wave -noupdate -group tb /tb_tx_rx_esistream_top/m1_axi_addr
add wave -noupdate -group tb /tb_tx_rx_esistream_top/m1_axi_strb
add wave -noupdate -group tb /tb_tx_rx_esistream_top/m1_axi_wdata
add wave -noupdate -group tb /tb_tx_rx_esistream_top/m1_axi_rdata
add wave -noupdate -group tb /tb_tx_rx_esistream_top/m1_axi_wen
add wave -noupdate -group tb /tb_tx_rx_esistream_top/m1_axi_ren
add wave -noupdate -group tb /tb_tx_rx_esistream_top/m1_axi_busy
add wave -noupdate -group tb /tb_tx_rx_esistream_top/s1_interrupt
add wave -noupdate -group tb /tb_tx_rx_esistream_top/reg_0_0
add wave -noupdate -group tb /tb_tx_rx_esistream_top/reg_0_1
add wave -noupdate -group tb /tb_tx_rx_esistream_top/reg3
add wave -noupdate -group tb /tb_tx_rx_esistream_top/manual_mode
add wave -noupdate -group tb /tb_tx_rx_esistream_top/spare_0
add wave -noupdate -group tb /tb_tx_rx_esistream_top/FPGA_REF_CLK
add wave -noupdate -group tb /tb_tx_rx_esistream_top/ADC_SCLK
add wave -noupdate -group tb /tb_tx_rx_esistream_top/ADC_CS_U
add wave -noupdate -group tb /tb_tx_rx_esistream_top/CSN_PLL
add wave -noupdate -group tb /tb_tx_rx_esistream_top/ADC_MISO
add wave -noupdate -group tb /tb_tx_rx_esistream_top/ADC_MOSI
add wave -noupdate -group tb /tb_tx_rx_esistream_top/PLL_MUXOUT
add wave -noupdate -group tb /tb_tx_rx_esistream_top/RSTN
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SCLK
add wave -noupdate -group tb /tb_tx_rx_esistream_top/CSN
add wave -noupdate -group tb /tb_tx_rx_esistream_top/MISO
add wave -noupdate -group tb /tb_tx_rx_esistream_top/MOSI
add wave -noupdate -group tb /tb_tx_rx_esistream_top/REF_SEL_EXT
add wave -noupdate -group tb /tb_tx_rx_esistream_top/REF_SEL
add wave -noupdate -group tb /tb_tx_rx_esistream_top/HMC1031_D1
add wave -noupdate -group tb /tb_tx_rx_esistream_top/HMC1031_D0
add wave -noupdate -group tb /tb_tx_rx_esistream_top/CLK_SEL
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SYNC_SEL
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SYNCTRIG_P_DUT
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SYNCTRIG_N_DUT
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SYNCO_SEL
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SYNCO_P
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SYNCO_N
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SPARE_9
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SPARE_8
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SPARE_7
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SPARE_6
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SPARE_5
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SPARE_4
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SPARE_3
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SPARE_2
add wave -noupdate -group tb /tb_tx_rx_esistream_top/SPARE_1
add wave -noupdate -group tb /tb_tx_rx_esistream_top/C2M_LED1
add wave -noupdate -group tb /tb_tx_rx_esistream_top/C2M_LED2
add wave -noupdate -group tb /tb_tx_rx_esistream_top/C2M_LED3
add wave -noupdate -group tb /tb_tx_rx_esistream_top/C2M_LED4
add wave -noupdate -group tb /tb_tx_rx_esistream_top/M2C_CFG1
add wave -noupdate -group tb /tb_tx_rx_esistream_top/M2C_CFG2
add wave -noupdate -group tb /tb_tx_rx_esistream_top/M2C_CFG3
add wave -noupdate -group tb /tb_tx_rx_esistream_top/M2C_CFG4
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/rst
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/clk
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/d_ctrl
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/lanes_on
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/frame_out
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/valid_out
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/be_status
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/cb_status
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/valid_status
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/sum
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/u_sum
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/step
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/data_check_per_lane
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/data_check_all_lane
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/cb_check_per_lane
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/cb_check_all_lane
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/cb_out_d
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/data_out_12b
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/data_out_12b_d
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/valid_out_d1
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/valid_out_d2
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/valid_out_d3
add wave -noupdate -group {rx check} -format Analog-Step -height 74 -min -1.0 /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/valid_out_d4
add wave -noupdate -group {rx check} -format Analog-Step -height 74 -min -1.0 /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/valid_out_d5
add wave -noupdate -group {rx check} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/txrx_frame_checking_1/valid_out_d6
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/clk
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/rst
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/spi_ncs1
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/spi_ncs2
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/spi_sclk
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/spi_mosi
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/spi_miso
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/spi_ss
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/spi_start
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/spi_busy
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_in_wr_en
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_in_din
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_in_full
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_out_rd_en
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_out_dout
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_out_empty
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/refclk
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/refclk_re
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/refclk_fe
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/spi_start_re
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_in_rd_en
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_in_dout
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_in_empty
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_in_almost_empty
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_in_rd_counter
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_out_wr_en
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_out_din
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_out_full
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_out_almost_empty
add wave -noupdate -group {spi dual master} /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/spi_dual_master_1/fifo_out_rd_counter
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/clk
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/rstn
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/interrupt_en
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/m_axi_addr
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/m_axi_strb
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/m_axi_wdata
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/m_axi_rdata
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/m_axi_wen
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/m_axi_ren
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/m_axi_busy
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/interrupt
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/uart_ready
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_0
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_1
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_2
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_3
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_4
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_5
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_6
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_7
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_8
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_9
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_10
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_11
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_12
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_13
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_14
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_15
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_16
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_17
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_18
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_19
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_4_os
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_5_os
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_6_os
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_7_os
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_10_os
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_12_os
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_addr
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_rdata
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_wdata
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_wen
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_ren
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_0_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_1_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_2_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_3_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_4_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_5_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_6_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_7_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_8_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_9_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_10_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_11_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_12_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_13_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_14_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_15_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_16_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_17_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_18_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/reg_19_m
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/n_m_axi_busy
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/n_m_axi_busy_re
add wave -noupdate /tb_tx_rx_esistream_top/tx_rx_esistream_top_1/register_map_1/interrupt_mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {637299347 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1032594939 ps}
