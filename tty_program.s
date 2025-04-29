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

.globl _start0
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
    li   s1, SERIAL_PORT_BASE           // load base address of serial port

//todo list: 
// add some NOPs between functions to allow edits without having to redo all the jump addresses
// stop RGB values being recalculated when it is not neccacary
// BONUS POINTS: only recalculate the colour values that changed instead of all of them
// add the rest of the letters and backspace, next line, etc
// add notification if you are trying to write with the colours too close to black
// store the written text for later use for shell commands, ETC
// optimise how the letters are found (instead of doing a BEQ of every letter, perhaps a JALR of the letter value to go to another jump that goes to the letter print function, this will stop the nested if:else loops and make all letters have the same processing latency




        //start writing to screen
    li s6, LCD_FB_START
    li s5, screen_width
    add s7, s6, zero //s7 is the cursor position
    add s8, s6, zero //s8 is the address of the pixel being written to
    
    
    auipc s11, 0
    //clear registers
    add gp, zero, zero
    add tp, zero, zero
    add t0, zero, zero
    add t1, zero, zero
    

    //get RGB value
    li ra, SPILED_REG_KNOBS_8BIT //load RGB values
    lbu gp, 2(ra)
    lbu tp, 1(ra)
    lbu t0, 0(ra)  //todo: stop it from recalculating RGB values when there is no need 
    
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
    or t3, t1, t6
    add t1, zero, t3
    add t6, zero, zero
    
  //  sw t1, 0(s6)  //test to see if RGB calcs working
  
    //  nop
      
    li a1, 1 //check for input
    nop
    lb a0, 0(s1)
    bne a0, a1,  0x00000268
  auipc s10, 0
  nop 
  li a3, 0x61 //check for terminal input
  li a2, 0xffffc004
  nop
  lw a4, 0(a2)
  beq a3, a4, 0x3b8 //A 
  addi a3, a3, 1
  beq a3,a4, 0x420 //B
  addi a3, a3, 1
  beq a3,a4, 0x45c//C
  addi a3, a3, 1
  beq a3,a4, 0x494 //D
  addi a3, a3, 1
  beq a3,a4, 0x4d0 //E
  addi a3, a3, 1
  beq a3,a4, 0x50c //F
  addi a3, a3, 1
  beq a3,a4, 0x548 //G 
  addi a3, a3, 1
  beq a3,a4, 0x588 //H 
  addi a3, a3, 1
  beq a3,a4, 0x5d0 //I 
  addi a3, a3, 1
  beq a3,a4, 0x604 //J
  addi a3, a3, 1
  beq a3,a4, 0x640 //K 
  addi a3, a3, 1
  beq a3,a4, 0x684 //L 
  addi a3, a3, 1
  beq a3,a4, 0x6b8 //M 
  addi a3, a3, 1
  beq a3,a4, 0x704 //N 
  addi a3, a3, 1
  beq a3,a4, 0x750 //O 
  addi a3, a3, 1
  beq a3,a4, 0x790 //P 
  addi a3, a3, 1
  beq a3,a4, 0x7c8 //Q 
  addi a3, a3, 1
  beq a3,a4, 0x80c //R 
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop //extra space to add more characters later
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
jalr zero, s10, 0
  
  
  nop  //write letter A to screen
  add s8, s7, zero
  sh t1, 2(s8)
  add s8, s5, s7
  sh t1, 0(s8)
  sh t1, 4(s8)
  add s8, s5, s8
  sw t1, 0(s8)
  sh t1, 4(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 4(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 4(s8)
  
addi s7, s7, 8
jalr zero, s11, 0

nop
nop
nop
nop
nop
nop
nop
nop
nop

 nop  //write letter B to screen
  add s8, s7, zero
  sw t1, 0(s8)
  add s8, s5, s7
  sh t1, 0(s8)
  sh t1, 4(s8)
  add s8, s5, s8
  sw t1, 0(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 4(s8)
  add s8, s5, s8
  sw t1, 0(s8)
    
addi s7, s7, 8
jalr zero, s11, 0


 nop  //write letter C to screen
  add s8, s7, zero

  sw t1, 2(s8)
  add s8, s5, s7
  sh t1, 0(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  add s8, s5, s8
  sw t1, 2(s8)
  
addi s7, s7, 8
jalr zero, s11, 0

 nop  //write letter D to screen
  add s8, s7, zero

  sw t1, 0(s8)
  add s8, s5, s7
  sh t1, 0(s8)  
  sh t1, 4(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 4(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 4(s8)
  add s8, s5, s8
  sw t1, 0(s8)
  
addi s7, s7, 8
jalr zero, s11, 0


 nop  //write letter E to screen
  add s8, s7, zero

  sw t1, 0(s8)
  sh t1, 4(s8)
  add s8, s5, s7
  sh t1, 0(s8)  
  add s8, s5, s8
  sw t1, 0(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  add s8, s5, s8
  sw t1, 0(s8)
  sh t1, 4(s8)
  
addi s7, s7, 8
jalr zero, s11, 0

 nop  //write letter F to screen
  add s8, s7, zero

  sw t1, 0(s8)
  sh t1, 4(s8)
  add s8, s5, s7
  sh t1, 0(s8)  
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 2(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  add s8, s5, s8
  sh t1, 0(s8)
addi s7, s7, 8
jalr zero, s11, 0

 nop  //write letter G to screen
  add s8, s7, zero

  sh t1, 2(s8)
  sw t1, 4(s8)
  add s8, s5, s7
  sh t1, 0(s8) 
  add s8, s5, s8
  sh t1, 0(s8)
  sw t1, 4(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 6(s8) 
  add s8, s5, s8
  sw t1, 2(s8)
  
addi s7, s7, 10
jalr zero, s11, 0

 nop  //write letter H to screen
  add s8, s7, zero

  sh t1, 0(s8)
  sh t1, 6(s8)
  add s8, s5, s7
  sh t1, 0(s8)
  sh t1, 6(s8)
  add s8, s5, s8
  sw t1, 0(s8)
  sw t1, 4(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 6(s8) 
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 6(s8)
addi s7, s7, 10
jalr zero, s11, 0

 nop  //write letter I to screen
  add s8, s7, zero

  sh t1, 0(s8)
  add s8, s5, s7
  sh t1, 0(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  add s8, s5, s8
  sh t1, 0(s8)
addi s7, s7, 4
jalr zero, s11, 0

 nop  //write letter J to screen
  add s8, s7, zero
  
  sw t1, 2(s8)
  add s8, s5, s7
  sh t1, 4(s8)
  add s8, s5, s8
  sh t1, 4(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 4(s8)
  add s8, s5, s8
  sh t1, 2(s8)
  
addi s7, s7, 8
jalr zero, s11, 0

 nop  //write letter k to screen
  add s8, s7, zero

  sh t1, 0(s8)
  sh t1, 6(s8)
  add s8, s5, s7
  sh t1, 0(s8)
  sh t1, 4(s8)
  add s8, s5, s8
  sw t1, 0(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 4(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 6(s8)
addi s7, s7, 10
jalr zero, s11, 0

 nop  //write letter L to screen
  add s8, s7, zero

  sh t1, 0(s8)
  add s8, s5, s7
  sh t1, 0(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  add s8, s5, s8
  sw t1, 0(s8)
  sh t1, 4(s8)
addi s7, s7, 8
jalr zero, s11, 0

 nop  //write letter M to screen
  add s8, s7, zero

  sh t1, 0(s8)
  sh t1, 8(s8)
  add s8, s5, s7
  sw t1, 0(s8)
  sw t1, 6(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 4(s8)
  sh t1, 8(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 8(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 8(s8)
addi s7, s7, 12
jalr zero, s11, 0

 nop  //write letter N to screen
  add s8, s7, zero

  sh t1, 0(s8)
  sh t1, 8(s8)
  add s8, s5, s7
  sw t1, 0(s8)
  sh t1, 8(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 4(s8)
  sh t1, 8(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sw t1, 6(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 8(s8)
addi s7, s7, 12
jalr zero, s11, 0

 nop  //write letter O to screen
  add s8, s7, zero

  sw t1, 2(s8)
  add s8, s5, s7
  sh t1, 0(s8)
  sh t1, 6(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 6(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 6(s8)
  add s8, s5, s8
  sw t1, 2(s8)
  
addi s7, s7, 10
jalr zero, s11, 0

 nop  //write letter P to screen
  add s8, s7, zero
  sw t1, 0(s8)
  add s8, s5, s7
  sh t1, 0(s8)
  sh t1, 4(s8)
  add s8, s5, s8
  sw t1, 0(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  
addi s7, s7, 8
jalr zero, s11, 0

 nop  //write letter q to screen
  add s8, s7, zero
  sw t1, 2(s8)
  add s8, s5, s7
  sh t1, 0(s8)
  sh t1, 6(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 6(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 6(s8)
  add s8, s5, s8
  sw t1, 2(s8)
  sw t1, 6(s8)
addi s7, s7, 12
jalr zero, s11, 0


 nop  //write letter R to screen
  add s8, s7, zero
  sw t1, 0(s8)
  add s8, s5, s7
  sh t1, 0(s8)
  sh t1, 4(s8)
  add s8, s5, s8
  sw t1, 0(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 4(s8)
  add s8, s5, s8
  sh t1, 0(s8)
  sh t1, 4(s8)
  
addi s7, s7, 8
jalr zero, s11, 0


end_char:
    ebreak // stop continuous execution, request developer interaction
    jal  zero, end_char

.org 0x400
.data

data_1:	.word	1, 2, 3, 4	// example how to fill data words

text_1: .asciz  "Hello world.\n"    // store zero terminated ASCII text

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
