################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/SDCARD/bmp.c \
../src/SDCARD/sdReadWrite.c 

OBJS += \
./src/SDCARD/bmp.o \
./src/SDCARD/sdReadWrite.o 

C_DEPS += \
./src/SDCARD/bmp.d \
./src/SDCARD/sdReadWrite.d 


# Each subdirectory must supply rules for building sources it contributes
src/SDCARD/%.o: ../src/SDCARD/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v8 gcc compiler'
	aarch64-none-elf-gcc -DKV260_JPEG_MODE=1 -Wall -O0 -g3 -I"R:\KV260\third_party\libjpeg-turbo-3.0.4" -I"R:\KV260\jpeg_benchmark\build-kv260-arm64-notls" -c -fmessage-length=0 -MT"$@" -IR:/KV260/vitis/kv260_video_wrapper/export/kv260_video_wrapper/sw/kv260_video_wrapper/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


