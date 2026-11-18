################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/PLATFORM/platform.c \
../src/PLATFORM/platform_zynqmp.c \
../src/PLATFORM/zynq_interrupt.c 

OBJS += \
./src/PLATFORM/platform.o \
./src/PLATFORM/platform_zynqmp.o \
./src/PLATFORM/zynq_interrupt.o 

C_DEPS += \
./src/PLATFORM/platform.d \
./src/PLATFORM/platform_zynqmp.d \
./src/PLATFORM/zynq_interrupt.d 


# Each subdirectory must supply rules for building sources it contributes
src/PLATFORM/%.o: ../src/PLATFORM/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v8 gcc compiler'
	aarch64-none-elf-gcc -DKV260_JPEG_MODE=1 -Wall -O0 -g3 -I"R:\KV260\third_party\libjpeg-turbo-3.0.4" -I"R:\KV260\jpeg_benchmark\build-kv260-arm64-notls" -c -fmessage-length=0 -MT"$@" -IR:/KV260/vitis/kv260_video_wrapper/export/kv260_video_wrapper/sw/kv260_video_wrapper/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


