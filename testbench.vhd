--Group:
    --Pulasthi Peiris
    --Soumik Podder

-- import libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench is
-- empty
end testbench;

architecture tb of testbench is

-- DUT component
component Booth_Mult is
    Port (In_1,In_2 : in std_logic_vector (7 downto 0);
          clk : in std_logic;
          ready : in std_logic;
          done : out std_logic;
          S : out std_logic_vector (15 downto 0));
end component;

--input and output signals
signal In_1_in : std_logic_vector (7 downto 0);
signal In_2_in : std_logic_vector (7 downto 0);
signal clk : std_logic := '0';
signal ready_in : std_logic;
signal done_out : std_logic;
signal S_out : std_logic_vector (15 downto 0);
 
begin

  clk_process: process
  begin
    clk <= '0';
    wait for 1 ns;  --for 1 ns signal is '0'.
    clk <= '1';
    wait for 1 ns;  --for next 1 ns signal is '1'.
  end process;


  --Connect DUT
  DUT: Booth_Mult port map (In_1_in, In_2_in, clk, ready_in, done_out, S_out);
  process
  begin
  --test signals
  
      --positive positive 
  --  In_1_in <= "00011000"; --24
  --  In_2_in <= "00110111"; --55
  --  ready_in <= '1';
  --  wait for 2 ns;
    --total = 1320
    --total = 0000010100101000
  
  --positive negative
  --  In_1_in <= "00011000"; --24
  --  In_2_in <= "11011100"; -- -36
  --  ready_in <= '1';
  --  wait for 2 ns;
    --total = -864
    --total = 1111110010100000
    
    --negative positive
   -- In_1_in <= "11011100";-- -36
   -- In_2_in <= "00011000";-- 24
   -- ready_in <= '1';
   -- wait for 2 ns;
    --total = -864
    --total = 1111110010100000
    
    --negative negative
    In_1_in <= "10110110"; -- -74
    In_2_in <= "10000010"; -- -126
    ready_in <= '1';
    wait for 2 ns;
    --total = 9324
    --total = 0010010001101100
    
    ready_in <= '0';
    wait for 10 ns;   
    
    wait;
  end process;
end tb;