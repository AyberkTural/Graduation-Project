library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top is
    generic (
        c_clkfreq   : integer := 100_000_000;
        c_baudrate  : integer := 57600;
        c_stopbit   : integer := 2
    );
    port (
        clock       : in std_logic;
        btnu_i      : in std_logic;
        btnd_i      : in std_logic;
        btnr_i      : in std_logic;
        btnl_i      : in std_logic;
        tx_o        : out std_logic
    );
end top;

architecture Behavioral of top is
    component debounce is
        generic (
            c_clkfreq   : integer := 100_000_000;
            c_debtime   : integer := 1000;
            c_initval   : std_logic := '0'
        );
        port (
            clk         : in std_logic;
            signal_i    : in std_logic;
            signal_o    : out std_logic
        );
    end component;

    component uart_tx is
        generic (
            c_clkfreq   : integer := 100_000_000;
            c_baudrate  : integer := 57600;
            c_stopbit   : integer := 2
        );
        port (
            clk             : in std_logic;
            din_i           : in std_logic_vector (7 downto 0);
            tx_start_i      : in std_logic;
            tx_o            : out std_logic;
            tx_done_tick_o  : out std_logic
        );
    end component;

    signal btnu_deb          : std_logic := '0';
    signal btnu_deb_next     : std_logic := '0';
    signal btnd_deb          : std_logic := '0';
    signal btnd_deb_next     : std_logic := '0';
    signal btnr_deb          : std_logic := '0';
    signal btnr_deb_next     : std_logic := '0';
    signal btnl_deb          : std_logic := '0';
    signal btnl_deb_next     : std_logic := '0';
    signal tx_start          : std_logic := '0';
    signal tx_done_tick      : std_logic := '0';
    signal data              : std_logic_vector (7 downto 0) := (others => '0');
    signal prescaler         : std_logic_vector(16 downto 0) := "11000011010100000";
    signal prescaler_counter : std_logic_vector(16 downto 0) := (others => '0');
    signal counter           : std_logic_vector(1 downto 0) := (others => '0');

begin

    i_btnu : debounce
        generic map (
            c_clkfreq   => c_clkfreq,
            c_debtime   => 1000,
            c_initval   => '0'
        )
        port map (
            clk         => clock,
            signal_i    => btnu_i,
            signal_o    => btnu_deb
        );

    i_btnd : debounce
        generic map (
            c_clkfreq   => c_clkfreq,
            c_debtime   => 1000,
            c_initval   => '0'
        )
        port map (
            clk         => clock,
            signal_i    => btnd_i,
            signal_o    => btnd_deb
        );

    i_btnr : debounce
        generic map (
            c_clkfreq   => c_clkfreq,
            c_debtime   => 1000,
            c_initval   => '0'
        )
        port map (
            clk         => clock,
            signal_i    => btnr_i,
            signal_o    => btnr_deb
        );

    i_btnl : debounce
        generic map (
            c_clkfreq   => c_clkfreq,
            c_debtime   => 1000,
            c_initval   => '0'
        )
        port map (
            clk         => clock,
            signal_i    => btnl_i,
            signal_o    => btnl_deb
        );

    i_uart_tx : uart_tx
        generic map (
            c_clkfreq   => c_clkfreq,
            c_baudrate  => c_baudrate,
            c_stopbit   => c_stopbit
        )
        port map (
            clk             => clock,
            din_i           => data,
            tx_start_i      => tx_start,
            tx_o            => tx_o,
            tx_done_tick_o  => tx_done_tick
        );

    process (clock) begin
        if rising_edge(clock) then
            prescaler_counter <= prescaler_counter + 1;
            if prescaler_counter = prescaler then
                counter <= counter + 1;
                prescaler_counter <= (others => '0');
            end if;

            case counter is
                when "00" =>
                    if btnu_i = '1' then
                        btnu_deb_next <= btnu_deb;
                        btnu_deb <= '1';
                        tx_start <= '1';
                        data <= "00000001";
                    elsif btnu_i = '0' then
                        btnu_deb <= '0';
                        tx_start <= '0';
                    end if;
                when "01" =>
                    if btnd_i = '1' then
                        btnd_deb_next <= btnd_deb;
                        btnd_deb <= '1';
                        tx_start <= '1';
                        data <= "00000010";
                    elsif btnd_i = '0' then
                        btnd_deb <= '0';
                        tx_start <= '0';
                    end if;
                when "11" =>
                    if btnr_i = '1' then
                        btnr_deb_next <= btnr_deb;
                        btnr_deb <= '1';
                        tx_start <= '1';
                        data <= "00000011";
                    elsif btnr_i = '0' then
                        btnr_deb <= '0';
                        tx_start <= '0';
                    end if;
                when "10" =>
                    if btnl_i = '1' then
                        btnl_deb_next <= btnl_deb;
                        btnl_deb <= '1';
                        tx_start <= '1';
                        data <= "00000100";
                    elsif btnl_i = '0' then
                        btnl_deb <= '0';
                        tx_start <= '0';
                    end if;
                when others =>
                    null;
            end case;
        end if;
    end process;

end Behavioral;
