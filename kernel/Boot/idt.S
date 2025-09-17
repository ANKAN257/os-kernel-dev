# idt.S

.globl load_idt
.globl isr_default

load_idt:
    movl 4(%esp), %eax     # Load pointer from stack into eax
    lidt (%eax)            # Load IDT
    ret

isr_default:
    pusha                  # Save all general purpose registers
    cli                    # Clear interrupts
.loop:
    hlt                    # Halt CPU
    jmp .loop              # Keep halting to prevent continuation
    popa                   # Restore registers (unreachable)
    iret                   # Return from interrupt (unreachable)
