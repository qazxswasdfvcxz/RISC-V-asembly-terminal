
.globl __start

.eqv SERIAL_PORT_BASE,      0xffff0000 # base address of serial port region

.eqv SERP_RX_ST_REG,        0xffff0008 # Receiver status register
.eqv SERP_RX_ST_REG_o,          0x0000 # Offset of RX_ST_REG
.eqv SERP_RX_ST_REG_READY_m,       0x1 # Data byte is ready to be read
.eqv SERP_RX_ST_REG_IE_m,          0x2 # Enable Rx ready interrupt

.eqv SERP_RX_DATA_REG,      0xffff0004 # Received data byte in 8 LSB bits
.eqv SERP_RX_DATA_REG_o,        0x0004 # Offset of RX_DATA_REG

.eqv SERP_TX_ST_REG,        0xffff0008 # Transmitter status register
.eqv SERP_TX_ST_REG_o,          0x0008 # Offset of TX_ST_REG
.eqv SERP_TX_ST_REG_READY_m,       0x1 # Transmitter can accept next byte
.eqv SERP_TX_ST_REG_IE_m,          0x2 # Enable Tx ready interrupt

.eqv SERP_TX_DATA_REG,      0xffff000c # Write word to send 8 LSB bits to terminal
.eqv SERP_TX_DATA_REG_o,        0x000c # Offset of TX_DATA_REG

# Memory mapped peripheral for dial knobs input,
# LED and RGB LEDs output designed to match
# MZ_APO education Zynq based board developed
# by Petr Porazil and Pavel Pisa at PiKRON.com company

.eqv SPILED_REG_BASE,       0xffffc100 # base of SPILED port region

.eqv SPILED_REG_LED_LINE,   0xffffc104 # 32 bit word mapped as output
.eqv SPILED_REG_LED_LINE_o,     0x0004 # Offset of the LED_LINE
.eqv SPILED_REG_LED_RGB1,   0xffffc110 # RGB LED 1 color components
.eqv SPILED_REG_LED_RGB1_o,     0x0010 # Offset of LED_RGB1
.eqv SPILED_REG_LED_RGB2,   0xffffc114 # RGB LED 2 color components
.eqv SPILED_REG_LED_RGB2_o,     0x0014 # Offset of LED_RGB2
.eqv SPILED_REG_KNOBS_8BIT, 0xffffc124 # Three 8 bit knob values
.eqv SPILED_REG_KNOBS_8BIT_o,   0x0024 # Offset of KNOBS_8BIT

# The simple 16-bit per pixel (RGB565) frame-buffer
# display size is 480 x 320 pixel
# Pixel format RGB565 expect
#   bits 11 .. 15 red component
#   bits  5 .. 10 green component
#   bits  0 ..  4 blue component
.eqv LCD_FB_START,          0x10010000#0x10000000#0x10040000
.eqv LCD_FB_END,            0xffe4afff

# RISC-V ACLINT MSWI and MTIMER memory mapped peripherals
.eqv ACLINT_MSWI,           0xfffd0000 # core 0 SW interrupt request
.eqv ACLINT_MTIMECMP,       0xfffd4000 # core 0 compare value
.eqv ACLINT_MTIME,          0xfffdbff8 # timer base 10 MHz

# Mapping of interrupts
# mcause      mie / mip
# irq number    bit       Source
#   3            3        ACLINT MSWI
#   7            7        MTIME reached value of MTIMECMP
#  16           16        There is received character ready to be read
#  17           17        Serial port ready to accept character to Tx

# Start address after reset


.text




.eqv stack_start, 0x7fffeffc
.eqv screen_width, 0x00000200
.eqv screen_width2, 0x00000800
.eqv newline_stack_pointer, 0x10040000
.eqv newline_stack_pointer_start_add, 0x10040004#0xffe4b004

__start:
_start:

loop:
    

# todo list: 

# add font size





# current WIP (currently not breaking code/causing issues)

# add the rest of the letters and backspace, next line, etc. ---- alphabet, 
# backspace and newline are done


# started reallocating registers to allign with how they are supposed to be used
# ---- most registers reallocated, still need to look for ones I missed




# current WIP (currently breaking code/causing issues)





#done

# take advantage of software interrupts? (read/write to file, etc)

# stop hardcoding the ASCII values being written to stack

# swap input check from polling to interrupt based

# delete characters from file

# print the characters to the terminal as well as the screen


# store the written text for later use for shell commands, ETC

# optimise how the letters are found (instead of doing a BEQ of every letter, perhaps a JALR of 
# the letter value to go to another jump that goes to the letter print function, this will stop
# the nested if:else loops and make all letters have the same processing latency

# fix occasional crash when deleting spaces, fix some letters not being cleared correctly when being
# deleted ---- same bug, the chr_del_enc was misaligned (EG: it thoight it was deleting a H when it
# was deleting an I)

# use more indirect jumps to decrease the amount of painful recalculation (see
# code to delete characters)

# added some error detection (see edge_case_handler_1, 2, etc)

# added manual bitmasking for the colour calcs. much slower, but makes it easier to swap to only 
# recalculating the colour values that changed instead of all of them

# stop RGB values being recalculated when it is not neccacary
# BONUS POINTS: only recalculate the colour values that changed instead of all of 
# them ---- did not get bonus points :(

# add notification if you have text colour too close to black ---- currently only
# activates on pure black, currently spams terminal with warnings ----FIXED & FULLY implemted

# LED RGB 1 now shows the text colour

#all characters are antialiased

# redone colour calc to work with RARS digital lab sim

li s9, screen_width
li s8, 0x0 #s8 is the background colour
#open file
  li   a7, 1024     # system call for open file
  la   a0, fout     # output file name
  li   a1, 9        # Open for writing (flags are 0: read, 1: write)
  ecall             # open a file (file descriptor returned in a0)
  mv   s2, a0       # save the file descriptor



    #start writing to screen      
    
    li a1, newline_stack_pointer
    li a2, newline_stack_pointer_start_add
    sw a2, 0(a1)

    li s1, LCD_FB_START #s7 is the cursor position
    li t5, LCD_FB_START #t5 is the address of the pixel being written to
    li s3, SERIAL_PORT_BASE # load base address of serial port
    
   # addi t6, zero, 0x1 #why was this here?
    
    
    #set default colour to white
    li s0, 0xffffff
    li s4, 0x808080
    li s7, 0x404040
    
    
    
    
    #turn on colour interrupt
li t1, 0xf2 #set Digital lab sim to interrupt mode
li t2, 0xffff0012
sb t1, 0(t2)

not t1, zero #set keyboard to interrupt mode
li t2, 0xffff0000
sb t1, 0(t2)


