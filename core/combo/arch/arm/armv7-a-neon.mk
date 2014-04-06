# Configuration for Linux on ARM.
# Generating binaries for the ARMv7-a architecture and higher with NEON
#
ARCH_ARM_HAVE_ARMV7A            := true
ARCH_ARM_HAVE_VFP               := true
ARCH_ARM_HAVE_VFP_D32           := true
ARCH_ARM_HAVE_NEON              := true

ifeq ($(strip $(TARGET_CPU_VARIANT)), cortex-a15)
	arch_variant_cflags := -mcpu=cortex-a15
else
ifeq ($(strip $(TARGET_CPU_VARIANT)),cortex-a9)
	arch_variant_cflags := -mcpu=cortex-a9
else
ifeq ($(strip $(TARGET_CPU_VARIANT)),cortex-a8)
	arch_variant_cflags := -mcpu=cortex-a8
else
ifeq ($(strip $(TARGET_CPU_VARIANT)),cortex-a7)
	arch_variant_cflags := -mcpu=cortex-a7
else
ifeq ($(strip $(TARGET_CPU_VARIANT)),cortex-a5)
	arch_variant_cflags := -mcpu=cortex-a5
else
ifeq ($(strip $(TARGET_CPU_VARIANT)),krait)
	arch_variant_cflags := -mcpu=cortex-a15
else
ifeq ($(strip $(TARGET_CPU_VARIANT)),scorpion)
	arch_variant_cflags := -mcpu=cortex-a8
else
	arch_variant_cflags := -march=armv7-a
endif
endif
endif
endif
endif
endif
endif

arch_variant_cflags += \
    -mfloat-abi=softfp \
    -mfpu=neon

#is an FPU explicitly defined?
ifeq ($(strip $(TARGET_ARCH_VARIANT_FPU)),)
	#no, so figure out if one is set on the GLOBAL_CFLAGS
	currentfpu := $(strip $(filter -mfpu=%,$(TARGET_GLOBAL_CFLAGS)))

	#if one is, then use that as ARCH_VARIANT_FPU
	ifneq ($(currentfpu),)
		TARGET_ARCH_VARIANT_FPU := $(strip $(subst -mfpu=,,$(currentfpu)))
	else
		TARGET_ARCH_VARIANT_FPU := neon
	endif # ifneq ($(currentfpu),)
endif # ifeq ($(strip $(TARGET_ARCH_VARIANT_FPU),)

#get rid of existing instances of -mfpu in TARGET_GLOBAL_CP*FLAGS
TARGET_GLOBAL_CFLAGS := $(filter-out -mfpu=%,$(TARGET_GLOBAL_CFLAGS))
TARGET_GLOBAL_CPPFLAGS := $(filter-out -mfpu=%,$(TARGET_GLOBAL_CPPFLAGS))
arch_variant_cflags += -mfpu=$(TARGET_ARCH_VARIANT_FPU)

ifneq ($(findstring neon,$(TARGET_ARCH_VARIANT_FPU)),)
arch_variant_cflags += -fno-tree-vectorize
endif

#is a float-abi explicitly defined?
ifeq ($(strip $(TARGET_ARCH_VARIANT_FLOAT_ABI)),)
	#no, so figure out if one is set on the GLOBAL_CFLAGS
	currentfloatabi := $(strip $(filter -mfloat-abi=%,$(TARGET_GLOBAL_CFLAGS)))

	#if one is, then use that as ARCH_VARIANT_FLOAT_ABI
	ifneq ($(currentfloatabi),)
		TARGET_ARCH_VARIANT_FLOAT_ABI := $(strip $(subst -mfloat-abi=,,$(currentfloatabi)))
	else
		TARGET_ARCH_VARIANT_FLOAT_ABI := softfp
	endif # ifneq ($(currentfloatabi),)
endif # ifeq ($(strip $(TARGET_ARCH_VARIANT_FLOAT_ABI)),)

#get rid of existing instances of -mfloat-abi in TARGET_GLOBAL_CP*FLAGS
TARGET_GLOBAL_CFLAGS := $(filter-out -mfloat-abi=%,$(TARGET_GLOBAL_CFLAGS))
TARGET_GLOBAL_CPPFLAGS := $(filter-out -mfloat-abi=%,$(TARGET_GLOBAL_CPPFLAGS))
arch_variant_cflags += -mfloat-abi=$(TARGET_ARCH_VARIANT_FLOAT_ABI)

arch_variant_ldflags := \
	-Wl,--fix-cortex-a8
