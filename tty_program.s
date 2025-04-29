//  Template file with defines of peripheral registers
//  QtRVSim simulator https://github.com/cvut/qtrvsim/
//
//  template.S       - example file
//
//  (C) 2021-2024 by Pavel Pisa
//      e-mail:   pisa@cmp.felk.cvut.cz
//      homepage: http://cmp.felk.cvut.cz/~pisa
//      work:     http://www.pikron.com/
//      license:  public domain

// Directives to make interesting windows visible
#pragma qtrvsim show terminal
#pragma qtrvsim show registers
#pragma qtrvsim show memory


.globl __start
.option norelax

// Serial port/terminal registers
// There is mirror of this region at address 0xffff0000
// to match QtSpim and Mars emulators

.equ SERIAL_PORT_BASE,      0xffffc000 // base address of serial port region

.equ SERP_RX_ST_REG,        0xffffc000 // Receiver status register
.equ SERP_RX_ST_REG_o,          0x0000 // Offset of RX_ST_REG
.equ SERP_RX_ST_REG_READY_m,       0x1 // Data byte is ready to be read
.equ SERP_RX_ST_REG_IE_m,          0x2 // Enable Rx ready interrupt

.equ SERP_RX_DATA_REG,      0xffffc004 // Received data byte in 8 LSB bits
.equ SERP_RX_DATA_REG_o,        0x0004 // Offset of RX_DATA_REG

.equ SERP_TX_ST_REG,        0xffffc008 // Transmitter status register
.equ SERP_TX_ST_REG_o,          0x0008 // Offset of TX_ST_REG
.equ SERP_TX_ST_REG_READY_m,       0x1 // Transmitter can accept next byte
.equ SERP_TX_ST_REG_IE_m,          0x2 // Enable Tx ready interrupt

.equ SERP_TX_DATA_REG,      0xffffc00c // Write word to send 8 LSB bits to terminal
.equ SERP_TX_DATA_REG_o,        0x000c // Offset of TX_DATA_REG

// Memory mapped peripheral for dial knobs input,
// LED and RGB LEDs output designed to match
// MZ_APO education Zynq based board developed
// by Petr Porazil and Pavel Pisa at PiKRON.com company

.equ SPILED_REG_BASE,       0xffffc100 // base of SPILED port region

.equ SPILED_REG_LED_LINE,   0xffffc104 // 32 bit word mapped as output
.equ SPILED_REG_LED_LINE_o,     0x0004 // Offset of the LED_LINE
.equ SPILED_REG_LED_RGB1,   0xffffc110 // RGB LED 1 color components
.equ SPILED_REG_LED_RGB1_o,     0x0010 // Offset of LED_RGB1
.equ SPILED_REG_LED_RGB2,   0xffffc114 // RGB LED 2 color components
.equ SPILED_REG_LED_RGB2_o,     0x0014 // Offset of LED_RGB2
.equ SPILED_REG_KNOBS_8BIT, 0xffffc124 // Three 8 bit knob values
.equ SPILED_REG_KNOBS_8BIT_o,   0x0024 // Offset of KNOBS_8BIT

// The simple 16-bit per pixel (RGB565) frame-buffer
// display size is 480 x 320 pixel
// Pixel format RGB565 expect
//   bits 11 .. 15 red component
//   bits  5 .. 10 green component
//   bits  0 ..  4 blue component
.equ LCD_FB_START,          0xffe00000
.equ LCD_FB_END,            0xffe4afff

// RISC-V ACLINT MSWI and MTIMER memory mapped peripherals
.equ ACLINT_MSWI,           0xfffd0000 // core 0 SW interrupt request
.equ ACLINT_MTIMECMP,       0xfffd4000 // core 0 compare value
.equ ACLINT_MTIME,          0xfffdbff8 // timer base 10 MHz

// Mapping of interrupts
// mcause      mie / mip
// irq number    bit       Source
//   3            3        ACLINT MSWI
//   7            7        MTIME reached value of MTIMECMP
//  16           16        There is received character ready to be read
//  17           17        Serial port ready to accept character to Tx

