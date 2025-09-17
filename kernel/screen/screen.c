#include "screen.h"
#include "io.h"

#define VIDEO_MEMORY 0xB8000
#define MAX_COLS 80
#define MAX_ROWS 25
#define WHITE_ON_BLACK 0x0F

volatile char* video = (volatile char*) VIDEO_MEMORY;
int cursor = 0;

void move_cursor() {
    outb(0x3D4, 14);
    outb(0x3D5, (cursor >> 8) & 0xFF);
    outb(0x3D4, 15);
    outb(0x3D5, cursor & 0xFF);
}

void print_char(char c) {
    if (c == '\n') {
        cursor += MAX_COLS;
        cursor -= cursor % MAX_COLS;
    } else {
        video[cursor * 2] = c;
        video[cursor * 2 + 1] = WHITE_ON_BLACK;
        cursor++;
    }

    if (cursor >= MAX_COLS * MAX_ROWS) {
        cursor = 0; // Reset if screen full (or add scrolling)
    }

    move_cursor();
}

void print(const char* str) {
    for (int i = 0; str[i] != '\0'; ++i) {
        print_char(str[i]);
    }
}

void println(const char* str) {
    print(str);
    print_char('\n');
}

void clear_screen() {
    for (int i = 0; i < MAX_COLS * MAX_ROWS; ++i) {
        video[i * 2] = ' ';
        video[i * 2 + 1] = WHITE_ON_BLACK;
    }
    cursor = 0;
    move_cursor();
}

void print_int(int num) {
    if (num == 0) {
        print("0");
        return;
    }

    char buffer[12];
    int i = 0;
    int isNegative = 0;

    if (num < 0) {
        isNegative = 1;
        num = -num;
    }

    while (num > 0) {
        buffer[i++] = (num % 10) + '0';
        num /= 10;
    }

    if (isNegative)
        buffer[i++] = '-';

    // Reverse and print
    for (int j = i - 1; j >= 0; --j)
        print_char(buffer[j]);
}




void print_hex(uint8_t num) {
    const char* hex_chars = "0123456789ABCDEF";
    print("0x");
    print_char(hex_chars[(num >> 4) & 0xF]);
    print_char(hex_chars[num & 0xF]);
}

void IRQ_fun() {
    uint8_t scancode = inb(0x60); // Read scancode from keyboard
    print("Scancode received: ");
    print_hex(scancode);
    print(" | Decimal: ");
    print_int(scancode);
    print("\n");
}



void draw_virtual_keyboard() {
    println(" +---+---+---+---+---+---+---+---+---+---+---+---+---+ ");
    println(" | Q | W | E | R | T | Y | U | I | O | P | [ | ] | \\ |");
    println(" +---+---+---+---+---+---+---+---+---+---+---+---+---+ ");
    println(" | A | S | D | F | G | H | J | K | L | ; | ' | Enter | ");
    println(" +---+---+---+---+---+---+---+---+---+---+---+--------+ ");
    println(" | Z | X | C | V | B | N | M | , | . | / |   Space    | ");
    println(" +-----------------------------------------------+    ");
}
