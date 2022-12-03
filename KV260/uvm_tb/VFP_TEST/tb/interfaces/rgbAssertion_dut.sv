// MODULE : ADDER [TEMPLATE]
module rgbAssertionDut(d5m_camera_if.ConfigMaster d5m_camera_vif);

rgbAssertion rgb_dut   (
   .pixclk             (d5m_camera_vif.clkmm),
   .mmclk              (d5m_camera_vif.clkmm),
   .reset              (d5m_camera_vif.reset),
   .valid              (d5m_camera_vif.d5m.valid),
   .iRed               (d5m_camera_vif.d5m.red),
   .iGreen             (d5m_camera_vif.d5m.green),
   .iBlue              (d5m_camera_vif.d5m.blue),
   .m_axis_mm2s_tvalid (d5m_camera_vif.m_axis_mm2s_tvalid),
   .m_axis_mm2s_tdata  (d5m_camera_vif.m_axis_mm2s_tdata));
endmodule: rgbAssertionDut