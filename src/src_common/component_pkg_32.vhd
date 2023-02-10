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
-- 1.0          2022            R.BAHRI      Creation
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package component_pkg is

------------ transceiver ref clock
component PF_XCVR_REF_CLK_C0
    port  (
      -- Inputs
      REF_CLK_PAD_N : in  std_logic;
      REF_CLK_PAD_P : in  std_logic;
      -- Outputs
      REF_CLK       : out  std_logic
    );
end component;
---------------- PLL
component PF_CCC_C1
    port(
      -- Inputs
      PLL_POWERDOWN_N_0: in  std_logic;
      REF_CLK_0        : in  std_logic;
      -- Outputs
      OUT0_FABCLK_0    : out  std_logic;
      PLL_LOCK_0       : out  std_logic
    );
end component;

component PF_CCC_C0
    port(
      -- Inputs
      FB_CLK_0         : in  std_logic;
      PLL_POWERDOWN_N_0: in  std_logic;
      REF_CLK_0        : in  std_logic;
      -- Outputs
      OUT0_FABCLK_0    : out  std_logic;
      OUT1_FABCLK_0    : out  std_logic;
      OUT2_FABCLK_0    : out  std_logic;
      OUT3_FABCLK_0    : out  std_logic;
      PLL_LOCK_0       : out  std_logic
    );
end component;

----------- transmit pll
component PF_TX_PLL_C0
    port(
      -- Inputs
      REF_CLK        : in  std_logic;
      -- Outputs
      BIT_CLK         : out  std_logic;
      LOCK            : out  std_logic;
      PLL_LOCK        : out  std_logic;
      REF_CLK_TO_LANE : out  std_logic
    );
end component;
component PF_TX_PLL_C1
    port(
      -- Inputs
      REF_CLK        : in  std_logic;
      -- Outputs
      BIT_CLK         : out  std_logic;
      LOCK            : out  std_logic;
      PLL_LOCK        : out  std_logic;
      REF_CLK_TO_LANE : out  std_logic
    );
end component;
component PF_TX_PLL_C2
    port(
      -- Inputs
      REF_CLK        : in  std_logic;
      -- Outputs
      BIT_CLK         : out  std_logic;
      CLK_125         : out  std_logic;
      LOCK            : out  std_logic;
      PLL_LOCK        : out  std_logic;
      REF_CLK_TO_LANE : out  std_logic
    );
end component;
component PF_TX_PLL_C3
    port(
      -- Inputs
      REF_CLK        : in  std_logic;
      -- Outputs
      BIT_CLK         : out  std_logic;
      CLK_125         : out  std_logic;
      LOCK            : out  std_logic;
      PLL_LOCK        : out  std_logic;
      REF_CLK_TO_LANE : out  std_logic
    );
