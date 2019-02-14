.PHONY: all clean
.SUFFIXES:	# disable built-in rules

TARGET := $(basename $(wildcard *.c *.s))

all: $(TARGET)

%: %.c
	gcc -o $@ $< -Wall -Werror

%.o: %.s
	as -o $@ $<

%: %.o
	ld -o $@ $<

clean:
	rm -f $(TARGET)
