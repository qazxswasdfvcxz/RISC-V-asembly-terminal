        .data
fout:   .asciz "Desktop/testout.txt"      # filename for output
buffer: .asciz "The quick brown fox jumps over the lazy dog."
        .text
  ###############################################################
  # Open (for writing) a file that does not exist
  li   a7, 1024     # system call for open file
  la   a0, fout     # output file name
  li   a1, 0        # Open for writing (flags are 0: read, 1: write)
  ecall             # open a file (file descriptor returned in a0)
  mv   s6, a0       # save the file descriptor
  ###############################################################
  # Write to file just opened
  li   a7, 63       # system call for read from file
  mv   a0, s6       # file descriptor
  li   a1, 0x10010100# address of buffer from which to write
  li   a2, 16384       # hardcoded buffer length
  ecall             # write to file
  ###############################################################
  # Close the file
  li   a7, 57       # system call for close file
  mv   a0, s6       # file descriptor to close
  ecall             # close file
  ###############################################################