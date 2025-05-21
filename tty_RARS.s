#  Template file with defines of peripheral registers
#  QtRVSim simulator https:#github.com/cvut/qtrvsim/
#
#  template.S       - example file
#
#  (C) 2021-2024 by Pavel Pisa
#      e-mail:   pisa@cmp.felk.cvut.cz
#      homepage: http:#cmp.felk.cvut.cz/~pisa
#      work:     http:#www.pikron.com/
#      license:  public domain

# Directives to make interesting windows visible
#pragma qtrvsim show terminal
#pragma qtrvsim show registers
#pragma qtrvsim show memory


.globl __start


# Serial port/terminal registers
# There is mirror of this region at address 0xffff0000
# to match QtSpim and Mars emulators

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
# MZ_APO education Zynq based board developed

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





.eqv screen_width, 0x00000200
.eqv newline_stack_pointer, 0x10040000
.eqv newline_stack_pointer_start_add, 0x10040004#0xffe4b004

__start:
_start:

loop:
    

# todo list: 

# add font size

# print the characters to the terminal as well as the screen

# take advantage of software interrupts? (read/write to file, etc)

# stop hardcoding the ASCII values being written to stack

# swap input check from polling to interrupt based




# current WIP (currently not breaking code/causing issues)

# add the rest of the letters and backspace, next line, etc. ---- alphabet, 
# backspace and newline are done


# started reallocating registers to allign with how they are supposed to be used
# ---- most registers reallocated, still need to look ffor ones I missed




# current WIP (currently breaking code/causing issues)









#done

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






    #start writing to screen      
    
    li a1, newline_stack_pointer
    li a2, newline_stack_pointer_start_add
    sw a2, 0(a1)

    li s1, LCD_FB_START #s7 is the cursor position
    li s2, LCD_FB_START #s8 is the address of the pixel being written to
    li s3, SERIAL_PORT_BASE # load base address of serial port
    
    addi t6, zero, 0x1
    
    
    
    
    #turn on colour interrupt
li t1, 0xf2 #set Digital lab sim to interrupt mode
li t2, 0xffff0012
sb t1, 0(t2)


li t0, 0xffffffff
csrrw zero, 4, t0 #enable all interrupts

 	la t0,interrupt_handler
 	csrrw zero, 5, t0 # set utvec (5) to the handlers address
 	csrrsi zero, 0, 1 # set interrupt enable bit in ustatus (0)

    start:
    j edge_case_handler_1
    
    
    interrupt_handler:
    csrrc t1, 66, zero #load the ucause value
    li t0, 0x80000008 #load the value of the digital lab sim ucause
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
    
    
    
    
    
    
    

    ebreak
    
    ebreak

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
    
    
    
    ebreak
    
    ebreak
    
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
    jal zero, input_check
    
    
    
    ebreak
   
    ebreak
    
    
    colour_warner:
    
    colour_warning_1: 
    bne s0, zero, colour_warning_2
    la a1, colour_warning_text_1 # load address of text
    add t6, ra, zero
    call serial_write
    add ra, t6, zero
    add a1, zero, zero
    jal zero, colour_warning_ret
    
    ebreak
    
    ebreak
    
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
    
    
    nop
    nop
    nop
    nop
    nop
    nop
    nop
  
   
 


        

    


    
  #  sw t1, 0(s6)  #test to see if RGB calcs working 
