; ModuleID = 'R:/KV260/vivado/KV260.runs/kv260_video_v_demosaic_0_0_synth_1/prj/sol/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>" = type { %"struct.hls::axis<ap_uint<10>, 1, 1, 1>" }
%"struct.hls::axis<ap_uint<10>, 1, 1, 1>" = type { %"struct.ap_uint<10>", %"struct.ap_uint<2>", %"struct.ap_uint<2>", %"struct.ap_uint<1>", %"struct.ap_uint<1>", %"struct.ap_uint<1>", %"struct.ap_uint<1>" }
%"struct.ap_uint<10>" = type { %"struct.ap_int_base<10, false>" }
%"struct.ap_int_base<10, false>" = type { %"struct.ssdm_int<10, false>" }
%"struct.ssdm_int<10, false>" = type { i10 }
%"struct.ap_uint<2>" = type { %"struct.ap_int_base<2, false>" }
%"struct.ap_int_base<2, false>" = type { %"struct.ssdm_int<2, false>" }
%"struct.ssdm_int<2, false>" = type { i2 }
%"struct.ap_uint<1>" = type { %"struct.ap_int_base<1, false>" }
%"struct.ap_int_base<1, false>" = type { %"struct.ssdm_int<1, false>" }
%"struct.ssdm_int<1, false>" = type { i1 }
%"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>" = type { %"struct.hls::axis<ap_uint<30>, 1, 1, 1>" }
%"struct.hls::axis<ap_uint<30>, 1, 1, 1>" = type { %"struct.ap_uint<30>", %"struct.ap_uint<4>", %"struct.ap_uint<4>", %"struct.ap_uint<1>", %"struct.ap_uint<1>", %"struct.ap_uint<1>", %"struct.ap_uint<1>" }
%"struct.ap_uint<30>" = type { %"struct.ap_int_base<30, false>" }
%"struct.ap_int_base<30, false>" = type { %"struct.ssdm_int<30, false>" }
%"struct.ssdm_int<30, false>" = type { i30 }
%"struct.ap_uint<4>" = type { %"struct.ap_int_base<4, false>" }
%"struct.ap_int_base<4, false>" = type { %"struct.ssdm_int<4, false>" }
%"struct.ssdm_int<4, false>" = type { i4 }

