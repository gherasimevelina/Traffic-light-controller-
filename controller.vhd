library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_unsigned.all;

entity controller_semafor is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           Sa, Sb: in std_logic;
           led : out STD_LOGIC_VECTOR (5 downto 0)           
           );
           
end controller_semafor;

architecture Behavioral of controller_semafor is

--enumeram starile
type states is (idle, masinaB_int, masinaB_int2, masinaB_1, masinaB_2, masinaB_3, masinaB_4, masinaB_5, 
nicioMasina_int, nicioMasina, masinaA_1, masinaA_2, masinaA_3, masinaA_4, masinaA_5, masinaA_6);

signal s10sec: std_logic;

signal current_state, next_state : states;--enumeram toti parametrii din automat
begin

--global counter

process(clk,rst)
variable q: integer range 0 to 10000000 := 0;
begin

if rst = '1' then
    q := 0; 
    s10sec <= '0';
elsif rising_edge(clk) then

if q = 10000000 then 
    q := 0;
    s10sec <= '1';
else 
    q := q +1;
    s10sec <= '0';
    
end if;   
end if;
end process;


-- CLS -> realizeaza tranzitiile
process(clk, rst)
begin
    if rst = '1' then
    current_state <= idle;
    elsif rising_edge(clk) then
    current_state <= next_state;
    end if;
end process;


--CLC -> 
process(current_state, Sa, Sb, s10sec)
begin
case current_state is
when idle => if Sa = '1' then
next_state <= masinaA_1;

elsif Sa ='0' and Sb = '1' then 
next_state <= masinaB_int;
end if;


when masinaA_1 => if s10sec = '1' then
next_state <= masinaA_2;
end if;
when masinaA_2 => if s10sec = '1' then 
next_state <= masinaA_3;
end if;
when masinaA_3 => if s10sec = '1' then 
next_state <= masinaA_4;
end if;
when masinaA_4 => if s10sec = '1' then 
next_state <= masinaA_5;
end if;
when masinaA_5 => if s10sec = '1' then 
next_state <= masinaA_6;
end if;
when masinaA_6 => if Sb = '0' then
next_state <= masinaA_6;
elsif Sb = '1' then 
next_state <= masinaB_int;
end if;

when masinaB_int => next_state <= masinaB_int2;
when masinaB_int2 => next_state <= masinaB_1;

when masinaB_1 => if s10sec = '1' then 
next_state <= masinaB_2;
end if;
when masinaB_2 => if s10sec = '1' then 
next_state <= masinaB_3;
end if;
when masinaB_3 => if s10sec = '1' then 
next_state <= masinaB_4;
end if;
when masinaB_4 => if s10sec = '1' then 
next_state <= masinaB_5;
end if;
when masinaB_5 => if Sb = '1' and Sa ='0' then 
next_state <= masinaB_5;
elsif Sa ='1' or Sb = '0' then 
next_state <= nicioMasina_int;
end if;

when nicioMasina_int => next_state <= nicioMasina;
when nicioMasina =>next_state <= masinaA_1;


end case;
end process;

--proces led

process(rst, current_state)
begin 
if rst ='1' then 
    led <= "100001";
end if;
if (current_state = masinaA_1 or current_state = masinaA_2 or current_state = masinaA_3 or
current_state = masinaA_4 or current_state = masinaA_5 or current_state = masinaA_6 or current_state = nicioMasina) then 
    led <= "100001";
end if;
if current_state = masinaB_int then 
    led <= "010001";
end if;
if current_state = masinaB_int2 then 
    led <= "001001";
end if;
if (current_state = masinaB_1 or current_state = masinaB_2 or current_state = masinaB_3 or current_state = masinaB_4 or
current_state = masinaB_5) then 
    led <= "001100";
end if;
if current_state = nicioMasina_int then 
    led <= "001010";
end if;

end process;

end Behavioral;