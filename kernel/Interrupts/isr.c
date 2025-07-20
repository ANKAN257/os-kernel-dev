#include "isr.h"
#include "idt.h"
#include "port.h"
#include "irq.h"

// Only ONE definition of this globally
const char* exception_messages[] = {
    "Division By Zero", "Debug", "Non Maskable Interrupt", "Breakpoint", "Into Detected Overflow",
    "Out of Bounds", "Invalid Opcode", "No Coprocessor", "Double Fault", "Coprocessor Segment Overrun",
    "Bad TSS", "Segment Not Present", "Stack Fault", "General Protection Fault", "Page Fault",
    "Unknown Interrupt", "Coprocessor Fault", "Alignment Check", "Machine Check", "Reserved",
    "Reserved", "Reserved", "Reserved", "Reserved", "Reserved", "Reserved", "Reserved",
    "Reserved", "Reserved", "Reserved", "Reserved", "Reserved"
};

// External assembly stubs for interrupts 0–31
extern void* isr_stub_table[];

void isr_handler(registers_t* r) {
    if (r->int_no < 32) {
        // You can later implement print() for screen/serial
        // Example: print(exception_messages[r->int_no]);
        while (1); // Halt on exception
    }
}

void isr_install() {
    for (int i = 0; i < 32; i++) {
        set_idt_gate(i, (uint32_t)isr_stub_table[i]);
    }
}