; Function Attrs: noinline
define void @apatb_v_demosaic_ir(i16 zeroext %width, i16 zeroext %height, i16 zeroext %bayer_phase, %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* noalias nonnull dereferenceable(8) %s_axis_video, %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* noalias nonnull dereferenceable(12) %m_axis_video) local_unnamed_addr #0 {
entry:
  %s_axis_video_copy.data = alloca i10
  %s_axis_video_copy.keep = alloca i2
  %s_axis_video_copy.strb = alloca i2
  %s_axis_video_copy.user = alloca i1
  %s_axis_video_copy.last = alloca i1
  %s_axis_video_copy.id = alloca i1
  %s_axis_video_copy.dest = alloca i1
  %m_axis_video_copy.data = alloca i30
  %m_axis_video_copy.keep = alloca i4
  %m_axis_video_copy.strb = alloca i4
  %m_axis_video_copy.user = alloca i1
  %m_axis_video_copy.last = alloca i1
  %m_axis_video_copy.id = alloca i1
  %m_axis_video_copy.dest = alloca i1
  call fastcc void @copy_in(%"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* nonnull %s_axis_video, i10* %s_axis_video_copy.data, i2* %s_axis_video_copy.keep, i2* %s_axis_video_copy.strb, i1* %s_axis_video_copy.user, i1* %s_axis_video_copy.last, i1* %s_axis_video_copy.id, i1* %s_axis_video_copy.dest, %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* nonnull %m_axis_video, i30* %m_axis_video_copy.data, i4* %m_axis_video_copy.keep, i4* %m_axis_video_copy.strb, i1* %m_axis_video_copy.user, i1* %m_axis_video_copy.last, i1* %m_axis_video_copy.id, i1* %m_axis_video_copy.dest)
  call void @apatb_v_demosaic_hw(i16 %width, i16 %height, i16 %bayer_phase, i10* %s_axis_video_copy.data, i2* %s_axis_video_copy.keep, i2* %s_axis_video_copy.strb, i1* %s_axis_video_copy.user, i1* %s_axis_video_copy.last, i1* %s_axis_video_copy.id, i1* %s_axis_video_copy.dest, i30* %m_axis_video_copy.data, i4* %m_axis_video_copy.keep, i4* %m_axis_video_copy.strb, i1* %m_axis_video_copy.user, i1* %m_axis_video_copy.last, i1* %m_axis_video_copy.id, i1* %m_axis_video_copy.dest)
  call void @copy_back(%"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %s_axis_video, i10* %s_axis_video_copy.data, i2* %s_axis_video_copy.keep, i2* %s_axis_video_copy.strb, i1* %s_axis_video_copy.user, i1* %s_axis_video_copy.last, i1* %s_axis_video_copy.id, i1* %s_axis_video_copy.dest, %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %m_axis_video, i30* %m_axis_video_copy.data, i4* %m_axis_video_copy.keep, i4* %m_axis_video_copy.strb, i1* %m_axis_video_copy.user, i1* %m_axis_video_copy.last, i1* %m_axis_video_copy.id, i1* %m_axis_video_copy.dest)
  ret void
}

; Function Attrs: argmemonly noinline
define internal fastcc void @copy_in(%"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* noalias, i10* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.0" %_V_data_V, i2* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.1" %_V_keep_V, i2* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.2" %_V_strb_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.3" %_V_user_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.4" %_V_last_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.5" %_V_id_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.6" %_V_dest_V, %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* noalias, i30* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.0" %_V_data_V1, i4* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.1" %_V_keep_V2, i4* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.2" %_V_strb_V3, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.3" %_V_user_V4, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.4" %_V_last_V5, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.5" %_V_id_V6, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.6" %_V_dest_V7) unnamed_addr #1 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>.28"(i10* %_V_data_V, i2* %_V_keep_V, i2* %_V_strb_V, i1* %_V_user_V, i1* %_V_last_V, i1* %_V_id_V, i1* %_V_dest_V, %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %0)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"(i30* %_V_data_V1, i4* %_V_keep_V2, i4* %_V_strb_V3, i1* %_V_user_V4, i1* %_V_last_V5, i1* %_V_id_V6, i1* %_V_dest_V7, %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1)
  ret void
}

; Function Attrs: argmemonly noinline
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"(%"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* noalias align 512 "fpga.caller.interfaces"="layout_transformed", i10* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.0" %_V_data_V, i2* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.1" %_V_keep_V, i2* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.2" %_V_strb_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.3" %_V_user_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.4" %_V_last_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.5" %_V_id_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.6" %_V_dest_V) unnamed_addr #2 {
entry:
  %1 = icmp eq %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %0, null
  %2 = or i1 %1, false
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"(%"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* nonnull align 512 %0, i10* %_V_data_V, i2* %_V_keep_V, i2* %_V_strb_V, i1* %_V_user_V, i1* %_V_last_V, i1* %_V_id_V, i1* %_V_dest_V)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"(%"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* noalias nocapture align 512 "fpga.caller.interfaces"="layout_transformed", i10* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.0" %_V_data_V, i2* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.1" %_V_keep_V, i2* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.2" %_V_strb_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.3" %_V_user_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.4" %_V_last_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.5" %_V_id_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.6" %_V_dest_V) unnamed_addr #3 {
entry:
  %1 = alloca %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"
  %2 = alloca i10
  %3 = alloca i1
  %4 = alloca i1
  %5 = alloca i1
  %6 = alloca i1
  %7 = alloca i2
  %8 = alloca i2
  br label %empty

empty:                                            ; preds = %push, %entry
  %9 = bitcast i10* %_V_data_V to i8*
  %10 = call i1 @fpga_fifo_not_empty_2(i8* %9)
  br i1 %10, label %push, label %ret

