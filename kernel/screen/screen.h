#ifndef SCREEN_H
#define SCREEN_H

#include <stdint.h>

// Print a single character to the screen
void print_char(char c);

// Print a null-terminated string to the screen
void print(const char* str);

// Print a string followed by a newline
void println(const char* str);

// Clear the screen
void clear_screen();

// Custom IRQ test function
void IRQ_fun();


void draw_virtual_keyboard();

#endif
