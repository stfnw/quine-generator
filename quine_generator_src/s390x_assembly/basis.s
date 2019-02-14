.global _start
.section .text


/***************************************************************************
 * main code -- content can be (almost) arbitrary                          *
 *                                                                         *
 * for example here: if user provided a command line argument, then print  *
 * the first one; otherwise (if no arguments are provided), print its own  *
 * source code                                                             *
 ***************************************************************************/

_start:
        lgr     %r13,%r15               # backup initial stack pointer
        agfi    %r15,-160

        # initial stack layout (taken from ELF ABI Supplement, page 22):
        # HIGH         ...
        #              arg pointers (2-words each; first one points to name/path of program)
        # LOW  %r15 -> arg count (2-words)
        lg      %r0,0(%r13)             # fetch arg count

        clfi    %r0,1
        jh      .arg                    # if user arg provided, print first user supplied arg
.quine: bras    %r14,print_src          # else, print the source code of the program
        j       .end
.arg:   bras    %r14,print_first_arg

.end:   xr      %r2,%r2
        svc     1


print_first_arg:
        stmg    %r11,%r15,88(%r15)
        agfi    %r15,-160

        lg      %r1,16(%r13)            # fetch address of first user-supplied arg (skipping program name)

                                        #/ determine arg length (arg is null-terminated string)
        lgfi    %r4,-1                  #| r4 = index register (at end: contains length of arg)
.len:   agfi    %r4,1                   #|
        ic      %r2,0(%r4,%r1)          #| fetch byte of arg
        clfi    %r2,0                   #| test if end reached
        jne     .len                    #\

        lgfi    %r0,'\n'                # overwrite nullbyte with newline
        stc     %r0,0(%r4,%r1)
        agfi    %r4,1                   # include newline in output


.write: lgfi    %r2,1                   # write out the arg
        lgr     %r3,%r1
        svc     4

        lmg     %r11,%r15,248(%r15)
        br      %r14


/***************************************************************************
 * routine for printing the encoded data as both code and data             *
 * (can be conveniently placed at the end of the file, including data)     *
 ***************************************************************************/

print_src:
        stmg    %r11,%r15,88(%r15)
        agfi    %r15,-160

        bras    %r14,print_data_as_code
        bras    %r14,print_data_as_data

        lmg     %r11,%r15,248(%r15)
        br      %r14


print_data_as_code:
        stmg    %r11,%r15,88(%r15)
        agfi    %r15,-160

        lgfi    %r2,1
        larl    %r3,enc
        lgfi    %r4,enc_len
        svc     4

        lmg     %r11,%r15,248(%r15)
        br      %r14


print_data_as_data:
        stmg    %r11,%r15,88(%r15)
        agfi    %r15,-160

        bras    %r14,decode

        lgfi    %r2,1                       # print prefix
        larl    %r3,prefix
        lgfi    %r4,prefix_len
        svc     4

        lgfi    %r2,1                       # print decoded data
        larl    %r3,dec
        lgfi    %r4,dec_len
        svc     4

        lgfi    %r2,1                       # print suffix
        larl    %r3,suffix
        lgfi    %r4,suffix_len
        svc     4

        lmg     %r11,%r15,248(%r15)
        br      %r14


decode:
        stmg    %r6,%r15,48(%r15)
        agfi    %r15,-160

        larl    %r13,vars

        lgfi    %r7,0                       # r7 - index register, pos in enc
        lgfi    %r8,enc_len                 # r8 - number of input bytes

.loop:  sll     %r7,1                       #/ r10 - index register, pos in dec
        lgr     %r10,%r7                    #| r10 = 6*r7   (temp register, see dec_len: output size = 6 * input size)
        sll     %r10,2                      #| 6x = 8x - 2x = x<<2 - x<<1
        slr     %r10,%r7                    #|
        srl     %r7,1                       #\ restore r7

        lgfi    %r9,'0'                     #/ r9 - temp register for storing prefix '0x'
        stc     %r9,dec-.data(%r10,%r13)    #|
        lgfi    %r9,'x'                     #|
        stc     %r9,dec+1-.data(%r10,%r13)  #\

        icy     %r0,enc-.data(%r7,%r13)     # fetch byte
        lgr     %r1,%r0
        nill    %r0,0xf                     # r0 - low nibble
        srl     %r1,4                       # r1 - high nibble

        clfi    %r1,9                       #/ convert high hex-nibble
        jh      .alphh                      #|
.numh:  ahi     %r1,'0'                     #| 0x30
        j       .conth                      #|
.alphh: ahi     %r1,'a'-10                  #| 0x37
.conth: stc     %r1,dec+2-.data(%r10,%r13)  #\ store %r1 at dec[6*r7+2]

        clfi    %r0,9                       #/ convert low hex-nibble
        jh      .alphl                      #|
.numl:  ahi     %r0,'0'                     #| 0x30
        j       .contl                      #|
.alphl: ahi     %r0,'a'-10                  #| 0x37
.contl: stc     %r0,dec+3-.data(%r10,%r13)  #\ store %r0 at dec[6*r7+3]

        lgfi    %r9,','                     #/ r9 - temp register for storing suffix ', '
        stc     %r9,dec+4-.data(%r10,%r13)  #|
        lgfi    %r9,' '                     #|
        stc     %r9,dec+5-.data(%r10,%r13)  #\

        afi     %r7,1
        clr     %r7,%r8                     # processed all input data?
        jl      .loop

        lmg     %r6,%r15,208(%r15)
        br      %r14


.align  8
.section .data
vars:
dec:    .zero   dec_len
        .equ    dec_len,6*enc_len-2         # e.g. 0xff -> '0xff, '; for each byte in, write six byte out (without trailing ', ')
        .zero   2                           # padding for trailing ', '
.align  8
prefix: .ascii  "enc:    .byte   "
        .equ    prefix_len,.-prefix
suffix: .ascii  "\n        .equ    enc_len,.-enc\n"
        .equ    suffix_len,.-suffix
.align  8