end component;
----- tx transceiver
component PF_XCVR_ERM_C0
    port (
      -- Inputs
       CTRL_ARST_N           : in  std_logic;
       CTRL_CLK              : in  std_logic;
       
       LANE0_CDR_REF_CLK_0   : in  std_logic;
       LANE0_LOS             : in  std_logic;
       LANE0_PCS_ARST_N      : in  std_logic;
       LANE0_PMA_ARST_N      : in  std_logic;
       LANE0_RXD_N           : in  std_logic;
       LANE0_RXD_P           : in  std_logic;
       LANE0_TX_DATA         : in  std_logic_vector (31 downto 0);
       LANE0_TX_WCLK         : in  std_logic;
       
       LANE1_CDR_REF_CLK_0   : in  std_logic;
       LANE1_LOS             : in  std_logic;
       LANE1_PCS_ARST_N      : in  std_logic;
       LANE1_PMA_ARST_N      : in  std_logic;
       LANE1_RXD_N           : in  std_logic;
       LANE1_RXD_P           : in  std_logic;
       LANE1_TX_DATA         : in  std_logic_vector (31 downto 0);
       LANE1_TX_WCLK         : in  std_logic;
       
       LANE2_CDR_REF_CLK_0   : in  std_logic;
       LANE2_LOS             : in  std_logic;
       LANE2_PCS_ARST_N      : in  std_logic;
       LANE2_PMA_ARST_N      : in  std_logic;
       LANE2_RXD_N           : in  std_logic;
       LANE2_RXD_P           : in std_logic ;
       LANE2_TX_DATA         : in std_logic_vector (31 downto 0); 
       LANE2_TX_WCLK         : in std_logic ;

       LANE3_CDR_REF_CLK_0   : in std_logic ;
       LANE3_LOS             : in  std_logic;
       LANE3_PCS_ARST_N      : in std_logic ;
       LANE3_PMA_ARST_N      : in std_logic ;
       LANE3_RXD_N           : in std_logic ;
       LANE3_RXD_P           : in std_logic ;
       LANE3_TX_DATA         : in std_logic_vector (31 downto 0); 
       LANE3_TX_WCLK         : in std_logic ;

       TX_BIT_CLK_0          : in std_logic ;
       TX_PLL_LOCK_0         : in std_logic ;
       TX_PLL_REF_CLK_0      : in std_logic ;
       -- Outputs  
       LANE0_RX_BYPASS_DATA  : out std_logic ;
       LANE0_RX_CLK_R        : out std_logic ;
       LANE0_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE0_RX_IDLE         : out std_logic ;
       LANE0_RX_READY        : out std_logic ;
       LANE0_RX_VAL          : out std_logic ;
       LANE0_TXD_N           : out std_logic ;
       LANE0_TXD_P           : out std_logic ;
       LANE0_TX_CLK_G        : out std_logic ;
       LANE0_TX_CLK_R        : out std_logic ;
       LANE0_TX_CLK_STABLE   : out std_logic ;
                             
       LANE1_RX_BYPASS_DATA  : out std_logic ;
       LANE1_RX_CLK_R        : out std_logic ;
       LANE1_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE1_RX_IDLE         : out std_logic ;
       LANE1_RX_READY        : out std_logic ;
       LANE1_RX_VAL          : out std_logic ;
       LANE1_TXD_N           : out std_logic ;
       LANE1_TXD_P           : out std_logic ;
       LANE1_TX_CLK_G        : out std_logic ;
       LANE1_TX_CLK_R        : out std_logic ;
       LANE1_TX_CLK_STABLE   : out std_logic ;
                             
       LANE2_RX_BYPASS_DATA  : out std_logic ;
       LANE2_RX_CLK_R        : out std_logic ;
       LANE2_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE2_RX_IDLE         : out std_logic ;
       LANE2_RX_READY        : out std_logic ;
       LANE2_RX_VAL          : out std_logic ;
       LANE2_TXD_N           : out std_logic ;
       LANE2_TXD_P           : out std_logic ;
       LANE2_TX_CLK_G        : out std_logic ;
       LANE2_TX_CLK_R        : out std_logic ;
       LANE2_TX_CLK_STABLE   : out std_logic ;
                             
       LANE3_RX_BYPASS_DATA  : out std_logic ;
       LANE3_RX_CLK_R        : out std_logic ;
       LANE3_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE3_RX_IDLE         : out std_logic ;
       LANE3_RX_READY        : out std_logic ;
       LANE3_RX_VAL          : out std_logic ;
       LANE3_TXD_N           : out std_logic ;
       LANE3_TXD_P           : out std_logic ;
       LANE3_TX_CLK_G        : out std_logic ;
       LANE3_TX_CLK_R        : out std_logic ;
       LANE3_TX_CLK_STABLE   : out std_logic 
    );
end component;




