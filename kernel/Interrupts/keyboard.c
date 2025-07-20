// keyboard.c
#include "keyboard.h"
#include "port.h"
#include "irq.h"
#include <stdint.h>
#include <stddef.h>

// This function is triggered by IRQ1 (keyboard interrupt)
void keyboard_handler(registers_t* r) {
    // Read scancode from the keyboard controller
    uint8_t scancode = inb(0x60);

    // You can print the scancode or convert it to ASCII here if needed
    // For now, halt if ESC key is pressed (scancode 0x01)
    if (scancode == 0x01) {
        while (1); // Infinite loop to simulate system halt
    }
}

// This function installs the keyboard IRQ handler (IRQ1)
void keyboard_install() {
    irq_set_handler(1, keyboard_handler);
}