// Start address after reset
.org 0x00000200

.text





.equ screen_width, 0x000003c0



__start:
_start:

loop:
    

//todo list: 
 // add notification if you are trying to write with the colours too close to black
 // stop RGB values being recalculated when it is not neccacary
 // BONUS POINTS: only recalculate the colour values that changed instead of all of 
 // them
 //fix occasional crash when deleting spaces
 //fix some letters not being cleared correctly whenv being deleted

//current WIP (currently not breaking code/causing issues)

// add the rest of the letters and backspace, next line, etc.

// add some NOPs between functions to allow edits without having to redo all the jump addresses.

// store the written text for later use for shell commands, ETC ---- only 
// implemented in A, B, C. stored in stack.

//use more indirect jumps to decrease the amount of painful recalculation (see
//code to delete characters)




// current WIP (currently breaking code/causing issues)

// started reallocating registers to allign with how they are supposed to be used
// ---- currently the RGB value and letters A, B work. Have not finished 
// reallocating all the registers





//done

// optimise how the letters are found (instead of doing a BEQ of every letter, perhaps a JALR of the letter value to go to another jump that goes to the letter print function, this will stop the nested if:else loops and make all letters have the same processing latency







    nop
    nop
    nop 
    //start writing to screen        
    li s1, LCD_FB_START //s7 is the cursor position
    li s2, LCD_FB_START //s8 is the address of the pixel being written to
    li s3, SERIAL_PORT_BASE // load base address of serial port
    
    colour_calc:    
    
    li t0, SPILED_REG_KNOBS_8BIT //load RGB values into ra
    //clear registers

    add t1, zero, zero
    

    //get RGB value
    li t4, SPILED_REG_KNOBS_8BIT //load RGB values
    lbu gp, 2(t4)
    lbu tp, 1(t4)
    lbu t0, 0(t4)  //todo: stop it from recalculating RGB values when there is no need 
    
    srli gp, gp, 3 //divide RGB values by 2
    srli tp, tp, 2
    srli t0, t0, 3
        
    add t1, t1, t0 //merge RGB values into bottom half of 1 register (T1 register is RGB value)
    slli tp, tp, 5
    add t1, t1, tp
    slli gp, gp, 11
    add t1, t1, gp  
    
    //duplicate RGB values on top half of register to allow for writing 2 pixels at once
    add t6, t1, zero  
    slli t6, t6, 16
    or s0, t1, t6
    add t1, zero, t3
    add t6, zero, zero

    call edge_case_handler_2
    jal zero, colour_calc
    
    
    
    
    //currently set to stop on error values, commented instructions are for automatically fixing the values
    edge_case_handler_1: //if the stack pointer is lower then it is supposed to be, this is expected behavior when sending delete chr command with no text so it is kept as auto-fix
    
    li t0, 0xbfffff00
    bgt sp, t0, edge_case_handler_2
    add sp, t0, zero
    add a0, zero, zero
    jal zero, edge_case_handler_2
    nop
    nop
    nop
    text_1: .asciz  "cursor overflow error\n"    // store zero terminated ASCII text
    nop
    nop
    edge_case_handler_2: 
    li t2, LCD_FB_START
    beq t2, s1, edge_case_handler_end
    blt s1, t2, edge_case_handler_end
    la   a1, text_1 // load address of text
    call serial_write
    add a1, zero, zero
    jal zero, edge_case_handler_end
    edge_case_handler_end:
    jal zero, input_check
    nop
    nop
    nop
    nop
    nop
    nop
    
    serial_write:
    li   a0, SERIAL_PORT_BASE           // load base address of serial port
next_char:
    lb   t1, 0(a1)                      // load one byte after another
    beq  t1, zero, end_char             // is this the terminal zero byte
    addi a1, a1, 1                      // move pointer to next text byte
