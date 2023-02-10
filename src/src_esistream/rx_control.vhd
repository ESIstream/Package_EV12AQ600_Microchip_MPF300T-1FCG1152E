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
-- 1.2          2021            Teledyne e2v Increase sync width
-- 1.3          2021            Teledyne e2v Remove global rst 
-------------------------------------------------------------------------------
-- Description :
-- Manages and monitors sync, transceiver PLL(s) lock, reset, reset
-- done, user ready and ip ready signals. 
-------------------------------------------------------------------------------

library work;
use work.esistream_pkg.all;

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity rx_control is
  generic(
    NB_LANES : natural := 4
    );
  port (
    rx_usrclk       : in  std_logic;
    pll_lock        : in  std_logic;  -- Indicates whether GTH CPLL is locked
    rst_done        : in  std_logic;  -- Indicates that GTH is ready
    rst_esistream   : out std_logic;                              -- Reset logic FPGA, active high
    rst_transceiver : out std_logic;                              -- Reset GTH, active high
    ip_ready        : out std_logic                               -- Indicates that IP is ready if driven high
    );
end entity rx_control;

architecture rtl of rx_control is

  signal lock                   : std_logic                             := '0';
  signal lock_sr                : std_logic_vector(1 downto 0)          := (others => '0');
  signal sync_sr                : std_logic_vector(3 downto 0)          := (others => '0');
  signal rst_esistream_t        : std_logic                             := '0';

begin

  ip_ready        <= rst_done and pll_lock;
  rst_transceiver <= not pll_lock;

  p_transceiver_pll_lock : process(rx_usrclk)
  begin
    if rising_edge(rx_usrclk) then
      lock_sr(0) <= pll_lock;
      lock_sr(1) <= lock_sr(0);
    end if;
  end process;

  p_lock_rising_edge : process(rx_usrclk)
  begin
    if rising_edge(rx_usrclk) then
        rst_esistream <= lock_sr(0) and not lock_sr(1);
    end if;
  end process;

end architecture rtl;
