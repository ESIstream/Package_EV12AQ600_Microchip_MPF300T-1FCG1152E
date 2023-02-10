-------------------------------------------------------------------------------
-- This is free and unencumbered software released into the public domain.
--
-- Anyone is free to copy, modify, publish, use, compile, sell, or distribute
-- this software, either in source code form or as a compiled bitstream, for 
-- any purpose, commercial or non-commercial, and by any means.
--
-- In jurisdictions that recognize copyright laws, the author or authors of 
-- this software dedicate any and all copyright interest in the software to 
-- the public domain. We make this dedication for the benefit of the public at
-- large and to the detriment of our heirs and successors. We intend this 
-- dedication to be an overt act of relinquishment in perpetuity of all present
-- and future rights to this software under copyright law.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN 
-- ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
-- THIS DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES. 
-------------------------------------------------------------------------------
-- Version      Date            Author       Description
-- 1.0          2019            Teledyne e2v Creation
-- 1.1          2019            REFLEXCES    FPGA target migration, 64-bit data path
-- 2.0          2021            Teledyne e2v uart, regmap, frame checking, 16-bit/32-bit/64-bit
-------------------------------------------------------------------------------

library work;
use work.esistream_pkg.all;
use work.component_pkg.all;

library IEEE;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

library polarfire;
use polarfire.all;

entity tx_rx_esistream_top is
  generic(
    GEN_ESISTREAM : boolean                       := true;
    GEN_GPIO      : boolean                       := false;
    NB_LANES      : integer                       := 8;
    RST_CNTR_INIT : std_logic_vector(11 downto 0) := x"000";
    NB_CLK_CYC    : std_logic_vector(31 downto 0) := x"00000000";
    CLK_MHz       : real                          := 100.0;
    SPI_CLK_MHz   : real                          := 5.0;
    DEB_WIDTH     : integer                       := 25
    );
  port (
    sso_n          : in  std_logic;                              -- mgtrefclk from transceiver clock input
    sso_p          : in  std_logic;                              -- mgtrefclk from transceiver clock input
    --sso_ref_n      : out std_logic;
    --sso_ref_p      : out std_logic;
    CLK_50MHZ_I    : in  std_logic;                              -- sysclk
    rxp            : in  std_logic_vector(NB_LANES-1 downto 0);  -- lane serial input p
    rxn            : in  std_logic_vector(NB_LANES-1 downto 0);  -- lane Serial input n
    txp            : out std_logic_vector(NB_LANES-1 downto 0);  -- lane serial input p
    txn            : out std_logic_vector(NB_LANES-1 downto 0);  -- lane Serial input n
    SW1            : in  std_logic;
    SW2            : in  std_logic;
    DIP1           : in  std_logic;
    DIP2           : in  std_logic;
    DIP3           : in  std_logic;
    DIP4           : in  std_logic;
    LED            : out std_logic_vector(3 downto 0);
    FTDI_UART1_TXD : in  std_logic;                              -- CP2105 USB to UART output 
    FTDI_UART1_RXD : out std_logic;                              -- CP2105 USB to UART input
    -- EV12AQ600-FMC-EVM: 
    FPGA_REF_CLK   : out std_logic;                              -- LA00_P_CC 
    ADC_SCLK       : out std_logic;                              -- LA01_P_CC / PLL and TEMPERATURE Monitoring ADC SPI SCLK
    ADC_CS_U       : out std_logic;                              -- LA09_N / TEMPERATURE Monitoring ADC SPI chip select
    CSN_PLL        : out std_logic;                              -- LA11_P / PLL SPI chip select
    ADC_MISO       : in  std_logic;                              -- LA13_P / TEMPERATURE Monitoring ADC MISO
    ADC_MOSI       : out std_logic;                              -- LA13_N / PLL and TEMPERATURE Monitoring ADC MOSI
    PLL_MUXOUT     : in  std_logic;                              -- LA16_P / PLL MUXOUT, can be configured as PLL LOCK or PLL SPI MISO.
    RSTN           : out std_logic;                              -- LA10_N / EV12AQ600 ADC RSTN
    SCLK           : out std_logic;                              -- LA14_P / EV12AQ600 ADC SPI SCLK
    CSN            : out std_logic;                              -- LA20_P / EV12AQ600 ADC SPI chip select
    MISO           : in  std_logic;                              -- LA06_N / EV12AQ600 ADC SPI MISO
    MOSI           : out std_logic;                              -- LA20_N / EV12AQ600 ADC SPI MOSI
    REF_SEL_EXT    : out std_logic;                              -- LA03_P
    REF_SEL        : out std_logic;                              -- LA03_N
    HMC1031_D1     : out std_logic;                              -- LA05_P   
    HMC1031_D0     : out std_logic;                              -- LA05_N
    CLK_SEL        : out std_logic;                              -- LA08_P
    SYNC_SEL       : out std_logic;                              -- LA12_P
    SYNCTRIG_P_DUT : out std_logic;                              -- LA04_P
    SYNCTRIG_N_DUT : out std_logic;                              -- LA04_N
    SYNCO_SEL      : out std_logic;                              -- LA08_N
    SYNCO_P        : in  std_logic;                              -- LA28_P
    SYNCO_N        : in  std_logic;                              -- LA28_N
    SPARE_9        : in  std_logic;                              -- LA14_N / UART_RX 
    SPARE_8        : in  std_logic;                              -- LA10_P / UART_TX
    SPARE_7        : in  std_logic;                              -- LA06_P
    SPARE_6        : in  std_logic;                              -- LA09_P
    SPARE_5        : in  std_logic;                              -- LA16_N
    SPARE_4        : in  std_logic;                              -- LA07_P
    SPARE_3        : in  std_logic;                              -- LA07_N
    SPARE_2        : in  std_logic;                              -- LA12_N
    SPARE_1        : in  std_logic;                              -- LA11_N
    C2M_LED1       : out std_logic;                              -- LA15_P
    C2M_LED2       : out std_logic;                              -- LA15_N
    C2M_LED3       : out std_logic;                              -- LA19_P
    C2M_LED4       : out std_logic;                              -- LA19_N
    M2C_CFG1       : in  std_logic;                              -- LA15_P
    M2C_CFG2       : in  std_logic;                              -- LA15_N
    M2C_CFG3       : in  std_logic;                              -- LA19_P
    M2C_CFG4       : in  std_logic                               -- LA19_N
    );