push:                                             ; preds = %empty
  %11 = bitcast i10* %2 to i8*
  %12 = bitcast i10* %_V_data_V to i8*
  call void @fpga_fifo_pop_2(i8* %11, i8* %12)
  %13 = bitcast i10* %2 to i16*
  %14 = load i16, i16* %13
  %15 = trunc i16 %14 to i10
  %16 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 0
  %17 = bitcast %"struct.ap_uint<10>"* %16 to i10*
  store i10 %15, i10* %17
  %18 = bitcast i2* %8 to i8*
  %19 = bitcast i2* %_V_keep_V to i8*
  call void @fpga_fifo_pop_1(i8* %18, i8* %19)
  %20 = bitcast i2* %8 to i8*
  %21 = load i8, i8* %20
  %22 = trunc i8 %21 to i2
  %23 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 1
  %24 = bitcast %"struct.ap_uint<2>"* %23 to i2*
  store i2 %22, i2* %24
  %25 = bitcast i2* %7 to i8*
  %26 = bitcast i2* %_V_strb_V to i8*
  call void @fpga_fifo_pop_1(i8* %25, i8* %26)
  %27 = bitcast i2* %7 to i8*
  %28 = load i8, i8* %27
  %29 = trunc i8 %28 to i2
  %30 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 2
  %31 = bitcast %"struct.ap_uint<2>"* %30 to i2*
  store i2 %29, i2* %31
  %32 = bitcast i1* %6 to i8*
  %33 = bitcast i1* %_V_user_V to i8*
  call void @fpga_fifo_pop_1(i8* %32, i8* %33)
  %34 = bitcast i1* %6 to i8*
  %35 = load i8, i8* %34
  %36 = trunc i8 %35 to i1
  %37 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 3
  %38 = bitcast %"struct.ap_uint<1>"* %37 to i1*
  store i1 %36, i1* %38
  %39 = bitcast i1* %5 to i8*
  %40 = bitcast i1* %_V_last_V to i8*
  call void @fpga_fifo_pop_1(i8* %39, i8* %40)
  %41 = bitcast i1* %5 to i8*
  %42 = load i8, i8* %41
  %43 = trunc i8 %42 to i1
  %44 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 4
  %45 = bitcast %"struct.ap_uint<1>"* %44 to i1*
  store i1 %43, i1* %45
  %46 = bitcast i1* %4 to i8*
  %47 = bitcast i1* %_V_id_V to i8*
  call void @fpga_fifo_pop_1(i8* %46, i8* %47)
  %48 = bitcast i1* %4 to i8*
  %49 = load i8, i8* %48
  %50 = trunc i8 %49 to i1
  %51 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 5
  %52 = bitcast %"struct.ap_uint<1>"* %51 to i1*
  store i1 %50, i1* %52
  %53 = bitcast i1* %3 to i8*
  %54 = bitcast i1* %_V_dest_V to i8*
  call void @fpga_fifo_pop_1(i8* %53, i8* %54)
  %55 = bitcast i1* %3 to i8*
  %56 = load i8, i8* %55
  %57 = trunc i8 %56 to i1
  %58 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 6
  %59 = bitcast %"struct.ap_uint<1>"* %58 to i1*
  store i1 %57, i1* %59
  %60 = bitcast %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1 to i8*
  %61 = bitcast %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %0 to i8*
  call void @fpga_fifo_push_8(i8* %60, i8* %61)
  br label %empty, !llvm.loop !5

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"(i30* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.0" %_V_data_V, i4* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.1" %_V_keep_V, i4* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.2" %_V_strb_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.3" %_V_user_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.4" %_V_last_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.5" %_V_id_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.6" %_V_dest_V, %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* noalias "fpga.caller.interfaces"="layout_transformed") unnamed_addr #2 {
entry:
  %1 = icmp eq %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %0, null
  %2 = or i1 false, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"(i30* %_V_data_V, i4* %_V_keep_V, i4* %_V_strb_V, i1* %_V_user_V, i1* %_V_last_V, i1* %_V_id_V, i1* %_V_dest_V, %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* nonnull %0)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"(i30* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.0" %_V_data_V, i4* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.1" %_V_keep_V, i4* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.2" %_V_strb_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.3" %_V_user_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.4" %_V_last_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.5" %_V_id_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.6" %_V_dest_V, %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* noalias nocapture "fpga.caller.interfaces"="layout_transformed") unnamed_addr #3 {
entry:
  %1 = alloca %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"
  %2 = alloca %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"
  br label %empty

empty:                                            ; preds = %push, %entry
  %3 = bitcast %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %0 to i8*
  %4 = call i1 @fpga_fifo_not_empty_12(i8* %3)
  br i1 %4, label %push, label %ret

push:                                             ; preds = %empty
  %5 = bitcast %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %2 to i8*
  %6 = bitcast %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %0 to i8*
  call void @fpga_fifo_pop_12(i8* %5, i8* %6)
  %7 = load volatile %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %2
  store %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>" %7, %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1
  %8 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 0
  %9 = bitcast %"struct.ap_uint<30>"* %8 to i30*
  %10 = bitcast i30* %9 to i8*
  %11 = bitcast i30* %_V_data_V to i8*
  call void @fpga_fifo_push_4(i8* %10, i8* %11)
  %12 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 1
  %13 = bitcast %"struct.ap_uint<4>"* %12 to i4*
  %14 = bitcast i4* %13 to i8*
  %15 = bitcast i4* %_V_keep_V to i8*
  call void @fpga_fifo_push_1(i8* %14, i8* %15)
  %16 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 2
  %17 = bitcast %"struct.ap_uint<4>"* %16 to i4*
  %18 = bitcast i4* %17 to i8*
  %19 = bitcast i4* %_V_strb_V to i8*
  call void @fpga_fifo_push_1(i8* %18, i8* %19)
  %20 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 3
  %21 = bitcast %"struct.ap_uint<1>"* %20 to i1*
  %22 = bitcast i1* %21 to i8*
  %23 = bitcast i1* %_V_user_V to i8*
  call void @fpga_fifo_push_1(i8* %22, i8* %23)
  %24 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 4
  %25 = bitcast %"struct.ap_uint<1>"* %24 to i1*
  %26 = bitcast i1* %25 to i8*
  %27 = bitcast i1* %_V_last_V to i8*
  call void @fpga_fifo_push_1(i8* %26, i8* %27)
  %28 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 5
  %29 = bitcast %"struct.ap_uint<1>"* %28 to i1*
  %30 = bitcast i1* %29 to i8*
  %31 = bitcast i1* %_V_id_V to i8*
  call void @fpga_fifo_push_1(i8* %30, i8* %31)
  %32 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 6
  %33 = bitcast %"struct.ap_uint<1>"* %32 to i1*
  %34 = bitcast i1* %33 to i8*
  %35 = bitcast i1* %_V_dest_V to i8*
  call void @fpga_fifo_push_1(i8* %34, i8* %35)
  br label %empty, !llvm.loop !7

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline
define internal fastcc void @copy_out(%"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* noalias, i10* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.0" %_V_data_V, i2* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.1" %_V_keep_V, i2* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.2" %_V_strb_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.3" %_V_user_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.4" %_V_last_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.5" %_V_id_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.6" %_V_dest_V, %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* noalias, i30* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.0" %_V_data_V1, i4* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.1" %_V_keep_V2, i4* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.2" %_V_strb_V3, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.3" %_V_user_V4, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.4" %_V_last_V5, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.5" %_V_id_V6, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.6" %_V_dest_V7) unnamed_addr #4 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"(%"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %0, i10* %_V_data_V, i2* %_V_keep_V, i2* %_V_strb_V, i1* %_V_user_V, i1* %_V_last_V, i1* %_V_id_V, i1* %_V_dest_V)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>.16"(%"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i30* %_V_data_V1, i4* %_V_keep_V2, i4* %_V_strb_V3, i1* %_V_user_V4, i1* %_V_last_V5, i1* %_V_id_V6, i1* %_V_dest_V7)
  ret void
}

; Function Attrs: argmemonly noinline
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>.16"(%"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* noalias align 512 "fpga.caller.interfaces"="layout_transformed", i30* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.0" %_V_data_V, i4* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.1" %_V_keep_V, i4* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.2" %_V_strb_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.3" %_V_user_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.4" %_V_last_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.5" %_V_id_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.6" %_V_dest_V) unnamed_addr #2 {
entry:
  %1 = icmp eq %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %0, null
  %2 = or i1 %1, false
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>.19"(%"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* nonnull align 512 %0, i30* %_V_data_V, i4* %_V_keep_V, i4* %_V_strb_V, i1* %_V_user_V, i1* %_V_last_V, i1* %_V_id_V, i1* %_V_dest_V)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>.19"(%"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* noalias nocapture align 512 "fpga.caller.interfaces"="layout_transformed", i30* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.0" %_V_data_V, i4* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.1" %_V_keep_V, i4* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.2" %_V_strb_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.3" %_V_user_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.4" %_V_last_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.5" %_V_id_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.6" %_V_dest_V) unnamed_addr #3 {
entry:
  %1 = alloca %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"
  %2 = alloca i30
  %3 = alloca i4
  %4 = alloca i4
  %5 = alloca i1
  %6 = alloca i1
  %7 = alloca i1
  %8 = alloca i1
  br label %empty

empty:                                            ; preds = %push, %entry
  %9 = bitcast i30* %_V_data_V to i8*
  %10 = call i1 @fpga_fifo_not_empty_4(i8* %9)
  br i1 %10, label %push, label %ret

push:                                             ; preds = %empty
  %11 = bitcast i30* %2 to i8*
  %12 = bitcast i30* %_V_data_V to i8*
  call void @fpga_fifo_pop_4(i8* %11, i8* %12)
  %13 = bitcast i30* %2 to i32*
  %14 = load i32, i32* %13
  %15 = trunc i32 %14 to i30
  %16 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 0
  %17 = bitcast %"struct.ap_uint<30>"* %16 to i30*
  store i30 %15, i30* %17
  %18 = bitcast i4* %4 to i8*
  %19 = bitcast i4* %_V_keep_V to i8*
  call void @fpga_fifo_pop_1(i8* %18, i8* %19)
  %20 = bitcast i4* %4 to i8*
  %21 = load i8, i8* %20
  %22 = trunc i8 %21 to i4
  %23 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 1
  %24 = bitcast %"struct.ap_uint<4>"* %23 to i4*
  store i4 %22, i4* %24
  %25 = bitcast i4* %3 to i8*
  %26 = bitcast i4* %_V_strb_V to i8*
  call void @fpga_fifo_pop_1(i8* %25, i8* %26)
  %27 = bitcast i4* %3 to i8*
  %28 = load i8, i8* %27
  %29 = trunc i8 %28 to i4
  %30 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 2
  %31 = bitcast %"struct.ap_uint<4>"* %30 to i4*
  store i4 %29, i4* %31
  %32 = bitcast i1* %8 to i8*
  %33 = bitcast i1* %_V_user_V to i8*
  call void @fpga_fifo_pop_1(i8* %32, i8* %33)
  %34 = bitcast i1* %8 to i8*
  %35 = load i8, i8* %34
  %36 = trunc i8 %35 to i1
  %37 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 3
  %38 = bitcast %"struct.ap_uint<1>"* %37 to i1*
  store i1 %36, i1* %38
  %39 = bitcast i1* %7 to i8*
  %40 = bitcast i1* %_V_last_V to i8*
  call void @fpga_fifo_pop_1(i8* %39, i8* %40)
  %41 = bitcast i1* %7 to i8*
  %42 = load i8, i8* %41
  %43 = trunc i8 %42 to i1
  %44 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 4
  %45 = bitcast %"struct.ap_uint<1>"* %44 to i1*
  store i1 %43, i1* %45
  %46 = bitcast i1* %6 to i8*
  %47 = bitcast i1* %_V_id_V to i8*
  call void @fpga_fifo_pop_1(i8* %46, i8* %47)
  %48 = bitcast i1* %6 to i8*
  %49 = load i8, i8* %48
  %50 = trunc i8 %49 to i1
  %51 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 5
  %52 = bitcast %"struct.ap_uint<1>"* %51 to i1*
  store i1 %50, i1* %52
  %53 = bitcast i1* %5 to i8*
  %54 = bitcast i1* %_V_dest_V to i8*
  call void @fpga_fifo_pop_1(i8* %53, i8* %54)
  %55 = bitcast i1* %5 to i8*
  %56 = load i8, i8* %55
  %57 = trunc i8 %56 to i1
  %58 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 6
  %59 = bitcast %"struct.ap_uint<1>"* %58 to i1*
  store i1 %57, i1* %59
  %60 = bitcast %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1 to i8*
  %61 = bitcast %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %0 to i8*
  call void @fpga_fifo_push_12(i8* %60, i8* %61)
  br label %empty, !llvm.loop !7

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>.28"(i10* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.0" %_V_data_V, i2* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.1" %_V_keep_V, i2* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.2" %_V_strb_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.3" %_V_user_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.4" %_V_last_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.5" %_V_id_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.6" %_V_dest_V, %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* noalias "fpga.caller.interfaces"="layout_transformed") unnamed_addr #2 {
entry:
  %1 = icmp eq %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %0, null
  %2 = or i1 false, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>.31"(i10* %_V_data_V, i2* %_V_keep_V, i2* %_V_strb_V, i1* %_V_user_V, i1* %_V_last_V, i1* %_V_id_V, i1* %_V_dest_V, %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* nonnull %0)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>.31"(i10* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.0" %_V_data_V, i2* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.1" %_V_keep_V, i2* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.2" %_V_strb_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.3" %_V_user_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.4" %_V_last_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.5" %_V_id_V, i1* noalias nocapture "fpga.caller.interfaces"="layout_transformed" "unpacked"="0.6" %_V_dest_V, %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* noalias nocapture "fpga.caller.interfaces"="layout_transformed") unnamed_addr #3 {
entry:
  %1 = alloca %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"
  %2 = alloca %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"
  br label %empty

empty:                                            ; preds = %push, %entry
  %3 = bitcast %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %0 to i8*
  %4 = call i1 @fpga_fifo_not_empty_8(i8* %3)
  br i1 %4, label %push, label %ret

push:                                             ; preds = %empty
  %5 = bitcast %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %2 to i8*
  %6 = bitcast %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %0 to i8*
  call void @fpga_fifo_pop_8(i8* %5, i8* %6)
  %7 = load volatile %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %2
  store %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>" %7, %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1
  %8 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 0
  %9 = bitcast %"struct.ap_uint<10>"* %8 to i10*
  %10 = bitcast i10* %9 to i8*
  %11 = bitcast i10* %_V_data_V to i8*
  call void @fpga_fifo_push_2(i8* %10, i8* %11)
  %12 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 1
  %13 = bitcast %"struct.ap_uint<2>"* %12 to i2*
  %14 = bitcast i2* %13 to i8*
  %15 = bitcast i2* %_V_keep_V to i8*
  call void @fpga_fifo_push_1(i8* %14, i8* %15)
  %16 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 2
  %17 = bitcast %"struct.ap_uint<2>"* %16 to i2*
  %18 = bitcast i2* %17 to i8*
  %19 = bitcast i2* %_V_strb_V to i8*
  call void @fpga_fifo_push_1(i8* %18, i8* %19)
  %20 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 3
  %21 = bitcast %"struct.ap_uint<1>"* %20 to i1*
  %22 = bitcast i1* %21 to i8*
  %23 = bitcast i1* %_V_user_V to i8*
  call void @fpga_fifo_push_1(i8* %22, i8* %23)
  %24 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 4
  %25 = bitcast %"struct.ap_uint<1>"* %24 to i1*
  %26 = bitcast i1* %25 to i8*
  %27 = bitcast i1* %_V_last_V to i8*
  call void @fpga_fifo_push_1(i8* %26, i8* %27)
  %28 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 5
  %29 = bitcast %"struct.ap_uint<1>"* %28 to i1*
  %30 = bitcast i1* %29 to i8*
  %31 = bitcast i1* %_V_id_V to i8*
  call void @fpga_fifo_push_1(i8* %30, i8* %31)
  %32 = getelementptr inbounds %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>", %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %1, i32 0, i32 0, i32 6
  %33 = bitcast %"struct.ap_uint<1>"* %32 to i1*
  %34 = bitcast i1* %33 to i8*
  %35 = bitcast i1* %_V_dest_V to i8*
  call void @fpga_fifo_push_1(i8* %34, i8* %35)
  br label %empty, !llvm.loop !5

ret:                                              ; preds = %empty
  ret void
}

