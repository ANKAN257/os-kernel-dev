# ===========================
# 🔧 CONFIGURATION SECTION
# ===========================

# Automatically find source files
C_SOURCES     := $(shell find kernel -name "*.c")
ASM_SOURCES   := $(shell find kernel -name "*.S")
# NASM_SOURCES  := $(shell find kernel -name "*.asm")

# Convert source files to object files
C_OBJECTS     := $(C_SOURCES:.c=.o)
ASM_OBJECTS   := $(ASM_SOURCES:.S=.o)
# NASM_OBJECTS  := $(NASM_SOURCES:.asm=.o)

# Combine all object files
ALL_OBJECTS   := $(C_OBJECTS) $(ASM_OBJECTS) 

# Output binaries
KERNEL_BIN    := kernel.bin
ISO_NAME      := catkernel.iso
ISO_DIR       := iso
GRUB_CFG      := boot/grub/grub.cfg

# Tools
CC            := gcc
AS            := nasm
LD            := ld

# Flags
CFLAGS        := -m32 -ffreestanding -nostdlib -fno-pic -fno-pie
# ASFLAGS       := -f elf32
LDFLAGS       := -m elf_i386 -T kernel/Linker/linker.ld

# Include directories from kernel/
INCLUDE_DIRS  := $(shell find kernel -type d)
CFLAGS       += $(patsubst %, -I%, $(INCLUDE_DIRS))

# ===========================
# 🛠️ BUILD RULES
# ===========================

# Default target
all: $(KERNEL_BIN)

# C to object
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# AT&T Assembly to object
%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

# NASM Assembly to object
# %.o: %.asm
# 	$(AS) $(ASFLAGS) $< -o $@

# Link all objects into kernel binary
$(KERNEL_BIN): $(ALL_OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $(ALL_OBJECTS)

# ===========================
# 💿 ISO CREATION
# ===========================

iso: $(KERNEL_BIN)
	mkdir -p $(ISO_DIR)/boot/grub
	cp $(KERNEL_BIN) $(ISO_DIR)/boot/kernel.bin
	cp $(GRUB_CFG) $(ISO_DIR)/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO_NAME) $(ISO_DIR)

# ===========================
# 🚀 RUN IN QEMU
# ===========================

run: iso
	qemu-system-i386 -cdrom $(ISO_NAME)

# ===========================
# 🧹 CLEANUP
# ===========================

clean:
	rm -f $(ALL_OBJECTS) $(KERNEL_BIN) $(ISO_NAME)
	rm -rf $(ISO_DIR)
