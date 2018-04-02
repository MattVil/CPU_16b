LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux IS
	PORT (
		DIN, R0, R1, R2, R3, R4, R5, R6, R7, G	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
		Sel: IN STD_LOGIC_VECTOR(3 DOWNTO 0);  
		S : OUT	STD_LOGIC_VECTOR(15 DOWNTO 0));
END mux;

ARCHITECTURE behavior OF mux IS
BEGIN
	mux : with Sel select
		S <= 	R0 when "0000",
				R1 when "0001",
				R2 when "0010",
				R3 when "0011",
				R4 when "0100",
				R5 when "0101",
				R6 when "0110",
				R7 when "0111",
				G  when "1000",
				DIN when others;
END Behavior;