tx_busy:
    lw   t0, SERP_TX_ST_REG_o(a0)       // read status of transmitter
    andi t0, t0, SERP_TX_ST_REG_READY_m // mask ready bit
    beq  t0, zero, tx_busy              // if not ready wait for ready condition
    sw   t1, SERP_TX_DATA_REG_o(a0)     // write byte to Tx data register
    jal  zero, next_char                // unconditional branch to process next byte
    end_char:
    ret
    
    
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
   
 


        

    


    
  //  sw t1, 0(s6)  //test to see if RGB calcs working 
input_check:
    
    lb a0, 0(s3) //check for input
    beq a0, zero, colour_calc  //if there is no new inputs, return
  
  li a2, 0xffffc004  //check for terminal input
  lb a4, 0(a2)
  slli a4, a4, 2
  jalr zero, a4, chr_code
  chr_code:
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
    nop //free space for future edits 
    nop
    nop
    nop
    nop
    jal zero, chr_space //space
    nop //!
    nop //"
    nop //#
    nop //$
    nop //%
    nop //&
    nop //' --apostraphe
    nop //(
    nop //)
    nop //*
    nop //+
    nop //,
    nop //-
    nop //.
    nop ///
    nop //0
    nop //1
    nop //2
    nop //3
    nop //4
    nop //5
    nop //6
    nop //7
    nop //8
    nop //9
    nop //:
    nop //; --semicolon, use as enter/newline
    nop //<
    nop //=
    nop //>
    nop //?
    nop //@
    nop //A
    nop //B
    nop //C
    nop //D
    nop //E
    nop //F
    nop //G
    nop //H
    nop //I
    nop //J
    nop //K
    nop //L
    nop //M
    nop //N
    nop //O
    nop //P
    nop //Q
    nop //R
    nop //S
    nop //T
    nop //U
    nop //V
    nop //W
    nop //X
    nop //Y
    nop //Z
    nop //[
    nop //\
    nop //]
    nop //^
    nop //_
    jal zero, del //` --grave accent, use as backspace
    jal zero, chr_A //a
    jal zero, chr_B //b
    jal zero, chr_C //c
    jal zero, chr_D //d
    jal zero, chr_E //e
    jal zero, chr_F //f
    jal zero, chr_G //g
    jal zero, chr_H //h
    jal zero, chr_I //i
    jal zero, chr_J //j
    jal zero, chr_K //k
    jal zero, chr_L //l
    jal zero, chr_M //m
    jal zero, chr_N //n
    jal zero, chr_O //o
    jal zero, chr_P //p
    jal zero, chr_Q //q
    jal zero, chr_R //r
    jal zero, chr_S //s
    jal zero, chr_T //t
    jal zero, chr_U //u
    jal zero, chr_V //v
    jal zero, chr_W //w
    jal zero, chr_X //x
    jal zero, chr_Y //y
    jal zero, chr_Z //z
    nop //{
    nop //|
    nop //}
    nop //~
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
    nop
    nop  
    ecall //stop execution if unknown character
    
  //write letter A to screen
  chr_A:
  add s2, s1, zero //set pixel write adress to cursor position
    
  sh s0, 2(s2) //write one pixel to screen at one pixel ( half this number ->2(s2) ) right of the pixel write adress 
  addi s2, s2, screen_width //move pixel write adress down one row
  sh s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2) //write two pixels, one at the pixel write adress and one to the right of the pixel write adress
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  
  addi t6, zero, 0x61 //load ascii value of this character 
  sb t6, 0(sp) //pop character into stack
  add t6, zero, zero //clear register
  addi sp, sp, 1 //increment stack pointer
  
  addi s1, s1, 8 //move cursor position right by 4 pixels
  ret //return

  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter B to screen
  chr_B:
  add s2, s1, zero
  
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
    
  addi t6, zero, 0x62
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
    
  addi s1, s1, 8
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter C to screen
  chr_C:
  add s2, s1, zero
  
  sw s0, 2(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 2(s2)
  
  addi t6, zero, 0x63
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 8
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter D to screen
  chr_D:
  add s2, s1, zero

  sw s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)  
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  
  addi t6, zero, 0x64
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
addi s1, s1, 8
ret

  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
   //write letter E to screen
   chr_E:
  add s2, s1, zero

  sw s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)  
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sh s0, 4(s2)
  
  addi t6, zero, 0x65
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 8
  ret

  nop
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  
  //write letter F to screen
  chr_F:
  add s2, s1, zero

  sw s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)  
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 2(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  
  addi t6, zero, 0x66
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 8
  ret

  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter G to screen
  chr_G:
  add s2, s1, zero

  sh s0, 2(s2)
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2) 
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 6(s2) 
  addi s2, s2, screen_width
  sw s0, 2(s2)
  
  addi t6, zero, 0x66
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 10
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter H to screen
  chr_H:
  add s2, s1, zero

  sh s0, 0(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 6(s2) 
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 6(s2)
  
  addi t6, zero, 0x67
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 10
  ret

  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter I to screen
  chr_I:
  add s2, s1, zero

  sh s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  
    addi t6, zero, 0x68
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 4
  jalr zero, s11, 0

  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter J to screen
  chr_J:
  add s2, s1, zero
  
  sw s0, 2(s2)
  addi s2, s2, screen_width
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 2(s2)
  
  addi t6, zero, 0x69
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 8
  ret

  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter k to screen
  chr_K:
  add s2, s1, zero

  sh s0, 0(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 6(s2)
  
  addi t6, zero, 0x6a
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 10
  ret

  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  
  //write letter L to screen
  chr_L:
  add s2, s1, zero

  sh s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sh s0, 4(s2)
  
  addi t6, zero, 0x6b
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 8
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter M to screen
  chr_M:
  add s2, s1, zero

  sh s0, 0(s2)
  sh s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sw s0, 6(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  sh s0, 8(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 8(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 8(s2)
  
  addi t6, zero, 0x6c
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 12
  ret

  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter N to screen
  chr_N:
  add s2, s1, zero

  sh s0, 0(s2)
  sh s0, 8(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sh s0, 8(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  sh s0, 8(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sw s0, 6(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 8(s2)
  
  addi t6, zero, 0x6d
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 12
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter O to screen
  chr_O:
  add s2, s1, zero

  sw s0, 2(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sw s0, 2(s2)
  
  addi t6, zero, 0x6e
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 10
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter P to screen
  chr_P:
  add s2, s1, zero
  
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  
  addi t6, zero, 0x6f
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 8
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter q to screen
  chr_Q:
  add s2, s1, zero
  
  sw s0, 2(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sw s0, 2(s2)
  sw s0, 6(s2)
  
  addi t6, zero, 0x70
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 12
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
     
  //write letter R to screen
  chr_R:
  add s2, s1, zero
  
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  
  addi t6, zero, 0x71
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 8
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter s to screen
  chr_S:
  add s2, s1, zero
  
  sw s0, 2(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  addi s2, s2, screen_width
  sh s0, 2(s2)
  addi s2, s2, screen_width
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  
  addi t6, zero, 0x72
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 8
  ret

  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter t to screen
  chr_T:
  add s2, s1, zero
  
  sh s0, 2(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 2(s2)
  addi s2, s2, screen_width
  sh s0, 2(s2)
  addi s2, s2, screen_width
  sh s0, 2(s2)
  
  addi t6, zero, 0x73
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 8
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter U to screen
  chr_U:
  add s2, s1, zero
  
  sh s0, 0(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sw s0, 2(s2)
  
  addi t6, zero, 0x74
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 10
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter V to screen
  chr_V:
  add s2, s1, zero
  
  sh s0, 0(s2)
  sh s0, 8(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 8(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 8(s2)
  addi s2, s2, screen_width
  sh s0, 2(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sh s0, 4(s2)
  
  addi t6, zero, 0x75
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 12
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter w to screen
  chr_W:
  add s2, s1, zero
  
  sh s0, 0(s2)
  sh s0, 8(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 8(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  sh s0, 8(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  sh s0, 8(s2)
  addi s2, s2, screen_width
  sh s0, 2(s2)
  sh s0, 6(s2)
  
  addi t6, zero, 0x76
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 12
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter x to screen
  chr_X:
  add s2, s1, zero
  
  sh s0, 0(s2)
  sh s0, 8(s2)
  addi s2, s2, screen_width
  sh s0, 2(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 2(s2)
  sh s0, 6(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 8(s2)
  
  addi t6, zero, 0x77
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 12
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter y to screen
  chr_Y:
  add s2, s1, zero
  
  sh s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 2(s2)
  addi s2, s2, screen_width
  sh s0, 2(s2)
  addi s2, s2, screen_width
  sh s0, 2(s2)
  
  addi t6, zero, 0x78
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 8
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write letter z to screen
  chr_Z:
  add s2, s1, zero
  
  sw s0, 0(s2)
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 4(s2)
  addi s2, s2, screen_width
  sh s0, 2(s2)
  addi s2, s2, screen_width
  sh s0, 0(s2)
  addi s2, s2, screen_width
  sw s0, 0(s2)
  sh s0, 4(s2)
  
  addi t6, zero, 0x78
  sb t6, 0(sp)
  add t6, zero, zero
  addi sp, sp, 1
  
  addi s1, s1, 8
  ret
  
  nop //free space for future edits 
  nop
  nop
  nop
  nop
  nop
  
  //write space to screen
  chr_space:
    addi t6, zero, 0x20 //load ascii value of this character 
  sb t6, 0(sp) //pop character into stack
  add t6, zero, zero //clear register
  addi sp, sp, 1 //increment stack pointer
  
  addi s1, s1, 8
  ret //return
  
  
    //delete letter
    del:
    li t6, 0x00000001  //0x80000001
    sub sp, sp, t6 //decrement stack pointer
    lw a4, 0(sp) //load character from stack
    sb zero, 0(sp) //delete character from stack
    slli a4, a4, 2
    li t2, chr_del_enc // 0x00000fc8
    add a4, a4, t2
    //  nop//add a4, zero, zero
    jalr zero, a4, 0
    
    chr_del_enc:
    jal zero, colour_calc //  ret
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
    jal zero, dec_eight_wide //space
    ebreak//this nop shouldn't have to be here, find out why it needs to be here
    ebreak //! //sometimesjumps here
    ebreak //"
    ebreak //#
    ebreak //$
    ebreak //%
    ebreak //&
    ebreak //' --apostraphe
    ebreak //(
    ebreak //)
    ebreak //*
    ebreak //+
    ebreak //,
    ebreak //-
    ebreak //.
    ebreak ///
    ebreak //0
    ebreak //1
    ebreak //2
    ebreak //3
    ebreak //4
    ebreak //5
    ebreak //6
    ebreak //7
    ebreak //8
    ebreak //9
    ebreak //:
    ebreak //; --semicolon, use as enter/newline
    ebreak //<
    ebreak //=
    ebreak //>
    ebreak //?
    ebreak //@
    ebreak //A
    ebreak //B
    ebreak //C
    ebreak //D
    ebreak //E
    ebreak //F
    ebreak //G
    ebreak //H
    ebreak //I
    ebreak //J
    ebreak //K
    ebreak //L
    ebreak //M
    ebreak //N
    ebreak //O
    ebreak //P
    ebreak //Q
    ebreak //R
    ebreak //S
    ebreak //T
    ebreak //U
    ebreak //V
    ebreak //W
    ebreak //X
    ebreak //Y
    ebreak //Z
    ebreak //[
    ebreak //\
    ebreak //]
    ebreak //^
    ebreak //_
    ecall//` --grave accent, use as backspace
    jal zero, dec_eight_wide //a
    jal zero, dec_eight_wide //b
    jal zero, dec_eight_wide //c
    jal zero, dec_eight_wide //d
    jal zero, dec_eight_wide //e
    jal zero, dec_twelve_wide //f //broken for some reason
    jal zero, dec_ten_wide//g
    jal zero, dec_ten_wide//h
    jal zero, dec_four_wide//i
    jal zero, dec_eight_wide//j
    jal zero, dec_ten_wide//k
    jal zero, dec_eight_wide//l
    jal zero, dec_twelve_wide//m
    jal zero, dec_twelve_wide//n
    jal zero, dec_ten_wide//o
    jal zero, dec_eight_wide//p
    ebreak //jal zero, dec_twelve_wide//q
    jal zero, dec_eight_wide//r
    jal zero, dec_eight_wide//s
    jal zero, dec_eight_wide//t
    jal zero, dec_ten_wide//u
    jal zero, dec_twelve_wide//v
    jal zero, dec_twelve_wide//w
    jal zero, dec_twelve_wide//x
    jal zero, dec_eight_wide//y
    jal zero, dec_eight_wide//z
    nop //{
    nop //|
    nop //}
    nop //~
  

  dec_four_wide:
  li t6, 0x00000004  
  sub s1, s1, t6 //move character pointer left by two pixels
  
  jal zero, clr_two_at_chr_pointer
  
    
  dec_eight_wide:
  li t6, 0x00000008  
  sub s1, s1, t6 
  
  jal zero, clr_two_at_chr_pointer_plus_2_px
  
  dec_ten_wide:
  li t6, 0x0000000a
  sub s1, s1, t6 
  
  jal zero, clr_one_at_chr_pointer_plus_4_px
  
  dec_twelve_wide:
  li t6, 0x0000000c
  sub s1, s1, t6 
  
  jal zero, clr_two_at_chr_pointer_plus_4_px


clr_two_at_chr_pointer:
  add s2, s1, zero
  
  sw zero, 0(s2)
  addi s2, s2, screen_width
  sw zero, 0(s2)
  addi s2, s2, screen_width
  sw zero, 0(s2)
  addi s2, s2, screen_width
  sw zero, 0(s2)
  addi s2, s2, screen_width
  sw zero, 0(s2)
ret




clr_two_at_chr_pointer_plus_2_px:
  add s2, s1, zero
  
  sw zero, 4(s2)
  addi s2, s2, screen_width
  sw zero, 4(s2)
  addi s2, s2, screen_width
  sw zero, 4(s2)
  addi s2, s2, screen_width
  sw zero, 4(s2)
  addi s2, s2, screen_width
  sw zero, 4(s2)
  
  jal zero, clr_two_at_chr_pointer
  
  
  
  clr_one_at_chr_pointer_plus_4_px:
  add s2, s1, zero
  
  sh zero, 6(s2)
  addi s2, s2, screen_width
  sh zero, 6(s2)
  addi s2, s2, screen_width
  sh zero, 6(s2)
  addi s2, s2, screen_width
  sh zero, 6(s2)
  addi s2, s2, screen_width
  sh zero, 6(s2)
  
  jal zero, clr_two_at_chr_pointer_plus_2_px

  clr_two_at_chr_pointer_plus_4_px:
  add s2, s1, zero
  
  sw zero, 6(s2)
  addi s2, s2, screen_width
  sw zero, 6(s2)
  addi s2, s2, screen_width
  sw zero, 6(s2)
  addi s2, s2, screen_width
  sw zero, 6(s2)
  addi s2, s2, screen_width
  sw zero, 6(s2)
  
  jal zero, clr_two_at_chr_pointer_plus_2_px
  
  
  
  

    ebreak // stop continuous execution, request developer interaction


.org 0x400
.data




// if whole source compile is OK the switch to core tab
#pragma qtrvsim tab core

// The sample can be compiled by full-featured riscv64-unknown-elf GNU tool-chain
// for RV32IMA use
// riscv64-unknown-elf-gcc -c -march=rv64ima -mabi=lp64 template.S
// riscv64-unknown-elf-gcc -march=rv64ima -mabi=lp64 -nostartfiles -nostdlib template.o
// for RV64IMA use
// riscv64-unknown-elf-gcc -c -march=rv32ima -mabi=ilp32 template.S
// riscv64-unknown-elf-gcc -march=rv32ima -mabi=ilp32 -nostartfiles -nostdlib template.o
// add "-o template" to change default "a.out" output file name
