--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
--Date        : Sun Nov 15 20:24:51 2026
--Host        : LAPTOP-I3ECBFK4 running 64-bit major release  (build 9200)
--Command     : generate_target kv260_video_wrapper.bd
--Design      : kv260_video_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity kv260_video_wrapper is
  port (
    gpio_tri_o : out STD_LOGIC_VECTOR ( 2 downto 0 );
    iic_scl_io : inout STD_LOGIC;
    iic_sda_io : inout STD_LOGIC;
    mipi_phy_if_clk_n : in STD_LOGIC;
    mipi_phy_if_clk_p : in STD_LOGIC;
    mipi_phy_if_data_n : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mipi_phy_if_data_p : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mipi_rx_ias_clk_n : in STD_LOGIC;
    mipi_rx_ias_clk_p : in STD_LOGIC;
    mipi_rx_ias_data_n : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mipi_rx_ias_data_p : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
end kv260_video_wrapper;

architecture STRUCTURE of kv260_video_wrapper is
  component kv260_video is
  port (
    gpio_tri_o : out STD_LOGIC_VECTOR ( 2 downto 0 );
    mipi_phy_if_clk_n : in STD_LOGIC;
    mipi_phy_if_clk_p : in STD_LOGIC;
    mipi_phy_if_data_n : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mipi_phy_if_data_p : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mipi_rx_ias_clk_n : in STD_LOGIC;
    mipi_rx_ias_clk_p : in STD_LOGIC;
    mipi_rx_ias_data_n : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mipi_rx_ias_data_p : in STD_LOGIC_VECTOR ( 3 downto 0 );
    iic_scl_i : in STD_LOGIC;
    iic_scl_o : out STD_LOGIC;
    iic_scl_t : out STD_LOGIC;
    iic_sda_i : in STD_LOGIC;
    iic_sda_o : out STD_LOGIC;
    iic_sda_t : out STD_LOGIC
  );
  end component kv260_video;
  component IOBUF is
  port (
    I : in STD_LOGIC;
    O : out STD_LOGIC;
    T : in STD_LOGIC;
    IO : inout STD_LOGIC
  );
  end component IOBUF;
  signal iic_scl_i : STD_LOGIC;
  signal iic_scl_o : STD_LOGIC;
  signal iic_scl_t : STD_LOGIC;
  signal iic_sda_i : STD_LOGIC;
  signal iic_sda_o : STD_LOGIC;
  signal iic_sda_t : STD_LOGIC;
begin
iic_scl_iobuf: component IOBUF
     port map (
      I => iic_scl_o,
      IO => iic_scl_io,
      O => iic_scl_i,
      T => iic_scl_t
    );
iic_sda_iobuf: component IOBUF
     port map (
      I => iic_sda_o,
      IO => iic_sda_io,
      O => iic_sda_i,
      T => iic_sda_t
    );
kv260_video_i: component kv260_video
     port map (
      gpio_tri_o(2 downto 0) => gpio_tri_o(2 downto 0),
      iic_scl_i => iic_scl_i,
      iic_scl_o => iic_scl_o,
      iic_scl_t => iic_scl_t,
      iic_sda_i => iic_sda_i,
      iic_sda_o => iic_sda_o,
      iic_sda_t => iic_sda_t,
      mipi_phy_if_clk_n => mipi_phy_if_clk_n,
      mipi_phy_if_clk_p => mipi_phy_if_clk_p,
      mipi_phy_if_data_n(1 downto 0) => mipi_phy_if_data_n(1 downto 0),
      mipi_phy_if_data_p(1 downto 0) => mipi_phy_if_data_p(1 downto 0),
      mipi_rx_ias_clk_n => mipi_rx_ias_clk_n,
      mipi_rx_ias_clk_p => mipi_rx_ias_clk_p,
      mipi_rx_ias_data_n(3 downto 0) => mipi_rx_ias_data_n(3 downto 0),
      mipi_rx_ias_data_p(3 downto 0) => mipi_rx_ias_data_p(3 downto 0)
    );
end STRUCTURE;
