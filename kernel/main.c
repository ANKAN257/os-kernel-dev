#include <stdint.h>
#include "idt.h"
#include "isr.h"
#include "irq.h"
#include "screen.h"


// Entry point from assembly (called from boot.asm or linker script)
void c_kernel_main() {
  
    clear_screen(); // Clear the screen
    println("Booting kernel...\n");
    draw_virtual_keyboard();

    init_idt();     // Initialize the IDT
    isr_install();  // Install ISRs for CPU exceptions
    irq_install();  // Install IRQ handlers (e.g., keyboard)

    println("GDT, IDT, ISR, and IRQ loaded!\n");
    println("Press any key to test IRQ1 (keyboard)... \n");

    print("Kernel initialized successfully.\n");

    asm volatile("sti"); // enable interrupts

    print("System initialized. Waiting for keyboard input...\n");

    while (1) {
        asm volatile("hlt");
    }
}
