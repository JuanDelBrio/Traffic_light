ENTITY=traffic_light_TB
ARCHITECTURE=behavior

SRC=TrafficLight.vhd $(ENTITY).vhd

VCD_FILE=TL_wave.vcd

GHDL=ghdl
FLAGS=--std=08

all: analyze elaborate run

analyze:
	$(GHDL) -a $(FLAGS) TrafficLight.vhd
	$(GHDL) -a $(FLAGS) $(ENTITY).vhd

elaborate:
	$(GHDL) -e $(FLAGS) $(ENTITY)

run:
	$(GHDL) -r $(FLAGS) $(ENTITY) --vcd=$(VCD_FILE)

clean:
	-rm -v *.o *.cf $(ENTITY) $(VCD_FILE) ghdl*.cf work*.cf || true