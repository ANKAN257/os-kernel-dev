#pragma once
#include <stdint.h>


struct IDTEntry {
    uint16_t offset_low;
    uint16_t selector;
    uint8_t zero;
    uint8_t type_attr;
    uint16_t offset_high;
} __attribute__((packed));

struct IDTPointer {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

void init_idt();


void set_idt_gate(int n, uint32_t handler); // <-- Add this line