end entity tx_rx_esistream_top;

architecture rtl of tx_rx_esistream_top is

  --------------------------------------------------------------------------------------------------------------------
  --! signal name description:
  -- _sr = _shift_register
  -- _re = _rising_edge (one clk period pulse generated on the rising edge of the initial signal)
  -- _fe = _falling_edge (one clk period pulse generated on the falling edge of the initial signal)
  -- _d  = _delay
  -- _2d = _delay x2
  -- _ba = _bitwise_and
  -- _sw = _slide_window
  -- _o  = _output
  -- _i  = _input
  -- _t  = _temporary or _tristate pin (OBUFT)
  -- _a  = _asychronous (fsm output decode signal)
  -- _s  = _synchronous (fsm synchronous output signal)
  -- _rs = _resynchronized (when there is a clock domain crossing)
  --------------------------------------------------------------------------------------------------------------------
  attribute keep                         : string;
  constant ALL_LANES_ON                  : std_logic_vector(NB_LANES-1 downto 0) := (others => '1');
  constant ALL_LANES_OFF                 : std_logic_vector(NB_LANES-1 downto 0) := (others => '0');
  signal sysrstn                         : std_logic                             := '0';
  signal sysclk                          : std_logic                             := '0';
  signal sysclk2                         : std_logic                             := '0';
  signal sysclk3                         : std_logic                             := '0';
  signal syslock                         : std_logic                             := '0';
  signal rx_clk                          : std_logic                             := '0';
  attribute keep of rx_clk               : signal is "true";
  signal tx_clk                          : std_logic                             := '0';
  attribute keep of tx_clk               : signal is "true";
  signal reg_rst                         : std_logic                             := '0';
  signal reg_rst_check                   : std_logic                             := '0';
  signal sw_rst                          : std_logic                             := '0';
  signal sw_rst_check                    : std_logic                             := '0';
  signal rst_in                          : std_logic                             := '0';
  signal rst_deb                         : std_logic                             := '0';
  signal rst_t                           : std_logic                             := '0';
  signal rst_re                          : std_logic                             := '0';
  signal rst_check                       : std_logic                             := '0';
  signal rst_check_rs                    : std_logic                             := '0';
  signal rst_check_re                    : std_logic                             := '0';
  signal sync_in                         : std_logic                             := '0';
  signal sync_deb                        : std_logic                             := '0';
  signal sync_meta                       : std_logic                             := '0';
  signal sync_reg                        : std_logic;
  signal rx_sync_in                      : std_logic                             := '0';
  signal rx_ip_ready                     : std_logic                             := '0';
  signal rx_lanes_on                     : std_logic_vector(NB_LANES-1 downto 0) := (others => '1');
  signal rx_lanes_ready                  : std_logic                             := '0';
  signal rx_release_data                 : std_logic                             := '0';
  signal rx_prbs_en                      : std_logic                             := '1';
  signal tx_sync_in                      : std_logic                             := '0';
  signal tx_prbs_en                      : std_logic                             := '1';
  signal tx_disp_en                      : std_logic                             := '1';
  signal tx_lfsr_init                    : slv_17_array_n(NB_LANES-1 downto 0)   := (others => (others => '1'));
  signal tx_data_in                      : tx_data_array(NB_LANES-1 downto 0)    := (others => (others => (others => '0')));
  signal tx_ip_ready                     : std_logic                             := '0';
  signal tx_emu_d_ctrl                   : std_logic_vector(1 downto 0)          := "00";
  signal dsw_tx_emu_d_ctrl               : std_logic_vector(1 downto 0)          := "00";
  signal dsw_prbs_en                     : std_logic                             := '1';
  signal dsw_disp_en                     : std_logic                             := '1';
  --
  signal fifo_dout                       : data_array(NB_LANES-1 downto 0);
  signal fifo_rd_en                      : std_logic_vector(NB_LANES-1 downto 0) := (others => '0');
  signal fifo_empty                      : std_logic_vector(NB_LANES-1 downto 0) := (others => '0');
  --
  signal be_status                       : std_logic                             := '0';
  signal cb_status                       : std_logic                             := '0';
  signal valid_status                    : std_logic                             := '0';
  --
  signal aq600_prbs_en                   : std_logic                             := '1';
  signal clk_acq                         : std_logic                             := '0';
  signal s_reset_i                       : std_logic                             := '0';
  signal s_resetn_i                      : std_logic                             := '0';
  signal s_resetn_re                     : std_logic                             := '0';
  signal rx_rst                          : std_logic                             := '0';
  signal rx_nrst                         : std_logic                             := '1';
  signal fb_clk                          : std_logic                             := '0';
  --
  type rx_data_array_12b is array (natural range <>) of slv_12_array_n(DESER_WIDTH/16-1 downto 0);
  signal data_out_12b                    : rx_data_array_12b(NB_LANES-1 downto 0);
  --
  signal frame_out                       : rx_frame_array(NB_LANES-1 downto 0);
  signal frame_out_d                     : rx_frame_array(NB_LANES-1 downto 0);
  signal valid_out                       : std_logic_vector(NB_LANES-1 downto 0) := (others => '0');
  --
  signal m_axi_addr                      : std_logic_vector(3 downto 0)          := (others => '0');
  signal m_axi_strb                      : std_logic_vector(3 downto 0)          := (others => '0');
  signal m_axi_wdata                     : std_logic_vector(31 downto 0)         := (others => '0');
  signal m_axi_rdata                     : std_logic_vector(31 downto 0)         := (others => '0');
  signal m_axi_wen                       : std_logic                             := '0';
  signal m_axi_ren                       : std_logic                             := '0';
  signal m_axi_busy                      : std_logic                             := '0';
  signal s_interrupt                     : std_logic                             := '0';
  --
  signal reg_0                           : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_1                           : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_2                           : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_3                           : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_4                           : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_5                           : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_6                           : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_7                           : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_8                           : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_9                           : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_10                          : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_11                          : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_12                          : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_13                          : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_14                          : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_15                          : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_16                          : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_17                          : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_18                          : std_logic_vector(31 downto 0)         := (others => '0');
  signal reg_19                          : std_logic_vector(31 downto 0)         := (others => '0');
  --
  signal uart_ready                      : std_logic                             := '0';
  --
  signal reg_4_os                        : std_logic                             := '0';
  signal reg_5_os                        : std_logic                             := '0';
  signal reg_6_os                        : std_logic                             := '0';
  signal reg_7_os                        : std_logic                             := '0';
  signal reg_10_os                       : std_logic                             := '0';
  signal reg_12_os                       : std_logic                             := '0';
  --
  constant FIFO_DATA_WIDTH               : integer                               := 24;
  signal spi_ncs1                        : std_logic                             := '1';
  signal spi_ncs2                        : std_logic                             := '1';
  signal spi_sclk                        : std_logic                             := '0';
  signal spi_mosi                        : std_logic                             := '0';
  signal spi_miso                        : std_logic                             := '0';
  signal spi_ss                          : std_logic;
  signal spi_start                       : std_logic;
  signal fifo_in_wr_en                   : std_logic;
  signal fifo_in_din                     : std_logic_vector(FIFO_DATA_WIDTH-1 downto 0);
  signal fifo_in_full                    : std_logic;
  signal fifo_out_rd_en                  : std_logic;
  signal fifo_out_dout                   : std_logic_vector(FIFO_DATA_WIDTH-1 downto 0);
  signal fifo_out_empty                  : std_logic;
  --
  signal adc_synco                       : std_logic                             := '0';
  --
  attribute MARK_DEBUG                   : string;
  attribute MARK_DEBUG of rx_sync_in     : signal is "true";
  attribute MARK_DEBUG of rx_ip_ready    : signal is "true";
  attribute MARK_DEBUG of rx_lanes_ready : signal is "true";
  attribute MARK_DEBUG of cb_status      : signal is "true";
  attribute MARK_DEBUG of be_status      : signal is "true";
  attribute MARK_DEBUG of data_out_12b   : signal is "true";
  attribute MARK_DEBUG of valid_out      : signal is "true";
  --
  component OUTBUF_DIFF
    port (
      -- Inputs
      D    : in  std_logic;
      -- Outputs
      PADP : out std_logic;
      PADN : out std_logic
      );
  end component;
  --
  component INBUF_DIFF
    port (
      -- Inputs
      PADP : in  std_logic;
      PADN : in  std_logic;
      -- Outputs
      Y    : out std_logic
      );
  end component;
