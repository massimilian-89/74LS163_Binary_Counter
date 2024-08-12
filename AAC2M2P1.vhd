LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity AAC2M2P1 is
  port (
    CP:   in std_logic;  -- Clock
    SR:   in std_logic;  -- Active low, synchronous reset
    P:    in std_logic_vector(3 downto 0);  -- Parallel input
    PE:   in std_logic;  -- Parallel Enable (Load)
    CEP:  in std_logic;  -- Count Enable Parallel input
    CET:  in std_logic;  -- Count Enable Trickle input
    Q:    out std_logic_vector(3 downto 0);  -- Counter output
    TC:   out std_logic  -- Terminal Count
  );
end entity;

architecture LS163 of AAC2M2P1 is
  signal temp: std_logic_vector(3 downto 0);
begin
  process(CP, SR)
  begin
    if (SR = '0') then
      temp <= "0000";
    elsif (rising_edge(CP)) then
      if (PE = '0') then
        temp <= P;
      elsif (CET = '1' and CEP = '1') then
        if temp = "1111" then
          temp <= "0000";  -- Reset counter after reaching max value
        else
          temp <= temp + 1;
        end if;
      end if;
    end if;
  end process;

  Q <= temp;
  TC <= CET and temp(0) and temp(1) and temp(2) and temp(3);  -- Corrected logic to check TC
end architecture;

