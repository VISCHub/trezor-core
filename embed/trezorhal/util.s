  .syntax unified

  .text

  .global memset_reg
  .type memset_reg, STT_FUNC
memset_reg:
  // call with the following (note that the arguments are not validated prior to use):
  // r0 - address of first word to write (inclusive)
  // r1 - address of first word following the address in r0 to NOT write (exclusive)
  // r2 - word value to be written
  // both addresses in r0 and r1 needs to be divisible by 4!
  .L_loop_begin:
    str r2, [r0], 4 // store the word in r2 to the address in r0, post-indexed
    cmp r0, r1
  bne .L_loop_begin
  bx lr

  .global jump_to
  .type jump_to, STT_FUNC
jump_to:
  mov r4, r0            // save input argument r0
  // this subroutine re-points the exception handlers before the C code
  // that comprises them has been given a good environment to run.
  // therefore, this code needs to disable interrupts before the VTOR
  // update. then, the reset_handler of the next stage needs to re-enable interrupts.
  // the following prevents activation of all exceptions except Non-Maskable Interrupt (NMI).
  // according to "ARM Cortex-M Programming Guide to Memory Barrier Instructions" Application Note 321, section 4.8:
  // "there is no requirement to insert memory barrier instructions after CPSID".
  cpsid f
  // wipe memory at the end of the current stage of code
  ldr r0, =ccmram_start // r0 - point to beginning of CCMRAM
  ldr r1, =ccmram_end   // r1 - point to byte after the end of CCMRAM
  ldr r2, =0            // r2 - the word-sized value to be written
  bl memset_reg
  ldr r0, =sram_start   // r0 - point to beginning of SRAM
  ldr r1, =sram_end     // r1 - point to byte after the end of SRAM
  ldr r2, =0            // r2 - the word-sized value to be written
  bl memset_reg
  // give the next stage a fresh main stack pointer
  ldr r0, [r4]
  msr msp, r0
  // point to the next stage's exception handlers
  // AN321, section 4.11: "a memory barrier is not required after a VTOR update"
  .set SCB_VTOR, 0xE000ED08 // reference "Cortex-M4 Devices Generic User Guide" section 4.3
  ldr r0, =SCB_VTOR
  str r4, [r0]
  // go on to the next stage
  ldr lr, =0xffffffff   // set the link register to reset value. there is no reason to return here.
  ldr r0, [r4, 4]
  ldr r1, =0
  ldr r2, =0
  ldr r3, =0
  ldr r4, =0
  ldr r5, =0
  ldr r6, =0
  ldr r7, =0
  ldr r8, =0
  ldr r9, =0
  ldr r10, =0
  ldr r11, =0
  ldr r12, =0
  bx r0

  .global shutdown
  .type shutdown, STT_FUNC
shutdown:
  cpsid f
  bl clear_otg_hs_memory
  ldr r0, =ccmram_start
  ldr r1, =ccmram_end
  ldr r2, =0
  bl memset_reg
  ldr r0, =sram_start
  ldr r1, =sram_end
  ldr r2, =0
  bl memset_reg
  ldr lr, =0xffffffff
  ldr r0, =0
  ldr r1, =0
  ldr r2, =0
  ldr r3, =0
  ldr r4, =0
  ldr r5, =0
  ldr r6, =0
  ldr r7, =0
  ldr r8, =0
  ldr r9, =0
  ldr r10, =0
  ldr r11, =0
  ldr r12, =0

  b . // loop forever

  .end
