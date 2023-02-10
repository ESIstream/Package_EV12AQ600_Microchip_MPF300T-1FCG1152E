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

library work;
use work.esistream_pkg.all;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library STD;
use STD.textio.all;

library polarfire;
use polarfire.all;

entity tb_tx_rx_esistream_top is
end entity tb_tx_rx_esistream_top;

architecture behavioral of tb_tx_rx_esistream_top is
---------------- Constants ----------------
  constant sso_half_period     : time                                  := 3.2 ns;
  constant GEN_ESISTREAM       : boolean                               := false;
  constant GEN_GPIO            : boolean                               := true;
  constant NB_LANES            : natural                               := 8;
  constant COMMA               : std_logic_vector(31 downto 0)         := x"FF0000FF";
  signal sso_p                 : std_logic                             := '0';
  signal sso_n                 : std_logic                             := '1';
  signal CLK_50MHZ_I           : std_logic                             := '0';
  -- signal CLK_50MHZ_N          : std_logic                             := '1';
  signal clk_100               : std_logic                             := '0';
  signal fmc_xcvr_out_p        : std_logic_vector(NB_LANES-1 downto 0) := (others => '0');
  signal fmc_xcvr_out_n        : std_logic_vector(NB_LANES-1 downto 0) := (others => '1');
  signal SW1                   : std_logic                             := '0';
  signal SW2                   : std_logic                             := '0';
  signal DIP1                  : std_logic                             := '0';
  signal DIP2                  : std_logic                             := '0';
  signal DIP3                  : std_logic                             := '0';
  signal DIP4                  : std_logic                             := '0';
  signal LED                   : std_logic_vector(3 downto 0)          := (others => '0');
  --
  signal led_uart_ready        : std_logic                             := '0';
  signal led_sync_in           : std_logic                             := '0';
  signal led_ip_ready          : std_logic                             := '0';
  signal led_lanes_ready       : std_logic                             := '0';
  signal led_isrunning         : std_logic                             := '0';
  signal led_be_status         : std_logic                             := '0';
  signal led_cb_status         : std_logic                             := '0';
  signal led_valid_status      : std_logic                             := '0';
  --
  signal tx_ip_ready           : std_logic                             := '0';
  signal rx_ip_ready           : std_logic                             := '0';
  signal ip_ready              : std_logic                             := '0';
  signal tx_d_ctrl             : std_logic_vector(1 downto 0)          := (others => '0');
  signal rx_prbs_en            : std_logic                             := '0';
  signal tx_prbs_en            : std_logic                             := '0';
  signal tx_disp_en            : std_logic                             := '0';
  signal tx_lss                : std_logic                             := '0';
  signal sync                  : std_logic                             := '0';
  signal tb_rst                   : std_logic                             := '0';
  signal tb_rstn                  : std_logic                             := '0';
  --
  signal lfsr_init             : slv_17_array_n(NB_LANES-1 downto 0)   := (others => (others => '1'));
  signal clk_bit               : std_logic                             := '0';
  signal tx_clk                : std_logic                             := '0';
  signal txp                   : std_logic_vector(NB_LANES-1 downto 0) := (others => '0');
  signal txn                   : std_logic_vector(NB_LANES-1 downto 0) := (others => '1');
  constant NB_CLK_CYC          : std_logic_vector(31 downto 0)         := (others => '0');
  constant RST_CNTR_INIT       : std_logic_vector(11 downto 0)         := x"00F";
  signal uart_tx               : std_logic                             := '0';
  signal uart_rx               : std_logic                             := '0';
  --
  -- -- UART IP constants:
  constant ADDR_RX_FIFO        : std_logic_vector(3 downto 0)          := x"0";
  constant ADDR_TX_FIFO        : std_logic_vector(3 downto 0)          := x"4";
  constant ADDR_STAT           : std_logic_vector(3 downto 0)          := x"8";
  constant ADDR_CTRL           : std_logic_vector(3 downto 0)          := x"C";
  --
  signal m1_axi_addr           : std_logic_vector(3 downto 0)          := (others => '0');
  signal m1_axi_strb           : std_logic_vector(3 downto 0)          := (others => '0');
  signal m1_axi_wdata          : std_logic_vector(31 downto 0)         := (others => '0');
  signal m1_axi_rdata          : std_logic_vector(31 downto 0)         := (others => '0');
  signal m1_axi_wen            : std_logic                             := '0';
  signal m1_axi_ren            : std_logic                             := '0';
  signal m1_axi_busy           : std_logic                             := '0';
  signal s1_interrupt          : std_logic                             := '0';
