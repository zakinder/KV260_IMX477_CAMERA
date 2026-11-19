# Refined portrait output on KV260

Build the jpeg project with the updated VFP 2.0 from KV260/ip_lib. In Vivado, refresh the IP catalog, review Report IP Status, upgrade the VFP instance to the packaged revision 154 and regenerate the block design output products. Rebuild implementation and the bitstream, export the matching XSA, then rebuild the bare-metal application. Previously exported bitstreams and boot images contain the older selector.

In Camera Studio, choose **30 Refined portrait** and apply the output path. The serial Live VFP filters menu also provides **8 Refined portrait**. From firmware the equivalent call is:

```c
per_write_reg(VFP_OUTPUT_CHANNEL_SELECT, VFP_PREVIEW_REFINED_PORTRAIT);
```

Register 16 is at offset 0x40 (physical address 0xA0030040 in the checked-in BSP). Value 30 selects portrait and 0 restores camera bypass. Program width and height in register 19 as usual. After a geometry change, supply a fresh input SOF. Portrait accepts full RGB10 camera beats, processes the upper eight bits per component and returns a native-size raster. Compared with the standalone BMP demo, the 2×2 reduction is removed. Spatial filter radii are measured in native pixels.

Line buffers advance on valid camera samples. The next frame supplies the lookahead for the tail of the preceding frame. The first output after reset requires approximately nine active rows of input. Switching to or from portrait can skip a frame while waiting for the requested source's SOF. Existing VFP output FIFO capacity and stall limits still apply.

The standalone regression tb_portrait_stream exercises runtime geometry smaller than the maximum allocation, consecutive frames, input-valid gaps, marker alignment and per-frame RGB CRCs. Hardware timing, utilization and live display/JPEG capture require a Vivado build and board run.
