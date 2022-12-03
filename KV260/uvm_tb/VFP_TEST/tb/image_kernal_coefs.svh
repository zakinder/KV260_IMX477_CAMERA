package filters_coef_pack;

    parameter kCoefDisabIndex  = 0;
    parameter kCoefYcbcrIndex  = 1;
    parameter kCoefCgainIndex  = 2;
    parameter kCoefSharpIndex  = 3;
    parameter kCoefBlureIndex  = 4;
    parameter kCoefSobeXIndex  = 5;
    parameter kCoefSobeYIndex  = 6;
    parameter kCoefEmbosIndex  = 7;
    parameter kCoefCgai1Index  = 8;
    
    parameter kCoeffYcbcr_k1   = 16'h0101;//--  0_257
    parameter kCoeffYcbcr_k2   = 16'h01F8;//--  0_504
    parameter kCoeffYcbcr_k3   = 16'h0062;//--  0_098
    parameter kCoeffYcbcr_k4   = 16'hFF6C;//-- -0_148
    parameter kCoeffYcbcr_k5   = 16'hFEDD;//-- -0_291
    parameter kCoeffYcbcr_k6   = 16'h01B7;//--  0_439
    parameter kCoeffYcbcr_k7   = 16'h01B7;//--  0_439
    parameter kCoeffYcbcr_k8   = 16'hFE90;//-- -0_368
    parameter kCoeffYcbcr_k9   = 16'hFFB9;//-- -0_071
    parameter kCoeffYcbcr_kSet = kCoefYcbcrIndex;
    
    
    parameter kCoeffCgain_k1   = 16'h05DC;//--  1375  =  1_375
    parameter kCoeffCgain_k2   = 16'hFF06;//-- -250   = -0_250
    parameter kCoeffCgain_k3   = 16'hFF06;//-- -500   = -0_500
    parameter kCoeffCgain_k4   = 16'hFF06;//-- -500   = -0_500
    parameter kCoeffCgain_k5   = 16'h05DC;//--  1375  =  1_375
    parameter kCoeffCgain_k6   = 16'hFF06;//-- -250   = -0_250
    parameter kCoeffCgain_k7   = 16'hFF06;//-- -250   = -0_250
    parameter kCoeffCgain_k8   = 16'hFF06;//-- -500   = -0_500
    parameter kCoeffCgain_k9   = 16'h05DC;//--  1375  =  1_375
    parameter kCoeffCgain_kSet = kCoefCgainIndex;
    
    
    parameter kCoeffSharp_k1   = 16'h0000;//--  0
    parameter kCoeffSharp_k2   = 16'hFE0C;//-- -0_5
    parameter kCoeffSharp_k3   = 16'h0000;//--  0
    parameter kCoeffSharp_k4   = 16'hFE0C;//-- -0_5
    parameter kCoeffSharp_k5   = 16'h0BB8;//--  3
    parameter kCoeffSharp_k6   = 16'hFE0C;//-- -0_5
    parameter kCoeffSharp_k7   = 16'h0000;//--  0
    parameter kCoeffSharp_k8   = 16'hFE0C;//-- -0_5
    parameter kCoeffSharp_k9   = 16'h0000;//--  0
    parameter kCoeffSharp_kSet = kCoefSharpIndex;
    
    
    parameter kCoeffBlure_k1   = 16'h006F;//-- 0_111
    parameter kCoeffBlure_k2   = 16'h006F;//-- 0_111
    parameter kCoeffBlure_k3   = 16'h006F;//-- 0_111
    parameter kCoeffBlure_k4   = 16'h006F;//-- 0_111
    parameter kCoeffBlure_k5   = 16'h006F;//-- 0_111
    parameter kCoeffBlure_k6   = 16'h006F;//-- 0_111
    parameter kCoeffBlure_k7   = 16'h006F;//-- 0_111
    parameter kCoeffBlure_k8   = 16'h006F;//-- 0_111
    parameter kCoeffBlure_k9   = 16'h006F;//-- 0_111
    parameter kCoeffBlure_kSet = kCoefBlureIndex;
    
    
    parameter kCoefXSobel_k1   = 16'hFC18;//--  [-1]
    parameter kCoefXSobel_k2   = 16'h0000;//--  [+0]
    parameter kCoefXSobel_k3   = 16'h03E8;//--  [+1]
    parameter kCoefXSobel_k4   = 16'hF830;//--  [-2]
    parameter kCoefXSobel_k5   = 16'h0000;//--  [+0]
    parameter kCoefXSobel_k6   = 16'h07D0;//--  [+2]
    parameter kCoefXSobel_k7   = 16'hFC18;//--  [-1]
    parameter kCoefXSobel_k8   = 16'h0000;//--  [+0]
    parameter kCoefXSobel_k9   = 16'h03E8;//--  [+1]
    parameter kCoefXSobel_kSet = kCoefSobeXIndex;
    
    
    parameter kCoefYSobel_k1   = 16'h03E8;//--  [+1]
    parameter kCoefYSobel_k2   = 16'h07D0;//--  [+2]
    parameter kCoefYSobel_k3   = 16'h03E8;//--  [+1]
    parameter kCoefYSobel_k4   = 16'h0000;//--  [+0]
    parameter kCoefYSobel_k5   = 16'h0000;//--  [+0]
    parameter kCoefYSobel_k6   = 16'h0000;//--  [+0]
    parameter kCoefYSobel_k7   = 16'hFC18;//--  [-1]
    parameter kCoefYSobel_k8   = 16'hF830;//--  [-2]
    parameter kCoefYSobel_k9   = 16'hFC18;//--  [-1]
    parameter kCoefYSobel_kSet = kCoefSobeYIndex;
    
    
    parameter kCoeffEmbos_k1   = 16'hFC18;//-- -1
    parameter kCoeffEmbos_k2   = 16'hFC18;//-- -1
    parameter kCoeffEmbos_k3   = 16'h0000;//--  0
    parameter kCoeffEmbos_k4   = 16'hFC18;//-- -1
    parameter kCoeffEmbos_k5   = 16'h0000;//--  0
    parameter kCoeffEmbos_k6   = 16'h03E8;//--  1
    parameter kCoeffEmbos_k7   = 16'h0000;//--  0
    parameter kCoeffEmbos_k8   = 16'h03E8;//--  1
    parameter kCoeffEmbos_k9   = 16'h03E8;//--  1
    parameter kCoeffEmbos_kSet = kCoefEmbosIndex;
    
    
    parameter kCoef1Cgain_k1   = 16'h055F;//--  1375  =  1_375
    parameter kCoef1Cgain_k2   = 16'hFF83;//-- -125   = -0_125
    parameter kCoef1Cgain_k3   = 16'hFF06;//-- -250   = -0_250
    parameter kCoef1Cgain_k4   = 16'hFF06;//-- -250   = -0_250
    parameter kCoef1Cgain_k5   = 16'h055F;//--  1375  =  1_375
    parameter kCoef1Cgain_k6   = 16'hFF83;//-- -125   = -0_125
    parameter kCoef1Cgain_k7   = 16'hFF83;//-- -125   = -0_125
    parameter kCoef1Cgain_k8   = 16'hFF06;//-- -250   = -0_250
    parameter kCoef1Cgain_k9   = 16'h055F;//--  1375  =  1_375
    parameter kCoef1Cgain_kSet = kCoefCgai1Index;

endpackage