--
  signal reg_0_0, reg_0_1      : std_logic                             := '0';
  --
  signal reg3                  : std_logic_vector(7 downto 0)          := (others => '0');
  constant SPI_START_ENABLE    : std_logic_vector(7 downto 0)          := x"02";
  constant SPI_START_DISABLE   : std_logic_vector(7 downto 0)          := x"FD";
  constant SPI_SS_EXTERNAL_PLL : std_logic_vector(7 downto 0)          := x"01";
  constant SPI_SS_EV12AQ600    : std_logic_vector(7 downto 0)          := x"00";
  --
  signal manual_mode           : std_logic                             := '0';
  --
  signal spare_0               : std_logic                             := '0';
  --
  signal FPGA_REF_CLK          : std_logic                             := '0';
  signal ADC_SCLK              : std_logic                             := '0';
  signal ADC_CS_U              : std_logic                             := '0';
  signal CSN_PLL               : std_logic                             := '0';
  signal ADC_MISO              : std_logic                             := '0';
  signal ADC_MOSI              : std_logic                             := '0';
  signal PLL_MUXOUT            : std_logic                             := '0';
  signal RSTN                  : std_logic                             := '0';
  signal SCLK                  : std_logic                             := '0';
  signal CSN                   : std_logic                             := '0';
  signal MISO                  : std_logic                             := '0';
  signal MOSI                  : std_logic                             := '0';
  signal REF_SEL_EXT           : std_logic                             := '0';
  signal REF_SEL               : std_logic                             := '0';
  signal HMC1031_D1            : std_logic                             := '0';
  signal HMC1031_D0            : std_logic                             := '0';
  signal CLK_SEL               : std_logic                             := '0';
  signal SYNC_SEL              : std_logic                             := '0';
  signal SYNCTRIG_P_DUT        : std_logic                             := '0';
  signal SYNCTRIG_N_DUT        : std_logic                             := '0';
  signal SYNCO_SEL             : std_logic                             := '0';
  signal SYNCO_P               : std_logic                             := '0';
  signal SYNCO_N               : std_logic                             := '0';
  signal SPARE_9               : std_logic                             := '0';
  signal SPARE_8               : std_logic                             := '0';
  signal SPARE_7               : std_logic                             := '0';
  signal SPARE_6               : std_logic                             := '0';
  signal SPARE_5               : std_logic                             := '0';
  signal SPARE_4               : std_logic                             := '0';
  signal SPARE_3               : std_logic                             := '0';
  signal SPARE_2               : std_logic                             := '0';
  signal SPARE_1               : std_logic                             := '0';
  signal C2M_LED1              : std_logic                             := '0';
  signal C2M_LED2              : std_logic                             := '0';
  signal C2M_LED3              : std_logic                             := '0';
  signal C2M_LED4              : std_logic                             := '0';
  signal M2C_CFG1              : std_logic                             := '0';
  signal M2C_CFG2              : std_logic                             := '0';
  signal M2C_CFG3              : std_logic                             := '0';
  signal M2C_CFG4              : std_logic                             := '0';
  --
begin
--
--############################################################################################################################
--############################################################################################################################
-- Clock Generation
--############################################################################################################################
--############################################################################################################################
  sso_p       <= not sso_p       after sso_half_period;  -- Tsso = 2.56 ns <=> Maximum HSSL lane rate with ESIstream = 6.25 Gbps => 6.25 GHz/16 = 390.625 MHz 
  sso_n       <= not sso_n       after sso_half_period;  -- T_390.625_MHz = 2.56 ns
  --
  CLK_50MHZ_I <= not CLK_50MHZ_I after 10 ns;            -- PL system clock for registers map, UART communication with computer...
  --CLK_50MHZ_P <= not CLK_50MHZ_P after 4 ns;                                                                    -- PL system clock for registers map, UART communication with computer...
  --CLK_50MHZ_N <= not CLK_50MHZ_N after 4 ns;
  --
  clk_100     <= not clk_100     after 5 ns;             -- clock for UART testbench module used to simulate the computer.
  --
