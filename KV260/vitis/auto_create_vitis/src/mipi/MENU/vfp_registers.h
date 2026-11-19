#ifndef VFP_REGISTERS_H
#define VFP_REGISTERS_H

/* VFP AXI4-Lite byte offsets relative to VFPCONFIG_BASEADDR.
 * VFP_UNUSED_* offsets have no active consumer in vfp_v1_0.vhd.
 * They are retained for the existing raw-offset UART commands.
 */
#define VFP_UNUSED_00                            0x00
#define VFP_DARK_CCM_K1                          0x04
#define VFP_DARK_CCM_K2                          0x08
#define VFP_DARK_CCM_K3                          0x0C
#define VFP_DARK_CCM_K4                          0x10
#define VFP_DARK_CCM_K5                          0x14
#define VFP_DARK_CCM_K6                          0x18
#define VFP_DARK_CCM_K7                          0x1C
#define VFP_DARK_CCM_K8                          0x20
#define VFP_DARK_CCM_K9                          0x24
#define VFP_UNUSED_10                            0x28
#define VFP_DARK_CCM_PRESET_SELECT               0x2C
#define VFP_LIGHT_CCM_PRESET_SELECT              0x30
#define VFP_BALANCE_CCM_PRESET_SELECT            0x34
#define VFP_RGB_CHANNEL_SELECT                   0x38
#define VFP_CENTROID_LUT_WRITE_INDEX             0x3C
#define VFP_PREVIEW_REFINED_PORTRAIT             30U
#define VFP_OUTPUT_CHANNEL_SELECT                0x40
#define VFP_SOBEL_CLUSTER_INPUT_SELECT           0x44
#define VFP_UNUSED_18                            0x48
#define VFP_FRAME_DIMENSIONS                     0x4C  /* Height [31:16], width [15:0]. */
#define VFP_CENTROID_LUT_READ_INDEX              0x50
#define VFP_IMAGE_ADJUST_SELECTOR_VALUE          0x54  /* Adjustment selector [31:16], value [15:0]. */
#define VFP_UNUSED_22                            0x58
#define VFP_UNUSED_23                            0x5C
#define VFP_UNUSED_24                            0x60
#define VFP_UNUSED_25                            0x64
#define VFP_UNUSED_26                            0x68
#define VFP_UNUSED_27                            0x6C
#define VFP_UNUSED_28                            0x70
#define VFP_UNUSED_29                            0x74
#define VFP_UNUSED_30                            0x78
#define VFP_UNUSED_31                            0x7C
#define VFP_UNUSED_32                            0x80
#define VFP_UNUSED_33                            0x84
#define VFP_UNUSED_34                            0x88
#define VFP_UNUSED_35                            0x8C
#define VFP_UNUSED_36                            0x90
#define VFP_UNUSED_37                            0x94
#define VFP_UNUSED_38                            0x98
#define VFP_UNUSED_39                            0x9C
#define VFP_UNUSED_40                            0xA0
#define VFP_UNUSED_41                            0xA4
#define VFP_UNUSED_42                            0xA8
#define VFP_CENTROID_LUT_SELECT                  0xAC
#define VFP_TEST_PATTERN_SELECT_SOBEL_THRESHOLD  0xB0  /* Shared by the test-pattern generator and Sobel filter. */
#define VFP_CENTROID_LUT_DATA                    0xB4  /* Write: max/mid/min bytes [23:0]. Read: LUT entry selected by READ_INDEX. */
#define VFP_LIGHT_CCM_K1                         0xB8
#define VFP_LIGHT_CCM_K2                         0xBC
#define VFP_LIGHT_CCM_K3                         0xC0
#define VFP_LIGHT_CCM_K4                         0xC4
#define VFP_LIGHT_CCM_K5                         0xC8
#define VFP_LIGHT_CCM_K6                         0xCC
#define VFP_LIGHT_CCM_K7                         0xD0
#define VFP_LIGHT_CCM_K8                         0xD4
#define VFP_LIGHT_CCM_K9                         0xD8
#define VFP_BALANCE_CCM_K1                       0xDC
#define VFP_BALANCE_CCM_K2                       0xE0
#define VFP_BALANCE_CCM_K3                       0xE4
#define VFP_BALANCE_CCM_K4                       0xE8
#define VFP_BALANCE_CCM_K5                       0xEC
#define VFP_BALANCE_CCM_K6                       0xF0
#define VFP_BALANCE_CCM_K7                       0xF4
#define VFP_BALANCE_CCM_K8                       0xF8
#define VFP_BALANCE_CCM_K9                       0xFC

#endif
