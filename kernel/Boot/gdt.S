# gdt.s

.section .data
gdt_start:
    .quad 0x0000000000000000         # Null descriptor
    .quad 0x00CF9A000000FFFF         # Code segment descriptor
    .quad 0x00CF92000000FFFF         # Data segment descriptor
gdt_end:

gdt_descriptor:
    .word gdt_end - gdt_start - 1    # GDT size (limit)
    .long gdt_start                  # GDT base address

.section .text
.global load_gdt
.extern c_kernel_main        # ✅ Declare the external C function here
load_gdt:
    lgdt gdt_descriptor              # Load GDT register with our descriptor

    mov $0x10, %ax                   # 0x10 = Data Segment (index 2 << 3)
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss                     # Set up all data segment registers

    ljmp $0x08, $flush_cs            # Far jump to reload CS (0x08 = Code Segment)

flush_cs:
    mov $0x90000, %esp               # Set up stack pointer (stack top at 0x90000)
    mov $0x90000, %ebp               # Optional: set base pointer

    call c_kernel_main                 # Call your C kernel main function

halt:
    cli
    hlt                              # Halt CPU
    jmp halt                         # Infinite loop



