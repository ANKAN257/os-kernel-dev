
#include "idt.h"
#include <stdint.h>


void c_kernel_main() {
  

    // Then load IDT
    init_idt();  // Should set up IDT and call `load_idt`
 
   
    // Only after GDT & IDT are loaded, safely write to video memory
    char* video = (char*)0xB8000;
    const char* msg = "GDT & IDT LOADED SUCCESSFULLY";
    int color = 0x1E;  // Yellow text on Blue background (0xE = Yellow, 0x1 = Blue)
    for (int i = 0; msg[i] != '\0'; ++i) {
        video[i * 2] = msg[i];
        video[i * 2 + 1] = color;
    }

    while (1) __asm__ volatile ("hlt");
}
