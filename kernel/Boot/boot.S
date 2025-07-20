
# boot.S
.set MULTIBOOT_MAGIC, 0x1BADB002
.set MULTIBOOT_FLAGS, 0x0
.set MULTIBOOT_CHECKSUM, -(MULTIBOOT_MAGIC + MULTIBOOT_FLAGS)

.section .multiboot
    .long MULTIBOOT_MAGIC
    .long MULTIBOOT_FLAGS
    .long MULTIBOOT_CHECKSUM

.section .text
.global _start
.extern c_kernel_main

_start:
    call load_gdt         # Load GDT before jumping to C code
   # call c_kernel_main
    

    cli
.hang:
    hlt
    jmp .hang
