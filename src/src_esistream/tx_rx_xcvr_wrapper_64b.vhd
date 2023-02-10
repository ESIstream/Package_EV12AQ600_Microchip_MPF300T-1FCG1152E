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
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABIqLITY, 
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN 
-- ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
-- THIS DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES. 
-------------------------------------------------------------------------------
-- Version      Date            Author       Description
-- 1.1          2019            REFLEXCES    FPGA target migration, 64-bit data path
-- 2.1          2022            R.BAHRI      updated for polarfire fpga
--------------------------------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.esistream_pkg.all;
use work.component_pkg.all;

library polarfire;
use polarfire.all;


entity tx_rx_xcvr_wrapper is
  generic (
    NB_LANES : natural := 4
    );
  port (
    rst              : in  std_logic;
    rx_rst_xcvr      : in  std_logic;
    rx_rstdone       : out std_logic_vector(NB_LANES-1 downto 0)             := (others => '0');
    rx_frame_clk     : out std_logic                                         := '0';
    rx_usrclk        : out std_logic_vector(NB_LANES-1 downto 0)             := (others => '0');
    tx_rst_xcvr      : in  std_logic;
    tx_usrrdy        : in  std_logic_vector(NB_LANES-1 downto 0);  -- TX User Ready
    tx_rstdone       : out std_logic_vector(NB_LANES-1 downto 0)             := (others => '0');
    tx_frame_clk     : out std_logic                                         := '0';
    tx_usrclk        : out std_logic;
    sysclk           : in  std_logic;
    refclk_n         : in  std_logic;
    refclk_p         : in  std_logic;
    rxp              : in  std_logic_vector(NB_LANES-1 downto 0);
    rxn              : in  std_logic_vector(NB_LANES-1 downto 0);
    txp              : out std_logic_vector(NB_LANES-1 downto 0);
    txn              : out std_logic_vector(NB_LANES-1 downto 0);
    tx_xcvr_pll_lock : out std_logic_vector(NB_LANES-1 downto 0)             := (others => '0');
    rx_xcvr_pll_lock : out std_logic_vector(NB_LANES-1 downto 0)             := (others => '0');
    data_in          : in  std_logic_vector(SER_WIDTH*NB_LANES-1 downto 0)   := (others => '0');
    data_out         : out std_logic_vector(DESER_WIDTH*NB_LANES-1 downto 0) := (others => '0')
    );
end entity tx_rx_xcvr_wrapper;

architecture rtl of tx_rx_xcvr_wrapper is
  --============================================================================================================================
  -- Function and Procedure declarations
  --============================================================================================================================

  --============================================================================================================================
  -- Constant and Type declarations
  --============================================================================================================================

  --============================================================================================================================
  -- Component declarations
  --============================================================================================================================

  --============================================================================================================================
  -- Signal declarations
  --============================================================================================================================
  signal rstn             : std_logic                               := '0';
  signal refclk           : std_logic                               := '0';
  signal refclk_o         : std_logic                               := '0';
  signal tx_clk_to_xcvr   : std_logic                               := '0';
  signal tx_clk_to_xcvr_1 : std_logic                               := '0';
  signal frame_clk        : std_logic                               := '0';
  signal rx_usrclk_1      : std_logic_vector(NB_LANES-1 downto 0)   := (others => '0');
  signal tx_usrclk_1      : std_logic                               := '0';
  signal rx_val           : std_logic_vector(NB_LANES-1 downto 0)   := (others => '0');
  signal tx_clk_stable    : std_logic_vector(NB_LANES-1 downto 0)   := (others => '0');
  signal rx_ready         : std_logic_vector(NB_LANES-1 downto 0)   := (others => '0');
  signal tx_bit_clk       : std_logic                               := '0';
  signal tx_bit_clk_1     : std_logic                               := '0';
  signal tx_pll_lock      : std_logic                               := '0';
  signal tx_pll_lock_1    : std_logic                               := '0';
  signal pll_lock         : std_logic_vector(NB_LANES/4-1 downto 0) := (others => '0');
