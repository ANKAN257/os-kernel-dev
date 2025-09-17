.section .data
gdt_start:
    .quad 0x0000000000000000         # Null descriptor
    .quad 0x00CF9A000000FFFF         # Code segment
    .quad 0x00CF92000000FFFF         # Data segment
gdt_end:

gdt_descriptor:
    .word gdt_end - gdt_start - 1    # Limit
    .long gdt_start                  # Base

.section .text
.global load_gdt
.extern c_kernel_main               # Declare C function

load_gdt:
    lgdt gdt_descriptor              # Load the GDT

    mov $0x10, %ax                   # Data segment selector (2 << 3)
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

    ljmp $0x08, $flush_cs            # Far jump to update CS

flush_cs:
    mov $0x90000, %esp               # Set up stack pointer
    mov $0x90000, %ebp

    call c_kernel_main               # Call C kernel entry
.hang:
    cli
    hlt
    jmp .hang
