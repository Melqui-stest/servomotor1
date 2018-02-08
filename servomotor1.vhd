----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2018 14:07:15
-- Design Name: 
-- Module Name: servomotor1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity servomotor1 is
--  Port ( );
Port ( clk : in std_logic;
       btn0 : in std_logic;--reset
       JB3: out std_logic;--señal de control
       swt: in std_logic_vector(3 downto 0)
        );
end servomotor1;

architecture Behavioral of servomotor1 is
--señales auxiliares para señal de T=0,1ms
signal s0con1ms : std_logic;
signal cuenta0con1ms: natural range 0 to 2**14-1;
constant fincuenta0con1ms :natural:=10000;
--Señales auxiliares para generar señal de f=50hz(con ancho de pulso igual a un ciclo de clk(10ns))
---creada a partir de la de 0,1ms 
signal s20ms : std_logic;--f=50hz
signal cuenta20ms : natural range 0 to 2**8-1;
constant fincuenta20ms: natural:=200;--reduccion de cuenta en realidad es 2000000
--------------------------------------------------------------------
--Señales para contador del giro 
signal sgiro : std_logic;-- se pone a 1 cuanndo se alcanza el giro(mini) seleccionado
--Para fin cuenta en funcion del giro que quieras seleccionar
signal fincuentasrelojt : unsigned(3 downto 0);
signal cuentagiro : unsigned(3 downto 0);--fines de cuenta en decimal son de 0 a 10--cuenta de los giros

--Señales para contador de 1ms
signal cuenta1ms: natural range 0 to 2**4-1;---señal que cuenta cada 0,1 ms
constant fincuenta1ms:natural:=10;
signal s1ms: std_logic;

--Señales auxiliares para generar la señal de control del motor
signal cuentacontrolservo : unsigned(3 downto 0);
signal scontrolservo : std_logic; ---señal que será JB3
signal fincuentasrelojtnat : natural range 0 to 2**4-1;
begin
P_conta0con1miliseg:Process (btn0, clk)
begin
 if btn0='1' then
   cuenta0con1ms<=0;
   s0con1ms<='0';
 elsif clk'event and clk='1' then
   if cuenta0con1ms= fincuenta0con1ms-1 then
     cuenta0con1ms<=0;
     s0con1ms<='1';
   else 
     cuenta0con1ms<= cuenta0con1ms+1;
     s0con1ms<='0';
   end if;
 end if;
end process;
--s0con1ms<='1' when (clk'event and clk='1' and cuenta0con1ms= fincuenta0con1ms-1) else '0';
P_conta20miliseg:Process (btn0, clk)
begin
 if btn0='1' then
   cuenta20ms<=0;
   s20ms<='0';
 elsif clk'event and clk='1' then
  s20ms<='0';
  if s0con1ms='1' then---
   if cuenta20ms= fincuenta20ms-1 then
     cuenta20ms<=0;
     s20ms<='1';
   else 
     cuenta20ms<= cuenta20ms+1;
     s20ms<='0';
     
   end if;
  end if;
 end if;
end process;
--s20ms<='1' when ((cuenta20ms=fincuenta20ms-1) and s0con1ms='1') else '0';
--s20ms<='1' when ((cuenta20ms=0) and s0con1ms='1') else '0';
P_conta1miliseg:Process (btn0, clk)
begin
 if btn0='1' then
   cuenta1ms<=0;
   s1ms<='0';
 elsif clk'event and clk='1' then
  s1ms<='0';
  if s0con1ms='1' then--
   if cuenta1ms= fincuenta1ms-1 then
     cuenta1ms<=0;
     s1ms<='1';
   else 
     cuenta1ms<= cuenta1ms+1;
     s1ms<='0';
   end if;
  end if;
 end if;
end process;
-- s20ms<='1' when cuenta20ms= fincuenta20ms-1 then s20ms='1' else '0';


P_contagiro:Process (btn0, clk)
begin
 if btn0='1' then
   cuentagiro<="0000";
   sgiro<='0';
 elsif clk'event and clk='1' then
  sgiro<='0';
  if s0con1ms='1' then--
   if cuentagiro= fincuentasrelojt-1 then
     cuentagiro<="0000";
     sgiro<='1';
   else 
     cuentagiro<= cuentagiro+1;
     sgiro<='0';
   end if;
  end if;
 end if;
end process;
-- s20ms<='1' when cuenta20ms= fincuenta20ms-1 then s20ms='1' else '0';

P_resoluciongiro:Process(swt)--Multiplexor para seleccionar grados de giro
begin
   case swt is
     when "0000"=>
      fincuentasrelojt<="0000";--fincuenta 4-genera señal 1ms(T=2ms)-0º
     when "0001"=>
      fincuentasrelojt<="0001";--fincuenta 4-genera señal 1,25ms(T=2,5ms)-45º
     when "0010"=>
      fincuentasrelojt<="0010";--fincuenta 4-genera señal 1,5ms(T=3ms)-90º
     when "0011"=>
      fincuentasrelojt<="0011";--fincuenta 4-genera señal 1,75ms(T=3,5ms)-135º
     when "0100"=>
      fincuentasrelojt<="0100";--fincuenta 4-genera señal 2ms(T=4ms)-180º
     when "0101"=>
      fincuentasrelojt<="0101";
     when "0110"=>
      fincuentasrelojt<="0110";
     when "0111"=>
      fincuentasrelojt<="0111";
     when "1000"=>
      fincuentasrelojt<="1000";
     when "1001"=>
      fincuentasrelojt<="1001";
     when "1010"=>
      fincuentasrelojt<="1010";
     when others=>
      fincuentasrelojt<="0000";--fincuenta 4-genera señal 1ms(T=2ms)-0º
    end case;
end process; 
fincuentasrelojtnat<=to_integer(fincuentasrelojt);
P_scontrol:Process (btn0, clk)
begin
 if btn0='1' then
   --cuentascontrolservo<="0000";
   scontrolservo<='0';
  elsif clk'event and clk='1' then
    if cuenta20ms<=(fincuenta1ms+fincuentasrelojtnat-1) then
      if s20ms='1' then  --generamos latch para guardar el valor anterior cuando s20ms no es 1
       scontrolservo<='1';
      end if;
    else 
      scontrolservo<='0';
    end if;
  end if;
 end process;
     
-- s20ms<='1' when cuenta20ms= fincuenta20ms-1 then s20ms='1' else '0';

JB3<=scontrolservo;
end Behavioral;
