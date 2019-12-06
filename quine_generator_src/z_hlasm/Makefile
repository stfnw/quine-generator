SRC        := basis.hlasm
BUILD_DIR  := build
TARGET_SRC := $(BUILD_DIR)/quine.hlasm

# if you want to generate the final quine source code on x86, set this variable nonempty (then an extra conversion from ASCII to EBCDIC will be made)
# in USS on the mainframe EBDIC is the default
TEST_X86   := YES

.PHONY: all clean


# afterwards run in MVS by submitting the JCL QUINECLG
all: $(TARGET_SRC)


$(TARGET_SRC): $(SRC) $(BUILD_DIR)/data
	@printf '\x1b[32m[+] Generating Program Source $@\n\x1b[39m'
	cat $^ > $@

# conversion is not only dependend on encoding (ASCII vs EBCDIC)
# but also on the different handling of line/record endings on the platform
# => also pad with spaces to the desired record length (here e.g. 80)
$(BUILD_DIR)/$(SRC): $(SRC) | $(BUILD_DIR)
	if [ -n "$(TEST_X86)" ] ; then \
		cat $< | awk '{printf "%-80s", $$0}' \
		       | iconv -f ASCII -t IBM1047 > $@ ;\
	else cp $< $@ ; fi

$(BUILD_DIR)/data: $(BUILD_DIR)/$(SRC) | $(BUILD_DIR)
	@printf '\x1b[32m[+] Encoding code $< as hex data into $@\n\x1b[39m'
	{ \
		echo 'DATAENC  DS    0D' ;\
		od -An -tx1 -v $< \
		    | tr 'a-f' 'A-F' \
		    | tr -d ' \r\n' \
		    | fold -b -w 50 \
		    | sed "s/^/         DC    X'/" \
		    | sed "s/$$/'/" ;\
		echo ;\
		echo 'ENCLEN   EQU   *-DATAENC' ;\
		echo ;\
		echo '         END' ;\
	} > $@

$(BUILD_DIR) $(CODE_DIR) $(DATA_DIR):
	mkdir -p $@


clean:
	rm -rf $(BUILD_DIR)