--
begin
  rstn <= not rst;
  --============================================================================================================================
  -- Clock buffer for REFCLK
  --============================================================================================================================
  -- transceiver ref clock
  i_ref_clk : PF_XCVR_REF_CLK_C0
    port map (
      -- Inputs
      REF_CLK_PAD_N => refclk_n,
      REF_CLK_PAD_P => refclk_p,
      -- Outputs
      REF_CLK       => refclk_o
      );
  -----------------------------
  -- pll 
  --- i_frame_clk : PF_CCC_C1
  ---   port map (
  ---     -- Inputs
  ---     PLL_POWERDOWN_N_0 => rstn,
  ---     REF_CLK_0         => refclk_o,
  ---     -- Outputs
  ---     OUT0_FABCLK_0     => frame_clk,
  ---     PLL_LOCK_0        => open
  ---     );
  ------------------------------------
  --- transmit pll
  i_transmit_pll : PF_TX_PLL_C0
    port map(
      -- Inputs
      REF_CLK         => refclk_o,
      -- Outputs
      BIT_CLK         => tx_bit_clk,
      LOCK            => tx_pll_lock,
      PLL_LOCK        => pll_lock(0),
      REF_CLK_TO_LANE => tx_clk_to_xcvr
      );
  i_transmit_pll_2 : PF_TX_PLL_C1
    port map(
      -- Inputs
      REF_CLK         => refclk_o,
      -- Outputs
      BIT_CLK         => tx_bit_clk_1,
      LOCK            => tx_pll_lock_1,
      PLL_LOCK        => pll_lock(1),
      REF_CLK_TO_LANE => tx_clk_to_xcvr_1
      );
-------------------------------------------
  --transceiver quad 1
  i_txrx_4lanes_64b_1 : PF_XCVR_ERM_C2
    port map(
      -- Inputs
      CTRL_ARST_N => rstn,
      CTRL_CLK    => sysclk,

      LANE0_CDR_REF_CLK_0 => refclk_o,
      LANE0_LOS           => '0',
      LANE0_PCS_ARST_N    => rstn,
      LANE0_PMA_ARST_N    => rstn,
      LANE0_RXD_N         => rxn(0),
      LANE0_RXD_P         => rxp(0),
      LANE0_TX_DATA       => data_in(SER_WIDTH-1 downto 0),  -- 63 downto 0
      LANE0_TX_WCLK       => tx_usrclk_1,

      LANE1_CDR_REF_CLK_0 => refclk_o,
      LANE1_LOS           => '0',
      LANE1_PCS_ARST_N    => rstn,
      LANE1_PMA_ARST_N    => rstn,
      LANE1_RXD_N         => rxn(1),
      LANE1_RXD_P         => rxp(1),
      LANE1_TX_DATA       => data_in(2*SER_WIDTH-1 downto SER_WIDTH),  -- 127 downto 64
      LANE1_TX_WCLK       => tx_usrclk_1,

      LANE2_CDR_REF_CLK_0 => refclk_o,
      LANE2_LOS           => '0',
      LANE2_PCS_ARST_N    => rstn,
      LANE2_PMA_ARST_N    => rstn,
      LANE2_RXD_N         => rxn(2),
      LANE2_RXD_P         => rxp(2),
      LANE2_TX_DATA       => data_in(3*SER_WIDTH-1 downto 2*SER_WIDTH),  -- 191 downto 128
      LANE2_TX_WCLK       => tx_usrclk_1,

      LANE3_CDR_REF_CLK_0 => refclk_o,
      LANE3_LOS           => '0',
      LANE3_PCS_ARST_N    => rstn,
      LANE3_PMA_ARST_N    => rstn,
      LANE3_RXD_N         => rxn(3),
      LANE3_RXD_P         => rxp(3),
      LANE3_TX_DATA       => data_in(4*SER_WIDTH-1 downto 3*SER_WIDTH),  -- 255 downto 192
      LANE3_TX_WCLK       => tx_usrclk_1,

      TX_BIT_CLK_0         => tx_bit_clk,
      TX_PLL_LOCK_0        => tx_pll_lock,
      TX_PLL_REF_CLK_0     => tx_clk_to_xcvr,
      -- Outputs
      LANE0_RX_BYPASS_DATA => open,
      LANE0_RX_CLK_R       => rx_usrclk_1(0),
      LANE0_RX_DATA        => data_out(SER_WIDTH-1 downto 0),  -- 63 downto 0
      LANE0_RX_IDLE        => open,
      LANE0_RX_READY       => rx_ready(0),
      LANE0_RX_VAL         => rx_val(0),
      LANE0_TXD_N          => txn(0),
      LANE0_TXD_P          => txp(0),
      LANE0_TX_CLK_G       => open,
      LANE0_TX_CLK_R       => open,
      LANE0_TX_CLK_STABLE  => tx_clk_stable(0),

      LANE1_RX_BYPASS_DATA => open,
      LANE1_RX_CLK_R       => rx_usrclk_1(1),
      LANE1_RX_DATA        => data_out(2*SER_WIDTH-1 downto 1*SER_WIDTH),  -- 127 downto 64
      LANE1_RX_IDLE        => open,
      LANE1_RX_READY       => rx_ready(1),
      LANE1_RX_VAL         => rx_val(1),
      LANE1_TXD_N          => txn(1),
      LANE1_TXD_P          => txp(1),
      LANE1_TX_CLK_G       => open,
      LANE1_TX_CLK_R       => open,
      LANE1_TX_CLK_STABLE  => tx_clk_stable(1),

      LANE2_RX_BYPASS_DATA => open,
      LANE2_RX_CLK_R       => rx_usrclk_1(2),
      LANE2_RX_DATA        => data_out(3*SER_WIDTH-1 downto 2*SER_WIDTH),  -- 191 downto 128
      LANE2_RX_IDLE        => open,
      LANE2_RX_READY       => rx_ready(2),
      LANE2_RX_VAL         => rx_val(2),
      LANE2_TXD_N          => txn(2),
      LANE2_TXD_P          => txp(2),
      LANE2_TX_CLK_G       => open,
      LANE2_TX_CLK_R       => open,
      LANE2_TX_CLK_STABLE  => tx_clk_stable(2),

      LANE3_RX_BYPASS_DATA => open,
      LANE3_RX_CLK_R       => rx_usrclk_1(3),
      LANE3_RX_DATA        => data_out(4*SER_WIDTH-1 downto 3*SER_WIDTH),  -- 255 downto 192
      LANE3_RX_IDLE        => open,
      LANE3_RX_READY       => rx_ready(3),
      LANE3_RX_VAL         => rx_val(3),
      LANE3_TXD_N          => txn(3),
      LANE3_TXD_P          => txp(3),
      LANE3_TX_CLK_G       => open,
      LANE3_TX_CLK_R       => open,
      LANE3_TX_CLK_STABLE  => tx_clk_stable(3)
      );
