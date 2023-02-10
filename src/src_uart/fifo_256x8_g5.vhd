-- ********************************************************************
-- Actel Corporation Proprietary and Confidential
--  Copyright 2008 Actel Corporation.  All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- Description: COREUART/ CoreUARTapb UART core
--
--
--  Revision Information:
-- Date     Description
-- Jun09    Revision 4.1
-- Aug10    Revision 4.2

-- SVN Revision Information:
-- SVN $Revision: 8508 $
-- SVN $Date: 2009-06-15 16:49:49 -0700 (Mon, 15 Jun 2009) $
--
-- Resolved SARs
-- SAR      Date     Who   Description
-- 20741    2Sep10   AS    Increased baud rate by ensuring fifo ctrl runs off
--                         sys clk (not baud clock).  See note below.

-- Notes:
-- best viewed with tabstops set to "4"                    
library ieee;                                          
use ieee.std_logic_1164.all;                        
library polarfire;
                                                    
                                                        
                                    
ENTITY COREUART_C0_COREUART_C0_0_fifo_256x8 IS
   GENERIC ( SYNC_RESET :  integer := 0);
   PORT (
      DO                      : OUT std_logic_vector(7 DOWNTO 0);   
      RCLOCK                  : IN std_logic;   
      WCLOCK                  : IN std_logic;   
      DI                      : IN std_logic_vector(7 DOWNTO 0);   
      WRB                     : IN std_logic;   
      RDB                     : IN std_logic;   
      RESET                   : IN std_logic;   
      FULL                    : OUT std_logic;   
      EMPTY                   : OUT std_logic);   
END ENTITY COREUART_C0_COREUART_C0_0_fifo_256x8;

ARCHITECTURE translated OF COREUART_C0_COREUART_C0_0_fifo_256x8 IS

   COMPONENT COREUART_C0_COREUART_C0_0_fifo_ctrl_256
      GENERIC (
          SYNC_RESET                     :  integer := 0;
          FIFO_BITS                      :  integer := 8;    --  Number of bits required to
          FIFO_WIDTH                     :  integer := 8;    --  Width of FIFO data
          FIFO_DEPTH                     :  integer := 256);    --  Depth of FIFO (number of bytes)
      PORT (
         clock                   : IN  std_logic;
         reset_n                 : IN  std_logic;
         data_in                 : IN  std_logic_vector(FIFO_WIDTH - 1 DOWNTO 0);
         read_n                  : IN  std_logic;
         write_n                 : IN  std_logic;
         LEVEL                   : IN  std_logic_vector(FIFO_BITS - 1 DOWNTO 0);
         data_out                : OUT std_logic_vector(FIFO_WIDTH - 1 DOWNTO 0);
         full                    : OUT std_logic;
         empty                   : OUT std_logic;
         half                    : OUT std_logic);
   END COMPONENT;


   CONSTANT  LEVEL                 :  std_logic_vector(7 DOWNTO 0) := "01000000";    
   SIGNAL AEMPTY                   :  std_logic;   
   SIGNAL AFULL                    :  std_logic;   
   SIGNAL DO_xhdl1                 :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL FULL_xhdl2               :  std_logic;   
   SIGNAL EMPTY_xhdl3              :  std_logic;   
   SIGNAL GEQTH                    :  std_logic;   

BEGIN
   DO <= DO_xhdl1;
   FULL <= FULL_xhdl2;
   EMPTY <= EMPTY_xhdl3;
   COREUART_C0_COREUART_C0_0_fifo_256x8_g5 : COREUART_C0_COREUART_C0_0_fifo_ctrl_256
      GENERIC MAP(SYNC_RESET => SYNC_RESET)
      PORT MAP (
         data_in => DI,
         data_out => DO_xhdl1,
         write_n => WRB,
         read_n => RDB,
         clock => WCLOCK,
         full => FULL_xhdl2,
         empty => EMPTY_xhdl3,
         half => GEQTH,
         reset_n => RESET,
         LEVEL => LEVEL);   
   

END ARCHITECTURE translated;

--*******************************************************-- MODULE:		Synchronous FIFO
--
-- FILE NAME:	fifo_ctl.v
-- 
-- CODE TYPE:	Register Transfer Level
--
-- DESCRIPTION:	This module defines a Synchronous FIFO. The
-- FIFO memory is implemented as a ring buffer. The read
-- pointer points to the beginning of the buffer, while the
-- write pointer points to the end of the buffer. Note that
-- in this RTL version, the memory has one more location than
-- the FIFO needs in order to calculate the FIFO count
-- correctly.
--
--*******************************************************-- fifo control logic 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;                          
library polarfire;
                       

