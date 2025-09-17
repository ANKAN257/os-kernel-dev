.set MULTIBOOT_MAGIC, 0x1BADB002
.set MULTIBOOT_FLAGS, 0
.set CHECKSUM, -(MULTIBOOT_MAGIC + MULTIBOOT_FLAGS)

.section .multiboot
    .long MULTIBOOT_MAGIC
    .long MULTIBOOT_FLAGS
    .long CHECKSUM

.section .text
.global _start
.extern load_gdt

_start:
    call load_gdt        # Let GDT file do everything (including calling C)
halt:
    cli
    hlt
    jmp halt
