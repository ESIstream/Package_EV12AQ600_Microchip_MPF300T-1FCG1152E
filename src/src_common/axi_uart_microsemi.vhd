--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: axi_uart_microsemi.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::PolarFire> <Die::MPF300TS> <Package::FCG1152>
-- Author: <Name>
--
--------------------------------------------------------------------------------



library IEEE;

use IEEE.std_logic_1164.all;

entity axi_uart_microsemi is
port (
    s_axi_aclk    : in std_logic;
    s_axi_aresetn : in std_logic;
    interrupt     : out std_logic;
    s_axi_awaddr  : in std_logic_vector(3 downto 0);
    s_axi_awvalid : in std_logic;
    s_axi_awready : out std_logic;
    s_axi_wdata   : in std_logic_vector(31 downto 0);
    s_axi_wstrb   : in std_logic_vector(3 downto 0);
    s_axi_wvalid  : in std_logic;
    s_axi_wready  : out std_logic;
    s_axi_bresp   : out std_logic_vector(1 downto 0);
    s_axi_bvalid  : out std_logic;
    s_axi_bready  : in std_logic;
    s_axi_araddr  : in std_logic_vector(3 downto 0);
    s_axi_arvalid : in std_logic;
    s_axi_arready : out std_logic;
    s_axi_rdata   : out std_logic_vector(31 downto 0);
    s_axi_rresp   : out std_logic_vector(1 downto 0);
    s_axi_rvalid  : out std_logic;
    s_axi_rready  : in std_logic;
    rx            : in std_logic;
    tx            : out std_logic
);
end axi_uart_microsemi;

architecture arch_imp of axi_uart_microsemi is

        -- Width of S_AXI data bus
    constant C_S_AXI_DATA_WIDTH    : integer    := 32;
        -- Width of S_AXI address bus
    constant C_S_AXI_ADDR_WIDTH    : integer    := 4;

    constant C_BAUD_VAL : std_logic_vector := '0' & x"035"; --53 decimal

    -- AXI4LITE signals
    signal axi_awaddr   : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal axi_awready  : std_logic;
    signal axi_wready   : std_logic;
    signal axi_bresp    : std_logic_vector(1 downto 0);
    signal axi_bvalid   : std_logic;
    signal axi_araddr   : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal axi_arready  : std_logic;
    signal axi_rdata    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal axi_rresp    : std_logic_vector(1 downto 0);
    signal axi_rvalid   : std_logic;

    -- Example-specific design signals
    -- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
    -- ADDR_LSB is used for addressing 32/64 bit registers/memories
    -- ADDR_LSB = 2 for 32 bits (n downto 2)
    -- ADDR_LSB = 3 for 64 bits (n downto 3)
    constant ADDR_LSB          : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
    constant OPT_MEM_ADDR_BITS : integer := 1;
    ------------------------------------------------
    ---- Signals for user logic register space example
    --------------------------------------------------
    ---- Number of Slave Registers 4
    signal slv_reg0        : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg1        : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg2        : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg3        : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg_rden    : std_logic;
    signal slv_reg_wren    : std_logic;
    signal reg_data_out    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal byte_index      : integer;
    signal aw_en           : std_logic;
    signal clr_Status      : std_logic;

    --Uart core signal
    signal csn                    : std_logic;
    signal rde_n                  : std_logic;
    signal tx_Buffer_Empty        : std_logic;
    signal rx_Buffer_NotEmpty     : std_logic;
    signal tx_Buffer_Empty_Pre    : std_logic;
    signal rx_Buffer_NotEmpty_Pre : std_logic;
    signal tx_Buffer_Full         : std_logic;
    signal tx_fifo_we_n           : std_logic;
    signal rx_Frame_Error         : std_logic;
    signal rx_Overrun_Error       : std_logic;
    signal rx_fifo_dout           : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

    --

