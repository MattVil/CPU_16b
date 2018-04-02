library IEEE;
use ieee.std_logic_1164.all;

entity CPU is 
port(d_in: in std_logic_vector(15 downto 0);
	clk, reset, run: in std_logic;
	bus_out: out std_logic_vector(15 downto 0);
	done: out std_logic);
end CPU;

architecture behavior of CPU is
	component add_sub is
		port(A,B : in std_logic_vector(16-1 DOWNTO 0);
			Sel: in std_logic_vector(2 DOWNTO 0);
			S: out std_logic_vector(16-1 DOWNTO 0);
			Cout : out std_logic);
	end component;
	
	component mux is
		port(DIN, R0, R1, R2, R3, R4, R5, R6, R7, G	: in	STD_LOGIC_VECTOR(15 DOWNTO 0);
			Sel: in STD_LOGIC_VECTOR(3 DOWNTO 0);  
			S : out	STD_LOGIC_VECTOR(15 DOWNTO 0));
	end component;
	
	component ControlUnit is
		port(clk, reset, run: in std_logic;
			irs, as, gs, done: out std_logic;
			din: in std_logic_vector(8 downto 0);
			alu: out std_logic_vector(2 downto 0);
			reg : out std_logic_vector(7 downto 0);
			bus_sel: out std_logic_vector(3 downto 0));
	end component;
	
	component reg_n is
		generic(N : integer := 16);
		port(D : IN std_logic_vector(N-1 downto 0);
			Resetn, CLK, SET : IN std_logic;
			Q : OUT std_logic_vector(N-1 downto 0));
	end component;
	
	signal irs_sig, as_sig, gs_sig, cout: std_logic;
	signal alu_sig: std_logic_vector(2 downto 0);
	signal bussel_sig: std_logic_vector(3 downto 0);
	signal regsel_sig: std_logic_vector(7 downto 0);
	signal ir_sig: std_logic_vector(8 downto 0);
	signal reg_sig, a_sig, g_sig: std_logic_vector(15 downto 0);
	signal reg0mux, reg1mux, reg2mux, reg3mux, reg4mux, reg5mux, reg6mux, reg7mux, gmux_sig: std_logic_vector(15 downto 0);
	
	begin
	reg_ir: reg_n generic map(N => 9) port map(D=>d_in(15 downto 7), Resetn=>'0', CLK=>clk, 
									SET=>irs_sig, Q(8 downto 0)=>ir_sig(8 downto 0));
	cu: ControlUnit port map(clk=>clk, reset=>reset, run=>run, irs=>irs_sig, as=>as_sig,
									gs=>gs_sig, done=>done, alu=>alu_sig, din=>ir_sig,
									reg=>regsel_sig, bus_sel=>bussel_sig);
	reg_0: reg_n generic map(N => 16) port map(D=>reg_sig, Resetn=>'0', CLK=>clk, 
									SET=>regsel_sig(0), Q=>reg0mux);
	reg_1: reg_n generic map(N => 16) port map(D=>reg_sig, Resetn=>'0', CLK=>clk, 
									SET=>regsel_sig(1), Q=>reg1mux);
	reg_2: reg_n generic map(N => 16) port map(D=>reg_sig, Resetn=>'0', CLK=>clk, 
									SET=>regsel_sig(2), Q=>reg2mux);
	reg_3: reg_n generic map(N => 16) port map(D=>reg_sig, Resetn=>'0', CLK=>clk, 
									SET=>regsel_sig(3), Q=>reg3mux);
	reg_4: reg_n generic map(N => 16) port map(D=>reg_sig, Resetn=>'0', CLK=>clk, 
									SET=>regsel_sig(4), Q=>reg4mux);
	reg_5: reg_n generic map(N => 16) port map(D=>reg_sig, Resetn=>'0', CLK=>clk, 
									SET=>regsel_sig(5), Q=>reg5mux);
	reg_6: reg_n generic map(N => 16) port map(D=>reg_sig, Resetn=>'0', CLK=>clk, 
									SET=>regsel_sig(6), Q=>reg6mux);
	reg_7: reg_n generic map(N => 16) port map(D=>reg_sig, Resetn=>'0', CLK=>clk, 
									SET=>regsel_sig(7), Q=>reg7mux);
	A: reg_n generic map(N => 16) port map(D=>reg_sig, Resetn=>'0', CLK=>clk, 
									SET=>as_sig, Q=>a_sig);
	ALU: add_sub port map(A=>a_sig, B=>reg_sig, Sel=>alu_sig, S=>g_sig, Cout=>cout);
	G: reg_n generic map(N => 16) port map(D=>g_sig, Resetn=>'0', CLK=>clk, 
									SET=>gs_sig, Q=>gmux_sig);
	MUX1: mux port map(DIN=>d_in, R0=>reg0mux, R1=>reg1mux, R2=>reg2mux, R3=>reg3mux,
							R4=>reg4mux, R5=>reg5mux, R6=>reg6mux, R7=>reg7mux, G=>gmux_sig,
							Sel=>bussel_sig, S=>reg_sig);
	
end architecture behavior;