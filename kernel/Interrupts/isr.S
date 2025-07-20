.extern isr_handler

.section .text
.globl isr0, isr1, isr2, isr3, isr4, isr5, isr6, isr7
.globl isr8, isr9, isr10, isr11, isr12, isr13, isr14, isr15
.globl isr16, isr17, isr18, isr19, isr20, isr21, isr22, isr23
.globl isr24, isr25, isr26, isr27, isr28, isr29, isr30, isr31

.macro ISR_NOERR num
isr\num:
    cli
    pushl $0        # dummy error code
    pushl $\num     # interrupt number
    jmp isr_common_stub
.endm

.macro ISR_ERR num
isr\num:
    cli
    pushl $\num     # interrupt number only (error code already pushed by CPU)
    jmp isr_common_stub
.endm

# No error code (push dummy error code)
ISR_NOERR 0
ISR_NOERR 1
ISR_NOERR 2
ISR_NOERR 3
ISR_NOERR 4
ISR_NOERR 5
ISR_NOERR 6
ISR_NOERR 7
# Has error code
ISR_ERR   8
# No error
ISR_NOERR 9
# Has error
ISR_ERR 10
ISR_ERR 11
ISR_ERR 12
ISR_ERR 13
ISR_ERR 14
# No error
ISR_NOERR 15
ISR_NOERR 16
ISR_NOERR 17
ISR_NOERR 18
ISR_NOERR 19
ISR_NOERR 20
ISR_NOERR 21
ISR_NOERR 22
ISR_NOERR 23
ISR_NOERR 24
ISR_NOERR 25
ISR_NOERR 26
ISR_NOERR 27
ISR_NOERR 28
ISR_NOERR 29
ISR_NOERR 30
ISR_NOERR 31

# Common ISR handler
isr_common_stub:
    pusha
    push %ds
    push %es
    push %fs
    push %gs

    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs

    push %esp         # pointer to registers
    call isr_handler
    add $4, %esp      # clean up parameter to handler

    pop %gs
    pop %fs
    pop %es
    pop %ds
    popa

    add $8, %esp      # pop error code and int number
    sti
    iret