ENTITY COREUART_C0_COREUART_C0_0_fifo_ctrl_256 IS
   GENERIC (
      SYNC_RESET                     :  integer := 0;
      FIFO_DEPTH                     :  integer := 256;    --  Depth of FIFO (number of bytes)
      FIFO_BITS                      :  integer := 8;    --  Number of bits required to
      FIFO_WIDTH                     :  integer := 8);    --  Width of FIFO data
   PORT (
      -- INPUTS

      clock                   : IN std_logic;   --  Clock input
      reset_n                 : IN std_logic;   --  Active low reset
      data_in                 : IN std_logic_vector(FIFO_WIDTH - 1 DOWNTO 0);   --  Data input to FIFO
      read_n                  : IN std_logic;   --  Read FIFO (active low)
      write_n                 : IN std_logic;   --  Write FIFO (active low)
      LEVEL                   : IN std_logic_vector(FIFO_BITS - 1 DOWNTO 0);   
      -- OUTPUTS

      data_out                : OUT std_logic_vector(FIFO_WIDTH - 1 DOWNTO 0);   --  FIFO output data
      full                    : OUT std_logic;   --  FIFO is full
      empty                   : OUT std_logic;   --  FIFO is empty
      half                    : OUT std_logic);   --  FIFO is half full
END ENTITY COREUART_C0_COREUART_C0_0_fifo_ctrl_256;

ARCHITECTURE translated OF COREUART_C0_COREUART_C0_0_fifo_ctrl_256 IS

   COMPONENT COREUART_C0_COREUART_C0_0_ram256x8_g5
      PORT (
         Data                    : IN  std_logic_vector(7 DOWNTO 0);
         Q                       : OUT std_logic_vector(7 DOWNTO 0);
         WAddress                : IN  std_logic_vector(7 DOWNTO 0);
         RAddress                : IN  std_logic_vector(7 DOWNTO 0);
         WE                      : IN  std_logic;
         RE                      : IN  std_logic;
         WClock                  : IN  std_logic;
         reset_n                 : IN  std_logic;
         RClock                  : IN  std_logic);
   END COMPONENT;


   -- or more
   -- INOUTS
   -- SIGNAL DECLARATIONS
   SIGNAL data_out_0               :  std_logic_vector(FIFO_WIDTH - 1 DOWNTO 0);   
   SIGNAL read_n_hold              :  std_logic;   
   -- How many locations in the FIFO
   -- are occupied?
   SIGNAL counter                  :  std_logic_vector(FIFO_BITS - 1 DOWNTO 0);   
   -- FIFO read pointer points to
   -- the location in the FIFO to
   -- read from next
   SIGNAL rd_pointer               :  std_logic_vector(FIFO_BITS - 1 DOWNTO 0);   
   -- FIFO write pointer points to
   -- the location in the FIFO to
   -- write to next
   SIGNAL wr_pointer               :  std_logic_vector(FIFO_BITS - 1 DOWNTO 0);   
   -- PARAMETERS
   -- ASSIGN STATEMENTS
   SIGNAL temp_xhdl5               :  std_logic;   
   SIGNAL temp_xhdl6               :  std_logic;   
   SIGNAL temp_xhdl7               :  std_logic;   
   SIGNAL data_out_xhdl1           :  std_logic_vector(FIFO_WIDTH - 1 DOWNTO 0);   
   SIGNAL full_xhdl2               :  std_logic;   
   SIGNAL empty_xhdl3              :  std_logic;   
   SIGNAL half_xhdl4               :  std_logic;   
   SIGNAL aresetn                  :  std_logic;
   SIGNAL sresetn                  :  std_logic;

