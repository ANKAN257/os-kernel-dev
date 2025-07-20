#pragma once

#include <stdint.h>
#include "isr.h"  // Contains the definition for `registers_t`

// Install all IRQs (and remap the PICs)
void irq_install();

// The actual IRQ handler called from assembly
void irq_handler(registers_t* regs);

// Register a custom handler for a specific IRQ (0–15)
void irq_set_handler(int irq, void (*handler)(registers_t*));
