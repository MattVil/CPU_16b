LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY add_2v1 IS
  PORT(
    A, B, Cin : IN std_logic;
    S, Cout : OUT std_logic
  );
END add_2v1;

ARCHITECTURE behavior OF add_2v1 IS

BEGIN
  S <= A xor B xor Cin;
  Cout <= (A and B) or ((A xor B) and Cin);
END behavior;