input_check:
    
    
  lb t0, 0(s3) #check for input
  beq t0, zero, start  #if there is no new inputs, return
  #ebreak
  #call colour_warner #
  
  li t1, 0xffff0004  #check for terminal input
  lw t3, 0(t1) #load character code
  slli t3, t3, 2 #multiply to align with instruction addresses
  auipc t0, 0
  addi t0, t0, 0x10
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
    nop # bell
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
    ret # unit seperator
    jal zero, chr_space # space
    nop # !
    nop # "
    nop # #
    nop # $
    nop # %
    nop # &
    jal zero, chr_apostraphe # ' --apostraphe
    nop # (
    nop # )
    nop # *
    nop # +
    jal zero, chr_comma # ,
    jal zero, chr_dash # -
    jal zero, chr_period # .
    jal zero, chr_slash # /
    ebreak #jal zero, chr_0 # 0
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
    nop # <
    nop # =
    nop # >
    nop # ?
    ebreak # @
    jal zero, chr_big_A # A
    jal zero, chr_big_B # B
    jal zero, chr_C # C
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
    nop # [
    nop # \
    nop # ]
    nop # ^
    ret # _
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
    nop # {
    nop # |
    nop # }
    ret # ~
    jal zero, del # delete
    ebreak
    nop
    nop 
    nop
    nop
    nop
    nop 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop  
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop  
    ecall #stop execution if unknown character
    
  #write letter A to screen
  chr_A:
  add s2, s1, zero #set pixel write adress to cursor position
    
    
  sw s4, 0(s2) #write one pixel to screen at the pixel write adress with the antiiliasing colour
  sw s0, 4(s2) #write one pixel to screen at one pixel ( half this number ->2(s2) ) right of the pixel write adress 
  sw s7, 8(s2)
  addi s2, s2, screen_width #move pixel write adress down one row
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2) #write two pixels, one at the pixel write adress and one to the right of the pixel write adressthe pixel write adress 
  sw s0, 4(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  
  addi t6, zero, 0x61 #load ascii value of this character 
  sb t6, 0(sp) #pop character into stack
  add t6, zero, zero #clear register
  addi sp, sp, 4 #increment stack pointer
  
  addi s1, s1, 16 #move cursor position right by 4 pixels
  jal zero, start #return

  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter B to screen
  chr_B:
  add s2, s1, zero
  
  sw s0, 0(s2)
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
    
  addi t6, zero, 0x62
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
    
  addi s1, s1, 16
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter C to screen
  chr_C:
  add s2, s1, zero
  
  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  
  addi t6, zero, 0x63
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter D to screen
  chr_D:
  add s2, s1, zero

  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)  
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  
  addi t6, zero, 0x64
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start

  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter E to screen
  chr_E:
  add s2, s1, zero

  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)  
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  
  addi t6, zero, 0x65
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start

  nop
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  
  #write letter F to screen
  chr_F:
  add s2, s1, zero

  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)  
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  
  addi t6, zero, 0x66
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start

  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter G to screen
  chr_G:
  add s2, s1, zero
  
  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2) 
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2) 
  addi s2, s2, screen_width
  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  sh s4, 12(s2)
  
  addi t6, zero, 0x67
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 20
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter H to screen
  chr_H:
  add s2, s1, zero

  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2) 
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2)
  
  addi t6, zero, 0x68
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 20
  jal zero, start

  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter I to screen
  chr_I:
  add s2, s1, zero

  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  
    addi t6, zero, 0x69
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 8
  jal zero, start
  
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter J to screen
  chr_J:
  add s2, s1, zero
  
  sw s0, 4(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  
  addi t6, zero, 0x6a
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start

  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter k to screen
  chr_K:
  add s2, s1, zero

  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  sw s4, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s4, 8(s2)
  sw s0, 12(s2)
  
  addi t6, zero, 0x6b
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 20
  jal zero, start

  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  
  #write letter L to screen
  chr_L:
  add s2, s1, zero

  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  
  addi t6, zero, 0x6c
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter M to screen
  chr_M:
  add s2, s1, zero

  sw s0, 0(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 12(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s4, 4(s2)
  sw s0, 8(s2)
  sw s4, 12(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 16(s2)
  
  addi t6, zero, 0x6d
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 24
  jal zero, start

  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter N to screen
  chr_N:
  add s2, s1, zero

  sw s0, 0(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s4, 4(s2)
  sw s0, 8(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s4, 8(s2)
  sw s0, 12(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s4, 12(s2)
  sw s0, 16(s2)
  
  addi t6, zero, 0x6e
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 24
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter O to screen
  chr_O:
  add s2, s1, zero

  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  sw s4, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  sw s4, 12(s2)
  
  addi t6, zero, 0x6f
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 20
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter P to screen
  chr_P:
  add s2, s1, zero
  
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  
  addi t6, zero, 0x70
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter q to screen
  chr_Q:
  add s2, s1, zero
  
  sw s0, 4(s2)
  sw s0, 8(s2)
  sw s4, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s4, 4(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  sw s0, 8(s2)
  sw s0, 12(s2)
  sw s0, 16(s2)
  
  addi t6, zero, 0x71
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 24
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
     
  #write letter R to screen
  chr_R:
  add s2, s1, zero
  
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  
  addi t6, zero, 0x72
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter s to screen
  chr_S:
  add s2, s1, zero
  
  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  
  addi t6, zero, 0x73
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start

  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter t to screen
  chr_T:
  add s2, s1, zero
  
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  
  addi t6, zero, 0x74
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter U to screen
  chr_U:
  add s2, s1, zero
  
  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  sw s4, 12(s2)
  
  addi t6, zero, 0x75
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 20
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter V to screen
  chr_V:
  add s2, s1, zero
  
  sw s0, 0(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s4, 4(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  sw s4, 8(s2)
  sw s0, 12(s2)
  sw s4, 16(s2)
  addi s2, s2, screen_width
  sw s0, 8(s2)
  sw s4, 12(s2)
  
  addi t6, zero, 0x76
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 24
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter w to screen
  chr_W:
  add s2, s1, zero
  
  sw s0, 0(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  sw s0, 12(s2)
  sw s4, 16(s2)
  
  addi t6, zero, 0x77
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 24
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter x to screen
  chr_X:
  add s2, s1, zero
  
  sw s0, 0(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s0, 12(s2)
  sw s4, 16(s2)
  addi s2, s2, screen_width
  sw s4, 4(s2)
  sw s0, 8(s2)
  sw s4, 12(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  sw s4, 8(s2)
  sw s0, 12(s2)
  sw s4, 16(s2) 
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s4, 4(s2)
  sw s0, 16(s2)
  
  addi t6, zero, 0x78
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 24
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter y to screen
  chr_Y:
  add s2, s1, zero
  
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  
  addi t6, zero, 0x79
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write letter z to screen
  chr_Z:
  add s2, s1, zero
  
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s4, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  
  addi t6, zero, 0x7a
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start
  
  nop #free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  #write space to screen
  chr_space:
    addi t6, zero, 0x20 #load ascii value of this character 
  sb t6, 0(sp) #pop character into stack
  add t6, zero, zero #clear register
  addi sp, sp, 4 #increment stack pointer
  
  addi s1, s1, 16 #move cursor position right by 4 pixels 
  jal zero, start #return
  
  chr_newline:
  
  li t3, newline_stack_pointer
  lw t4, 0(t3) #load the adress for the newline stack
  
  addi t6, zero, 0x3b #load ascii value of this character 
  sb t6, 0(sp) #pop character into stack
  add t6, zero, zero #clear register
  addi sp, sp, 4 #increment stack pointer
  
  sh s1, 0(t4) #push the bottom half of the s1 register into the newline stack (reordered away from the newline stack adress load to reduce pipeline stalls
  addi t5, t4, 2 #increment newline stack
  sh t5, 0(t3)  #store newline stack pointer back
  
  li t1, screen_width
  addi s5, s5, 0x7 #s4 is current cursor height (how many pixels down from the top)
  mul t3, t1, s5
  #multiply the cursor height by the screen width to get the offset that is needed to go that many pixels down
  li t4, LCD_FB_START
  add s1, t3, t4 #add the offset to the value of the screen start and store it in the cursor position
  jal zero, start #return
  
  
  
  
  
    #delete letter
    del:
    li t6, 0x00000004  #0x80000001
    sub sp, sp, t6 #decrement stack pointer
    lw t3, 0(sp) #load character from stack
    sb zero, 0(sp) #delete character from stack
    slli t3, t3, 2
    
    auipc t0, 0
    addi t0, t0, 0x10
    add t3, t3, t0
   jalr zero, t3, 0
    chr_del_enc:
    jal zero, start #  ret
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
    ebreak #! #sometimesjumps here
    ebreak #"
    ebreak ##
    ebreak #$
    ebreak #%
    ebreak #&
    jal zero, dec_six_wide #' --apostraphe
    ebreak #(
    ebreak #)
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
    nop # <
    nop # =
    nop # >
    nop # ?
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
    nop # [
    nop # \
    nop # ]
    nop # ^
    nop # _   #why does this have to be removed
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
    nop #{
    nop #|
    nop #}
    ret #~
  

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
  add s2, s1, zero
  
  sw zero, 0(s2)
  sw zero, 4(s2)
  addi s2, s2, screen_width
  sw zero, 0(s2)
  sw zero, 4(s2)
  addi s2, s2, screen_width
  sw zero, 0(s2)
  sw zero, 4(s2)
  addi s2, s2, screen_width
  sw zero, 0(s2)
  sw zero, 4(s2)
  addi s2, s2, screen_width
  sw zero, 0(s2)
  sw zero, 4(s2)
  jal zero, start


  clr_one_at_chr_pointer_plus_2_px:
  add s2, s1, zero
  
  sw zero, 8(s2)
  addi s2, s2, screen_width
  sw zero, 8(s2)
  addi s2, s2, screen_width
  sw zero, 8(s2)
  addi s2, s2, screen_width
  sw zero, 8(s2)
  addi s2, s2, screen_width
  sw zero, 8(s2)
  
  jal zero, clr_two_at_chr_pointer

clr_two_at_chr_pointer_plus_2_px:
  add s2, s1, zero
  
  sw zero, 8(s2)
  sw zero, 12(s2)
  addi s2, s2, screen_width
  sw zero, 8(s2)
  sw zero, 12(s2)
  addi s2, s2, screen_width
  sw zero, 8(s2)
  sw zero, 12(s2)
  addi s2, s2, screen_width
  sw zero, 8(s2)
  sw zero, 12(s2)
  addi s2, s2, screen_width
  sw zero, 8(s2)
  sw zero, 12(s2)
  
  jal zero, clr_two_at_chr_pointer
  
  
  
  clr_one_at_chr_pointer_plus_4_px:
  add s2, s1, zero
  
  sw zero, 12(s2)
  addi s2, s2, screen_width
  sw zero, 12(s2)
  addi s2, s2, screen_width
  sw zero, 12(s2)
  addi s2, s2, screen_width
  sw zero, 12(s2)
  addi s2, s2, screen_width
  sw zero, 12(s2)
  
  jal zero, clr_two_at_chr_pointer_plus_2_px

  clr_two_at_chr_pointer_plus_4_px:
  add s2, s1, zero
  
  sw zero, 12(s2)
  sw zero, 16(s2)
  addi s2, s2, screen_width
  sw zero, 12(s2)
  sw zero, 16(s2)
  addi s2, s2, screen_width
  sw zero, 12(s2)
  sw zero, 16(s2)
  addi s2, s2, screen_width
  sw zero, 12(s2)
  sw zero, 16(s2)
  addi s2, s2, screen_width
  sw zero, 12(s2)
  sw zero, 16(s2)
  
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
  
  jal zero, start











chr_apostraphe:

  add s2, s1, zero

  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s4, 4(s2)
  
  addi t6, zero, 0x27
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 12
  jal zero, start


chr_comma:

  add s2, s1, zero
  addi s2, s2, screen_width
  addi s2, s2, screen_width
  addi s2, s2, screen_width
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s4, 4(s2)
  
    addi t6, zero, 0x2c
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 12
  jal zero, start

chr_dash:

  add s2, s1, zero
  addi s2, s2, screen_width
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  sw s0, 12(s2)
  
    addi t6, zero, 0x2d
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
    addi s1, s1, 20
  jal zero, start

chr_period:

  add s2, s1, zero
  addi s2, s2, screen_width
  addi s2, s2, screen_width
  addi s2, s2, screen_width
  addi s2, s2, screen_width
  sw s0, 0(s2)
  
    addi t6, zero, 0x2e
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 8
  jal zero, start

chr_slash: 
  add s2, s1, zero
 
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 12(s2)
  sw s4, 16(s2)
  addi s2, s2, screen_width
  sw s0, 8(s2)
  sw s4, 12(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s4, 4(s2)
  
  addi t6, zero, 0x2f
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 24
  jal zero, start



chr_0:
  add s2, s1, zero

  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  sw s4, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  sw s4, 12(s2)
  
  addi t6, zero, 0x6f
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 20
  jal zero, start

chr_1:

  add s2, s1, zero

  sw s4, 0(s2)
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  addi t6, zero, 0x31
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start
  
  
  
  
  
  
  chr_2:

  add s2, s1, zero

  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  
  addi t6, zero, 0x32
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start
  
  
  
  
  
  chr_3:

  add s2, s1, zero

  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)

  
  addi t6, zero, 0x33
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start
  
  
  
    chr_4:

  add s2, s1, zero

  sw s4, 8(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s4, 4(s2)
  sw s0, 8(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 12(s2)

  
  addi t6, zero, 0x34
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 8
  
  addi s1, s1, 10
  jal zero, start
  
  
  
  chr_5:

  add s2, s1, zero

  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)

  
  addi t6, zero, 0x35
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start
  
  
  
  
  chr_6:

  add s2, s1, zero
  
  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)

  
  addi t6, zero, 0x36
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start
  
  
  
  
  
  chr_7:

  add s2, s1, zero

  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s4, 4(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s4, 4(s2)

  
  addi t6, zero, 0x37
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 16
  jal zero, start
  
  
  chr_8:
  add s2, s1, zero
  
  sw s0, 4(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 12(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  sw s0, 8(s2)
    
  addi t6, zero, 0x38
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
    
  addi s1, s1, 20
  jal zero, start
  
  chr_9:
  add s2, s1, zero
  
  sw s4, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 4(s2)
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s4, 8(s2)
   
    
  addi t6, zero, 0x39
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
    
  addi s1, s1, 16
  jal zero, start
  
  chr_colon:
  
  add s2, s1, zero

  sw s0, 0(s2)
  addi s2, s2, screen_width
  addi s2, s2, screen_width
  addi s2, s2, screen_width
  addi s2, s2, screen_width
  sw s0, 0(s2)
  
  addi t6, zero, 0x3a
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 8
  jal zero, start
  
  
  
  
    
  
  chr_big_A:
  add s2, s1, zero #set pixel write adress to cursor position
    
  sw s7, 16(s2)
  sw s4, 20(s2)
  sw s4, 24(s2)
  sw s4, 28(s2)
  sw s7, 32(s2)
  addi s2, s2, screen_width
  
  sw s4, 16(s2)
  sw s0, 20(s2)
  sw s0, 24(s2)
  sw s0, 28(s2)
  sw s4, 32(s2)
  addi s2, s2, screen_width
  
  sw s0, 16(s2)
  sw s0, 20(s2)
  sw s4, 24(s2)
  sw s0, 28(s2)
  sw s0, 32(s2)
  addi s2, s2, screen_width
  
  sw s0, 16(s2)
  sw s0, 20(s2)
  sw s7, 24(s2)
  sw s0, 28(s2)
  sw s0, 32(s2)
  addi s2, s2, screen_width
  
  sw s7, 12(s2)
  sw s0, 16(s2)
  sw s4, 20(s2)
  sw s7, 24(s2)
  sw s4, 28(s2)
  sw s0, 32(s2)
  sw s7, 36(s2)
  addi s2, s2, screen_width
  
  sw s4, 12(s2)
  sw s0, 16(s2)
  sw s7, 20(s2)
  sw s7, 28(s2)
  sw s0, 32(s2)
  sw s4, 36(s2)
  addi s2, s2, screen_width
  
  sw s0, 12(s2)
  sw s0, 36(s2)
  addi s2, s2, screen_width
  
  sw s0, 12(s2)
  sw s0, 16(s2)
  sw s0, 20(s2)
  sw s0, 24(s2)
  sw s0, 28(s2)
  sw s0, 32(s2)
  sw s0, 36(s2)
  addi s2, s2, screen_width
  
  sw s7, 8(s2)
  sw s0, 12(s2)
  sw s4, 16(s2)
  sw s4, 32(s2)
  sw s0, 36(s2)
  sw s7, 40(s2)
  addi s2, s2, screen_width
  
  sw s4, 8(s2)
  sw s0, 12(s2)
  sw s7, 16(s2)
  sw s7, 32(s2)
  sw s0, 36(s2)
  sw s4, 40(s2)
  addi s2, s2, screen_width
  
  sw s0, 8(s2)
  sw s4, 12(s2)
  sw s4, 36(s2)
  sw s0, 40(s2)
  
  addi t6, zero, 0x61 
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  
  
  
  addi s1, s1, 48
  jal zero, start
  
  
  
  chr_big_B:
  add s2, s1, zero #set pixel write adress to cursor position
  

  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  sw s0, 12(s2)
  sw s4, 16(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s7, 4(s2)
  sw s4, 8(s2)
  sw s0, 12(s2)
  sw s0, 16(s2)
  sw s7, 20(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s7, 4(s2)
  sw s4, 12(s2)
  sw s0, 16(s2)
  sw s7, 20(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s7, 4(s2)
  sw s0, 16(s2)
  sw s7, 20(s2)
  
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s7, 4(s2)
  sw s4, 8(s2)
  sw s0, 12(s2)
  sw s0, 16(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  sw s0, 12(s2)
  sw s4, 16(s2)
  
  
 addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s7, 4(s2)
  sw s7, 8(s2)
  sw s4, 12(s2)
  sw s0, 16(s2)
  sw s7, 20(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s7, 4(s2)
  sw s0, 16(s2)
  sw s4, 20(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s7, 4(s2)
  sw s0, 16(s2)
  sw s4, 20(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s7, 4(s2)
  sw s4, 12(s2)
  sw s0, 16(s2)
  sw s7, 20(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  sw s0, 8(s2)
  sw s0, 12(s2)
  sh s4, 16(s2)
  
  addi t6, zero, 0x62
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 4
  
  addi s1, s1, 32
  jal zero, start
  
  






    ebreak # stop continuous execution, request developer interaction
fmax.s ft0, ft1, ft2


.data
error_1: .asciz  "ERROR: stack overflow"   # store zero terminated ASCII text
error_2: .asciz  "ERROR: cursor overflow"   # store zero terminated ASCII text
colour_warning_text_1: .asciz "WARNING:you have not chosen a text colour" # store zero terminated ASCII text
colour_warning_text_2: .asciz  "WARNING: text colour may be too dark to see"   # store zero terminated ASCII text 






# if whole source compile is OK the switch to core tab
#pragma qtrvsim tab core

# The sample can be compiled by full-featured riscv64-unknown-elf GNU tool-chain
# for RV32IMA use
# riscv64-unknown-elf-gcc -c -march=rv64ima -mabi=lp64 template.S
# riscv64-unknown-elf-gcc -march=rv64ima -mabi=lp64 -nostartfiles -nostdlib template.o
# for RV64IMA use
# riscv64-unknown-elf-gcc -c -march=rv32ima -mabi=ilp32 template.S
# riscv64-unknown-elf-gcc -march=rv32ima -mabi=ilp32 -nostartfiles -nostdlib template.o
# add "-o template" to change default "a.out" output file name
