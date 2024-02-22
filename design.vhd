-- import libraries

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- entity declaration

entity Booth_Mult is

    Port (In_1,In_2 : in std_logic_vector (7 downto 0);
          clk : in std_logic;
          ready : in std_logic;
          done : out std_logic;
          S : out std_logic_vector (15 downto 0));
        
end Booth_Mult;

-- architecture definition

architecture myimplementation of Booth_Mult is 

    signal M : unsigned(9 downto 0); --multiplicand
    signal AQ : unsigned(18 downto 0); -- accumulator & multiplier
    signal N : integer:= 4; -- number of iterations
    signal AplusM : unsigned(9 downto 0); -- A + M
    signal AminusM : unsigned(9 downto 0); -- A - M
    signal TWOXM : unsigned (9 downto 0);
    signal MTWOXM : unsigned(9 downto 0);
    signal ATWOXM : unsigned (9 downto 0);
    signal AMTWOXM : unsigned(9 downto 0);
    
    
begin

-- process based on clock cycles

process(clk)
    
    begin  
    
     if rising_edge(clk) then -- check for rising edge
     
         if(N = 0) then       -- if iterated through N times, output the result of AQ
              done <= '1';     -- indicating that the process is complete
               S <= std_logic_vector(AQ(16 downto 1));     -- output        
         end if;
          
        if (ready = '1') then   -- if ready is 1 then initialize M and AQ
            
            if (In_1(7) = '1') then
               M(9 downto 8) <= "11";
               M(7 downto 0) <= unsigned(In_1); --multiplicand
               
            elsif (In_1(7) = '0') then
               M(9 downto 8) <= "00";
               M(7 downto 0) <= unsigned(In_1); --multiplicand
               
            end if;
            
            AQ <= (others => '0');
            AQ(8 downto 1) <= unsigned(In_2);
            
            TWOXM <= (others => '0');
            TWOXM(8 downto 0) <= unsigned(In_1(7 downto 0)) & '0';
            
            if (In_1(7) = '1') then
               TWOXM(9) <= '1';
               
            elsif (In_1(7) = '0') then
               TWOXM(9) <= '0';
               
            end if;
            
            MTWOXM <= (others => '0');
            MTWOXM(8 downto 0) <= NOT(unsigned(In_1(7 downto 0)) & '0') + 1;
            
            if (In_1(7) = '1') then
               MTWOXM(9) <= '0';
               
            elsif (In_1(7) = '0') then
               MTWOXM(9) <= '1';
               
            end if;
        
        
          else -- if ready is 0
            
            if(AQ(1 downto 0) = "01" OR AQ(1 downto 0) = "10") then 
            
                if(AQ(2) = '0') then 
                    
                    if(AplusM(9) = '0') then
                        AQ <= "00" & AplusM & AQ(8 downto 2);
                    elsif(AplusM(9) = '1') then
                        AQ <= "11" & AplusM & AQ(8 downto 2);
                    end if;

                elsif (AQ(2) = '1') then
                    if(AminusM(9) = '0') then
                        AQ <= "00" & AminusM & AQ(8 downto 2);
                    elsif(AminusM(9) = '1') then
                        AQ <= "11" & AminusM & AQ(8 downto 2);
                    end if;
                  
                end if;
            
             elsif(AQ(2 downto 0) = "011") then -- 2XM
            
                if(ATWOXM(9) = '0') then 
                    AQ <= "00" & ATWOXM & AQ(8 downto 2);

                elsif (ATWOXM(9) = '1') then
                    AQ <= "11" & ATWOXM & AQ(8 downto 2);

                end if;                
            
            elsif(AQ(2 downto 0) = "100") then -- -2XM
            
                if(AMTWOXM(9) = '0') then 
                    AQ <= "00" & AMTWOXM & AQ(8 downto 2);

                elsif (AMTWOXM(9) = '1') then
                    AQ <= "11" & AMTWOXM & AQ(8 downto 2);

                end if;
            
            elsif (AQ(2 downto 0) = "111" OR AQ(2 downto 0) = "000") then 
                           
                if(AQ(18) = '0') then 
                    AQ <= "00" & AQ(18 downto 2);

                elsif (AQ(18) = '1') then
                    AQ <= "11" & AQ(18 downto 2);

                end if;
            end if;
            
        N <= N - 1; -- decrement N 
        
      end if;
      
    end if;
    
    -- use the falling edge to perform the arithmetic operations on A and M
    
    if falling_edge(clk) then
    
              AplusM <= AQ(18 downto 9) + M(9 downto 0);
              AminusM <= AQ(18 downto 9) - M(9 downto 0);
              ATWOXM <= AQ(18 downto 9) + TWOXM;
              AMTWOXM <= AQ(18 downto 9) + MTWOXM;
              
    end if;
        
    end process;
end myimplementation;
