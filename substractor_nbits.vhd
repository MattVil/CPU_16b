LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY substractor_nbits IS
GENERIC(SIZE : INTEGER := 16);
PORT(
	A,B : IN std_logic_vector(SIZE-1 DOWNTO 0);
	Cin : IN std_logic;
	S : OUT std_logic_vector(SIZE-1 DOWNTO 0);
	Cout : OUT std_logic
);
END ENTITY;

ARCHITECTURE behavior OF substractor_nbits IS

	COMPONENT substractor_2v1bit
	PORT(
		A,B,Cin : IN std_logic;
		S, Cout : OUT std_logic
	);
	END COMPONENT;

  SIGNAL tmp: std_logic_vector(SIZE-1 DOWNTO 0);

BEGIN

	tmp(SIZE-1) <= Cin;

	sub_loop: FOR i IN SIZE-1 DOWNTO 1
  GENERATE
		sub : substractor_2v1bit PORT MAP(A=>A(i), B=>B(i), Cin=>tmp(i), S=>S(i), Cout=>tmp(i-1));
	END GENERATE sub_loop;

	sub : substractor_2v1bit PORT MAP(A=>A(0), B=>B(0), Cin=>tmp(0), S=>S(0), Cout=>Cout);

END behavior;
