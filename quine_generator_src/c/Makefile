SRC := basis.c

BUILD_DIR := build

TARGET_SRC := $(BUILD_DIR)/quine.c
TARGET     := $(BUILD_DIR)/quine

CFLAGS := -Wall -Werror -std=c99


.PHONY: all clean run test



all: test

$(TARGET_SRC): $(BUILD_DIR)/data $(SRC)
	@printf '\x1b[32m[+] Generating Program Source $@\n\x1b[39m'
	cat $^ > $@

$(BUILD_DIR)/data: $(SRC) | $(BUILD_DIR)
	@printf '\x1b[32m[+] Encoding code $< as numerical data into $@\n\x1b[39m'
	{ \
		echo 'char data[] = {' ;\
		hexdump -v -e '20/1 "%3d," "\n"' $< | sed 's/   ,//g' ;\
		echo '};' ;\
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
