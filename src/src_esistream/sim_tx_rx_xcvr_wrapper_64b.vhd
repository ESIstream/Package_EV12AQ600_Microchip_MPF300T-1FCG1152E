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
  --
  signal rstn     : std_logic := '1';
  signal refclk_o : std_logic := '0';
--
begin
  rstn <= not rst;
  --
  data_out         <= data_in;
  --
  rx_xcvr_pll_lock <= (others => rstn);
  rx_rstdone       <= (others => rstn);
  rx_usrclk        <= (others => refclk_o);
  rx_frame_clk     <= refclk_o;
  --
  tx_xcvr_pll_lock <= (others => rstn);
  tx_rstdone       <= (others => rstn);
  tx_usrclk        <= refclk_o;
  tx_frame_clk     <= refclk_o;
  txp              <= (others => '1');
  txn              <= (others => '0');
  --
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
--
end architecture rtl;