li t0, 0xffffffff
csrrw zero, 4, t0 #enable all interrupts

 	la t0,interrupt_handler
 	csrrw zero, 5, t0 # set utvec (5) to the handlers address
 	csrrsi zero, 0, 1 # set interrupt enable bit in ustatus (0)

    start:
    j edge_case_handler_1
    
    
    interrupt_handler:
    
    csrrc t1, 67, zero #load the ucause value
    li t0, 0x40 #load the value of the digital lab sim ucause
    beq t0, t1, input_check #if the interrupt is because of the keyboard, jump to input check
    li t0, 0x200 #load the value of the digital lab sim ucause
    beq t0, t1, colour_calc #if the interrupt is because of the digital lab sim, jump to colour calc
    ebreak #if it is because of an unknown interrupt, stop execution
    
    
    
    
    
    colour_calc:
    
        #row 1
    	li t0, 0xffff0012
	li t1, 0xf1 #set Digital lab sim to interrupt mode
        sb t1, 0(t0)
        lh t2, 2(t0)
        beq t2, zero, row_2
        
        li t0, 0x1
        sub t2, t2, t0
        auipc t0, 0
        add t0, t0, t2
        jalr t0, 0
        
      #  ebreak
        ebreak
        j DLS_0#0
        ebreak
        ebreak
        ebreak
        j DLS_1#1
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        j DLS_2#2
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        j DLS_3#3
        ebreak
        ebreak
        ebreak
        ebreak
        
        DLS_0: #remove blue
        li t0, 0xffffff00
        and s0, s0, t0
        and s4, s4, t0
        and s7, s7, t0
        uret
        DLS_1: #remove green
        li t0, 0xffff00ff
        and s0, s0, t0
        and s4, s4, t0
        and s7, s7, t0
        uret
        DLS_2: #remove red
        li t0, 0xff00ffff
        and s0, s0, t0
        and s4, s4, t0
        and s7, s7, t0
        uret
        DLS_3: #remove all
        and s0, zero, zero
        and s4, zero, zero
        and s7, zero, zero
        uret
        
        
        row_2:
        addi t1, t1, 0x1
        sb t1, 0(t0)
        lh t2, 2(t0)
        beq t2, zero, row_3
        
        li t0, 0x2
        sub t2, t2, t0
        auipc t0, 0
        add t0, t0, t2
        jalr t0, 0
        
      #  ebreak
        ebreak
        j DLS_4#0
        ebreak
        ebreak
        ebreak
        j DLS_5#1
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        j DLS_6#2
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        j DLS_7#3
        ebreak
        ebreak
        ebreak
        ebreak
        
        DLS_4: #set  blue
        
        li t0, 0xffffff00
        and s0, s0, t0
        and s4, s4, t0
        and s7, s7, t0
        ori s0, s0, 0x55
        ori s4, s4, 0x2b
        ori s4, s4, 0x16
        uret
        DLS_5: #set green
        
        li t0, 0xffff00ff
        and s0, s0, t0
        and s4, s4, t0
        and s7, s7, t0
        li t1, 0x5500
        or s0, s0, t1
        li t1, 0x2b00
        or s4, s4, t1
        li t1, 0x1600
        or s7, s7, t1
        uret
        DLS_6: #set red
        
        li t0, 0xff00ffff
        and s0, s0, t0
        and s4, s4, t0
        and s7, s7, t0
        li t1, 0x550000
        or s0, s0, t1
        li t1, 0x2b0000
        or s4, s4, t1
        li t1, 0x160000
        or s7, s7, t1
        uret
        DLS_7:#set all
        li s0, 0x555555
        li s4, 0x2b2b2b
        li s7, 0x161616
        uret
        
        
        
        
        row_3:
        addi t1, t1, 0x2
        sb t1, 0(t0)
        lh t2, 2(t0)
        beq t2, zero, row_4
        
        li t0, 0x4
        sub t2, t2, t0
        auipc t0, 0
        add t0, t0, t2
        jalr t0, 0
        
      #  ebreak
        ebreak
        j DLS_8#0
        ebreak
        ebreak
        ebreak
        j DLS_9#1
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        j DLS_a#2
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        j DLS_b#3
        ebreak
        ebreak
        ebreak
        ebreak
        
        DLS_8: #set  blue
        li t0, 0xffffff00
        and s0, s0, t0
        and s4, s4, t0
        and s7, s7, t0
        ori s0, s0, 0xaa
        ori s4, s4, 0x55
        ori s7, s7, 0x2b
        uret
        DLS_9: #set green
        li t0, 0xffff00ff
        and s0, s0, t0
        and s4, s4, t0
        and s7, s7, t0
        li t1, 0xaa00
        or s0, s0, t1
        li t1, 0x5500
        or s4, s4, t1
        li t1, 0x2b00
        or s7, s7, t1
        uret
        DLS_a: #set red
        li t0, 0xff00ffff
        and s0, s0, t0
        and s4, s4, t0
        and s7, s7, t0
        li t1, 0xaa0000
        or s0, s0, t1
        li t1, 0x550000
        or s4, s4, t1
        li t1, 0x2b0000
        or s7, s7, t1
        uret
        DLS_b:#set all
        li s0, 0xaaaaaa
        li s4, 0x555555
        li s7, 0x2b2b2b
        uret
        
        
        
        row_4:
        addi t1, t1, 0x4
        sb t1, 0(t0)
        lh t2, 2(t0)
        beq t2, zero, no_row
        
        li t0, 0x8
        sub t2, t2, t0
        auipc t0, 0
        add t0, t0, t2
        jalr t0, 0
        
      #  ebreak
        ebreak
        j DLS_c#0
        ebreak
        ebreak
        ebreak
        j DLS_d#1
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        j DLS_e#2
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        ebreak
        j DLS_f#3
        ebreak
        ebreak
        ebreak
        ebreak
        
        DLS_c: #set  blue
        li t0, 0xffffff00
        and s0, s0, t0
        and s4, s4, t0
        and s7, s7, t0
        ori s0, s0, 0xff
        ori s4, s4, 0x80
        ori s7, s7, 0x40
        uret
        DLS_d: #set green
        li t0, 0xffff00ff
        and s0, s0, t0
        and s4, s4, t0
        and s7, s7, t0
        li t1, 0xff00
        or s0, s0, t1
        li t1, 0x8000
        or s4, s4, t1
        li t1, 0x4000
        or s7, s7, t1
        uret
        DLS_e: #set red
        li t0, 0xff00ffff
        and s0, s0, t0
        and s4, s4, t0
        and s7, s7, t0
        li t1, 0xff0000
        or s0, s0, t1
        li t1, 0x800000
        or s4, s4, t1
        li t1, 0x400000
        or s7, s7, t1
        uret
        DLS_f:#set all
        li s0, 0xffffff
        li s4, 0x808080
        li s7, 0x404040
        uret
        
        
        no_row:
        uret
    
    
    

    
    

    
    
    not s1, zero #test
        
    #call input_check #call edge_case_handler_1
    jal zero, edge_case_handler_1
    
    
    
    
    
    
    



    #currently set to stop on error values, commented instructions are for automatically fixing the values
    edge_case_handler_1: #if the stack pointer is lower then it is supposed to be, this is expected behavior when sending delete chr command with no text so it is kept as auto-fix
    
    li t0, 0x7fffeffc # load the default stack pointer value 
    li t1, 0x10040000
    
    blt sp, t0 edge_case_handler_2  #beq t0, sp, edge_case_handler_2  # if the stack pointer isn't greater than or equal to the default stack pointer value, continue
    bgt sp, t1 edge_case_handler_2 #bgt sp, t0, edge_case_handler_2  
    add sp, t0, zero #set the stack pointer to the default stack pointer value
    la a1, error_1 # load address of text
    call serial_write
    add a1, zero, zero
    jal zero, edge_case_handler_2
    
    
    

    
    edge_case_handler_2: 
    #li t2, LCD_FB_START
    #beq s1, t2, edge_case_handler_end
    #bgt s1, t2, edge_case_handler_end
    #add s1, t2, zero
    #la a1, error_2 # load address of text
    #call serial_write
    #add a1, zero, zero
    jal zero, edge_case_handler_end
    
    
    edge_case_handler_end:
    jal zero, edge_case_handler_1
    
    
    

    
    
    colour_warner:
    
    colour_warning_1: 
    bne s0, zero, colour_warning_2
    la a1, colour_warning_text_1 # load address of text
    add t6, ra, zero
    call serial_write
    add ra, t6, zero
    add a1, zero, zero
    jal zero, colour_warning_ret
    

    
    colour_warning_2: 
   
    li t1, 0x20
    bgt s6, t1, colour_warning_ret
    la a1, colour_warning_text_2 # load address of text
    add t6, ra, zero
    call serial_write
    add ra, t6, zero
    add a1, zero, zero
    
    colour_warning_ret:
    jal zero, serial_write
    



    serial_write:
    li   a0, SERP_TX_ST_REG             # load base address of serial port