declare void @apatb_v_demosaic_hw(i16, i16, i16, i10*, i2*, i2*, i1*, i1*, i1*, i1*, i30*, i4*, i4*, i1*, i1*, i1*, i1*)

; Function Attrs: argmemonly noinline
define internal fastcc void @copy_back(%"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* noalias, i10* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.0" %_V_data_V, i2* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.1" %_V_keep_V, i2* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.2" %_V_strb_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.3" %_V_user_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.4" %_V_last_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.5" %_V_id_V, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="1.6" %_V_dest_V, %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* noalias, i30* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.0" %_V_data_V1, i4* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.1" %_V_keep_V2, i4* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.2" %_V_strb_V3, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.3" %_V_user_V4, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.4" %_V_last_V5, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.5" %_V_id_V6, i1* noalias "fpga.caller.interfaces"="layout_transformed" "unpacked"="3.6" %_V_dest_V7) unnamed_addr #4 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"(%"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %0, i10* %_V_data_V, i2* %_V_keep_V, i2* %_V_strb_V, i1* %_V_user_V, i1* %_V_last_V, i1* %_V_id_V, i1* %_V_dest_V)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>.16"(%"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %1, i30* %_V_data_V1, i4* %_V_keep_V2, i4* %_V_strb_V3, i1* %_V_user_V4, i1* %_V_last_V5, i1* %_V_id_V6, i1* %_V_dest_V7)
  ret void
}

define void @v_demosaic_hw_stub_wrapper(i16, i16, i16, i10*, i2*, i2*, i1*, i1*, i1*, i1*, i30*, i4*, i4*, i1*, i1*, i1*, i1*) #5 {
entry:
  %17 = alloca %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"
  %18 = alloca %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"
  call void @copy_out(%"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %17, i10* %3, i2* %4, i2* %5, i1* %6, i1* %7, i1* %8, i1* %9, %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %18, i30* %10, i4* %11, i4* %12, i1* %13, i1* %14, i1* %15, i1* %16)
  call void @v_demosaic_hw_stub(i16 %0, i16 %1, i16 %2, %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %17, %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %18)
  call void @copy_in(%"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"* %17, i10* %3, i2* %4, i2* %5, i1* %6, i1* %7, i1* %8, i1* %9, %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"* %18, i30* %10, i4* %11, i4* %12, i1* %13, i1* %14, i1* %15, i1* %16)
  ret void
}

declare void @v_demosaic_hw_stub(i16, i16, i16, %"class.hls::stream<hls::axis<ap_uint<10>, 1, 1, 1>, 0>"*, %"class.hls::stream<hls::axis<ap_uint<30>, 1, 1, 1>, 0>"*)

declare i1 @fpga_fifo_not_empty_8(i8*)

declare i1 @fpga_fifo_not_empty_12(i8*)

declare i1 @fpga_fifo_not_empty_4(i8*)

declare i1 @fpga_fifo_not_empty_2(i8*)

declare void @fpga_fifo_pop_8(i8*, i8*)

declare void @fpga_fifo_pop_12(i8*, i8*)

declare void @fpga_fifo_pop_4(i8*, i8*)

declare void @fpga_fifo_pop_2(i8*, i8*)

declare void @fpga_fifo_pop_1(i8*, i8*)

declare void @fpga_fifo_push_8(i8*, i8*)

declare void @fpga_fifo_push_12(i8*, i8*)

declare void @fpga_fifo_push_4(i8*, i8*)

declare void @fpga_fifo_push_2(i8*, i8*)

declare void @fpga_fifo_push_1(i8*, i8*)

attributes #0 = { noinline "fpga.wrapper.func"="wrapper" }
attributes #1 = { argmemonly noinline "fpga.wrapper.func"="copyin" }
attributes #2 = { argmemonly noinline "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #3 = { argmemonly noinline "fpga.wrapper.func"="streamcpy_hls" }
attributes #4 = { argmemonly noinline "fpga.wrapper.func"="copyout" }
attributes #5 = { "fpga.wrapper.func"="stub" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!blackbox_cfg = !{!4}

!0 = !{!"clang version 7.0.0 "}
!1 = !{i32 2, !"Dwarf Version", i32 4}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.rotate.disable"}
!7 = distinct !{!7, !6}
