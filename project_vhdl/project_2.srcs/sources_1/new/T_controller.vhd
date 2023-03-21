library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity T_controller is
    Port ( bSa : in STD_LOGIC; --buttonSensorA (switch)
           bSb : in STD_LOGIC; --buttonSensorB (switch)
           bPPA : in STD_LOGIC; --buttonPedestrianPressedA
           bPPB : in STD_LOGIC; --buttonPedestrianPressedB
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (4 downto 0)
           --led1 => Sa, led2 => PedestrianButtonA, led3 => Sb, led4 => PedestrianButtonB
           );
end T_controller;

architecture Behavioral of T_controller is

type states is (TLSA, TLSAy, TLSB, TLSBy); 
--TLSA=>TrafficLightStreenA(green), TLSAy(yellow). If TLSA is green, the TLSB is red
            
signal current_state, next_state : states;

signal Sa, Sb, PPA, PPB : std_logic;


component DeBouncer is
    port(   Clock : in std_logic;
            Reset : in std_logic;
            button_in : in std_logic;
            pulse_out : out std_logic
        );
end component DeBouncer;

signal btn_db : std_logic_vector (1 downto 0);

begin
db1 : DeBouncer port map (Clock => clk,
                          Reset => rst,
                          button_in => PPA,
                          pulse_out => btn_db (1));

db0 : DeBouncer port map (Clock => clk,
                          Reset => rst,
                          button_in => PPB,
                          pulse_out => btn_db (0));    

process(clk, rst)
begin
  if rst = '1' then
    current_state <= TLSA;
--  elsif rising_edge(clk) then
--    current_state <= TLSA;
  end if;    
end process;

process(current_state, TLSA, TLSAy, TLSB, TLSBy)
begin
case (current_state) is
            when TLSA => 
                if ((Sa = '0')  and (Sb = '1')) or (PPA = '1') then
                    if PPa = '1' then
                        led(2) <= '1';
                    end if;   
                    current_state <= TLSAy;
                else if (Sa = '0') and (Sb = '0') and (PPA = '0') then
                    current_state <= TLSA;
                end if;
                end if;
            when TLSAy => 
                --wait for 5 sec;
                if led(2) = '1' or led(4) = '1' then
                    --wait for 2 sec;
                    led(2) <= '0';
                    led(4) <= '0';
                end if;
                current_state <= TLSBy;
            when TLSBy => 
                --wait for 5 sec;
                if led(2) = '1' or led(4) = '1' then
                    --wait for 2 sec;
                    led(2) <= '0';
                    led(4) <= '0';
                end if;
                current_state <= TLSB;
            when TLSB =>
                --wait for 50 sec;
                if (Sa = '0') and (Sb = '1') and (PPB = '0') then
                    --wait for 10 sec;
                    if (Sa = '0') or (PPB = '0') then
                        --wait until Sa = '1' or PPB = '1';
                    end if;
                end if;
            when others => current_state <= TLSA;
           end case;
   end process;
end Behavioral;