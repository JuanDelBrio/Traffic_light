LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY traffic_light_TB IS
END traffic_light_TB;

ARCHITECTURE behavior OF traffic_light_TB IS

    COMPONENT traffic_light
        PORT (
            clk        : IN  std_logic;
            reset      : IN  std_logic;
            idle_mode  : IN  std_logic;
            TL1_g      : OUT std_logic;
            TL1_y      : OUT std_logic;
            TL1_r      : OUT std_logic;
            TL2_g      : OUT std_logic;
            TL2_y      : OUT std_logic;
            TL2_r      : OUT std_logic
        );
    END COMPONENT;

    SIGNAL clk        : std_logic := '0';
    SIGNAL reset      : std_logic := '0';
    SIGNAL idle_mode  : std_logic := '0';
    SIGNAL TL1_g      : std_logic;
    SIGNAL TL1_y      : std_logic;
    SIGNAL TL1_r      : std_logic;
    SIGNAL TL2_g      : std_logic;
    SIGNAL TL2_y      : std_logic;
    SIGNAL TL2_r      : std_logic;

BEGIN

    uut: traffic_light
        PORT MAP (
            clk        => clk,
            reset      => reset,
            idle_mode  => idle_mode,
            TL1_g      => TL1_g,
            TL1_y      => TL1_y,
            TL1_r      => TL1_r,
            TL2_g      => TL2_g,
            TL2_y      => TL2_y,
            TL2_r      => TL2_r
        );

    clk_process : PROCESS
    BEGIN
        WHILE NOW < 2 us LOOP
            clk <= '0';
            WAIT FOR 5 ns;
            clk <= '1';
            WAIT FOR 5 ns;
        END LOOP;
        WAIT;  
    END PROCESS;

    test_start: PROCESS
    BEGIN
        -- Reset
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';

        -- Normal Run
        WAIT FOR 1 us;

        -- Idle
        idle_mode <= '1';

        WAIT FOR 800 ns;

        WAIT;
    END PROCESS;

END behavior;