--
begin
  --
  --------------------------------------------------------------------------------------------
  -- User interface:
  --------------------------------------------------------------------------------------------
  --
  C2M_LED1             <= PLL_MUXOUT;
  C2M_LED2             <= '0';
  C2M_LED3             <= '0';
  C2M_LED4             <= '0';
  -------------------------
  -- push-buttons
  -------------------------
  rst_in               <= not SW1;
  sync_in              <= not SW2;
  -------------------------
  -- SW2 switch
  -------------------------
  dsw_tx_emu_d_ctrl(0) <= DIP1;
  dsw_tx_emu_d_ctrl(1) <= DIP2;
  dsw_prbs_en          <= DIP3;
  dsw_disp_en          <= DIP4;
  --
  -------------------------
  -- LEDs
  -------------------------
  LED(0)               <= uart_ready;
  LED(1)               <= rx_ip_ready and tx_ip_ready;
  LED(2)               <= rx_lanes_ready and valid_status;
  LED(3)               <= cb_status or be_status;
  --
  -------------------------
  -- reset
  -------------------------
  rst_t                <= sw_rst or reg_rst;
  rx_rst               <= rst_re or s_reset_i;
  rx_nrst              <= not rx_rst;
  rst_check            <= sw_rst_check or reg_rst_check;
  --
  meta_1 : entity work.meta
    port map (
      clk       => rx_clk,
      reg_async => rst_check,
      reg_sync  => rst_check_rs);
  --
  debouncer_1 : entity work.debouncer
    generic map (
      WIDTH => DEB_WIDTH)
    port map (
      clk   => CLK_50MHZ_I,
      deb_i => rst_in,
      deb_o => rst_deb);
  --
  sw_rst       <= rst_deb;
  sw_rst_check <= rst_deb;
  sysrstn      <= not rst_deb;
  --
  risingedge_1 : entity work.risingedge
    port map (
      rst => s_reset_i,
      clk => sysclk,
      d   => rst_t,
      re  => rst_re);

  risingedge_2 : entity work.risingedge
    port map (
      rst => s_reset_i,
      clk => sysclk,
      d   => s_resetn_i,
      re  => s_resetn_re);
  --
  sysreset_1 : entity work.sysreset_1
    generic map (
      RST_CNTR_INIT => RST_CNTR_INIT)
    port map (
      syslock => syslock,
      sysclk  => sysclk,
      reset   => s_reset_i,
      resetn  => s_resetn_i);
  --
  --------------------------------------------------------------------------------------------
  -- SYNC 
  --------------------------------------------------------------------------------------------
  debouncer_2 : entity work.debouncer
    generic map (
      WIDTH => DEB_WIDTH)
    port map (
      clk   => sysclk,
      deb_i => sync_in,
      deb_o => sync_deb);
  --
  sync_meta  <= sync_deb or sync_reg;
  rx_sync_in <= sync_meta;
  --
  meta_re_2 : entity work.meta_re
    port map (
      rst       => rst_t,
      pulse_in  => sync_meta,
      clk_out   => tx_clk,
      pulse_out => tx_sync_in);
  --------------------------------------------------------------------------------------------
  --  clk_out1 : 100.0MHz (must be consistent with C_SYS_CLK_PERIOD)
  --------------------------------------------------------------------------------------------
  i_pll_sys : PF_CCC_C0
    port map (
      -- Inputs
      FB_CLK_0          => fb_clk,  -- 50 MHz
      PLL_POWERDOWN_N_0 => sysrstn,
      REF_CLK_0         => CLK_50MHZ_I,
      -- Outputs
      OUT0_FABCLK_0     => fb_clk,
      OUT1_FABCLK_0     => sysclk,
      OUT2_FABCLK_0     => sysclk2,
      OUT3_FABCLK_0     => sysclk3,
      PLL_LOCK_0        => syslock
      );

  --outbuf_diff_1 : OUTBUF_DIFF
  --  port map (
  --    -- Inputs
  --    D    => sysclk2,
  --    -- Outputs
  --    PADP => sso_ref_p,
  --    PADN => sso_ref_n
  --    );
  outbuf_diff_2 : OUTBUF_DIFF
    port map (
      -- Inputs
      D    => tx_sync_in,
      -- Outputs
      PADP => SYNCTRIG_P_DUT,
      PADN => SYNCTRIG_N_DUT
      );

  -- instance "INBUF_DIFF_1"
  inbuf_diff_1 : INBUF_DIFF
    port map (
      -- Inputs
      PADP => SYNCO_P,
      PADN => SYNCO_N,
      -- Ouputs
      Y    => adc_synco
      );
  --
  --------------------------------------------------------------------------------------------
  -- ESIstream RX IP
  --------------------------------------------------------------------------------------------
  gen_esistream_hdl : if GEN_ESISTREAM = true generate
    tx_rx_esistream_with_xcvr_1 : entity work.tx_rx_esistream_with_xcvr
      generic map (
        NB_LANES => NB_LANES,
        COMMA    => x"FF0000FF")
      port map (
        rst            => rx_rst,
        sysclk         => sysclk,
        refclk_n       => sso_n,
        refclk_p       => sso_p,
        -- TX port
        txp            => txp,
        txn            => txn,
        tx_sync_in     => tx_sync_in,
        tx_prbs_en     => tx_prbs_en,
        tx_disp_en     => tx_disp_en,
        tx_lfsr_init   => tx_lfsr_init,
        data_in        => tx_data_in,
        tx_ip_ready    => tx_ip_ready,
        tx_frame_clk   => tx_clk,
        -- RX port
        rxp            => rxp,
        rxn            => rxn,
        rx_sync_in     => rx_sync_in,
        rx_prbs_en     => rx_prbs_en,
        rx_lanes_on    => rx_lanes_on,
        rx_data_en     => rx_lanes_ready,                        -- rx_release_data,
        clk_acq        => rx_clk,
        rx_frame_clk   => rx_clk,
        rx_sync_out    => open,
        frame_out      => frame_out,
        valid_out      => valid_out,
        rx_ip_ready    => rx_ip_ready,
        rx_lanes_ready => rx_lanes_ready);
  end generate gen_esistream_hdl;
  --------------------------------------------------------------------------------------------
  -- Received data check 
  --------------------------------------------------------------------------------------------
  tx_emu_data_gen_top_1 : entity work.tx_emu_data_gen_top
    generic map (
      NB_LANES => NB_LANES)
    port map (
      nrst    => rx_nrst,
      clk     => tx_clk,
      d_ctrl  => tx_emu_d_ctrl,                                  -- "00" all 0; "11" all 1; else ramp+
      tx_data => tx_data_in);
  --------------------------------------------------------------------------------------------
  -- Received data check 
  --------------------------------------------------------------------------------------------
  -- Used for ILA only to display the ramp waveform using analog view in vivado simulator:
  lanes_assign : for i in 0 to NB_LANES-1 generate
    channel_assign : for j in 0 to DESER_WIDTH/16-1 generate
      process(rx_clk)
      begin
        if rising_edge(rx_clk) then
          -- to Integrated Logic Analyzer (ILA)
          data_out_12b(i)(j) <= frame_out(i)(j)(12-1 downto 0);  -- add pipeline to meet timing constraints
          -- to txrx_frame_checking
          frame_out_d(i)(j)  <= frame_out(i)(j);                 -- add pipeline to meet timing constraints
        end if;
      end process;
    end generate channel_assign;
  end generate lanes_assign;

  txrx_frame_checking_1 : entity work.txrx_frame_checking
    generic map (
      NB_LANES => NB_LANES)
    port map (
      rst          => rst_check_rs,
      clk          => rx_clk,
      d_ctrl       => tx_emu_d_ctrl,
      lanes_on     => rx_lanes_on,
      frame_out    => frame_out,
      valid_out    => valid_out,
      be_status    => be_status,
      cb_status    => cb_status,
      valid_status => valid_status);

  --------------------------------------------------------------------------------------------
  -- SPI Master, dual slave: EV12AQ600 & LMX2592
  --------------------------------------------------------------------------------------------
  -- SPI MUX to switch between EV12AQ60x ADC and PLL LMX2592:
  process(spi_ss, spi_sclk, spi_ncs1, spi_ncs2, spi_mosi, miso, adc_miso)
  begin
    if spi_ss = '0' then                  -- AQ600
      SCLK     <= spi_sclk;
      CSN      <= spi_ncs1;
      MOSI     <= spi_mosi;
      spi_miso <= MISO;
      --
      ADC_SCLK <= '0';
      CSN_PLL  <= '1';
      ADC_MOSI <= '0';
      --spi_miso     <= adc_miso; -- not used
      --
      ADC_CS_U <= '1';
    else                                  -- LMX
      SCLK     <= '0';
      CSN      <= '1';
      MOSI     <= '0';
      -- spi_miso <= miso; -- not used
      --
      ADC_SCLK <= spi_sclk;
      CSN_PLL  <= spi_ncs2;
      ADC_MOSI <= spi_mosi;
      spi_miso <= ADC_MISO;
      --
      ADC_CS_U <= '1';
    end if;
  end process;
  -- This SPI master both control ADC EV12AQ60x and PLL LMX2592.
  spi_dual_master_1 : entity work.spi_dual_master
    generic map (
      CLK_MHz         => CLK_MHz,
      SPI_CLK_MHz     => SPI_CLK_MHz,
      FIFO_DATA_WIDTH => FIFO_DATA_WIDTH,
      FIFO_DEPTH      => 8)
    port map (
      clk            => sysclk,
      rst            => s_reset_i,
      spi_ncs1       => spi_ncs1,         -- EV12AQ600
      spi_ncs2       => spi_ncs2,         -- LMX2592
      spi_sclk       => spi_sclk,
      spi_mosi       => spi_mosi,
      spi_miso       => spi_miso,
      spi_ss         => spi_ss,           -- from register '0': AQ600 ; '1' : LMX2592
      spi_start      => spi_start,        -- from register
      spi_busy       => open,
      fifo_in_wr_en  => fifo_in_wr_en,    -- from register
      fifo_in_din    => fifo_in_din,      -- from register
      fifo_in_full   => fifo_in_full,     -- to register
      fifo_out_rd_en => fifo_out_rd_en,   -- from register
      fifo_out_dout  => fifo_out_dout,    -- to register
      fifo_out_empty => fifo_out_empty);  -- from register
  --------------------------------------------------------------------------------------------
  -- UART 8 bit 115200 and Register map
  --------------------------------------------------------------------------------------------
  uart_wrapper_1 : entity work.uart_wrapper
    port map (
      clk         => sysclk,
      rstn        => s_resetn_i,
      m_axi_addr  => m_axi_addr,
      m_axi_strb  => m_axi_strb,
      m_axi_wdata => m_axi_wdata,
      m_axi_rdata => m_axi_rdata,
      m_axi_wen   => m_axi_wen,
      m_axi_ren   => m_axi_ren,
      m_axi_busy  => m_axi_busy,
      interrupt   => s_interrupt,
      tx          => FTDI_UART1_RXD,
      rx          => FTDI_UART1_TXD);

  register_map_1 : entity work.register_map
    generic map (
      CLK_FREQUENCY_HZ => 100000000,
      TIME_US          => 1000000)
    port map (
      clk          => sysclk,
      rstn         => s_resetn_i,
      interrupt_en => s_resetn_re,
      m_axi_addr   => m_axi_addr,
      m_axi_strb   => m_axi_strb,
      m_axi_wdata  => m_axi_wdata,
      m_axi_rdata  => m_axi_rdata,
      m_axi_wen    => m_axi_wen,
      m_axi_ren    => m_axi_ren,
      m_axi_busy   => m_axi_busy,
      interrupt    => s_interrupt,
      uart_ready   => uart_ready,
      reg_0        => reg_0,
      reg_1        => reg_1,
      reg_2        => reg_2,
      reg_3        => reg_3,
      reg_4        => reg_4,
      reg_5        => reg_5,
      reg_6        => reg_6,
      reg_7        => reg_7,
      reg_8        => reg_8,
      reg_9        => reg_9,
      reg_10       => reg_10,
      reg_11       => reg_11,
      reg_12       => reg_12,
      reg_13       => reg_13,
      reg_14       => reg_14,
      reg_15       => reg_15,
      reg_16       => reg_16,
      reg_17       => reg_17,
      reg_18       => reg_18,
      reg_19       => reg_19,
      reg_4_os     => reg_4_os,
      reg_5_os     => reg_5_os,
      reg_6_os     => reg_6_os,
      reg_7_os     => reg_7_os,
      reg_10_os    => reg_10_os,
      reg_12_os    => reg_12_os);
  --
  tx_emu_d_ctrl(0)    <= reg_0(0) or dsw_tx_emu_d_ctrl(0);
  tx_emu_d_ctrl(1)    <= reg_0(1) or dsw_tx_emu_d_ctrl(1);
  --
  rx_prbs_en          <= reg_1(0) or dsw_prbs_en;
  tx_prbs_en          <= reg_1(1) or dsw_prbs_en;
  tx_disp_en          <= reg_1(2) or dsw_disp_en;
  --
  reg_rst             <= reg_2(0);
  reg_rst_check       <= reg_2(1);
  RSTN                <= reg_2(2);     -- ADC EV12AQ600 RSTN
  --rx_sync_rst         <= reg_2(3);
  --
  spi_ss              <= reg_3(0);
  spi_start           <= reg_3(1);
  --
  fifo_in_din         <= reg_4(23 downto 0);
  --
  --sync_mode            <= reg_5(0);
  --sync_delay           <= reg_5(7 downto 4);
  --sync_en              <= reg_5_os;
  --
  sync_reg            <= reg_6(0);
  --manual_mode          <= reg_6(1) or dsw_manual_mode;
  --
  --sync_wr_counter      <= reg_7(7 downto 0);
  --sync_wr_en           <= reg_7(8);
  -- firmware version --
  reg_8               <= x"0F7C0600";  -- EV12AQ600-FMC-EVM
  --
  reg_9(0)            <= fifo_in_full;
  reg_9(1)            <= fifo_out_empty;
  --
  reg_10(23 downto 0) <= fifo_out_dout;
  --
  --reg_11(7 downto 0)   <= sync_rd_counter;
  --reg_11(8)            <= sync_counter_busy;
  --reg_11(24 downto 16) <= sync_odelay_o;
  --
  --sync_get_odelay      <= reg_12(15);
  --sync_odelay_i        <= reg_12(8 downto 0);
  --
  fifo_in_wr_en       <= reg_4_os;
  fifo_out_rd_en      <= reg_10_os;
  --sync_set_odelay      <= reg_12_os;
  ------------------------------------------------------------------------------------
  -- ref clk source switch:
  ------------------------------------------------------------------------------------
  -- | ref_sel_ext | ref clk source |
  -- | 1           | external       |
  -- | 0           | internal       | DEFAULT
  REF_SEL_EXT         <= reg_14(6);
  ------------------------------------------------------------------------------------
  -- external ref clk switch:
  ------------------------------------------------------------------------------------
  -- |ref_sel     | ref clk source               |
  -- | 1          | fpga_ref_clk                 |
  -- | 0          | external ref clk SMA EXT REF | DEFAULT
  REF_SEL             <= reg_14(5);
  ------------------------------------------------------------------------------------
  -- EV12AQ60x CLK source switch:
  ------------------------------------------------------------------------------------
  -- |clk_sel      | ref clk source   |
  -- | 1           | PLL LMX2592      | 
  -- | 0           | external SMA     | DEFAULT 
  CLK_SEL             <= reg_14(4);
  ------------------------------------------------------------------------------------
  -- SYNCO multiplexer CBTL01023 SEL-input:
  ------------------------------------------------------------------------------------
  -- |synco_sel | synco fpga source   |
  -- | 1        | SYNCO external SMA  |
  -- | 0        | SYNCO ADC           | DEFAULT
  SYNCO_SEL           <= reg_14(3);
  ------------------------------------------------------------------------------------
  -- SYNC multiplexer CBTL01023 SEL-input:
  ------------------------------------------------------------------------------------
  -- |sync_sel    | sync adc source   |
  -- | 1          | SYNC external SMA |
  -- | 0          | SYNC FPGA         | DEFAULT
  SYNC_SEL            <= reg_14(2);
  ------------------------------------------------------------------------------------
  -- Low jitter clock generation with integer N PLL:
  ------------------------------------------------------------------------------------
  -- | D0   | D1  | state  | ref clock frequency | PLL Division ratio |
  -- |  0   |  0  |  OFF   | N.A.                | Power-down         | DEFAULT
  -- |  1   |  0  |  ON    | 100 MHz             | Divide by 1        |
  -- |  0   |  1  |  ON    | 20 MHz              | Divide by 5        |
  -- |  1   |  1  |  ON    | 10 MHz              | Divide by 10       |
  HMC1031_D1          <= reg_14(1);
  HMC1031_D0          <= reg_14(0);
  ------------------------------------------------------------------------------------
  -- Connect spare signals
  ------------------------------------------------------------------------------------
  reg_18(0)           <= SPARE_1;
  reg_18(1)           <= SPARE_2;
  reg_18(2)           <= SPARE_3;
  reg_18(3)           <= SPARE_4;
  reg_18(4)           <= SPARE_5;
  reg_18(5)           <= SPARE_6;
  reg_18(6)           <= SPARE_7;
  reg_18(7)           <= SPARE_8;
  reg_18(8)           <= SPARE_9;
  reg_18(9)           <= '0';
  reg_18(10)          <= '0';
  reg_18(11)          <= '0';
  reg_18(12)          <= '0';
  reg_18(13)          <= '0';
  reg_18(14)          <= '0';
  reg_18(15)          <= '0';
  reg_18(16)          <= M2C_CFG1;
  reg_18(17)          <= M2C_CFG2;
  reg_18(18)          <= M2C_CFG3;
  reg_18(19)          <= M2C_CFG4;
  reg_18(20)          <= '0';
  reg_18(21)          <= '0';
  reg_18(22)          <= '0';
  reg_18(23)          <= '0';
  reg_18(24)          <= adc_synco; -- can't be detected as too fast. 
--
end architecture rtl;
