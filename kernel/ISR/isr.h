
// Include/ isr.h
#ifndef ISR_H
#define ISR_H

#include <stdint.h>

#define ISR_COUNT 32

// Struct to capture CPU state at time of interrupt
typedef struct {
    uint32_t ds;
    uint32_t edi, esi, ebp, esp, ebx, edx, ecx, eax;
    uint32_t int_no, err_code;
    uint32_t eip, cs, eflags, useresp, ss;
} registers_t;

// // Handler type for ISRs
typedef void (*isr_handler_t)(registers_t*);

// Setup all ISR stubs
void isr_install();

// // Function that gets called from assembly
void isr_handler(registers_t* regs);

// // Register a custom handler
void register_interrupt_handler(uint8_t n, isr_handler_t handler);

#endif
