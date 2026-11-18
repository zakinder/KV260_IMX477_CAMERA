################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/DP_VIDEO/xdpdma.c \
../src/DP_VIDEO/xdpdma_video.c \
../src/DP_VIDEO/xdppsu_interrupt.c 

OBJS += \
./src/DP_VIDEO/xdpdma.o \
./src/DP_VIDEO/xdpdma_video.o \
./src/DP_VIDEO/xdppsu_interrupt.o 

C_DEPS += \
./src/DP_VIDEO/xdpdma.d \
./src/DP_VIDEO/xdpdma_video.d \
./src/DP_VIDEO/xdppsu_interrupt.d 


# Each subdirectory must supply rules for building sources it contributes
src/DP_VIDEO/%.o: ../src/DP_VIDEO/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v8 gcc compiler'
	aarch64-none-elf-gcc -DKV260_JPEG_MODE=1 -Wall -O0 -g3 -I"R:\KV260\third_party\libjpeg-turbo-3.0.4" -I"R:\KV260\jpeg_benchmark\build-kv260-arm64-notls" -c -fmessage-length=0 -MT"$@" -IR:/KV260/vitis/kv260_video_wrapper/export/kv260_video_wrapper/sw/kv260_video_wrapper/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