-------------- rx transceiver
  component PF_XCVR_ERM_C1
    port (
      -- Inputs
       CTRL_ARST_N           : in  std_logic;
       CTRL_CLK              : in  std_logic;
       
       LANE0_CDR_REF_CLK_0   : in  std_logic;
       LANE0_LOS             : in  std_logic;
       LANE0_PCS_ARST_N      : in  std_logic;
       LANE0_PMA_ARST_N      : in  std_logic;
       LANE0_RXD_N           : in  std_logic;
       LANE0_RXD_P           : in  std_logic;
       LANE0_TX_DATA         : in  std_logic_vector (31 downto 0);
       LANE0_TX_WCLK         : in  std_logic;
       
       LANE1_CDR_REF_CLK_0   : in  std_logic;
       LANE1_LOS             : in  std_logic;
       LANE1_PCS_ARST_N      : in  std_logic;
       LANE1_PMA_ARST_N      : in  std_logic;
       LANE1_RXD_N           : in  std_logic;
       LANE1_RXD_P           : in  std_logic;
       LANE1_TX_DATA         : in  std_logic_vector (31 downto 0);
       LANE1_TX_WCLK         : in  std_logic;
       
       LANE2_CDR_REF_CLK_0   : in  std_logic;
       LANE2_LOS             : in  std_logic;
       LANE2_PCS_ARST_N      : in  std_logic;
       LANE2_PMA_ARST_N      : in  std_logic;
       LANE2_RXD_N           : in  std_logic;
       LANE2_RXD_P           : in std_logic ;
       LANE2_TX_DATA         : in std_logic_vector (31 downto 0); 
       LANE2_TX_WCLK         : in std_logic ;

       LANE3_CDR_REF_CLK_0   : in std_logic ;
       LANE3_LOS             : in  std_logic;
       LANE3_PCS_ARST_N      : in std_logic ;
       LANE3_PMA_ARST_N      : in std_logic ;
       LANE3_RXD_N           : in std_logic ;
       LANE3_RXD_P           : in std_logic ;
       LANE3_TX_DATA         : in std_logic_vector (31 downto 0); 
       LANE3_TX_WCLK         : in std_logic ;

       TX_BIT_CLK_0          : in std_logic ;
       TX_PLL_LOCK_0         : in std_logic ;
       TX_PLL_REF_CLK_0      : in std_logic ;
       -- Outputs  
       LANE0_RX_BYPASS_DATA  : out std_logic ;
       LANE0_RX_CLK_R        : out std_logic ;
       LANE0_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE0_RX_IDLE         : out std_logic ;
       LANE0_RX_READY        : out std_logic ;
       LANE0_RX_VAL          : out std_logic ;
       LANE0_TXD_N           : out std_logic ;
       LANE0_TXD_P           : out std_logic ;
       LANE0_TX_CLK_G        : out std_logic ;
       LANE0_TX_CLK_R        : out std_logic ;
       LANE0_TX_CLK_STABLE   : out std_logic ;
                             
       LANE1_RX_BYPASS_DATA  : out std_logic ;
       LANE1_RX_CLK_R        : out std_logic ;
       LANE1_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE1_RX_IDLE         : out std_logic ;
       LANE1_RX_READY        : out std_logic ;
       LANE1_RX_VAL          : out std_logic ;
       LANE1_TXD_N           : out std_logic ;
       LANE1_TXD_P           : out std_logic ;
       LANE1_TX_CLK_G        : out std_logic ;
       LANE1_TX_CLK_R        : out std_logic ;
       LANE1_TX_CLK_STABLE   : out std_logic ;
                             
       LANE2_RX_BYPASS_DATA  : out std_logic ;
       LANE2_RX_CLK_R        : out std_logic ;
       LANE2_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE2_RX_IDLE         : out std_logic ;
       LANE2_RX_READY        : out std_logic ;
       LANE2_RX_VAL          : out std_logic ;
       LANE2_TXD_N           : out std_logic ;
       LANE2_TXD_P           : out std_logic ;
       LANE2_TX_CLK_G        : out std_logic ;
       LANE2_TX_CLK_R        : out std_logic ;
       LANE2_TX_CLK_STABLE   : out std_logic ;
                             
       LANE3_RX_BYPASS_DATA  : out std_logic ;
       LANE3_RX_CLK_R        : out std_logic ;
       LANE3_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE3_RX_IDLE         : out std_logic ;
       LANE3_RX_READY        : out std_logic ;
       LANE3_RX_VAL          : out std_logic ;
       LANE3_TXD_N           : out std_logic ;
       LANE3_TXD_P           : out std_logic ;
       LANE3_TX_CLK_G        : out std_logic ;
       LANE3_TX_CLK_R        : out std_logic ;
       LANE3_TX_CLK_STABLE   : out std_logic 
    );
end component;

