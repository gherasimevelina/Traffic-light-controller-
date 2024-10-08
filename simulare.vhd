library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test is

end test;

architecture Behavioral of test is
component controller_semafor is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           Sa, Sb: in std_logic;
           led : out STD_LOGIC_VECTOR (5 downto 0)           
           );
           
end component controller_semafor;


signal clk, rst, Sa, Sb : std_logic;
signal led: std_logic_vector(5 downto 0);
begin

conexiune: controller_semafor port map(
rst => rst,
clk => clk,
Sa => Sa ,
Sb => Sb, 
led => led
);

--generare ceas 

process
begin
clk <= '1'; wait for 5 ns;
clk <= '0'; wait for 5 ns;
end process;

--generare reset

rst <= '1' after 0 ns, '0' after 10 ns;

Sa <= '1' after 0ns,
      '0' after 10ns,
      '1' after 80ns,
      '0' after 150ns,
      '1' after 330ns;
      
      
Sb <= '0' after 0ns,
      '1' after 10ns,
      '0' after 80ns,
      '1' after 150ns;
      

      
           
end Behavioral;
