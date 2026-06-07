# Patent Review Notice

**Project:** KV260 IMX477 Camera FPGA Video Processing  
**Designer:** Sakinder Ali  
**Repository:** `zakinder/KV260_IMX477_CAMERA`

## Purpose

This notice records that selected materials from this repository may be relevant to a pending attorney review for possible intellectual-property protection related to FPGA video color-processing, K-means color clustering, programmable color schemes, palette behavior, and runtime-adaptive color-control concepts.

## Public-Disclosure Caution

Before publishing additional implementation details, source-code internals, control-register details, or complete runtime-update mechanisms, patent counsel should review the project for filing strategy and disclosure timing.

## Attorney Review Focus

The review should consider whether any material in this repository supports or affects possible claims involving:

1. FPGA-based real-time RGB video processing.
2. K-means color clustering and palette/reference-color schemes.
3. Programmable color palettes and generated clustered output images.
4. Runtime profile or LUT selection mechanisms.
5. RGB max/mid/min color analysis and channel remapping logic.
6. Host-controlled configuration paths.
7. Diagnostic or readback-style verification of active configuration.
8. Continuous live video stream operation during color-processing updates.

## Repository Evidence Areas

Relevant public repository areas include:

```text
KV260/ip_lib/vfp_2.0/src/color_space/rgbogp.vhd
KV260/ip_lib/vfp_2.0/src/color_segments/color_k5_clustering.vhd
KV260/ip_lib/vfp_2.0/hdl/vfp_v1_0.vhd
KV260/ip_lib/vfp_2.0/src/Include/ports_package.vhd
KV260/doc/13-k-means-color-clustering.md
KV260/doc/14-programmable-color-schemes-and-palettes.md
docs/index.md
```

## Notes

This notice is not a patent application and is not a legal conclusion. It is a repository-level marker to support attorney review and evidence organization.
