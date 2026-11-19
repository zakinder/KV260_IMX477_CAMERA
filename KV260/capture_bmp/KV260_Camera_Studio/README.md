# KV260 Camera Studio

Windows 4K KJPG viewer with IMX477 and VFP controls for the existing KV260
bare-metal project. Based on `zakinder/KV260_IMX477_CAMERA`, branch `jpeg`,
commit `51bfa98fd1241446c4e780dbebd5d63101708851`.

## What is included

- `windows/kv260_camera_studio.py`: video and control GUI.
- `windows/kjpg.py`, `video_engine.py`, `control_client.py`: viewer support.
- `board/mipi/src/LWIP/lwip_app.c` and `.h`: the branch versions with a small
  control initialization/polling change and idempotent stream control.
- `board/mipi/src/LWIP/gui_control.c` and `.h`: the new board endpoint.
- `patches/`: reviewable changes to the existing application files.
- `tests/`: synthetic frame, protocol, GUI and C mock tests.

No FPGA RTL, BSP driver, JPEG worker, UDP video packet format or video pacing
is changed. No prebuilt ELF, bitstream or BOOT.bin is included.

## Update from the first Camera Studio release

The CCM page now has **Use camera input**, **Show this CCM**, and **Show
bypass** buttons. Applying a matrix writes coefficients; it does not select an
output path. The VFP starts in bypass, so matrix edits will not appear there.

If Camera Studio is already installed, close it and replace only the existing
`windows/kv260_camera_studio.py` with the file from this ZIP. The Dark and
Light path buttons work with the original Camera Studio board firmware.
No Vitis rebuild is needed to try them.

The original board control firmware does not allow output 18, which is needed
for the Balance CCM. To enable that path, also replace the existing
`mipi/src/LWIP/gui_control.c` with this package's updated copy, rebuild
`mipi.elf`, and create/program a boot image using the same known-working BIF,
bitstream, workers, and boot settings. Until then, the GUI reports the rejected
command. Back up your installed source and working boot image first. The
updated board code has only been host-tested with mocks.

## Before installing the board files

The changes assume your local application matches the commit above. Back up
your current `lwip_app.c`, `lwip_app.h`, working BIF and BOOT.bin. Also back
up any existing `gui_control.c` or `gui_control.h` in that directory.

If the workspace is a Git checkout, check your sources in PowerShell:

```powershell
$vitisRoot = "R:\KV260\vitis"
$commit = "51bfa98fd1241446c4e780dbebd5d63101708851"
git -C $vitisRoot cat-file -e "$commit^{commit}"
git -C $vitisRoot diff --name-only $commit -- `
  "mipi/src/LWIP/lwip_app.c" `
  "mipi/src/LWIP/lwip_app.h" `
  "mipi/src/SENSORS_CONFIG/IMX477/imx477.c" `
  "mipi/src/SENSORS_CONFIG/IMX477/imx477.h" `
  "mipi/src/MENU/vfp_registers.h"
