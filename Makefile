MAIN=traffic_light_TB
VCD_FILE=TL_wave.vcd
GHDL=ghdl
FLAGS=--std=08

all: analyze elaborate run clean

analyze:
	$(GHDL) -a $(FLAGS) TrafficLight.vhd
	$(GHDL) -a $(FLAGS) $(MAIN).vhd

elaborate:
	$(GHDL) -e $(FLAGS) $(MAIN)

run:
	$(GHDL) -r $(FLAGS) $(MAIN) --vcd=$(VCD_FILE)

clean:
	-rm -v *.o *.cf