--############################################################################################################################
--############################################################################################################################
-- Unit under test
--############################################################################################################################
--############################################################################################################################   
  tx_rx_esistream_top_1 : entity work.tx_rx_esistream_top
    generic map (
      GEN_ESISTREAM => GEN_ESISTREAM,
      GEN_GPIO      => GEN_GPIO,
      NB_LANES      => NB_LANES,
      RST_CNTR_INIT => RST_CNTR_INIT,
      NB_CLK_CYC    => NB_CLK_CYC,
      CLK_MHz       => 100.0,
      SPI_CLK_MHz   => 10.0,
      DEB_WIDTH     => 2)
    port map (
      sso_n          => sso_n,
      sso_p          => sso_p,
      --sso_ref_n      => open,
      --sso_ref_p      => open,
      CLK_50MHZ_I    => CLK_50MHZ_I,
      rxp            => txp,
      rxn            => txn,
      txp            => txp,
      txn            => txn,
      SW1            => SW1,
      SW2            => SW2,
      DIP1           => DIP1,
      DIP2           => DIP2,
      DIP3           => DIP3,
      DIP4           => DIP4,
      LED            => LED,
      FTDI_UART1_TXD => uart_tx,
      FTDI_UART1_RXD => uart_rx,
      -- EV12AQ600-FMC-EVM: 
      FPGA_REF_CLK   => FPGA_REF_CLK,                    -- LA00_P_CC 
      ADC_SCLK       => ADC_SCLK,                        -- LA01_P_CC / PLL and TEMPERATURE Monitoring ADC SPI SCLK
      ADC_CS_U       => ADC_CS_U,                        -- LA09_N / TEMPERATURE Monitoring ADC SPI chip select
      CSN_PLL        => CSN_PLL,                         -- LA11_P / PLL SPI chip select
      ADC_MISO       => ADC_MISO,                        -- LA13_P / TEMPERATURE Monitoring ADC MISO
      ADC_MOSI       => ADC_MOSI,                        -- LA13_N / PLL and TEMPERATURE Monitoring ADC MOSI
      PLL_MUXOUT     => PLL_MUXOUT,                      -- LA16_P / PLL MUXOUT, can be configured as PLL LOCK or PLL SPI MISO.
      RSTN           => RSTN,                            -- LA10_N / EV12AQ600 ADC RSTN
      SCLK           => SCLK,                            -- LA14_P / EV12AQ600 ADC SPI SCLK
      CSN            => CSN,                             -- LA20_P / EV12AQ600 ADC SPI chip select
      MISO           => MISO,                            -- LA06_N / EV12AQ600 ADC SPI MISO
      MOSI           => MOSI,                            -- LA20_N / EV12AQ600 ADC SPI MOSI
      REF_SEL_EXT    => REF_SEL_EXT,                     -- LA03_P
      REF_SEL        => REF_SEL,                         -- LA03_N
      HMC1031_D1     => HMC1031_D1,                      -- LA05_P   
      HMC1031_D0     => HMC1031_D0,                      -- LA05_N
      CLK_SEL        => CLK_SEL,                         -- LA08_P
      SYNC_SEL       => SYNC_SEL,                        -- LA12_P
      SYNCTRIG_P_DUT => SYNCTRIG_P_DUT,                  -- LA04_P
      SYNCTRIG_N_DUT => SYNCTRIG_N_DUT,                  -- LA04_N
      SYNCO_SEL      => SYNCO_SEL,                       -- LA08_N
      SYNCO_P        => SYNCO_P,                         -- LA28_P
      SYNCO_N        => SYNCO_N,                         -- LA28_N
      SPARE_9        => SPARE_9,                         -- LA14_N / UART_RX 
      SPARE_8        => SPARE_8,                         -- LA10_P / UART_TX
      SPARE_7        => SPARE_7,                         -- LA06_P
      SPARE_6        => SPARE_6,                         -- LA09_P
      SPARE_5        => SPARE_5,                         -- LA16_N
      SPARE_4        => SPARE_4,                         -- LA07_P
      SPARE_3        => SPARE_3,                         -- LA07_N
      SPARE_2        => SPARE_2,                         -- LA12_N
      SPARE_1        => SPARE_1,                         -- LA11_N
      C2M_LED1       => C2M_LED1,                        -- LA15_P
      C2M_LED2       => C2M_LED2,                        -- LA15_N
      C2M_LED3       => C2M_LED3,                        -- LA19_P
      C2M_LED4       => C2M_LED4,                        -- LA19_N
      M2C_CFG1       => M2C_CFG1,                        -- LA15_P
      M2C_CFG2       => M2C_CFG2,                        -- LA15_N
      M2C_CFG3       => M2C_CFG3,                        -- LA19_P
      M2C_CFG4       => M2C_CFG4                         -- LA19_N
      );
  -- --
  DIP1 <= tx_d_ctrl(0);
  DIP2 <= tx_d_ctrl(1);
  DIP3 <= rx_prbs_en;
  DIP4 <= '1';
  SW1  <= not tb_rst;
  SW2  <= not sync;

  -- --             
  led_uart_ready   <= LED(0);
  led_ip_ready     <= LED(1);
  led_lanes_ready  <= LED(2);
  led_valid_status <= LED(2);
  led_cb_status    <= LED(3);
  led_be_status    <= LED(3);
  --                
  rx_ip_ready      <= led_ip_ready;
