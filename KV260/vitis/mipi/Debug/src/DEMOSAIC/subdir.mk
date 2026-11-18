################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/DEMOSAIC/demosaic.c \
../src/DEMOSAIC/demosaic1.c \
../src/DEMOSAIC/demosaic2.c 

OBJS += \
./src/DEMOSAIC/demosaic.o \
./src/DEMOSAIC/demosaic1.o \
./src/DEMOSAIC/demosaic2.o 

C_DEPS += \
./src/DEMOSAIC/demosaic.d \
./src/DEMOSAIC/demosaic1.d \
./src/DEMOSAIC/demosaic2.d 


# Each subdirectory must supply rules for building sources it contributes
src/DEMOSAIC/%.o: ../src/DEMOSAIC/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v8 gcc compiler'
	aarch64-none-elf-gcc -DKV260_JPEG_MODE=1 -Wall -O0 -g3 -I"R:\KV260\third_party\libjpeg-turbo-3.0.4" -I"R:\KV260\jpeg_benchmark\build-kv260-arm64-notls" -c -fmessage-length=0 -MT"$@" -IR:/KV260/vitis/kv260_video_wrapper/export/kv260_video_wrapper/sw/kv260_video_wrapper/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


