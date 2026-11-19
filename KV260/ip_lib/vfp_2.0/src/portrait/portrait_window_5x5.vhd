library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity portrait_window_5x5 is
    generic (
        MAX_IMG_WIDTH : integer := 4096
    );
    port (
        clk        : in std_logic;
        rst_n      : in std_logic;
        img_width : in unsigned(15 downto 0);
        s_valid    : in std_logic;
        s_rgb      : in std_logic_vector(23 downto 0);
        m_valid    : out std_logic;
        window_out : out std_logic_vector(599 downto 0)
    );
end entity portrait_window_5x5;

architecture rtl of portrait_window_5x5 is
    type line_ram_t is array (0 to MAX_IMG_WIDTH - 1) of std_logic_vector(23 downto 0);
    signal line0, line1, line2, line3 : line_ram_t := (others => (others => '0'));

    type win_t is array (0 to 4, 0 to 4) of std_logic_vector(23 downto 0);
    signal w : win_t := (others => (others => (others => '0')));

    signal col_cnt : integer range 0 to MAX_IMG_WIDTH - 1 := 0;
    signal row_cnt : integer range 0 to 8191 := 0;
    signal valid_d1 : std_logic := '0';
begin

    process(clk)
        variable d0, d1, d2, d3 : std_logic_vector(23 downto 0);
        variable w_limit          : integer;
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                 col_cnt <= 0;
                 row_cnt <= 0;
                 valid_d1 <= '0';
                 w        <= (others => (others => (others => '0')));
            else
                 valid_d1 <= '0';
                 w_limit := to_integer(img_width);

                if s_valid = '1' then
                    d0 := line0(col_cnt);
                    d1 := line1(col_cnt);
                    d2 := line2(col_cnt);
                    d3 := line3(col_cnt);

                    line0(col_cnt) <= s_rgb;
                    line1(col_cnt) <= d0;
                    line2(col_cnt) <= d1;
                    line3(col_cnt) <= d2;

                    for r in 0 to 4 loop
                          for c in 0 to 3 loop
                              w(r, c) <= w(r, c + 1);
                          end loop;
                      end loop;

                      w(0, 4) <= d3;
                      w(1, 4) <= d2;
                      w(2, 4) <= d1;
                      w(3, 4) <= d0;
                      w(4, 4) <= s_rgb;

                      if col_cnt = w_limit - 1 then
                           col_cnt <= 0;
                           if row_cnt < 3 then row_cnt <= row_cnt + 1; end if;
                      else
                           col_cnt <= col_cnt + 1;
                      end if;

                     if (row_cnt > 2) or (row_cnt = 2 and col_cnt >= 2) then
                         valid_d1 <= '1';
                     end if;
                 end if;
            end if;
        end if;
    end process;

    gen_pack_r : for r in 0 to 4 generate
        gen_pack_c : for c in 0 to 4 generate
            window_out(((r * 5 + c + 1) * 24) - 1 downto (r * 5 + c) * 24) <= w(r, c);
        end generate;
    end generate;

    m_valid <= valid_d1;

end architecture rtl;
