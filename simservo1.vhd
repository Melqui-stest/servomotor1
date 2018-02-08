
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity simservo1 is
--  Port ( );
end simservo1;

architecture tb of simservo1 is
component servomotor1
Port (  clk : in std_logic;
        btn0: in std_logic;-- será el reset(btnc)
        swt : in std_logic_vector( 3 downto 0);
        JB3: out std_logic--señal de control
 );
 
 end component;

--Inputps
signal clk : std_logic;
signal btn0: std_logic;-- será el reset(btnc)
signal  swt : std_logic_vector( 3 downto 0);--control del micropaso ms
--Outputs
signal JB3: std_logic;

begin
UnidadenPruebas : servomotor1
Port Map(
 clk => clk,
 btn0 => btn0,
 swt => swt,
 JB3 => JB3
);
P_clk:process
 begin
 clk <='0';
 wait for 5 ns;
 clk <='1';
 wait for 5 ns;
 end process;
P_reset:process
  begin
  btn0 <='1';
  wait for 100 ns;
  btn0 <='0';
  swt<="0100";
  wait for 50 ms;
  swt<="0010";
  wait for 30 ms;
  swt<="0001";
  wait for 40 ms;
  swt<="0100";
  wait for 70 ms;
  swt<="0011";
  wait for 1000 ns;
  swt<="0100";
  wait for 100 ns;
  swt<="0100";
  wait for 10 ns;
  swt<="0000";
  wait for 10 ns;
  swt<="0101";
  wait for 10 ns;
  swt<="0000";
  wait;
end process;
end tb;


