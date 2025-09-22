library ieee;
use ieee.std_logic_1164.all;

entity top is
	port (
		en : in std_logic; -- enable pulsing
		led_r : out std_logic; 
		led_g : out std_logic; 
		led_b : out std_logic 
	);
end entity top;

architecture rtl of top is

	component SB_HFOSC is
		generic (
			CLKHF_DIV : STRING := "0b00"
		);
		port (
			CLKHFEN : in STD_LOGIC;
			CLKHFPU : in STD_LOGIC;
			CLKHF : out STD_LOGIC
		);
	end component SB_HFOSC;

	component SB_RGBA_DRV is
		generic (
			CURRENT_MODE : string := "0b0"; -- "0b0" = half-current mode off (full-scale)
			RGB0_CURRENT : string := "0b111111"; -- 6-bit current code
			RGB1_CURRENT : string := "0b111111";
			RGB2_CURRENT : string := "0b111111"
		);
		port (
			CURREN : in std_logic;
			RGBLEDEN : in std_logic;
			RGB0PWM : in std_logic;
			RGB1PWM : in std_logic;
			RGB2PWM : in std_logic;
			RGB0 : out std_logic;
			RGB1 : out std_logic;
			RGB2 : out std_logic
		);
	end component SB_RGBA_DRV;

	signal clk_48mhz : std_logic;
begin

	global_clk: component SB_HFOSC
	port map (
		CLKHFEN => '1',
		CLKHFPU => '1',
		CLKHF => clk_48mhz
	);

	led_drive : component SB_RGBA_DRV
	port map (
		CURREN => en,
		RGBLEDEN => en,
		RGB0PWM => clk_48mhz,	
		RGB1PWM => clk_48mhz,	
		RGB2PWM => clk_48mhz,	
		RGB0 => led_r, 
		RGB1 => led_g, 
		RGB2 => led_b
	);

end architecture rtl;
