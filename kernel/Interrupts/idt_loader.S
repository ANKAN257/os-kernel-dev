# idt_loader.S (AT&T syntax)
.globl load_idt
load_idt:
    movl 4(%esp), %eax   # Get pointer argument from stack into EAX
    lidt (%eax)          # Load IDT from the pointer
    ret
