library IEEE;
use ieee.std_logic_1164.all;

entity ControlUnit is
port(
	clk, reset, run: in std_logic;
	irs, as, gs, done: out std_logic;
	din: in std_logic_vector(8 downto 0);
	alu: out std_logic_vector(2 downto 0);
	reg : out std_logic_vector(7 downto 0);
	bus_sel: out std_logic_vector(3 downto 0));
end ControlUnit;

architecture behavior of ControlUnit is

type state is (IR, DON, MV, MVI, ALU0, ALU1, ALU2);
signal actual_state, next_state: state;

begin

--Registre d'état à reset asynchrone
state_reg: process(clk, reset)
begin
	if reset='1' then
		actual_state <= IR;
	elsif clk'event and clk='1' then
		actual_state <= next_state;
	end if;
end process;

--Fonction de Génération (Mealy)
generate_func: process(actual_state, din)
begin
	case actual_state is
		when IR => irs<='1'; as<='0'; gs<='0'; done<='0';
						alu<="000";
						reg<="00000000";
						bus_sel<="1111";
		when DON => irs<='0'; as<='0'; gs<='0'; done<='1';
						alu<="000";
						reg<="00000000";
						bus_sel<="1111";
		when MV => irs<='0'; as<='0'; gs<='0'; done<='0';
						alu<="000";
						if (din(5 downto 3)="000") then reg<="00000001";
						elsif (din(5 downto 3)="001") then reg<="00000010";
						elsif (din(5 downto 3)="010") then reg<="00000100";
						elsif (din(5 downto 3)="011") then reg<="00001000";
						elsif (din(5 downto 3)="100") then reg<="00010000";
						elsif (din(5 downto 3)="101") then reg<="00100000";
						elsif (din(5 downto 3)="110") then reg<="01000000";
						elsif (din(5 downto 3)="111") then reg<="10000000";
						end if;
						if (din(2 downto 0)="000") then bus_sel<="0000";
						elsif (din(2 downto 0)="001") then bus_sel<="0001";
						elsif (din(2 downto 0)="010") then bus_sel<="0010";
						elsif (din(2 downto 0)="011") then bus_sel<="0011";
						elsif (din(2 downto 0)="100") then bus_sel<="0100";
						elsif (din(2 downto 0)="101") then bus_sel<="0101";
						elsif (din(2 downto 0)="110") then bus_sel<="0110";
						elsif (din(2 downto 0)="111") then bus_sel<="0111";
						end if;
		when MVI => irs<='0'; as<='0'; gs<='0'; done<='0';
						alu<="000";
						if (din(5 downto 3)="000") then reg<="00000001";
						elsif (din(5 downto 3)="001") then reg<="00000010";
						elsif (din(5 downto 3)="010") then reg<="00000100";
						elsif (din(5 downto 3)="011") then reg<="00001000";
						elsif (din(5 downto 3)="100") then reg<="00010000";
						elsif (din(5 downto 3)="101") then reg<="00100000";
						elsif (din(5 downto 3)="110") then reg<="01000000";
						elsif (din(5 downto 3)="111") then reg<="10000000";
						end if;
						bus_sel<="1111";
		when ALU0 => irs<='0'; as<='1'; gs<='0'; done<='0';
						alu<="000";
						if (din(5 downto 3)="000") then bus_sel<="0000";
						elsif (din(5 downto 3)="001") then bus_sel<="0001";
						elsif (din(5 downto 3)="010") then bus_sel<="0010";
						elsif (din(5 downto 3)="011") then bus_sel<="0011";
						elsif (din(5 downto 3)="100") then bus_sel<="0100";
						elsif (din(5 downto 3)="101") then bus_sel<="0101";
						elsif (din(5 downto 3)="110") then bus_sel<="0110";
						elsif (din(5 downto 3)="111") then bus_sel<="0111";
						end if;
						reg<="00000000";
		when ALU1 => irs<='0'; as<='0'; gs<='1'; done<='0';
						alu<=din(8 downto 6);
						if (din(2 downto 0)="000") then bus_sel<="0000";
						elsif (din(2 downto 0)="001") then bus_sel<="0001";
						elsif (din(2 downto 0)="010") then bus_sel<="0010";
						elsif (din(2 downto 0)="011") then bus_sel<="0011";
						elsif (din(2 downto 0)="100") then bus_sel<="0100";
						elsif (din(2 downto 0)="101") then bus_sel<="0101";
						elsif (din(2 downto 0)="110") then bus_sel<="0110";
						elsif (din(2 downto 0)="111") then bus_sel<="0111";
						end if;
						reg<="00000000";
		when ALU2 => irs<='0'; as<='0'; gs<='0'; done<='0';
						alu<="000";
						bus_sel<="1000";
						if (din(5 downto 3)="000") then reg<="00000001";
						elsif (din(5 downto 3)="001") then reg<="00000010";
						elsif (din(5 downto 3)="010") then reg<="00000100";
						elsif (din(5 downto 3)="011") then reg<="00001000";
						elsif (din(5 downto 3)="100") then reg<="00010000";
						elsif (din(5 downto 3)="101") then reg<="00100000";
						elsif (din(5 downto 3)="110") then reg<="01000000";
						elsif (din(5 downto 3)="111") then reg<="10000000";
						end if;
	end case;
end process;

--Fonction de Transition
transition_func: process(actual_state, reset, run, din)
begin
	if (reset='1') then next_state<=IR;
	else
		case actual_state is
			when IR => if(din(8 downto 6)="110") then next_state<=MV;
				elsif(din(8 downto 6)="111") then next_state<=MVI;
				else next_state<=ALU0;
				end if;
			when DON =>
				if (run='1') then next_state<=IR;
				else next_state<=DON;
				end if;
			when MV => next_state<=DON;
			when MVI => 
				if (run='1') then next_state<=DON;
				else next_state<=MVI;
				end if;
			when ALU0 => next_state<=ALU1;
			when ALU1 => next_state<=ALU2;
			when ALU2 => next_state<=DON;
		end case;
	end if;
end process;

end architecture behavior;