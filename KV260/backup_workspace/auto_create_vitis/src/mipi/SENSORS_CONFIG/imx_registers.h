#define REG_SW_RESET 				    0x0103
#define REG_MODEL_ID_MSB			    0x0016
#define REG_MODEL_ID_LSB			    0x0017
#define REG_MODE_SEL 				    0x0100
#define REG_CSI_LANE				    0x0114
#define REG_DPHY_CTRL				    0x0808
#define REG_EXCK_FREQ_MSB			    0x0136
#define REG_EXCK_FREQ_LSB			    0x0137
#define REG_FRAME_LEN_MSB			    0x0340
#define REG_FRAME_LEN_LSB			    0x0341
#define REG_LINE_LEN_MSB			    0x0342
#define REG_LINE_LEN_LSB			    0x0343
#define REG_X_ADD_STA_MSB			    0x0344
#define REG_X_ADD_STA_LSB			    0x0345
#define REG_X_ADD_END_MSB			    0x0348
#define REG_X_ADD_END_LSB			    0x0349
#define REG_Y_ADD_STA_MSB			    0x0346
#define REG_Y_ADD_STA_LSB			    0x0347
#define REG_Y_ADD_END_MSB			    0x034A
#define REG_Y_ADD_END_LSB			    0x034B
#define REG_X_OUT_SIZE_MSB			    0x034C
#define REG_X_OUT_SIZE_LSB			    0x034D
#define REG_Y_OUT_SIZE_MSB			    0x034E
#define REG_Y_OUT_SIZE_LSB			    0x034F
#define REG_IMG_ORIENT				    0x0101
#define REG_BINNING_MODE			    0x0900
#define REG_BINNING_HV				    0x0901
#define REG_BINNING_WEIGHTING		    0x0902
#define REG_CSI_FORMAT_C			    0x0112
#define REG_CSI_FORMAT_D			    0x0113
#define REG_ANA_GLOBAL_GAIN_U	        0x0204
#define REG_ANA_GLOBAL_GAIN_L	        0x0205
#define REG_DIG_GLOBAL_GAIN	            0x3FF9
#define REG_DIG_GAIN_GR_U	            0x020E
#define REG_DIG_GAIN_GR_L	            0x020F
#define REG_DIG_GAIN_R_U	            0x0210
#define REG_DIG_GAIN_R_L	            0x0211
#define REG_DIG_GAIN_B_U	            0x0212
#define REG_DIG_GAIN_B_L	            0x0213 
#define REG_DIG_GAIN_GB_U	            0x0214 
#define REG_DIG_GAIN_GB_L	            0x0215
#define REG_ANA_GAIN_GLOBAL1_MSB		0x00F0
#define REG_ANA_GAIN_GLOBAL1_LSB		0x00F1
#define REG_ANA_GAIN_GLOBAL2_MSB		0x00F2
#define REG_ANA_GAIN_GLOBAL2_LSB		0x00F3
#define REG_ANA_GAIN_GLOBAL3_MSB		0x00F4
#define REG_ANA_GAIN_GLOBAL3_LSB		0x00F5
#define REG_DIG_GAIN_GLOBAL1_MSB		0x00F6
#define REG_DIG_GAIN_GLOBAL1_LSB		0x00F7
#define REG_DIG_GAIN_GLOBAL2_MSB		0x00F8
#define REG_DIG_GAIN_GLOBAL2_LSB		0x00F9
#define REG_DIG_GAIN_GLOBAL3_MSB		0x00FA
#define REG_DIG_GAIN_GLOBAL3_LSB		0x00FB
#define REG_FINE_INTEGRATION_TIME_MSB	0x0200
#define REG_FINE_INTEGRATION_TIME_LSB 	0x0201
#define REG_COARSE_INTEGRATION_TIME_MSB	0x0202
#define REG_COARSE_INTEGRATION_TIME_LSB 0x0203
#define REG_IVTPXCK_DIV				    0x0301 /* The Pixel Clock Divider for IVTS   */
#define REG_IVTSYCK_DIV				    0x0303 /* The System Clock Divider for IVTS  */
#define REG_IOP_PREPLLCK_DIV		    0x030D /* The pre-PLL Clock Divider for IOPS */
#define	REG_IVT_PREPLLCK_DIV		    0x0305 /* The pre-PLL Clock Divider for IVTS */
#define	REG_PLL_IVT_MPY_MSB			    0x0306 /* The PLL multiplier for IVTS [10:8] */
#define	REG_PLL_IVT_MPY_LSB			    0x0307 /* The PLL multiplier for IVTS [7:0]  */
#define REG_IOPPXCK_DIV				    0x0309 /* The Pixel Clock Divider for IOPS   */
#define REG_IOPSYCK_DIV				    0x030B /* The System Clock Divider for IOPS  */
#define REG_IOP_MPY_MSB				    0x030E /* The pre-PLL Clock Divider for IOPS */
#define REG_IOP_MPY_LSB				    0x030F /* The PLL multiplier for IOPS [7:0]  */
#define REG_PLL_MULTI_DRV			    0x0310 /* PLL mode select: Dual Mode         */
#define REG_TEST_PATTERN_MSB		    0x0600
#define REG_TEST_PATTERN_LSB		    0x0601
#define REG_TP_RED_MSB				    0x0602
#define REG_TP_RED_LSB				    0x0603
#define REG_TP_GREENR_MSB			    0x0604
#define REG_TP_GREENR_LSB			    0x0605
#define REG_TP_BLUE_MSB				    0x0606
#define REG_TP_BLUE_LSB				    0x0607
#define REG_TP_GREENB_MSB			    0x0608
#define REG_TP_GREENB_LSB			    0x0609
#define REG_FRAME_BLANKSTOP_CTRL	    0xE000
#define REG_PD_AREA_WIDTH_MSB		    0x38A8
#define REG_PD_AREA_WIDTH_LSB		    0x38A9
#define REG_PD_AREA_HEIGHT_MSB		    0x38AA
#define REG_PD_AREA_HEIGHT_LSB		    0x38AB
#define REG_FRAME_LENGTH_CTRL		    0x0350
#define REG_EBD_SIZE_V				    0xBCF1
#define REG_DPGA_GLOBEL_GAIN		    0x3FF9
#define REG_X_ENV_INC_CONST			    0x0381
#define REG_X_ODD_INC_CONST			    0x0383
#define REG_Y_ENV_INC_CONST			    0x0385
#define REG_Y_ODD_INC				    0x0387
#define REG_MULTI_CAM_MODE			    0x3F0B
#define REG_ADC_BIT_SETTING			    0x3F0D
#define REG_SCALE_MODE				    0x0401
#define REG_SCALE_M_MSbit			    0x0404
#define REG_SCALE_M_LSB				    0x0405
#define REG_SCALE_N_MSbit			    0x0406
#define REG_SCALE_N_LSB				    0x0407
#define REG_DIG_CROP_X_OFFSET_MSB	    0x0408
#define REG_DIG_CROP_X_OFFSET_LSB	    0x0409
#define REG_DIG_CROP_Y_OFFSET_MSB	    0x040A
#define REG_DIG_CROP_Y_OFFSET_LSB	    0x040B
#define REG_DIG_CROP_WIDTH_MSB		    0x040C
#define REG_DIG_CROP_WIDTH_LSB		    0x040D
#define REG_DIG_CROP_HEIGHT_MSB		    0x040E
#define REG_DIG_CROP_HEIGHT_LSB		    0x040F
#define REG_REQ_LINK_BIT_RATE_MSB	    0x0820 /* Output Data Rate, Mbps [31:24]     */
#define REG_REQ_LINK_BIT_RATE_LMSB	    0x0821 /* Output Data Rate, Mbps [23:16]     */
#define REG_REQ_LINK_BIT_RATE_MLSB	    0x0822 /* Output Data Rate, Mbps [15:8]      */
#define REG_REQ_LINK_BIT_RATE_LSB	    0x0823 /* Output Data Rate, Mbps [7:0]       */
#define REG_TCLK_POST_EX_MSB		    0x080A /* MIPI Global Timing (Tclk) [9:8]    */
#define REG_TCLK_POST_EX_LSB		    0x080B /* MIPI Global Timing (Tclk) [7:0]    */
#define REG_THS_PRE_EX_MSB			    0x080C /* MIPI Global Timing (ths_prepare)   */
#define REG_THS_PRE_EX_LSB			    0x080D /* MIPI Global Timing (ths_prepare)   */
#define REG_THS_ZERO_MIN_MSB		    0x080E /* MIPI Global Timing (ths_zero_min)  */
#define REG_THS_ZERO_MIN_LSB		    0x080F /* MIPI Global Timing (ths_zero_min)  */
#define REG_THS_TRAIL_EX_MSB		    0x0810 /* MIPI Global Timing (ths_trail)     */
#define REG_THS_TRAIL_EX_LSB		    0x0811 /* MIPI Global Timing (ths_trail)     */
#define REG_TCLK_TRAIL_MIN_MSB		    0x0812 /* MIPI Global Timing (Tclk_trail_min)*/
#define REG_TCLK_TRAIL_MIN_LSB		    0x0813 /* MIPI Global Timing (Tclk_trail_min)*/
#define REG_TCLK_PREP_EX_MSB		    0x0814 /* MIPI Global Timing (Tclk_prepare)  */
#define REG_TCLK_PREP_EX_LSB		    0x0815 /* MIPI Global Timing (Tclk_prepare)  */
#define REG_TCLK_ZERO_EX_MSB		    0x0816 /* MIPI Global Timing (Tclk_zero)     */
#define REG_TCLK_ZERO_EX_LSB		    0x0817 /* MIPI Global Timing (Tclk_zero)     */
#define REG_TLPX_EX_MSB				    0x0818 /* MIPI Global Timing (Tlpx)          */
#define REG_TLPX_EX_LSB				    0x0819 /* MIPI Global Timing (Tlpx)          */
#define REG_PDAF_CTRL1_0			    0x3E37
#define REG_POWER_SAVE_ENABLE		    0x3F50
#define REG_LINE_LEN_INCLK_MSB		    0x3F56
#define REG_LINE_LEN_INCLK_LSB		    0x3F57
#define REG_MAP_COUPLET_CORR		    0x0B05
#define REG_SING_DYNAMIC_CORR		    0x0B06
#define REG_CIT_LSHIFT_LONG_EXP		    0x3100
#define REG_TEMP_SENS_CTL 			    0x0138
#define REG_DOL_HDR_EN				    0x00E3
#define REG_DOL_HDR_NUM				    0x00E4
#define REG_DOL_CSI_DT_FMT_H_2ND	    0x00FC
#define REG_DOL_CSI_DT_FMT_L_2ND	    0x00FD
#define REG_DOL_CSI_DT_FMT_H_3ND	    0x00FE
#define REG_DOL_CSI_DT_FMT_L_3ND	    0x00FF
#define REG_DOL_CONST				    0xE013
#define LANES 2