next_char:
    lb   t1, 0(a1)                      # load one byte after another
    beq  t1, zero, end_char             # is this the terminal zero byte
    addi a1, a1, 1                      # move pointer to next text byte
tx_busy:
    lw   t0, 0(a0)       # read status of transmitter
    andi t0, t0, SERP_TX_ST_REG_READY_m # mask ready bit
    beqz  t0, tx_busy              # if not ready wait for ready condition
    sw   t1, 4(a0)     # write byte to Tx data register
    jal  zero, next_char                # unconditional branch to process next byte
    end_char:
    ret
    
    

   
 


        

    


    
  #  sw t1, 0(s6)  #test to see if RGB calcs working 
input_check:
    
    
 # lb t0, 0(s3) #check for input
 # beq t0, zero, start  #if there is no new inputs, return
  #call colour_warner #
  
  
  
  li t1, 0xffff0004  #get terminal input
  lb t3, 0(t1) #load character code
  
  li t2, 0xffff000c       # system call for write to file
  sw t3, 0(t2)
  
    # Write to file just opened
#  li   a7, 64       # system call for write to file
#  mv   a0, s2       # file descriptor
#  mv   a1, t1   # address of buffer from which to write
#  li   a2, 1       # hardcoded buffer length
#  ecall             # write to file
  
  sb t3, 0(sp) #pop character into stack
  addi sp, sp, 1 # addi sp, sp, 4 #increment stack pointer
  
  
  slli t3, t3, 2 #multiply to align with instruction addresses
  la t0, chr_code
  add t3, t3, t0
  jalr zero, t3, 0 #indirect jump to write character
  chr_code:
    nop # null
    nop # start of heading
    nop # start of text
    nop # end of text
    nop # end of transmission
    nop # enquiry
    nop # acknowledge
    ebreak # bell
    jal zero, del # backspace
    jal zero, chr_space # horizantal tab
    nop # line feed
    jal zero, chr_newline # vertical tab
    nop # form feed
    nop # carriage return
    nop # shift out
    nop # shift in
    nop # data link escape
    nop # device control 1
    nop # device control 2
    nop # device control 3
    nop # device control 4
    nop # negative acknowledge
    nop # synchronous idle
    nop # end of trans. block
    nop # cancel
    nop # end of medium
    nop # substitute
    nop # escape
    nop # file seperator
    nop # group seperator
    nop # record seperator
    ebreak # unit seperator
    jal zero, chr_space # space
    jal zero, chr_exclamation_mark # !
    ebreak  # "
    jal zero, store_to_file # #
    nop # $
    nop # %
    ebreak # &
    jal zero, chr_apostraphe # ' --apostraphe
    jal zero, chr_start_bracket # (
    jal zero, chr_end_bracket # )
    nop # *
    ebreak # +
    jal zero, chr_comma # ,
    jal zero, chr_dash # -
    jal zero, chr_period # .
    jal zero, chr_slash # /
    jal zero, chr_0 # 0
    jal zero, chr_1 # 1
    jal zero, chr_2 # 2
    jal zero, chr_3 # 3
    jal zero, chr_4 # 4
    jal zero, chr_5 # 5
    jal zero, chr_6 # 6
    jal zero, chr_7 # 7
    jal zero, chr_8 # 8
    jal zero, chr_9 # 9
    jal zero, chr_colon # :
    jal zero, chr_newline # ; --semicolon, use as enter/newline
    jal zero, chr_greater_than# <
    jal zero, chr_equals # =
    jal zero, chr_less_than # >
    ebreak # ?
    jal zero, settings_edit # @
    jal zero, chr_big_A # A
    jal zero, chr_big_B # B
    jal zero, chr_big_C # C
    jal zero, chr_D # D
    jal zero, chr_E # E
    jal zero, chr_F # F
    jal zero, chr_G # G
    jal zero, chr_H # H
    jal zero, chr_I # I
    jal zero, chr_J # J
    jal zero, chr_K # K
    jal zero, chr_L # L
    jal zero, chr_M # M
    jal zero, chr_N # N
    jal zero, chr_O # O
    jal zero, chr_P # P
    jal zero, chr_Q # Q
    jal zero, chr_R # R
    jal zero, chr_S # S
    jal zero, chr_T # T
    jal zero, chr_U # U
    jal zero, chr_V # V
    jal zero, chr_W # W
    jal zero, chr_X # X
    jal zero, chr_Y # Y
    jal zero, chr_Z # Z
    jal zero, chr_start_square_bracket # [
    jal zero, chr_backslash # \
    jal zero, chr_end_square_bracket # ]
    jal zero, chr_xor # ^
    jal zero, chr_underscore # _
    jal zero, del # ` --grave accent, use as backspace
    jal zero, chr_A # a
    jal zero, chr_B # b
    jal zero, chr_C # c
    jal zero, chr_D # d
    jal zero, chr_E # e
    jal zero, chr_F # f
    jal zero, chr_G # g
    jal zero, chr_H # h
    jal zero, chr_I # i
    jal zero, chr_J # j
    jal zero, chr_K # k
    jal zero, chr_L # l
    jal zero, chr_M # m
    jal zero, chr_N # n
    jal zero, chr_O # o
    jal zero, chr_P # p
    jal zero, chr_Q # q
    jal zero, chr_R # r
    jal zero, chr_S # s
    jal zero, chr_T # t
    jal zero, chr_U # u
    jal zero, chr_V # v
    jal zero, chr_W # w
    jal zero, chr_X # x
    jal zero, chr_Y # y
    jal zero, chr_Z # z
    jal zero, chr_start_curly_bracket # {
    jal zero, chr_or # |
    jal zero, chr_end_curly_bracket # }
    ebreak # ~
    jal zero, del # delete

    
  #write letter A to screen
  chr_A:
  add t5, s1, zero #set pixel write adress to cursor position
    
    
  sw s4, 0(t5) #write one pixel to screen at the pixel write adress with the antiiliasing colour
  sw s0, 4(t5) #write one pixel to screen at one pixel ( half this number ->2(t5) ) right of the pixel write adress 
  sw s7, 8(t5)
  add t5, t5, s9 #move pixel write adress down one row
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5) #write two pixels, one at the pixel write adress and one to the right of the pixel write adressthe pixel write adress 
  sw s0, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)

  addi s1, s1, 16 #move cursor position right by 4 pixels
  uret #return
  
  #write letter B to screen
  chr_B:
  add t5, s1, zero
  
  sw s0, 0(t5)
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
    
  addi s1, s1, 16
  uret
  
  #write letter C to screen
  chr_C:
  add t5, s1, zero
  
  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  
  addi s1, s1, 16
  uret
  

  #write letter D to screen
  chr_D:
  add t5, s1, zero

  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)  
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)

  addi s1, s1, 16
  uret

  
  #write letter E to screen
  chr_E:
  add t5, s1, zero

  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)  
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)

  addi s1, s1, 16
  uret

  #write letter F to screen
  chr_F:
  add t5, s1, zero

  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)  
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  

  
  addi s1, s1, 16
  uret

  #write letter G to screen
  chr_G:
  add t5, s1, zero
  
  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5) 
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5) 
  add t5, t5, s9
  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sh s4, 12(t5)
  
  addi s1, s1, 20
  uret
  
  #write letter H to screen
  chr_H:
  add t5, s1, zero

  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5) 
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5)

  addi s1, s1, 20
  uret
  
  #write letter I to screen
  chr_I:
  add t5, s1, zero

  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)

  addi s1, s1, 8
  uret
  
  #write letter J to screen
  chr_J:
  add t5, s1, zero
  
  sw s0, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)
  
  addi s1, s1, 16
  uret

  #write letter k to screen
  chr_K:
  add t5, s1, zero

  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  sw s4, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 8(t5)
  sw s0, 12(t5)

  addi s1, s1, 20
  uret


  #write letter L to screen
  chr_L:
  add t5, s1, zero

  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  
  addi s1, s1, 16
  uret

  #write letter M to screen
  chr_M:
  add t5, s1, zero

  sw s0, 0(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 12(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 4(t5)
  sw s0, 8(t5)
  sw s4, 12(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 16(t5)

  addi s1, s1, 24
  uret


  
  #write letter N to screen
  chr_N:
  add t5, s1, zero

  sw s0, 0(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 4(t5)
  sw s0, 8(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 8(t5)
  sw s0, 12(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 12(t5)
  sw s0, 16(t5)

  addi s1, s1, 24
  uret
  
  
  #write letter O to screen
  chr_O:
  add t5, s1, zero

  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s4, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s4, 12(t5)

  addi s1, s1, 20
  uret
  

  #write letter P to screen
  chr_P:
  add t5, s1, zero
  
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)

  addi s1, s1, 16
  uret
  

  #write letter q to screen
  chr_Q:
  add t5, s1, zero
  
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s4, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 4(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s0, 12(t5)
  sw s0, 16(t5)

  addi s1, s1, 24
  uret
  

  #write letter R to screen
  chr_R:
  add t5, s1, zero
  
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)

  addi s1, s1, 16
  uret
  

  #write letter s to screen
  chr_S:
  add t5, s1, zero
  
  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)

  addi s1, s1, 16
  uret
  
  
  #write letter t to screen
  chr_T:
  add t5, s1, zero
  
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)

  addi s1, s1, 16
  uret


  #write letter U to screen
  chr_U:
  add t5, s1, zero
  
  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s4, 12(t5)

  addi s1, s1, 20
  uret
  
  
  #write letter V to screen
  chr_V:
  add t5, s1, zero
  
  sw s0, 0(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 4(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s4, 8(t5)
  sw s0, 12(t5)
  sw s4, 16(t5)
  add t5, t5, s9
  sw s0, 8(t5)
  sw s4, 12(t5)
  
  addi s1, s1, 24
  uret

  
  #write letter w to screen
  chr_W:
  add t5, s1, zero
  
  sw s0, 0(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)
  sw s0, 12(t5)
  sw s4, 16(t5)
  
  addi s1, s1, 24
  uret


  #write letter x to screen
  chr_X:
  add t5, s1, zero
  
  sw s0, 0(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s0, 12(t5)
  sw s4, 16(t5)
  add t5, t5, s9
  sw s4, 4(t5)
  sw s0, 8(t5)
  sw s4, 12(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s4, 8(t5)
  sw s0, 12(t5)
  sw s4, 16(t5) 
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 4(t5)
  sw s0, 16(t5)
  
  addi s1, s1, 24
  uret
  
  #write letter y to screen
  chr_Y:
  add t5, s1, zero
  
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)

  addi s1, s1, 16
  uret

  #write letter z to screen
  chr_Z:
  add t5, s1, zero
  
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  
  addi s1, s1, 16
  uret


  #write space to screen
  chr_space:
  addi s1, s1, 16 #move cursor position right by 4 pixels 
  uret #return
  
  chr_newline:
  
  li t3, newline_stack_pointer
  lw t4, 0(t3) #load the adress for the newline stack
  
  sh s1, 0(t4) #push the bottom half of the s1 register into the newline stack (reordered away from the newline stack adress load to reduce pipeline stalls
  addi t5, t4, 2 #increment newline stack
  sh t5, 0(t3)  #store newline stack pointer back
  
  li t1, screen_width
  addi s5, s5, 0x7 #s4 is current cursor height (how many pixels down from the top)
  mul t3, t1, s5
  #multiply the cursor height by the screen width to get the offset that is needed to go that many pixels down
  li t4, LCD_FB_START
  add s1, t3, t4 #add the offset to the value of the screen start and store it in the cursor position
  uret #return
  
  
  
  
  
    #delete letter
    del:
    li t6, 2#0x00000004  #0x80000001
    sub sp, sp, t6 #decrement stack pointer
    lb t3, 0(sp) #load character from stack
    sb zero, 0(sp) #delete character from stack
    sb zero, 1(sp)
    slli t3, t3, 2
    

    
  
    
    la t0, chr_del_enc
    add t3, t3, t0
    
   jalr zero, t3, 0
    chr_del_enc:
    uret
    uret
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    jal zero, del_newline
    jal zero, del_newline
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    ebreak
    jal zero, dec_eight_wide #space
    jal zero, dec_four_wide #!
    ebreak #"
    ebreak ##
    ebreak #$
    ebreak #%
    ebreak #&
    jal zero, dec_six_wide #' --apostraphe
    jal zero, dec_six_wide #(
    jal zero, dec_six_wide #)
    ebreak #*
    ebreak #+
    jal zero, dec_six_wide #,
    jal zero, dec_ten_wide #-
    jal zero, dec_four_wide #.
    jal zero, dec_twelve_wide #/
    jal zero, dec_ten_wide #0
    jal zero, dec_eight_wide #1
    jal zero, dec_eight_wide #2
    jal zero, dec_eight_wide #3
    jal zero, dec_ten_wide #4
    jal zero, dec_eight_wide #5
    jal zero, dec_eight_wide #6
    jal zero, dec_eight_wide #7
    jal zero, dec_ten_wide #8
    jal zero, dec_eight_wide #9
    jal zero, dec_four_wide #:
    jal zero, del_newline #; --semicolon, use as newline
    jal zero, dec_eight_wide # <
    jal zero, dec_ten_wide # =
    jal zero, dec_eight_wide # >
    ebreak # ?
    ebreak #@
    ebreak #A
    ebreak #B
    ebreak #C
    ebreak #D
    ebreak #E
    ebreak #F
    ebreak #G
    ebreak #H
    ebreak #I
    ebreak #J
    ebreak #K
    ebreak #L
    ebreak #M
    ebreak #N
    ebreak #O
    ebreak #P
    ebreak #Q
    ebreak #R
    ebreak #S
    ebreak #T
    ebreak #U
    ebreak #V
    ebreak #W
    ebreak #X
    ebreak #Y
    ebreak #Z
    jal zero, dec_six_wide # [
    jal zero, dec_twelve_wide # \
    jal zero, dec_six_wide # ]
    jal zero, dec_eight_wide # ^
    jal zero, dec_ten_wide # _
    ebreak#` --grave accent, use as backspace
    jal zero, dec_eight_wide #a
    jal zero, dec_eight_wide #b
    jal zero, dec_eight_wide #c
    jal zero, dec_eight_wide #d
    jal zero, dec_eight_wide #e
    jal zero, dec_eight_wide #f 
    jal zero, dec_ten_wide#g
    jal zero, dec_ten_wide#h
    jal zero, dec_four_wide#i
    jal zero, dec_eight_wide#j
    jal zero, dec_ten_wide#k
    jal zero, dec_eight_wide#l
    jal zero, dec_twelve_wide#m
    jal zero, dec_twelve_wide#n
    jal zero, dec_ten_wide#o
    jal zero, dec_eight_wide#p
    jal zero, dec_twelve_wide#q
    jal zero, dec_eight_wide#r
    jal zero, dec_eight_wide#s
    jal zero, dec_eight_wide#t
    jal zero, dec_ten_wide#u
    jal zero, dec_twelve_wide#v
    jal zero, dec_twelve_wide#w
    jal zero, dec_twelve_wide#x
    jal zero, dec_eight_wide#y
    jal zero, dec_eight_wide#z
    jal zero, dec_eight_wide #{
    jal zero, dec_four_wide #|
    jal zero, dec_eight_wide #}
    ebreak #~
  

  dec_four_wide:
  li t6, 0x00000008  
  sub s1, s1, t6 #move character pointer left by two pixels
  
  jal zero, clr_two_at_chr_pointer
  
    
    
  dec_six_wide:
  li t6, 0x0000000c
  sub s1, s1, t6 #move character pointer left by two pixels
  
  jal zero, clr_one_at_chr_pointer_plus_2_px
    
  dec_eight_wide:
  li t6, 0x00000010
  sub s1, s1, t6 
  
  jal zero, clr_two_at_chr_pointer_plus_2_px
  
  dec_ten_wide:
  li t6, 0x00000014
  sub s1, s1, t6 
  
  jal zero, clr_one_at_chr_pointer_plus_4_px
  
  dec_twelve_wide:
  li t6, 0x00000018
  sub s1, s1, t6 
  
  jal zero, clr_two_at_chr_pointer_plus_4_px


clr_two_at_chr_pointer:
  add t5, s1, zero
  
  sw s8, 0(t5)
  sw s8, 4(t5)
  add t5, t5, s9
  sw s8, 0(t5)
  sw s8, 4(t5)
  add t5, t5, s9
  sw s8, 0(t5)
  sw s8, 4(t5)
  add t5, t5, s9
  sw s8, 0(t5)
  sw s8, 4(t5)
  add t5, t5, s9
  sw s8, 0(t5)
  sw s8, 4(t5)
  uret


  clr_one_at_chr_pointer_plus_2_px:
  add t5, s1, zero
  
  sw s8, 8(t5)
  add t5, t5, s9
  sw s8, 8(t5)
  add t5, t5, s9
  sw s8, 8(t5)
  add t5, t5, s9
  sw s8, 8(t5)
  add t5, t5, s9
  sw s8, 8(t5)
  
  jal zero, clr_two_at_chr_pointer

clr_two_at_chr_pointer_plus_2_px:
  add t5, s1, zero
  
  sw s8, 8(t5)
  sw s8, 12(t5)
  add t5, t5, s9
  sw s8, 8(t5)
  sw s8, 12(t5)
  add t5, t5, s9
  sw s8, 8(t5)
  sw s8, 12(t5)
  add t5, t5, s9
  sw s8, 8(t5)
  sw s8, 12(t5)
  add t5, t5, s9
  sw s8, 8(t5)
  sw s8, 12(t5)
  
  jal zero, clr_two_at_chr_pointer
  
  
  
  clr_one_at_chr_pointer_plus_4_px:
  add t5, s1, zero
  
  sw s8, 12(t5)
  add t5, t5, s9
  sw s8, 12(t5)
  add t5, t5, s9
  sw s8, 12(t5)
  add t5, t5, s9
  sw s8, 12(t5)
  add t5, t5, s9
  sw s8, 12(t5)
  
  jal zero, clr_two_at_chr_pointer_plus_2_px

  clr_two_at_chr_pointer_plus_4_px:
  add t5, s1, zero
  
  sw s8, 12(t5)
  sw s8, 16(t5)
  add t5, t5, s9
  sw s8, 12(t5)
  sw s8, 16(t5)
  add t5, t5, s9
  sw s8, 12(t5)
  sw s8, 16(t5)
  add t5, t5, s9
  sw s8, 12(t5)
  sw s8, 16(t5)
  add t5, t5, s9
  sw s8, 12(t5)
  sw s8, 16(t5)
  
  jal zero, clr_two_at_chr_pointer_plus_2_px
  
  
  
  
  del_newline:
  
    li t3, newline_stack_pointer
  lw t4, 0(t3) #load the adress for the newline stack
  

  li t6, 0x2
  sub t4, t4, t6 #decrement newline stack
  lh t5, 0(t4) #pop from the newline stack
  
  srli t1, s1, 16
  slli t1, t1, 16
  
  add s1, t1, t5
  sh zero, 0(t4) #zero stack (reordered away from the newline stack adress load to reduce pipeline stalls
  sh t4, 0(t3)  #store newline stack pointer back
  
  uret











chr_apostraphe:

  add t5, s1, zero

  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 4(t5)
  
  addi s1, s1, 12
  uret


chr_comma:

  add t5, s1, zero
  add t5, t5, s9
  add t5, t5, s9
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 4(t5)
  
  addi s1, s1, 12
  uret

chr_dash:

  add t5, s1, zero
  add t5, t5, s9
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s0, 12(t5)

  addi s1, s1, 20
  uret
  
  chr_underscore:
  add t5, s1, zero
  add t5, t5, s9
  add t5, t5, s9
  add t5, t5, s9
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s0, 12(t5)

  addi s1, s1, 20
  uret
  
  
  chr_equals:
  add t5, s1, zero
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s0, 12(t5)

  addi s1, s1, 20
  uret

chr_period:
  
  li t0, screen_width
  slli t0, t0, 2
  add t5, s1, t0

  sw s0, 0(t5)
  
  addi s1, s1, 8
  uret

chr_slash: 
  add t5, s1, zero
 
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 12(t5)
  sw s4, 16(t5)
  add t5, t5, s9
  sw s0, 8(t5)
  sw s4, 12(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 4(t5)

  addi s1, s1, 24
  uret

chr_backslash: 
  add t5, s1, zero
 
  sw s0, 0(t5)
  add t5, t5, s9
  sw s4, 0(t5)
  sw s0, 4(t5)
  add t5, t5, s9
  sw s4, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s4, 8(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s4, 12(t5)
  sw s0, 16(t5)

  addi s1, s1, 24
  uret

chr_greater_than:
  add t5, s1, zero
 
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 8(t5)


  addi s1, s1, 16
  uret
   
  chr_less_than:
  add t5, s1, zero
 
  sw s0, 0(t5)
  add t5, t5, s9
  sw s4, 0(t5)
  sw s0, 4(t5)
  add t5, t5, s9
  sw s4, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s4, 0(t5)
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)

  addi s1, s1, 16
  uret
  
  chr_or:
  add t5, s1, zero

  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)

  addi s1, s1, 8
  uret
  
  chr_xor:
    add t5, s1, zero

  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s7, 4(t5)
  sw s0, 8(t5)

  addi s1, s1, 16
  uret
  
chr_0:
  add t5, s1, zero

  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s4, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s4, 12(t5)
  
  addi s1, s1, 20
  uret

chr_1:

  add t5, s1, zero

  sw s4, 0(t5)
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  
  addi s1, s1, 16
  uret
  
  chr_2:

  add t5, s1, zero

  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)

  addi s1, s1, 16
  uret 
  
  chr_3:

  add t5, s1, zero
  

  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)

  addi s1, s1, 16
  uret
 
    chr_4:

  add t5, s1, zero

  sw s4, 8(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s4, 4(t5)
  sw s0, 8(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 12(t5)

  addi s1, s1, 20
  uret

  chr_5:

  add t5, s1, zero

  sw s0, 0(s1)
  sw s0, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)

  addi s1, s1, 16
  uret

  chr_6:

  add t5, s1, zero
  
  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)

  addi s1, s1, 16
  uret

  chr_7:

  add t5, s1, zero

  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 8(t5)
  add t5, t5, s9
  sw s4, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 4(t5)

  addi s1, s1, 16
  uret
  
  chr_8:
  add t5, s1, zero
  
  sw s0, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 12(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s0, 8(t5)

  addi s1, s1, 20
  uret
  
  chr_9:
  add t5, s1, zero
  
  sw s4, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s4, 8(t5)

  addi s1, s1, 16
  uret
  
  chr_colon:
  
  add t5, s1, zero

  sw s0, 0(t5)
  add t5, t5, s9 #replace with mul
  add t5, t5, s9
  add t5, t5, s9
  add t5, t5, s9
  sw s0, 0(t5)

  addi s1, s1, 8
  uret

  chr_exclamation_mark:
    add t5, s1, zero

  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  add t5, t5, s9
  sw s0, 0(t5)
  
  addi s1, s1, 8
  uret
  
  chr_start_bracket:
    add t5, s1, zero
  
  sw s4, 0(t5)
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s4, 0(t5)
  sw s0, 4(t5)
  
  addi s1, s1, 12
  uret
  
  chr_end_bracket:
  add t5, s1, zero
  
  sw s0, 0(t5)
  sw s4, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 4(t5)
  
  addi s1, s1, 12
  uret

  chr_start_square_bracket:
  add t5, s1, zero
  
  sw s0, 0(t5)
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  
  addi s1, s1, 12
  uret
  
  chr_end_square_bracket:
  add t5, s1, zero
  
  sw s0, 0(t5)
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  
  addi s1, s1, 12
  uret
  
  chr_start_curly_bracket:
  add t5, s1, zero
  
  sw s4, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s4, 4(t5)
  sw s0, 8(t5)
  
  addi s1, s1, 16
  uret
  
  chr_end_curly_bracket:
  add t5, s1, zero
  
  sw s0, 0(t5)
  sw s4, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s0, 8(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s4, 4(t5)
  
  addi s1, s1, 16
  uret
  
  chr_big_A:
  add t5, s1, zero #set pixel write adress to cursor position
    
  sw s7, 16(t5)
  sw s4, 20(t5)
  sw s4, 24(t5)
  sw s4, 28(t5)
  sw s7, 32(t5)
  add t5, t5, s9
  sw s4, 16(t5)
  sw s0, 20(t5)
  sw s0, 24(t5)
  sw s0, 28(t5)
  sw s4, 32(t5)
  add t5, t5, s9
  sw s0, 16(t5)
  sw s0, 20(t5)
  sw s4, 24(t5)
  sw s0, 28(t5)
  sw s0, 32(t5)
  add t5, t5, s9
  sw s0, 16(t5)
  sw s4, 20(t5)
  sw s4, 28(t5)
  sw s0, 32(t5)
  add t5, t5, s9
  sw s7, 12(t5)
  sw s0, 16(t5)
  sw s7, 20(t5)
  sw s7, 28(t5)
  sw s0, 32(t5)
  sw s7, 36(t5)
  add t5, t5, s9
  sw s4, 12(t5)
  sw s0, 16(t5)
  sw s0, 32(t5)
  sw s4, 36(t5)
  add t5, t5, s9
  sw s0, 12(t5)
  sw s4, 16(t5)
  sw s4, 32(t5)
  sw s0, 36(t5)
  add t5, t5, s9
  sw s0, 12(t5)
  sw s0, 16(t5)
  sw s0, 20(t5)
  sw s0, 24(t5)
  sw s0, 28(t5)
  sw s0, 32(t5)
  sw s0, 36(t5)
  add t5, t5, s9
  sw s7, 8(t5)
  sw s0, 12(t5)
  sw s4, 16(t5)
  sw s4, 32(t5)
  sw s0, 36(t5)
  sw s7, 40(t5)
  add t5, t5, s9
  sw s4, 8(t5)
  sw s0, 12(t5)
  sw s7, 16(t5)
  sw s7, 32(t5)
  sw s0, 36(t5)
  sw s4, 40(t5)
  add t5, t5, s9
  sw s0, 8(t5)
  sw s4, 12(t5)
  sw s4, 36(t5)
  sw s0, 40(t5)

  addi s1, s1, 48
  uret
  
  
  
  chr_big_B:
  add t5, s1, zero

  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s0, 12(t5)
  sw s4, 16(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s7, 4(t5)
  sw s4, 8(t5)
  sw s0, 12(t5)
  sw s0, 16(t5)
  sw s7, 20(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s7, 4(t5)
  sw s4, 12(t5)
  sw s0, 16(t5)
  sw s7, 20(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s7, 4(t5)
  sw s0, 16(t5)
  sw s7, 20(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s7, 4(t5)
  sw s4, 8(t5)
  sw s0, 12(t5)
  sw s0, 16(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s0, 12(t5)
  sw s4, 16(t5)
 add t5, t5, s9
  sw s0, 0(t5)
  sw s7, 4(t5)
  sw s7, 8(t5)
  sw s4, 12(t5)
  sw s0, 16(t5)
  sw s7, 20(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s7, 4(t5)
  sw s0, 16(t5)
  sw s4, 20(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s7, 4(t5)
  sw s0, 16(t5)
  sw s4, 20(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s7, 4(t5)
  sw s4, 12(t5)
  sw s0, 16(t5)
  sw s7, 20(t5)
  add t5, t5, s9
  sw s0, 0(t5)
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s0, 12(t5)
  sh s4, 16(t5)

  addi s1, s1, 32
  uret
  
  
  
    chr_big_C:
  add t5, s1, zero
  
  
  #sw s7, 20(t5)
  #sw s7, 24(t5)
  #sw s7, 28(t5)
  #sw s7, 32(t5)
  #add t5, t5, s9
  sw s7, 12(t5)
  sw s4, 16(t5)
  sw s0, 20(t5)
  sw s0, 24(t5)
  sw s0, 28(t5)
  sw s0, 32(t5)
  add t5, t5, s9
  sw s4, 8(t5)
  sw s0, 12(t5)
  sw s0, 16(t5)
  sw s0, 20(t5)
  sw s4, 24(t5)
  add t5, t5, s9
  sw s4, 4(t5)
  sw s0, 8(t5)
  sw s0, 12(t5)
  sw s4, 16(t5)
  sw s7, 20(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s7, 12(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s4, 8(t5)
  add t5, t5, s9
  sw s0, 4(t5)
  sw s0, 8(t5)
  sw s7, 12(t5)
  add t5, t5, s9
  sw s4, 4(t5)
  sw s0, 8(t5)
  sw s0, 12(t5)
  sw s4, 16(t5)
  sw s7, 20(t5)
  add t5, t5, s9
  sw s4, 8(t5)
  sw s0, 12(t5)
  sw s0, 16(t5)
  sw s0, 20(t5)
  sw s4, 24(t5)
  add t5, t5, s9
  sw s7, 12(t5)
  sw s4, 16(t5)
  sw s0, 20(t5)
  sw s0, 24(t5)
  sw s0, 28(t5)
  sw s0, 32(t5)

  addi s1, s1, 40
  uret
  
  
  
  
  settings_edit:
  #edit screen resolution
  li a7, 51
  la a0, screen_width_req
  li a2, 4
  ecall
  li a7, 51 #does this do anything?
  bltz a1, skip_editing_scrn_width
  mv t0, a0
  
  li a7, 51
  la a0, unit_width_req
  ecall
  bltz a1, skip_editing_scrn_width
  
  li t1, screen_width2
  slli t1, t0, 2
  div s9, t1, a0
  j edit_BG_colour 
  
  skip_editing_scrn_width:
  li a7, 4
  la a0, skip_editing_setting
  ecall
  
  
  
  
  edit_BG_colour:
  li a7, 51
  la a0, screen_height_req
  li a2, 4
  ecall
  
  bltz a1, skip_BG_colour_change
  mv t0, a0
  
  li a7, 51
  la a0, unit_height_req
  ecall
  
  bltz a1, skip_editing_scrn_width
  
  div t1, t0, a0 #number of rows to draw
  mul t1, t1, s9 #multiplied by the number of collums
  
  #addi t1, t1, -4 #don't recolour the bottom right pight pixel(for testing)
  
  li t4, LCD_FB_START
  
  #get new BG colour
  
  li a7, 54
  la a0, get_new_bg_colour
  li a1, 0x100401a0
  add t0, a1, zero #save the address of the string
  li a2, 7
  ecall
  bltz a1, skip_BG_colour_change
  

  
  #cvt ascii code to colour
  
  lb a0, 0(t0) #load first character
  
  li a1, 79 #1001111
  and a0, a1, a0 # cvt capital letters to lowercase

  li a1, 64 #1000000 
  and a1, a1, a0

  bgtz a1, ascii_letter_to_binary_0
  
  addi a7, a0, 0
  j ascii_was_not_letter_0
  
  ascii_letter_to_binary_0:
  not a1, a1
  and a0, a1, a0 #remove that 1
  
  addi a7, a0, 9
  ascii_was_not_letter_0:
  #repeat for the rest of the numbers
  slli a7, a7, 20


  lb a0, 1(t0) #load second character
  
  li a1, 79 #1001111
  and a0, a1, a0 # cvt capital letters to lowercase
  li a1, 64 #1000000 
  and a1, a1, a0
  bgtz a1, ascii_letter_to_binary_1
  
  j ascii_was_not_letter_1
  
  ascii_letter_to_binary_1:
  not a1, a1
  and a0, a1, a0 #remove that 1
  addi a0, a0, 9

  ascii_was_not_letter_1:
  
  slli a0, a0, 16
  or a7, a0, a7
  
  
  
  
  #------------
   lb a0, 2(t0) #load third character
  
  li a1, 79 #1001111
  and a0, a1, a0 # cvt capital letters to lowercase
  li a1, 64 #1000000 
  and a1, a1, a0
  bgtz a1, ascii_letter_to_binary_2
  
  j ascii_was_not_letter_2
  
  ascii_letter_to_binary_2:
  not a1, a1
  and a0, a1, a0 #remove that 1
  addi a0, a0, 9

  ascii_was_not_letter_2:
  
  slli a0, a0, 12
  or a7, a0, a7
  
 
  #------------
   lb a0, 3(t0) #load fourth character
  
  li a1, 79 #1001111
  and a0, a1, a0 # cvt capital letters to lowercase
  li a1, 64 #1000000 
  and a1, a1, a0
  bgtz a1, ascii_letter_to_binary_3
  
  j ascii_was_not_letter_3
  
  ascii_letter_to_binary_3:
  not a1, a1
  and a0, a1, a0 #remove that 1
  addi a0, a0, 9

  ascii_was_not_letter_3:
  
  slli a0, a0, 8
  or a7, a0, a7
  
    #------------
   lb a0, 4(t0) #load fifth character
  
  li a1, 79 #1001111
  and a0, a1, a0 # cvt capital letters to lowercase
  li a1, 64 #1000000 
  and a1, a1, a0
  bgtz a1, ascii_letter_to_binary_4
  
  j ascii_was_not_letter_4
  
  ascii_letter_to_binary_4:
  not a1, a1
  and a0, a1, a0 #remove that 1
  addi a0, a0, 9

  ascii_was_not_letter_4:
  
  slli a0, a0, 4
  or a7, a0, a7
  
  
      #------------
   lb a0, 5(t0) #load sixth character
  
  li a1, 79 #1001111
  and a0, a1, a0 # cvt capital letters to lowercase
  li a1, 64 #1000000 
  and a1, a1, a0
  bgtz a1, ascii_letter_to_binary_5
  
  j ascii_was_not_letter_5
  
  ascii_letter_to_binary_5:
  not a1, a1
  and a0, a1, a0 #remove that 1
  addi a0, a0, 9

  ascii_was_not_letter_5:
  
  or s8, a0, a7
  
  #new BG colour is stored in t6

  la a0, set_new_bg_colour
  li a7, 4
  ecall
  
  li a7, 34
  addi a0, s8, 0
  ecall
  
  li a7, 11
  li a0, 0x0a
  ecall

  start_BG_change_loop:
  sw s8, 0(t4)
  addi t4, t4, 4 #increment the pointer
  addi t1, t1, -4 #dec the counter
  bgtz t1, start_BG_change_loop
  
  j edit_font_colour
  
  
  skip_BG_colour_change:
  li a7, 4
  la a0, skip_editing_setting

  
  #todo: use this method of getting colours to change font colour
  edit_font_colour:
  
  
  li a7, 54
  la a0, req_new_font_colour
  li a1, 0x100401a0
  add t0, a1, zero #save the address of the string
  li a2, 7
  ecall
  bltz a1, skip_font_colour_change

    lb a0, 0(t0) #load first character
  
  li a1, 79 #1001111
  and a0, a1, a0 # cvt capital letters to lowercase

  li a1, 64 #1000000 
  and a1, a1, a0

  bgtz a1, ascii_letter_to_binary_01
  
  addi a7, a0, 0
  j ascii_was_not_letter_01
  
  ascii_letter_to_binary_01:
  not a1, a1
  and a0, a1, a0 #remove that 1
  
  addi a7, a0, 9
  ascii_was_not_letter_01:
  #repeat for the rest of the numbers
  slli a7, a7, 20


  lb a0, 1(t0) #load second character
  
  li a1, 79 #1001111
  and a0, a1, a0 # cvt capital letters to lowercase
  li a1, 64 #1000000 
  and a1, a1, a0
  bgtz a1, ascii_letter_to_binary_11
  
  j ascii_was_not_letter_11
  
  ascii_letter_to_binary_11:
  not a1, a1
  and a0, a1, a0 #remove that 1
  addi a0, a0, 9

  ascii_was_not_letter_11:
  
  slli a0, a0, 16
  or a7, a0, a7
  
  
  
  
  #------------
   lb a0, 2(t0) #load third character
  
  li a1, 79 #1001111
  and a0, a1, a0 # cvt capital letters to lowercase
  li a1, 64 #1000000 
  and a1, a1, a0
  bgtz a1, ascii_letter_to_binary_21
  
  j ascii_was_not_letter_21
  
  ascii_letter_to_binary_21:
  not a1, a1
  and a0, a1, a0 #remove that 1
  addi a0, a0, 9

  ascii_was_not_letter_21:
  
  slli a0, a0, 12
  or a7, a0, a7
  
 
  #------------
   lb a0, 3(t0) #load fourth character
  
  li a1, 79 #1001111
  and a0, a1, a0 # cvt capital letters to lowercase
  li a1, 64 #1000000 
  and a1, a1, a0
  bgtz a1, ascii_letter_to_binary_31
  
  j ascii_was_not_letter_31
  
  ascii_letter_to_binary_31:
  not a1, a1
  and a0, a1, a0 #remove that 1
  addi a0, a0, 9

  ascii_was_not_letter_31:
  
  slli a0, a0, 8
  or a7, a0, a7
  
    #------------
   lb a0, 4(t0) #load fifth character
  
  li a1, 79 #1001111
  and a0, a1, a0 # cvt capital letters to lowercase
  li a1, 64 #1000000 
  and a1, a1, a0
  bgtz a1, ascii_letter_to_binary_41
  
  j ascii_was_not_letter_41
  
  ascii_letter_to_binary_41:
  not a1, a1
  and a0, a1, a0 #remove that 1
  addi a0, a0, 9

  ascii_was_not_letter_41:
  
  slli a0, a0, 4
  or a7, a0, a7
  
  
      #------------
   lb a0, 5(t0) #load sixth character
  
  li a1, 79 #1001111
  and a0, a1, a0 # cvt capital letters to lowercase
  li a1, 64 #1000000 
  and a1, a1, a0
  bgtz a1, ascii_letter_to_binary_51
  
  j ascii_was_not_letter_51
  
  ascii_letter_to_binary_51:
  not a1, a1
  and a0, a1, a0 #remove that 1
  addi a0, a0, 9

  ascii_was_not_letter_51:
  
  or s0, a0, a7
  
  #new font colour is stored in s0

  la a0, set_new_font_colour
  li a7, 4
  ecall
  
  li a7, 34
  addi a0, s0, 0
  ecall
  
  li a7, 11
  li a0, 0x0a
  ecall
  
  
  #todo: recalculate the antiailiasing colours
  
  li a0, 0xff
  li a3, 2
  and a1, a0, s0
  and a2, a0, s8
  
  add a7, a1, a2
  div a7, a7, a3
  
  and a7, a7, a0 #idk if this is needed but it could stop some edge cases
  
  slli a0, a0, 8
  
  ebreak
  
  and a1, a0, s0
  and a2, a0, s8
  
  srli a1, a1, 8
  srli a2, a2, 8
  
  add a6, a1, a2
  div a6, a7, a3
  
  slli a6, a6, 8

  
  and a6, a6, a0 #idk if this is needed but it could stop some edge cases
  or a7, a6, a7
  
  slli a0, a0, 8
  
  and a1, a0, s0
  and a2, a0, s8
  
  srli a1, a1, 16
  srli a2, a2, 16
  
  add a6, a1, a2
  div a6, a7, a3
  
  slli a6, a6, 16
  
  and a6, a6, a0 #idk if this is needed but it could stop some edge cases
  or s4, a6, a7 #set antiailiasing colour 1

  
  skip_font_colour_change:
  li a7, 4
  la a0, skip_editing_setting

#todo: recalculate the antiailiasing colours 
#todo: add option to reprint all characters
  
  uret
  
store_to_file:

 # ebreak
    li a7, 50
    la a0, f_ask_loc
    ecall
    beqz a0, save_to_desktop
    addi t0, zero, 1
    beq t0, a0, save_to_documents
    
    li a7, 4 #if the user cancels, stop saving file
    la a0, f_save_cancelled
    li a1, 4
    ecall
    uret
    
    save_to_documents:
    li t3, 0x100400e0
    la t0, doc
    lb t1, 0(t0)
    sb t1, 0(t3)
    lb t1, 1(t0)
    sb t1, 1(t3)
    lb t1, 2(t0)
    sb t1, 2(t3)
    lb t1, 3(t0)
    sb t1, 3(t3)
    lb t1, 4(t0)
    sb t1, 4(t3)
    lb t1, 5(t0)
    sb t1, 5(t3)
    lb t1, 6(t0)
    sb t1, 6(t3)
    lb t1, 7(t0)
    sb t1, 7(t3)
    lb t1, 8(t0)
    sb t1, 8(t3)
    lb t1, 9(t0)
    sb t1, 9(t3)
    addi t3, t3, 10
    j get_filename
    save_to_desktop:
    li t3, 0x100400e0

    la t0, desk
    lb t1, 0(t0)
    sb t1, 0(t3)
    lb t1, 1(t0)
    sb t1, 1(t3)
    lb t1, 2(t0)
    sb t1, 2(t3)
    lb t1, 3(t0)
    sb t1, 3(t3)
    lb t1, 4(t0)
    sb t1, 4(t3)
    lb t1, 5(t0)
    sb t1, 5(t3)
    lb t1, 6(t0)
    sb t1, 6(t3)
    lb t1, 7(t0)
    sb t1, 7(t3)
    addi t3, t3, 8
    
    get_filename:
    li a7, 54 #get the file name and address
    la a0, fnam
    mv a1, t3
    li a2, 128
    ecall
    beqz a1, file_location_print
    
    li a7, 4
    la a0, f_save_cancelled #if the user cancels or gives a bad value, stop saving file #UNTESTED
    li a1, 4
    ecall
    uret
    
    
    file_location_print:
    li a7, 4 #print "saving file to"
    la a0, save_loc_notify
    ecall
    
    li a7, 4 #print the file location
    li a0,  0x100400e0
    ecall
    
    li a7, 11 #print newline
    li a0, 0x0a
    #ecall
    
    
     #test if file exists CURRENTLY NOT WORKING
     
#  li   a7, 1024     # system call for open file
#  li a0, 0x100400e0 # output file name
#  li   a1, 0#9        # Open for writing (flags are 0: read, 1: write)
#  ecall             # open a file (file descriptor returned in a0)

  
#  li a3, -1
#  beq a3, a0, file_write
    
    
#    li a7, 50
#    la a0, f_ask_file_overwrite
#    ecall
#    beqz a0, file_write
#    li a7, 55 #if the user says to not overwrite or cancels, stop saving file
#    la a0, f_save_cancelled
#    li a1, 4
#    ecall
#    uret
    
  
  
   
  
    file_write:
  andi a3, zero, 0
  li   a7, 1024     # system call for open file
  li a0, 0x100400e0 # output file name
  li   a1, 1        # Open for writing (flags are 0: read, 1: write)
  ecall             # open a file (file descriptor returned in a0)
  mv   t1, a0       # save the file descriptor
  
  li a3, -1
  bne a3, t1, file_length_calc
  
    li a7, 55 #if the OS fails to open file, notify user and cancel file saving
    la a0, f_write_failed
    li a1, 4
    ecall
    uret
  
  
  
  file_length_calc:
  li   t4, 0x7fffeffc  #t4 is the address of buffer from which to write
  sub  t0, sp, t4 #t0 is the number of characters to write
  addi  t0, t0, -1 #subtracting 1 to not save the hashtag that calls for the file to be saved
  
  li t5, 16
  
  li   a7, 64       # system call for write to file
  mv   a0, t1       # file descriptor
  mv   a1, t4   # address of buffer from which to write
  mv   a2, t0       # hardcoded buffer length
  ecall             # write to file
  
  uret
  
  
    ebreak # stop continuous execution, request developer interaction




ascii_to_colour_code:
#TODO
uret











.data
error_1: 
.asciz     "ERROR: stack overflow"   # store zero terminated ASCII text
error_2: 
.asciz  "ERROR: cursor overflow"   # store zero terminated ASCII text
colour_warning_text_1: 
.asciz "WARNING:you have not chosen a text colour" # store zero terminated ASCII text
colour_warning_text_2: 
.asciz  "WARNING: text colour may be too dark to see"   # store zero terminated ASCII text 

fout: .asciz "Desktop/testout.txt"      # filename for output

f_ask_loc: .string "would you like to save the file to the desktop?"
fnam: .string   "please write the location you want this file to be written to"   # store zero terminated ASCII text
f_save_cancelled: .ascii "file was not saved"
.byte 0x0a #manually adding newline character
.byte 00
f_save_failed: .string "failed to create file, cancelling"
f_write_failed: .string "failed to write to file, cancelling"
doc: .ascii "Documents/"
desk: .ascii "Desktop/"
save_loc_notify: .asciz "saving file to: "
f_ask_file_overwrite: .asciz "file already exists, do you want to append to it?"
screen_width_req: .asciz "what is the display width in pixels?"
unit_width_req: .asciz "what is the unit width in pixels?"
skip_editing_setting: .ascii "setting was unchanged"
.byte 0x0a
.byte 00

screen_height_req: .ascii "what is the display height in pixels?"
.byte 0x0a
req_for_bg_change_0: .asciz "(required for background change)"
unit_height_req: .ascii "what is the unit height in pixels?"
.byte 0x0a
req_for_bg_change_1: .asciz "(required for background change)"
get_new_bg_colour: .asciz "new background colour"

set_new_bg_colour: .asciz "setting background colour to "
req_new_font_colour: .asciz "new font colour"
set_new_font_colour: .asciz "setting font colour to "