BEGIN
   aresetn <= '1' WHEN (SYNC_RESET=1) ELSE reset_n;
   sresetn <= reset_n WHEN (SYNC_RESET=1) ELSE '1';
   data_out <= data_out_xhdl1;
   full <= full_xhdl2;
   empty <= empty_xhdl3;
   half <= half_xhdl4;
   temp_xhdl5 <= '1' WHEN (counter = CONV_STD_LOGIC_VECTOR(FIFO_DEPTH - 1, 8)) ELSE '0';
   full_xhdl2 <= temp_xhdl5 ;
   temp_xhdl6 <= '1' WHEN (counter = "00000000") ELSE '0';
   empty_xhdl3 <= temp_xhdl6 ;
   temp_xhdl7 <= '1' WHEN (counter >= LEVEL) ELSE '0';
   half_xhdl4 <= temp_xhdl7 ;

   -- MAIN CODE
   -- This block contains all devices affected by the clock 
   -- and reset inputs
   
   PROCESS (clock, aresetn)
   BEGIN
      IF (NOT aresetn = '1') THEN
         -- Reset the FIFO pointer
         rd_pointer <= (OTHERS => '0');    
         wr_pointer <= (OTHERS => '0');    
         counter <= (OTHERS => '0');    
      ELSIF (clock'EVENT AND clock = '1') THEN
        IF (NOT sresetn = '1') THEN
           -- Reset the FIFO pointer
           rd_pointer <= (OTHERS => '0');    
           wr_pointer <= (OTHERS => '0');    
           counter <= (OTHERS => '0');    
	    ELSE
	    
           IF (NOT read_n = '1') THEN
              -- If we are doing a simultaneous read and write,
              -- there is no change to the counter
              
              IF (write_n = '1') THEN
                 -- Decrement the FIFO counter
                 
                 counter <= counter - "00000001";    
              END IF;
              -- Increment the read pointer
              -- Check if the read pointer has gone beyond the
              -- depth of the FIFO. If so, set it back to the
              -- beginning of the FIFO
              
              IF (rd_pointer = CONV_STD_LOGIC_VECTOR(FIFO_DEPTH - 1, 8)) 
              THEN
                 rd_pointer <= (OTHERS => '0');    
              ELSE
                 rd_pointer <= rd_pointer + "00000001";    
              END IF;
           END IF;
           IF (NOT write_n = '1') THEN
              -- If we are doing a simultaneous read and write,
              -- there is no change to the counter
              
              IF (read_n = '1') THEN
                 -- Increment the FIFO counter
                 
                 counter <= counter + "00000001";    
              END IF;
              -- Increment the write pointer
              -- Check if the write pointer has gone beyond the
              -- depth of the FIFO. If so, set it back to the
              -- beginning of the FIFO
              
              IF (wr_pointer = CONV_STD_LOGIC_VECTOR(FIFO_DEPTH - 1, 8)) 
              THEN
                 wr_pointer <= (OTHERS => '0');    
              ELSE
                 wr_pointer <= wr_pointer + "00000001";    
              END IF;
           END IF;
        END IF;
      END IF;
   END PROCESS;

   PROCESS (clock, aresetn)
   BEGIN
      IF (NOT aresetn = '1') THEN
         read_n_hold <= '0';    
      ELSIF (clock'EVENT AND clock = '1') THEN
         IF (NOT sresetn = '1') THEN
            read_n_hold <= '0';    
	     ELSE
            read_n_hold <= read_n;    
            IF (read_n_hold = '0') THEN
               data_out_xhdl1 <= data_out_0;    
            ELSE
               data_out_xhdl1 <= data_out_xhdl1;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   ram256x8_g5 : COREUART_C0_COREUART_C0_0_ram256x8_g5 
      PORT MAP (
         Data => data_in,
         Q => data_out_0,
         WAddress => wr_pointer,
         RAddress => rd_pointer,
         WE => write_n,
		 RE => read_n,
         reset_n => reset_n,
         WClock => clock,
         RClock => clock);   
   

END ARCHITECTURE translated;


library ieee;
use ieee.std_logic_1164.all;
library polarfire;        

ENTITY COREUART_C0_COREUART_C0_0_ram256x8_g5 IS
   PORT (
      Data                    : IN std_logic_vector(7 DOWNTO 0);   
      Q                       : OUT std_logic_vector(7 DOWNTO 0);   
      WAddress                : IN std_logic_vector(7 DOWNTO 0);   
      RAddress                : IN std_logic_vector(7 DOWNTO 0);   
      WE                      : IN std_logic;    
      RE                      : IN std_logic;    
      reset_n                 : IN  std_logic;  
      WClock                  : IN std_logic;   
      RClock                  : IN std_logic);   
END ENTITY COREUART_C0_COREUART_C0_0_ram256x8_g5;

ARCHITECTURE translated OF COREUART_C0_COREUART_C0_0_ram256x8_g5 IS

    component INV
        port(A : in std_logic := 'U'; Y : out std_logic) ;
    end component;

COMPONENT RAM1K20
PORT ( 
  A_DOUT        : OUT std_logic_vector (19 DOWNTO 0);         
  B_DOUT        : OUT std_logic_vector (19 DOWNTO 0);         
  ACCESS_BUSY   : OUT std_logic;    
  DB_DETECT     : OUT std_logic;      
  SB_CORRECT    : OUT std_logic;     
  BUSY_FB       : IN  std_logic;        
  ECC_EN        : IN  std_logic;         
  ECC_BYPASS    : IN  std_logic;     
  A_CLK         : IN  std_logic;          
  A_DOUT_EN     : IN  std_logic;      
  A_BLK_EN      : IN  std_logic_vector (2 DOWNTO 0);       
  A_DOUT_SRST_N : IN  std_logic;  
  A_DOUT_ARST_N : IN  std_logic;  
  A_BYPASS      : IN  std_logic;       
  A_DIN         : IN  std_logic_vector (19 DOWNTO 0);          
  A_ADDR        : IN  std_logic_vector (13 DOWNTO 0);         
  A_WEN         : IN  std_logic_vector (1 DOWNTO 0);          
  A_REN         : IN  std_logic;          
  A_WIDTH       : IN  std_logic_vector (2 DOWNTO 0);        
  A_WMODE       : IN  std_logic_vector (1 DOWNTO 0);       
  B_CLK         : IN  std_logic;          
  B_DOUT_EN     : IN  std_logic;      
  B_BLK_EN      : IN  std_logic_vector (2 DOWNTO 0);       
  B_DOUT_SRST_N : IN  std_logic;  
  B_DOUT_ARST_N : IN  std_logic;  
  B_BYPASS      : IN  std_logic;          
  B_DIN         : IN  std_logic_vector (19 DOWNTO 0);          
  B_ADDR        : IN  std_logic_vector (13 DOWNTO 0);         
  B_WEN         : IN  std_logic_vector (1 DOWNTO 0);          
  B_REN         : IN  std_logic;          
  B_WIDTH       : IN  std_logic_vector (2 DOWNTO 0);        
  B_WMODE       : IN  std_logic_vector (1 DOWNTO 0)); 
END COMPONENT;   

    component VCC
        port( Y : out std_logic);
    end component;

    component GND
        port( Y : out std_logic);
    end component;

   SIGNAL INV_1_Y                  :  std_logic;   
   SIGNAL INV_0_Y                  :  std_logic;   
   SIGNAL DOUT_RAM_0               :  std_LOGIC_vector(19 DOWNTO 0);
   SIGNAL RADDR_int                :  std_LOGIC_vector(13 DOWNTO 0);
   SIGNAL WADDR_int                :  std_LOGIC_vector(13 DOWNTO 0);
   SIGNAL DIN_RAM_0                :  std_LOGIC_vector(19 DOWNTO 0);
   SIGNAL RE_int                   :  std_LOGIC_vector(2 DOWNTO 0);
   SIGNAL WE_int                   :  std_LOGIC_vector(2 DOWNTO 0);

BEGIN
   INV_0 : INV 
      PORT MAP (
         A => WE,
         Y => INV_0_Y); 
   INV_1 : INV 
      PORT MAP (
         A => RE,
         Y => INV_1_Y); 
 
Q <= DOUT_RAM_0(7 downto 0);
RADDR_int <= "00" & RAddress & "0000";
WADDR_int <= "00" & WAddress & "0000";
DIN_RAM_0 <= "000000000000" & Data;
WE_int <= INV_0_Y & "11";
RE_int <= INV_1_Y & "11";


RAM_R0C0 : RAM1K20
    --GENERIC MAP(WARNING_MSGS_ON => 0) -- Remove Read and Write same address warning for pre-sythesis simulation
    PORT MAP ( A_DOUT        => DOUT_RAM_0,           
               B_DOUT        => open, 
               ACCESS_BUSY   => open, 
               BUSY_FB       => '1',
               ECC_EN        => '0', 
               ECC_BYPASS    => '0', 
               DB_DETECT     => open, 
               SB_CORRECT    => open,
               A_CLK         => RClock, 
               A_DOUT_EN     => '1', 
               A_DOUT_SRST_N => '1',
               A_DOUT_ARST_N => '1',
               A_BYPASS      => '1', 
               A_BLK_EN      => RE_int, 
               A_DIN         => X"00000", 
               A_ADDR        => RADDR_int, 
               A_WEN         => "00", 
               A_REN         => '1', 
               A_WIDTH       => "100", 
               A_WMODE       => "00", 
               B_CLK         => WClock, 
               B_DOUT_EN     => '1', 
               B_DOUT_SRST_N => '1',
               B_DOUT_ARST_N => '1',
               B_BYPASS      => '1', 
               B_BLK_EN      => WE_int, 
               B_DIN         => DIN_RAM_0, 
               B_ADDR        => WADDR_int, 
               B_WEN         => "11", 
               B_REN         => '0', 
               B_WIDTH       => "100", 
               B_WMODE       => "00");      
   
END ARCHITECTURE translated;
