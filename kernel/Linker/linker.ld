SECTIONS
{
    .text : {
        *(.text)
    } :text

    .rodata : {
        *(.rodata)
    }

    .data : {
        *(.data)
    }

    .bss : {
        *(.bss COMMON)
    }
}

PHDRS
{
    text PT_LOAD FLAGS(0x5); /* R + X */
    data PT_LOAD FLAGS(0x6); /* R + W */
}
