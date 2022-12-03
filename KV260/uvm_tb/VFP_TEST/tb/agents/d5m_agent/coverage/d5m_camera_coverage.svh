// Class: d5m_camera_fc_subscriber
// This class is inherited from "uvm_subscriber".
// This class provides an analysis export for receiving transactions 
// from a connected analysis export.
class d5m_camera_fc_subscriber extends uvm_subscriber#(d5m_trans);
    `uvm_component_utils(d5m_camera_fc_subscriber)
    // handle: d5m_txn
    d5m_trans d5m_txn;
    //Axi4 coverage groups
    covergroup axi4_cg;
        // vfp config registers coverpoint
        vfp_write_registers_cp : coverpoint d5m_txn.axi4.AWADDR { 
        option.at_least               = 1;
        bins reg00_rgb_sharp          = {oRgbOsharp}           iff(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg04_edge_type          = {oEdgeType}            iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg08_write_unused       = {8}                    iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg12_bus_select         = {aBusSelect}           iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg16_threshold          = {threshold}            iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg20_video_channel      = {videoChannel}         iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg24_d_channel          = {dChannel}             iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg28_c_channel          = {cChannel}             iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg32_kls_k1             = {kls_k1}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg36_kls_k2             = {kls_k2}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg40_kls_k3             = {kls_k3}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg44_kls_k4             = {kls_k4}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg48_kls_k5             = {kls_k5}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg52_kls_k6             = {kls_k6}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg56_kls_k7             = {kls_k7}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg60_kls_k8             = {kls_k8}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg64_kls_k9             = {kls_k9}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg68_kls_config         = {kls_config}           iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg72_als_k1             = {als_k1}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg76_als_k2             = {als_k2}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg80_als_k3             = {als_k3}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg84_als_k4             = {als_k4}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg88_als_k5             = {als_k5}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg92_als_k6             = {als_k6}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg96_als_k7             = {als_k7}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg100_als_k8            = {als_k8}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg104_als_k9            = {als_k9}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg108_als_config        = {als_config}           iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg112_point_interest    = {pReg_pointInterest}   iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg116_delta_config      = {pReg_deltaConfig}     iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg120_cpu_ack_again     = {pReg_cpuAckGoAgain}   iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg124_cpu_wgrid_lock    = {pReg_cpuWgridLock}    iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg128_cpu_ack_off_frame = {pReg_cpuAckoffFrame}  iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg132_fifo_read_en_addr = {pReg_fifoReadAddress} iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg136_clear_fifo_data   = {pReg_clearFifoData}   iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg200_rgb_coord_rl      = {rgbCoord_rl}          iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg204_rgb_coord_rh      = {rgbCoord_rh}          iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg208_rgb_coord_gl      = {rgbCoord_gl}          iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg212_rgb_coord_gh      = {rgbCoord_gh}          iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg216_rgb_coord_bl      = {rgbCoord_bl}          iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg220_rgb_coord_bh      = {rgbCoord_bh}          iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg224_lum_th            = {oLumTh}               iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg228_hsv_per_ch        = {oHsvPerCh}            iff(d5m_txn.axi4.WVALID == 1'b1);
        bins reg232_ycc_per_ch        = {oYccPerCh}            iff(d5m_txn.axi4.WVALID == 1'b1);
        }
        // vfp config registers value coverpoint
        vfp_registers_write_data_cp : coverpoint d5m_txn.axi4.WDATA[15:0] {
        option.at_least               = 1;
        bins reg00_rgb_sharp          = {reg_00_rgb_sharp}          iff(d5m_txn.axi4.AWADDR == oRgbOsharp)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg04_edge_type          = {reg_01_edge_type}          iff(d5m_txn.axi4.AWADDR == oEdgeType)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg12_bus_select         = {reg_03_bus_select}         iff(d5m_txn.axi4.AWADDR == aBusSelect)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg16_threshold          = {reg_04_config_threshold}   iff(d5m_txn.axi4.AWADDR == threshold)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg20_video_channel      = {reg_05_video_channel}      iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg24_d_channel          = {reg_06_en_ycbcr_or_rgb}    iff(d5m_txn.axi4.AWADDR == dChannel)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg28_c_channel          = {reg_07_c_channel}          iff(d5m_txn.axi4.AWADDR == cChannel)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg32_kls_k1             = {reg_08_kls_k1}             iff(d5m_txn.axi4.AWADDR == kls_k1)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg36_kls_k2             = {reg_09_kls_k2}             iff(d5m_txn.axi4.AWADDR == kls_k2)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg40_kls_k3             = {reg_10_kls_k3}             iff(d5m_txn.axi4.AWADDR == kls_k3)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg44_kls_k4             = {reg_11_kls_k4}             iff(d5m_txn.axi4.AWADDR == kls_k4)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg48_kls_k5             = {reg_12_kls_k5}             iff(d5m_txn.axi4.AWADDR == kls_k5)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg52_kls_k6             = {reg_13_kls_k6}             iff(d5m_txn.axi4.AWADDR == kls_k6)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg56_kls_k7             = {reg_14_kls_k7}             iff(d5m_txn.axi4.AWADDR == kls_k7)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg60_kls_k8             = {reg_15_kls_k8}             iff(d5m_txn.axi4.AWADDR == kls_k8)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg64_kls_k9             = {reg_16_kls_k9}             iff(d5m_txn.axi4.AWADDR == kls_k9)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg68_kls_config         = {reg_17_k_coef}             iff(d5m_txn.axi4.AWADDR == kls_config)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg72_als_k1             = {reg_21_als_k1}             iff(d5m_txn.axi4.AWADDR == als_k1)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg76_als_k2             = {reg_22_als_k2}             iff(d5m_txn.axi4.AWADDR == als_k2)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg80_als_k3             = {reg_23_als_k3}             iff(d5m_txn.axi4.AWADDR == als_k3)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg84_als_k4             = {reg_24_als_k4}             iff(d5m_txn.axi4.AWADDR == als_k4)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg88_als_k5             = {reg_25_als_k5}             iff(d5m_txn.axi4.AWADDR == als_k5)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg92_als_k6             = {reg_26_als_k6}             iff(d5m_txn.axi4.AWADDR == als_k6)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg96_als_k7             = {reg_27_als_k7}             iff(d5m_txn.axi4.AWADDR == als_k7)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg100_als_k8            = {reg_28_als_k8}             iff(d5m_txn.axi4.AWADDR == als_k8)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg104_als_k9            = {reg_29_als_k9}             iff(d5m_txn.axi4.AWADDR == als_k9)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg108_als_config        = {reg_30_als_coef}           iff(d5m_txn.axi4.AWADDR == als_config)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg112_point_interest    = {reg_31_point_interest}     iff(d5m_txn.axi4.AWADDR == pReg_pointInterest)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg116_delta_config      = {reg_32_delta_config}       iff(d5m_txn.axi4.AWADDR == pReg_deltaConfig)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg120_cpu_ack_again     = {reg_33_cpu_ack_go_again}   iff(d5m_txn.axi4.AWADDR == pReg_cpuAckGoAgain)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg124_cpu_wgrid_lock    = {reg_34_cpu_wgrid_lock}     iff(d5m_txn.axi4.AWADDR == pReg_cpuWgridLock)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg128_cpu_ack_off_frame = {reg_35_cpu_ack_off_frame}  iff(d5m_txn.axi4.AWADDR == pReg_cpuAckoffFrame)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg132_fifo_read_en_addr = {reg_36_fifo_read_address}  iff(d5m_txn.axi4.AWADDR == pReg_fifoReadAddress)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg136_clear_fifo_data   = {reg_37_clear_fifo_data}    iff(d5m_txn.axi4.AWADDR == pReg_clearFifoData)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg200_rgb_coord_rl      = {reg_50_rgb_cord_rl}        iff(d5m_txn.axi4.AWADDR == rgbCoord_rl)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg204_rgb_coord_rh      = {reg_51_rgb_cord_rh}        iff(d5m_txn.axi4.AWADDR == rgbCoord_rh)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg208_rgb_coord_gl      = {reg_52_rgb_cord_gl}        iff(d5m_txn.axi4.AWADDR == rgbCoord_gl)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg212_rgb_coord_gh      = {reg_53_rgb_cord_gh}        iff(d5m_txn.axi4.AWADDR == rgbCoord_gh)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg216_rgb_coord_bl      = {reg_54_rgb_cord_bl}        iff(d5m_txn.axi4.AWADDR == rgbCoord_bl)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg220_rgb_coord_bh      = {reg_55_rgb_cord_bh}        iff(d5m_txn.axi4.AWADDR == rgbCoord_bh)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg224_lum_th            = {reg_56_lum_th}             iff(d5m_txn.axi4.AWADDR == oLumTh)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg228_hsv_per_ch        = {reg_57_hsv_per_ch}         iff(d5m_txn.axi4.AWADDR == oHsvPerCh)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        bins reg232_ycc_per_ch        = {reg_58_ycc_per_ch}         iff(d5m_txn.axi4.AWADDR == oYccPerCh)&&(d5m_txn.axi4.WVALID == 1'b1)&&(d5m_txn.axi4.AWVALID == 1'b1);
        }
        // vfp config video channel registers coverpoint
        video_channels_cp : coverpoint d5m_txn.axi4.WDATA[15:0] {
        option.at_least    = 1;
        bins v_ch_cga      = {select_cgain}            iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_sha      = {select_sharp}            iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_blu      = {select_blur}             iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_hsl      = {select_hsl}              iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_hsv      = {select_hsv}              iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_rgb      = {select_rgb}              iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_sob      = {select_sobel}            iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_emb      = {select_emboss}           iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_ycb      = {select_y_cb_cr}          iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_cga_cga  = {select_cgainToCgain}     iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_cga_sha  = {select_cgainToSharp}     iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_cga_hsl  = {select_cgainToHsl}       iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_cga_hsv  = {select_sharp}            iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_sob_cga  = {select_sobel_mask_cga}   iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_sob_sha  = {select_sobel_mask_shp}   iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_sob_blu  = {select_sobel_mask_blu}   iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_sob_hsl  = {select_sobel_mask_hsl}   iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_sob_hsv  = {select_sobel_mask_hsv}   iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_sob_rgb  = {select_sobel_mask_rgb}   iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_cga_ycb  = {select_cgainToYcbcr}     iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_rgb_cor  = {select_rgbCorrect}       iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_rgb_rem  = {select_rgbRemix}         iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_rgb_det  = {select_rgbDetect}        iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        bins v_ch_rgb_poi  = {select_rgbPoi}           iff(d5m_txn.axi4.AWADDR == videoChannel)&&(d5m_txn.axi4.WVALID == 1'b1);
        }
        // vfp config registers value coverpoint
        vfp_registers_read_data_cp : coverpoint d5m_txn.axi4.RDATA { 
        option.at_least               = 1;
        bins reg00_rgb_sharp          = {reg_00_rgb_sharp}          iff(d5m_txn.axi4.ARADDR == oRgbOsharp)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg04_edge_type          = {reg_01_edge_type}          iff(d5m_txn.axi4.ARADDR == oEdgeType)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg12_bus_select         = {reg_03_bus_select}         iff(d5m_txn.axi4.ARADDR == aBusSelect)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg16_threshold          = {reg_04_config_threshold}   iff(d5m_txn.axi4.ARADDR == threshold)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg20_video_channel      = {reg_05_video_channel}      iff(d5m_txn.axi4.ARADDR == videoChannel)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg24_d_channel          = {reg_06_en_ycbcr_or_rgb}    iff(d5m_txn.axi4.ARADDR == dChannel)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg28_c_channel          = {reg_07_c_channel}          iff(d5m_txn.axi4.ARADDR == cChannel)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg32_kls_k1             = {reg_08_kls_k1}             iff(d5m_txn.axi4.ARADDR == kls_k1)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg36_kls_k2             = {reg_09_kls_k2}             iff(d5m_txn.axi4.ARADDR == kls_k2)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg40_kls_k3             = {reg_10_kls_k3}             iff(d5m_txn.axi4.ARADDR == kls_k3)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg44_kls_k4             = {reg_11_kls_k4}             iff(d5m_txn.axi4.ARADDR == kls_k4)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg48_kls_k5             = {reg_12_kls_k5}             iff(d5m_txn.axi4.ARADDR == kls_k5)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg52_kls_k6             = {reg_13_kls_k6}             iff(d5m_txn.axi4.ARADDR == kls_k6)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg56_kls_k7             = {reg_14_kls_k7}             iff(d5m_txn.axi4.ARADDR == kls_k7)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg60_kls_k8             = {reg_15_kls_k8}             iff(d5m_txn.axi4.ARADDR == kls_k8)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg64_kls_k9             = {reg_16_kls_k9}             iff(d5m_txn.axi4.ARADDR == kls_k9)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg68_kls_config         = {reg_17_k_coef}             iff(d5m_txn.axi4.ARADDR == kls_config)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg72_als_k1             = {reg_21_als_k1}             iff(d5m_txn.axi4.ARADDR == als_k1)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg76_als_k2             = {reg_22_als_k2}             iff(d5m_txn.axi4.ARADDR == als_k2)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg80_als_k3             = {reg_23_als_k3}             iff(d5m_txn.axi4.ARADDR == als_k3)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg84_als_k4             = {reg_24_als_k4}             iff(d5m_txn.axi4.ARADDR == als_k4)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg88_als_k5             = {reg_25_als_k5}             iff(d5m_txn.axi4.ARADDR == als_k5)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg92_als_k6             = {reg_26_als_k6}             iff(d5m_txn.axi4.ARADDR == als_k6)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg96_als_k7             = {reg_27_als_k7}             iff(d5m_txn.axi4.ARADDR == als_k7)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg100_als_k8            = {reg_28_als_k8}             iff(d5m_txn.axi4.ARADDR == als_k8)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg104_als_k9            = {reg_29_als_k9}             iff(d5m_txn.axi4.ARADDR == als_k9)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg108_als_config        = {reg_30_als_coef}           iff(d5m_txn.axi4.ARADDR == als_config)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg112_point_interest    = {reg_31_point_interest}     iff(d5m_txn.axi4.ARADDR == pReg_pointInterest)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg116_delta_config      = {reg_32_delta_config}       iff(d5m_txn.axi4.ARADDR == pReg_deltaConfig)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg120_cpu_ack_again     = {reg_33_cpu_ack_go_again}   iff(d5m_txn.axi4.ARADDR == pReg_cpuAckGoAgain)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg124_cpu_wgrid_lock    = {reg_34_cpu_wgrid_lock}     iff(d5m_txn.axi4.ARADDR == pReg_cpuWgridLock)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg128_cpu_ack_off_frame = {reg_35_cpu_ack_off_frame}  iff(d5m_txn.axi4.ARADDR == pReg_cpuAckoffFrame)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg132_fifo_read_en_addr = {reg_36_fifo_read_address}  iff(d5m_txn.axi4.ARADDR == pReg_fifoReadAddress)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg136_clear_fifo_data   = {reg_37_clear_fifo_data}    iff(d5m_txn.axi4.ARADDR == pReg_clearFifoData)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg200_rgb_coord_rl      = {reg_50_rgb_cord_rl}        iff(d5m_txn.axi4.ARADDR == rgbCoord_rl)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg204_rgb_coord_rh      = {reg_51_rgb_cord_rh}        iff(d5m_txn.axi4.ARADDR == rgbCoord_rh)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg208_rgb_coord_gl      = {reg_52_rgb_cord_gl}        iff(d5m_txn.axi4.ARADDR == rgbCoord_gl)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg212_rgb_coord_gh      = {reg_53_rgb_cord_gh}        iff(d5m_txn.axi4.ARADDR == rgbCoord_gh)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg216_rgb_coord_bl      = {reg_54_rgb_cord_bl}        iff(d5m_txn.axi4.ARADDR == rgbCoord_bl)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg220_rgb_coord_bh      = {reg_55_rgb_cord_bh}        iff(d5m_txn.axi4.ARADDR == rgbCoord_bh)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg224_lum_th            = {reg_56_lum_th}             iff(d5m_txn.axi4.ARADDR == oLumTh)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg228_hsv_per_ch        = {reg_57_hsv_per_ch}         iff(d5m_txn.axi4.ARADDR == oHsvPerCh)&&(d5m_txn.axi4.RVALID == 1'b1);
        bins reg232_ycc_per_ch        = {reg_58_ycc_per_ch}         iff(d5m_txn.axi4.ARADDR == oYccPerCh)&&(d5m_txn.axi4.RVALID == 1'b1);
        }
    endgroup: axi4_cg
    //Rgb pixel coverage groups
    covergroup rgb_cg;
        // rgb red pixel in given range coverpoint
        red_cp : coverpoint d5m_txn.d5m.rgb[7:0] {
        bins red_000_000_black      = {0}       iff(d5m_txn.d5m.lvalid == high);
        bins red_001_025_darker     = {1,25}    iff(d5m_txn.d5m.lvalid == high);
        bins red_026_050_dark       = {26,50}   iff(d5m_txn.d5m.lvalid == high);
        bins red_051_100_med_dark   = {51,100}  iff(d5m_txn.d5m.lvalid == high);
        bins red_101_150_medium     = {101,150} iff(d5m_txn.d5m.lvalid == high);
        bins red_151_200_med_light  = {151,200} iff(d5m_txn.d5m.lvalid == high);
        bins red_201_255_light      = {201,254} iff(d5m_txn.d5m.lvalid == high);
        bins red_255_255_white      = {255}     iff(d5m_txn.d5m.lvalid == high);
        }
        // rgb green pixel in given range coverpoint
        green_cp : coverpoint d5m_txn.d5m.rgb[15:8] {
        bins grn_000_000_black      = {0}       iff(d5m_txn.d5m.lvalid == high);
        bins grn_001_025_darker     = {1,25}    iff(d5m_txn.d5m.lvalid == high);
        bins grn_026_050_dark       = {26,50}   iff(d5m_txn.d5m.lvalid == high);
        bins grn_051_100_med_dark   = {51,100}  iff(d5m_txn.d5m.lvalid == high);
        bins grn_101_150_medium     = {101,150} iff(d5m_txn.d5m.lvalid == high);
        bins grn_151_200_med_light  = {151,200} iff(d5m_txn.d5m.lvalid == high);
        bins grn_201_255_light      = {201,254} iff(d5m_txn.d5m.lvalid == high);
        bins grn_255_255_white      = {255}     iff(d5m_txn.d5m.lvalid == high);
        }
        // rgb blue pixel in given range coverpoint
        blue_cp : coverpoint d5m_txn.d5m.rgb[23:16] {
        bins blu_000_000_black      = {0}       iff(d5m_txn.d5m.lvalid == high);
        bins blu_001_025_darker     = {1,25}    iff(d5m_txn.d5m.lvalid == high);
        bins blu_026_050_dark       = {26,50}   iff(d5m_txn.d5m.lvalid == high);
        bins blu_051_100_med_dark   = {51,100}  iff(d5m_txn.d5m.lvalid == high);
        bins blu_101_150_medium     = {101,150} iff(d5m_txn.d5m.lvalid == high);
        bins blu_151_200_med_light  = {151,200} iff(d5m_txn.d5m.lvalid == high);
        bins blu_201_255_light      = {201,254} iff(d5m_txn.d5m.lvalid == high);
        bins blu_255_255_white      = {255}     iff(d5m_txn.d5m.lvalid == high);
        }
        // rgb frame x coordinates coverpoint
        xCord_cp : coverpoint d5m_txn.d5m.x{
        bins left1_000_025          = {0,25};
        bins left2_026_050          = {26,50};
        bins middle_051_075         = {51,75};
        bins right1_076_100         = {76,100};
        bins right2_101_150         = {101,150};
        bins right3_151_200         = {151,200};
        }
        // rgb frame y coordinates coverpoint
        yCord_cp : coverpoint d5m_txn.d5m.y {
        bins top1_000_025           = {0,25};
        bins top2_026_050           = {26,50};
        bins middle_051_075         = {51,75};
        bins bottom1_076_100        = {76,100};
        bins bottom2_101_150        = {101,150};
        bins bottom3_151_200        = {151,200};
        }
        // rgb frame x coordinates when red pixel above given range coverpoint
        xCord_iff_cp : coverpoint d5m_txn.d5m.x[7:0] iff (d5m_txn.d5m.red > 100){
        option.at_least     = 1;
        option.auto_bin_max = 4;
        }
        // rgb frame y coordinates when red pixel above given range coverpoint
        yCord_iff_cp : coverpoint d5m_txn.d5m.y[7:0] iff (d5m_txn.d5m.red > 100){
        option.at_least     = 1;
        option.auto_bin_max = 4;
        }
        // rgb per pixel auto range coverpoints
        red_auto_pixel_cp   : coverpoint d5m_txn.d5m.red   {option.at_least = 1;option.auto_bin_max = 5;}
        gre_auto_pixel_cp   : coverpoint d5m_txn.d5m.green {option.at_least = 1;option.auto_bin_max = 5;}
        blu_auto_pixel_cp   : coverpoint d5m_txn.d5m.blue  {option.at_least = 1;option.auto_bin_max = 5;}
        // rgb per pixel color crosses for comparison
        cross_rgb           : cross red_cp,green_cp,blue_cp;
        cross_rgb_auto      : cross red_auto_pixel_cp,gre_auto_pixel_cp,blu_auto_pixel_cp;
        cross_max_rgb       : cross red_auto_pixel_cp,gre_auto_pixel_cp,blu_auto_pixel_cp,xCord_iff_cp,yCord_iff_cp;
        cross_iff_rgb       : cross red_cp,green_cp,blue_cp,xCord_iff_cp,yCord_iff_cp;
    endgroup: rgb_cg
    //Rgb pixel processed coverage groups
    covergroup rgb_slave_cg;
        // rgb red processed pixel in given range coverpoint
        red_cp : coverpoint d5m_txn.d5m.red {
        bins red_000_000_black      = {0}       iff(d5m_txn.d5m.valid == high);
        bins red_001_025_darker     = {1,25}    iff(d5m_txn.d5m.valid == high);
        bins red_026_050_dark       = {26,50}   iff(d5m_txn.d5m.valid == high);
        bins red_051_100_med_dark   = {51,100}  iff(d5m_txn.d5m.valid == high);
        bins red_101_150_medium     = {101,150} iff(d5m_txn.d5m.valid == high);
        bins red_151_200_med_light  = {151,200} iff(d5m_txn.d5m.valid == high);
        bins red_201_255_light      = {201,254} iff(d5m_txn.d5m.valid == high);
        bins red_255_255_white      = {255}     iff(d5m_txn.d5m.valid == high);
        }
        // rgb green processed pixel in given range coverpoint
        green_cp : coverpoint d5m_txn.d5m.green {
        bins grn_000_000_black      = {0}       iff(d5m_txn.d5m.valid == high);
        bins grn_001_025_darker     = {1,25}    iff(d5m_txn.d5m.valid == high);
        bins grn_026_050_dark       = {26,50}   iff(d5m_txn.d5m.valid == high);
        bins grn_051_100_med_dark   = {51,100}  iff(d5m_txn.d5m.valid == high);
        bins grn_101_150_medium     = {101,150} iff(d5m_txn.d5m.valid == high);
        bins grn_151_200_med_light  = {151,200} iff(d5m_txn.d5m.valid == high);
        bins grn_201_255_light      = {201,254} iff(d5m_txn.d5m.valid == high);
        bins grn_255_255_white      = {255}     iff(d5m_txn.d5m.valid == high);
        }
        // rgb blue processed pixel in given range coverpoint
        blue_cp : coverpoint d5m_txn.d5m.blue {
        bins blu_000_000_black      = {0}       iff(d5m_txn.d5m.valid == high);
        bins blu_001_025_darker     = {1,25}    iff(d5m_txn.d5m.valid == high);
        bins blu_026_050_dark       = {26,50}   iff(d5m_txn.d5m.valid == high);
        bins blu_051_100_med_dark   = {51,100}  iff(d5m_txn.d5m.valid == high);
        bins blu_101_150_medium     = {101,150} iff(d5m_txn.d5m.valid == high);
        bins blu_151_200_med_light  = {151,200} iff(d5m_txn.d5m.valid == high);
        bins blu_201_255_light      = {201,254} iff(d5m_txn.d5m.valid == high);
        bins blu_255_255_white      = {255}     iff(d5m_txn.d5m.valid == high);
        }
        // Check for black and white color cross
        rgb_black_white_cr : cross red_cp, green_cp, blue_cp{
        bins black = binsof(red_cp.red_000_000_black) && binsof(green_cp.grn_000_000_black) && binsof(blue_cp.blu_000_000_black);
        bins white = binsof(red_cp.red_255_255_white) && binsof(green_cp.grn_255_255_white) && binsof(blue_cp.blu_255_255_white);}
    endgroup: rgb_slave_cg
    // Function: new
    // Construct covergroups
    function new(string name, uvm_component parent);
        super.new(name, parent);
        rgb_cg       = new;
        rgb_slave_cg = new;
        axi4_cg      = new;
    endfunction: new
    // Function: write
    // Sample covergroups
    function void write(d5m_trans t);
        d5m_txn = t;
        rgb_cg.sample();
        rgb_slave_cg.sample();
        axi4_cg.sample();
    endfunction: write
endclass: d5m_camera_fc_subscriber