-------------------------------------------
  -- transceiver quad 2
  i_txrx_4lanes_64b_2 : PF_XCVR_ERM_C3
    port map(
      -- Inputs
      CTRL_ARST_N         => rstn,
      CTRL_CLK            => sysclk,
      LANE0_CDR_REF_CLK_0 => refclk_o,
      LANE0_LOS           => '0',
      LANE0_PCS_ARST_N    => rstn,
      LANE0_PMA_ARST_N    => rstn,
      LANE0_RXD_N         => rxn(4),
      LANE0_RXD_P         => rxp(4),
      LANE0_TX_DATA       => data_in(5*SER_WIDTH-1 downto 4*SER_WIDTH),    -- 319 downto 256
      LANE0_TX_WCLK       => tx_usrclk_1,

      LANE1_CDR_REF_CLK_0 => refclk_o,
      LANE1_LOS           => '0',
      LANE1_PCS_ARST_N    => rstn,
      LANE1_PMA_ARST_N    => rstn,
      LANE1_RXD_N         => rxn(5),
      LANE1_RXD_P         => rxp(5),
      LANE1_TX_DATA       => data_in(6*SER_WIDTH-1 downto 5*SER_WIDTH),  -- 383 downto 320
      LANE1_TX_WCLK       => tx_usrclk_1,

      LANE2_CDR_REF_CLK_0 => refclk_o,
      LANE2_LOS           => '0',
      LANE2_PCS_ARST_N    => rstn,
      LANE2_PMA_ARST_N    => rstn,
      LANE2_RXD_N         => rxn(6),
      LANE2_RXD_P         => rxp(6),
      LANE2_TX_DATA       => data_in(7*SER_WIDTH-1 downto 6*SER_WIDTH),  -- 447 downto 384
      LANE2_TX_WCLK       => tx_usrclk_1,

      LANE3_CDR_REF_CLK_0 => refclk_o,
      LANE3_LOS           => '0',
      LANE3_PCS_ARST_N    => rstn,
      LANE3_PMA_ARST_N    => rstn,
      LANE3_RXD_N         => rxn(7),
      LANE3_RXD_P         => rxp(7),
      LANE3_TX_DATA       => data_in(8*SER_WIDTH-1 downto 7*SER_WIDTH),  -- 511 downto 448
      LANE3_TX_WCLK       => tx_usrclk_1,

      TX_BIT_CLK_0         => tx_bit_clk_1,
      TX_PLL_LOCK_0        => tx_pll_lock_1,
      TX_PLL_REF_CLK_0     => tx_clk_to_xcvr_1,
      -- Outputs
      LANE0_RX_BYPASS_DATA => open,
      LANE0_RX_CLK_R       => rx_usrclk_1(4),
      LANE0_RX_DATA        => data_out(5*SER_WIDTH-1 downto 4*SER_WIDTH),  -- 319 downto 256
      LANE0_RX_IDLE        => open,
      LANE0_RX_READY       => rx_ready(4),
      LANE0_RX_VAL         => rx_val(4),
      LANE0_TXD_N          => txn(4),
      LANE0_TXD_P          => txp(4),
      LANE0_TX_CLK_G       => open,
      LANE0_TX_CLK_R       => open,
      LANE0_TX_CLK_STABLE  => tx_clk_stable(4),

      LANE1_RX_BYPASS_DATA => open,
      LANE1_RX_CLK_R       => rx_usrclk_1(5),
      LANE1_RX_DATA        => data_out(6*SER_WIDTH-1 downto 5*SER_WIDTH),  -- 383 downto 320
      LANE1_RX_IDLE        => open,
      LANE1_RX_READY       => rx_ready(5),
      LANE1_RX_VAL         => rx_val(5),
      LANE1_TXD_N          => txn(5),
      LANE1_TXD_P          => txp(5),
      LANE1_TX_CLK_G       => tx_usrclk_1,
      LANE1_TX_CLK_R       => open,
      LANE1_TX_CLK_STABLE  => tx_clk_stable(5),

      LANE2_RX_BYPASS_DATA => open,
      LANE2_RX_CLK_R       => rx_usrclk_1(6),
      LANE2_RX_DATA        => data_out(7*SER_WIDTH-1 downto 6*SER_WIDTH),  -- 447 downto 384
      LANE2_RX_IDLE        => open,
      LANE2_RX_READY       => rx_ready(6),
      LANE2_RX_VAL         => rx_val(6),
      LANE2_TXD_N          => txn(6),
      LANE2_TXD_P          => txp(6),
      LANE2_TX_CLK_G       => open,
      LANE2_TX_CLK_R       => open,
      LANE2_TX_CLK_STABLE  => tx_clk_stable(6),

      LANE3_RX_BYPASS_DATA => open,
      LANE3_RX_CLK_R       => rx_usrclk_1(7),
      LANE3_RX_DATA        => data_out(8*SER_WIDTH-1 downto 7*SER_WIDTH),  -- 511 downto 448
      LANE3_RX_IDLE        => open,
      LANE3_RX_READY       => rx_ready(7),
      LANE3_RX_VAL         => rx_val(7),
      LANE3_TXD_N          => txn(7),
      LANE3_TXD_P          => txp(7),
      LANE3_TX_CLK_G       => open,
      LANE3_TX_CLK_R       => open,
      LANE3_TX_CLK_STABLE  => tx_clk_stable(7)
      );

-------------------------------------------
  --
  tx_rstdone       <= tx_clk_stable;
  rx_rstdone       <= rx_ready;
  --
  rx_xcvr_pll_lock <= rx_val;
  xcvr_pll_lock_generate : for i in NB_LANES/4-1 downto 0 generate
    tx_xcvr_pll_lock(i*4+0) <= pll_lock(i);
    tx_xcvr_pll_lock(i*4+1) <= pll_lock(i);
    tx_xcvr_pll_lock(i*4+2) <= pll_lock(i);
    tx_xcvr_pll_lock(i*4+3) <= pll_lock(i);
  end generate;
  --
  rx_usrclk <= rx_usrclk_1;
  tx_usrclk <= tx_usrclk_1;

  rx_frame_clk <= refclk_o;
  tx_frame_clk <= tx_usrclk_1;
--
end architecture rtl;
