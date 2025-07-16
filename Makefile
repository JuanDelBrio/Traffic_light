ENTITY=traffic_light
ARCHITECTURE=behavior

SRC=$(ENTITY).vhdl

VCD_FILE=wave.vcd

GHDL=ghdl
FLAGS=--std=08

all: analyze, elaborate and run

analyze:
	$(GHDL) -a $(FLAGS) $(SRC)

elaborate:
	$(GHDL) -e $(FLAGS) $(ENTITY)

run:
	$(GHDL) -r $(FLAGS) $(ENTITY) --vcd=$(VCD_FILE)

clean:
	rm -f *.o *.cf $(ENTITY) $(VCD_FILE)

wave:
	gtkwave $(VCD_FILE)
