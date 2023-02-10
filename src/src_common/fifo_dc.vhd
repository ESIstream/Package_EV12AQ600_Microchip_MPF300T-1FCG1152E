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
library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

entity FIFO_DC is
   generic
   (
      G_DATA_LENGTH     : integer := 32;
      G_ADDR_LENGTH     : integer := 4
   );
   port
   (
      RESET_N        : in    std_logic;

      CLK_WR         : in    std_logic;
      WR             : in    std_logic;
      DATA_IN        : in    std_logic_vector(G_DATA_LENGTH-1 downto 0);

      CLK_RD         : in    std_logic;
      RD             : in    std_logic;
      DATA_OUT       : out   std_logic_vector(G_DATA_LENGTH-1 downto 0);

      THRESHOLD_HIGH : in    std_logic_vector(G_ADDR_LENGTH downto 0);
      THRESHOLD_LOW  : in    std_logic_vector(G_ADDR_LENGTH downto 0);

      FULL           : out   std_logic;
      ALMOST_FULL    : out   std_logic;
      FULL_N         : out   std_logic;
      ALMOST_FULL_N  : out   std_logic;
      EMPTY          : out   std_logic;
      ALMOST_EMPTY   : out   std_logic;
      EMPTY_N        : out   std_logic;
      ALMOST_EMPTY_N : out   std_logic
   );
end entity FIFO_DC;

