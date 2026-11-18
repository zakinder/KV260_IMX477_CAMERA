################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/LWIP/jpeg_pipeline.c \
../src/LWIP/jpeg_snapshot.c \
../src/LWIP/lwip_app.c 

OBJS += \
./src/LWIP/jpeg_pipeline.o \
./src/LWIP/jpeg_snapshot.o \
./src/LWIP/lwip_app.o 

C_DEPS += \
./src/LWIP/jpeg_pipeline.d \
./src/LWIP/jpeg_snapshot.d \
./src/LWIP/lwip_app.d 


# Each subdirectory must supply rules for building sources it contributes
src/LWIP/%.o: ../src/LWIP/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v8 gcc compiler'
	aarch64-none-elf-gcc -DKV260_JPEG_MODE=1 -Wall -O0 -g3 -I"R:\KV260\third_party\libjpeg-turbo-3.0.4" -I"R:\KV260\jpeg_benchmark\build-kv260-arm64-notls" -c -fmessage-length=0 -MT"$@" -IR:/KV260/vitis/kv260_video_wrapper/export/kv260_video_wrapper/sw/kv260_video_wrapper/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/LWIP/jpeg_snapshot.o: ../src/LWIP/jpeg_snapshot.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v8 gcc compiler'
	aarch64-none-elf-gcc -DKV260_JPEG_MODE=1 -Wall -O2 -g3 -I"R:\KV260\third_party\libjpeg-turbo-3.0.4" -I"R:\KV260\jpeg_benchmark\build-kv260-arm64-notls" -c -fmessage-length=0 -MT"$@" -IR:/KV260/vitis/kv260_video_wrapper/export/kv260_video_wrapper/sw/kv260_video_wrapper/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"src/LWIP/jpeg_snapshot.d" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


