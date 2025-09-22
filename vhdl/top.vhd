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

	component SB_LFOSC is
		port (
			CLKLFEN : in STD_LOGIC;
			CLKLFPU : in STD_LOGIC;
			CLKLF : out STD_LOGIC
		);
	end component SB_LFOSC;

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
	signal pulse_signal : std_logic;

begin

	global_clk: component SB_LFOSC
	port map (
		CLKLFEN => '1',
		CLKLFPU => '1',
		CLKLF => clk_48mhz
	);

	pulse_signal <= clk_48mhz when en = '1' else '1';

	led_drive: component SB_RGBA_DRV
	port map (
		CURREN => '1',
		RGBLEDEN => '1',
		RGB0PWM => pulse_signal,
		RGB1PWM => pulse_signal,
		RGB2PWM => pulse_signal,
		RGB0 => led_r,
		RGB1 => led_g,
		RGB2 => led_b
	);

end architecture rtl;