```

If Git cannot find the commit, fetch the `jpeg` branch first. If the diff
lists files, preserve those changes and merge the patches instead of blindly
replacing your files. The source and header for the existing IMX477 tuning
functions and the VFP register map must match or be reviewed for compatibility.

## Build the board application

1. Copy the four files from `board/mipi/src/LWIP/` into
   `R:\KV260\vitis\mipi\src\LWIP\` after making the backups above.
2. In Vitis 2022.1, refresh the `mipi` project. Build it. If a newly added
   file is not picked up, refresh and clean/rebuild the **mipi application**.
3. Confirm the console compiles `gui_control.c` and `lwip_app.c` and links
   `mipi.elf` successfully. An undefined `gui_control_start` or
   `gui_control_poll` means the new source has not been compiled/linked.
   The board code has been host-tested with mocks, not compiled with Vitis.
4. If you have just restored the BSP sources, confirm the platform/BSP was
   rebuilt before rebuilding `mipi`; this GUI upgrade itself does not modify
   the BSP. If the rebuild overwrites other generated sources, inspect them.
5. Create a new boot image using your **previously working** BIF and the new
   `mipi.elf`. Preserve the existing FSBL, PMU firmware if used, bitstream,
   JPEG worker ELFs, CPU assignments, and known-working boot/flash settings.
   Keep a copy of the working boot image. Program/verify using your established
   KV260 workflow, then power-cycle. A new boot image has not been built here.

The VFP controls depend on the running PL bitstream matching the analyzed VFP
design. A matching source tree does not itself prove the board bitstream matches.
Whether a particular VFP change appears in the UDP video also depends on the
VDMA capture tap in the running design; verify both the monitor and the stream.
In the referenced block design, VFP `ovideo` connects to AXI VDMA 0 S2MM,
which is the source used by the JPEG pipeline. Confirm the flashed bitstream
matches that design before relying on that connection.

## Windows setup

Python 3 with Tkinter and Pillow is needed. In PowerShell:

```powershell
py -3 -m pip install -r .\windows\requirements.txt
py -3 .\windows\kv260_camera_studio.py
```

Run those commands from the extracted package directory, or double-click
`windows\Launch_Camera_Studio.bat` after installing Pillow. Close the old
UDP 8081 receiver first: two programs cannot normally bind the same video port.

The default board IP is `192.168.0.10`, video port is 8081 and control port is
8082. Video and control ports on the board are fixed in this build. The source
filter in the GUI uses the Board IP. The existing board sender defaults to
destination `192.168.0.42`; this GUI does not change that destination. Ensure
the PC interface receiving video has the destination address configured by your
working board application.

## First use

1. Launch the GUI. Click **Start receiver**.
2. On the board's UART menu, press `k` + Enter. This first action initializes
   Ethernet/lwIP and starts the stream; after a board reset UDP 8082 is not
   available until the existing network initialization runs. It may take a
   few seconds for the IP setup to finish.
3. Click **Check board**. Wait for `Control: connected`. If there is no reply,
   check that the new ELF is actually running, UART reports the control port,
   the board/PC IP addresses and firewall allow UDP, then retry. If the old
   firmware is running, video can work but control will not reply.
4. Click **Read sensor settings**. The status shows exposure lines, frame
   length, analog gain, DOL state, long-exposure shift and Gr/R/B/Gb gains.
   If it says global gain mode, use **Use per-channel gain**, then read again.
5. Turn a channel knob or type a multiplier and click that channel's **Apply**.
   The GUI does not write the device merely because it is opened or a knob is
   moved. The editable range is deliberately limited to 1.0–8.0×; readback
   outside this range is shown as text without being loaded into the knob.
6. Choose an exposure preset and click **Apply exposure**. The project maps
   these to 5/15/35/60/90% of usable frame lines. Existing SDR/HDR checks and
   sensor register write/readback are used. The existing tuning routine puts
   the camera into standby while writing, so each apply can briefly interrupt
   video and control operations may take time. Avoid continuous knob dragging
   followed by rapid repeated Apply presses.
7. Once the control endpoint is running, GUI **Start board stream** and
   **Stop board stream** are idempotent. `Start/Stop receiver` only starts or
   stops the Windows listener; stopping it does not stop board transmission.

If a command times out, the board may have applied it even though the reply
was lost. Read sensor settings or inspect the video state before trying again.
For VFP writes the acknowledgement means software issued the register writes;
it does not verify the PL bitstream or prove the expected visual change.

## Color controls

### CCM path test

After connecting the board and starting live video:

1. On **CCM**, select **Light • HSV path**, click **Use camera input** and
   then **Show this CCM**. The selected output is 22. These actions change
   board registers, including the video displayed on the monitor.
2. Click **Edit identity**, then **Apply matrix**. This supplies a known
   baseline. The editor is not a readback of the current FPGA matrix.
3. Change the bottom-right coefficient from `1.000` to `0.500` and click
   **Apply matrix**. The source design's HSV value channel should darken if
   the active bitstream implements that path. Compare the PC window and the
   board monitor, and move a hand in view to make sure frames are updating.
4. To restore the original unprocessed view, click **Show bypass**. To return
   the edited matrix to identity, click **Edit identity** and **Apply matrix**.

The path buttons select these source-design routes:

| CCM bank | VFP output | Route |
| --- | ---: | --- |
| Dark | 6 | Dark CCM output; its input comes from the Light/HSV path |
| Light | 22 | Light CCM followed by HSV-to-RGB |
| Balance | 18 | Balance CCM followed by YCbCr-to-RGB; updated board firmware required |

If the output 22 test has no visible effect, it is not proof of a bad matrix.
Check that the stream is live, try **Show bypass**, and compare the board
monitor with the UDP window. The UDP acknowledgment proves only that the
firmware issued the write; it does not confirm the FPGA read it or show which
bitstream is running.

- **VFP:** output selector, RGB input selector, four contrast parameters,
  saturation/exposure raw parameters, CMYK keys, centroid LUT, and the shared
  Sobel threshold/test-pattern register. Actual effect depends on the selected
  VFP path. The Sobel threshold and test-pattern number share one register.
  To experiment with the saturation block, use RGB input 3 and output 2, then
  set its parameters; these raw values are design-specific, not photographic
  saturation percentages. Contrast selector 2 is present in the register
  selector but its effect is not established by the active datapath.
- **CCM:** Dark/RGB, Light/HSV and Balance/YCbCr 3×3 blocks. `1.000` is encoded
  as 1024. Custom mode 15 treats diagonal values as unsigned and off-diagonal
  values as signed. The editor constrains diagonals to 0–4 and others to -2–2.
  The nine writes and selection are sequential, not an atomic frame update.
  The matrix has no effect on the bypass output. `Edit identity` changes the
  editor only; `Apply matrix` writes the selected hardware bank.
- **HSV / VFP hardware:** saturation and value gains are implemented by
  writing a diagonal Light/HSV CCM, with hue gain fixed at 1.0. This replaces
  that bank's custom matrix and selects mode 15. Use output 22 to select the
  HSV-to-RGB path and RGB input 0 for camera RGB. The running bitstream and
  visual effect still need verification on the board. The VFP source does not
  expose a hue-offset control; no bitstream changes are made by this package.
- **HSV / Windows preview:** hue offset, saturation and value multipliers are
  applied locally after JPEG decoding and downscaling. They do not modify the
  FPGA, sensor, DisplayPort output, or the saved original JPEG.

The window preserves the full image aspect ratio when resized. Rotation and
preview HSV are local display controls. **Save received JPEG** saves the
original received frame, not the scaled or color-adjusted preview.

## Interpreting results

The video receiver keeps one KJPG frame in progress, as the previous comparison
receiver did. A newer frame finalizes an incomplete older one; late/reordered
chunks can therefore look like missing chunks. It maintains a bounded latest
frame queue and may skip preview frames when decoding cannot keep up. The GUI
reports received FPS, incomplete frames and preview skips separately. It does
not repair UDP losses or guarantee a particular frame rate. Test full 4K,
frame freshness, display quality and timing on the actual KV260/Windows setup.

The control protocol is unauthenticated UDP. Use it only on a trusted network.
It uses port 8082 independently of the existing UDP 8080 control and 8081
video paths; a control request does not alter the stream destination.

## Validation performed

- Host GCC mock tests cover request parsing, bounds, sensor error/mode handling,
  CCM writes, reply handling, sender payload/pacing and control at a frame
  boundary. Two sender preprocessor configurations were compiled with mocks.
- Python tests cover out-of-order and missing KJPG chunks, sequence wrap,
  local UDP control replies, preview HSV and synthetic 3840×2160 JPEG decode.
- A Tk window was launched against a synthetic local board and 4K video source;
  sensor-read, gain, exposure and VFP HSV commands were exercised.
- Not yet validated with the Vitis toolchain, real I2C sensor, FPGA bitstream,
  Windows machine, actual board networking, full streaming performance or flash.
