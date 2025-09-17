.intel_syntax noprefix

.global isr0
.global isr1
.global isr2
.global isr3
.global isr4
.global isr5
.global isr6
.global isr7
.global isr8
.global isr9
.global isr10
.global isr11
.global isr12
.global isr13
.global isr14
.global isr15
.global isr16
.global isr17
.global isr18
.global isr19
.global isr20
.global isr21
.global isr22
.global isr23
.global isr24
.global isr25
.global isr26
.global isr27
.global isr28
.global isr29
.global isr30
.global isr31

.extern isr_handler

.section .text

.macro ISR_NO_ERR n
isr\n:
    cli
    pusha
    push \n
    call isr_handler
    add esp, 4
    popa
    sti
    iret
.endm

.macro ISR_ERR n
isr\n:
    cli
    pusha
    mov eax, [esp + 32]     # get error code
    push eax
    push \n
    call isr_handler
    add esp, 8
    popa
    sti
    iret
.endm

# 0–7: No error code
ISR_NO_ERR 0
ISR_NO_ERR 1
ISR_NO_ERR 2
ISR_NO_ERR 3
ISR_NO_ERR 4
ISR_NO_ERR 5
ISR_NO_ERR 6
ISR_NO_ERR 7

# 8: Double Fault (has error code)
ISR_ERR    8

# 9: No error
ISR_NO_ERR 9

# 10–14: Have error code
ISR_ERR    10
ISR_ERR    11
ISR_ERR    12
ISR_ERR    13
ISR_ERR    14

# 15–31: No error
ISR_NO_ERR 15
ISR_NO_ERR 16
ISR_NO_ERR 17
ISR_NO_ERR 18
ISR_NO_ERR 19
ISR_NO_ERR 20
ISR_NO_ERR 21
ISR_NO_ERR 22
ISR_NO_ERR 23
ISR_NO_ERR 24
ISR_NO_ERR 25
ISR_NO_ERR 26
ISR_NO_ERR 27
ISR_NO_ERR 28
ISR_NO_ERR 29

# 30: Has error
ISR_ERR    30

# 31: No error
ISR_NO_ERR 31