----- tx transceiver
component PF_XCVR_ERM_C4
    port (
      -- Inputs
       
       LANE0_CDR_REF_CLK_0   : in  std_logic;
   --    LANE0_LOS             : in  std_logic;
       LANE0_PCS_ARST_N      : in  std_logic;
       LANE0_PMA_ARST_N      : in  std_logic;
       LANE0_RXD_N           : in  std_logic;
       LANE0_RXD_P           : in  std_logic;
       LANE0_TX_DATA         : in  std_logic_vector (31 downto 0);
       LANE0_TX_WCLK         : in  std_logic;
       
       LANE1_CDR_REF_CLK_0   : in  std_logic;
   --    LANE1_LOS             : in  std_logic;
       LANE1_PCS_ARST_N      : in  std_logic;
       LANE1_PMA_ARST_N      : in  std_logic;
       LANE1_RXD_N           : in  std_logic;
       LANE1_RXD_P           : in  std_logic;
       LANE1_TX_DATA         : in  std_logic_vector (31 downto 0);
       LANE1_TX_WCLK         : in  std_logic;
       
       LANE2_CDR_REF_CLK_0   : in  std_logic;
   --    LANE2_LOS             : in  std_logic;
       LANE2_PCS_ARST_N      : in  std_logic;
       LANE2_PMA_ARST_N      : in  std_logic;
       LANE2_RXD_N           : in  std_logic;
       LANE2_RXD_P           : in std_logic ;
       LANE2_TX_DATA         : in std_logic_vector (31 downto 0); 
       LANE2_TX_WCLK         : in std_logic ;

       LANE3_CDR_REF_CLK_0   : in std_logic ;
   --    LANE3_LOS             : in  std_logic;
       LANE3_PCS_ARST_N      : in std_logic ;
       LANE3_PMA_ARST_N      : in std_logic ;
       LANE3_RXD_N           : in std_logic ;
       LANE3_RXD_P           : in std_logic ;
       LANE3_TX_DATA         : in std_logic_vector (31 downto 0); 
       LANE3_TX_WCLK         : in std_logic ;

       TX_BIT_CLK_0          : in std_logic ;
       TX_PLL_LOCK_0         : in std_logic ;
       TX_PLL_REF_CLK_0      : in std_logic ;
       -- Outputs  
       LANE0_RX_BYPASS_DATA  : out std_logic ;
       LANE0_RX_CLK_R        : out std_logic ;
       LANE0_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE0_RX_IDLE         : out std_logic ;
       LANE0_RX_READY        : out std_logic ;
       LANE0_RX_VAL          : out std_logic ;
       LANE0_TXD_N           : out std_logic ;
       LANE0_TXD_P           : out std_logic ;
       LANE0_TX_CLK_G        : out std_logic ;
       LANE0_TX_CLK_R        : out std_logic ;
       LANE0_TX_CLK_STABLE   : out std_logic ;
                             
       LANE1_RX_BYPASS_DATA  : out std_logic ;
       LANE1_RX_CLK_R        : out std_logic ;
       LANE1_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE1_RX_IDLE         : out std_logic ;
       LANE1_RX_READY        : out std_logic ;
       LANE1_RX_VAL          : out std_logic ;
       LANE1_TXD_N           : out std_logic ;
       LANE1_TXD_P           : out std_logic ;
       LANE1_TX_CLK_G        : out std_logic ;
       LANE1_TX_CLK_R        : out std_logic ;
       LANE1_TX_CLK_STABLE   : out std_logic ;
                             
       LANE2_RX_BYPASS_DATA  : out std_logic ;
       LANE2_RX_CLK_R        : out std_logic ;
       LANE2_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE2_RX_IDLE         : out std_logic ;
       LANE2_RX_READY        : out std_logic ;
       LANE2_RX_VAL          : out std_logic ;
       LANE2_TXD_N           : out std_logic ;
       LANE2_TXD_P           : out std_logic ;
       LANE2_TX_CLK_G        : out std_logic ;
       LANE2_TX_CLK_R        : out std_logic ;
       LANE2_TX_CLK_STABLE   : out std_logic ;
                             
       LANE3_RX_BYPASS_DATA  : out std_logic ;
       LANE3_RX_CLK_R        : out std_logic ;
       LANE3_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE3_RX_IDLE         : out std_logic ;
       LANE3_RX_READY        : out std_logic ;
       LANE3_RX_VAL          : out std_logic ;
       LANE3_TXD_N           : out std_logic ;
       LANE3_TXD_P           : out std_logic ;
       LANE3_TX_CLK_G        : out std_logic ;
       LANE3_TX_CLK_R        : out std_logic ;
       LANE3_TX_CLK_STABLE   : out std_logic 
    );
end component;




