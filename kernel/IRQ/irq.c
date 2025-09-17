#include "irq.h"
#include "idt.h"
#include "io.h"
#include "screen.h"

#define PIC1            0x20
#define PIC2            0xA0
#define PIC1_COMMAND    PIC1
#define PIC1_DATA       (PIC1+1)
#define PIC2_COMMAND    PIC2
#define PIC2_DATA       (PIC2+1)

#define ICW1_INIT       0x10
#define ICW1_ICW4       0x01
#define ICW4_8086       0x01

extern void irq0();
extern void irq1();
extern void irq2();
extern void irq3();
extern void irq4();
extern void irq5();
extern void irq6();
extern void irq7();
extern void irq8();
extern void irq9();
extern void irq10();
extern void irq11();
extern void irq12();
extern void irq13();
extern void irq14();
extern void irq15();

void pic_remap() {
    outb(0x20, 0x11); // Start initialization
    outb(0xA0, 0x11);
    outb(0x21, 0x20); // Master offset = 0x20
    outb(0xA1, 0x28); // Slave offset = 0x28
    outb(0x21, 0x04); // Tell Master PIC that Slave PIC is at IRQ2 (0000 0100)
    outb(0xA1, 0x02);
    outb(0x21, 0x01);
    outb(0xA1, 0x01);
    outb(0x21, 0x00); // Enable all IRQs
    outb(0xA1, 0x00);
}

void irq_install() {
    pic_remap();

    set_idt_gate(32, (uint32_t)irq0);
    set_idt_gate(33, (uint32_t)irq1);  // Keyboard IRQ
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



void no_key_pressed() {
    print("Key released or no valid key pressed\n");
}

void irq_handler(registers_t *r) {
    if (r->int_no == 33) {  // Keyboard IRQ
        uint8_t scancode = inb(0x60);  // Read the scancode from keyboard port

        if (scancode & 0x80) {
            // Key release (bit 7 is set)
            no_key_pressed();
        } else {
            // Key press
            print("Scancode: ");
            print_hex(scancode);
            print("\n");
            // Optionally call a handler function for key press
            // key_pressed(scancode);
        }
    }

    // Send End Of Interrupt (EOI)
    if (r->int_no >= 40) {
        outb(PIC2_COMMAND, 0x20);
    }
    outb(PIC1_COMMAND, 0x20);
}
