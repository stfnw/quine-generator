SRC        := basis.s
BUILD_DIR  := build
TARGET     := $(BUILD_DIR)/quine
TARGET_SRC := $(BUILD_DIR)/quine.s


.PHONY: all clean run test


all: test

$(TARGET_SRC): $(SRC) $(BUILD_DIR)/data
	@printf '\x1b[32m[+] Generating Program Source $@\n\x1b[39m'
	cat $^ > $@

$(BUILD_DIR)/data: $(SRC) | $(BUILD_DIR)
	@printf '\x1b[32m[+] Encoding code $< as hex data into $@\n\x1b[39m'
	{ \
		printf 'enc:    .byte   ' ;\
		hexdump -v -e '1/1 "0x%02x, "' $< | sed 's/, $$//' ;\
		echo   '' ;\
		echo   '        .equ    enc_len,.-enc' ;\
	} > $@

$(BUILD_DIR) $(CODE_DIR) $(DATA_DIR):
	mkdir -p $@


run: $(TARGET) $(TARGET).src

$(BUILD_DIR)/%.src: $(BUILD_DIR)/%
	@printf '\x1b[32m[+] Running the quine program\n\x1b[39m'
	./$< > $@

test: $(TARGET_SRC) $(TARGET).src
	@printf '\x1b[32m[+] Testing, whether the quine output is the same as the quine\n\x1b[39m'
	diff -qs $^


clean:
	rm -rf $(BUILD_DIR)


%.o: %.s
	as -o $@ $<

$(TARGET): %: %.o
	ld -o $@ $<
