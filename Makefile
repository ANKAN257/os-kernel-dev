# ===========================
# 🔧 CONFIGURATION SECTION
# ===========================

# Find all C and Assembly source files in the kernel directory
C_SOURCES := $(shell find kernel -name "*.c")
ASM_SOURCES := $(shell find kernel -name "*.S")





# Convert them into object file names
C_OBJECTS   := $(C_SOURCES:.c=.o)
ASM_OBJECTS := $(ASM_SOURCES:.S=.o)

# All object files to be linked
ALL_OBJECTS := $(C_OBJECTS) $(ASM_OBJECTS)

# Output binary and ISO file
KERNEL_BIN  := kernel.bin
ISO_NAME    := catkernel.iso
ISO_DIR     := iso
GRUB_CFG    := boot/grub/grub.cfg

# Compilers and Linker
CC := gcc
LD := ld

# Compiler Flags
# -m32 => 32-bit mode
# -ffreestanding => no standard library
# -nostdlib => don't use the host system libraries
# -fno-pic & -fno-pie => disable position-independent code
CFLAGS  := -m32 -ffreestanding -nostdlib -fno-pic -fno-pie

# Linker Flags with linker script
LDFLAGS := -m elf_i386 -T kernel/Linker/linker.ld

# Automatically include header paths
INCLUDE_DIRS := $(shell find kernel -type d)
CFLAGS += $(patsubst %, -I%, $(INCLUDE_DIRS))

# ===========================
# 🛠️ BUILD RULES
# ===========================

# Default target to build the kernel
all: $(KERNEL_BIN)

# Rule to compile C source files to object files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Rule to compile Assembly source files to object files
%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

# Link all object files into a final kernel binary
$(KERNEL_BIN): $(ALL_OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $(ALL_OBJECTS)

# ===========================
# 💿 ISO CREATION
# ===========================

# Build a bootable ISO using GRUB
iso: $(KERNEL_BIN)
	mkdir -p $(ISO_DIR)/boot/grub
	cp $(KERNEL_BIN) $(ISO_DIR)/boot/kernel.bin
	cp $(GRUB_CFG) $(ISO_DIR)/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO_NAME) $(ISO_DIR)

# ===========================
# 🚀 RUN IN QEMU
# ===========================

# Run the kernel in QEMU emulator
run: iso
	qemu-system-i386 -cdrom $(ISO_NAME)

# ===========================
# 🧹 CLEANUP
# ===========================

# Clean up build files
clean:
	rm -f $(ALL_OBJECTS) $(KERNEL_BIN) $(ISO_NAME)
	rm -rf *.o */*.o */*/*.o *.bin *.iso
	rm -rf $(ISO_DIR)