--------------------------------------------------------------------------------
-- Code start here
--------------------------------------------------------------------------------
begin
    --------------------------------------------------------------------------------
    -- I/O Connections assignments
    --------------------------------------------------------------------------------
    S_AXI_AWREADY   <= axi_awready;
    S_AXI_WREADY    <= axi_wready;
    S_AXI_BRESP     <= axi_bresp;
    S_AXI_BVALID    <= axi_bvalid;
    S_AXI_ARREADY   <= axi_arready;
    S_AXI_RDATA     <= axi_rdata;
    S_AXI_RRESP     <= axi_rresp;
    S_AXI_RVALID    <= axi_rvalid;
    rx_fifo_dout(31 downto 8)    <= x"000000";
    -- Implement axi_awready generation
    -- axi_awready is asserted for one s_axi_aclk clock cycle when both
    -- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
    -- de-asserted when reset is low.

    process (s_axi_aclk)
    begin
      if rising_edge(s_axi_aclk) then 
        if s_axi_aresetn = '0' then
          axi_awready <= '0';
          aw_en <= '1';
        else
          if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
            -- slave is ready to accept write address when
            -- there is a valid write address and write data
            -- on the write address and data bus. This design 
            -- expects no outstanding transactions. 
               axi_awready <= '1';
               aw_en <= '0';
            elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then
               aw_en <= '1';
               axi_awready <= '0';
          else
            axi_awready <= '0';
          end if;
        end if;
      end if;
    end process;

    -- Implement axi_awaddr latching
    -- This process is used to latch the address when both 
    -- S_AXI_AWVALID and S_AXI_WVALID are valid. 

    process (s_axi_aclk)
    begin
      if rising_edge(s_axi_aclk) then 
        if s_axi_aresetn = '0' then
          axi_awaddr <= (others => '0');
        else
          if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
            -- Write Address latching
            axi_awaddr <= S_AXI_AWADDR;
          end if;
        end if;
      end if;                   
    end process; 

    -- Implement axi_wready generation
    -- axi_wready is asserted for one s_axi_aclk clock cycle when both
    -- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
    -- de-asserted when reset is low. 

    process (s_axi_aclk)
    begin
      if rising_edge(s_axi_aclk) then 
        if s_axi_aresetn = '0' then
          axi_wready <= '0';
        else
          if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1' and aw_en = '1') then
              -- slave is ready to accept write data when 
              -- there is a valid write address and write data
              -- on the write address and data bus. This design 
              -- expects no outstanding transactions.           
              axi_wready <= '1';
          else
            axi_wready <= '0';
          end if;
        end if;
      end if;
    end process; 

    -- Implement memory mapped register select and write logic generation
    -- The write data is accepted and written to memory mapped registers when
    -- axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
    -- select byte enables of slave registers while writing.
    -- These registers are cleared when reset (active low) is applied.
    -- Slave register write enable is asserted when valid address and data are available
    -- and the slave is ready to accept the write address and write data.
    slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;

    process (s_axi_aclk)
    variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
    begin
      if rising_edge(s_axi_aclk) then 
        if s_axi_aresetn = '0' then
          --slv_reg0 <= (others => '0');
          slv_reg1 <= (others => '0');
          --slv_reg2 <= (others => '0');
          slv_reg3 <= (others => '0');
          tx_fifo_we_n <= '1';
        else
          loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
          if (slv_reg_wren = '1') then
            case loc_addr is

              when b"00" => -- Rx Fifo Read only
                tx_fifo_we_n <= '1';

              when b"01" => --Tx Fifo
                tx_fifo_we_n <= '0';
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes                   
                    -- slave registor 1
                    slv_reg1(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"10" => --Status Reg
                tx_fifo_we_n <= '1';
      
              when b"11" =>
                tx_fifo_we_n <= '1';
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    -- Respective byte enables are asserted as per write strobes                   
                    -- slave registor 3
                    slv_reg3(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when others =>
                tx_fifo_we_n <= '1';
                --slv_reg0 <= slv_reg0;
                slv_reg1 <= slv_reg1;
                --slv_reg2 <= slv_reg2;
                slv_reg3 <= slv_reg3;
            end case;
            else
              tx_fifo_we_n <= '1';
          end if;
        end if;
      end if;                   
    end process; 

    -- Implement write response logic generation
    -- The write response and response valid signals are asserted by the slave 
    -- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
    -- This marks the acceptance of address and indicates the status of 
    -- write transaction.

    process (s_axi_aclk)
    begin
      if rising_edge(s_axi_aclk) then 
        if s_axi_aresetn = '0' then
          axi_bvalid  <= '0';
          axi_bresp   <= "00"; --need to work more on the responses
        else
          if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
            axi_bvalid <= '1';
            axi_bresp  <= "00"; 
          elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
            axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
          end if;
        end if;
      end if;                   
    end process; 

    -- Implement axi_arready generation
    -- axi_arready is asserted for one s_axi_aclk clock cycle when
    -- S_AXI_ARVALID is asserted. axi_awready is 
    -- de-asserted when reset (active low) is asserted. 
    -- The read address is also latched when S_AXI_ARVALID is 
    -- asserted. axi_araddr is reset to zero on reset assertion.

    process (s_axi_aclk)
    begin
      if rising_edge(s_axi_aclk) then 
        if s_axi_aresetn = '0' then
          axi_arready <= '0';
          axi_araddr  <= (others => '1');
        else
          if (axi_arready = '0' and S_AXI_ARVALID = '1') then
            -- indicates that the slave has acceped the valid read address
            axi_arready <= '1';
            -- Read Address latching 
            axi_araddr  <= S_AXI_ARADDR;           
          else
            axi_arready <= '0';
          end if;
        end if;
      end if;                   
    end process; 

    -- Implement axi_arvalid generation
    -- axi_rvalid is asserted for one s_axi_aclk clock cycle when both 
    -- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
    -- data are available on the axi_rdata bus at this instance. The 
    -- assertion of axi_rvalid marks the validity of read data on the 
    -- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
    -- is deasserted on reset (active low). axi_rresp and axi_rdata are 
    -- cleared to zero on reset (active low).  
    process (s_axi_aclk)
    begin
      if rising_edge(s_axi_aclk) then
        if s_axi_aresetn = '0' then
          axi_rvalid <= '0';
          axi_rresp  <= "00";
        else
          if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
            -- Valid read data is available at the read data bus
            axi_rvalid <= '1';
            axi_rresp  <= "00"; -- 'OKAY' response
          elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
            -- Read data is accepted by the master
            axi_rvalid <= '0';
          end if;            
        end if;
      end if;
    end process;

    -- Implement memory mapped register select and read logic generation
    -- Slave register read enable is asserted when valid address is available
    -- and the slave is ready to accept the read address.
    slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;

    process (slv_reg0, slv_reg1, slv_reg2, slv_reg3, axi_araddr, s_axi_aresetn, slv_reg_rden)
    variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
    begin
        -- Address decoding for reading registers
        loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
        case loc_addr is
          when b"00" =>
            reg_data_out <= slv_reg0; --Rx FIFO
          when b"01" =>
            reg_data_out <= slv_reg1; --TX FIFO
          when b"10" =>
            reg_data_out <= slv_reg2; --UART Lite status register
          when b"11" =>
            reg_data_out <= slv_reg3; --UART Lite control register
          when others =>
            reg_data_out  <= (others => '0');
        end case;
    end process; 

    -- Output register or memory read data
    process( s_axi_aclk ) is
    begin
      if (rising_edge (s_axi_aclk)) then
        if ( s_axi_aresetn = '0' ) then
          axi_rdata  <= (others => '0');
        else
          if (slv_reg_rden = '1') then
            -- When there is a valid read address (S_AXI_ARVALID) with 
            -- acceptance of read address by the slave (axi_arready), 
            -- output the read dada 
            -- Read address mux
              axi_rdata <= reg_data_out;     -- register read data
          end if;   
        end if;
      end if;
    end process;

    ----------------------------------------------------------------------------
    -- Uart logic
    ----------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    -- uart_fifo chip_select
    --------------------------------------------------------------------------------
    --CS_FIFO_RW_DFF: Process (s_axi_aclk) is
    --begin
    --    if (s_axi_aclk'event and s_axi_aclk = '1') then -- rising clock edge
    --        if s_axi_aresetn = '0' then               -- Synchronous reset (active low)
    --            csn <= '1';
    --        else
    --            csn <= not(slv_reg_rden) or tx_fifo_we_n; --always active for developement only
    --        end if;
    --    end if;
    --end process CS_FIFO_RW_DFF;

    --------------------------------------------------------------------------------
    -- Status Reg write
    --------------------------------------------------------------------------------
    -------------------------------------------------------------------------
    -- Process to register rx_Overrun_Error
    -------------------------------------------------------------------------
    RX_OVERRUN_ERROR_DFF: Process (s_axi_aclk) is
    begin
        if (s_axi_aclk'event and s_axi_aclk = '1') then
            if ((s_axi_aresetn = '0') or (clr_Status = '1')) then
                slv_reg2(2) <= '0';
            elsif (rx_Overrun_Error = '1') then
                slv_reg2(2) <= '1';
            end if;
        end if;
    end process RX_OVERRUN_ERROR_DFF;

    -------------------------------------------------------------------------
    -- Process to register rx_Frame_Error
    -------------------------------------------------------------------------
    RX_FRAME_ERROR_DFF: Process (s_axi_aclk) is
    begin
        if (s_axi_aclk'event and s_axi_aclk = '1') then
            if (s_axi_aresetn = '0') then
                slv_reg2(1) <= '0';
            else
                if (clr_Status = '1') then
                    slv_reg2(1) <= '0';
                elsif (rx_Frame_Error = '1') then
                    slv_reg2(1) <= '1';
                end if;
            end if;
        end if;
    end process RX_FRAME_ERROR_DFF;




    --------------------------------------------------------------------------------
    -- UART CORE control
    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    -- uart_fifo chip_select
    --------------------------------------------------------------------------------
    RX_FIFO_R_DFF: Process (s_axi_aclk) is
    begin
        if (s_axi_aclk'event and s_axi_aclk = '1') then -- rising clock edge
            if s_axi_aresetn = '0' then               -- Synchronous reset (active low)
                rde_n <= '1';
                csn   <= '1';
            else
                rde_n <= not(slv_reg_rden) and rx_Buffer_NotEmpty; --always active for developement only
                csn   <= not(slv_reg_rden) and rx_Buffer_NotEmpty; 
            end if;
        end if;
    end process RX_FIFO_R_DFF;

    --------------------------------------------------------------------------------
    -- rx_fifo_read
    --------------------------------------------------------------------------------
    RX_FIFO_READ_DFF: Process (s_axi_aclk) is
    begin
        if (s_axi_aclk'event and s_axi_aclk = '1') then -- rising clock edge
            if s_axi_aresetn = '0' then               -- Synchronous reset (active low)
                slv_reg0 <= (others => '0');
            else
               if (csn = '0' and rde_n= '0') then -- Chip enables for the write
                   slv_reg0(7 downto 0) <= rx_fifo_dout(7 downto 0);
               end if;
            end if;
        end if;
    end process RX_FIFO_READ_DFF;

    -------------------------------------------------------------------------
    -- Tx Fifo Interrupt handling
    -------------------------------------------------------------------------
    TX_BUFFER_EMPTY_DFF_I: Process (s_axi_aclk) is
    begin
        if (s_axi_aclk'event and s_axi_aclk = '1') then -- rising clock edge
            if s_axi_aresetn = '0' then               -- Synchronous reset (active low)
                tx_Buffer_Empty_Pre <= '0';
            else
               --if (csn = '0') and (tx_fifo_we_n = '0') then -- Chip enables for the write
                --   tx_Buffer_Empty_Pre <= '0';
               --else
                   tx_Buffer_Empty_Pre <= tx_Buffer_Empty;
               --end if;
            end if;
        end if;
    end process TX_BUFFER_EMPTY_DFF_I;
    
    -------------------------------------------------------------------------
    -- Rx Fifo Interrupt handling
    -------------------------------------------------------------------------
    RX_BUFFER_DATA_DFF_I: Process (s_axi_aclk) is
    begin
         if (s_axi_aclk'event and s_axi_aclk = '1') then -- rising clock edge
             if s_axi_aresetn = '0' then                 -- synchronous reset (active low)
                rx_Buffer_NotEmpty_Pre <= '0';
             else
                --if (csn = '0') and (rde_n = '0') then -- Chip enables for the read is active
                --    rx_Buffer_NotEmpty_Pre <= '0';
               -- else
                    rx_Buffer_NotEmpty_Pre <= rx_Buffer_NotEmpty;
               -- end if;
             end if;
          end if;
    end process RX_BUFFER_DATA_DFF_I;

    -------------------------------------------------------------------------
    -- Interrupt register handling
    -------------------------------------------------------------------------
    INTERRUPT_DFF: process (s_axi_aclk) is
    begin 
        if s_axi_aclk'event and s_axi_aclk = '1' then
            if s_axi_aresetn = '0' then         -- synchronous reset (active low)
                Interrupt <= '0';
            else 
                Interrupt <= (rx_Buffer_NotEmpty and not rx_Buffer_NotEmpty_Pre) or (tx_Buffer_Empty and not tx_Buffer_Empty_Pre);
            end if;
        end if;
    end process INTERRUPT_DFF;

    --tx_Buffer_Empty <= TXRDY and tx_fifo_we_n; -- when tx is ready and a write data happen


    -------------------------------------------------------------------------
    -- Status register handling
    -------------------------------------------------------------------------
    slv_reg2(7) <= rx_Buffer_NotEmpty;
    slv_reg2(6) <= '0'; --rx_Buffer_Full
    slv_reg2(5) <= tx_Buffer_Empty;
    slv_reg2(4) <= tx_Buffer_Full;
    slv_reg2(3) <= '1';

  

    --------------------------------------------------------------------------------
    -- Component instanciation
    --------------------------------------------------------------------------------
    COREUART_C0_1 : entity work.COREUART_C0
        port map (
            BAUD_VAL        => C_BAUD_VAL,               --x"053" = 100 000 000 / (115200*16) - 1
            BIT8            => '1',                      --BIT8 is logic 1, the data width is 8 bits; otherwise, the data width is 7 bits
            CLK             => s_axi_aclk,
            CSN             => csn,   
            DATA_IN         => slv_reg1(7 downto 0),     --FIFO TX DATA IN
            ODD_N_EVEN      => '0',
            OEN             => rde_n,                     --Active low read enable
            PARITY_EN       => '0',                       --Parity is enabled when the bit is set to logic 1.
            RESET_N         => s_axi_aresetn,
            RX              => rx,
            WEN             => tx_fifo_we_n,
            --Output    
            DATA_OUT        => rx_fifo_dout(7 downto 0),   --FIFO RX DATA OUT
            FRAMING_ERR     => rx_Frame_Error,             --TODO TO Connect to status_reg trough process!!!!!
            OVERFLOW        => rx_Overrun_Error,           --TODO TO Connect to status_reg trough process!!!!!
            PARITY_ERR      => open,         
            RXRDY           => rx_Buffer_NotEmpty,
            TX              => tx,
            TXRDY           => tx_Buffer_Full,             --FIFOTX FULL
            TX_Buffer_Empty => TX_Buffer_Empty             --Ajout par rapport a IP original
        );
    -- User logic ends

end arch_imp;

