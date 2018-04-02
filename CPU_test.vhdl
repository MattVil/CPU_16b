library IEEE;
use ieee.std_logic_1164.all;

entity CPU_test is
	port(SW: in std_logic_vector(17 downto 0);
	KEY: in std_logic_vector(3 downto 0);
	LEDR: out std_logic_vector(17 downto 0));
end CPU_test;

architecture behavior of CPU_test is
	component CPU is
		port(d_in: in std_logic_vector(15 downto 0);
			clk, reset, run: in std_logic;
			bus_out: out std_logic_vector(15 downto 0);
			done: out std_logic);
	end component;
	
	begin
	Proc: CPU port map(d_in=>SW(15 downto 0), clk=>KEY(1), reset=>KEY(0), run=>SW(17),
						bus_out=>LEDR(15 downto 0), done=>LEDR(17));
end architecture behavior;