architecture ARCH_FIFO_DC of FIFO_DC is

   component RAM_DUAL_CLOCK is
      generic
      (
         G_ADDR_LENGTH : integer := 8;
         G_DATA_LENGTH : integer := 8
      );
      port
      (
         CLK_WR  : in    std_logic;
         WR_ADDR : in    std_logic_vector(G_ADDR_LENGTH-1 downto 0);
         DIN     : in    std_logic_vector(G_DATA_LENGTH-1 downto 0);
         WE      : in    std_logic;
         CLK_RD  : in    std_logic;
         RD_ADDR : in    std_logic_vector(G_ADDR_LENGTH-1 downto 0);
         DOUT    : out   std_logic_vector(G_DATA_LENGTH-1 downto 0)
      );
   end component RAM_DUAL_CLOCK;

   ----------------------------------------------------------------------------
   -- FUNCTIONS
   ----------------------------------------------------------------------------
   function binary_to_gray_code (data : unsigned(G_ADDR_LENGTH-1 downto 0)) return unsigned is
   begin
      return data(data'high) & (data(data'high downto 1) xor data(data'high-1 downto 0));
   end function binary_to_gray_code;

   function gray_to_binary_code (data_gray : unsigned(G_ADDR_LENGTH-1 downto 0)) return unsigned is
      variable data : unsigned (data_gray'range);
   begin
      data(data'high) := data_gray(data'high);
      for i in data'high-1 downto 0 loop
         data(i) := data(i+1) xor data_gray(i);
      end loop;
      return data;
   end function gray_to_binary_code;

   ----------------------------------------------------------------------------
   constant CST_DEPTH   : integer := 2**G_ADDR_LENGTH;

   ----------------------------------------------------------------------------
   signal wr_en_s                : std_logic:='0';

   signal ptr_wr_s               : std_logic_vector(G_ADDR_LENGTH-1 downto 0):=(others=>'0');
   signal addr_wr_r              : unsigned(G_ADDR_LENGTH-1 downto 0):=(others=>'0');
   signal addr_wr_inc_s          : unsigned(G_ADDR_LENGTH-1 downto 0):=(others=>'0');
   signal addr_wr_gray_r         : unsigned(G_ADDR_LENGTH-1 downto 0):=(others=>'0');
   signal addr_wr_gray_sync_r    : unsigned(G_ADDR_LENGTH-1 downto 0):=(others=>'0');
   signal addr_wr_gray_sync_rr   : unsigned(G_ADDR_LENGTH-1 downto 0):=(others=>'0');
   signal addr_wr_sync_r         : unsigned(G_ADDR_LENGTH-1 downto 0):=(others=>'0');

   signal ptr_rd_s               : std_logic_vector(G_ADDR_LENGTH-1 downto 0):=(others=>'0');
   signal addr_rd_r              : unsigned(G_ADDR_LENGTH-1 downto 0):=(others=>'0');
   signal addr_rd_inc_s          : unsigned(G_ADDR_LENGTH-1 downto 0):=(others=>'0');
   signal addr_rd_gray_r         : unsigned(G_ADDR_LENGTH-1 downto 0):=(others=>'0');
   signal addr_rd_gray_sync_r    : unsigned(G_ADDR_LENGTH-1 downto 0):=(others=>'0');
   signal addr_rd_gray_sync_rr   : unsigned(G_ADDR_LENGTH-1 downto 0):=(others=>'0');
   signal addr_rd_sync_r         : unsigned(G_ADDR_LENGTH-1 downto 0):=(others=>'0');

   signal ram_out_s              : std_logic_vector(G_DATA_LENGTH-1 downto 0):=(others=>'0');

   signal fifo_full_r            : std_logic:='0';
   signal fifo_full_n_r          : std_logic:='0';
   signal fifo_empty_r           : std_logic:='1';
   signal fifo_empty_n_r         : std_logic:='1';
   signal fifo_rd_s              : std_logic;

   signal fifo_wr_level_int_s    : unsigned(G_ADDR_LENGTH-1 downto 0):=(others=>'0');
   signal fifo_wr_level_s        : unsigned(G_ADDR_LENGTH downto 0):=(others=>'0');
   signal fifo_rd_level_int_s    : unsigned(G_ADDR_LENGTH-1 downto 0):=(others=>'0');
   signal fifo_rd_level_s        : unsigned(G_ADDR_LENGTH downto 0):=(others=>'0');

begin

---------------------------------------------------------------------------
-- RAM
---------------------------------------------------------------------------
   INST_RAM : RAM_DUAL_CLOCK
   generic map
   (
      G_ADDR_LENGTH => G_ADDR_LENGTH,
      G_DATA_LENGTH => G_DATA_LENGTH
   )
   port map
   (
      CLK_WR  => CLK_WR,
      WR_ADDR => ptr_wr_s,
      DIN     => DATA_IN,
      WE      => wr_en_s,
      CLK_RD  => CLK_RD,
      RD_ADDR => ptr_rd_s,
      DOUT    => ram_out_s
   );

---------------------------------------------------------------------------
-- RD/WR POINTERS MANAGEMENT
---------------------------------------------------------------------------

   ------------------------------------------------------------------------
   -- COMBINATORIAL
   -- Description : commands write enable
   ------------------------------------------------------------------------
   wr_en_s <= WR and not fifo_full_r;

   ------------------------------------------------------------------------
   -- COMBINATORIAL
   -- Description : increment address
   ------------------------------------------------------------------------
   addr_wr_inc_s <= addr_wr_r + 1;
   addr_rd_inc_s <= addr_rd_r + 1;

   ------------------------------------------------------------------------
   -- COMBINATORIAL
   -- Description :
   ------------------------------------------------------------------------
   ptr_wr_s <= std_logic_vector(addr_wr_r);
   ptr_rd_s <= std_logic_vector(addr_rd_r);

   ------------------------------------------------------------------------
   -- PROCESS : P_ADDR_WR
   -- Description : address write increment
   ------------------------------------------------------------------------
   P_ADDR_WR : process(CLK_WR, RESET_N)
   begin
      if RESET_N = '0' then
         addr_wr_r <= (others => '0');
      elsif rising_edge(CLK_WR) then
         if wr_en_s = '1' then
            addr_wr_r <= addr_wr_inc_s;
         end if;
      end if;
   end process P_ADDR_WR;

   ------------------------------------------------------------------------
   -- PROCESS : P_ADDR_WR_GRAY
   -- Description : transform write address into gray code
   ------------------------------------------------------------------------
   P_ADDR_WR_GRAY : process(CLK_WR, RESET_N)
   begin
      if RESET_N = '0' then
         addr_wr_gray_r <= (others => '0');
      elsif rising_edge(CLK_WR) then
         addr_wr_gray_r <= binary_to_gray_code(addr_wr_r);
      end if;
   end process P_ADDR_WR_GRAY;

   ------------------------------------------------------------------------
   -- PROCESS : P_ADDR_WR_GRAY_SYNC
   -- Description : double resynchronization into read clock domain
   ------------------------------------------------------------------------
   P_ADDR_WR_GRAY_SYNC : process(CLK_RD, RESET_N)
   begin
      if RESET_N = '0' then
         addr_wr_gray_sync_r  <= (others => '0');
         addr_wr_gray_sync_rr <= (others => '0');
      elsif rising_edge(CLK_RD) then
         addr_wr_gray_sync_r  <= addr_wr_gray_r;
         addr_wr_gray_sync_rr <= addr_wr_gray_sync_r;
      end if;
   end process P_ADDR_WR_GRAY_SYNC;

   ------------------------------------------------------------------------
   -- PROCESS : P_ADDR_WR_SYNC
   -- Description : write address into read clock domain
   ------------------------------------------------------------------------
   P_ADDR_WR_SYNC : process(CLK_RD, RESET_N)
   begin
      if RESET_N = '0' then
         addr_wr_sync_r  <= (others => '0');
      elsif rising_edge(CLK_RD) then
         addr_wr_sync_r  <= gray_to_binary_code(addr_wr_gray_sync_rr);
      end if;
   end process P_ADDR_WR_SYNC;

   ------------------------------------------------------------------------
   -- PROCESS : P_ADDR_RD
   -- Description : address read increment
   ------------------------------------------------------------------------
   P_ADDR_RD : process(CLK_RD, RESET_N)
   begin
      if RESET_N = '0' then
         addr_rd_r     <= (others => '0');
      elsif rising_edge(CLK_RD) then
         if fifo_rd_s = '1' then
            addr_rd_r <= addr_rd_inc_s;
         end if;
      end if;
   end process P_ADDR_RD;

   ------------------------------------------------------------------------
   -- PROCESS : P_ADDR_RD_GRAY
   -- Description : transform read address into gray code
   ------------------------------------------------------------------------
   P_ADDR_RD_GRAY : process(CLK_RD, RESET_N)
   begin
      if RESET_N = '0' then
         addr_rd_gray_r <= (others => '0');
      elsif rising_edge(CLK_RD) then
         addr_rd_gray_r <= binary_to_gray_code(addr_rd_r);
      end if;
   end process P_ADDR_RD_GRAY;

   ------------------------------------------------------------------------
   -- PROCESS : P_ADDR_RD_GRAY_SYNC
   -- Description : double resynchronization into write clock domain
   ------------------------------------------------------------------------
   P_ADDR_RD_GRAY_SYNC : process(CLK_WR, RESET_N)
   begin
      if RESET_N = '0' then
         addr_rd_gray_sync_r  <= (others => '0');
         addr_rd_gray_sync_rr <= (others => '0');
      elsif rising_edge(CLK_WR) then
         addr_rd_gray_sync_r  <= addr_rd_gray_r;
         addr_rd_gray_sync_rr <= addr_rd_gray_sync_r;
      end if;
   end process P_ADDR_RD_GRAY_SYNC;

   ------------------------------------------------------------------------
   -- PROCESS : P_ADDR_RD_SYNC
   -- Description : read address into write clock domain
   ------------------------------------------------------------------------
   P_ADDR_RD_SYNC : process(CLK_WR, RESET_N)
   begin
      if RESET_N = '0' then
         addr_rd_sync_r  <= (others => '0');
      elsif rising_edge(CLK_WR) then
         addr_rd_sync_r  <= gray_to_binary_code(addr_rd_gray_sync_rr);
      end if;
   end process P_ADDR_RD_SYNC;

   ------------------------------------------------------------------------
   -- COMBINATORIAL
   -- Description :
   ------------------------------------------------------------------------
   fifo_wr_level_int_s <= unsigned(addr_wr_r)-unsigned(addr_rd_sync_r);
   fifo_wr_level_s     <= fifo_full_r & fifo_wr_level_int_s;

   fifo_rd_level_int_s <= unsigned(addr_wr_sync_r)-unsigned(addr_rd_r);
   fifo_rd_level_s     <= '1' & fifo_rd_level_int_s when fifo_rd_level_int_s = 0 and fifo_empty_r = '0' else '0' & fifo_rd_level_int_s;

---------------------------------------------------------------------------
-- STATUS MANAGEMENT
---------------------------------------------------------------------------

   ------------------------------------------------------------------------
   -- PROCESS : P_FIFO_FULL
   -- Description :
   ------------------------------------------------------------------------
   P_FIFO_FULL : process(CLK_WR, RESET_N)
   begin
      if RESET_N = '0' then
         fifo_full_r   <= '0';
         fifo_full_n_r <= '1';
      elsif rising_edge(CLK_WR) then
         if addr_wr_inc_s = addr_rd_sync_r and wr_en_s = '1' then
            fifo_full_r   <= '1';
            fifo_full_n_r <= '0';
         elsif addr_wr_r /= addr_rd_sync_r then
            fifo_full_r   <= '0';
            fifo_full_n_r <= '1';
         end if;
      end if;
   end process P_FIFO_FULL;

   ------------------------------------------------------------------------
   -- PROCESS : P_FIFO_EMPTY
   -- Description :
   ------------------------------------------------------------------------
   P_FIFO_EMPTY : process(CLK_RD, RESET_N)
   begin
      if RESET_N = '0' then
         fifo_empty_r   <= '1';
         fifo_empty_n_r <= '0';
      elsif rising_edge(CLK_RD) then
         if addr_rd_inc_s = addr_wr_sync_r and RD = '1' then
            fifo_empty_r   <= '1';
            fifo_empty_n_r <= '0';
         elsif addr_rd_r /= addr_wr_sync_r then
            fifo_empty_r   <= '0';
            fifo_empty_n_r <= '1';
         end if;
      end if;
   end process P_FIFO_EMPTY;

---------------------------------------------------------------------------
-- BUFF OUT
---------------------------------------------------------------------------

   fifo_rd_s      <= RD and not fifo_empty_r;
   EMPTY          <= fifo_empty_r;
   EMPTY_N        <= fifo_empty_n_r;
   DATA_OUT       <= ram_out_s;

   ------------------------------------------------------------------------
   -- PROCESS : P_ALMOST_EMPTY
   -- Description :
   ------------------------------------------------------------------------
   P_ALMOST_EMPTY : process(CLK_RD, RESET_N)
   begin
      if RESET_N = '0' then
         ALMOST_EMPTY   <= '1';
         ALMOST_EMPTY_N <= '0';
      elsif rising_edge(CLK_RD) then
         if fifo_rd_level_s = unsigned(THRESHOLD_LOW)+1 and fifo_rd_s = '1' then
            ALMOST_EMPTY   <= '1';
            ALMOST_EMPTY_N <= '0';
         elsif fifo_rd_level_s > unsigned(THRESHOLD_LOW) and fifo_empty_n_r = '1' then
            ALMOST_EMPTY   <= '0';
            ALMOST_EMPTY_N <= '1';
         end if;
      end if;
   end process P_ALMOST_EMPTY;

   FULL   <= fifo_full_r;
   FULL_N <= fifo_full_n_r;


   ------------------------------------------------------------------------
   -- PROCESS : P_ALMOST_FULL
   -- Description :
   ------------------------------------------------------------------------
   P_ALMOST_FULL : process(CLK_WR, RESET_N)
   begin
      if RESET_N = '0' then
         ALMOST_FULL   <= '0';
         ALMOST_FULL_N <= '1';
      elsif rising_edge(CLK_WR) then
         if fifo_wr_level_s = unsigned(THRESHOLD_HIGH)-1 and wr_en_s = '1' then
            ALMOST_FULL   <= '1';
            ALMOST_FULL_N <= '0';
         elsif fifo_wr_level_s < unsigned(THRESHOLD_HIGH) then
            ALMOST_FULL   <= '0';
            ALMOST_FULL_N <= '1';
         end if;
      end if;
   end process P_ALMOST_FULL;
   -------------------------------------------------------------------------------------------------


end architecture ARCH_FIFO_DC;
