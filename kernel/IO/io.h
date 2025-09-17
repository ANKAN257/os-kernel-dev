#ifndef IO_H
#define IO_H

#include <stdint.h>

// Write a byte to the specified I/O port
void outb(uint16_t port, uint8_t val);

// Read a byte from the specified I/O port
uint8_t inb(uint16_t port);

#endif
