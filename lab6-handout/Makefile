SRC = $(wildcard src/*.c)
INPUT ?= $(wildcard 447inputs/*/*.x)

.PHONY: all verify clean

all: sim

sim: $(SRC)
	gcc -g -O2 $^ -o $@

verify: sim
	@./verify $(INPUT)

cyclediff: sim
	@./cyclediff $(INPUT)

clean:
	rm -rf *.o *~ sim
