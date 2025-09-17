#include "idt.h"
#include <stdint.h>
#include<screen.h>


#define IDT_ENTRIES 256
struct IDTEntry idt[IDT_ENTRIES];
struct IDTPointer idt_ptr;

extern void isr_default();             // defined in isr.s
extern void load_idt(struct IDTPointer*); // defined in assembly

void set_idt_gate(int n, uint32_t handler) {
    idt[n].offset_low = handler & 0xFFFF;
    idt[n].selector = 0x08; // Kernel code segment
    idt[n].zero = 0;
    idt[n].type_attr = 0x8E; // Interrupt gate, present
    idt[n].offset_high = (handler >> 16) & 0xFFFF;
}


void init_idt() {
    idt_ptr.limit = sizeof(struct IDTEntry) * IDT_ENTRIES - 1;
    idt_ptr.base = (uint32_t)&idt;

    // Assign all 256 entries to isr_default
    for (int i = 0; i < IDT_ENTRIES; i++) {
        set_idt_gate(i, (uint32_t) isr_default);
    }

    load_idt(&idt_ptr);
}