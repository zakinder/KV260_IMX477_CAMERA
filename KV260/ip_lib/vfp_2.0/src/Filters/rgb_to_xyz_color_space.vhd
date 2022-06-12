library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_package.all;
use work.vpf_records.all;
use work.ports_package.all;
entity rgb_to_xyz_color_space is
  generic (
    i_data_width    : integer := 8);
  port (
    clk             : in std_logic;
    reset           : in std_logic;
    iRgb            : in channel;
    oRgb            : out channel);
end rgb_to_xyz_color_space;
architecture behavioral of rgb_to_xyz_color_space is
    constant ROUND_RESULTWIDTH                 : natural := ROUND_RESULT_WIDTH;
    constant fullRange    : boolean := true;
    signal rgb_pixel      : uChannel;
    signal coeff          : w_3_by_3_pixels;
    signal coeff_prod     : w_3_by_3_pixels_28_width;
    signal red_rgbSum     : unsigned(31 downto 0);
    signal gre_rgbSum     : unsigned(31 downto 0);
    signal blu_rgbSum     : unsigned(31 downto 0);
    signal yCbCrRgb       : uChannel;
    signal yCbCr128       : unsigned(i_data_width-1 downto 0);
    signal yCbCr16        : unsigned(i_data_width-1 downto 0);
    signal rgb            : channel;
begin
    yCbCr128        <= shift_left(to_unsigned(one,i_data_width), i_data_width - 1);
    yCbCr16         <= shift_left(to_unsigned(one,i_data_width), i_data_width - 4);
    coeff.k1 <= x"FD70A3";--0.5    --C*(2^32)+0.5
    coeff.k2 <= x"000000";--0.25
    coeff.k3 <= x"000000"; -- to check the value convert 040000 into integer than divide the value to 2^20
    coeff.k4 <= x"000000"; --to convert the decimal value multiply by it to 2^20
    coeff.k5 <= x"FD70A3"; -- 0E6666 = 0.90
    coeff.k6 <= x"000000"; -- FD70A3 = 0.99
    coeff.k7 <= x"000000";
    coeff.k8 <= x"000000";
    coeff.k9 <= x"FD70A3";


process (clk) begin
    if rising_edge(clk) then
        rgb_pixel.red    <= unsigned(iRgb.red);
        rgb_pixel.green  <= unsigned(iRgb.green);
        rgb_pixel.blue   <= unsigned(iRgb.blue);
        rgb_pixel.valid  <= iRgb.valid;
    end if;
end process;
process (clk) begin
    if rising_edge(clk) then
        coeff_prod.k1    <= rgb_pixel.red * coeff.k1;
        coeff_prod.k2    <= rgb_pixel.green * coeff.k2;
        coeff_prod.k3    <= rgb_pixel.blue * coeff.k3;
        coeff_prod.k4    <= rgb_pixel.red * coeff.k4;
        coeff_prod.k5    <= rgb_pixel.green * coeff.k5;
        coeff_prod.k6    <= rgb_pixel.blue * coeff.k6;
        coeff_prod.k7    <= rgb_pixel.red * coeff.k7;
        coeff_prod.k8    <= rgb_pixel.green * coeff.k8;
        coeff_prod.k9    <= rgb_pixel.blue * coeff.k9;
    end if;
end process;


process (clk) begin
    if rising_edge(clk) then
        red_rgbSum  <= (coeff_prod.k1 + coeff_prod.k2 - coeff_prod.k3);
        gre_rgbSum  <= (coeff_prod.k5 - coeff_prod.k4 + coeff_prod.k6);
        blu_rgbSum  <= (coeff_prod.k9 - coeff_prod.k8 + coeff_prod.k7);
    end if;
end process;
process (clk)
    variable yRound      : unsigned(i_data_width-1 downto 0) :=(others => '0');
    variable cbRound     : unsigned(i_data_width-1 downto 0) :=(others => '0');
    variable crRound     : unsigned(i_data_width-1 downto 0) :=(others => '0');
    begin
    if rising_edge(clk) then
        if (red_rgbSum(ROUND_RESULT_WIDTH-1) = hi)  then
            if fullRange then
                yRound := yCbCr16 + 1;
            else
                yRound := to_unsigned(1, i_data_width);
            end if;
        else
            if fullRange then
                yRound := yCbCr16;
            else
                yRound := (others => '0');
            end if;
        end if;
        if (gre_rgbSum(0) = hi) then
            cbRound := resize(yCbCr128+1, i_data_width);
        else
            cbRound := yCbCr128;
        end if;
        if (blu_rgbSum(0) = hi) then
            crRound := resize(yCbCr128+1, i_data_width);
        else
            crRound := yCbCr128;
        end if;
        ---------------------------------------------------------------------------------------
        yCbCrRgb.red   <= (red_rgbSum(30 downto 23));
        yCbCrRgb.green <= (gre_rgbSum(30 downto 23));
        yCbCrRgb.blue  <= (blu_rgbSum(30 downto 23));
        ---------------------------------------------------------------------------------------
    end if;
end process;



process (clk) begin
    if rising_edge(clk) then
        rgb.red     <= std_logic_vector(yCbCrRgb.red);
        rgb.green   <= std_logic_vector(yCbCrRgb.green);
        rgb.blue    <= std_logic_vector(yCbCrRgb.blue);
        rgb.valid   <= iRgb.valid;
    end if;
end process;


yCbCr_valid_Inst: d_valid
generic map (
    pixelDelay   => 8)
port map(
    clk      => clk,
    iRgb     => rgb,
    oRgb     => oRgb);
end behavioral;