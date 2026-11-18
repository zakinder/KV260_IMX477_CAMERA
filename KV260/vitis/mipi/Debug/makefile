################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/VTC/subdir.mk
-include src/VDMA/subdir.mk
-include src/UART/subdir.mk
-include src/SENSORS_CONFIG/OV5647/subdir.mk
-include src/SENSORS_CONFIG/OV5640/subdir.mk
-include src/SENSORS_CONFIG/IMX682/subdir.mk
-include src/SENSORS_CONFIG/IMX519/subdir.mk
-include src/SENSORS_CONFIG/IMX477/subdir.mk
-include src/SENSORS_CONFIG/IMX219/subdir.mk
-include src/SENSORS_CONFIG/AR1335/subdir.mk
-include src/SENSORS_CONFIG/AP1302/subdir.mk
-include src/SENSORS_CONFIG/subdir.mk
-include src/SDCARD/subdir.mk
-include src/PLATFORM/subdir.mk
-include src/MIPI/subdir.mk
-include src/MENU/subdir.mk
-include src/LWIP/subdir.mk
-include src/DP_VIDEO/subdir.mk
-include src/DP_CLOCK/subdir.mk
-include src/DEMOSAIC/subdir.mk
-include src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
ELFSIZE += \
mipi.elf.size \


# All Target
all: mipi.elf secondary-outputs

# Tool invocations
mipi.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: ARM v8 gcc linker'
	aarch64-none-elf-gcc -L"R:\KV260\jpeg_benchmark\build-kv260-arm64-notls" -Wl,-Map=mipi.map -Wl,-T -Wl,../src/lscript.ld -LR:/KV260/vitis/kv260_video_wrapper/export/kv260_video_wrapper/sw/kv260_video_wrapper/standalone_domain/bsplib/lib -o "mipi.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

mipi.elf.size: mipi.elf
	@echo 'Invoking: ARM v8 Print Size'
	aarch64-none-elf-size mipi.elf  |tee "mipi.elf.size"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(EXECUTABLES)$(OBJS)$(S_UPPER_DEPS)$(C_DEPS)$(ELFSIZE) mipi.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE)

.PHONY: all clean dependents

-include ../makefile.targets
