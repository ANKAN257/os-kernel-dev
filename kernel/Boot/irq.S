.intel_syntax noprefix

.global irq0
.global irq1
.global irq2
.global irq3
.global irq4
.global irq5
.global irq6
.global irq7
.global irq8
.global irq9
.global irq10
.global irq11
.global irq12
.global irq13
.global irq14
.global irq15

.extern irq_handler

.section .text

.macro IRQ n
irq\n:
    cli
    pusha
    push ds
    push es
    push fs
    push gs
    mov ax, 0x10        # Load kernel data segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    push \n             # Push IRQ number
    call irq_handler
    add esp, 4          # Clean up pushed IRQ number
    pop gs
    pop fs
    pop es
    pop ds
    popa
    sti
    iret
.endm

IRQ 0
IRQ 1
IRQ 2
IRQ 3
IRQ 4
IRQ 5
IRQ 6
IRQ 7
IRQ 8
IRQ 9
IRQ 10
IRQ 11
IRQ 12
IRQ 13
IRQ 14
IRQ 15
