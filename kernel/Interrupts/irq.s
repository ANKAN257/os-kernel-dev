.section .text
.global irq0, irq1, irq2, irq3, irq4, irq5, irq6, irq7
.global irq8, irq9, irq10, irq11, irq12, irq13, irq14, irq15

.extern irq_handler

.macro IRQ n
irq\n:
    cli
    pushl $(32 + \n)     # IRQ number + 32 to match IDT offset
    jmp irq_common_stub
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

irq_common_stub:
    pusha                      # Push general-purpose registers
    push %ds
    push %es
    push %fs
    push %gs

    mov $0x10, %ax             # Load kernel data segment selector
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs

    push %esp                  # Push pointer to register state
    call irq_handler
    pop %esp

    pop %gs
    pop %fs
    pop %es
    pop %ds
    popa

    add $4, %esp               # Clean up pushed IRQ number
    sti
    iret
