Library IEEE;
Use IEEE.std_logic_1164.all;

ENTITY reg_n IS 
	generic(N : integer := 16);
	PORT(
		D : IN std_logic_vector(N-1 downto 0);
		Resetn, CLK, SET : IN std_logic;
		Q : OUT std_logic_vector(N-1 downto 0)
	);
END ENTITY;

ARCHITECTURE behavior of reg_n IS
BEGIN
	PROCESS(CLK)
	BEGIN
		IF(rising_edge(CLK)) THEN
			IF(Resetn = '0') THEN
				Q <= (others => '0');
			ELSIF (SET = '1') THEN
				Q <= D;
			END IF;
		END IF;
	END PROCESS;
	
END ARCHITECTURE;