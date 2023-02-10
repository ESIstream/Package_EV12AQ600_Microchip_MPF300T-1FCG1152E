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
-- 1.1          2021            R.BAHRI      Creation
--------------------------------------------------------------------------------- 




library IEEE;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use IEEE.std_logic_1164.all;

entity add_u12 is
port (
       A    : in  std_logic_vector (11 downto 0);
       B    : in  std_logic_vector (11 downto 0);
       CLK  : in  std_logic;
       S    : out std_logic_vector (11 downto 0)
       );
end entity add_u12;

architecture rtl of add_u12 is
signal sum       : std_logic_vector(11 downto 0);
signal sum_d     : std_logic_vector(11 downto 0);
signal sum_d_d   : std_logic_vector(11 downto 0);
begin
  i_add : process(clk) 
    begin
        if rising_edge(clk) then
           sum <= A+B;
        end if;
    end process;
  i_latency : process(clk)
     begin
        if rising_edge(clk) then
            sum_d <= sum;
            sum_d_d <= sum_d;
        end if;
end process;
  S <= sum_d_d;
end architecture rtl;