-------------- rx transceiver
  component PF_XCVR_ERM_C5
    port (
      -- Inputs
       
       LANE0_CDR_REF_CLK_0   : in  std_logic;
   --    LANE0_LOS             : in  std_logic;
       LANE0_PCS_ARST_N      : in  std_logic;
       LANE0_PMA_ARST_N      : in  std_logic;
       LANE0_RXD_N           : in  std_logic;
       LANE0_RXD_P           : in  std_logic;
       LANE0_TX_DATA         : in  std_logic_vector (31 downto 0);
       LANE0_TX_WCLK         : in  std_logic;
       
       LANE1_CDR_REF_CLK_0   : in  std_logic;
   --    LANE1_LOS             : in  std_logic;
       LANE1_PCS_ARST_N      : in  std_logic;
       LANE1_PMA_ARST_N      : in  std_logic;
       LANE1_RXD_N           : in  std_logic;
       LANE1_RXD_P           : in  std_logic;
       LANE1_TX_DATA         : in  std_logic_vector (31 downto 0);
       LANE1_TX_WCLK         : in  std_logic;
       
       LANE2_CDR_REF_CLK_0   : in  std_logic;
   --    LANE2_LOS             : in  std_logic;
       LANE2_PCS_ARST_N      : in  std_logic;
       LANE2_PMA_ARST_N      : in  std_logic;
       LANE2_RXD_N           : in  std_logic;
       LANE2_RXD_P           : in std_logic ;
       LANE2_TX_DATA         : in std_logic_vector (31 downto 0); 
       LANE2_TX_WCLK         : in std_logic ;

       LANE3_CDR_REF_CLK_0   : in std_logic ;
   --    LANE3_LOS             : in  std_logic;
       LANE3_PCS_ARST_N      : in std_logic ;
       LANE3_PMA_ARST_N      : in std_logic ;
       LANE3_RXD_N           : in std_logic ;
       LANE3_RXD_P           : in std_logic ;
       LANE3_TX_DATA         : in std_logic_vector (31 downto 0); 
       LANE3_TX_WCLK         : in std_logic ;

       TX_BIT_CLK_0          : in std_logic ;
       TX_PLL_LOCK_0         : in std_logic ;
       TX_PLL_REF_CLK_0      : in std_logic ;
       -- Outputs  
       LANE0_RX_BYPASS_DATA  : out std_logic ;
       LANE0_RX_CLK_R        : out std_logic ;
       LANE0_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE0_RX_IDLE         : out std_logic ;
       LANE0_RX_READY        : out std_logic ;
       LANE0_RX_VAL          : out std_logic ;
       LANE0_TXD_N           : out std_logic ;
       LANE0_TXD_P           : out std_logic ;
       LANE0_TX_CLK_G        : out std_logic ;
       LANE0_TX_CLK_R        : out std_logic ;
       LANE0_TX_CLK_STABLE   : out std_logic ;
                             
       LANE1_RX_BYPASS_DATA  : out std_logic ;
       LANE1_RX_CLK_R        : out std_logic ;
       LANE1_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE1_RX_IDLE         : out std_logic ;
       LANE1_RX_READY        : out std_logic ;
       LANE1_RX_VAL          : out std_logic ;
       LANE1_TXD_N           : out std_logic ;
       LANE1_TXD_P           : out std_logic ;
       LANE1_TX_CLK_G        : out std_logic ;
       LANE1_TX_CLK_R        : out std_logic ;
       LANE1_TX_CLK_STABLE   : out std_logic ;
                             
       LANE2_RX_BYPASS_DATA  : out std_logic ;
       LANE2_RX_CLK_R        : out std_logic ;
       LANE2_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE2_RX_IDLE         : out std_logic ;
       LANE2_RX_READY        : out std_logic ;
       LANE2_RX_VAL          : out std_logic ;
       LANE2_TXD_N           : out std_logic ;
       LANE2_TXD_P           : out std_logic ;
       LANE2_TX_CLK_G        : out std_logic ;
       LANE2_TX_CLK_R        : out std_logic ;
       LANE2_TX_CLK_STABLE   : out std_logic ;
                             
       LANE3_RX_BYPASS_DATA  : out std_logic ;
       LANE3_RX_CLK_R        : out std_logic ;
       LANE3_RX_DATA         : out std_logic_vector (31 downto 0); 
       LANE3_RX_IDLE         : out std_logic ;
       LANE3_RX_READY        : out std_logic ;
       LANE3_RX_VAL          : out std_logic ;
       LANE3_TXD_N           : out std_logic ;
       LANE3_TXD_P           : out std_logic ;
       LANE3_TX_CLK_G        : out std_logic ;
       LANE3_TX_CLK_R        : out std_logic ;
       LANE3_TX_CLK_STABLE   : out std_logic 
    );
end component;


end package;
