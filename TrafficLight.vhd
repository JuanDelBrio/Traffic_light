LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY traffic_light IS
	PORT (clk: IN std_logic;
		  reset: IN std_logic;
		  idle_mode: IN std_logic;
		  TL1_g: OUT std_logic; --first traffic light green
		  TL1_y: OUT std_logic; --first traffic light yellow
		  TL1_r: OUT std_logic; --first traffic light red
		  TL2_g: OUT std_logic; --second traffic light green
		  TL2_y: OUT std_logic; --second traffic light yellow
		  TL2_r: OUT std_logic); --second traffic light red
END traffic_light;

ARCHITECTURE behavior OF traffic_light IS
	TYPE tl_state IS (first_g, first_y, second_g, second_y, all_red, idle); --check the status of the 2 traffic lights (green or yellow)
	SIGNAL previous_state, current_state, next_state: tl_state;
	SIGNAL timer: integer := 0;
	SIGNAL idle_blinker_counter: integer:= 0;
BEGIN
	state_sequence: PROCESS(clk, reset) --states order and timer settings
	BEGIN
	
		IF (reset = '1') THEN
			current_state <= first_g;
			timer <= 0;
		ELSE
			IF rising_edge(clk) THEN
				IF timer = 0 THEN
					previous_state <= current_state;
					current_state <= next_state;
					CASE next_state IS --timer duration
						WHEN first_g => timer <= 20;
						WHEN first_y => timer <= 6;
						WHEN second_g => timer <= 20;
						WHEN second_y => timer <= 6;
						WHEN all_red => timer <= 3;
						WHEN idle => timer <= 0;
					END CASE;
				ELSE
					timer <= timer - 1;
				END IF;
			END IF;
		END IF;
		
	END PROCESS;
	
	idle_blinker: PROCESS(clk, reset)
	BEGIN
	
		IF reset = '1' THEN
			idle_blinker_counter <= 0;
		ELSIF rising_edge(clk) THEN
			IF idle_mode = '1' THEN
				idle_blinker_counter <= idle_blinker_counter + 1;
				IF idle_blinker_counter >= 20 THEN
					idle_blinker_counter <= 0;
				END IF;
			ELSE
				idle_blinker_counter <= 0;
			END IF;
		END IF;
		
	END PROCESS;


	state_trasition: PROCESS(current_state) 
	BEGIN
	
		CASE current_state IS
			WHEN first_g => next_state <= first_y;
			WHEN first_y => next_state <= all_red;
			WHEN all_red =>
				IF previous_state = first_y THEN
					next_state <= second_g;
				ELSIF previous_state = second_y THEN
					next_state <= first_g;
				END IF;
			WHEN second_g => next_state <= second_y;
			WHEN second_y => next_state <= all_red;
			WHEN idle => next_state <= idle;
		END CASE;
		
	END PROCESS;
	
	
	tl_output: PROCESS(current_state) 
	BEGIN
		--TL default: all off
		TL1_g <= '0'; TL1_y <= '0'; TL1_r <= '0';
		TL2_g <= '0'; TL2_y <= '0'; TL2_r <= '0';
				
		IF idle_mode = '1' THEN
			IF idle_blinker_counter < 10 THEN
				TL1_y <= '1';
				TL2_y <= '1';
			END IF;
		ELSE
			CASE current_state IS
				WHEN first_g => TL1_g <= '1'; TL2_r <= '1'; 
				WHEN first_y => TL1_y <= '1'; TL2_r <= '1';
				WHEN second_g => TL2_g <= '1'; TL1_r <= '1'; 
				WHEN second_y => TL2_y <= '1'; TL1_r <= '1';
				WHEN all_red => TL1_r <= '1'; TL2_r <= '1';
				WHEN idle => NULL;
			END CASE;
		END IF;
		
	END PROCESS;
	
	
END behavior;