--============================================================================================================================
-- Stimulus
--============================================================================================================================
  my_tb : process
    -- 
    procedure axi4_lite_write
      (
        signal clk         : in  std_logic;
        constant addr      : in  std_logic_vector;
        constant data      : in  std_logic_vector;
        signal m_axi_addr  : out std_logic_vector;
        signal m_axi_strb  : out std_logic_vector;
        signal m_axi_wdata : out std_logic_vector;
        signal m_axi_wen   : out std_logic;
        signal m_axi_busy  : in  std_logic) is
    begin
      wait until rising_edge(clk);
      m_axi_addr  <= addr;
      m_axi_strb  <= "0001";
      m_axi_wdata <= x"000000"&data;
      m_axi_wen   <= '1';
      wait until rising_edge(clk);
      m_axi_wen   <= '0';
      wait until falling_edge(m_axi_busy);
    end axi4_lite_write;
    --
    procedure axi4_lite_read
      (
        signal clk         : in  std_logic;
        constant addr      : in  std_logic_vector;
        signal rdata       : out std_logic_vector;
        signal m_axi_addr  : out std_logic_vector;
        signal m_axi_rdata : in  std_logic_vector;
        signal m_axi_ren   : out std_logic;
        signal m_axi_busy  : in  std_logic) is
    begin
      wait until rising_edge(clk);
      m_axi_addr <= addr;
      m_axi_ren  <= '1';
      wait until rising_edge(clk);
      m_axi_ren  <= '0';
      wait until falling_edge(m_axi_busy);
      rdata      <= m_axi_rdata;
    end axi4_lite_read;
    --
    procedure write_log
      (
        signal clk       : in std_logic;
        signal cb_status : in std_logic;
        signal be_status : in std_logic) is
      file logfile     : text;
      variable fstatus : file_open_status;
      variable result  : std_logic_vector(1 downto 0);
      variable buf     : line;
    begin
      --
      result := cb_status & be_status;
      --
      --file_open(fstatus, logfile, "log.txt", write_mode);
      file_open(fstatus, logfile, "bit_error_status.txt", append_mode);
      L1 : write(buf, string'("tb result: [cb_status & be_status] = ["));
      L2 : write(buf, to_bitvector(result));
      L3 : write(buf, string'("] "));
      L4 : writeline(logfile, buf);
      file_close(logfile);
    end write_log;
    --
    procedure send_sync(
      signal clk          : in  std_logic;
      signal lanes_ready  : in  std_logic;
      signal valid_status : in  std_logic;
      signal sync         : out std_logic;
      signal manual_mode  : out std_logic) is
    begin
      wait until rising_edge(clk);
      sync <= '1';
      wait for 100 ns;
      wait until rising_edge(clk);
      sync <= '0';
      report "sync sent...";
      report "wait lanes_ready";
      wait until rising_edge(lanes_ready);
      report "lanes ready...";
    --report "wait valid_status";
    --wait until rising_edge(valid_status);
    --report "valid status...";
    end send_sync;
  --
  begin
    -------------------------------- 
    -- tb init
    --------------------------------
    tb_rst        <= '0';
    rx_prbs_en <= '1';
    tx_prbs_en <= '1';
    tx_disp_en <= '1';
    tx_d_ctrl  <= "01";                                                                                             -- [00: all x"000"; 11: all x"FFF" else ramp mode]
    reg3       <= SPI_SS_EV12AQ600;
    sync       <= '0';
    wait for 250 ns;
    tb_rst        <= '1';
    wait for 250 ns;
    tb_rst        <= '0';
    wait for 250 ns;
    report "release reset...";
    report "start testbench...";
    ----------------------------------------------------------------------------------------------------
    -- TEST 1: 
    ---------------------------------------------------------------------------------------------------- 
    if GEN_ESISTREAM then
      report "test 1...";
      wait for 1000 ns;
      -- wait until rising_edge(clk_100);
      --  tb_rst <= '1';
      -- wait until rising_edge(clk_100);
      --  tb_rst <= '0';
      --
      wait until rising_edge(led_ip_ready);
      -- send 1st sync:
      send_sync(clk_100, led_lanes_ready, led_valid_status, sync, manual_mode);
      wait for 100 ns;
      write_log(clk_100, led_cb_status, led_be_status);
      --
      wait for 2000 ns;
      -- send 2nd sync:
      send_sync(clk_100, led_lanes_ready, led_valid_status, sync, manual_mode);
      wait for 100 ns;
      write_log(clk_100, led_cb_status, led_be_status);
    ----------------------------------------------------------------------------------------------------
    -- TEST 2: Uncomment lines below and comment TEST 1 lines above
    --         Set boolean constant GEN_ESISTREAM to false to speed up simulation for
    -- uart & spi communication tests below.
    -- uart 115200, 8-bit
    ----------------------------------------------------------------------------------------------------
    else
      report "test 2...";
      report "wait uart_ready";
      wait until rising_edge(led_uart_ready);
      -------------------------------- 
      -- s1 enable interrupt of tb uart_wrapper_1 module
      -------------------------------- 
      axi4_lite_write(clk_100, ADDR_CTRL, x"10", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);  -- s1 enable interrupt
      wait for 200 us;

      -------------------------------- 
      -- UART WRITE command 
      --------------------------------
      -- spi slave select command, external pll
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"00", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"03", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"00", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"00", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"00", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, reg3, m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      wait for 1 ms;
      wait until rising_edge(clk_100);
      -- spi write fifo in 
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"00", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"04", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"00", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"55", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"AA", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"55", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      wait for 1 ms;
      wait until rising_edge(clk_100);
      -- spi write fifo in 
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"00", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"04", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"00", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"87", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"65", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"43", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      --
      reg3 <= reg3 or SPI_START_ENABLE;
      wait for 1 ms;
      wait until rising_edge(clk_100);
      -- spi start command
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"00", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"03", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"00", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"00", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, x"00", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      axi4_lite_write(clk_100, ADDR_TX_FIFO, reg3, m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);
      wait for 1 ms;
      wait until rising_edge(clk_100);
    -- wait until rising_edge(s1_interrupt);                                                                     -- Wait TX FIFO empty
    -- wait until rising_edge(s1_interrupt);                                                                     -- Wait ACK
    -- axi4_lite_read(clk, ADDR_RX_FIFO, s1_rdata, m1_axi_addr, m1_axi_rdata, m1_axi_ren, m1_axi_busy);
    -- -- axi4_lite_write(clk_100, ADDR_CTRL, x"10", m1_axi_addr, m1_axi_strb, m1_axi_wdata, m1_axi_wen, m1_axi_busy);  -- s1 enable interrupt
    -- -- wait until rising_edge(s1_interrupt);                                                                     -- Wait TX FIFO empty
    -- -- wait until rising_edge(s1_interrupt);                                                                     -- Wait ACK
    -- -- axi4_lite_read(clk_100, ADDR_RX_FIFO, s1_rdata, m1_axi_addr, m1_axi_rdata, m1_axi_ren, m1_axi_busy);
    end if;
    assert false report "Test finish" severity failure;
    wait;
  end process;

  -- Simulate PC:
  tb_rstn <= not tb_rst;
  uart_wrapper_1 : entity work.uart_wrapper
    port map (
      clk         => clk_100,
      rstn        => tb_rstn,
      m_axi_addr  => m1_axi_addr,
      m_axi_strb  => m1_axi_strb,
      m_axi_wdata => m1_axi_wdata,
      m_axi_rdata => m1_axi_rdata,
      m_axi_wen   => m1_axi_wen,
      m_axi_ren   => m1_axi_ren,
      m_axi_busy  => m1_axi_busy,
      interrupt   => s1_interrupt,
      tx          => uart_tx,
      rx          => uart_rx);
--
end behavioral;
