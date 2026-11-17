# KV260 bare-metal JPEG encoder benchmark

Keep the current VFP FIFO bitstream, UART commands, UDP sender, and Windows player. Replace only `mipi/src/LWIP/jpeg_snapshot.c` with the supplied application source. Keep the per-file `-O2` setting.

## Build the AArch64 static library on Windows

Download the libjpeg-turbo 3.0.4 source from https://github.com/libjpeg-turbo/libjpeg-turbo/releases/tag/3.0.4. Install CMake and Ninja. Use the same aarch64-none-elf GCC toolchain as Vitis 2022.1. This is a bare-metal cross-build recipe and must be verified with your installed toolchain.

Run in CMD from the directory containing the supplied toolchain file. Adjust the source and toolchain paths. The toolchain path must contain aarch64-none-elf-gcc.exe.

```bat
set "KV260_TURBO_SRC=R:/KV260/third_party/libjpeg-turbo-3.0.4"
set "KV260_VITIS_GCC=REPLACE_WITH_YOUR_VITIS_GCC_BIN_DIRECTORY"
cmake -S "%KV260_TURBO_SRC%" -B build-kv260 -G Ninja -DCMAKE_TOOLCHAIN_FILE="%CD%/kv260-aarch64-baremetal.cmake" -DKV260_TOOLCHAIN_BIN="%KV260_VITIS_GCC%" -DCMAKE_BUILD_TYPE=Release -DENABLE_SHARED=OFF -DENABLE_STATIC=ON -DWITH_TURBOJPEG=OFF -DWITH_SIMD=ON
cmake --build build-kv260 --target jpeg-static
```

Check the configure output for enabled Arm SIMD. Confirm it produced the AArch64 static archive (normally `build-kv260/libjpeg.a`). An x64 Windows or Linux AArch64 library is incompatible with the standalone Vitis application.

## Vitis application settings

- Add the libjpeg-turbo source directory and the generated `build-kv260` directory to the compiler include paths. They provide jpeglib.h, jerror.h, and the generated jconfig.h.
- In the ARM v8 gcc linker settings, add `build-kv260` as a library search path and `jpeg` as a library.
- Increase the application heap in the active linker script to `0x400000` (4 MiB) in DDR for libjpeg-turbo's internal allocations. Keep your existing stack settings. Verify the linker map fits DDR and does not overlap any reserved video memory.
- Add `KV260_JPEG_MODE=2` under compiler Symbols. Clean, rebuild, and boot the app.

## Run the benchmark

| Define | What runs |
|---|---|
| `KV260_JPEG_MODE=0` (default) | Original STB encoder. The external library is unnecessary in this mode. |
| `KV260_JPEG_MODE=2` | Encodes the same captured frame twice, logs both durations and sizes, and sends the libjpeg-turbo JPEG. |
| `KV260_JPEG_MODE=1` | Encodes each frame only with libjpeg-turbo. Use this for streaming FPS. |

With mode 2, open the Windows receiver and press `j` + Enter a few times. Look for `JPEG same-frame comparison:`. Both use quality 75, but compare the output visually because the two encoders may differ. Then rebuild with mode 1, press `k` + Enter, and collect 10–20 frames. The target is about 500 ms or less per encode and approximately 1 received fps.

The Vitis cross-build, SIMD dispatch, and KV260 timing require on-board verification. Keep the original working ELF or BOOT.bin available.
