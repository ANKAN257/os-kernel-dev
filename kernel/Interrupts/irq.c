#include "irq.h"
#include "port.h"
#include "idt.h"

// Array of function pointers to hold custom IRQ handlers
void (*irq_routines[16])(registers_t*) = { 0 };

// Register a custom handler for a specific IRQ
void irq_set_handler(int irq, void (*handler)(registers_t*)) {
    irq_routines[irq] = handler;
}

// Called from irq_common_stub in irq.s
void irq_handler(registers_t* r) {
    int irq = r->int_no - 32;

    if (irq < 16 && irq_routines[irq]) {
        irq_routines[irq](r);  // Call registered handler
    }

    // Send End Of Interrupt (EOI) signal to PICs
    if (r->int_no >= 40) {
        outb(0xA0, 0x20);  // Slave PIC
    }
    outb(0x20, 0x20);      // Master PIC
}

// Install IRQs 0–15 and remap the PIC
void irq_install() {
    // Remap PIC: IRQs 0–15 → Interrupts 32–47
    outb(0x20, 0x11); // Start init
    outb(0xA0, 0x11);
    outb(0x21, 0x20); // Master offset: 0x20 (32)
    outb(0xA1, 0x28); // Slave offset:  0x28 (40)
    outb(0x21, 0x04); // Tell Master about Slave at IRQ2
    outb(0xA1, 0x02); // Tell Slave its cascade identity
    outb(0x21, 0x01); // 8086 mode
    outb(0xA1, 0x01);
    outb(0x21, 0x00); // Clear data
    outb(0xA1, 0x00);

    // IRQ handler entry points from irq.s
    extern void* irq0;
    extern void* irq1;
    extern void* irq2;
    extern void* irq3;
    extern void* irq4;
    extern void* irq5;
    extern void* irq6;
    extern void* irq7;
    extern void* irq8;
    extern void* irq9;
    extern void* irq10;
    extern void* irq11;
    extern void* irq12;
    extern void* irq13;
    extern void* irq14;
    extern void* irq15;

    // Set IDT entries for IRQs 0–15
    set_idt_gate(32, (uint32_t)irq0);
    set_idt_gate(33, (uint32_t)irq1);
    set_idt_gate(34, (uint32_t)irq2);
    set_idt_gate(35, (uint32_t)irq3);
    set_idt_gate(36, (uint32_t)irq4);
    set_idt_gate(37, (uint32_t)irq5);
    set_idt_gate(38, (uint32_t)irq6);
    set_idt_gate(39, (uint32_t)irq7);
    set_idt_gate(40, (uint32_t)irq8);
    set_idt_gate(41, (uint32_t)irq9);
    set_idt_gate(42, (uint32_t)irq10);
    set_idt_gate(43, (uint32_t)irq11);
    set_idt_gate(44, (uint32_t)irq12);
    set_idt_gate(45, (uint32_t)irq13);
    set_idt_gate(46, (uint32_t)irq14);
    set_idt_gate(47, (uint32_t)irq15);
}
