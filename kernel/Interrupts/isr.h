#ifndef ISR_H
#define ISR_H

#include <stdint.h>

// Structure pushed by ISR stub
typedef struct registers {
    uint32_t ds;
    uint32_t edi, esi, ebp, esp, ebx, edx, ecx, eax;
    uint32_t int_no, err_code;
    uint32_t eip, cs, eflags, useresp, ss;
} registers_t;

extern void isr_install();
extern void isr_handler(registers_t* r);

#endif
